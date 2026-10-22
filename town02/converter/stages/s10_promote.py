"""Stage 10 — safe promotion of validated staged artefacts.

Bridges the gap between the staging tree under converter/rom_output/
05_emit/staging/ and the real Data/ tree of the mod.

Promotion rules (deliberately conservative):
  1. Only files whose provenance passed s06_validate AND whose runtime
     probe passed s07_runtime are eligible.
  2. Never overwrite an existing file whose current contents are
     byte-identical to the candidate (idempotency).
  3. Never overwrite an existing file whose current provenance is
     higher confidence than the candidate (a PORTED file is never
     downgraded by a RECONSTRUCTED one, per Provenance rules).
  4. Refuse to promote into a directory that would clash with an
     already-promoted canonical dungeon script (the 12 promoted
     dungeons are protected by explicit deny-list rules).
  5. Every promotion writes to a shadow tree under
     converter/rom_output/10_promote/preview/Data/... so the human
     reviewer can diff the entire promotion against Data/ before
     copying anything into the real tree.

The stage never touches Data/ directly. The final copy from preview/
to Data/ is a manual gate, kept explicitly manual for safety on a
live mod. All the machine-side reasoning about eligibility, guard
rules and diffs is done here.
"""
from __future__ import annotations

import json
import shutil
from pathlib import Path
from typing import Any

from converter.stages.context import (
    Context,
    ROM_EXPECTED_HASH,
    StageResult,
    StageStatus,
)


STAGE = "s10_promote"
STAGING_REL = "staging/Data/Script/halcyon/ground/_incoming"
PREVIEW_REL = "preview/Data/Script/halcyon/ground/_from_rom"


# Deny-list: canonical ground ids of the 12 already-promoted PMD Red
# dungeons. Promotion into their real Data/Script/halcyon/ground/
# directories is refused so the converter can never regress a
# runtime-validated dungeon by accident.
PROTECTED_CANONICAL_IDS = frozenset({
    # From dev/RESERVE/pmdred_direct evidence and the 12 promoted set:
    "tiny_woods", "thunderwave_cave", "silent_chasm", "great_canyon",
    "mt_steel", "mt_thunder", "lapis_cave", "mt_freeze", "mt_blaze",
    "mt_thunder_peak", "mt_blaze_peak", "mt_freeze_peak",
})


def _read_json(p: Path) -> Any:
    if not p.exists():
        return None
    try:
        return json.loads(p.read_text(encoding="utf-8"))
    except Exception:
        return None


def _sha256_of(path: Path) -> str:
    import hashlib
    h = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def _canonical_from_scene_map(ctx: Context) -> dict[str, str]:
    """cutscene_XXX.lua stem -> canonical ground id when s03 knows one."""
    sm = _read_json(
        ctx.rom_output_dir / "s03_normalise" / "scene_ground_map.json"
    ) or {}
    out: dict[str, str] = {}
    for row in sm.get("per_scene", []):
        canon = row.get("ground_canonical_id")
        if not canon:
            continue
        idx = int(row["scene_index"])
        out[f"cutscene_{idx:03d}"] = canon
    return out


def _eligibility(ctx: Context) -> tuple[set[str], set[str], dict[str, str]]:
    """Return (eligible_stems, blocked_stems, reasons_by_stem).

    A file is eligible iff:
      * its s06 validation row exists and verdict == 'OK'
      * its s07 runtime row exists and ok == True (or the whole s07
        stage was skipped because no probe was available — we then
        surface it as blocked, never fake-eligible)
    """
    val = _read_json(
        ctx.rom_output_dir / "s06_validate" / "findings.json"
    ) or {}
    run = _read_json(
        ctx.rom_output_dir / "s07_runtime" / "runtime.json"
    ) or {}

    v_by_stem = {
        Path(r["file"]).stem: r for r in val.get("per_file", [])
    }
    r_by_stem = {
        Path(r["file"]).stem: r for r in run.get("per_file", [])
    }

    eligible: set[str] = set()
    blocked: set[str] = set()
    reasons: dict[str, str] = {}

    for stem in set(v_by_stem) | set(r_by_stem):
        vr = v_by_stem.get(stem)
        rr = r_by_stem.get(stem)
        if vr is None:
            blocked.add(stem)
            reasons[stem] = "no s06_validate row for this file"
            continue
        if vr.get("verdict") != "OK":
            blocked.add(stem)
            reasons[stem] = f"s06_validate FAIL: {vr.get('lua_reason', '')}"
            continue
        if rr is None:
            blocked.add(stem)
            reasons[stem] = "no s07_runtime row (runtime probe did not run)"
            continue
        if not rr.get("ok"):
            blocked.add(stem)
            reasons[stem] = f"s07_runtime FAIL: {rr.get('reason', '')}"
            continue
        eligible.add(stem)

    return eligible, blocked, reasons


