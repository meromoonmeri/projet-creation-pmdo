#!/usr/bin/env bash
# Campagne runtime complète: toutes les zones non encore testées, par lots.
# Chaque lot est une exécution PMDO réelle; la matrice s'agrège dans
# dev/docs/canonical_dungeon_runtime/matrix.json.
set -u
cd "$(dirname "$0")/../.."
ITER="${1:-1}"
LOG=/tmp/canonical_all.log
: > "$LOG"

# Garde-fou CH1-5 : la campagne refuse de démarrer si une ressource
# verrouillée a été altérée (vérification byte-exacte vs 0f691fa3).
python3 dev/tools/ch1_5_lockfile.py check > /dev/null || {
  echo "ABANDON: violation du verrou CH1-5 (dev/tools/ch1_5_lockfile.py check)" | tee -a "$LOG"
  exit 3
}

BATCHES=(
  "buried_relic,joyous_tower"
  "purity_forest,silver_trench"
  "western_cave,far_off_sea"
  "southern_cavern,jardin_secret,mt_faraway,stormy_sea"
  "fantasy_strait,fiery_field,lightning_field,northwind_field"
  "grand_sea,marvelous_sea,desert_region,northern_range"
  "pitfall_valley,wyvern_hill,solar_cave,darknight_relic"
  "waterfall_pond,unown_relic,remains_island,oddity_cave,murky_cave"
  "meteor_cave,magma_cavern_pit,sealed_ruin,sealed_ruin_pit"
  "frosty_forest,frosty_grotto,uproar_forest,howling_forest,gloomy_forest"
  "great_canyon,lapis_cave,mt_blaze,mt_blaze_peak,mt_freeze,mt_freeze_peak"
  "mt_steel,mt_thunder,mt_thunder_peak,silent_chasm,thunderwave_cave,tiny_woods"
  "sky_tower_summit,snow_path,rock_path,chasm_cave,dark_hill"
  "dusk_forest,foret_embuscade,bois_filou,bois_ronces,bosquet_voile"
  "antre_enigme,apricorn_grove,beginner_lesson,carriere_cuivre,cloven_ruins"
  "crooked_cavern,grotte_repos,grotte_echoue,grotte_mystere,halles_royales"
  "illuminant_riverbed,passage_temps,petit_tunnel,jardin_secret"
  "mount_windswept,vast_steppe,vallee_fertile,relic_forest,spiritomb_room"
  "bug_maze,electric_maze,fire_maze,flying_maze,grass_maze"
  "normal_maze,rock_maze,water_maze,nnv_wild,searing_tunnel"
)

for batch in "${BATCHES[@]}"; do
  echo "=== BATCH $batch ===" >> "$LOG"
  python3 dev/tools/canonical_dungeon.py test "$batch" \
    --iterations "$ITER" --timeout 1650 >> "$LOG" 2>&1
done
echo "CAMPAGNE_TERMINEE" >> "$LOG"
