# PMU → PMDO intelligent adaptation (phase 2)

This is deliberately **not** a mechanical PMU-to-Ground converter. It is a
separate consumer of the immutable, source-certified phase-1 SQL snapshot.
Nothing here may overwrite `PMU_EXTRACTION/` or `.runtime-cache/pmu-extraction/`.

## Current gate

The `s1`–`s2000` public SQL snapshot is authorized as input. Encrypted V9-only
or alternate data remains out of scope: `s3000` has no adaptation plan and the
137 blocked overlap comparisons remain provenance caveats. Tile values 101 and
103 stay `UNKNOWN` on `s263`/`s268`.

A representative group now exercises actual native `.rsground`/`.tile`
composition at TexSize 1, 2 and 4, canonical collision/anchor materialization,
NPC mapping, PMDO 0.8.12 indexing/loading, free and blocked movement probes,
runtime captures and the exact Agent A termination gate. Technical runtime
success never bypasses artistic review: the current automatic composition is
explicitly rejected for generalization where buildings, water, relief or source
hierarchy remain visually incoherent.

## Why planning precedes Ground emission

A valid phase-2 result must preserve source topology and identity while choosing
map-local PMDO scale, native visual grammar, collision behavior, actors,
entrances, triggers and runtime scripts. Emitting 2,000 source-looking Grounds
before these choices would be the forbidden mechanical conversion described by
the project owner.

The first command therefore creates an exhaustive deterministic adaptation
contract for all 2,000 maps. It indexes clean PMDO Grounds as **visual grammar
references only**; their layouts are never copied. It selects no global viewport,
zoom, dimensions, skin or `TexSize`. A map with insufficient evidence remains
`UNVERIFIED`/`ADAPTATION_REQUIRED` rather than receiving a fabricated Ground.

```bash
.runtime-cache/pmu-venv/bin/python PMU_ADAPTATION/pmu_adaptation.py plan
.runtime-cache/pmu-venv/bin/python PMU_ADAPTATION/pmu_adaptation.py compose-representative
.runtime-cache/pmu-venv/bin/python PMU_ADAPTATION/pmu_adaptation.py validate-representative
.runtime-cache/pmu-venv/bin/python PMU_ADAPTATION/pmu_adaptation.py review-representative
.runtime-cache/pmu-venv/bin/python PMU_ADAPTATION/pmu_adaptation.py publish-representative
.runtime-cache/pmu-venv/bin/python PMU_ADAPTATION/tests.py
```

Bulk per-map plans are written to `.runtime-cache/pmu-adaptation/plans/`.
Tracked summaries are written to `PMU_ADAPTATION/reports/`.

## Non-negotiable final Ground gate

A map may become `CERTIFIED` only after all of the following exist and pass:

1. immutable phase-1 source PNG and IR hash verification;
2. map-local PMDO composition from structured elements, never a screenshot map;
3. native `.rsground`, `.tile`/AutoTile dependencies, collisions and entities;
4. entrances, warps, NPCs, objects and proved script/story transitions;
5. deterministic PMDO render(s) and source-vs-adaptation anchor comparison;
6. visual review preserving emptiness, hierarchy and gameplay readability;
7. exact PMDO 0.8.12 load, free/blocked movement and animation probes through
   Agent A's ignored-overlay + patched-SDL + SwiftShader/ANGLE method.

The planner does not emit a Ground. The separate composer may emit candidates,
but only the runtime + visual-review chain can advance their status; rejected
representative candidates remain `RUNTIME_TESTED`/`BLOCKED` and are not
generalized.
