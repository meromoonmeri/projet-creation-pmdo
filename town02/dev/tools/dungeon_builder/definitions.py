"""Dungeon definitions: external data files loaded by the builder.

A definition lives outside the tool (`DungeonDefs/canonical/<id>.json`) so the
builder itself never hardcodes dungeon content.  Values cascade:

    dungeon defaults  ->  segment  ->  floor override

Anything omitted falls back to the RogueElements / PMDO defaults already used
by this repository's zones.
"""
from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence, Tuple

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_DEF_DIR = ROOT / "DungeonDefs" / "canonical"


class DefinitionError(ValueError):
    """Raised for any structurally invalid dungeon definition."""


# --------------------------------------------------------------------------
@dataclass
class ProfileChoice:
    name: str
    weight: int = 10
    overrides: Dict[str, Any] = field(default_factory=dict)


@dataclass
class MobEntry:
    species: str
    level: Tuple[int, int]
    weight: int = 10
    floors: Optional[Tuple[int, int]] = None
    tactic: str = "wander_normal"
    skills: Sequence[str] = ()
    features: Sequence[str] = ("weak",)


@dataclass
class ItemEntry:
    item: str
    weight: int = 10
    price: int = 0
    amount: int = 0
    floors: Optional[Tuple[int, int]] = None


@dataclass
class ItemTable:
    name: str
    amount: Tuple[int, int] = (2, 5)
    entries: List[ItemEntry] = field(default_factory=list)


@dataclass
class Features:
    shop: Dict[str, Any] = field(default_factory=dict)
    monster_house: Dict[str, Any] = field(default_factory=dict)
    treasure_room: Dict[str, Any] = field(default_factory=dict)
    key_room: Dict[str, Any] = field(default_factory=dict)
    weather: List[Dict[str, Any]] = field(default_factory=list)
    mystery: Dict[str, Any] = field(default_factory=dict)
    traps: Dict[str, Any] = field(default_factory=dict)

    @classmethod
    def from_json(cls, data: Dict[str, Any]) -> "Features":
        known = {f for f in cls.__dataclass_fields__}
        unknown = set(data) - known
        if unknown:
            raise DefinitionError(f"unknown feature keys: {sorted(unknown)}")
        return cls(**{k: data[k] for k in data})

    def merged(self, other: Optional["Features"]) -> "Features":
        if other is None:
            return self
        out = Features(**{k: getattr(self, k) for k in self.__dataclass_fields__})
        for key in self.__dataclass_fields__:
            val = getattr(other, key)
            if val:
                setattr(out, key, val)
        return out


@dataclass
class Segment:
    name: str
    floors: Tuple[int, int]                 # inclusive 1-based floor numbers
    biome: str = ""
    dtef: Dict[str, str] = field(default_factory=dict)
    music: str = ""
    profiles: List[ProfileChoice] = field(default_factory=list)
    mobs: List[MobEntry] = field(default_factory=list)
    inherit_mobs: bool = True
    item_tables: List[ItemTable] = field(default_factory=list)
    inherit_items: bool = True
    money: Tuple[int, int] = (0, 0)
    features: Optional[Features] = None
    stairs: Dict[str, Any] = field(default_factory=dict)
    max_foes: int = 0
    respawn_time: int = 0
    fixed_floors: Dict[int, Dict[str, str]] = field(default_factory=dict)
    floor_overrides: Dict[int, Dict[str, Any]] = field(default_factory=dict)

    @property
    def floor_numbers(self) -> List[int]:
        return list(range(self.floors[0], self.floors[1] + 1))

    @property
    def length(self) -> int:
        return self.floors[1] - self.floors[0] + 1


BOSS_MODES = ("canonical_ground", "arena_rsmap")


