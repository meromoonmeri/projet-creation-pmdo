#!/usr/bin/env bash
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
