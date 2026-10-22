#!/usr/bin/env python3
"""Multi-source asset analysis, uncertainty and visual compatibility graphs."""
from __future__ import annotations
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import hashlib
import json
import math
import re
import struct
import sys
import tempfile
from collections import Counter, defaultdict
from pathlib import Path
from statistics import mean

TOOLS = Path(__file__).resolve().parents[2] / "external/BIBLIOTHEQUE_WORKSPACE/tools"
if str(TOOLS) not in sys.path:
    sys.path.insert(0, str(TOOLS))
from png_rgba import load_png
from .model import AssetProfile

ROLE_WORDS = {
    "floor": {"floor", "ground", "sol", "path", "road", "grass", "sand", "snow", "carpet", "plank", "tile"},
    "wall": {"wall", "mur", "cliff", "rock", "block", "pillar", "fence", "barrier", "hedge"},
    "border": {"edge", "border", "rim", "shore", "coast", "corner", "front", "ledge"},
    "structure": {"house", "door", "gate", "bridge", "stairs", "tower", "altar", "ruin", "temple"},
    "decoration": {"deco", "flower", "plant", "bush", "mushroom", "web", "banner", "statue", "torch"},
    "hazard": {"lava", "poison", "spike", "trap", "fire", "abyss", "void", "toxic"},
    "water": {"water", "river", "sea", "ocean", "lake", "pond", "rain", "ice"},
    "transition": {"transition", "fade", "portal", "wormhole", "entrance", "exit"},
    "focal": {"boss", "legend", "altar", "crystal", "throne", "monument", "giant", "guardian"},
}
MATERIAL_WORDS = {
    "mineral_apparent": {"rock", "stone", "crystal", "ore", "cliff", "cave", "ruin"},
    "vegetal_apparent": {"grass", "plant", "flower", "forest", "bush", "tree", "moss"},
    "liquid_apparent": {"water", "river", "sea", "lake", "lava", "poison"},
    "constructed_apparent": {"brick", "metal", "plank", "carpet", "temple", "house", "wall"},
}
STOP = {"base", "layer", "tileset", "tile", "town", "map", "the", "and", "front", "back", "new"}


def tokens(text: str) -> set[str]:
    return {x for x in re.findall(r"[a-z0-9]+", text.casefold()) if len(x) > 1 and x not in STOP}


def _tile_entries(path: Path):
    data = path.read_bytes()
    if len(data) < 8:
        return 0, []
    size, count = struct.unpack_from("<II", data, 0)
    rows = []
    if 8 + count * 16 > len(data):
        return size, []
    for index in range(count):
        key, offset = struct.unpack_from("<QQ", data, 8 + index * 16)
        if offset + 8 > len(data):
            continue
        length = struct.unpack_from("<Q", data, offset)[0]
        if offset + 8 + length <= len(data):
            rows.append((key, data[offset + 8:offset + 8 + length]))
    return size, rows