@dataclass
class DungeonDefinition:
    id: str
    name: Dict[str, str]
    chapter: int
    floors: int
    segments: List[Segment]
    source: str = ""
    route: str = "secondary"
    biome: str = ""
    music: str = ""
    dtef: Dict[str, str] = field(default_factory=dict)
    level: int = 1
    rescues: int = 2
    released: bool = True
    comment: str = ""
    profiles: List[ProfileChoice] = field(default_factory=list)
    mobs: List[MobEntry] = field(default_factory=list)
    item_tables: List[ItemTable] = field(default_factory=list)
    money: Tuple[int, int] = (100, 140)
    features: Features = field(default_factory=Features)
    stairs: Dict[str, Any] = field(default_factory=dict)
    fixed_grounds: Dict[str, str] = field(default_factory=dict)
    minibosses: List[Dict[str, Any]] = field(default_factory=list)
    boss: Dict[str, Any] = field(default_factory=dict)
    midpoint: Dict[str, Any] = field(default_factory=dict)
    variation: Dict[str, Any] = field(default_factory=dict)
    aliases: List[str] = field(default_factory=list)
    blocked: List[str] = field(default_factory=list)
    scenes: Dict[str, Any] = field(default_factory=dict)
    narrative: Dict[str, Any] = field(default_factory=dict)
    provenance: Dict[str, Any] = field(default_factory=dict)
    fixed_segments: List[Dict[str, Any]] = field(default_factory=list)
    path: Optional[Path] = None

    # -- cascade helpers ----------------------------------------------
    def segment_for_floor(self, floor: int) -> Segment:
        for seg in self.segments:
            if seg.floors[0] <= floor <= seg.floors[1]:
                return seg
        raise DefinitionError(f"floor {floor} of '{self.id}' belongs to no segment")

    def profiles_for(self, seg: Segment, floor: Optional[int] = None) -> List[ProfileChoice]:
        if floor is not None:
            override = seg.floor_overrides.get(floor, {})
            if override.get("profiles"):
                return list(override["profiles"])
        return seg.profiles or self.profiles

    def mobs_for(self, seg: Segment) -> List[MobEntry]:
        if seg.inherit_mobs:
            return list(self.mobs) + list(seg.mobs)
        return list(seg.mobs)

    def items_for(self, seg: Segment) -> List[ItemTable]:
        if seg.inherit_items:
            base = {t.name: t for t in self.item_tables}
            for table in seg.item_tables:
                base[table.name] = table
            return list(base.values())
        return list(seg.item_tables)

    def features_for(self, seg: Segment) -> Features:
        return self.features.merged(seg.features)

    def dtef_for(self, seg: Segment) -> Dict[str, str]:
        merged = dict(self.dtef)
        merged.update(seg.dtef or {})
        return merged

    def stairs_for(self, seg: Segment, floor: Optional[int] = None) -> Dict[str, Any]:
        merged = dict(self.stairs)
        merged.update(seg.stairs or {})
        if floor is not None:
            merged.update(seg.floor_overrides.get(floor, {}).get("stairs", {}))
        return merged


# --------------------------------------------------------------------------
def _tuple2(value, field_name: str) -> Tuple[int, int]:
    if not isinstance(value, (list, tuple)) or len(value) != 2:
        raise DefinitionError(f"'{field_name}' must be a [min, max] pair, got {value!r}")
    lo, hi = value
    if not isinstance(lo, int) or not isinstance(hi, int):
        raise DefinitionError(f"'{field_name}' must contain integers, got {value!r}")
    if hi < lo:
        raise DefinitionError(f"'{field_name}' has max < min: {value!r}")
    return int(lo), int(hi)


def _mob(data: Dict[str, Any]) -> MobEntry:
    for required in ("species", "level"):
        if required not in data:
            raise DefinitionError(f"pokemon entry missing '{required}': {data!r}")
    return MobEntry(
        species=str(data["species"]),
        level=_tuple2(data["level"], "pokemon.level"),
        weight=int(data.get("weight", 10)),
        floors=_tuple2(data["floors"], "pokemon.floors") if "floors" in data else None,
        tactic=str(data.get("tactic", "wander_normal")),
        skills=tuple(data.get("skills", ())),
        features=tuple(data.get("features", ("weak",))),
    )


