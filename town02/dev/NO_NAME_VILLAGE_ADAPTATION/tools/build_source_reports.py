#!/usr/bin/env python3
from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import shutil
from collections import Counter
from pathlib import Path
from typing import Any


def read(path: Path) -> Any: return json.loads(path.read_text(encoding="utf-8"))
def read_gzip(path: Path) -> Any:
    with gzip.open(path, "rt", encoding="utf-8") as stream: return json.load(stream)
def write(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True); path.write_text(json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
def sha(path: Path) -> str: return hashlib.sha256(path.read_bytes()).hexdigest()


def build(extracted: Path, renders: Path, reports: Path) -> dict[str, Any]:
    global_ir = read(extracted / "global-ir.json")
    objects = read(extracted / "inventories/objects.json")
    sprites = read(extracted / "inventories/sprites.json")
    sounds = read(extracted / "inventories/sounds.json")
    tilesets = read(extracted / "inventories/tilesets.json")
    seasons = read(extracted / "inventories/seasons.json")
    object_by_id = {row["id"]: row for row in objects}
    rooms = []
    transition_rows = []
    collision_total = 0
    season_counts = Counter()
    layer_types = Counter()
    for entry in global_ir["rooms"]:
        room = read_gzip(Path(entry["ir"]))
        names = Counter(instance["object_name"] for instance in room["instances"])
        transitions = [instance for instance in room["instances"] if instance["object_name"] in {"objtransit", "objdoor"}]
        spawns = [instance for instance in room["instances"] if "spawn" in instance["object_name"].casefold()]
        houses = [instance for instance in room["instances"] if "house" in instance["object_name"].casefold()]
        collision = [instance for instance in room["instances"] if object_by_id.get(instance["object_id"], {}).get("solid")]
        collision_total += len(collision)
        season_counts.update(room["season_instance_counts"])
        layer_types.update(str(layer["type"]) for layer in room["layers"])
        category = "system" if room["name"].startswith("Room_Steam") or room["name"] in {"mainmenu", "rmempty", "rmcalendar"} else "interior" if room["dimensions_px"][0] < 4992 else "cave" if "cave" in room["name"] else "world"
        row = {
            **{key: entry[key] for key in ("id", "name", "dimensions_px", "layer_count", "layer_types", "instance_count", "season_instance_counts", "ir", "ir_json_sha256")},
            "category": category, "transition_count": len(transitions), "spawn_count": len(spawns),
            "house_instance_count": len(houses), "solid_collision_instance_count": len(collision),
            "transitions": [{key: value for key, value in instance.items() if key in {"instance_id", "object_name", "x", "y", "scale", "creation_code_id"}} for instance in transitions],
            "spawns": [{key: value for key, value in instance.items() if key in {"instance_id", "object_name", "x", "y", "creation_code_id"}} for instance in spawns],
            "houses": [{key: value for key, value in instance.items() if key in {"instance_id", "object_name", "x", "y", "creation_code_id"}} for instance in houses],
            "layer_names": [layer["name"] for layer in room["layers"]],
        }
        rooms.append(row)
        for transition in row["transitions"]: transition_rows.append({"room_id": row["id"], "room": row["name"], **transition, "destination": "UNVERIFIED_BYTECODE"})
    village = next(row for row in rooms if row["name"] == "rmvillage")
    animated_sprites = [row for row in sprites if row["frame_count"] > 1]
    animated_tilesets = [row for row in tilesets if row["frames_per_tile"] > 1]
    season_mapping = {}
    names = {row["name"] for row in objects}
    for row in objects:
        if row["season_family"] != "spring": continue
        suffix = row["name"][len("objsp"):]
        season_mapping[row["name"]] = {season: (("objsp" if season == "spring" else {"summer":"objsm","autumn":"objau","winter":"objwn"}[season]) + suffix if (("objsp" if season == "spring" else {"summer":"objsm","autumn":"objau","winter":"objwn"}[season]) + suffix) in names else None) for season in ("spring", "summer", "autumn", "winter")}
    for generic in ("objtree", "objtree0"):
        if generic in names:
            suffix = generic[len("obj"):]
            season_mapping[generic] = {"spring": generic, "summer": "objsm" + suffix, "autumn": "objau" + suffix, "winter": "objwn" + suffix}
    season_report = {
        "schema": "no-name-village.seasons.v1", "status": "SOURCE_PROVEN_PARTIAL_VM_LOGIC",
        "states": ["spring", "summer", "autumn", "winter"], "global_variable": "season",
        "scripts": global_ir["season_system"]["selection_scripts"],
        "seasonal_objects": seasons["objects"], "seasonal_sprites": seasons["sprites"],
        "object_correspondence": season_mapping, "room_instance_counts": dict(season_counts),
        "runtime_controllers": [row for row in objects if row["name"] in {"objwinter", "objcutsnow", "objcutpostsummer"}],
        "limitations": [
            "GameMaker VM bytecode is preserved but the audited Python decoder does not correctly decompile this runtime version.",
            "Object substitution families are source-proven by complete resource counterparts; exact branch ordering remains UNVERIFIED.",
            "Winter post-processing/ground snow and particles require controller-bytecode decompilation before PMDO certification."
        ],
    }
    write(reports / "season-system.json", season_report)
    write(reports / "room-index.json", rooms)
    write(reports / "connection-evidence.json", {"status": "PARTIAL", "edge_count": len(transition_rows), "edges": transition_rows})
    preview_dir = reports / "source-previews"; preview_dir.mkdir(parents=True, exist_ok=True)
    previews = []
    for name in ("rmvillage-spring.png", "rmvillage-summer.png", "rmvillage-autumn.png", "rmvillage-winter.png", "rmvillage-seasons.png", "interiors.png"):
        source = renders / name
        if source.exists():
            destination = preview_dir / name; shutil.copyfile(source, destination)
            previews.append({"file": str(destination), "sha256": sha(destination), "bytes": destination.stat().st_size, "role": "source reconstruction audit only; never PMDO map texture"})
    summary = {
        "schema": "no-name-village.source-summary.v1", "status": "SOURCE_STRUCTURALLY_EXTRACTED",
        "source": global_ir["source"], "runtime_family": global_ir["runtime_family"],
        "counts": global_ir["counts"], "room_categories": dict(Counter(row["category"] for row in rooms)),
        "layer_type_counts": dict(layer_types), "solid_collision_instance_count": collision_total,
        "transition_instance_count": len(transition_rows), "animated_sprite_count": len(animated_sprites),
        "animated_tileset_count": len(animated_tilesets), "maximum_sprite_frame_count": max(row["frame_count"] for row in sprites),
        "village": village, "season_system": {"status": season_report["status"], "states": season_report["states"], "mapping_count": len(season_mapping)},
        "sounds": {"count": len(sounds), "named_music_candidates": [row for row in sounds if any(word in row["name"].casefold() for word in ("music", "bgm", "theme", "village", "forest"))]},
        "day_night": global_ir["day_night"], "previews": previews,
        "phase2_pmdo": "BLOCKED until source rendering, season VM logic, collision and transition destinations are completely certified",
    }
    write(reports / "source-summary.json", summary)
    lines = [
        "# No Name Village — audit source GameMaker", "",
        f"- **État :** `{summary['status']}`", f"- **Rooms :** {summary['counts']['rooms']}",
        f"- **Room principale :** `rmvillage`, {village['dimensions_px'][0]}×{village['dimensions_px'][1]} px, {village['layer_count']} layers, {village['instance_count']} instances",
        f"- **Objets :** {summary['counts']['objects']}", f"- **Sprites :** {summary['counts']['sprites']} ({summary['animated_sprite_count']} animés)",
        f"- **Tilesets :** {summary['counts']['tilesets']} ({summary['animated_tileset_count']} animés)",
        f"- **Sons :** {summary['counts']['sounds']}", f"- **Colliders solides placés :** {summary['solid_collision_instance_count']}",
        f"- **Transitions/portes placées :** {summary['transition_instance_count']}", "",
        "## Saisons", "",
        "Le système quatre saisons est réel : variable `season`, scripts `scrseasonmap`/compteurs saisonniers, familles complètes d’objets et sprites, contrôleurs hiver/neige et substitutions d’arbres/plantes. Les quatre variantes de `rmvillage` sont reconstruites depuis les layers, tilesets et instances — pas depuis une capture.", "",
        "La logique VM exacte de post-traitement hiver reste `UNVERIFIED`; aucune conversion PMDO ne sera certifiée avant sa résolution.", "",
        "## Village", "",
        f"- Layers : {', '.join(village['layer_names'])}",
        f"- Portes/transitions : {village['transition_count']}", f"- Spawn points : {village['spawn_count']}",
        f"- Maisons : {village['house_instance_count']}", f"- Colliders solides : {village['solid_collision_instance_count']}", "",
        "## Frontière PMDO", "",
        "Aucun `.rsground` n’est encore produit. Le prochain gate doit résoudre les destinations de chaque RoomCC, la logique saisonnière VM, les effets neige/jour-nuit et le rendu exhaustif des 98 rooms avant adaptation des bâtiments PMU.", "",
    ]
    (reports / "source-summary.md").write_text("\n".join(lines), encoding="utf-8")
    hash_path = reports / "artifact-hashes.sha256"
    hashes = []
    for path in sorted(reports.rglob("*")):
        if path.is_file() and path != hash_path:
            hashes.append(f"{sha(path)}  {path.relative_to(reports).as_posix()}")
    hash_path.write_text("\n".join(hashes) + "\n", encoding="utf-8")
    return summary


def main() -> int:
    parser = argparse.ArgumentParser(); parser.add_argument("--extracted", type=Path, required=True); parser.add_argument("--renders", type=Path, required=True); parser.add_argument("--reports", type=Path, required=True)
    args = parser.parse_args(); result = build(args.extracted.resolve(), args.renders.resolve(), args.reports.resolve()); print(json.dumps({"status": result["status"], "rooms": result["counts"]["rooms"], "seasons": result["season_system"]}, sort_keys=True)); return 0
if __name__ == "__main__": raise SystemExit(main())
