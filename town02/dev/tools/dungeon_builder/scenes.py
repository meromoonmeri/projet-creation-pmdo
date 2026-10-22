"""Canonical scene resolution: cinematic Ground = battle Ground = end Ground.

Authoritative source: `docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md`, the
project's own inventory of the 245 converted PMD Red Grounds, which records for
every GBA dungeon its ENTRY / RELAY / END-or-ARENA Ground.

The rule this module enforces:

* when a canonical scene exists for a boss/legendary, that single Ground hosts
  the whole sequence — arrival, cutscene, dialogue, battle trigger, battle,
  aftermath.  No teleport to a separate arena, ever;
* a canonical scene available only as a `.rsmap` must *become* that Ground, it
  must not be used to build a second, different arena;
* a canonical scene still sitting in `RESERVE/` is not "missing": it is
  `REQUIRES_INTEGRATION` (restore it), and an arena is still forbidden;
* `arena_rsmap` is legal only when the inventory has no scene at all.
"""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Tuple

ROOT = Path(__file__).resolve().parents[2]
INVENTORY = ROOT / "docs" / "INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md"
GROUND_DIR = ROOT / "Data" / "Ground"
MAP_DIR = ROOT / "Data" / "Map"
RESERVE_DIR = ROOT / "RESERVE"

ACTIVE_GROUND = "ACTIVE_GROUND"
ACTIVE_RSMAP = "ACTIVE_RSMAP"
ARCHIVED = "ARCHIVED"
NONE = "NONE"


@dataclass
class SceneAsset:
    name: str
    state: str = NONE
    location: str = ""

    @property
    def exists(self) -> bool:
        return self.state != NONE


@dataclass
class DungeonScenes:
    dungeon: str
    code: str = ""          # GBA dungeon code (D01…D25) used by the cinematic archives
    boss: str = ""
    entrance: Optional[SceneAsset] = None
    relay: Optional[SceneAsset] = None
    end: List[SceneAsset] = field(default_factory=list)

    @property
    def canonical_end(self) -> Optional[SceneAsset]:
        for asset in self.end:
            if asset.state == ACTIVE_GROUND:
                return asset
        for asset in self.end:
            if asset.state in (ACTIVE_RSMAP, ARCHIVED):
                return asset
        return self.end[0] if self.end else None

    def to_dict(self) -> Dict[str, object]:
        return {
            "dungeon": self.dungeon,
            "code": self.code,
            "boss": self.boss,
            "entrance": self.entrance.__dict__ if self.entrance else None,
            "relay": self.relay.__dict__ if self.relay else None,
            "end": [asset.__dict__ for asset in self.end],
        }


def locate(name: str) -> SceneAsset:
    """Where does this scene asset live today? (aliases included)"""
    if not name:
        return SceneAsset(name, NONE, "")
    for alias in SCENE_ALIASES.get(name, ()):  # the mod may have renamed it
        if (GROUND_DIR / f"{alias}.rsground").exists():
            return SceneAsset(alias, ACTIVE_GROUND, f"Data/Ground/{alias}.rsground")
        if (MAP_DIR / f"{alias}.rsmap").exists():
            return SceneAsset(alias, ACTIVE_RSMAP, f"Data/Map/{alias}.rsmap")
    if (GROUND_DIR / f"{name}.rsground").exists():
        return SceneAsset(name, ACTIVE_GROUND, f"Data/Ground/{name}.rsground")
    if (MAP_DIR / f"{name}.rsmap").exists():
        return SceneAsset(name, ACTIVE_RSMAP, f"Data/Map/{name}.rsmap")
    for folder in sorted(RESERVE_DIR.glob("*")):
        if not folder.is_dir():
            continue
        for suffix in (".rsground", ".rsmap"):
            candidate = folder / f"{name}{suffix}"
            if candidate.exists():
                return SceneAsset(name, ARCHIVED, str(candidate.relative_to(ROOT)))
    return SceneAsset(name, NONE, "")


def _clean(cell: str) -> List[str]:
    names: List[str] = []
    for token in re.findall(r"`([a-z0-9_]+)`", cell):
        names.append(token)
    return names


