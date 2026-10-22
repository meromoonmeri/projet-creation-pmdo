#!/usr/bin/env python3
"""Summarize JSONL emitted by the in-engine ``mapgen_validator`` service.

With ``--prototype``, the command additionally performs topology-aware
accept/reject selection.  Signatures come from RogueElements' actual
``FloorPlan`` (rooms, halls and room adjacency graph), never from a Python map
generator or from rendered pixels.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import statistics
from collections import Counter, defaultdict
from pathlib import Path
from typing import Iterable


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("target", type=Path)
    parser.add_argument("--prototype", action="store_true")
    parser.add_argument("--required-per-profile", type=int, default=10)
    parser.add_argument("--similarity-threshold", type=float, default=0.92)
    return parser.parse_args()


def read_events(source: Path) -> tuple[list[dict], list[dict], dict | None, dict | None]:
    rows: list[dict] = []
    grounds: list[dict] = []
    begin = end = None
    for line in source.read_text(encoding="utf-8").splitlines():
        try:
            row = json.loads(line)
        except (json.JSONDecodeError, TypeError):
            continue
        event = row.get("event")
        if event == "floor":
            rows.append(row)
        elif event == "ground":
            grounds.append(row)
        elif event == "begin":
            begin = row
        elif event == "end":
            end = row
    return rows, grounds, begin, end


def ints(value: object) -> list[int]:
    out = []
    for token in str(value or "").split(","):
        try:
            out.append(int(token))
        except ValueError:
            pass
    return out


def graph_data(row: dict) -> tuple[int, set[tuple[int, int]], dict[int, set[int]]]:
    count = max(0, int(row.get("rooms", 0)))
    edges: set[tuple[int, int]] = set()
    adjacency = {idx: set() for idx in range(count)}
    for token in str(row.get("graph", "")).split(","):
        if "-" not in token:
            continue
        try:
            left, right = (int(part) for part in token.split("-", 1))
        except ValueError:
            continue
        edge = (min(left, right), max(left, right))
        edges.add(edge)
        adjacency.setdefault(edge[0], set()).add(edge[1])
        adjacency.setdefault(edge[1], set()).add(edge[0])
    return count, edges, adjacency


def graph_signature(row: dict) -> str:
    """Approximate an isomorphism-invariant signature with WL refinement.

    Node creation order and absolute room coordinates are deliberately ignored:
    two maps with the same room graph remain near-duplicates even if their tile
    drawing differs.
    """
    count, edges, adjacency = graph_data(row)
    labels = {idx: "n" for idx in range(count)}
    for _ in range(max(1, count)):
        refined = {}
        for idx in range(count):
            neighborhood = ",".join(sorted(labels[n] for n in adjacency.get(idx, ())))
            refined[idx] = hashlib.sha256(
                f"{labels[idx]}|{neighborhood}".encode("utf-8")
            ).hexdigest()[:16]
        if sorted(refined.values()) == sorted(labels.values()):
            labels = refined
            break
        labels = refined
    edge_labels = sorted(
        "-".join(sorted((labels.get(a, ""), labels.get(b, "")))) for a, b in edges
    )
    payload = {
        "nodes": sorted(labels.values()),
        "edges": edge_labels,
        "degrees": sorted(len(adjacency.get(idx, ())) for idx in range(count)),
    }
    return hashlib.sha256(json.dumps(payload, sort_keys=True).encode("utf-8")).hexdigest()


def structural_signature(row: dict) -> str:
    payload = {
        "graph": graph_signature(row),
        "room_dims": sorted(str(row.get("room_dims", "")).split(",")),
        "room_forms": sorted(str(row.get("room_forms", "")).split(",")),
        "hall_lengths": sorted(ints(row.get("hall_lengths"))),
        "stairs": [row.get("stair_distance_min"), row.get("stair_distance_max")],
    }
    return hashlib.sha256(json.dumps(payload, sort_keys=True).encode("utf-8")).hexdigest()


def similarity(left: dict, right: dict) -> float:
    if graph_signature(left) == graph_signature(right):
        return 1.0
    fields = (
        "rooms", "halls", "branches", "dead_ends", "loops",
        "large_rooms", "small_rooms", "stair_distance_min",
    )
    scores = []
    for field in fields:
        a, b = float(left.get(field, 0) or 0), float(right.get(field, 0) or 0)
        scores.append(1.0 - abs(a - b) / max(1.0, abs(a), abs(b)))
    forms_a = Counter(str(left.get("room_forms", "")).split(","))
    forms_b = Counter(str(right.get("room_forms", "")).split(","))
    union = sum((forms_a | forms_b).values())
    intersection = sum((forms_a & forms_b).values())
    scores.append(intersection / union if union else 1.0)
    return statistics.mean(scores)


def valid_prototype_floor(row: dict) -> tuple[bool, list[str]]:
    errors = []
    if row.get("status") != "OK":
        errors.append("engine failure")
    if row.get("traversable") is not True or int(row.get("isolated", 0)) != 0:
        errors.append("non-traversable or isolated cells")
    if int(row.get("components", 0)) != 1:
        errors.append("room graph is disconnected")
    if int(row.get("rooms", 0)) < 4 or int(row.get("halls", 0)) < 3:
        errors.append("degenerate room/hall count")
    if int(row.get("branches", 0)) < 1:
        errors.append("no branch")
    if int(row.get("dead_ends", 0)) < 1:
        errors.append("no dead end")
    if row.get("profile") == "looping" and int(row.get("loops", 0)) < 1:
        errors.append("looping profile produced no loop")
    if not row.get("topology"):
        errors.append("no native FloorPlan topology")
    return not errors, errors


def prototype_selection(rows: Iterable[dict], required: int, threshold: float) -> dict:
    accepted: dict[str, list[dict]] = defaultdict(list)
    rejected: dict[str, list[dict]] = defaultdict(list)
    for row in rows:
        profile = str(row.get("profile", "unknown"))
        valid, reasons = valid_prototype_floor(row)
        if not valid:
            rejected[profile].append({"row": row, "reasons": reasons})
            continue
        closest = max((similarity(row, prior) for prior in accepted[profile]), default=0.0)
        if closest >= threshold:
            rejected[profile].append({
                "row": row,
                "reasons": [f"structural similarity {closest:.3f} >= {threshold:.3f}"],
            })
            continue
        accepted[profile].append(row)
    expected = {"branching", "looping", "large_rooms"}
    ok = all(len(accepted[name]) >= required for name in expected)
    return {"accepted": accepted, "rejected": rejected, "expected": expected, "ok": ok}


def range_text(values: list[int | float], digits: int = 1) -> str:
    if not values:
        return "—"
    mean = statistics.mean(values)
    return f"{min(values)}/{mean:.{digits}f}/{max(values)}"


def build_report(rows: list[dict], grounds: list[dict], begin: dict | None,
                 end: dict | None, args: argparse.Namespace) -> tuple[str, bool]:
    failures = [row for row in rows if row.get("status") == "FAIL"]
    ok_rows = [row for row in rows if row.get("status") == "OK"]
    invalid_rows = [row for row in ok_rows if row.get("valid") is False]
    per_zone: dict[str, list[dict]] = defaultdict(list)
    for row in rows:
        per_zone[str(row.get("zone", "?"))].append(row)

    lines = [
        "# Validation runtime de la génération — moteur RogueEssence",
        "",
        "Chaque ligne vient d'un appel réel à `ZoneSegmentBase.GetMap(ZoneGenContext)`.",
        "Les métriques topologiques proviennent du `FloorPlan` construit par RogueElements ;",
        "aucun simulateur Python et aucun rendu pixel ne servent à certifier la géométrie.",
        "",
        f"- zones testées : **{len(per_zone)}**",
        f"- itérations : **{(begin or {}).get('iterations', '?')}**",
        f"- générations tentées : **{len(rows)}**",
        f"- réussies : **{len(ok_rows)}**",
        f"- échecs moteur : **{len(failures)}**",
        f"- floors construits mais invalides : **{len(invalid_rows)}**",
        "",
    ]

    traversal = [row for row in ok_rows if "traversable" in row]
    bad_traversal = [row for row in traversal if row.get("traversable") is not True]
    pockets = [row for row in traversal if int(row.get("isolated", 0)) > 0]
    lines += [
        "## Traversabilité moteur",
        "",
        f"- étages analysés : **{len(traversal)}**",
        f"- escaliers tous atteignables : **{len(traversal) - len(bad_traversal)}**",
        f"- étages avec cellules praticables isolées : **{len(pockets)}**",
        "",
    ]

    if failures:
        lines += ["## Échecs", "", "| Zone | Segment | Étage | Type | Message | Seed |",
                  "|---|---|---|---|---|---|"]
        for row in failures:
            lines.append(
                f"| `{row.get('zone')}` | {row.get('segment')} | {row.get('floor')} | "
                f"`{row.get('type', '?')}` | {str(row.get('message', ''))[:160]} | "
                f"`{row.get('seed')}` |"
            )
        lines.append("")
    else:
        lines += ["## Échecs", "", "Aucun échec remonté par l'appel moteur.", ""]
    if invalid_rows:
        lines += [
            "## Floors invalides malgré un retour moteur",
            "",
            "Ces cas montrent pourquoi un simple `GetMap` sans exception ne suffit pas :",
            "",
            "| Zone | Segment | Floor | Profil | Rooms | Halls | Composantes | Branches | Culs-de-sac | Seed |",
            "|---|---:|---:|---|---:|---:|---:|---:|---:|---|",
        ]
        for row in invalid_rows:
            lines.append(
                f"| `{row.get('zone')}` | {row.get('segment')} | {row.get('floor')} | "
                f"`{row.get('profile')}` | {row.get('rooms')} | {row.get('halls')} | "
                f"{row.get('components')} | {row.get('branches')} | {row.get('dead_ends')} | "
                f"`{row.get('seed')}` |"
            )
        lines.append("")

    lines += [
        "## Par donjon",
        "",
        "| Donjon | Floors | Rooms min/moy/max | Halls min/moy/max | Branches | Culs-de-sac | Boucles | Dist. entrée→escalier | ms moy |",
        "|---|---:|---|---|---|---|---|---|---:|",
    ]
    for zone in sorted(per_zone):
        entries = [row for row in per_zone[zone] if row.get("status") == "OK"]
        if not entries:
            lines.append(f"| `{zone}` | 0 | — | — | — | — | — | — | — |")
            continue
        lines.append(
            f"| `{zone}` | {len(entries)} | "
            f"{range_text([int(r.get('rooms', -1)) for r in entries if int(r.get('rooms', -1)) >= 0])} | "
            f"{range_text([int(r.get('halls', -1)) for r in entries if int(r.get('halls', -1)) >= 0])} | "
            f"{range_text([int(r.get('branches', -1)) for r in entries if int(r.get('branches', -1)) >= 0])} | "
            f"{range_text([int(r.get('dead_ends', -1)) for r in entries if int(r.get('dead_ends', -1)) >= 0])} | "
            f"{range_text([int(r.get('loops', -1)) for r in entries if int(r.get('loops', -1)) >= 0])} | "
            f"{range_text([int(r.get('stair_distance_min', -1)) for r in entries if int(r.get('stair_distance_min', -1)) >= 0])} | "
            f"{statistics.mean(float(r.get('ms', 0)) for r in entries):.1f} |"
        )
    lines.append("")

    prototype_ok = True
    if args.prototype:
        selection = prototype_selection(rows, args.required_per_profile, args.similarity_threshold)
        prototype_ok = selection["ok"]
        lines += [
            "## Prototype isolé — sélection topologique",
            "",
            f"Seuil de similarité : **{args.similarity_threshold:.2f}**. Requis : "
            f"**{args.required_per_profile} variantes acceptées par profil**.",
            "Une signature de graphe ignore l'ordre de création et les coordonnées absolues :",
            "un même graphe de salles n'est donc pas compté comme nouveau parce que quelques tuiles bougent.",
            "",
            "| Profil | Tentatives | Acceptées | Rejetées | Rooms | Halls | Branches | Culs-de-sac | Boucles | Signatures |",
            "|---|---:|---:|---:|---|---|---|---|---|---:|",
        ]
        for profile in sorted(selection["expected"]):
            accepted = selection["accepted"][profile]
            rejected = selection["rejected"][profile]
            signatures = {structural_signature(row) for row in accepted}
            lines.append(
                f"| `{profile}` | {len(accepted) + len(rejected)} | {len(accepted)} | {len(rejected)} | "
                f"{range_text([int(r['rooms']) for r in accepted])} | "
                f"{range_text([int(r['halls']) for r in accepted])} | "
                f"{range_text([int(r['branches']) for r in accepted])} | "
                f"{range_text([int(r['dead_ends']) for r in accepted])} | "
                f"{range_text([int(r['loops']) for r in accepted])} | {len(signatures)} |"
            )
        lines += ["", f"**Verdict prototype : {'PASS' if prototype_ok else 'BLOCKED'}**", ""]
        all_rejected = [item for values in selection["rejected"].values() for item in values]
        if all_rejected:
            reason_counts = Counter(reason for item in all_rejected for reason in item["reasons"])
            lines += ["### Rejets", ""]
            for reason, count in reason_counts.most_common():
                lines.append(f"- {count} × {reason}")
            lines.append("")

    if grounds:
        problems = [ground for ground in grounds if ground.get("status") != "OK"]
        lines += ["## Grounds chargés par le moteur", "",
                  f"{len(grounds)} liaison(s), **{len(problems)} problème(s)**.", ""]

    if end:
        lines += [f"Ligne terminale : `{json.dumps(end, ensure_ascii=False)}`", ""]
    else:
        lines += ["**Aucune ligne terminale : run incomplet.**", ""]

    overall = not failures and not invalid_rows and end is not None and not bad_traversal and prototype_ok
    return "\n".join(lines) + "\n", overall


def main() -> int:
    args = parse_args()
    rows, grounds, begin, end = read_events(args.source)
    report, ok = build_report(rows, grounds, begin, end, args)
    args.target.parent.mkdir(parents=True, exist_ok=True)
    args.target.write_text(report, encoding="utf-8")
    print(f"{sum(r.get('status') == 'OK' for r in rows)}/{len(rows)} générations réussies -> {args.target}")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
