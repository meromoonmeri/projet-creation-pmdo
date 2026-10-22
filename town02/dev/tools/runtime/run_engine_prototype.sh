#!/usr/bin/env bash
# Run 36 isolated floors (3 native profiles x 12 PMDO runtime seeds).
# The disposable mod mirror and all generated evidence live outside Git.
set -euo pipefail

WORK="${1:?usage: run_engine_prototype.sh <work-dir> [iterations-per-profile]}"
ITER="${2:-12}"
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
PROTO="$WORK/prototype-mod"

if [ "$ITER" -lt 10 ]; then
  echo "iterations-per-profile must be >= 10" >&2
  exit 2
fi
if [ $((ITER * 3)) -gt 50 ]; then
  echo "prototype must remain within 20-50 floors (3 profiles, max 16 iterations)" >&2
  exit 2
fi

rm -rf "$PROTO"
mkdir -p "$PROTO"
# Hard links avoid copying the multi-GB mod. The only files replaced below are
# the disposable Zone index and the added prototype zone.
cp -al "$ROOT/Mod.xml" "$ROOT/Data" "$ROOT/Content" "$ROOT/Strings" "$PROTO/"
INDEX="$PROTO/Data/Zone/index.idx"
cp "$INDEX" "$INDEX.copy"
mv "$INDEX.copy" "$INDEX"
python3 "$HERE/build_engine_prototype.py" "$PROTO"

PMDO_MAPGEN_MOD_SRC="$PROTO" \
PMDO_MAPGEN_MOD_NAME="dungeon-builder-prototype" \
PMDO_MAPGEN_VALIDATOR_SPEC="__dungeon_builder_prototype" \
  "$HERE/run_engine_mapgen.sh" "$WORK/runtime" "$ITER"

python3 "$HERE/summarize_engine_mapgen.py" \
  "$WORK/runtime/mapgen_runtime.jsonl" "$WORK/ENGINE_PROTOTYPE_REPORT.md" \
  --prototype --required-per-profile 10 --similarity-threshold 0.92

echo "Prototype report: $WORK/ENGINE_PROTOTYPE_REPORT.md"