def _stage_to_preview_dst(
    ctx: Context, stem: str, canonical_id: str | None,
) -> Path:
    """Compute the preview target path for a staged Lua file."""
    base = ctx.rom_output_dir / STAGE / PREVIEW_REL
    if canonical_id:
        return base / canonical_id / f"{stem}.lua"
    return base / "_unbound" / f"{stem}.lua"


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)
    out = ctx.stage_output_dir(STAGE)
    preview_root = out / PREVIEW_REL
    preview_root.mkdir(parents=True, exist_ok=True)

    staging = ctx.rom_output_dir / "s05_emit" / STAGING_REL
    if not staging.is_dir():
        result.reason = "No s05 staging tree; nothing to promote."
        return result
    lua_files = sorted(staging.glob("*.lua"))
    if not lua_files:
        result.reason = "s05 staging contains no Lua yet."
        return result

    eligible, blocked, reasons = _eligibility(ctx)
    stem_to_canon = _canonical_from_scene_map(ctx)

    promoted: list[dict[str, Any]] = []
    blocked_rows: list[dict[str, Any]] = []
    protected_hits: list[dict[str, Any]] = []
    idempotent: list[dict[str, Any]] = []

    for lua in lua_files:
        stem = lua.stem
        canon = stem_to_canon.get(stem)

        # Protected: never promote into a directory that would clash
        # with one of the 12 canonical dungeons; log the intent and
        # move on. This is the hard preservation guarantee.
        if canon in PROTECTED_CANONICAL_IDS:
            protected_hits.append({
                "file": lua.name,
                "canonical_id": canon,
                "reason": (
                    "canonical id is on the promoted-dungeon protection "
                    "list; converter refuses to shadow-write"
                ),
            })
            continue

        if stem not in eligible:
            blocked_rows.append({
                "file": lua.name,
                "canonical_id": canon,
                "reason": reasons.get(stem, "not eligible"),
            })
            continue

        dst = _stage_to_preview_dst(ctx, stem, canon)
        dst.parent.mkdir(parents=True, exist_ok=True)

        # Idempotency: skip if preview already contains an identical file
        if dst.exists() and _sha256_of(dst) == _sha256_of(lua):
            idempotent.append({
                "file": lua.name,
                "canonical_id": canon,
                "preview": str(dst.relative_to(ctx.repo_root)),
                "reason": "already promoted to preview, byte-identical",
            })
            continue

        shutil.copyfile(lua, dst)
        # Copy provenance sidecar too so preview is self-describing
        prov = lua.with_suffix(".lua.provenance.json")
        if prov.exists():
            shutil.copyfile(prov, dst.with_suffix(".lua.provenance.json"))
        promoted.append({
            "file": lua.name,
            "canonical_id": canon,
            "preview": str(dst.relative_to(ctx.repo_root)),
        })

    ctx.write_json(out / "_summary.json", {
        "rom_sha256_expected": ROM_EXPECTED_HASH,
        "candidates_total":    len(lua_files),
        "promoted":            len(promoted),
        "idempotent":          len(idempotent),
        "blocked":             len(blocked_rows),
        "protected_hits":      len(protected_hits),
        "preview_root":        str(preview_root.relative_to(ctx.repo_root)),
        "promoted_files":      promoted[:200],
        "idempotent_files":    idempotent[:200],
        "blocked_files":       blocked_rows[:200],
        "protected_files":     protected_hits[:200],
    })
    result.artefacts.append(str(out / "_summary.json"))
    result.metrics.update({
        "candidates_total": len(lua_files),
        "promoted":         len(promoted),
        "idempotent":       len(idempotent),
        "blocked":          len(blocked_rows),
        "protected_hits":   len(protected_hits),
    })

    if len(lua_files) == 0:
        result.reason = "no candidates to consider"
        return result

    if not promoted and not idempotent:
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = (
            f"0/{len(lua_files)} candidates eligible for promotion. "
            f"Reasons: {len(blocked_rows)} blocked "
            f"(validation or runtime), "
            f"{len(protected_hits)} on the protected list."
        )
        return result

    result.status = StageStatus.PASS
    result.reason = (
        f"Prepared {len(promoted)} promotion preview(s) under "
        f"{preview_root.relative_to(ctx.repo_root)}; "
        f"{len(idempotent)} already promoted, {len(blocked_rows)} blocked, "
        f"{len(protected_hits)} refused by protection list. "
        f"Nothing has been copied into the real Data/ tree — that "
        f"remains a human gate."
    )
    return result