def _image_metrics(payloads: list[bytes], temp: Path):
    colors = Counter()
    alpha = edges = samples = symmetry = symmetry_total = 0
    lumas, saturations = [], []
    for raw in payloads:
        path = temp / f"{hashlib.sha256(raw).hexdigest()}.png"
        if not path.exists():
            path.write_bytes(raw)
        try:
            image = load_png(path)
        except Exception:
            continue
        step = max(1, min(image.width, image.height) // 8)
        for y in range(0, image.height, step):
            for x in range(0, image.width, step):
                i = (y * image.width + x) * 4
                r, g, b, a = image.pixels[i:i + 4]
                samples += 1
                alpha += a > 24
                if a > 24:
                    colors[(r // 24 * 24, g // 24 * 24, b // 24 * 24)] += 1
                    maximum, minimum = max(r, g, b), min(r, g, b)
                    lumas.append((r * 299 + g * 587 + b * 114) / 255000)
                    saturations.append(0 if maximum == 0 else (maximum - minimum) / maximum)
                if x + step < image.width:
                    j = (y * image.width + min(image.width - 1, x + step)) * 4
                    edges += sum(abs(image.pixels[i + channel] - image.pixels[j + channel]) for channel in range(3)) > 90
                j = (y * image.width + (image.width - 1 - x)) * 4
                symmetry_total += 1
                symmetry += sum(abs(image.pixels[i + channel] - image.pixels[j + channel]) for channel in range(4)) < 80
    if not samples:
        return [0, 0, 0], 0, 0, 0, 0, 0, 0
    dominant = list(colors.most_common(1)[0][0] if colors else (0, 0, 0))
    detail = min(1, len(colors) / 48 + (edges / samples) * .7)
    return (
        dominant,
        mean(lumas) if lumas else 0,
        mean(saturations) if saturations else 0,
        alpha / samples,
        min(1, edges / samples * 2),
        detail,
        symmetry / max(1, symmetry_total),
    )


def _role_scores(name: str, alpha: float, edge: float, detail: float, usage: float | None):
    name_tokens = tokens(name)
    scores = {key: .05 for key in ROLE_WORDS}
    for role, words in ROLE_WORDS.items():
        scores[role] += min(.75, .24 * len(name_tokens & words))
    scores["floor"] += max(0, .25 - detail * .2) + (0 if usage is None else (1 - usage) * .35)
    scores["wall"] += edge * .25 + (0 if usage is None else usage * .5)
    scores["decoration"] += (1 - alpha) * .35 + detail * .22
    scores["focal"] += detail * .3 + max(0, .2 - alpha * .1)
    scores["border"] += edge * .18 + (1 - alpha) * .15
    total = sum(scores.values())
    return {key: round(value / total, 4) for key, value in scores.items()}


def _layer_name(layer, index):
    raw = layer.get("Name", layer.get("name", f"layer_{index}"))
    if isinstance(raw, dict):
        return str(raw.get("DefaultText") or raw.get("default") or f"layer_{index}")
    return str(raw)


def _usage_evidence(grounds: list[Path], limit: int):
    """Observe actual sheet use, collision correlation and co-occurrences.

    Only compact aggregate evidence is retained. No Ground is modified.
    """
    hits = defaultdict(lambda: {"cells": 0, "blocked": 0, "grounds": Counter(), "layers": Counter(), "co": Counter()})
    selected = sorted(grounds, key=lambda path: (path.stat().st_size, path.name))[:limit]
    for path in selected:
        try:
            obj = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
            obstacles = obj.get("obstacles", [])
            texture_size = max(1, int(obj.get("TexSize", 1)))
        except Exception:
            continue
        for layer_index, layer in enumerate(obj.get("Layers", [])):
            layer_name = _layer_name(layer, layer_index)
            for x, column in enumerate(layer.get("Tiles", [])):
                for y, cell in enumerate(column):
                    blocked = False
                    for ox in range(x * texture_size, min(len(obstacles), (x + 1) * texture_size)):
                        if any(
                            obstacles[ox][oy].get("Tags", 0) != 0
                            for oy in range(y * texture_size, min(len(obstacles[ox]), (y + 1) * texture_size))
                        ):
                            blocked = True
                    sheets = sorted({
                        frame.get("Sheet", "")
                        for tile_layer in cell.get("Layers", [])
                        for frame in tile_layer.get("Frames", [])
                        if frame.get("Sheet")
                    })
                    for sheet in sheets:
                        row = hits[sheet]
                        row["cells"] += 1
                        row["blocked"] += blocked
                        row["grounds"][path.stem] += 1
                        row["layers"][layer_name] += 1
                        for other in sheets:
                            if other != sheet:
                                row["co"][other] += 1
    result = {}
    for sheet, row in hits.items():
        result[sheet] = {
            "blocked_ratio": row["blocked"] / max(1, row["cells"]),
            "occurrences": row["cells"],
            "contexts": [
                {"ground": name, "observed_cells": count}
                for name, count in row["grounds"].most_common(5)
            ],
            "layers": [{"layer": name, "observed_cells": count} for name, count in row["layers"].most_common(4)],
            "cooccurring": [
                {"asset_id": name, "observed_cells": count}
                for name, count in row["co"].most_common(8)
            ],
        }
    return result


def _overrides(path: Path | None):
    if not path or not path.exists():
        return {}
    data = json.loads(path.read_text(encoding="utf-8-sig"))
    return data.get("assets", data)


def _vector(asset: AssetProfile):
    return [
        asset.dominant_rgb[0] / 255, asset.dominant_rgb[1] / 255, asset.dominant_rgb[2] / 255,
        asset.mean_luma, asset.mean_saturation, asset.alpha_coverage,
        asset.edge_density, asset.detail_score, asset.symmetry_score,
    ]


def _distance(a: AssetProfile, b: AssetProfile):
    va, vb = _vector(a), _vector(b)
    visual = math.sqrt(sum((x - y) ** 2 for x, y in zip(va, vb)) / len(va))
    ta, tb = tokens(a.asset_id), tokens(b.asset_id)
    lexical = 1 - len(ta & tb) / max(1, len(ta | tb))
    size = 0 if a.tile_size == b.tile_size or not a.tile_size or not b.tile_size else 1
    return .67 * visual + .21 * lexical + .12 * size


def _material_hints(name: str, luma: float, saturation: float, alpha: float, detail: float):
    observed = tokens(name)
    hints = [label for label, words in MATERIAL_WORDS.items() if observed & words]
    # These are explicitly visual properties, not semantic material claims.
    hints += ["dark_palette" if luma < .3 else "light_palette" if luma > .68 else "mid_luma_palette"]
    if saturation > .55:
        hints.append("high_saturation")
    if detail > .62:
        hints.append("high_detail")
    if alpha < .72:
        hints.append("sparse_or_transparent")
    return sorted(set(hints))


def _uncertainty(profile: AssetProfile):
    ranked = sorted(profile.role_scores.values(), reverse=True)
    reasons = []
    if profile.confidence < .56:
        reasons.append("low_multi_source_confidence")
    if len(ranked) > 1 and ranked[0] - ranked[1] < .045:
        reasons.append("role_scores_too_close")
    if not profile.tags and not profile.usage_count:
        reasons.append("no_semantic_or_usage_context")
    if profile.sample_count < 3 and profile.kind == "ground_tile_sheet":
        reasons.append("insufficient_visual_samples")
    return bool(reasons), reasons


def analyze_library(
    repo: Path,
    output: Path,
    overrides: Path | None = None,
    max_sheets: int = 0,
    max_grounds: int = 96,
    samples_per_sheet: int = 24,
):
    repo = repo.resolve()
    tile_paths = sorted((repo / "Content/Tile").glob("*.tile"))[:max_sheets or None]
    usage = _usage_evidence(list((repo / "Data/Ground").glob("*.rsground")), max_grounds)
    profiles: list[AssetProfile] = []
    manual = _overrides(overrides)

    with tempfile.TemporaryDirectory() as temp_dir:
        temp = Path(temp_dir)
        for path in tile_paths:
            size, entries = _tile_entries(path)
            stride = max(1, len(entries) // max(1, samples_per_sheet))
            payloads = [item[1] for item in entries[::stride][:samples_per_sheet]]
            dominant, luma, saturation, alpha, edge, detail, symmetry = _image_metrics(payloads, temp)
            observed = usage.get(path.stem, {})
            blocked_ratio = observed.get("blocked_ratio")
            role_scores = _role_scores(path.stem, alpha, edge, detail, blocked_ratio)
            tags = sorted({role for role, words in ROLE_WORDS.items() if tokens(path.stem) & words})
            rarity = max(.05, min(.98, .25 + detail * .45 + (1 - alpha) * .2))
            evidence = ["pixel_metrics"] if payloads else []
            if tags:
                evidence.append("filename_semantics")
            if observed:
                evidence.extend(["ground_usage", "collision_correlation", "asset_cooccurrence"])
            confidence = min(.98, .30 + len(tags) * .10 + min(.22, len(payloads) / 100) + (.22 if observed else 0))
            profile = AssetProfile(
                asset_id=path.stem,
                source_file=path.relative_to(repo).as_posix(),
                kind="ground_tile_sheet",
                tile_size=size,
                sample_count=len(payloads),
                dominant_rgb=dominant,
                mean_luma=luma,
                mean_saturation=saturation,
                alpha_coverage=alpha,
                edge_density=edge,
                detail_score=detail,
                symmetry_score=symmetry,
                usage_blocked_ratio=blocked_ratio,
                role_scores=role_scores,
                tags=tags,
                rarity=rarity,
                confidence=confidence,
                usage_count=int(observed.get("occurrences", 0)),
                usage_contexts=observed.get("contexts", []) + observed.get("layers", []),
                cooccurring_assets=observed.get("cooccurring", []),
                evidence_sources=sorted(set(evidence)),
                material_hints=_material_hints(path.stem, luma, saturation, alpha, detail),
            )
            override = manual.get(path.stem)
            if override:
                if "role" in override:
                    profile.role_scores = {key: (1.0 if key == override["role"] else 0.0) for key in ROLE_WORDS}
                profile.tags = sorted(set(profile.tags + override.get("tags", [])))
                profile.rarity = float(override.get("rarity", profile.rarity))
                profile.overridden = True
                profile.confidence = max(profile.confidence, .99)
                profile.evidence_sources.append("human_override")
            profile.ambiguous, profile.uncertainty_reasons = _uncertainty(profile)
            profiles.append(profile)

    # Native dungeon texture bundles are first-class vocabulary, with source zones.
    bundles: dict[str, dict] = {}

    def collect(value, zone_name):
        if isinstance(value, dict):
            if "GroundTileset" in value and "BlockTileset" in value:
                vals = [value.get(key, "") for key in ("GroundTileset", "BlockTileset", "WaterTileset")]
                key = "|".join(str(item) for item in vals)
                bundles.setdefault(key, {"values": vals, "zones": set()})["zones"].add(zone_name)
            for child in value.values():
                collect(child, zone_name)
        elif isinstance(value, list):
            for child in value:
                collect(child, zone_name)

    for path in sorted((repo / "Data/Zone").glob("*.json")):
        try:
            collect(json.loads(path.read_text(encoding="utf-8-sig")), path.stem)
        except Exception:
            pass
    for key, data in sorted(bundles.items()):
        asset_id = "dungeon_texture:" + key
        name_tokens = tokens(key)
        roles = {role: .02 for role in ROLE_WORDS}
        roles["floor"] = roles["wall"] = .42
        tags = sorted({role for role, words in ROLE_WORDS.items() if name_tokens & words})
        profile = AssetProfile(
            asset_id=asset_id,
            source_file="Data/Zone/*.json",
            kind="dungeon_texture_bundle",
            tile_size=24,
            sample_count=3,
            dominant_rgb=[96, 96, 96],
            mean_luma=.45,
            mean_saturation=.25,
            alpha_coverage=1,
            edge_density=.45,
            detail_score=.4,
            symmetry_score=.5,
            role_scores=roles,
            tags=tags,
            rarity=.35,
            confidence=.92,
            usage_count=len(data["zones"]),
            usage_contexts=[{"zone": zone} for zone in sorted(data["zones"])[:12]],
            evidence_sources=["native_zone_usage", "map_texture_contract"],
            material_hints=_material_hints(key, .45, .25, 1, .4),
        )
        profiles.append(profile)

    # Compatibility graph.
    for profile in profiles:
        candidates = sorted(
            ((_distance(profile, other), other.asset_id) for other in profiles if other is not profile and other.kind == profile.kind),
            key=lambda row: (row[0], row[1]),
        )[:16]
        profile.compatible = [
            {"asset_id": asset_id, "score": round(max(0, 1 - distance), 4)}
            for distance, asset_id in candidates if distance < .76
        ]

    # Conservative connected visual families.
    by_id = {profile.asset_id: profile for profile in profiles}
    unseen = set(by_id)
    cluster_index = 0
    while unseen:
        root = min(unseen)
        front = [root]
        members = []
        unseen.remove(root)
        while front:
            current = front.pop()
            members.append(current)
            for relation in by_id[current].compatible[:6]:
                candidate = relation["asset_id"]
                if relation["score"] >= .67 and candidate in unseen:
                    unseen.remove(candidate)
                    front.append(candidate)
        cluster_id = f"visual_cluster_{cluster_index:03d}"
        cluster_index += 1
        for asset_id in members:
            by_id[asset_id].cluster_id = cluster_id

    # Assets close to more than one family can bridge transitions.
    for profile in profiles:
        bridge_scores = defaultdict(float)
        for relation in profile.compatible:
            other_cluster = by_id[relation["asset_id"]].cluster_id
            if other_cluster != profile.cluster_id:
                bridge_scores[other_cluster] = max(bridge_scores[other_cluster], relation["score"])
        profile.bridge_clusters = [
            cluster for cluster, score in sorted(bridge_scores.items(), key=lambda row: (-row[1], row[0])) if score >= .46
        ][:4]

    override_ref = None
    if overrides:
        try:
            override_ref = overrides.resolve().relative_to(output.parent.resolve()).as_posix()
        except ValueError:
            override_ref = str(overrides)
    payload = {
        "schema_version": "2.0.0",
        "result": "ASSET_SEMANTIC_ANALYSIS_PASS",
        "asset_count": len(profiles),
        "ground_sheet_count": sum(asset.kind == "ground_tile_sheet" for asset in profiles),
        "dungeon_texture_bundle_count": sum(asset.kind == "dungeon_texture_bundle" for asset in profiles),
        "cluster_count": cluster_index,
        "ambiguous_asset_count": sum(asset.ambiguous for asset in profiles),
        "override_file": override_ref,
        "analysis_sources": ["pixel_metrics", "ground_usage", "collision_correlation", "cooccurrence", "native_zone_usage", "filename_semantics"],
        "analysis_limits": {"max_sheets": max_sheets, "max_grounds": max_grounds, "samples_per_sheet": samples_per_sheet},
        "assets": [asset.to_dict() for asset in profiles],
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    return payload
