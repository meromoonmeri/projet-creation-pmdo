#!/usr/bin/env python3
"""Automatic Ground reference selection and cross-library compatibility."""
from __future__ import annotations
import math
import re
import tempfile
import unicodedata
from collections import Counter
from pathlib import Path
from statistics import mean
from .assets import _image_metrics, _tile_entries
from .knowledge import analyze_references

_KNOWLEDGE_CACHE = {}
STOP = {
    "base", "layer", "tileset", "tile", "ground", "objects", "under", "over", "front",
    "une", "avec", "des", "les", "pour", "dans", "plusieurs", "entree", "entrance",
    "sortie", "exit", "finale", "final", "defaulttext", "localtexts",
}


def words(text):
    normalized = "".join(char for char in unicodedata.normalize("NFKD", str(text).casefold()) if not unicodedata.combining(char))
    aliases = {
        "foret": "forest", "forest": "forest", "sylvestre": "forest",
        "clairiere": "clearing", "clearing": "clearing",
        "lac": "water", "lacs": "water", "pond": "water", "river": "water", "riviere": "water", "eau": "water",
        "arbre": "tree", "arbres": "tree", "tree": "tree", "trees": "tree",
        "rocher": "rock", "rochers": "rock", "rock": "rock", "rocks": "rock",
        "grotte": "cave", "caverne": "cave", "cave": "cave",
        "ruine": "ruins", "ruines": "ruins", "ruins": "ruins",
        "sombre": "dark", "dark": "dark", "nuit": "dark", "night": "dark",
    }
    result = set()
    for token in re.findall(r"[a-z0-9]+", normalized):
        if len(token) > 2 and token not in STOP:
            result.add(aliases.get(token, token))
    return result


def interpret_ground_intent(intent):
    text = intent.casefold()
    concepts = {
        "clearing_lakes": ("clairière" in text or "clearing" in text) and any(word in text for word in ("lac", "eau", "lake", "pond")),
        "crystal_cavern": any(word in text for word in ("cristal", "crystal")) and any(word in text for word in ("grotte", "caverne", "cave")),
        "winding_canyon": any(word in text for word in ("canyon", "ravin", "gorge")),
        "ancient_courtyard": any(word in text for word in ("ruine", "temple", "cour", "sanctuaire", "ruins", "courtyard")),
        "boss_arena": any(word in text for word in ("arène", "arena", "boss")),
    }
    concept = next((key for key, active in concepts.items() if active), "organic_exploration")
    semantic_cues = words(intent) & {"forest", "clearing", "water", "tree", "rock", "cave", "ruins", "dark", "cristal", "crystal", "canyon", "ravin", "gorge", "temple", "cour", "sanctuaire", "boss", "arena", "arene", "chemin", "path"}
    confidence = .9 if concept != "organic_exploration" else min(.72, .3 + len(semantic_cues) * .1)
    requires_water = concept in ("clearing_lakes", "crystal_cavern") or any(word in text for word in ("lac", "eau", "rivière", "water", "river", "pond"))
    target = {"luma": .48, "saturation": .35, "detail": .50, "edge": .42}
    if any(word in text for word in ("sombre", "dark", "ancien", "profonde")):
        target["luma"] -= .16
        target["edge"] += .10
    if any(word in text for word in ("clair", "lumineux", "bright")):
        target["luma"] += .18
    if any(word in text for word in ("forêt", "forest", "végétal")):
        target["saturation"] += .12
    if any(word in text for word in ("cristal", "crystal")):
        target["detail"] += .18
        target["edge"] += .10
    return {
        "concept": concept,
        "confidence": confidence,
        "requires_water": requires_water,
        "intent_words": sorted(words(intent)),
        "visual_target": {key: max(0, min(1, value)) for key, value in target.items()},
    }


def _sheet_paths(repo, ground):
    available = {path.stem: path for path in (repo / "Content/Tile").glob("*.tile")}
    ranked = sorted(ground.get("sheets", {}).items(), key=lambda row: (-row[1], row[0]))
    return [available[name] for name, _ in ranked if name in available][:4]


