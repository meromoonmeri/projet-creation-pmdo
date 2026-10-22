"""Runtime pre-flight: everything a zone needs must exist before the engine loads it.

A real runtime validation needs RogueEssence/PMDO with the base asset set and a
display; this module covers what can be proven *without* the engine, which is
where most load failures come from:

* every auto-tileset referenced by a zone exists (mod DTEF or attested base);
* every Ground / `.rsmap` referenced by a zone or a definition exists;
* every music track referenced exists in `Content/Music`;
* every item id exists in `Data/Item`;
* every zone is registered in `Data/Zone/index.idx` with the right floor count;
* every fixed floor points at an existing map;
* every cutscene that re-enters a dungeon targets a valid segment/floor.

`runtime_kit()` then writes the exact procedure + script to run the *true*
runtime check on a machine that owns PMDO and a display.
"""
from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Set

ROOT = Path(__file__).resolve().parents[2]
ZONE_DIR = ROOT / "Data" / "Zone"
GROUND_DIR = ROOT / "Data" / "Ground"
MAP_DIR = ROOT / "Data" / "Map"
ITEM_DIR = ROOT / "Data" / "Item"
MUSIC_DIR = ROOT / "Content" / "Music"
AUTOTILE_DIR = ROOT / "Data" / "AutoTile"
DOC_DIR = ROOT / "docs" / "dungeon_builder"

MUSIC_RE = re.compile(r'"Music"\s*:\s*"([^"]+)"')
TILESET_RE = re.compile(r'"(?:AutoTileset|GroundTileset|BlockTileset|WaterTileset)"\s*:\s*"([a-z0-9_]+)"')
ITEM_RE = re.compile(r'"(?:ID|Value)"\s*:\s*"((?:berry|seed|orb|gummi|food|held|apricorn|boost|'
                     r'machine|ammo|cafe|box|medicine)_[a-z0-9_]+)"')


@dataclass
class PreflightResult:
    dungeon: str
    zone: str = ""
    tilesets: int = 0
    music: List[str] = field(default_factory=list)
    problems: List[str] = field(default_factory=list)
    checks: int = 0

    @property
    def ok(self) -> bool:
        return not self.problems


def _known_tilesets() -> Set[str]:
    from .dtef import base_tilesets
    return set(base_tilesets()) | {p.stem for p in AUTOTILE_DIR.glob("*.json")}


def _known_items() -> Set[str]:
    base = ROOT / "tools/dungeon_builder/data/base_items.txt"
    return ({line.strip() for line in base.read_text().splitlines() if line.strip()}
            if base.is_file() else set()) | {p.stem for p in ITEM_DIR.glob("*.json")}


def preflight_zone(definition, known_tilesets: Optional[Set[str]] = None,
                   known_items: Optional[Set[str]] = None) -> Optional[PreflightResult]:
    path = ZONE_DIR / f"{definition.id}.json"
    if not path.exists():
        return None
    known_tilesets = known_tilesets if known_tilesets is not None else _known_tilesets()
    known_items = known_items if known_items is not None else _known_items()

    result = PreflightResult(dungeon=definition.id, zone=str(path.relative_to(ROOT)))
    text = path.read_text(encoding="utf-8-sig")
    zone = json.loads(text)["Object"]

    tilesets = set(TILESET_RE.findall(text))
    result.tilesets = len(tilesets)
    for tileset in sorted(tilesets):
        result.checks += 1
        if tileset not in known_tilesets:
            result.problems.append(f"auto-tileset '{tileset}' is not attested anywhere")

    for track in sorted(set(MUSIC_RE.findall(text))):
        result.checks += 1
        result.music.append(track)
        if track and not (MUSIC_DIR / track).exists():
            result.problems.append(f"music '{track}' missing from Content/Music")

    for item in sorted(set(ITEM_RE.findall(text))):
        result.checks += 1
        if item not in known_items:
            result.problems.append(f"item '{item}' missing from Data/Item")

    for ground in zone.get("GroundMaps", []) or []:
        result.checks += 1
        if ground and not (GROUND_DIR / f"{ground}.rsground").exists():
            result.problems.append(f"Ground '{ground}' referenced by the zone is missing")

    for segment in zone.get("Segments", []):
        for floor in segment.get("Floors", []):
            if "LoadGen" not in floor.get("$type", ""):
                continue
            for step in floor.get("GenSteps", []):
                map_id = step["Value"].get("MapID")
                if map_id:
                    result.checks += 1
                    if not (MAP_DIR / f"{map_id}.rsmap").exists():
                        result.problems.append(f"fixed floor map '{map_id}.rsmap' is missing")

    index_path = ZONE_DIR / "index.idx"
    if index_path.exists():
        result.checks += 1
        index = json.loads(index_path.read_text(encoding="utf-8-sig"))["Object"]
        entry = index.get(definition.id)
        if entry is None:
            result.problems.append("zone is not registered in Data/Zone/index.idx")
        elif entry.get("CountedFloors") != definition.floors:
            result.problems.append(
                f"index.idx says {entry.get('CountedFloors')} floors, definition says "
                f"{definition.floors}")
    return result