def parse_inventory(path: Optional[Path] = None) -> Dict[str, DungeonScenes]:
    """Read the PMD Red Ground inventory into `{english dungeon name: scenes}`."""
    path = Path(path or INVENTORY)
    scenes: Dict[str, DungeonScenes] = {}
    if not path.exists():
        return scenes
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.startswith("| **D"):
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        header = re.sub(r"\*\*", "", cells[0])
        match = re.match(r"(D\d+)\s+(.+)", header)
        if not match:
            continue
        code = match.group(1).strip()
        dungeon = match.group(2).strip()
        boss = re.sub(r"\*\*", "", cells[1]).strip(" —") if len(cells) > 1 else ""
        entry = DungeonScenes(dungeon=dungeon, code=code, boss=boss)
        if len(cells) == 5:            # section 1: entry | relay | end
            entry.entrance = locate(_clean(cells[2])[0]) if _clean(cells[2]) else None
            entry.relay = locate(_clean(cells[3])[0]) if _clean(cells[3]) else None
            entry.end = [locate(name) for name in _clean(cells[4])]
        elif len(cells) == 3:          # section 2: arena only
            entry.end = [locate(name) for name in _clean(cells[2])]
        scenes[dungeon] = entry
    return scenes


#: peak/pit sub-dungeons share the canonical scene of their parent dungeon:
#: the legendary's cutscene AND battle happen there, so no arena is created.
PARENT_SCENE = {
    "Mt. Thunder Peak": "Mt. Thunder",      # Zapdos  -> d06p03
    "Mt. Blaze Peak": "Mt. Blaze",          # Moltres -> d09p03
    "Frosty Grotto": "Frosty Forest",       # Articuno-> d10p03
    "Mt. Freeze Peak": "Mt. Freeze",        # Ninetales -> d11p03
    "Magma Cavern Pit": "Magma Cavern",     # Groudon -> fosse_ardente
    "Sky Tower Summit": "Sky Tower",        # Rayquaza -> tour_ciel_sommet
}

#: alternative names carried by the mod for a canonical scene
SCENE_ALIASES = {
    "tour_ciel_sommet": ("arc_tour_ciel_sommet", "sky_tower_summit"),
    "parvis_celeste": ("arc_parvis_celeste",),
    "palier_celeste": ("arc_palier_celeste",),
    "bois_sombres_fond": ("sinister_woods_clearing",),
    "bois_sombres_oree": ("gloomy_forest_entrance",),
}

#: roster english name -> inventory key, when they differ
INVENTORY_ALIASES = {}


def scenes_for(dungeon_name: str, inventory: Optional[Dict[str, DungeonScenes]] = None
               ) -> Optional[DungeonScenes]:
    """Canonical scenes of a dungeon, falling back to its parent location."""
    inventory = inventory if inventory is not None else parse_inventory()
    key = INVENTORY_ALIASES.get(dungeon_name, dungeon_name)
    lowered = {name.lower(): value for name, value in inventory.items()}
    found = inventory.get(key) or lowered.get(key.lower())
    if found is not None:
        return found
    parent = PARENT_SCENE.get(dungeon_name)
    if parent:
        return inventory.get(parent) or lowered.get(parent.lower())
    return None


def readiness(asset: Optional[SceneAsset]) -> Tuple[str, str]:
    """(status, blocking reason) for a canonical scene."""
    if asset is None or not asset.exists:
        return NONE, ""
    if asset.state == ACTIVE_GROUND:
        return ACTIVE_GROUND, ""
    if asset.state == ACTIVE_RSMAP:
        return ACTIVE_RSMAP, (f"REQUIRES_INTEGRATION: canonical scene '{asset.name}' exists as "
                              f"{asset.location}; convert this very map into the Ground that hosts "
                              "the cutscene and the battle (no separate arena)")
    return ARCHIVED, (f"REQUIRES_INTEGRATION: canonical scene '{asset.name}' is archived in "
                      f"{asset.location}; restore it as the cinematic/battle Ground "
                      "(no separate arena)")
