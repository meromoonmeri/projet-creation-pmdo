"""Automatic build report (JSON + Markdown)."""
from __future__ import annotations

import json
from dataclasses import asdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence

from .definitions import DungeonDefinition
from .grounds import GroundCheck
from .validation import FloorValidation, aggregate

ROOT = Path(__file__).resolve().parents[2]
REPORT_DIR = ROOT / "docs" / "dungeon_builder" / "reports"


def build_report(definition: DungeonDefinition, export, validations: Sequence[FloorValidation],
                 grounds: GroundCheck, rng_info: Dict[str, Any]) -> Dict[str, Any]:
    per_floor = []
    for validation in validations:
        metrics = [v.metrics for v in validation.accepted() if v.metrics]
        plan = next((f for f in export.floors if f.floor == validation.floor), None)
        per_floor.append({
            "floor": validation.floor,
            "segment": plan.segment if plan else "",
            "kind": plan.kind if plan else "",
            "profile": plan.profile if plan else validation.profile,
            "grid": list(plan.grid) if plan else [],
            "cell": list(plan.cell) if plan else [],
            "dtef": plan.dtef if plan else "",
            "weather": list(plan.weather) if plan else [],
            "map_id": plan.map_id if plan else "",
            "variants_ok": len(metrics),
            "variants_rejected": validation.rejected,
            "max_pair_similarity": validation.max_pair_similarity,
            "seeds": [v.seed for v in validation.accepted()],
            "metrics": aggregate(metrics),
            "traversable": all(m.stairs_reachable for m in metrics) if metrics else False,
            "notes": validation.notes,
        })

    segments = []
    for segment in definition.segments:
        features = definition.features_for(segment)
        segments.append({
            "name": segment.name, "floors": list(segment.floors), "biome": segment.biome,
            "dtef": definition.dtef_for(segment),
            "profiles": [p.name for p in definition.profiles_for(segment)],
            "pokemon": len(definition.mobs_for(segment)),
            "item_tables": {t.name: {"amount": list(t.amount), "entries": len(t.entries)}
                            for t in definition.items_for(segment)},
            "shop": bool((features.shop or {}).get("enabled")),
            "monster_house": bool((features.monster_house or {}).get("enabled")),
            "treasure_room": bool((features.treasure_room or {}).get("enabled")),
            "key_room": bool((features.key_room or {}).get("enabled")),
            "mystery": bool((features.mystery or {}).get("enabled")),
            "weather": features.weather,
        })

    return {
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "dungeon": definition.id,
        "name": definition.name,
        "chapter": definition.chapter,
        "route": definition.route,
        "source": definition.source,
        "provenance": definition.provenance,
        "floors": definition.floors,
        "biome": definition.biome,
        "direction": definition.variation.get("direction", ""),
        "zone_file": str(export.zone_path.relative_to(ROOT)) if export.zone_path else "",
        "segments": segments,
        "fixed_grounds": definition.fixed_grounds,
        "midpoint": definition.midpoint,
        "boss": definition.boss,
        "minibosses": definition.minibosses,
        "ground_check": grounds.to_dict(),
        "rng": rng_info,
        "warnings": export.warnings,
        "floor_reports": per_floor,
    }


def to_markdown(report: Dict[str, Any]) -> str:
    lines = [f"# Rapport de génération — {report['name'].get('en', report['dungeon'])}", ""]
    lines.append(f"- **ID** : `{report['dungeon']}`  ")
    lines.append(f"- **Chapitre** : {report['chapter']} ({report['route']})  ")
    lines.append(f"- **Source canonique** : {report['source']}  ")
    lines.append(f"- **Étages** : {report['floors']} — direction `{report['direction'] or 'n/a'}`  ")
    lines.append(f"- **Zone écrite** : `{report['zone_file']}`  ")
    status = (report.get("provenance") or {}).get("status", {})
    lines.append(f"- **Gate canonique** : configuration `{status.get('configuration', 'missing')}`, "
                 f"runtime `{status.get('runtime', 'missing')}`  ")
    lines.append("- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; "
                 "aucune seed de production n'est écrite dans la zone.  ")
    lines.append("")
    lines.append("## Segments")
    lines.append("")
    lines.append("| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |")
    lines.append("|---|---|---|---|---|---|---|---|---|")
    for seg in report["segments"]:
        dtef = seg["dtef"].get("package") or seg["dtef"].get("floor", "")
        weather = ", ".join(w.get("status", "") for w in seg["weather"]) or "—"
        lines.append(f"| {seg['name']} | {seg['floors'][0]}-{seg['floors'][1]} | {seg['biome']} | "
                     f"`{dtef}` | {', '.join(seg['profiles'])} | {seg['pokemon']} | "
                     f"{'oui' if seg['shop'] else 'non'} | {'oui' if seg['monster_house'] else 'non'} | {weather} |")
    lines.append("")
    lines.append("## Scènes fixes")
    lines.append("")
    check = report["ground_check"]
    lines.append(f"- entrée : `{check['entrance'] or '—'}`")
    lines.append(f"- midpoint : `{check['mid'] or '—'}`")
    lines.append(f"- Ground de fin : `{check['end'] or '—'}`")
    lines.append(f"- boss : mode `{check['boss_mode']}` → Ground `{check['boss_ground'] or '—'}`, "
                 f"rsmap `{check['boss_map'] or '—'}`")
    for note in check.get("notes", []):
        lines.append(f"  - {note}")
    for problem in check.get("problems", []):
        lines.append(f"  - ⚠ {problem}")
    lines.append("")
    lines.append("## Étages")
    lines.append("")
    lines.append("| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | "
                 "Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | "
                 "Signatures | Traversable |")
    lines.append("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
    for floor in report["floor_reports"]:
        m = floor["metrics"] or {}
        grid = "x".join(str(v) for v in floor["grid"]) or "—"
        cell = "x".join(str(v) for v in floor["cell"]) or "—"
        rooms = (f"{m.get('rooms_min', '—')}/{m.get('rooms_avg', '—')}/{m.get('rooms_max', '—')}"
                 if m else "—")
        lines.append(
            f"| {floor['floor']} | {floor['segment']} | {floor['kind']} | {floor['profile']} | {grid} | {cell} | "
            f"{floor['variants_ok']} | {floor['variants_rejected']} | {rooms} | {m.get('halls_avg', '—')} | "
            f"{m.get('branches_avg', '—')} | {m.get('dead_ends_avg', '—')} | {m.get('loops_avg', '—')} | "
            f"{m.get('stair_distance_avg', '—')} | {m.get('distinct_signatures', '—')} | "
            f"{'oui' if floor['traversable'] else 'non'} |")
    if report["warnings"]:
        lines.append("")
        lines.append("## Avertissements")
        for warning in report["warnings"]:
            lines.append(f"- {warning}")
    lines.append("")
    return "\n".join(lines)


def write_report(report: Dict[str, Any], folder: Optional[Path] = None) -> List[Path]:
    folder = Path(folder or REPORT_DIR)
    folder.mkdir(parents=True, exist_ok=True)
    json_path = folder / f"{report['dungeon']}.json"
    md_path = folder / f"{report['dungeon']}.md"
    json_path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    md_path.write_text(to_markdown(report), encoding="utf-8")
    return [json_path, md_path]