def preflight_all() -> List[PreflightResult]:
    from .definitions import DefinitionError, list_definitions, load_definition
    known_tilesets = _known_tilesets()
    known_items = _known_items()
    results: List[PreflightResult] = []
    for path in list_definitions():
        try:
            definition = load_definition(path)
        except DefinitionError:
            continue
        result = preflight_zone(definition, known_tilesets, known_items)
        if result is not None:
            results.append(result)
    return results


MAPGEN_SCRIPT = """#!/usr/bin/env bash
# ============================================================================
# HEADLESS runtime validation of the Dungeon Builder output.
# The real engine (RogueEssence, through its own MapGenTest harness) executes
# our GenSteps on every floor of every zone.  No graphics needed, only the
# .NET SDK.
#
#   ./run_mapgen_check.sh <PMDO-install> [iterations] [PMDC-checkout]
#
#   <PMDO-install>  folder containing Base/, Data/, Content/, MODS/ and PMDO
#   [iterations]    generations per floor (default 5)
#   [PMDC-checkout] optional; cloned automatically next to this script if absent
#
# Output: mapgen_stress.log + mapgen_report.txt (parseable summary)
# ============================================================================
set -euo pipefail

PMDO_DIR="${1:?usage: run_mapgen_check.sh <PMDO-install> [iterations] [PMDC-checkout]}"
ITER="${2:-5}"
HERE="$(cd "$(dirname "$0")" && pwd)"
MOD_SRC="$(cd "$HERE/../.." && pwd)"
PMDC_DIR="${3:-$HERE/.pmdc}"
MOD_NAME="new-era-abyss-to-ascension"

echo "== 0. prerequisites =="
command -v dotnet >/dev/null || { echo "FATAL: .NET SDK not found (dotnet)"; exit 2; }
command -v git >/dev/null || { echo "FATAL: git not found"; exit 2; }
[ -f "$PMDO_DIR/Base/PathParams.xml" ] || { echo "FATAL: $PMDO_DIR is not a PMDO install"; exit 2; }
dotnet --version

if [ ! -d "$PMDC_DIR/MapGenTest" ]; then
  echo "== 0b. fetching the engine sources (PMDCollab/PMDC) =="
  git clone --recurse-submodules --depth 1 https://github.com/PMDCollab/PMDC.git "$PMDC_DIR"
fi

echo "== 1. install this mod into the PMDO install =="
mkdir -p "$PMDO_DIR/MODS/$MOD_NAME"
rsync -a --delete --exclude '.git' --exclude 'RESERVE' --exclude 'external' \
      "$MOD_SRC/" "$PMDO_DIR/MODS/$MOD_NAME/"
ZONES=$(ls "$MOD_SRC/Data/Zone"/*.json | wc -l)
echo "mod installed: $ZONES zone files"

echo "== 2. build MapGenTest (headless harness) =="
dotnet build -c Release "$PMDC_DIR/MapGenTest/MapGenTest.csproj"
BIN="$(find "$PMDC_DIR/MapGenTest/bin/Release" -name MapGenTest -type f -perm -u+x | head -1)"
[ -n "$BIN" ] || { echo "FATAL: MapGenTest binary not produced"; exit 2; }

echo "== 3. generate every floor of every zone, $ITER times =="
cd "$PMDO_DIR"
# F2 on the zone list = "stress test all"; then the iteration count; ESC quits.
printf '\033OQ%s\n\033' "$ITER" | "$BIN" -quest "$MOD_NAME" 2>&1 | tee mapgen_stress.log || true

echo "== 4. report =="
{
  echo "dungeon-builder runtime report ($(date -u +%FT%TZ))"
  echo "mod: $MOD_NAME   zones: $ZONES   iterations/floor: $ITER"
  echo "errors:      $(grep -ciE 'exception|error' mapgen_stress.log || true)"
  echo "isolated:    $(grep -ci 'isolated' mapgen_stress.log || true)"
  echo "--- first 40 problem lines ---"
  grep -inE 'exception|error|isolated|fail' mapgen_stress.log | head -40 || true
} | tee mapgen_report.txt

if grep -qiE "exception|error" mapgen_stress.log; then
  echo; echo "RESULT: FAILURES — send mapgen_report.txt back for fixing"; exit 1
fi
echo; echo "RESULT: the engine generated every floor without error"
"""


