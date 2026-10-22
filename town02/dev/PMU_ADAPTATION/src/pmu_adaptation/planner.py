from __future__ import annotations

import gzip
import hashlib
import json
import math
import re
import subprocess
from collections import Counter, defaultdict, deque
from pathlib import Path
from typing import Any

DEFINITE_BLOCK_TYPES = {1: "Blocked", 14: "Sign", 31: "ScriptedSign"}
CONDITIONAL_BLOCK_TYPES = {10: "MobileBlock", 24: "SpriteBlock", 25: "LevelBlock"}
INTERACTION_TYPES = {
    2, 3, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
    21, 22, 23, 25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 36, 39,
}
STYLE_PATTERNS: dict[str, tuple[str, ...]] = {
    "settlement": ("town", "village", "city", "bourg", "ville", "plaza", "market", "bazaar", "port", "harbor"),
    "indoor": ("house", "home", "room", "inn", "cafe", "shop", "office", "hall", "guild", "dojo", "bank", "interior"),
    "forest": ("forest", "woods", "grove", "grassroot", "grass", "jungle", "woodland", "forêt", "bois"),
    "snow": ("snow", "ice", "frost", "winter", "winden", "glacier", "frozen", "neige", "glace"),
    "cave": ("cave", "cavern", "grotto", "tunnel", "mine", "grotte", "caverne"),
    "ruin": ("ruin", "temple", "ancient", "relic", "aegis", "sanctuary", "ruines"),
    "water": ("sea", "ocean", "beach", "coast", "isle", "island", "river", "lake", "water", "plage", "mer", "rivière", "lac"),
    "desert": ("desert", "sand", "dune", "arid", "désert", "sable"),
    "mountain": ("mount", "mountain", "peak", "cliff", "canyon", "summit", "gorge", "mont", "falaise"),
    "fire": ("fire", "magma", "volcano", "burn", "fiery", "searing", "feu", "volcan"),
    "sky": ("sky", "cloud", "aerial", "heaven", "ciel", "nuage"),
    "dark": ("dark", "shadow", "night", "abyss", "ghost", "haunt", "dusk", "nuit", "ombre"),
    "electric": ("electric", "thunder", "lightning", "electro", "foudre"),
    "plain": ("plain", "field", "steppe", "meadow", "prairie", "plaine"),
}
CATEGORY_DEFAULTS = {"settlement", "indoor", "dungeon", "connector", "special"}
FORBIDDEN_REFERENCE_PARTS = ("test", "debug", "validation", "missingno", "harness")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    path.write_text(payload + "\n", encoding="utf-8", newline="\n")


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_ir(path: Path) -> dict[str, Any]:
    with gzip.open(path, "rt", encoding="utf-8") as stream:
        return json.load(stream)


def tags_for(text: str) -> set[str]:
    normalized = text.casefold()
    return {
        tag for tag, patterns in STYLE_PATTERNS.items()
        if any(pattern in normalized for pattern in patterns)
    }


def source_category(map_data: dict[str, Any], tags: set[str]) -> tuple[str, str]:
    name = map_data.get("name", "")
    npc_count = len(map_data.get("npcs", []))
    warp_count = sum(tile["type"] == 2 for tile in map_data["tiles"])
    cardinal_count = sum((map_data.get(key) or 0) > 0 for key in ("up_map", "down_map", "left_map", "right_map"))
    if map_data.get("indoors") or "indoor" in tags:
        return "indoor", "PROVEN indoors property or reconstructed indoor-name signal"
    if "settlement" in tags or (npc_count >= 3 and warp_count >= 3):
        return "settlement", "reconstructed from canonical name and actor/warp density"
    if tags & {"cave", "ruin", "forest", "snow", "desert", "mountain", "fire", "sky", "dark"}:
        return "dungeon", "reconstructed environment family from canonical metadata"
    if cardinal_count or warp_count:
        return "connector", "proved outgoing topology without stronger semantic family"
    return "special", "no stronger source-backed category; special remains conservative"


def connected_walkable_components(map_data: dict[str, Any]) -> tuple[int, int]:
    width, height = map_data["max_x"] + 1, map_data["max_y"] + 1
    blocked = {
        (tile["x"], tile["y"]) for tile in map_data["tiles"]
        if tile["type"] in DEFINITE_BLOCK_TYPES
    }
    remaining = {(x, y) for x in range(width) for y in range(height)} - blocked
    sizes = []
    while remaining:
        start = remaining.pop()
        queue = deque([start])
        size = 1
        while queue:
            x, y = queue.popleft()
            for point in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
                if point in remaining:
                    remaining.remove(point)
                    queue.append(point)
                    size += 1
        sizes.append(size)
    return len(sizes), max(sizes, default=0)


