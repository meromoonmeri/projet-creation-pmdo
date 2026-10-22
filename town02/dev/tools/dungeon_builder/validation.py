"""Validation layer: fairplay, traversability and structural non-repetition.

A candidate layout is simulated with the profile's real RogueElements
parameters; whatever fails is rejected and regenerated with a new seed (and,
after a few tries, with another profile).  The same thresholds are what the
`preview` and `generate` commands report.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, List, Optional, Sequence, Tuple

from .profiles import ArchitectureProfile
from .re_sim.pipeline import FloorMetrics, FloorResult, measure, similarity
from .rng import DungeonRng


@dataclass
class Thresholds:
    min_rooms: int = 4
    min_halls: int = 3
    min_connections: int = 3
    min_reachable_ratio: float = 0.97
    max_isolated_tiles: int = 8
    require_stairs_reachable: bool = True
    min_stair_distance: int = 12
    max_similarity: float = 0.93
    min_distinct_signatures: int = 8
    max_attempts_per_variant: int = 12


@dataclass
class VariantOutcome:
    ok: bool
    metrics: Optional[FloorMetrics]
    seed: int
    profile: str
    attempts: int
    failures: List[str] = field(default_factory=list)


@dataclass
class FloorValidation:
    floor: int
    profile: str
    variants: List[VariantOutcome] = field(default_factory=list)
    rejected: int = 0
    distinct_signatures: int = 0
    max_pair_similarity: float = 0.0
    ok: bool = False
    notes: List[str] = field(default_factory=list)

    def accepted(self) -> List[VariantOutcome]:
        return [v for v in self.variants if v.ok]


def check_layout(result: FloorResult, thresholds: Thresholds) -> Tuple[FloorMetrics, List[str]]:
    m = measure(result)
    problems: List[str] = []
    if m.rooms < thresholds.min_rooms:
        problems.append(f"only {m.rooms} rooms (min {thresholds.min_rooms})")
    if m.halls < thresholds.min_halls:
        problems.append(f"only {m.halls} halls (min {thresholds.min_halls})")
    if m.connections < thresholds.min_connections:
        problems.append(f"only {m.connections} connections")
    if m.components > 1:
        problems.append(f"{m.components} disconnected room clusters")
    if m.reachable_ratio < thresholds.min_reachable_ratio:
        problems.append(f"reachable ratio {m.reachable_ratio} below {thresholds.min_reachable_ratio}")
    if m.isolated_tiles > thresholds.max_isolated_tiles:
        problems.append(f"{m.isolated_tiles} isolated floor tiles")
    if thresholds.require_stairs_reachable and not m.stairs_reachable:
        problems.append("exit stairs unreachable from the entrance")
    if m.entrance is None or m.exit is None:
        problems.append("entrance or exit could not be placed")
    elif m.stair_distance < thresholds.min_stair_distance:
        problems.append(f"entrance/exit distance {m.stair_distance} below {thresholds.min_stair_distance}")
    return m, problems


def validate_floor(floor: int, profiles: Sequence[ArchitectureProfile], rng: DungeonRng,
                   count: int = 10, thresholds: Optional[Thresholds] = None,
                   keep_results: bool = False) -> Tuple[FloorValidation, List[FloorResult]]:
    """Generate `count` accepted variants, rejecting invalid or clone layouts."""
    thresholds = thresholds or Thresholds()
    primary = profiles[0]
    report = FloorValidation(floor=floor, profile="+".join(p.name for p in profiles))
    accepted_metrics: List[FloorMetrics] = []
    kept: List[FloorResult] = []

    for index in range(count):
        attempts = 0
        failures: List[str] = []
        outcome = VariantOutcome(False, None, 0, primary.name, 0)
        while attempts < thresholds.max_attempts_per_variant:
            attempts += 1
            profile = profiles[(index + attempts - 1) % len(profiles)] if len(profiles) > 1 else primary
            seed = rng.next_seed()
            try:
                result = profile.simulate(seed)
            except Exception as exc:  # a step refused these parameters
                failures.append(f"{profile.name}: generation error {exc}")
                report.rejected += 1
                continue
            metrics, problems = check_layout(result, thresholds)
            if problems:
                failures.append(f"{profile.name}/{seed}: " + "; ".join(problems))
                report.rejected += 1
                continue
            clone_of = None
            for previous in accepted_metrics:
                score = similarity(metrics, previous)
                report.max_pair_similarity = max(report.max_pair_similarity, score)
                if score > thresholds.max_similarity:
                    clone_of = (previous.seed, score)
                    break
            if clone_of:
                failures.append(f"{profile.name}/{seed}: structural clone of seed "
                                f"{clone_of[0]} (similarity {clone_of[1]})")
                report.rejected += 1
                continue
            accepted_metrics.append(metrics)
            if keep_results:
                kept.append(result)
            outcome = VariantOutcome(True, metrics, seed, profile.name, attempts, failures)
            break
        else:
            outcome = VariantOutcome(False, None, 0, primary.name, attempts, failures)
        report.variants.append(outcome)

    report.distinct_signatures = len({m.signature for m in accepted_metrics})
    report.ok = (len(accepted_metrics) == count
                 and report.distinct_signatures >= min(thresholds.min_distinct_signatures, count))
    if not report.ok:
        report.notes.append(f"{len(accepted_metrics)}/{count} variants accepted, "
                            f"{report.distinct_signatures} distinct signatures")
    return report, kept


def aggregate(metrics: Sequence[FloorMetrics]) -> Dict[str, float]:
    if not metrics:
        return {}
    def avg(name):
        return round(sum(getattr(m, name) for m in metrics) / len(metrics), 2)
    return {
        "variants": len(metrics),
        "rooms_avg": avg("rooms"), "rooms_min": min(m.rooms for m in metrics),
        "rooms_max": max(m.rooms for m in metrics),
        "halls_avg": avg("halls"), "branches_avg": avg("branches"),
        "dead_ends_avg": avg("dead_ends"), "loops_avg": avg("loops"),
        "connections_avg": avg("connections"),
        "room_area_min": min(m.room_area_min for m in metrics),
        "room_area_max": max(m.room_area_max for m in metrics),
        "stair_distance_avg": avg("stair_distance"),
        "reachable_ratio_min": min(m.reachable_ratio for m in metrics),
        "distinct_signatures": len({m.signature for m in metrics}),
    }
