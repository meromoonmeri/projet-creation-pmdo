# Aegis Cave runtime repair progress — 2026-08-08

## Proven P0 defect

Real PMDO loading of all four boss segments initially failed before gameplay:

- segment 1: `Could not convert string to integer: cloven_ruins_regice` at `Object.ID`;
- segment 3: same for `cloven_ruins_regirock`;
- segment 5: same for `cloven_ruins_registeel`;
- segment 7: same for `sanctuaire_titans`.

The four `.rsmap` files stored a string asset name in integer field `Object.ID`.
They now store integer `0`, while `AssetName` keeps the stable textual ID.

## Runtime retest

After repair, PMDO successfully reached for Regice:

`DungeonModeBegin map=cloven_ruins_regice foes=1`
→ `DungeonMapInit ... TeamAttachee=OUI(4) foes=1`

The automatic run then remained in the interactive arrival cutscene (dialogue input is
not synthesized). Therefore:

- arena deserialization: `LOAD_PASS`;
- team attachment: `ENTITY_SETUP_PASS`;
- arrival cutscene completion: `INCONCLUSIVE`;
- battle start/victory/post-battle: `INCONCLUSIVE`.

The other three arenas have the same certain serialization correction, but were not
allowed to inherit a runtime PASS from Regice.

## Tornadus regression

The preceding real-engine run reached `DungeonFloorEnter` with Tornadus `(7,5)`, level
33, after fixing `BattlePositionEvent` offsets. This remains `BATTLE_START_PASS`; no
victory/post-battle claim is made.

## Validator limitation

A retained `TASK:BranchCoroutine` created from `GroundMapEnter` still does not advance
in PMDO 0.8.12. Movement remains `INCONCLUSIVE`; it is not converted to PASS. A future
runner must schedule from a map coroutine or inject real controller input.
