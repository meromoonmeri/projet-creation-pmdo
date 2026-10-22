# red_story_04 — Mt. Thunder

Fourth PMD Red story batch. Purely procedural 10-floor dungeon (no
fixed_room in the ROM manifest — the Zapdos fight belongs to the separate
`mt_thunder_peak` dungeon, chained via the canonical relay Ground
`d06p02`). Reuses the same shape as silent_chasm / great_canyon: procedural
floors + canonical end Ground.

## Status: PROMOTED_RUNTIME_VALIDATED

* Configuration + audit gates PASS
* Native RogueElements mapgen: **100 / 100** (10 procedural × 10 iterations,
  0 failures, 0 non-traversable, 0 invalid)
* Route runtime (real PMDO 0.8.12 headless): entrance
  `mont_grondant_pied` → 10 procedural floors with distinct `map_seed`s →
  `segment_clear` → canonical Ground `d06p02` reached → `canonical_end` →
  `end (canonical_complete=true)`
* No boss segment (Mt Thunder ROM has no fixed_room)
* `canonical_end_ground = d06p02` = `cinematic_ground` = `battle_ground`

## Canonical provenance

| Aspect | Source | Evidence |
| --- | --- | --- |
| Dungeon name | PMD Red ROM | `Mt. Thunder` / `Mont Grondant` |
| Music | PMD Red EU ROM extraction | `Content/Music/Mt. Thunder.ogg` |
| Floors 1–10 (all procedural) | PMD Red ROM manifest | `docs/canonical/red/mt_thunder_rom_manifest.json` |
| DTEF | PMDO base + ROM tileset 42 | `mt_thunder_floor/wall/secondary` |
| Entrance Ground | ROM d06p01 layout | `Data/Ground/mont_grondant_pied.rsground` (pixel-copy of `d06p01.rsground` with canonical name/UI) |
| Entrance scene | ROM cinematic `d06p01.cif.json` | `Data/Script/halcyon/ground/mont_grondant_pied/init.lua` (`SCENE_D06P01_*` keys, music "Mt. Thunder") |
| Final Ground | ROM d06p02 | `Data/Ground/d06p02.rsground` (existing canonical relay) |
| Final scene | ROM cinematic `d06p02.cif.json` | `Data/Script/halcyon/ground/d06p02/init.lua` (SV.CanonicalDungeons marker at head of Enter — matches the pattern used by all other final Grounds) |

## Cleanup of legacy artifacts

* `Data/Ground/mt_thunder_midpoint.rsground` → moved to
  `RESERVE/legacy_ch6_32/deprecated_grounds/`. This was a Terminal
  Kangourex station clone (biome copied from Sky-mod midpoint) — deprecated
  per the "no visual copy from another dungeon" rule.
* `Data/Script/halcyon/ground/mt_thunder_midpoint/` → deleted.
* `Data/Script/halcyon/zone/mt_thunder/init.lua` → rewritten to match the
  silent_chasm/great_canyon pattern (1 segment, direct transition to
  `d06p02`, no intermediate midpoint call).
* `DungeonDefs/canonical/mt_thunder.json` `wiring.segment_exits` cleaned:
  no longer references `mt_thunder_midpoint`.
* `porte_plaines_foudre.rsground` (16×12 legacy stub) is kept in
  `Data/Ground/` for potential future re-use but no longer part of the
  canonical Mt Thunder wiring.

## Runtime artifacts

* `docs/dungeon_builder/batches/red_story_04/runtime/native_mapgen.jsonl`
  — 100 real PMDO 0.8.12 mapgen outcomes.
* `docs/dungeon_builder/batches/red_story_04/runtime/routes/mt_thunder.jsonl`
  — real PMDO 0.8.12 route trace end-to-end.
* `docs/dungeon_builder/reports/mt_thunder.{json,md}` — regenerated Builder
  report reflecting the canonical implementation.
