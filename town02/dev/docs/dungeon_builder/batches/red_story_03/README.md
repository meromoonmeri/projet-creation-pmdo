# red_story_03 — Mt. Steel

Third PMD Red story batch. Introduces canonical **fixed-room boss** support to
the shared `red_story_batch` engine: the ROM's `fixed_room=1`
(`FIXED_ROOM_MT_STEEL_SKARMORY`) on floor 9 is materialised as a dedicated
`fixed_segments` entry pointing at a **pixel-exact `.rsmap` counterpart** of
the canonical Ground `d03p02.rsground`. The fight itself occurs on that
counterpart, whose visuals and geometry are byte-for-byte the canonical
Ground — the `.rsmap` is a technical representation of the ROM's fixed room,
never a standalone "boss arena" that visually or structurally departs from
`d03p02`.

## Status

**PROMOTED_RUNTIME_VALIDATED** (post-`bcd4d5fb` chain, this batch).

* Configuration gate: PASS (`canonical_gate.inspect` → `config_ready=true`)
* Audit gate: PASS (`readiness=READY_FOR_GENERATION`, `status=PASS`, no blockers)
* Native RogueElements mapgen: 90 / 90, 0 failures, 0 non-traversable, 0 invalid
* Route runtime (real PMDO 0.8.12 headless): entrance → 8 procedural floors →
  boss segment → canonical Skarmory clear → canonical Ground `d03p02` reached →
  end (`canonical_complete=true`)
* `canonical_battle_ground = d03p02`
* `rsmap_source = Data/Map/mt_steel_boss.rsmap`
* `rsmap_equivalence_verified = true`
* `battle_location_verified = true`
* `boss.roster = [{species: skarmory, level: [10,10], source_level: 10, provenance: PMD_RED_ROM}]`
* `boss.source_floor = 9`, `boss.source_fixed_room = 1`
* No regression on the four previously-promoted dungeons (tiny_woods,
  thunderwave_cave, silent_chasm, great_canyon), all re-verified with real
  PMDO 0.8.12 runtime after every change.

## Canonical provenance chain

| Aspect | Source | Evidence |
| --- | --- | --- |
| Dungeon name | PMD Red ROM | `Mt. Steel` / `Pic Ferreux` |
| Music | PMD Red EU ROM extraction | `Content/Music/Mt Steel.ogg` |
| Floors 1–8 (procedural) | PMD Red ROM manifest | `docs/canonical/red/mt_steel_rom_manifest.json` |
| Floor 9 (fixed) | PMD Red ROM manifest + `include/constants/fixed_rooms.h` | `FIXED_ROOM_MT_STEEL_SKARMORY` |
| DTEF (floors 1–5) | PMDO base + ROM tileset 39 | `mt_steel_1_floor/wall/secondary` |
| DTEF (floors 6–8) | PMDO base + ROM tileset 40 | `mt_steel_2_*` (variant, kept as override) |
| Boss species | PMD Red ROM manifest floor 9 Pokemon table | Skarmory level 10 |
| Boss `.rsmap` layout | Canonical Ground `d03p02.rsground` | `tools/make_ground_arena.py --ground d03p02 --name mt_steel_boss` (pixel-exact) |
| Post-battle scene | PMD Red ROM cinematic extraction | `Data/Script/halcyon/ground/d03p02/init.lua` (`SCENE_D03P02_*` keys, music "In the Depths of the Pit") |
| Entrance Ground | PMD Red ROM `d03p01` | `pic_ferreux_pied.rsground` |
| Final Ground | PMD Red ROM `d03p02` | `d03p02.rsground` (existing canonical) |

## Root-cause analysis: PMDC `FadeInEvent` blocked LoadGen `BeginFloor` in headless

An earlier attempt at this batch stalled on the boss segment: the
`EngineServiceEvents.DungeonFloorEnter` event never fired for the `LoadGen`
boss floor in headless mode. Instrumenting both `red_story_route_validator`
and `nre_probe` proved that the event was never published. The PMDO service-
log (`appdata/LOG/YYYY-MM-DD.txt`) stopped at
`LuaEngine.OnDungeonMapInit()..` for the boss and no `LuaEngine.OnDungeonMapEnter()..`
followed — meaning `Map.OnEnter()` was never reached.

Investigation of the RogueEssence 71236c63 + PMDCollab/PMDC sources traced
the stall to a chain of frame-tick-dependent yields inside
`DungeonScene.BeginFloor()`:

1. `moveToZoneInit` → `InitFloor` → `Map.OnInit` publishes
   `DungeonMapInit`, then `moveToZoneInit` yields on `BeginFloor()`.
2. `BeginFloor()` iterates `UniversalEvent.OnMapStarts` **before**
   calling `Map.OnEnter()` (which is what publishes `DungeonFloorEnter`).
3. `UniversalEvent.OnMapStarts` contains `PMDC.Dungeon.FadeInEvent`
   (`Data/Universal.json`), whose `Apply()` yields on
   `GameManager.Instance.FadeIn()` — the C# method, **not** the Lua-noop
   version the headless validator installs at startup.
4. `GameManager.FadeIn()` = `fadeScreen.Fade(false, ..., N)`. The fade
   coroutine has a fast-path at `RogueEssence/Scene/FadeEffect.cs:61`:
   `if (!fadeIn && fadeAmount == 0f) yield break;` — but after the
   previous segment's `EndSegment(FadeOut)`, `fadeAmount == 1f` (screen
   is black). So `FadeIn` actually needs to tick `N` frames.
5. Those frame waits cannot advance while we are inside the current
   `SceneOutcome` coroutine chain (`ScreenMainCoroutine` only iterates
   frames from its outer loop, and the outer loop is blocked on the
   ongoing outcome). Result: `FadeIn` yields forever, `BeginFloor` never
   completes, `Map.OnEnter` is never called, `DungeonFloorEnter` is
   never published.

The four procedural dungeons never hit this because floor-to-floor advance
inside the same segment does not go through `EndSegment` first, so the fade
is not primed to `1f` when their `BeginFloor` runs and `FadeIn` takes the
instant fast-path.

## Generic fix: reset fade to transparent at boss `DungeonMapInit`

`Data/Script/halcyon/services/red_story_route_validator/init.lua`
`OnDungeonMapInit` now calls
`RogueEssence.GameManager.Instance:SetFade(false, false)` when the current
map is a declared boss segment. This forces `fadeAmount == 0f` **before**
`BeginFloor`'s event queue runs `FadeInEvent`, so the C# `FadeIn()` takes the
fast-path (`!fadeIn && fadeAmount == 0f => yield break`) and completes
without waiting for frames. `BeginFloor` then advances normally,
`Map.OnEnter()` runs, `DungeonFloorEnter` publishes, and the boss-clear
`SceneOutcome = _GAME:EndSegment(Cleared, true)` reflection call
(unchanged from the sinister precedent) reaches
`ZoneManager.CurrentZone.OnExitSegment`, which runs the canonical
`mt_steel.ExitSegment` Lua and transitions to `d03p02` via
`GAME:EnterZone(zone.ID, -1, ZONE_GROUND_IDX(d03p02), 0)`.

Properties of the fix:

* **Generic**: applies to every dungeon that declares a `boss = { segment,
  map, species, ... }` in `CONFIG` and lands on that `LoadGen` floor after a
  faded segment transition. No `if zone == "mt_steel"` anywhere.
* **Scoped to the headless validator**: outside the validator (i.e. real
  gameplay), the canonical Ground scripts and `PMDC.FadeInEvent` behave
  exactly as before — the mod does not override them.
* **Preserves canonical Ground scripts**: `d03p02.Enter` is unchanged from
  its ROM-derived form (music switch to "In the Depths of the Pit",
  ordered ROM dialogue keys, canonical animations, then `EndDungeonRun`).
* **No per-Ground gate**: no `if os.getenv('PMDO_RED_STORY_ROUTE_VALIDATOR')
  == 'mt_steel'` in any Ground script.

## Architecture and engine changes

* `tools/dungeon_builder/red_story_batch_03.py` — Mt Steel CONFIG with
  procedural profiles (`steel_branch`, `steel_lattice`) and canonical
  `fixed_segments` declaration
  (`map=mt_steel_boss`, `ground=d03p02`, `source_floor=9`,
  `boss_species=["skarmory"]`).
* `tools/dungeon_builder/red_story_batch.py`:
  * `reconcile()` accepts ROM `fixed_floors` when CONFIG declares
    `fixed_segments`, emits `definition_floor_mode=procedural_only`,
    attaches the fixed segment to `raw["fixed_segments"]` with full ROM
    provenance (`source_pokemon`, `source_fixed_room`, `provenance`).
  * `raw["boss"]` gets `mode=canonical_ground`, `ground=<canonical
    Ground>`, `map=<pixel-exact .rsmap counterpart>`, `roster` derived
    from ROM Pokemon table filtered by CONFIG's `boss_species` allow-list.
  * `raw["scenes"]` gets `canonical_layout_source`, `rsmap_source`,
    `battle_ground`, `fixed_floor`, `fixed_room` per project rules.
  * `record_runtime` accounts for `LoadGen` floors in the mapgen count.
  * `record_routes` checks boss species/rsmap fidelity, emits
    `canonical_battle_ground` / `canonical_layout_source` / `rsmap_source`
    / `rsmap_equivalence_verified` / `battle_location_verified`.