def choose_tex_size(
    map_data: dict[str, Any], category: str, interaction_count: int,
    animation_count: int, warp_count: int,
) -> tuple[int, list[str]]:
    """Choose PMDO visual-cell granularity, never global pixel scaling."""
    width, height = map_data["max_x"] + 1, map_data["max_y"] + 1
    area = width * height
    reasons = ["source physical pixel footprint remains 1:1; no image interpolation"]
    if category == "settlement" or len(map_data["npcs"]) >= 8 or warp_count >= 8:
        reasons.append("fine 8 px cells preserve dense anchors, actors and building-edge editability")
        return 1, reasons
    if category == "indoor" or area <= 625 or interaction_count >= 10:
        reasons.append("16 px cells balance interior editability with complete 32 px source-element reconstruction")
        return 2, reasons
    if not animation_count and not interaction_count and not map_data["npcs"]:
        reasons.append("sparse noninteractive scene can retain atomic 32 px visual elements")
        return 4, reasons
    reasons.append("16 px cells preserve layer/animation editing without imposing settlement-level granularity")
    return 2, reasons


def dirty_ground_paths(repo_root: Path) -> set[str]:
    result = subprocess.run(
        ["git", "diff", "--name-only", "HEAD", "--", "Data/Ground"],
        cwd=repo_root, text=True, stdout=subprocess.PIPE, check=True,
    )
    return {line.strip() for line in result.stdout.splitlines() if line.strip()}


def reference_catalog(repo_root: Path) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    dirty = dirty_ground_paths(repo_root)
    rows = []
    skipped = []
    for path in sorted((repo_root / "Data/Ground").glob("*.rsground")):
        relative = path.relative_to(repo_root).as_posix()
        if relative in dirty:
            skipped.append({"path": relative, "reason": "dirty concurrent worktree file excluded from deterministic reference authority"})
            continue
        try:
            ground = read_json(path)["Object"]
        except (OSError, UnicodeError, json.JSONDecodeError, KeyError) as exc:
            skipped.append({"path": relative, "reason": f"unreadable: {type(exc).__name__}"})
            continue
        asset = str(ground.get("AssetName") or path.stem)
        name_value = ground.get("Name", {})
        name = name_value.get("DefaultText", "") if isinstance(name_value, dict) else str(name_value)
        text = f"{asset} {name}"
        if any(part in text.casefold() for part in FORBIDDEN_REFERENCE_PARTS):
            skipped.append({"path": relative, "reason": "test/debug/harness reference forbidden"})
            continue
        obstacles = ground.get("obstacles") or []
        width = len(obstacles)
        height = len(obstacles[0]) if width else 0
        sheets = sorted({
            frame.get("Sheet") for layer in ground.get("Layers", [])
            for column in layer.get("Tiles", []) for cell in column
            for tile_layer in cell.get("Layers", []) for frame in tile_layer.get("Frames", [])
            if frame.get("Sheet")
        })
        rows.append({
            "asset": asset, "name": name, "path": relative, "sha256": sha256_file(path),
            "tags": sorted(tags_for(text)), "tex_size": ground.get("TexSize"),
            "collision_dimensions_8px": [width, height],
            "physical_dimensions_px": [width * 8, height * 8],
            "layer_count": len(ground.get("Layers", [])), "sheets": sheets,
            "role": "visual grammar evidence only; source layout and entities are never copied",
        })
    authority = {
        "git_ref": "HEAD", "dirty_ground_count_excluded": len(dirty),
        "reference_count": len(rows), "skipped": skipped,
    }
    return rows, authority