def _item_table(name: str, data: Dict[str, Any]) -> ItemTable:
    entries = []
    for raw in data.get("entries", []):
        if "item" not in raw:
            raise DefinitionError(f"item entry missing 'item': {raw!r}")
        floors = (_tuple2(raw["floors"], f"item table '{name}' floors")
                  if "floors" in raw else None)
        entries.append(ItemEntry(str(raw["item"]), int(raw.get("weight", 10)),
                                 int(raw.get("price", 0)), int(raw.get("amount", 0)),
                                 floors))
    if not entries:
        raise DefinitionError(f"item table '{name}' has no entries")
    return ItemTable(name, _tuple2(data.get("amount", [2, 5]), "item_table.amount"), entries)


def _profiles(raw: Sequence[Any], where: str) -> List[ProfileChoice]:
    out = []
    for item in raw:
        if isinstance(item, str):
            out.append(ProfileChoice(item))
        elif isinstance(item, dict):
            if "name" not in item:
                raise DefinitionError(f"{where}: profile entry needs a 'name'")
            out.append(ProfileChoice(str(item["name"]), int(item.get("weight", 10)),
                                     dict(item.get("overrides", {}))))
        else:
            raise DefinitionError(f"{where}: invalid profile entry {item!r}")
    return out


def parse_definition(data: Dict[str, Any], path: Optional[Path] = None) -> DungeonDefinition:
    for required in ("id", "name", "chapter", "floors", "segments"):
        if required not in data:
            raise DefinitionError(f"definition missing required field '{required}'")

    floors = int(data["floors"])
    if floors < 1:
        raise DefinitionError("'floors' must be >= 1")

    name = data["name"]
    if isinstance(name, str):
        name = {"en": name}
    if "en" not in name:
        raise DefinitionError("'name' needs at least an 'en' entry")

    segments: List[Segment] = []
    for raw in data["segments"]:
        for required in ("name", "floors"):
            if required not in raw:
                raise DefinitionError(f"segment missing '{required}'")
        floor_overrides: Dict[int, Dict[str, Any]] = {}
        for floor_key, override_raw in raw.get("floor_overrides", {}).items():
            floor_id = int(floor_key)
            if not isinstance(override_raw, dict):
                raise DefinitionError(
                    f"segment '{raw['name']}' floor override {floor_key} must be an object")
            allowed = {"profiles", "stairs", "notes", "source_floor",
                       "item_amount", "initial_mobs", "trap_amount"}
            unknown = set(override_raw) - allowed
            if unknown:
                raise DefinitionError(
                    f"segment '{raw['name']}' floor override {floor_key}: unknown keys {sorted(unknown)}")
            floor_overrides[floor_id] = {
                "profiles": _profiles(override_raw.get("profiles", []),
                                      f"segment '{raw['name']}' floor {floor_id}"),
                "stairs": dict(override_raw.get("stairs", {})),
                "notes": str(override_raw.get("notes", "")),
                "source_floor": dict(override_raw.get("source_floor", {})),
                "item_amount": (_tuple2(override_raw["item_amount"], "floor.item_amount")
                                if "item_amount" in override_raw else None),
                "initial_mobs": (_tuple2(override_raw["initial_mobs"], "floor.initial_mobs")
                                 if "initial_mobs" in override_raw else None),
                "trap_amount": (_tuple2(override_raw["trap_amount"], "floor.trap_amount")
                                if "trap_amount" in override_raw else None),
            }
        seg = Segment(
            name=str(raw["name"]),
            floors=_tuple2(raw["floors"], "segment.floors"),
            biome=str(raw.get("biome", data.get("biome", ""))),
            dtef=dict(raw.get("dtef", {})),
            music=str(raw.get("music", "")),
            profiles=_profiles(raw.get("profiles", []), f"segment '{raw['name']}'"),
            mobs=[_mob(m) for m in raw.get("pokemon", [])],
            inherit_mobs=bool(raw.get("inherit_pokemon", True)),
            item_tables=[_item_table(k, v) for k, v in raw.get("items", {}).items()],
            inherit_items=bool(raw.get("inherit_items", True)),
            money=_tuple2(raw["money"], "segment.money") if "money" in raw else (0, 0),
            features=Features.from_json(raw["features"]) if "features" in raw else None,
            stairs=dict(raw.get("stairs", {})),
            max_foes=int(raw.get("max_foes", 0)),
            respawn_time=int(raw.get("respawn_time", 0)),
            fixed_floors={int(k): v for k, v in raw.get("fixed_floors", {}).items()},
            floor_overrides=floor_overrides,
        )
        segments.append(seg)

    if not segments:
        raise DefinitionError("a dungeon needs at least one segment")

    covered: List[int] = []
    for seg in segments:
        if seg.floors[0] < 1 or seg.floors[1] > floors:
            raise DefinitionError(
                f"segment '{seg.name}' range {seg.floors} is outside 1..{floors}")
        outside = sorted(set(seg.floor_overrides) - set(seg.floor_numbers))
        if outside:
            raise DefinitionError(
                f"segment '{seg.name}' has floor overrides outside its range: {outside}")
        covered.extend(seg.floor_numbers)
    if len(covered) != len(set(covered)):
        raise DefinitionError("segments overlap on at least one floor")
    if sorted(covered) != list(range(1, floors + 1)):
        missing = sorted(set(range(1, floors + 1)) - set(covered))
        raise DefinitionError(f"segments do not cover every floor; missing {missing}")

    definition = DungeonDefinition(
        id=str(data["id"]),
        name=name,
        chapter=int(data["chapter"]),
        floors=floors,
        segments=segments,
        source=str(data.get("source", "")),
        route=str(data.get("route", "secondary")),
        biome=str(data.get("biome", "")),
        music=str(data.get("music", "")),
        dtef=dict(data.get("dtef", {})),
        level=int(data.get("level", 1)),
        rescues=int(data.get("rescues", 2)),
        released=bool(data.get("released", True)),
        comment=str(data.get("comment", "")),
        profiles=_profiles(data.get("profiles", []), "dungeon"),
        mobs=[_mob(m) for m in data.get("pokemon", [])],
        item_tables=[_item_table(k, v) for k, v in data.get("items", {}).items()],
        money=_tuple2(data.get("money", [100, 140]), "money"),
        features=Features.from_json(data.get("features", {})),
        stairs=dict(data.get("stairs", {})),
        fixed_grounds=dict(data.get("fixed_grounds", {})),
        minibosses=list(data.get("minibosses", [])),
        boss=dict(data.get("boss", {})),
        midpoint=dict(data.get("midpoint", {})),
        variation=dict(data.get("variation", {})),
        aliases=[str(a) for a in data.get("aliases", [])],
        blocked=[str(b) for b in data.get("blocked", [])],
        scenes=dict(data.get("scenes", {})),
        narrative=dict(data.get("narrative", {})),
        provenance=dict(data.get("provenance", {})),
        fixed_segments=[dict(segment) for segment in data.get("fixed_segments", [])],
        path=path,
    )

    if not definition.profiles and not all(seg.profiles for seg in segments):
        raise DefinitionError("no architecture profile declared (dungeon level or every segment)")
    if not definition.dtef and not all(seg.dtef for seg in segments):
        raise DefinitionError("no DTEF tileset declared (dungeon level or every segment)")

    stair_specs = [("dungeon", definition.stairs)]
    for seg in segments:
        stair_specs.append((f"segment '{seg.name}'", seg.stairs))
        for floor_id, override in seg.floor_overrides.items():
            stair_specs.append((f"segment '{seg.name}' floor {floor_id}", override.get("stairs", {})))
    for where, stair_spec in stair_specs:
        if "distance" in stair_spec:
            lo, hi = _tuple2(stair_spec["distance"], f"{where}.stairs.distance")
            if lo < 0 or hi <= lo:
                raise DefinitionError(
                    f"{where}.stairs.distance must be [min,max] with 0 <= min < max")

    for index, fixed_segment in enumerate(definition.fixed_segments):
        if not fixed_segment.get("map"):
            raise DefinitionError(f"fixed_segments[{index}] requires map")
        if not fixed_segment.get("role"):
            raise DefinitionError(f"fixed_segments[{index}] requires role")
        if fixed_segment.get("is_relevant", False):
            raise DefinitionError(
                f"fixed_segments[{index}] must be non-relevant; counted floors belong in segments")

    boss = definition.boss
    if boss:
        mode = boss.get("mode")
        if mode not in BOSS_MODES:
            raise DefinitionError(
                f"boss.mode must be one of {BOSS_MODES} (got {mode!r}): a canonical end Ground "
                "must be reused when it exists, an arena .rsmap is only for dungeons without one")
        if mode == "canonical_ground" and not (boss.get("ground") or definition.fixed_grounds.get("end")):
            raise DefinitionError("boss.mode=canonical_ground requires boss.ground "
                                  "or fixed_grounds.end")
        if mode == "arena_rsmap":
            if not boss.get("map"):
                raise DefinitionError("boss.mode=arena_rsmap requires boss.map (the .rsmap arena)")
            if definition.fixed_grounds.get("end"):
                raise DefinitionError(
                    "boss.mode=arena_rsmap conflicts with fixed_grounds.end: the canonical end "
                    "Ground must host the final battle")
    scenes = definition.scenes
    if scenes:
        end = scenes.get("canonical_end_ground", "")
        for role in ("cinematic_ground", "battle_ground"):
            value = scenes.get(role, "")
            if end and value and value != end:
                raise DefinitionError(
                    f"scenes.{role} ('{value}') must be the canonical end Ground ('{end}'): the "
                    "cutscene, the battle and its aftermath happen in the same space")
        if end and definition.boss.get("mode") == "arena_rsmap":
            raise DefinitionError(
                f"boss.mode=arena_rsmap is forbidden: canonical scene '{end}' exists for this "
                "dungeon and must host the cutscene and the battle")
    for miniboss in definition.minibosses:
        for required in ("species", "level"):
            if required not in miniboss:
                raise DefinitionError(f"miniboss entry missing '{required}': {miniboss!r}")
    return definition


