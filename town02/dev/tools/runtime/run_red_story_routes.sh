#!/usr/bin/env bash
# Validate staged Tiny Woods / Thunderwave Cave routes in real PMDO.
set -euo pipefail
WORK="${1:?usage: run_red_story_routes.sh <prepared-runtime-workdir> <staging-mod-root> [zones]}"
MOD_SRC="${2:?staging mod root required}"
ZONES="${3:-tiny_woods,thunderwave_cave}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MOD_NAME="red-story-route"
BUNDLE="$WORK/pmdo-headless-bundle"
ASSET="$WORK/asset"
APPDATA="$WORK/appdata"
EXTRACT="$WORK/dotnet-bundle"

[ -x "$BUNDLE/PMDO" ] || {
  echo "runtime stack absent; prepare it with run_engine_mapgen.sh" >&2; exit 2;
}
ln -sfn "$MOD_SRC" "$APPDATA/MODS/$MOD_NAME"
mkdir -p "$WORK/red_story_routes"
IFS=',' read -ra IDS <<< "$ZONES"
for ZONE in "${IDS[@]}"; do
  OUT="$WORK/red_story_routes/${ZONE}.jsonl"
  LOG="$WORK/red_story_routes/${ZONE}.log"
  rm -f "$OUT" "$LOG"
  env DOTNET_BUNDLE_EXTRACT_BASE_DIR="$EXTRACT" \
      LD_LIBRARY_PATH="$BUNDLE" \
      SDL_VIDEODRIVER=offscreen SDL_AUDIODRIVER=dummy \
      PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY=1 SDL_OPENGL_ES_DRIVER=1 \
      SDL_VIDEO_GL_DRIVER="$BUNDLE/libGLESv2.so" SDL_VIDEO_EGL_DRIVER="$BUNDLE/libEGL.so" \
      FNA3D_FORCE_DRIVER=OpenGL FNA3D_OPENGL_FORCE_ES3=1 \
      ANGLE_DEFAULT_PLATFORM=vulkan VK_ICD_FILENAMES="$BUNDLE/vk_swiftshader_icd.absolute.json" \
      PMDO_RED_STORY_ROUTE_VALIDATOR="$ZONE" PMDO_RED_STORY_ROUTE_OUT="$OUT" \
      "$BUNDLE/PMDO" -asset "$ASSET/" -appdata "$APPDATA/" -quest "$MOD_NAME" \
      > "$LOG" 2>&1 &
  PID=$!
  for _ in $(seq 1 "${PMDO_ROUTE_TIMEOUT:-180}"); do
    grep -q '"event":"end"\|"event":"fatal"' "$OUT" 2>/dev/null && break
    kill -0 "$PID" 2>/dev/null || break
    sleep 1
  done
  kill "$PID" 2>/dev/null || true
  wait "$PID" 2>/dev/null || true
  python3 - "$ZONE" "$OUT" <<'PY'
import json,sys
from pathlib import Path
zone,path=sys.argv[1],Path(sys.argv[2])
if not path.is_file(): raise SystemExit(f'{zone}: route output missing')
rows=[json.loads(line) for line in path.read_text().splitlines() if line.strip()]
fatals=[row for row in rows if row.get('event')=='fatal']
maps_all=[row for row in rows if row.get('event')=='map']
proc_maps=[row['floor'] for row in maps_all if row.get('kind')!='canonical_fixed_boss']
boss_maps=[row for row in maps_all if row.get('kind')=='canonical_fixed_boss']
boss_clears=[row for row in rows if row.get('event')=='boss_clear']
# We now key on GroundMapInit (event='ground_init') instead of GroundMapEnter
# because GroundMapEnter is not guaranteed to fire on the canonical final
# Ground: if Ground.Enter calls EndDungeonRun (the canonical PMD Red rescue
# scene pattern), PMDO transitions away from that Ground before OnGroundMapEnter
# is published. See docs/dungeon_builder/RUNTIME_VALIDATION_ARCHITECTURE.md
# for the RogueEssence source references.
grounds=[row['id'] for row in rows if row.get('event')=='ground_init']
# expected_floors is the PROCEDURAL floor count (segment 0). Dungeons with a
# canonical fixed_room boss (mt_steel, mt_thunder_peak, mt_blaze_peak, ...)
# also have a `boss` map on segment>=1 with a species proof.
expected_floors={'tiny_woods':3,'thunderwave_cave':5,'silent_chasm':9,
                 'great_canyon':12,'mt_steel':8,'mt_thunder':10,
                 'lapis_cave':14,'mt_freeze':15,'mt_blaze':12,
                 'mt_thunder_peak':2,'mt_blaze_peak':2,'mt_freeze_peak':4}[zone]
expected_finals={'tiny_woods':'d01p02','thunderwave_cave':'d02p02',
                 'silent_chasm':'d05p02','great_canyon':'d07p02',
                 'mt_steel':'d03p02','mt_thunder':'d06p02',
                 'lapis_cave':'grotte_lazuli_fond','mt_freeze':'d11p02',
                 'mt_blaze':'d09p02','mt_thunder_peak':'d06p03',
                 'mt_blaze_peak':'d09p03','mt_freeze_peak':'d11p03'}
expected_final=expected_finals[zone]
# When a dungeon declares a canonical fixed-boss segment, we ALSO require the
# validator to have loaded the correct boss species and reported a boss_clear.
expected_boss={'mt_steel':{'species':'skarmory','map':'mt_steel_boss'},
               'mt_thunder_peak':{'species':'zapdos','map':'mt_thunder_peak_boss'},
               'mt_blaze_peak':{'species':'moltres','map':'mt_blaze_peak_boss'},
               'mt_freeze_peak':{'species':'glalie','map':'mt_freeze_peak_boss'}}
end=next((row for row in rows if row.get('event')=='end'),None)
canonical=next((row for row in rows if row.get('event')=='canonical_end'),None)
summary={'zone':zone,'events':len(rows),'procedural_maps':proc_maps,
         'boss_maps':boss_maps,'boss_clears':boss_clears,
         'grounds':grounds,'canonical_end':canonical,'fatals':fatals,'end':end}
print(json.dumps(summary,indent=2))
# Validation: floors 0..N-1 traversed, entrance seen, canonical final Ground
# reached, canonical_end emitted for that Ground, end emitted with success.
if fatals: raise SystemExit(1)
if proc_maps != list(range(expected_floors)): raise SystemExit(1)
if zone in expected_boss:
    exp=expected_boss[zone]
    if len(boss_maps)<1: raise SystemExit(1)
    for bm in boss_maps:
        if bm.get('boss_species')!=exp['species']: raise SystemExit(1)
        if bm.get('expected_boss_species')!=exp['species']: raise SystemExit(1)
    if not boss_clears: raise SystemExit(1)
if len(grounds) < 2 or expected_final not in grounds: raise SystemExit(1)
if not canonical or canonical.get('id') != expected_final: raise SystemExit(1)
if not end or not end.get('canonical_complete'): raise SystemExit(1)
for row in maps_all:
    if row.get('kind')=='canonical_fixed_boss':
        if not row.get('map_seed'): raise SystemExit(1)
    else:
        if not row.get('map_seed') or row.get('stairs',0)<1: raise SystemExit(1)
PY
  ! grep -Eq 'Missing Data|Could not deserialize|KeyNotFoundException|NullReferenceException|Lua Trace' "$LOG"
  echo "$ZONE route PASS: $OUT"
done