def score_references(
    source_tags: set[str], category: str, source_px: tuple[int, int],
    references: list[dict[str, Any]], limit: int = 5,
) -> list[dict[str, Any]]:
    scored = []
    category_tags = {
        "settlement": {"settlement"}, "indoor": {"indoor"},
        "dungeon": source_tags - {"settlement", "indoor"},
        "connector": source_tags, "special": source_tags,
    }[category]
    source_area = max(1, source_px[0] * source_px[1])
    for reference in references:
        ref_tags = set(reference["tags"])
        shared = source_tags & ref_tags
        score = len(shared) * 10
        score += len(category_tags & ref_tags) * 6
        if category == "settlement" and "settlement" in ref_tags:
            score += 12
        if category == "indoor" and "indoor" in ref_tags:
            score += 12
        if not score:
            continue
        ref_px = reference["physical_dimensions_px"]
        ref_area = max(1, ref_px[0] * ref_px[1])
        size_penalty = min(8.0, abs(math.log2(ref_area / source_area)))
        final = round(score - size_penalty, 4)
        scored.append((final, reference, shared, size_penalty))
    ordered = sorted(scored, key=lambda item: (-item[0], item[1]["asset"]))
    selected = ordered[: min(3, limit)]
    selected_assets = {item[1]["asset"] for item in selected}
    # Generic town references must not crowd out an environment-specific grammar.
    # Add the strongest candidate for each uncovered source style, while retaining
    # explicit multi-reference compatibility as a later gate.
    covered = set().union(*(item[2] for item in selected)) if selected else set()
    for tag in sorted(source_tags - covered):
        candidate = next((item for item in ordered if tag in item[2] and item[1]["asset"] not in selected_assets), None)
        if candidate is not None and len(selected) < limit:
            selected.append(candidate)
            selected_assets.add(candidate[1]["asset"])
            covered.update(candidate[2])
    output = []
    for score, ref, shared, penalty in selected:
        output.append({
            "asset": ref["asset"], "path": ref["path"], "sha256": ref["sha256"],
            "score": score, "shared_style_tags": sorted(shared), "size_penalty": round(penalty, 4),
            "usage_contract": "learn local visual grammar/components only; never copy its layout, camera, dimensions or actors",
        })
    return output


def layer_plan(map_data: dict[str, Any]) -> list[dict[str, Any]]:
    result = []
    for base, base_set, animated, animated_set in (
        ("ground", "ground_tileset", "ground_anim", "ground_anim_tileset"),
        ("mask", "mask_tileset", "mask_anim", "mask_anim_tileset"),
        ("mask2", "mask2_tileset", "mask2_anim", "mask2_anim_tileset"),
        ("fringe", "fringe_tileset", "fringe_anim", "fringe_anim_tileset"),
        ("fringe2", "fringe2_tileset", "fringe2_anim", "fringe2_anim_tileset"),
    ):
        base_count = sum(tile[base] != 0 for tile in map_data["tiles"])
        animation_count = sum(tile[animated] != 0 for tile in map_data["tiles"])
        sets = sorted({tile[base_set] for tile in map_data["tiles"] if tile[base]} | {tile[animated_set] for tile in map_data["tiles"] if tile[animated]})
        result.append({
            "source_layer": base, "source_cell_count": base_count,
            "animated_replacement_count": animation_count, "source_tilesets": sets,
            "target_role": "PMDO_NATIVE_LAYER_RECOMPOSITION",
            "rule": "resolve source element roles against selected PMDO grammar while preserving anchors and z-order",
        })
    return result


