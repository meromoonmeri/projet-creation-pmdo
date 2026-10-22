"""Restore archived canonical scenes and re-attach their narrative content.

`REQUIRES_INTEGRATION` means the canonical scene exists but lives in `RESERVE/`
(or only as a `.rsmap`).  This module performs the actual integration:

* copy the archived Ground into `Data/Ground` and register it in the index;
* copy the archived ground/zone Lua scripts into the live script tree;
* re-point the definition's `narrative` entries at their new live location and
  flip `narrative.transferred` to true **only** when every referenced asset is
  live — the flag means "the new implementation really uses them", not
  "we found them somewhere".

Nothing is deleted here: the archive stays as the provenance record.
"""
from __future__ import annotations

import json
import shutil
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence

from .definitions import DungeonDefinition
from .scenes import ACTIVE_GROUND, ACTIVE_RSMAP, ARCHIVED, parse_inventory, scenes_for

ROOT = Path(__file__).resolve().parents[2]
GROUND_DIR = ROOT / "Data" / "Ground"
MAP_DIR = ROOT / "Data" / "Map"
SCRIPT_GROUND = ROOT / "Data" / "Script" / "halcyon" / "ground"
SCRIPT_ZONE = ROOT / "Data" / "Script" / "halcyon" / "zone"
RESERVE = ROOT / "RESERVE"
RESERVE_SCRIPT_GROUND = RESERVE / "scripts_ground"
RESERVE_SCRIPT_ZONE = RESERVE / "scripts_zone"


@dataclass
class IntegrationResult:
    dungeon: str
    restored_grounds: List[str] = field(default_factory=list)
    restored_scripts: List[str] = field(default_factory=list)
    already_live: List[str] = field(default_factory=list)
    missing: List[str] = field(default_factory=list)
    narrative_complete: bool = False
    notes: List[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.missing


def _find_archived(name: str, suffix: str) -> Optional[Path]:
    for folder in sorted(RESERVE.glob("*")):
        if not folder.is_dir():
            continue
        candidate = folder / f"{name}{suffix}"
        if candidate.exists():
            return candidate
    return None


def restore_ground(name: str, dry_run: bool = False) -> Optional[str]:
    """Copy an archived Ground into the live data folder."""
    target = GROUND_DIR / f"{name}.rsground"
    if target.exists():
        return None
    source = _find_archived(name, ".rsground")
    if source is None:
        return None
    if not dry_run:
        shutil.copy2(source, target)
        _register_ground(name)
    return str(source.relative_to(ROOT))


def _register_ground(name: str) -> None:
    index_path = GROUND_DIR / "index.idx"
    if not index_path.exists():
        return
    data = json.loads(index_path.read_text(encoding="utf-8-sig"))
    entries = data["Object"]
    if name in entries:
        return
    template = None
    for key, value in entries.items():
        if not key.startswith("$") and isinstance(value, dict):
            template = value
            break
    entry = dict(template) if template else {}
    try:
        obj = json.loads((GROUND_DIR / f"{name}.rsground").read_text(encoding="utf-8-sig"))["Object"]
        entry["Name"] = obj.get("Name", {"DefaultText": name, "LocalTexts": {}})
        entry["Comment"] = obj.get("Comment", "")
    except (json.JSONDecodeError, KeyError, OSError):
        entry["Name"] = {"DefaultText": name, "LocalTexts": {}}
    entry["Released"] = True
    entries[name] = entry
    index_path.write_text("\ufeff" + json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def restore_script(folder_name: str, kind: str = "ground", dry_run: bool = False) -> Optional[str]:
    """Copy an archived Lua script folder into the live script tree."""
    live_root = SCRIPT_GROUND if kind == "ground" else SCRIPT_ZONE
    archive_root = RESERVE_SCRIPT_GROUND if kind == "ground" else RESERVE_SCRIPT_ZONE
    target = live_root / folder_name
    if target.is_dir():
        return None
    source = archive_root / folder_name
    if not source.is_dir():
        return None
    if not dry_run:
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copytree(source, target)
    return str(source.relative_to(ROOT))


def integrate(definition: DungeonDefinition, inventory: Optional[Dict[str, Any]] = None,
              dry_run: bool = False) -> IntegrationResult:
    """Restore every canonical scene and cutscene this dungeon needs."""
    inventory = inventory if inventory is not None else parse_inventory()
    result = IntegrationResult(dungeon=definition.id)
    scenes = scenes_for(definition.name.get("en", definition.id), inventory)

    names: List[str] = []
    if scenes:
        for asset in [scenes.entrance, scenes.relay, *scenes.end]:
            if asset and asset.name:
                names.append(asset.name)
    for value in (definition.fixed_grounds or {}).values():
        if value:
            names.append(value)
    boss_ground = (definition.boss or {}).get("ground")
    if boss_ground:
        names.append(boss_ground)

    for name in sorted(set(names)):
        if (GROUND_DIR / f"{name}.rsground").exists():
            result.already_live.append(name)
            continue
        restored = restore_ground(name, dry_run)
        if restored:
            result.restored_grounds.append(name)
            continue
        if (MAP_DIR / f"{name}.rsmap").exists():
            result.notes.append(f"'{name}' exists as a .rsmap: convert this very map into the "
                                "Ground that hosts the cutscene and the battle")
            continue
        result.missing.append(name)

    for name in sorted(set(names)):
        restored = restore_script(name, "ground", dry_run)
        if restored:
            result.restored_scripts.append(f"ground/{name}")
    restored = restore_script(definition.id, "zone", dry_run)
    if restored:
        result.restored_scripts.append(f"zone/{definition.id}")

    result.narrative_complete = narrative_is_live(definition)
    return result


def narrative_is_live(definition: DungeonDefinition) -> bool:
    """True when every cutscene the dungeon needs is in the live script tree."""
    narrative = definition.narrative or {}
    entries = narrative.get("cutscenes", [])
    zone_script = narrative.get("zone_script", "")
    if not entries and not zone_script:
        return False
    for entry in entries:
        scene = entry.get("scene", "")
        if not (SCRIPT_GROUND / scene).is_dir():
            return False
    if zone_script and not (ROOT / zone_script).is_dir():
        return False
    return True


def refresh_definition(definition: DungeonDefinition, dry_run: bool = False) -> Dict[str, Any]:
    """Rewrite the definition's narrative block against the live tree."""
    if definition.path is None:
        return {}
    raw = json.loads(definition.path.read_text(encoding="utf-8-sig"))
    narrative = raw.get("narrative")
    if not narrative:
        return {}
    for entry in narrative.get("cutscenes", []):
        scene = entry.get("scene", "")
        live = SCRIPT_GROUND / scene
        if live.is_dir():
            entry["state"] = "active"
            entry["path"] = str(live.relative_to(ROOT))
    zone_script = SCRIPT_ZONE / raw["id"]
    if zone_script.is_dir():
        narrative["zone_script"] = str(zone_script.relative_to(ROOT))
    complete = bool(narrative.get("cutscenes")) and all(
        entry.get("state") == "active" for entry in narrative.get("cutscenes", []))
    narrative["transferred"] = complete
    narrative["transfer_check"] = ("every cutscene folder is live under Data/Script/halcyon and is "
                                   "replayed on the canonical Ground" if complete else
                                   "some cutscenes are still archived")
    if not dry_run:
        definition.path.write_text(json.dumps(raw, ensure_ascii=False, indent=2) + "\n",
                                   encoding="utf-8")
    return narrative
