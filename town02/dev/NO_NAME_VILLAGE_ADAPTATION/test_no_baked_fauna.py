#!/usr/bin/env python3
"""Fail if any known source fauna is still baked into a generated Ground.

Source fauna (birds, butterflies, bugs, fireflies, frogs, mobs) is gameplay
data. It must be preserved as separate occurrences so it can later be cast as
native Pokemon through NNVLife - never painted into a Ground as scenery tiles.

The check has two independent legs so a naming variant cannot slip through:

  1. contract leg - every fauna object placed in a source room must appear in
     the converter's exclusion set;
  2. artifact leg - every generated manifest must list its fauna occurrences
     under `wildlife_source` and must not claim to have rendered them.

Run: python3 NO_NAME_VILLAGE_ADAPTATION/test_no_baked_fauna.py
"""
from __future__ import annotations

import gzip
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parent
CONVERTER = ROOT / "tools/convert_environment_room.py"
INVENTORY = ROOT / "reports/environment-inventory.json.gz"
GENERATED = ROOT / "generated"

# Heuristic used to DISCOVER fauna in the source, independent of the converter.
# If this finds something the converter does not exclude, the test fails.
FAUNA_TOKENS = ("mob", "bird", "butterfly", "bug", "firefly", "frog")
# Objects whose name contains a token but are demonstrably not fauna.
NOT_FAUNA = re.compile(r"^Obj_Steam_", re.IGNORECASE)


def load_converter_rules():
    """Read the converter's own fauna rules, so the test tracks the real code.

    Parsed statically rather than imported: the converter needs Pillow, which
    this guard must not depend on. The literals are still the single source of
    truth - if the converter changes, this test follows.
    """
    source = CONVERTER.read_text()
    prefixes = re.search(r"^FAUNA_PREFIXES\s*=\s*\(([^)]*)\)", source, re.M)
    exact = re.search(r"^FAUNA_EXACT\s*=\s*\{([^}]*)\}", source, re.M)
    assert prefixes and exact, "converter must define FAUNA_PREFIXES and FAUNA_EXACT"
    tuple_vals = tuple(re.findall(r'"([^"]+)"', prefixes.group(1)))
    exact_vals = set(re.findall(r'"([^"]+)"', exact.group(1)))
    assert tuple_vals and exact_vals, "fauna rules must not be empty"

    def is_fauna(name: str) -> bool:
        return name.startswith(tuple_vals) or name in exact_vals

    # The predicate must actually gate BOTH code paths, and no path may
    # re-implement its own narrower fauna test with a raw startswith.
    render_gate = re.search(
        r"^\s*if is_fauna\(object_name\) or object_name in \{", source, re.M)
    assert render_gate, "the render filter must be gated by is_fauna(object_name)"
    record_gate = re.search(r"^\s*elif is_fauna\(object_name\):", source, re.M)
    assert record_gate, "fauna recording must be gated by is_fauna(object_name)"

    # Any surviving hand-rolled objmob test would be a narrower duplicate rule.
    rogue = [
        line.strip() for line in source.splitlines()
        if "object_name.startswith(" in line and "FAUNA_PREFIXES" not in line
    ]
    assert not rogue, f"fauna must be tested only through is_fauna; found: {rogue}"
    return is_fauna, tuple_vals, exact_vals


def discover_placed_fauna() -> dict[str, int]:
    with gzip.open(INVENTORY) as stream:
        inventory = json.load(stream)
    counts: dict[str, int] = {}
    for room in inventory["rooms"]:
        for instance in room["instances"]:
            obj = instance.get("object")
            name = obj.get("name") if isinstance(obj, dict) else obj
            if not name or NOT_FAUNA.match(name):
                continue
            lowered = name.lower()
            if any(token in lowered for token in FAUNA_TOKENS):
                counts[name] = counts.get(name, 0) + 1
    return counts


def test_known_fauna_families_stay_covered() -> None:
    """Guard the families themselves, not only today's placed instances.

    Without this, dropping a prefix goes unnoticed as long as an exact name
    still happens to cover the instances currently present in the source.
    """
    is_fauna, _, _ = load_converter_rules()
    required = {
        "objmob0", "objmobsm1", "objmobau3fish", "objmobwn0_old",
        "objbmob0", "objbfmob1", "objbgmob", "objbmobsmcatch",
        "objbird0", "objbutterfly0", "objbutterfly1",
        "objbug0", "objfirefly", "objfrog",
        # naming variants that must not bypass the filter
        "objbird9", "objbutterfly7", "objmobsm999",
    }
    missed = sorted(name for name in required if not is_fauna(name))
    assert not missed, f"fauna families no longer covered by the converter: {missed}"


def test_every_placed_fauna_is_excluded() -> None:
    is_fauna, prefixes, exact = load_converter_rules()
    placed = discover_placed_fauna()
    assert placed, "expected the source inventory to contain fauna"
    missed = sorted(name for name in placed if not is_fauna(name))
    assert not missed, (
        "fauna objects placed in the source but NOT excluded by the converter: "
        f"{missed}. Add them to FAUNA_PREFIXES/FAUNA_EXACT."
    )


def test_generated_grounds_do_not_bake_fauna() -> None:
    is_fauna, _, _ = load_converter_rules()
    manifests = sorted(GENERATED.rglob("manifest.json"))
    checked = 0
    for path in manifests:
        data = json.loads(path.read_text())
        if "wildlife_source" not in data and "collision_metrics" not in data:
            continue  # not a room conversion manifest
        checked += 1
        for entry in data.get("wildlife_source", []):
            name = entry.get("object")
            assert name is None or is_fauna(name), (
                f"{path}: '{name}' recorded as wildlife but not recognised as fauna"
            )
        rendered = data.get("rendered_objects") or []
        baked = sorted({n for n in rendered if isinstance(n, str) and is_fauna(n)})
        assert not baked, f"{path}: fauna baked into the Ground: {baked}"
    assert checked, "no room conversion manifest found to verify"


def main() -> int:
    test_known_fauna_families_stay_covered()
    test_every_placed_fauna_is_excluded()
    test_generated_grounds_do_not_bake_fauna()
    print("No baked fauna tests: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