def plan_map(
    entry: dict[str, Any], map_data: dict[str, Any], references: list[dict[str, Any]],
    graph_edges: list[dict[str, Any]], seed: int,
) -> dict[str, Any]:
    width, height = map_data["max_x"] + 1, map_data["max_y"] + 1
    source_text = " ".join((map_data.get("name", ""), map_data.get("music", ""), str(map_data.get("weather", ""))))
    style_tags = tags_for(source_text)
    if map_data.get("indoors"):
        style_tags.add("indoor")
    category, category_evidence = source_category(map_data, style_tags)
    types = Counter(tile["type"] for tile in map_data["tiles"])
    warp_count = types[2]
    interaction_count = sum(count for tile_type, count in types.items() if tile_type in INTERACTION_TYPES)
    animation_count = sum(
        tile[field] != 0 for tile in map_data["tiles"]
        for field in ("ground_anim", "mask_anim", "mask2_anim", "fringe_anim", "fringe2_anim")
    )
    tex_size, tex_reasons = choose_tex_size(map_data, category, interaction_count, animation_count, warp_count)
    visual_subdivision = 4 // tex_size
    source_px = (width * 32, height * 32)
    refs = score_references(style_tags, category, source_px, references)
    covered_reference_tags = set().union(*(set(row["shared_style_tags"]) for row in refs)) if refs else set()
    missing_reference_tags = sorted(style_tags - covered_reference_tags)
    single_reference_complete = any(style_tags <= set(row["tags"]) for row in references if row["asset"] in {ref["asset"] for ref in refs}) if style_tags else bool(refs)
    definite = sum(count for tile_type, count in types.items() if tile_type in DEFINITE_BLOCK_TYPES)
    conditional = sum(count for tile_type, count in types.items() if tile_type in CONDITIONAL_BLOCK_TYPES)
    component_count, largest_component = connected_walkable_components(map_data)
    unknown_values = sorted(tile_type for tile_type in types if tile_type not in range(40))
    source_partial = entry["status"] == "PARTIAL"
    partial_reasons = list(entry.get("certification", {}).get("partial_reasons", []))
    blockers = []
    if not refs:
        blockers.append("no semantically matching clean PMDO grammar reference; visual family UNVERIFIED")
    elif missing_reference_tags:
        blockers.append(f"no clean PMDO grammar reference covers source style tags {missing_reference_tags}")
    elif len(style_tags) > 1 and not single_reference_complete:
        blockers.append("required style families exist only in separate references; visual compatibility is UNVERIFIED and may not be mixed")
    if unknown_values:
        blockers.append(f"source tile semantics UNKNOWN for values {unknown_values}")
    if conditional:
        blockers.append("conditional PMU collision requires PMDO runtime behavior adapter, not a permanent obstacle")
    plan_status = "PLAN_READY" if not blockers else "ADAPTATION_REQUIRED"
    outgoing = sorted(
        graph_edges,
        key=lambda edge: (edge["kind"], edge["target"], edge.get("source_x", -1), edge.get("source_y", -1)),
    )
    cardinal = {
        direction: (f"s{map_data[key]}" if (map_data.get(key) or 0) > 0 else None)
        for direction, key in (("up", "up_map"), ("down", "down_map"), ("left", "left_map"), ("right", "right_map"))
    }
    return {
        "schema": "new-era.pmu-pmdo-adaptation-plan.v1",
        "map_id": map_data["map_id"], "name": map_data.get("name", ""),
        "seed": seed, "status": plan_status, "final_certification": "NOT_STARTED",
        "phase_gate": {
            "status": "PASS", "scope": "SOURCE_CERTIFIED public SQL snapshot only",
            "source_manifest_status": entry["status"], "source_partial": source_partial,
            "source_partial_reasons": partial_reasons,
            "blocked_v9_data_consumed": False,
        },
        "immutable_source": {
            "canonical_ir": entry["canonical_source"],
            "canonical_ir_json_sha256": entry["canonical_json_sha256"],
            "source_png": entry.get("source_png"), "source_png_sha256": entry.get("source_png_sha256"),
            "dimensions_tiles": [width, height], "dimensions_px": list(source_px),
            "tile_size_px": 32, "selected_source": entry["selected_source"],
            "write_policy": "READ_ONLY_NEVER_OVERWRITE",
        },
        "classification": {
            "category": category, "category_status": "RECONSTRUCTED",
            "evidence": category_evidence, "style_tags": sorted(style_tags),
            "style_status": "RECONSTRUCTED" if style_tags else "UNVERIFIED",
        },
        "target_geometry": {
            "physical_scale": [1, 1],
            "physical_dimensions_px": list(source_px),
            "pmdo_tex_size": tex_size, "pmdo_visual_cell_px": tex_size * 8,
            "pmdo_visual_grid": [width * visual_subdivision, height * visual_subdivision],
            "pmdo_collision_cell_px": 8, "pmdo_collision_grid": [width * 4, height * 4],
            "source_tile_subdivision": [visual_subdivision, visual_subdivision],
            "decision_reasons": tex_reasons,
            "camera_viewport_zoom": "MAP_LOCAL_UNSET; never inherited from another map",
            "interpolation": "FORBIDDEN",
        },
        "topology": {
            "walkable_component_count_static": component_count,
            "largest_walkable_component_tiles": largest_component,
            "cardinal_connections": cardinal, "outgoing_edges": outgoing,
            "preservation_contract": "anchors, route connectivity, empty space and relative composition must survive adaptation",
        },
        "layers": layer_plan(map_data),
        "animation": {
            "classification": "ANIMATED" if animation_count else "STATIC",
            "replacement_reference_count": animation_count,
            "source_state_duration_ms": 250, "source_period_ms": 500,
            "pmdo_frame_length_at_60hz": 15,
            "conversion": "native PMDO frames per reconstructed element; never flatten to source.png",
        },
        "collision": {
            "definite_block_source_tiles": definite,
            "definite_block_types": DEFINITE_BLOCK_TYPES,
            "conditional_block_source_tiles": conditional,
            "conditional_block_types": CONDITIONAL_BLOCK_TYPES,
            "unknown_type_values": unknown_values,
            "static_obstacle_policy": "only source-proven definite blocks become permanent PMDO obstacles",
            "conditional_policy": "runtime adapter required; preserve payload in sidecar until proven",
        },
        "actors_objects_events": {
            "npc_presets": len(map_data.get("npcs", [])),
            "npc_initial_orientation": "RUNTIME_RANDOM_CARDINAL with deterministic PMDO seeded RNG",
            "interaction_tile_count": interaction_count, "warp_tile_count": warp_count,
            "actor_policy": "functional presets become native MapChars only after species, behavior and event mapping; decorative layer graphics stay tiles",
            "language_policy": "French EU in-game text; original source strings remain provenance sidecars",
        },
        "visual_grammar_references": refs,
        "reference_status": {
            "status": "RECONSTRUCTED_CANDIDATES" if refs else "UNVERIFIED",
            "covered_style_tags": sorted(covered_reference_tags),
            "missing_style_tags": missing_reference_tags,
            "single_reference_complete": single_reference_complete,
            "multi_reference_mixing": "UNVERIFIED" if len(refs) > 1 else "NOT_APPLICABLE",
        },
        "forbidden_shortcuts": [
            "source PNG as Ground layer or map image", "global image resize/interpolation",
            "copying a PMDO reference layout", "global Metano skin/TexSize/viewport",
            "inventing unknown semantics or computed destinations",
        ],
        "required_outputs": {
            "ground": f"candidates/{map_data['map_id']}/pmu_{map_data['map_id']}.rsground",
            "pmdo_png": f"candidates/{map_data['map_id']}/pmdo.png",
            "comparison": f"candidates/{map_data['map_id']}/comparison.json",
            "runtime_report": f"candidates/{map_data['map_id']}/runtime/runtime_report.json",
            "status": "NOT_GENERATED",
        },
        "adaptation_blockers": blockers,
    }


