# red_story_06 — Mt. Freeze

Sixth PMD Red story batch. Purely procedural 15-floor dungeon (no
fixed_room in ROM manifest — the Ninetales fight is on `mt_freeze_peak`,
a separate ROM dungeon, reached via the canonical relay Ground `d11p02`).

## Status: PROMOTED_RUNTIME_VALIDATED

* Native RogueElements mapgen: **150 / 150** (15 procedural × 10 iterations)
* Route runtime (real PMDO 0.8.12 headless): entrance `mont_gele_pied` →
  15 procedural floors with distinct `map_seed`s → `segment_clear` →
  canonical Ground `d11p02` reached → `canonical_end` →
  `end (canonical_complete=true)`
* `canonical_end_ground = d11p02` = `cinematic_ground` = `battle_ground`
* `boss.mode = canonical_ground`, `boss.ground = d11p02`

## Canonical provenance

| Aspect | Source | Evidence |
| --- | --- | --- |
| Dungeon name | PMD Red ROM | `Mt. Freeze` / `Mont Gelé` |
| Music | PMD Red EU ROM extraction | `Content/Music/Mt Freeze.ogg` |
| Floors 1–15 (all procedural) | PMD Red ROM manifest | `docs/canonical/red/mt_freeze_rom_manifest.json` (all tileset 47) |
| DTEF | PMDO base | `mt_freeze_floor/wall/secondary` |
| Entrance Ground | existing | `Data/Ground/mont_gele_pied.rsground` |
| Final Ground | canonical PMD Red d11p02 | `Data/Ground/d11p02.rsground` (existing) |
| Final scene | ROM `d11p02.cif.json` | `Data/Script/halcyon/ground/d11p02/init.lua` (SV.CanonicalDungeons marker now at head of Enter) |

## Cleanup

* `Data/Ground/mt_freeze_midpoint.rsground` → moved to
  `RESERVE/legacy_ch6_32/deprecated_grounds/` (Kangourex station clone,
  deprecated per the "no visual copy from another dungeon" rule).
* `Data/Script/halcyon/ground/mt_freeze_midpoint/` → deleted.
* `Data/Script/halcyon/zone/mt_freeze/init.lua` → rewritten to 1 segment
  with direct transition to `d11p02`.

## Runtime artifacts

* `docs/dungeon_builder/batches/red_story_06/runtime/native_mapgen.jsonl`
* `docs/dungeon_builder/batches/red_story_06/runtime/routes/mt_freeze.jsonl`
