#!/usr/bin/env python3
"""
tools/add_crooked_profondeurs.py

Inserts a SECOND procedural segment ("Profondeurs") into Data/Zone/crooked_cavern.json,
turning the zone from 2 segments (procedural + boss) into 3 segments
(procedural + Profondeurs + boss). The boss LoadGen shifts from segment index 1 to 2,
which matches the zone script (Data/Script/halcyon/zone/crooked_cavern/init.lua) and the
crooked_den boss launch (ContinueDungeon("crooked_cavern", 2, ...)).

This is a STRUCTURAL scaffold only: the new segment is a copy of segment 0 with a
distinct floor display name. Difficulty tuning (tougher species, denser spawns, traps,
monster houses) must be done in the PMDO Zone Editor + playtested — see
audit_checkpoint_crooked_cavern.md §9.2.

The PMDO editor serializes these JSON files in a flat (indent=0) format; we reproduce
that exactly so the diff is minimal (only the inserted segment changes).
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import copy, json, sys, pathlib

ZONE = pathlib.Path("Data/Zone/crooked_cavern.json")
SRC_DISPLAY = "Crooked Cavern\\nB{0}F"
DST_DISPLAY = "Crooked Cavern - Profondeurs\\nB{0}F"


def rename_display(obj):
    """Recursively rename the floor display text inside the copied segment."""
    if isinstance(obj, dict):
        for k, v in obj.items():
            if k == "DefaultText" and v == SRC_DISPLAY:
                obj[k] = DST_DISPLAY
            else:
                rename_display(v)
    elif isinstance(obj, list):
        for item in obj:
            rename_display(item)


def main():
    raw = ZONE.read_text(encoding="utf-8-sig")
    data = json.loads(raw)

    segs = data["Object"]["Segments"]
    assert len(segs) == 2, f"Expected 2 segments, found {len(segs)} (already patched?)"
    assert "RangeDictSegment" in segs[0]["$type"], "Segment 0 is not a RangeDictSegment"
    assert "LayeredSegment" in segs[1]["$type"], "Segment 1 is not the boss LayeredSegment"

    profundus = copy.deepcopy(segs[0])      # copy of the procedural first half
    rename_display(profundus)               # mark it as the Profondeurs second half
    segs.insert(1, profundus)               # boss becomes segment index 2

    out = json.dumps(data, ensure_ascii=False, indent=0)
    # Preserve the UTF-8 BOM the editor writes.
    ZONE.write_text(out, encoding="utf-8-sig")

    # Re-verify
    chk = json.loads(ZONE.read_text(encoding="utf-8-sig"))
    types = [s["$type"].split(",")[0].split(".")[-1] for s in chk["Object"]["Segments"]]
    print("Done. Segments now:", types)
    assert types == ["RangeDictSegment", "RangeDictSegment", "LayeredSegment"], types
    print("OK: segment 0 = Caverne Tortueuse, segment 1 = Profondeurs, segment 2 = boss.")


if __name__ == "__main__":
    main()
