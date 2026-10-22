# PHASE 2 — Repair results (current batch)

This is an intermediate repair batch, not Phase-2 completion.

| Finding | Discovery baseline | Before this batch | After | Delta this batch |
|---|---:|---:|---:|---:|
| TRUE_INVALID_TEXLOC | 189 | 0 | 0 | 0 |
| MISSING_SHEET | 7 false blank-sheet refs | 0 | 0 | 0 |
| MARKER_OUT_OF_BOUNDS | 38 geometry false positives | 0 | 0 | 0 |
| SPAWNER_OUT_OF_BOUNDS | 52 | 12 | 12 | 0 |
| CROSS_DUNGEON_FLOOR_NAME | 22 | 22 | 10 | -12 |
| ORPHAN_GROUND | 3 | 3 | 3 | 0 |
| INVALID_TRANSITION_TARGET | 3 | 3 | 3 | 0 |

## Floor identity repairs
Canonical identities restored for Frosty Forest/Frosty Grotto, Lapis Cave,
Magma Cavern/Magma Cavern Pit, Wish Cave, and the three procedural Sky Tower
segments. These edits affect each segment's own `FloorNameDropZoneStep`; no
Ground or segment index was redirected.

The ten remaining findings are special/rematch segments whose actual MapIDs
show deeper cross-zone ownership contamination (`annexe_toupie`,
`verdant_oath_arena`, Sky Tower special Grounds, etc.). They are not fixed by
renaming because that would conceal the structural defect.

## Tornadus
- BEFORE: `RUNTIME_FAIL`
- AFTER: `RUNTIME_FAIL`
- CUTSCENE_END: not reached
- Probe change attempted: remove re-entrant FadeOut while incoming transition
  already owns black display.
- Result: direct probe still stopped after scene start.
- Decision: experimental change reverted; no false fix committed.
- ROOT CAUSE: still unproven for production parent-dungeon route.
- REGRESSION: FAIL/INCONCLUSIVE.

`TORNADUS_PHASE2_PROBE.log` is the evidence. Tornadus remains a
`CRITICAL_RUNTIME_BLOCKER`.

## Chapters 6–10 narrative baseline
A new reproducible staging audit counts dialogue API calls, movement, turns,
reactions, camera events and pauses, and lists dialogue-heavy scenes lacking
staging. Chapter 8–10 remain below the requested density. Runtime status remains
`NOT_TESTED`; no dialogue padding was generated.