## Route validator (generic boss support)

`Data/Script/halcyon/services/red_story_route_validator/init.lua`
* `CONFIG.mt_steel = {floors=8, entrance='pic_ferreux_pied', final='d03p02',
                     boss={segment=1, map='mt_steel_boss', species='skarmory',
                           source_floor=9, source_fixed_room=1,
                           provenance='PMD_RED_ROM/FIXED_ROOM_MT_STEEL_SKARMORY'}}`.
* `OnDungeonMapInit` inspects the boss map's `MapTeams` and asserts the
  loaded species matches the CONFIG's `boss.species` (ROM->rsmap fidelity
  proof), then resets fade (see root-cause analysis).
* `OnDungeonFloorEnter` emits `boss_clear` with `native_clear_hooks` count
  and triggers `_GAME:EndSegment(Cleared, true)` via `SceneOutcome`
  reflection, exactly like the sinister precedent for procedural
  `EndSegment`.

## Canonical assets and scripts

* `Data/Map/mt_steel_boss.rsmap`: pixel-exact contrepartie of
  `Data/Ground/d03p02.rsground` (19×23 tiles at 24 px, 1 canonical layer
  preserved from d03p02). Skarmory level 10 placed at the chamber centre.
  Entry points at the corridor entrance. Produced by
  `tools/make_ground_arena.py --ground d03p02 --name mt_steel_boss`.
* `Content/Tile/mt_steel_boss_Base_canonique.tile` (+ `index.idx`
  re-injected) — the tile package for the boss map's canonical layer.
* `Data/Script/halcyon/ground/d03p02/init.lua`: `SV.CanonicalDungeons`
  marker moved to head of `Enter` (aligns with d01p02/d02p02/d05p02/d07p02).
  Otherwise unchanged from its ROM-derived canonical form.
* `Data/Script/halcyon/zone/mt_steel/init.lua`: `ExitSegment` routes
  segment 0 → segment 1 (boss) via `EnterZone(zone, 1, 0, 0)`;
  segment 1 → canonical Ground `d03p02` via
  `EnterZone(zone, -1, ZONE_GROUND_IDX(d03p02), 0)`. No env-var gate.
* `Data/Zone/mt_steel.json`: 2 segments (8 procedural + 1 LoadGen boss).
* `Data/Zone/index.idx`: rebuilt via `update_zone_index()`
  (`CountedFloors=8`, `Maps=[[0..7],[0]]`,
  `Grounds=[pic_ferreux_pied, d03p02]`).
* `DungeonDefs/canonical/mt_steel.json`: canonical definition with proper
  DTEF (`mt_steel_1`, ROM tileset 39), canonical music (`Mt Steel.ogg`),
  boss block, fixed_segments block.

## Runtime artifacts

* `docs/dungeon_builder/batches/red_story_03/runtime/native_mapgen.jsonl`
  — 90/90 real PMDO 0.8.12 mapgen outcomes (8 procedural × 10 iter +
  1 boss × 10 iter): 0 failures, 0 non-traversable, 0 invalid. Procedural
  floors show real structural variety (rooms 11–22, halls 15–48,
  branches 3–10, loops 0–37); autotiles `mt_steel_1_floor/wall` confirmed.
  Boss LoadGen validates with `entry_ok=true, traversable=true, mobs=1`
  (Skarmory).
* `docs/dungeon_builder/batches/red_story_03/runtime/routes/mt_steel.jsonl`
  — real PMDO 0.8.12 route trace:
  `begin` → `ground_init(pic_ferreux_pied)` → `entrance_reached` → 8
  procedural `map`s with distinct `map_seed`s → `segment_clear(procedural)`
  → boss `map` with `boss_species=skarmory` matching
  `expected_boss_species=skarmory` → `boss_clear(native_clear_hooks=1,
  source_floor=9, source_fixed_room=1)` → `segment_clear(canonical_fixed_boss)`
  → `ground_init(d03p02)` → `canonical_end(d03p02)` → `end(canonical_complete=true)`.