def build_plans(repo_root: Path, source_root: Path, output_root: Path, reports_root: Path, seed: int = 20260814) -> dict[str, Any]:
    certification = read_json(source_root / "certification-report.json")
    if certification.get("status") != "SOURCE_CERTIFIED" or certification.get("failure_count") != 0:
        raise ValueError("phase 2 requires a zero-failure SOURCE_CERTIFIED phase-1 snapshot")
    global_manifest = read_json(source_root / "global-manifest.json")
    if global_manifest.get("canonical_sql_snapshot_status") != "SOURCE_CERTIFIED" or global_manifest.get("map_count") != 2000:
        raise ValueError("phase-1 global manifest does not authorize the 2,000-map SQL snapshot")
    graph = read_json(source_root / "source/connection-graph.json")
    edges_by_source: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for edge in graph["edges"]:
        edges_by_source[edge["source"]].append(edge)
    references, reference_authority = reference_catalog(repo_root)
    plans_dir = output_root / "plans"
    plans_dir.mkdir(parents=True, exist_ok=True)
    entries = []
    status_counts = Counter()
    tex_counts = Counter()
    category_counts = Counter()
    animated = 0
    total_refs = 0
    for index, entry in enumerate(global_manifest["maps"], 1):
        map_data = read_ir(Path(entry["canonical_source"]))
        plan = plan_map(entry, map_data, references, edges_by_source[entry["map_id"]], seed + index)
        path = plans_dir / f"{entry['map_id']}.json"
        write_json(path, plan)
        digest = sha256_file(path)
        status_counts[plan["status"]] += 1
        tex_counts[plan["target_geometry"]["pmdo_tex_size"]] += 1
        category_counts[plan["classification"]["category"]] += 1
        animated += plan["animation"]["classification"] == "ANIMATED"
        total_refs += len(plan["visual_grammar_references"])
        entries.append({
            "map_id": plan["map_id"], "name": plan["name"], "status": plan["status"],
            "category": plan["classification"]["category"],
            "style_tags": plan["classification"]["style_tags"],
            "pmdo_tex_size": plan["target_geometry"]["pmdo_tex_size"],
            "target_visual_grid": plan["target_geometry"]["pmdo_visual_grid"],
            "target_collision_grid": plan["target_geometry"]["pmdo_collision_grid"],
            "reference_count": len(plan["visual_grammar_references"]),
            "blocker_count": len(plan["adaptation_blockers"]),
            "plan": str(path), "plan_sha256": digest,
            "ground_status": "NOT_GENERATED", "runtime_status": "NOT_RUN",
        })
    global_plan = {
        "schema": "new-era.pmu-pmdo-adaptation-global-plan.v1",
        "status": "PHASE2_PLANNED", "final_certification": "NOT_STARTED",
        "seed": seed, "phase1_gate": "PASS", "map_count": len(entries),
        "scope": "source-certified public SQL snapshot s1-s2000; no blocked V9 content",
        "status_counts": dict(status_counts), "tex_size_counts": {str(k): v for k, v in sorted(tex_counts.items())},
        "category_counts": dict(category_counts), "animated_map_count": animated,
        "visual_reference_catalog": reference_authority,
        "visual_reference_assignment_count": total_refs,
        "ground_count": 0, "pmdo_runtime_validated_count": 0, "certified_count": 0,
        "silversail": {"status": "UNKNOWN", "plan_generated": False, "reason": "no canonical phase-1 ID"},
        "maps": entries,
    }
    write_json(output_root / "global-adaptation-plan.json", global_plan)
    reports_root.mkdir(parents=True, exist_ok=True)
    tracked = dict(global_plan)
    tracked["maps"] = entries
    write_json(reports_root / "adaptation-plan-index.json", tracked)
    summary = {
        key: global_plan[key] for key in (
            "schema", "status", "final_certification", "seed", "phase1_gate", "map_count", "scope",
            "status_counts", "tex_size_counts", "category_counts", "animated_map_count",
            "visual_reference_assignment_count", "ground_count", "pmdo_runtime_validated_count", "certified_count", "silversail",
        )
    }
    summary["reference_catalog"] = reference_authority
    write_json(reports_root / "adaptation-plan-summary.json", summary)
    lines = [
        "# PMU → PMDO — plan d’adaptation intelligent", "",
        f"- **Gate phase 1 :** `{global_plan['phase1_gate']}`",
        f"- **État phase 2 :** `{global_plan['status']}`",
        f"- **Maps planifiées :** {global_plan['map_count']}",
        f"- **Grounds générés :** {global_plan['ground_count']}",
        f"- **Grounds validés runtime :** {global_plan['pmdo_runtime_validated_count']}",
        f"- **Grounds certifiés :** {global_plan['certified_count']}",
        f"- **Profils TexSize locaux :** {dict(sorted(tex_counts.items()))}",
        f"- **Catégories reconstruites :** {dict(category_counts)}", "",
        "## Ce que ce plan interdit", "",
        "- aucune utilisation du PNG source comme image de map PMDO ;",
        "- aucune interpolation ou mise à l’échelle globale ;",
        "- aucune copie de layout depuis Metano ou un autre Ground ;",
        "- aucun viewport, zoom, `TexSize` ou skin global ;",
        "- aucune invention pour les types 101/103, les destinations calculées ou Silversail.", "",
        "## Contrat géométrique", "",
        "Chaque map conserve son empreinte physique source tant qu’une transformation différente n’est pas justifiée localement. Les éléments 32 px sont reconstruits sur une grille PMDO de 8, 16 ou 32 px choisie par map. La collision reste une grille native de 8 px. Les bâtiments, routes, respirations, warps, NPC et autres anchors doivent conserver leurs relations topologiques ; une référence PMDO ne fournit que sa grammaire visuelle locale, jamais son layout.", "",
        "## État honnête", "",
        "Ce livrable commence la phase 2 de façon exhaustive, mais ne prétend pas l’avoir terminée : aucun `.rsground` n’est émis par le planner. Un Ground mécanique source-looking serait précisément le faux résultat interdit. Chaque map reste `NOT_GENERATED` jusqu’à résolution de sa composition native, puis devra passer le vrai runtime PMDO 0.8.12 via la méthode headless d’Agent A.", "",
        "## Cibles critiques", "",
        "- Grassroot : plans `s737` et `s1810` ;",
        "- Snowbasin : plan `s1991` ;",
        "- Silversail : `UNKNOWN`, aucun plan ni image substituée.", "",
    ]
    (reports_root / "adaptation-plan-summary.md").write_text("\n".join(lines), encoding="utf-8", newline="\n")
    hashes = []
    for path in sorted(reports_root.glob("*")):
        if path.is_file() and path.name != "artifact-hashes.sha256":
            hashes.append(f"{sha256_file(path)}  {path.name}")
    (reports_root / "artifact-hashes.sha256").write_text("\n".join(hashes) + "\n", encoding="utf-8", newline="\n")
    return global_plan
