"""Fail-closed canonical/provenance gate for production generation.

The older readiness audit proves that JSON references resolve.  It does *not*
prove that ROM data, DTEF ownership, fixed/event floors, or feature mappings are
canonical.  This stricter gate prevents those weaker checks from authorizing a
production write or a batch build.
"""
from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable, Sequence

from .definitions import list_definitions

ROOT = Path(__file__).resolve().parents[2]
DOC_DIR = ROOT / "docs" / "dungeon_builder"

ALLOWED_KINDS = {
    "PMD_RED_ROM",
    "PMD_SKY_ROM",
    "PMD_RED_RESERVED_GROUND",
    "PMD_SKY_RESERVED_GROUND",
    "RAW_ASSETS",
    "PMDO_RUNTIME",
    "ROGUEELEMENTS_SOURCE",
    "ROGUEESSENCE_SOURCE",
    "PMDC_SOURCE",
    "BULBAPEDIA",
    "PROJECT_DATA",
    "INFERRED",
    "SUPPLEMENTAL",
}
REQUIRED_CATEGORIES = (
    "floor_parameters",
    "pokemon",
    "items",
    "tileset",
    "grounds",
    "scenes",
)


@dataclass
class CanonicalGateResult:
    file: str
    dungeon: str
    game: str = ""
    config_state: str = "missing"
    runtime_state: str = "missing"
    batch_approved: bool = False
    blockers: list[str] = field(default_factory=list)
    notes: list[str] = field(default_factory=list)

    @property
    def config_ready(self) -> bool:
        return not self.blockers and self.config_state == "validated"

    @property
    def runtime_ready(self) -> bool:
        return self.config_ready and self.runtime_state == "validated"


def _refs(value: object) -> list[dict]:
    if isinstance(value, dict):
        return [value]
    if isinstance(value, list):
        return [item for item in value if isinstance(item, dict)]
    return []


def inspect(path: Path) -> CanonicalGateResult:
    try:
        raw = json.loads(path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError) as exc:
        return CanonicalGateResult(path.name, path.stem, blockers=[f"INVALID_JSON: {exc}"])

    result = CanonicalGateResult(path.name, str(raw.get("id") or path.stem))
    provenance = raw.get("provenance")
    if not isinstance(provenance, dict):
        result.blockers.append("MISSING_PROVENANCE: top-level provenance object")
        provenance = {}

    result.game = str(provenance.get("game") or "")
    if result.game not in {"PMD_RED", "PMD_SKY", "MIXED", "ORIGINAL"}:
        result.blockers.append(f"INVALID_GAME: {result.game!r}")

    status = provenance.get("status") or {}
    result.config_state = str(status.get("configuration") or "missing")
    result.runtime_state = str(status.get("runtime") or "missing")
    result.batch_approved = bool(status.get("batch_approved", False))
    if result.config_state != "validated":
        result.blockers.append(
            f"CONFIG_NOT_VALIDATED: provenance.status.configuration={result.config_state!r}")

    categories = provenance.get("categories") or {}
    for category in REQUIRED_CATEGORIES:
        refs = _refs(categories.get(category))
        if not refs:
            result.blockers.append(f"MISSING_PROVENANCE_CATEGORY: {category}")
            continue
        for ref in refs:
            kind = str(ref.get("kind") or "")
            if kind not in ALLOWED_KINDS:
                result.blockers.append(f"INVALID_PROVENANCE_KIND: {category}:{kind!r}")
            if not (ref.get("path") or ref.get("url") or ref.get("evidence")):
                result.blockers.append(f"UNTRACEABLE_PROVENANCE: {category}:{kind}")
            if kind in {"INFERRED", "SUPPLEMENTAL"} and not ref.get("reason"):
                result.blockers.append(f"UNDOCUMENTED_ADAPTATION: {category}:{kind}")

    # Cross-check a machine-readable PMD Red manifest when one is declared.
    floor_refs = _refs(categories.get("floor_parameters"))
    red_manifest = next((ref for ref in floor_refs
                         if ref.get("kind") == "PMD_RED_ROM"
                         and str(ref.get("path", "")).endswith("_rom_manifest.json")), None)
    if red_manifest:
        manifest_path = ROOT / str(red_manifest["path"])
        if not manifest_path.is_file():
            result.blockers.append(f"MISSING_ROM_MANIFEST: {red_manifest['path']}")
        else:
            try:
                manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
                mode = red_manifest.get("definition_floor_mode", "all")
                expected_floors = (len(manifest.get("procedural_floors", []))
                                   if mode == "procedural_only" else
                                   int(manifest.get("floor_count", 0)))
                if int(raw.get("floors", 0)) != expected_floors:
                    result.blockers.append(
                        f"ROM_FLOOR_COUNT_MISMATCH: definition={raw.get('floors')} "
                        f"expected={expected_floors} mode={mode}")

                procedural = set(manifest.get("procedural_floors", []))
                canonical_species = {
                    str(entry.get("species", "")).removeprefix("MONSTER_").lower()
                    for floor in manifest.get("floors", []) if floor.get("floor") in procedural
                    for entry in floor.get("pokemon", []) if int(entry.get("probability", 0)) > 0
                }
                defined_species = {
                    str(entry.get("species", "")) for entry in raw.get("pokemon", [])
                }
                for segment in raw.get("segments", []):
                    defined_species.update(str(entry.get("species", ""))
                                           for entry in segment.get("pokemon", []))
                missing_species = sorted(canonical_species - defined_species)
                extra_species = sorted(defined_species - canonical_species)
                if missing_species:
                    result.blockers.append(
                        "ROM_POKEMON_MISSING: " + ", ".join(missing_species))
                if extra_species:
                    result.blockers.append(
                        "SUPPLEMENTAL_POKEMON_NOT_SEPARATED: " + ", ".join(extra_species))

                params = [floor.get("floor_properties", {}) for floor in manifest.get("floors", [])
                          if floor.get("floor") in procedural]
                features_raw = raw.get("features") or {}
                if (features_raw.get("shop") or {}).get("enabled") and not any(
                        int(row.get("kecleonShopChance", 0)) > 0 for row in params):
                    result.blockers.append("ROM_FEATURE_CONFLICT: Kecleon shop chance is zero")
                if (features_raw.get("monster_house") or {}).get("enabled") and not any(
                        int(row.get("monsterHouseChance", 0)) > 0 for row in params):
                    result.blockers.append("ROM_FEATURE_CONFLICT: Monster House chance is zero")
                if features_raw.get("weather") and not any(
                        int(row.get("weather", 0)) > 0 for row in params):
                    result.blockers.append("ROM_FEATURE_CONFLICT: weather is clear on all source floors")
            except (OSError, ValueError, TypeError, json.JSONDecodeError) as exc:
                result.blockers.append(f"INVALID_ROM_MANIFEST: {exc}")

    for fixed_index, fixed_segment in enumerate(raw.get("fixed_segments", [])):
        map_id = str(fixed_segment.get("map") or "")
        ground_id = str(fixed_segment.get("ground") or "")
        if not map_id or not (ROOT / "Data" / "Map" / f"{map_id}.rsmap").is_file():
            result.blockers.append(
                f"MISSING_FIXED_SEGMENT_MAP: fixed_segments[{fixed_index}] {map_id!r}")
        if ground_id and not (ROOT / "Data" / "Ground" / f"{ground_id}.rsground").is_file():
            result.blockers.append(
                f"MISSING_CANONICAL_GROUND: fixed_segments[{fixed_index}] {ground_id!r}")

    features = raw.get("features") or {}
    traps = features.get("traps") or {}
    if traps.get("enabled") and not traps.get("entries"):
        result.blockers.append(
            "UNMAPPED_NATIVE_FEATURE: traps enabled but no ROM trap -> PMDO TileSpawn mapping")
    mystery = features.get("mystery") or {}
    if mystery.get("enabled") and not mystery.get("runtime"):
        result.blockers.append(
            "UNMAPPED_NATIVE_FEATURE: mystery enabled but no native runtime configuration")

    # A free-text source is useful documentation, but is never accepted as a
    # substitute for category-level machine-readable provenance.
    if not raw.get("source"):
        result.blockers.append("MISSING_SOURCE_DESCRIPTION")
    return result


