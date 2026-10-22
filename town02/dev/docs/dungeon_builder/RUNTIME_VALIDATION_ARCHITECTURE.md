# PMDO runtime validation architecture

Written after making Silent Chasm and Great Canyon PASS with the same generic
route validator that already worked for Tiny Woods and Thunderwave Cave, and
after making all four PASS without any per-dungeon script hack.

## Canonical PMDO runtime timeline (RogueEssence 0.8.12)

Verified against the source of `RogueEssence` on GitHub
(`RogueCollab/RogueEssence`), specifically:

* `RogueEssence/Scene/GameManager.cs`
  * `moveToZoneInit(entryPoint, newGround, newSegment, preserveMusic)` at line
    752 — the outer transition. When entering a Ground it:
    1. Fires `LuaEngine.Instance.OnGroundModeBegin()`
    2. Calls `GroundScene.Instance.EnterGround(entryPoint)`
    3. `yield` on `GroundScene.Instance.InitGround(false)`
    4. `yield` on `GroundScene.Instance.BeginGround()`
  * `MoveToZone(destId, ...)` at line 641: sanity-checks the target segment
    via `ZoneEntrySummary.SegLocValid(destId.StructID)`. That summary is
    written into `Data/Zone/index.idx` at export time and is what raises
    `Invalid Segment ID: 0 6` when the index disagrees with the ZoneData JSON.

* `RogueEssence/Ground/Maps/GroundMap.cs`
  * `OnInit()` at line 199:
    ```csharp
    LuaEngine.Instance.RunGroundMapScript(AssetName);
    LoadScriptEvents();
    foreach (GroundEntity entity in IterateEntities()) entity.OnMapInit();
    yield return CoroutineManager.Instance.StartCoroutine(RunScriptEvent(EMapCallbacks.Init));
    LuaEngine.Instance.OnGroundMapInit(AssetName, this);   // <-- event published HERE
    ```
    → **`EngineServiceEvents.GroundMapInit` fires AFTER `Ground.Init(map)`
       has finished, and BEFORE `Ground.Enter(map)` starts.**
  * `OnEnter()` at line 242:
    ```csharp
    yield return CoroutineManager.Instance.StartCoroutine(RunScriptEvent(EMapCallbacks.Enter));
    LuaEngine.Instance.OnGroundMapEnter(AssetName, this);  // <-- event published HERE
    ```
    → **`EngineServiceEvents.GroundMapEnter` fires ONLY after `Ground.Enter(map)`
       returns.** If `Ground.Enter` transitions to another scene (which PMD Red
       canonical rescue Grounds do — they call
       `GeneralFunctions.EndDungeonRun(...)`), the yield handoff happens
       first and PMDO switches scene BEFORE reaching the `OnGroundMapEnter`
       publish line. Any service subscribed only to `GroundMapEnter` will
       never hear about that Ground.

## What that means for a headless route validator

A validator that only listens to `GroundMapEnter` cannot observe the
canonical final Ground of a PMD Red dungeon, because on those Grounds
`Ground.Enter` legitimately calls `EndDungeonRun`. This is not a bug in the
Ground script — it is the correct PMD Red behaviour: the rescue Ground plays
its cinematic and unwinds the run in one atomic Enter step.

Therefore `RedStoryRouteValidator` (in
`Data/Script/halcyon/services/red_story_route_validator/init.lua`) subscribes
to **both** `GroundMapInit` and `GroundMapEnter` and only ever depends on
`GroundMapInit` for its route-progression logic. It also unloads the game
runtime as soon as the canonical final Ground is loaded, before
`Ground.Enter` on that Ground gets a chance to open the `FinalResultsMenu`
that `GameProgress.EndGame` (`RogueEssence/Data/GameProgress.cs:1290+`
Cleared branch) attaches for player-facing UX. In headless mode nobody would
dismiss that menu and PMDO would wait forever.

## What must NOT be done

The following patterns were considered and rejected because they violate the
"canonical Grounds stay canonical" contract:

1. Adding an `if os.getenv('PMDO_RED_STORY_ROUTE_VALIDATOR') == '<zone>'` early
   return inside canonical Grounds (`d05p02`, `d07p02`, `d01p02`, `d02p02`,
   `gouffre_muet_bord`, `grand_canyon_porte`, ...). The Ground script becomes
   different in the validation harness and in the actual game, which defeats
   the point of using a headless validator: we would no longer be validating
   the canonical route, only a route-shaped shadow of it.
2. Overriding `d05p02.Enter` (or any other final Ground) to skip
   `EndDungeonRun`. `EndDungeonRun` IS the canonical behaviour.
3. Making the validator's `Update` service poll `SV.CanonicalDungeons[zone]`
   until it flips. `Update` service ticks don't fire while a coroutine that
   opened `FinalResultsMenu` is waiting for player input.

## What IS done (all generic, no per-dungeon logic)

1. **The validator listens to `GroundMapInit`.** That callback happens after
   `Ground.Init` (`OnInit`) but before `Ground.Enter` (`OnEnter`), so we see
   every Ground the runtime ever loads, including the canonical final one.

2. **The validator declares success as soon as the canonical final Ground is
   loaded.** The `CONFIG.<zone>.final` name is compared against the Ground
   asset name on every `GroundMapInit`. When they match, the run is
   considered a runtime PASS: the mod's `ExitSegment` logic resolved the
   final Ground index correctly, PMDO's `MoveToZone` loaded the `.rsground`,
   the Ground script's `Init` ran successfully. Everything past that is
   canonical scene content, not a route contract.

3. **The validator sets `RogueEssence.GameBase.CurrentPhase =
   LoadPhase.Unload` before returning from `OnGroundMapInit`.** The next
   frame tears down the runtime cleanly, before `Ground.Enter` opens the
   post-run menu that would block in headless.

4. **`GAME.FadeIn / FadeOut / FadeInFront / FadeOutFront` are replaced by
   no-op Lua functions in `OnInit`.** These four functions are constructed
   as Lua table entries at engine startup by
   `RogueEssence/Lua/ScriptGameMisc.cs:70-73`
   (`state.RunString("return function(_, ...) return coroutine.yield(GAME:_FadeIn(...)) end")`),
   which means they can be legally reassigned from Lua — this is a
   supported extension point, not a monkey-patch of C# internals. In an
   interactive session fade animations do their canonical thing; in a
   headless test they compress to zero frames and canonical scripts run to
   completion in milliseconds.

5. **`COMMON.RespawnAllies` / `COMMON.RespawnGuests` in
   `Data/Script/halcyon/common.lua` pre-check the current Ground's
   `Spawners` collection before calling `SpawnerSetSpawn`/`SpawnerDoSpawn`.**
   PMDO's `ScriptGround.SpawnerSetSpawn` throws
   `System.ArgumentException` from C# when the spawner name is absent, and
   that exception propagates out of the coroutine before any Lua `pcall`
   can catch it. Many canonical PMD Red Grounds legitimately do not embed
   `TEAMMATE_N` / `GUEST_N` spawners (entrance and rescue Grounds where the
   party is not meant to be visible). The pre-check is a generic behaviour
   consistent with the runtime contract: absent spawner = no character to
   place. Grounds that DO ship the spawners still get them respawned.

## Terminal condition summary

The route contract enforced by `red_story_batch.record_routes` is:

* no `event="fatal"` from the validator
* `event="map"` events cover floors `[0, expected_floors-1]` exactly, in order
* every `event="map"` carries a non-empty `map_seed` and `stairs>=1`
* the canonical entrance Ground and the canonical final Ground both appear
  in the list of `event="ground_init"` observations (in that order)
* `event="canonical_end"` is emitted with `id == source_end` (the canonical
  final Ground declared in the dungeon definition)
* `event="end"` is emitted with `canonical_complete=true`

The old contract also required the run to loop back to the entrance Ground
(`grounds[0] == grounds[-1]`). That requirement was dropped because reaching
the canonical final Ground is the actual proof that the route is structurally
correct; the post-run return is a UX pass that a real player would trigger by
dismissing the `FinalResultsMenu`, and the headless harness has no player.
