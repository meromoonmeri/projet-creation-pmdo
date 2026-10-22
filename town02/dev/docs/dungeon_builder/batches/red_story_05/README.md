# red_story_05 — Lapis Cave

Fifth PMD Red story batch. Purely procedural 14-floor cave dungeon (no
fixed_room in ROM manifest). Same shape as silent_chasm / great_canyon /
mt_thunder: procedural floors + canonical end Ground scene.

## Status: PROMOTED_RUNTIME_VALIDATED

* Native RogueElements mapgen: **140 / 140** (14 procedural × 10 iterations)
* Route runtime (real PMDO 0.8.12 headless): entrance `grotte_lazuli_seuil`
  → 14 procedural floors with distinct `map_seed`s → `segment_clear` →
  canonical Ground `grotte_lazuli_fond` reached → `canonical_end` →
  `end (canonical_complete=true)`
* `canonical_end_ground = grotte_lazuli_fond` = `cinematic_ground` =
  `battle_ground`
* `boss.mode = canonical_ground`, `boss.ground = grotte_lazuli_fond`

## Canonical provenance

| Aspect | Source | Evidence |
| --- | --- | --- |
| Dungeon name | PMD Red ROM | `Lapis Cave` / `Grotte Lazuli` |
| Music | PMD Red EU ROM extraction | `Content/Music/Lapis Cave.ogg` |
| Floors 1–14 (all procedural) | PMD Red ROM manifest | `docs/canonical/red/lapis_cave_rom_manifest.json` (all tileset 45, layout 1) |
| DTEF | PMDO base | `lapis_cave_floor/wall/secondary` |
| Entrance Ground | canonical PMD Red d08p01 layout | `Data/Ground/grotte_lazuli_seuil.rsground` (already extant) |
| Entrance scene | ROM `d08p01.cif.json` | `Data/Script/halcyon/ground/grotte_lazuli_seuil/init.lua` (existing) |
| Final Ground | canonical PMD Red d08p02 layout | `Data/Ground/grotte_lazuli_fond.rsground` (already extant) |
| Final scene | ROM `d08p02.cif.json` | `Data/Script/halcyon/ground/grotte_lazuli_fond/init.lua` (SV.CanonicalDungeons marker now at head of Enter, aligned with all other final Grounds) |

## Cleanup vs. previous implementation

* `DungeonDefs/canonical/lapis_cave.json`: previously had 2 segments split
  as 7+7. Now a single 14-floor segment matching silent_chasm/great_canyon
  pattern — no artificial mid-run zone re-entry.
* `Data/Script/halcyon/zone/lapis_cave/init.lua`: rewritten to 1 segment
  with direct transition to `grotte_lazuli_fond` via
  `GAME:EnterZone(zone.ID, -1, ZONE_GROUND_IDX(...), 0)` — the same
  pattern as silent_chasm/great_canyon/mt_thunder/mt_steel. No env-var
  gate, no per-dungeon hack.
* `Data/Script/halcyon/ground/grotte_lazuli_fond/init.lua`:
  `SV.CanonicalDungeons` marker moved to head of `Enter` — aligns with
  d01p02/d02p02/d05p02/d07p02/d03p02/d06p02.

## Runtime artifacts

* `docs/dungeon_builder/batches/red_story_05/runtime/native_mapgen.jsonl`
* `docs/dungeon_builder/batches/red_story_05/runtime/routes/lapis_cave.jsonl`
* `docs/dungeon_builder/reports/lapis_cave.{json,md}` — regenerated Builder report.
