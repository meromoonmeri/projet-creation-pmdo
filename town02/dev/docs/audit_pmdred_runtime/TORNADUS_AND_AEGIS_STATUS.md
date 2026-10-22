# Tornadus / Aegis Cave — runtime status

Date: 2026-08-08 — PMDO/PMDC 0.8.12 Linux, offscreen OpenGL.

## Tornadus

### Reproduced root cause

The real engine raised:

`System.InvalidOperationException: Attempted to move character to X:13 Y:17 out of bounds!`

Stack: `PMDC.Dungeon.BattlePositionEvent.MoveChar` → `DungeonScene.BeginFloor`.
The arena is 15×14. `BattlePositionEvent.StartLocs` incorrectly contained absolute-looking
coordinates `(6,10),(5,10),(4,10),(4,11)` although PMDC treats them as offsets from the
entry `(7,7)`. This produced `(13,17)` and aborted floor initialization before control.

### Correction

`StartLocs` now uses valid relative formation offsets `(0,0),(-1,1),(1,1),(0,2)` and
`Positions=null`, matching PMDC boss-map semantics. Rain (`heavy_rain`, `falling_rain`,
`light_rain`) and `fog` are explicitly removed at scene entry, retry, battle transition,
and post-battle. No Tornadus scene adds rain/fog anymore.

### Runtime evidence after correction

`DungeonModeBegin` → map `mount_windswept_guardian`, team attached at map init, one enemy
team; `DungeonFloorEnter` completed with no exception; boss is `tornadus`, level 33,
position `(7,5)`. Validator verdict: `BATTLE_START_PASS`.

This proves battle initialization and entry into dungeon control mode. Victory and the
post-battle route were not automatically played in this run and remain `INCONCLUSIVE`.
See `TORNADUS_RUNTIME.log` and `TORNADUS_RUNTIME.jsonl`.

## Aegis Cave / Cloven Ruin

Current implementation contains eight dungeon segments and working code paths for the
three Unown seals, Regice, Regirock, Registeel, the Pit and Regigigas. However, this run
did **not** execute the complete arc, battles, save/reload, or chapter transition.

The Sky port itself records an unresolved provenance contradiction: its friendly
`aegis_cave_*` aliases use MAP_BG group `d32`, while `pret/pmd-sky` identifies dungeon
IDs 54–61 for Ice Aegis Cave through Regigigas. Therefore no canonical-arena import is
claimed here until the dungeon→MAP_BG table and actual d54–d61 maps are verified.

Verdict: `INCONCLUSIVE / MANUAL_REVIEW`, not PASS.
