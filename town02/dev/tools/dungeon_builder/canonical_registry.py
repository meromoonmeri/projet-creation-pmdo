"""Canonical ROM floor/event -> Ground -> rsmap -> runtime registry."""
from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
REGISTRY_PATH = ROOT / "DungeonDefs" / "canonical_scene_registry.json"


@dataclass
class RegistryCheck:
    dungeon: str
    entry: dict[str, Any]
    errors: list[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.errors


def load_registry(path: Path = REGISTRY_PATH) -> dict[str, dict[str, Any]]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    if payload.get("schema") != "new-era.canonical-scene-registry.v1":
        raise ValueError(f"unsupported registry schema in {path}")
    return payload.get("entries", {})


def resolve(name: str) -> dict[str, Any]:
    entries = load_registry()
    if name in entries:
        return entries[name]
    for entry in entries.values():
        if entry.get("dungeon_id") == name:
            return entry
    raise KeyError(f"canonical scene registry has no entry for {name}")


def _require(errors: list[str], path: str, label: str) -> None:
    if not (ROOT / path).is_file():
        errors.append(f"{label} missing: {path}")


def check(name: str) -> RegistryCheck:
    entry = resolve(name)
    errors: list[str] = []
    source = entry.get("source", {})
    _require(errors, str(source.get("manifest", "")), "ROM manifest")
    _require(errors, str(source.get("scene_ir", "")), "scene IR")
    _require(errors, str(source.get("scene_reference", "")), "scene reference")
    entrance = entry.get("entrance", {})
    _require(errors, f"Data/Ground/{entrance.get('ground', '')}.rsground", "entrance Ground")
    _require(errors, str(entrance.get("reserve_ground", "")), "reserved entrance Ground")
    _require(errors, str(entrance.get("runtime_script", "")), "entrance runtime script")
    final = entry.get("final", {})
    _require(errors, f"Data/Ground/{final.get('canonical_ground', '')}.rsground", "final Ground")
    _require(errors, str(final.get("reserve_ground", "")), "reserved final Ground")
    _require(errors, f"Data/Map/{final.get('battle_map', '')}.rsmap", "battle map")
    _require(errors, str(final.get("battle_map_visual_validation", "")), "visual validation")
    _require(errors, str(final.get("runtime_script", "")), "final runtime script")
    if final.get("battle_map_kind") != "exact_canonical_ground_counterpart":
        errors.append("final battle map is not declared as exact canonical counterpart")
    return RegistryCheck(name, entry, errors)