def _visual_profile(repo, ground):
    paths = _sheet_paths(repo, ground)
    vectors = []
    with tempfile.TemporaryDirectory() as temp_dir:
        temp = Path(temp_dir)
        for path in paths:
            size, entries = _tile_entries(path)
            if not entries:
                continue
            stride = max(1, len(entries) // 8)
            payloads = [row[1] for row in entries[::stride][:8]]
            dominant, luma, saturation, alpha, edge, detail, symmetry = _image_metrics(payloads, temp)
            vectors.append({
                "sheet": path.stem, "tile_size": size,
                "dominant_rgb": dominant, "luma": luma,
                "saturation": saturation, "alpha": alpha,
                "edge": edge, "detail": detail, "symmetry": symmetry,
            })
    if not vectors:
        return {"confidence": 0, "sheets": [], "luma": .5, "saturation": .3, "edge": .4, "detail": .5, "tile_sizes": []}
    return {
        "confidence": min(.95, .45 + len(vectors) * .12),
        "sheets": vectors,
        "luma": mean(row["luma"] for row in vectors),
        "saturation": mean(row["saturation"] for row in vectors),
        "edge": mean(row["edge"] for row in vectors),
        "detail": mean(row["detail"] for row in vectors),
        "tile_sizes": sorted({row["tile_size"] for row in vectors}),
    }


def visual_distance(left, right):
    return math.sqrt(mean((left[key] - right[key]) ** 2 for key in ("luma", "saturation", "edge", "detail")))


def _target_distance(profile, target):
    return math.sqrt(mean((profile[key] - target[key]) ** 2 for key in ("luma", "saturation", "edge", "detail")))


def _theme_score(ground, interpreted):
    name = ground["ground_id"].casefold()
    concept = interpreted["concept"]
    families = {
        "winding_canyon": (("searing", "tunnel", "windswept", "gorge", "mount"), 16),
        "ancient_courtyard": (("dojo", "altar", "temple", "sanct", "ruin", "relic"), 15),
        "crystal_cavern": (("cave", "cavern", "den", "tunnel", "grotte", "antre"), 15),
        "boss_arena": (("miniboss", "guardian", "dojo", "altar", "chamber", "arena"), 16),
        "clearing_lakes": (("pond", "river", "forest", "glade", "clearing"), 11),
    }
    tokens, bonus = families.get(concept, ((), 0))
    return bonus if any(token in name for token in tokens) else 0


def _structural_score(ground, interpreted):
    width, height = ground.get("size_cells", [0, 0])
    if ground.get("tex_size") != 1 or width < 24 or height < 20:
        return -100
    aligned = sum(layer.get("width") == width and layer.get("height") == height for layer in ground.get("layers", []))
    if not aligned:
        return -100
    collision = ground.get("collision_counts", {})
    open_count = int(collision.get("0", 0))
    blocked = sum(int(value) for key, value in collision.items() if key != "0")
    open_ratio = open_count / max(1, open_count + blocked)
    water = ground.get("water_visual_cell_count", 0)
    grammar_richness = min(7, len(ground.get("topology_grammar", {})) / 4)
    size_support = min(4, min(width, height) / 20)
    score = aligned * 1.5 + (1 - abs(open_ratio - .62)) * 4 + grammar_richness + size_support
    if interpreted["requires_water"]:
        score += 8 if water else -40
    if interpreted["concept"] == "boss_arena":
        score += 6 if 30 <= width <= 64 and 24 <= height <= 56 else -10
    if interpreted["concept"] == "clearing_lakes":
        score += min(5, water / max(1, width * height) * 40)
    return score


def select_ground_sources(repo: Path, intent: str, explicit_reference: str | None = None, knowledge: dict | None = None):
    repo = repo.resolve()
    interpreted = interpret_ground_intent(intent)
    if knowledge is None:
        cache_key = repo.as_posix()
        if cache_key not in _KNOWLEDGE_CACHE:
            _KNOWLEDGE_CACHE[cache_key] = analyze_references(repo, None, max_zones=0, max_grounds=0)
        knowledge = _KNOWLEDGE_CACHE[cache_key]
    grounds = knowledge.get("grounds", [])
    if explicit_reference:
        base = next((row for row in grounds if row["ground_id"] == explicit_reference), None)
        if not base:
            raise FileNotFoundError(repo / "Data/Ground" / f"{explicit_reference}.rsground")
        base_profile = _visual_profile(repo, base)
        return {
            "intent": interpreted, "base": base, "base_visual": base_profile,
            "decoration": base, "decoration_visual": base_profile,
            "compatibility": 1.0, "confidence": .99,
            "strategy": "explicit_user_reference", "ranked_candidates": [],
            "theme_match": _theme_score(base, interpreted) > 0,
            "knowledge_summary": {"ground_count": knowledge.get("ground_count", len(grounds))},
        }
    intent_tokens = set(interpreted["intent_words"])
    coarse = []
    for ground in grounds:
        ground_id = ground["ground_id"].casefold()
        # Story hubs and certified Metano maps teach proportions but are never
        # silently used as a global generation skin.
        if any(ground_id.startswith(prefix) for prefix in ("metano", "guild_", "personality_test")) and not set(("ville", "town", "guilde", "guild")) & intent_tokens:
            continue
        structural = _structural_score(ground, interpreted) + _theme_score(ground, interpreted)
        if structural <= -50:
            continue
        semantic_text = " ".join([ground["ground_id"], str(ground.get("name", {})), " ".join(ground.get("sheets", {}))])
        semantic = len(intent_tokens & words(semantic_text)) * 3
        placeholder_penalty = 20 if any("placeholder" in name.casefold() for name in ground.get("sheets", {})) else 0
        coarse.append((structural + semantic - placeholder_penalty, ground))
    coarse = sorted(coarse, key=lambda row: (-row[0], row[1]["ground_id"]))[:14]
    ranked = []
    for coarse_score, ground in coarse:
        profile = _visual_profile(repo, ground)
        visual_score = max(0, 1 - _target_distance(profile, interpreted["visual_target"])) * 8
        ranked.append({"ground": ground, "profile": profile, "score": coarse_score + visual_score, "coarse_score": coarse_score, "visual_score": visual_score})
    if not ranked:
        raise ValueError("No cell-aligned Ground reference satisfies the requested function")
    ranked.sort(key=lambda row: (-row["score"], row["ground"]["ground_id"]))
    base_row = ranked[0]
    # Decoration may come from a Ground without water, provided dimensions,
    # actual pixels and tile size are compatible with the structural base.
    profile_cache = {row["ground"]["ground_id"]: row["profile"] for row in ranked}
    decor_preselection = []
    for ground in (grounds if interpreted["confidence"] >= .55 else []):
        ground_id = ground["ground_id"].casefold()
        if ground["ground_id"] == base_row["ground"]["ground_id"]:
            continue
        if any(ground_id.startswith(prefix) for prefix in ("metano", "guild_", "personality_test")) and not set(("ville", "town", "guilde", "guild")) & intent_tokens:
            continue
        width, height = ground.get("size_cells", [0, 0])
        if ground.get("tex_size") != 1 or width < 16 or height < 12:
            continue
        has_decor = any(any(word in layer.get("name", "").casefold() for word in ("object", "fringe", "decor")) and layer.get("non_empty_cells", 0) for layer in ground.get("layers", []))
        if not has_decor:
            continue
        semantic_text = " ".join([ground["ground_id"], str(ground.get("name", {})), " ".join(ground.get("sheets", {}))])
        semantic = len(intent_tokens & words(semantic_text)) * 4
        if semantic == 0:
            continue
        decor_preselection.append((semantic + min(4, len(ground.get("layers", [])) / 2), ground))
    decor_candidates = []
    for pre_score, ground in sorted(decor_preselection, key=lambda row: (-row[0], row[1]["ground_id"]))[:20]:
        profile = profile_cache.get(ground["ground_id"]) or _visual_profile(repo, ground)
        distance = visual_distance(base_row["profile"], profile)
        same_sizes = bool(set(base_row["profile"]["tile_sizes"]) & set(profile["tile_sizes"]))
        if distance <= .24 and same_sizes:
            intent_fit = max(0, 1 - _target_distance(profile, interpreted["visual_target"]))
            decor_score = pre_score + (1 - distance) * 5 + intent_fit * 3
            decor_candidates.append((decor_score, distance, {"ground": ground, "profile": profile, "score": decor_score}))
    if decor_candidates:
        _, distance, decor_row = max(decor_candidates, key=lambda row: (row[0], -row[1], row[2]["ground"]["ground_id"]))
        strategy = "compatible_cross_library_decoration"
        confidence = min(base_row["profile"]["confidence"], decor_row["profile"]["confidence"], max(.55, 1 - distance))
    else:
        distance, decor_row = 0.0, base_row
        strategy = "single_library_conservative"
        confidence = base_row["profile"]["confidence"]
    return {
        "intent": interpreted,
        "base": base_row["ground"], "base_visual": base_row["profile"],
        "decoration": decor_row["ground"], "decoration_visual": decor_row["profile"],
        "compatibility": round(1 - distance, 4), "confidence": round(confidence, 4),
        "strategy": strategy,
        "theme_match": _theme_score(base_row["ground"], interpreted) > 0,
        "ranked_candidates": [{"ground_id": row["ground"]["ground_id"], "score": round(row["score"], 4), "visual_confidence": round(row["profile"]["confidence"], 3)} for row in ranked],
        "knowledge_summary": {"ground_count": knowledge.get("ground_count", len(grounds)), "autotile_count": knowledge.get("autotile_count", 0), "map_template_count": knowledge.get("map_template_count", 0)},
    }
