# red_story_07 — Mt. Blaze

Seventh PMD Red story batch. Purely procedural 12-floor dungeon (no
fixed_room in ROM manifest — the Moltres fight is on `mt_blaze_peak`, a
separate ROM dungeon, reached via the canonical relay Ground `d09p02`).

## Status: PROMOTED_RUNTIME_VALIDATED

* Native RogueElements mapgen: **120 / 120** (12 procedural × 10 iterations)
* Route runtime (real PMDO 0.8.12 headless): entrance `mont_cendre_pied` →
  12 procedural floors with distinct `map_seed`s → `segment_clear` →
  canonical Ground `d09p02` reached → `canonical_end` →
  `end (canonical_complete=true)`
* `canonical_end_ground = d09p02` = `cinematic_ground` = `battle_ground`
* `boss.mode = canonical_ground`, `boss.ground = d09p02`

## Canonical provenance

| Aspect | Source | Evidence |
| --- | --- | --- |
| Dungeon name | PMD Red ROM | `Mt. Blaze` / `Mont Cendré` |
| Music | PMD Red EU ROM extraction | `Content/Music/Mt. Blaze.ogg` (pre-existing) |
| Floors 1–12 (all procedural) | PMD Red ROM manifest | `docs/canonical/red/mt_blaze_rom_manifest.json` (all tileset 46) |
| DTEF | PMDO base | `mt_blaze_floor/wall/secondary` |
| Entrance Ground | existing | `Data/Ground/mont_cendre_pied.rsground` |
| Final Ground | canonical PMD Red d09p02 | `Data/Ground/d09p02.rsground` (existing) |
| Final scene | ROM `d09p02.cif.json` | `Data/Script/halcyon/ground/d09p02/init.lua` (SV.CanonicalDungeons marker now at head of Enter) |

## Cleanup

* `Data/Ground/mt_blaze_midpoint.rsground` → moved to
  `RESERVE/legacy_ch6_32/deprecated_grounds/` (Kangourex station clone).
* `Data/Script/halcyon/ground/mt_blaze_midpoint/` → deleted.
* `Data/Script/halcyon/zone/mt_blaze/init.lua` → rewritten to 1 segment
  with direct transition to `d09p02`.

## Runtime artifacts

* `docs/dungeon_builder/batches/red_story_07/runtime/native_mapgen.jsonl`
* `docs/dungeon_builder/batches/red_story_07/runtime/routes/mt_blaze.jsonl`
