# red_story_08 — mt_thunder_peak

PMD Red canonical peak dungeon with a **fixed_room boss** on the final
floor (same generic LoadGen infrastructure as mt_steel).

* ROM: 3 floors total, floor 3 = FIXED_ROOM (canonical constant,
  fixed_room=3 in the ROM manifest = MT_THUNDER_PEAK).
* Boss: **Zapdos** (per ROM `data/dungeon/*.json`).
* Procedural floors 1..2 via RogueElements native mapgen.
* Fixed boss floor via LoadGen + `Data/Map/mt_thunder_peak_boss.rsmap` (pixel-exact
  counterpart of `Data/Ground/d06p03.rsground` via
  `tools/make_ground_arena.py`). Not an unrelated arena.
* Canonical entrance for validator: the base dungeon's relay Ground
  `d06p02` (which chains into `EnterDungeon('mt_thunder_peak', 0, 0, 0)`
  after playing the canonical relay cinematic — exactly what PMD Red does).
* Canonical final Ground: `d06p03` (existing PMD Red end scene).

## Status: PROMOTED_RUNTIME_VALIDATED

* Native RogueElements mapgen: **30 / 30** (2 procedural × 10 iter + 1 boss × 10 iter)
* Route runtime (real PMDO 0.8.12 headless):
  * entrance `d06p02` loaded → `entrance_reached`
  * 2 procedural map events with distinct `map_seed`s and stairs
  * `segment_clear(procedural)` on segment 0
  * boss segment 1 loaded with pixel-exact `mt_thunder_peak_boss.rsmap`, canonical
    species `zapdos` matches `expected_boss_species=zapdos`
  * `boss_clear(source_floor=3, source_fixed_room=3,
    native_clear_hooks=1)`
  * `segment_clear(canonical_fixed_boss)`
  * canonical Ground `d06p03` reached → `canonical_end` →
    `end(canonical_complete=true)`
* `canonical_battle_ground = d06p03`
* `rsmap_source = Data/Map/mt_thunder_peak_boss.rsmap`
* `rsmap_equivalence_verified = true`
* `battle_location_verified = true`

## Runtime artifacts

* `docs/dungeon_builder/batches/red_story_08/runtime/native_mapgen.jsonl`
* `docs/dungeon_builder/batches/red_story_08/runtime/routes/mt_thunder_peak.jsonl`
* `docs/dungeon_builder/reports/mt_thunder_peak.{json,md}` — regenerated.
