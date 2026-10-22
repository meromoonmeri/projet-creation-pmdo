#!/usr/bin/env bash
# ============================================================================
# HEADLESS runtime validation of the Dungeon Builder output.
# The real engine (RogueEssence, through its own MapGenTest harness) executes
# our GenSteps on every floor of every zone.  No graphics needed, only the
# .NET SDK.
#
#   ./run_mapgen_check.sh <PMDO-install> [iterations] [PMDC-checkout]
#
#   <PMDO-install>  folder containing Base/, Data/, Content/, MODS/ and PMDO
#
# No .NET SDK on the machine?  Use tools/runtime/run_engine_mapgen.sh instead:
# it drives the official PMDO binary headless (ANGLE + SwiftShader) and makes
# the engine itself generate every floor -- no compilation required.
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
rsync -a --delete --exclude '.git' --exclude 'RESERVE' --exclude 'external'       "$MOD_SRC/" "$PMDO_DIR/MODS/$MOD_NAME/"
ZONES=$(ls "$MOD_SRC/Data/Zone"/*.json | wc -l)
echo "mod installed: $ZONES zone files"

echo "== 2. build MapGenTest (headless harness) =="
dotnet build -c Release "$PMDC_DIR/MapGenTest/MapGenTest.csproj"
BIN="$(find "$PMDC_DIR/MapGenTest/bin/Release" -name MapGenTest -type f -perm -u+x | head -1)"
[ -n "$BIN" ] || { echo "FATAL: MapGenTest binary not produced"; exit 2; }

echo "== 3. generate every floor of every zone, $ITER times =="
cd "$PMDO_DIR"
# F2 on the zone list = "stress test all"; then the iteration count; ESC quits.
printf 'OQ%s
' "$ITER" | "$BIN" -quest "$MOD_NAME" 2>&1 | tee mapgen_stress.log || true

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