def inspect_all(paths: Iterable[Path] | None = None) -> list[CanonicalGateResult]:
    return [inspect(path) for path in (paths or list_definitions())]


def assert_generation_ready(path: Path) -> CanonicalGateResult:
    result = inspect(path)
    if not result.config_ready:
        details = "; ".join(result.blockers)
        raise ValueError(f"canonical gate blocked {result.dungeon}: {details}")
    return result


def assert_batch_ready(paths: Sequence[Path] | None = None) -> list[CanonicalGateResult]:
    results = inspect_all(paths)
    blocked = [result for result in results if not result.runtime_ready or not result.batch_approved]
    if blocked:
        preview = "; ".join(
            f"{result.dungeon} ({', '.join(result.blockers[:2]) or 'runtime/batch approval missing'})"
            for result in blocked[:8]
        )
        raise ValueError(
            f"canonical batch gate blocked {len(blocked)}/{len(results)} definitions: {preview}")
    return results


def markdown(results: Sequence[CanonicalGateResult]) -> str:
    config_ready = sum(result.config_ready for result in results)
    runtime_ready = sum(result.runtime_ready for result in results)
    batch_ready = sum(result.runtime_ready and result.batch_approved for result in results)
    lines = [
        "# Canonical production gate",
        "",
        "Ce gate est volontairement plus strict que `audit-all` : une référence JSON qui",
        "se charge n'est pas une preuve de fidélité ROM ni une validation runtime.",
        "",
        f"- définitions : **{len(results)}**",
        f"- configuration canonique validée : **{config_ready}**",
        f"- runtime validé : **{runtime_ready}**",
        f"- autorisées en batch : **{batch_ready}**",
        "",
        "| Donjon | Jeu | Config | Runtime | Batch | Blocages |",
        "|---|---|---|---|---:|---|",
    ]
    for result in results:
        blockers = "<br>".join(result.blockers) or "—"
        lines.append(
            f"| `{result.dungeon}` | {result.game or '—'} | {result.config_state} | "
            f"{result.runtime_state} | {'oui' if result.batch_approved else 'non'} | {blockers} |"
        )
    lines += [
        "",
        "`generate` exige une configuration canonique validée. `generate-all` exige en plus",
        "une preuve runtime et `batch_approved=true` pour chaque définition sélectionnée.",
        "",
    ]
    return "\n".join(lines)


def write_report(results: Sequence[CanonicalGateResult], path: Path | None = None) -> Path:
    target = path or DOC_DIR / "CANONICAL_PRODUCTION_GATE.md"
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(markdown(results), encoding="utf-8")
    return target
