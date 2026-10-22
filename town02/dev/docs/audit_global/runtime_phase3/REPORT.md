# Phase 3 runtime arena repairs

## Root cause discovered globally
Nineteen fixed `.rsmap` arenas had `DiscoveryArray` dimensions left at a copied
15×18 template while their real `Tiles` dimensions differed. PMDO uses this array
in `Map.discoveryLightOp`; undersized arrays crash during `EnterMap` before player
control. All 19 arrays were resized exactly to each map's serialized Tiles grid.

## Groudon
`magma_cavern_pit` had three independent contamination defects:
- `CurrentForm=zeraora` while `BaseForm=groudon`;
- Dark/Grass and non-Groudon moves;
- position `(7,5)`, a solid tile outside the walkable arena.

The walkable arena bounds are x=6..14, y=6..14. Groudon now uses Ground/None,
Groudon in CurrentForm/BaseForm, and position `(10,7)` on the arena's north-center
axis facing the party. Canonical provenance: `pret/pmd-red`,
`data/dungeon/MagmaCavernPit/pokemon_found.json`, Groudon on canonical 3F, level 27.
New Era's adapted boss level 37 is retained and documented rather than silently
replaced.

Real PMDO 0.8.12 evidence after correction:

```text
DungeonFloorEnter ... map=magma_cavern_pit TeamAttachee=OUI(4) foes=1
boss_species=groudon boss_level=37 boss_x=10 boss_y=7
verdict=BATTLE_START_PASS
```

This is not victory/post-battle validation.

## Tornadus
After resizing its 15×18 stale DiscoveryArray to the actual 15×14 arena, real PMDO
again reached `DungeonFloorEnter`, with attached party and Tornadus `(7,5)`.
Result remains `BATTLE_START_PASS`, not complete-cutscene PASS. Intro, victory,
post-battle, save/reload and repeat remain NOT_TESTED/FAIL from the prior probe.
