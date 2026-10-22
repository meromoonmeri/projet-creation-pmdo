"""Fixed dungeon rooms (`.rsmap`) produced from a validated boss-room template.

Some canonical bosses are fought **inside the dungeon**, on a fixed room, not on
a cutscene Ground — this is the case whenever `pret/pmd-red` scripts the fight
with in-dungeon dialogue and the PMD Red Ground archive holds no scene for that
dungeon (it only covers D01–D25).

This module clones a validated boss-room map (auto-tile based, with its entry
points, element and music), retextures it onto the dungeon's own tileset triplet
and writes it to `Data/Map`.  The room is then attached to a floor through
`fixed_floors`, so RogueEssence loads it with `LoadGen` + `MappedRoomStep`:
the fixed room stays *part of the dungeon run*, never a separate arena.
"""
from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

ROOT = Path(__file__).resolve().parents[2]
MAP_DIR = ROOT / "Data" / "Map"
MUSIC_DIR = ROOT / "Content" / "Music"

#: validated in-dungeon boss room used as the structural donor
DEFAULT_TEMPLATE = "cloven_ruins_regice"


@dataclass
class FixedRoomBuild:
    map_id: str
    template: str
    tileset: str
    width: int = 0
    height: int = 0
    retextured: int = 0
    entry_points: int = 0
    music: str = ""
    path: Optional[Path] = None
    problems: List[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.problems


def build_fixed_room(map_id: str, tileset: str, name: Dict[str, str],
                     template: str = DEFAULT_TEMPLATE, music: str = "",
                     element: str = "normal", comment: str = "",
                     map_dir: Optional[Path] = None, dry_run: bool = False) -> FixedRoomBuild:
    map_dir = map_dir or MAP_DIR
    build = FixedRoomBuild(map_id=map_id, template=template, tileset=tileset)

    source = map_dir / f"{template}.rsmap"
    if not source.exists():
        build.problems.append(f"template map '{template}.rsmap' not found")
        return build
    if music and not (MUSIC_DIR / music).exists():
        build.problems.append(f"music '{music}' missing from Content/Music")
        return build

    data = json.loads(source.read_text(encoding="utf-8-sig"))
    obj = data["Object"]

    roles = {"floor": f"{tileset}_floor", "wall": f"{tileset}_wall",
             "secondary": f"{tileset}_secondary"}

    def retexture(node: Any) -> None:
        if isinstance(node, dict):
            value = node.get("AutoTileset")
            if isinstance(value, str) and value:
                for role, target in roles.items():
                    if value.endswith(f"_{role}"):
                        node["AutoTileset"] = target
                        build.retextured += 1
                        break
            for child in node.values():
                retexture(child)
        elif isinstance(node, list):
            for child in node:
                retexture(child)

    retexture(obj)
    tiles = obj.get("Tiles", [])
    build.width = len(tiles)
    build.height = len(tiles[0]) if tiles else 0
    build.entry_points = len(obj.get("EntryPoints", []))
    if build.entry_points == 0:
        build.problems.append("the template has no entry point: the party could not enter")

    obj["AssetName"] = map_id
    obj["Name"] = {"DefaultText": name.get("en", map_id),
                   "LocalTexts": {k: v for k, v in name.items() if k != "en"}}
    obj["Element"] = element
    if music:
        obj["Music"] = music
        build.music = music
    obj["Comment"] = comment or (
        f"Salle fixe de donjon dérivée du template validé '{template}', retexturée avec "
        f"'{tileset}'. Chargée comme étage via LoadGen + MappedRoomStep : le combat canonique "
        "reste à l'intérieur du donjon.")

    build.path = map_dir / f"{map_id}.rsmap"
    if not dry_run:
        build.path.write_text("\ufeff" + json.dumps(data, ensure_ascii=False, indent=2),
                              encoding="utf-8")
    return build
