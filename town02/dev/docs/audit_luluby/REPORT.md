# Luluby Town — import Waves of Nostalgia

## Provenance

Playable Grounds reconstructed directly from the supplied `WavetoNostalgia.NDS`
(SHA-256 `5d2b5c7b9942c7eca2115d486eec69b9060418b09fc215ad6f104d46b544f0db`):

- `OVERW1` → `luluby_town_morning` (2 source-rendered frames);
- `OVERW1E` → `luluby_town_evening` (2 source-rendered frames);
- `OVERW1N` → `luluby_town_night` (1 source-rendered frame).

The source is MAP_BG BMA/BPC/BPL/BPA data. No screenshot or cutscene image was used.
All maps are 84×72 cells. OVERW1's BMA collision is preserved. OVERW1E/N omit a
collision duplicate in the ROM, so the cell-identical OVERW1 collision is shared across
the three canonical visual variants; it is not generated from image colors.

## Residents

Ten residents and their positions come from `SCRIPT/OVERW1/enter.sse`: Dragonair,
Gourgeist, Eldegoss, Cinccino, two Stantler, Sableye, Comfey, Lycanroc and Anorith.
Each period has distinct dialogue for the Multi-Guild Tournament. The northern
Stantler provides the return to Metano.

## Access

The Metano destination menu now lists all three Luluby periods as Ground destinations.
A pre-existing destination-menu defect that displayed Grounds but never confirmed them
was corrected. Ground indices are resolved by name and `Data/Zone/index.idx` is synced.

## PMDO runtime evidence

PMDO/PMDC 0.8.12 loaded each real Ground and instantiated all ten residents:

```text
[LULUBY_RUNTIME] LOAD=luluby_town_morning period=morning residents=10 source=OVERW1
[LULUBY_RUNTIME] LOAD=luluby_town_evening period=evening residents=10 source=OVERW1
[LULUBY_RUNTIME] LOAD=luluby_town_night period=night residents=10 source=OVERW1
```

No Lua or C# exception occurred in these three runs. Runtime load and NPC construction
are PASS. Manual destination-menu selection and every dialogue interaction remain
`MANUAL_REVIEW`; they are not promoted to runtime PASS by the direct-entry probe.