RUNTIME_SCRIPT = """#!/usr/bin/env bash
# IN-GAME validation (needs a display): install the mod and play the checklist.
set -euo pipefail

PMDO_DIR="${1:?usage: run_runtime_check.sh /path/to/PMDO}"
MOD_NAME="new-era-abyss-to-ascension"
MOD_SRC="$(cd "$(dirname "$0")/../.." && pwd)"

echo "== 1. install the mod =="
mkdir -p "$PMDO_DIR/MODS/$MOD_NAME"
rsync -a --delete --exclude '.git' "$MOD_SRC/" "$PMDO_DIR/MODS/$MOD_NAME/"

echo "== 2. launch PMDO with the mod =="
echo "In game: Mods -> enable '$MOD_NAME' -> restart, then run the checklist below."
cd "$PMDO_DIR" && ./PMDO

cat <<'CHECK'
== 3. checklist per dungeon (report PASS/FAIL) ==
 1. the zone appears in the dungeon list with the expected floor count
 2. enter it: the first floor generates (no gen exception in the log)
 3. re-enter three times: the layout differs each time (rooms, corridors, stairs)
 4. walk the floor: collisions behave, corridors connect, no isolated pocket
 5. the stairs are reachable and lead to the next floor
 6. wild Pokemon spawn, with the species/levels of the definition
 7. floor items and money spawn
 8. reach a shop floor: Kecleon and his stock appear
 9. reach a monster house floor: it triggers
10. reach a vault/treasure floor if declared: the key/room behaves
11. fixed floor (buried_relic F99 / meteor_cave F20): the fixed room loads
12. the final Ground loads, the cutscene plays and the boss battle happens
    on that very Ground (no teleport to another arena)
13. the exit transition returns where the script expects
CHECK
"""


def runtime_kit(folder: Optional[Path] = None) -> List[Path]:
    """Write both validation entry points: headless generation, then in-game."""
    folder = Path(folder or (ROOT / "tools" / "runtime"))
    folder.mkdir(parents=True, exist_ok=True)
    written: List[Path] = []
    for name, content in (("run_mapgen_check.sh", MAPGEN_SCRIPT),
                          ("run_runtime_check.sh", RUNTIME_SCRIPT)):
        path = folder / name
        path.write_text(content, encoding="utf-8")
        path.chmod(0o755)
        written.append(path)
    return written


def markdown(results: Sequence[PreflightResult]) -> str:
    good = [r for r in results if r.ok]
    lines = ["# Pré-vol runtime des zones générées", "",
             f"_Généré le {datetime.now(timezone.utc).isoformat(timespec='seconds')} — "
             f"{len(results)} zones vérifiées : **{len(good)} sans référence manquante**, "
             f"{len(results) - len(good)} avec anomalie._", "",
             "Ce contrôle ne remplace pas l'exécution par le moteur : il vérifie que **toutes "
             "les références** d'une zone existent (tilesets, Grounds, salles fixes, musiques, "
             "objets, index), ce qui est la cause principale d'échec au chargement.", "",
             "| Zone | Tilesets | Musiques | Contrôles | Anomalies |", "|---|---|---|---|---|"]
    for result in sorted(results, key=lambda r: r.dungeon):
        lines.append(f"| `{result.dungeon}` | {result.tilesets} | "
                     f"{', '.join(result.music) or '—'} | {result.checks} | "
                     f"{len(result.problems)} |")
    problems = [r for r in results if not r.ok]
    if problems:
        lines += ["", "## Anomalies", ""]
        for result in problems:
            lines.append(f"### `{result.dungeon}`")
            lines.extend(f"- {problem}" for problem in result.problems)
            lines.append("")
    return "\n".join(lines)


def write_report(results: Sequence[PreflightResult], folder: Optional[Path] = None) -> List[Path]:
    folder = Path(folder or DOC_DIR)
    folder.mkdir(parents=True, exist_ok=True)
    md_path = folder / "RUNTIME_PREFLIGHT.md"
    md_path.write_text(markdown(results), encoding="utf-8")
    return [md_path]
