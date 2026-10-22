"""Isolated RogueElements prototype.

Generates dozens of floors across every architecture profile with fresh seeds,
measures each one and writes a Markdown report with sample layouts.  It touches
no canonical dungeon: it only reads profile definitions and prints numbers.

    python3 tools/dungeon_builder.py prototype --per-profile 6 --report
"""
from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Tuple

from .profiles import BUILTIN_PROFILES, ArchitectureProfile
from .re_sim.pipeline import FloorMetrics, FloorResult, measure, similarity
from .rng import DungeonRng
from .validation import Thresholds, check_layout

ROOT = Path(__file__).resolve().parents[2]
DOC_DIR = ROOT / "docs" / "dungeon_builder"


def run_prototype(per_profile: int = 6, seed: Optional[int] = None,
                  thresholds: Optional[Thresholds] = None
                  ) -> Tuple[Dict[str, List[FloorMetrics]], Dict[str, List[FloorResult]], DungeonRng, Dict[str, int]]:
    thresholds = thresholds or Thresholds()
    rng = DungeonRng(seed=seed, label="prototype")
    metrics: Dict[str, List[FloorMetrics]] = {}
    samples: Dict[str, List[FloorResult]] = {}
    rejects: Dict[str, int] = {}
    for name, profile in BUILTIN_PROFILES.items():
        metrics[name] = []
        samples[name] = []
        rejects[name] = 0
        attempts = 0
        while len(metrics[name]) < per_profile and attempts < per_profile * 6:
            attempts += 1
            result = profile.simulate(rng.next_seed())
            m, problems = check_layout(result, thresholds)
            if problems:
                rejects[name] += 1
                continue
            metrics[name].append(m)
            if len(samples[name]) < 2:
                samples[name].append(result)
    return metrics, samples, rng, rejects


def _avg(values: Sequence[float]) -> float:
    return round(sum(values) / len(values), 2) if values else 0.0


def markdown(metrics, samples, rng, rejects) -> str:
    total = sum(len(v) for v in metrics.values())
    lines = ["# Prototype RogueElements — mesures réelles", "",
             f"_Généré le {datetime.now(timezone.utc).isoformat(timespec='seconds')} — "
             f"{total} étages acceptés, seed racine de debug `{rng.seed}`._", "",
             "Aucun donjon canonique n'est touché par ce prototype : il exécute les mêmes "
             "algorithmes que les steps RogueElements configurés par les profils "
             "(`GridPathBranch`, `GridPathCircle`, `GridPathGrid`, `GridPathTwoSides`, "
             "`GridPathCross`, `ConnectGridBranchStep`, `SetGridDefaultsStep`, "
             "`CombineGridRoomStep`, `DrawGridToFloorStep`, `FloorStairsStep`) et mesure la "
             "topologie obtenue.", "",
             "## Synthèse par profil", "",
             "| Profil | Étages | Rejets | Rooms min/moy/max | Halls | Connexions | Branches | "
             "Culs-de-sac | Boucles | Aire salle min/max | Dist. escaliers | Traversables | "
             "Signatures distinctes |",
             "|---|---|---|---|---|---|---|---|---|---|---|---|---|"]
    for name, values in metrics.items():
        if not values:
            lines.append(f"| {name} | 0 | {rejects[name]} | — | — | — | — | — | — | — | — | — | — |")
            continue
        lines.append(
            f"| `{name}` | {len(values)} | {rejects[name]} | "
            f"{min(m.rooms for m in values)}/{_avg([m.rooms for m in values])}/{max(m.rooms for m in values)} | "
            f"{_avg([m.halls for m in values])} | {_avg([m.connections for m in values])} | "
            f"{_avg([m.branches for m in values])} | {_avg([m.dead_ends for m in values])} | "
            f"{_avg([m.loops for m in values])} | "
            f"{min(m.room_area_min for m in values)}/{max(m.room_area_max for m in values)} | "
            f"{_avg([m.stair_distance for m in values])} | "
            f"{sum(1 for m in values if m.stairs_reachable)}/{len(values)} | "
            f"{len({m.signature for m in values})}/{len(values)} |")

    lines += ["", "## Variation structurelle intra-profil", "",
              "| Profil | Similarité max entre deux générations | Signatures identiques |",
              "|---|---|---|"]
    for name, values in metrics.items():
        worst = 0.0
        clones = 0
        for i, a in enumerate(values):
            for b in values[i + 1:]:
                score = similarity(a, b)
                worst = max(worst, score)
                if a.signature == b.signature:
                    clones += 1
        lines.append(f"| `{name}` | {round(worst, 4)} | {clones} |")

    lines += ["", "## Exemples de layouts", "",
              "`.` salle, `,` couloir, `#` mur, `E` entrée, `X` escalier.", ""]
    for name, results in samples.items():
        for result in results[:1]:
            m = measure(result)
            lines += [f"### `{name}` — seed `{result.seed}`", "",
                      f"rooms={m.rooms} halls={m.halls} connexions={m.connections} "
                      f"branches={m.branches} culs-de-sac={m.dead_ends} boucles={m.loops} "
                      f"taille={m.width}x{m.height} distance entrée/escalier={m.stair_distance} "
                      f"accessibilité={m.reachable_ratio}", "", "```", result.ascii_art(), "```", ""]
    return "\n".join(lines)


def write_prototype_report(per_profile: int = 6, seed: Optional[int] = None) -> Path:
    metrics, samples, rng, rejects = run_prototype(per_profile, seed)
    DOC_DIR.mkdir(parents=True, exist_ok=True)
    path = DOC_DIR / "PROTOTYPE_METRICS.md"
    path.write_text(markdown(metrics, samples, rng, rejects), encoding="utf-8")
    return path