def load_definition(path: Path) -> DungeonDefinition:
    path = Path(path)
    if not path.exists():
        raise DefinitionError(f"definition not found: {path}")
    with path.open(encoding="utf-8-sig") as handle:
        try:
            data = json.load(handle)
        except json.JSONDecodeError as exc:
            raise DefinitionError(f"{path.name}: invalid JSON ({exc})") from exc
    return parse_definition(data, path)


def find_definition(name: str, folder: Optional[Path] = None) -> Path:
    folder = Path(folder or DEFAULT_DEF_DIR)
    direct = Path(name)
    if direct.exists() and direct.is_file():
        return direct
    candidate = folder / f"{name}.json"
    if candidate.exists():
        return candidate
    # a definition may declare an id that differs from its file name
    # (e.g. sinister_woods.json -> id "gloomy_forest" kept for save compatibility)
    for path in sorted(folder.glob("*.json")):
        try:
            data = json.loads(path.read_text(encoding="utf-8-sig"))
        except json.JSONDecodeError:
            continue
        if data.get("id") == name:
            return path
    raise DefinitionError(f"no definition '{name}' in {folder}")


def list_definitions(folder: Optional[Path] = None) -> List[Path]:
    folder = Path(folder or DEFAULT_DEF_DIR)
    return sorted(p for p in folder.glob("*.json"))
