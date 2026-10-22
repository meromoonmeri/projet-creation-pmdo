#!/usr/bin/env bash
# Execute the natural canonical Sinister Woods route in real PMDO.
set -euo pipefail
WORK="${1:?usage: run_sinister_route.sh <prepared-runtime-workdir> <candidate-mod-root>}"
MOD_SRC="${2:?candidate mod root required}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MOD_NAME="sinister-canonical-route"
BUNDLE="$WORK/pmdo-headless-bundle"
ASSET="$WORK/asset"
APPDATA="$WORK/appdata"
EXTRACT="$WORK/dotnet-bundle"
OUT="$WORK/sinister_route_runtime.jsonl"

if [ ! -x "$BUNDLE/PMDO" ]; then
  echo "Runtime stack absent; preparing it with one engine mapgen pass..."
  PMDO_MAPGEN_MOD_SRC="$MOD_SRC" PMDO_MAPGEN_MOD_NAME="$MOD_NAME" \
  PMDO_MAPGEN_VALIDATOR_SPEC="gloomy_forest" \
    "$ROOT/tools/runtime/run_engine_mapgen.sh" "$WORK" 1
fi
ln -sfn "$MOD_SRC" "$APPDATA/MODS/$MOD_NAME"
rm -f "$OUT"
env DOTNET_BUNDLE_EXTRACT_BASE_DIR="$EXTRACT" \
    LD_LIBRARY_PATH="$BUNDLE" \
    SDL_VIDEODRIVER=offscreen SDL_AUDIODRIVER=dummy \
    PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY=1 SDL_OPENGL_ES_DRIVER=1 \
    SDL_VIDEO_GL_DRIVER="$BUNDLE/libGLESv2.so" SDL_VIDEO_EGL_DRIVER="$BUNDLE/libEGL.so" \
    FNA3D_FORCE_DRIVER=OpenGL FNA3D_OPENGL_FORCE_ES3=1 \
    ANGLE_DEFAULT_PLATFORM=vulkan VK_ICD_FILENAMES="$BUNDLE/vk_swiftshader_icd.absolute.json" \
    PMDO_SINISTER_ROUTE_VALIDATOR=1 PMDO_SINISTER_ROUTE_OUT="$OUT" \
    "$BUNDLE/PMDO" -asset "$ASSET/" -appdata "$APPDATA/" -quest "$MOD_NAME" \
    > "$WORK/sinister_route_engine.log" 2>&1 &
PID=$!
for _ in $(seq 1 "${PMDO_ROUTE_TIMEOUT:-180}"); do
  grep -q '"event":"end"\|"event":"fatal"' "$OUT" 2>/dev/null && break
  kill -0 "$PID" 2>/dev/null || break
  sleep 1
done
kill "$PID" 2>/dev/null || true
wait "$PID" 2>/dev/null || true

python3 - "$OUT" <<'PY'
import json,sys
from pathlib import Path
p=Path(sys.argv[1])
if not p.is_file(): raise SystemExit('route output missing')
rows=[json.loads(line) for line in p.read_text().splitlines() if line.strip()]
fatals=[row for row in rows if row.get('event')=='fatal']
grounds=[row.get('id') for row in rows if row.get('event')=='ground']
map_rows=[row for row in rows if row.get('event')=='map']
maps=[(row.get('segment'),row.get('floor')) for row in map_rows]
stairs=[(row.get('segment'),row.get('floor')) for row in rows
        if row.get('event')=='stairs_located']
boss=next((row for row in rows if row.get('event')=='boss_outcome'),None)
end=next((row for row in rows if row.get('event')=='end'),None)
print(json.dumps({'events':len(rows),'grounds':grounds,'maps':maps,'stairs':stairs,
                  'boss':boss,'fatals':fatals,'end':end},indent=2))
expected_grounds=['bois_sombres_oree','gloomy_forest_midpoint','sinister_woods_clearing','metano_town']
procedural=([(0,floor) for floor in range(6)]+[(1,floor) for floor in range(6)])
expected_maps=procedural+[(2,0)]
seeds_logged=all(row.get('map_seed') and row.get('adventure_seed') for row in map_rows)
if (fatals or maps != expected_maps or stairs != procedural or grounds != expected_grounds
        or not seeds_logged or not boss or boss.get('mobs') != 3
        or boss.get('native_clear_hooks', 0) < 1
        or not end or not end.get('mission_complete')):
    raise SystemExit(1)
PY

grep -q '"event":"end"' "$OUT"
! grep -Eq 'Missing Data|Could not deserialize|KeyNotFoundException|NullReferenceException|Lua Trace' "$WORK/sinister_route_engine.log"
echo "Sinister route runtime PASS: $OUT"
