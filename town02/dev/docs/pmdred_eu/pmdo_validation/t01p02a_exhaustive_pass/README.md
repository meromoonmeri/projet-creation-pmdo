# `t01p02a` exhaustive exact-PMDO validation

## Verdict

`PASS` — promoted additively on 2026-08-12 after exhaustive validation of the exact canonical Ground and tile in PMDO 0.8.12.

| Gate | Result |
| --- | --- |
| Full-RGBA visual comparison | 817/817 full-map runtime samples pixel-exact at 456×624; 0 mismatched pixels; maximum channel delta 0 |
| Opacity | 817/817 fully opaque |
| Tiles and palettes | Authenticated raw EU BPL/BPC/BPA/BMA reference matched exact PMDO output at every planned sample |
| Animation | One six-frame BPA channel and six BPL palette channels; all 816 planned two-local-cycle boundary ticks through tick 2687 passed, plus reload tick 0 |
| Collision | One BMA layer with 3,802 solid cells; clear movement `(0, 8)` and blocked movement `(0, 0)` both passed |
| Lifecycle | Two loads, two exits, one same-Ground re-entry, and strict lifecycle order passed |
| Cleanup/reload | Four cleanup probes passed; reload tick 0 remained full-RGBA exact; terminal `end` observed; no PMDO orphan remained |
| Project integration | Additive lowercase destination and zone registration; the separate `sky_eos_t01p02a` Ground/tile/script/entities remain byte-identical and separately registered |
| Classification | Canonical source: Whiscash Pond Open, a standard overworld/story-cinematic venue; not an arena or boss Ground. Project contains an unrouted Fugitive cinematic scene with this stable ID; that later scene is not claimed validated |
| Destination | `Data/Ground/t01p02a.rsground`; `Content/Tile/t01p02a_Base.tile`; registered in `Data/Zone/master_zone.json` |
| Promotion | `PROMOTED_ADDITIVE_CANONICAL`; lowercase destinations were absent, so no active file was replaced; all historical and EoS variants remain retained |

The exact PMDO executable SHA-256 was `faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327`. The authenticated EU ROM SHA-256 was `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`.

## Exhaustive animation plan

The canonical Ground has seven independently derived animation channels:

- BPA tile channel 0: six frames of seven ticks, cycle 42;
- BPL palette channel 0: seven frames of eight ticks, cycle 56;
- BPL palette channel 1: three frames of eight ticks, cycle 24;
- BPL palette channel 2: eight frames of eight ticks, cycle 64;
- BPL palette channel 8: six frames of eight ticks, cycle 48;
- BPL palette channel 9: seven frames of eight ticks, cycle 56;
- BPL palette channel 10: six frames of eight ticks, cycle 48.

Actual map cells use 18 distinct local channel combinations. Their local cycles range from 24 through 1,344 ticks. The authenticated schema-v2 plan takes the transition-boundary union over two complete cycles of every used combination: 816 unique primary ticks from 0 through 2,687. Every primary capture and the independent reload capture at tick 0 matched the raw-resource EU-ROM renderer over the complete RGBA image. The 816 primary captures contain 336 distinct RGBA states.

The durable PNG set preserves representative first, final-cycle-boundary, and post-reload comparisons. `report.json` retains dimensions, RGBA hashes, mismatched-pixel counts, maximum channel deltas, opacity, capture hashes, and comparative paths for all 817 samples.

## Canonical identity and project routing

The authenticated extraction identifies `t01p02a` as canonical debug ID 2, map ID 3, map file ID 3, Ground place ID 3, conversion type 1, and weather ID 9. At pinned `pret/pmd-red` commit `bf0092d0e34fd8e49b859a0b5f96f00740faa42d`, ground-map enum index 3 is `MAP_WHISCASH_POND_OPEN`. This Ground is therefore the open-state Whiscash Pond map.

The repository previously had no lowercase canonical destination or `master_zone` registration. It did have:

- an older historical Red import in `RESERVE/red_grounds/` and `RESERVE/red_tiles/`;
- a distinct active Explorers of Sky alias, `sky_eos_t01p02a`, using uppercase tile ID `T01p02a_Base`, three spawners, and an entrance marker;
- `FugitiveCinematics.SCENES.t01p02a` and `arc_fugitif/scene/t01p02a.lua`, but no `t01p02a` entry in `FugitiveArc.SEQUENCE`, no `ground/t01p02a/init.lua`, and no prior route to this Ground.

Promotion therefore added the exact tested lowercase Red artifact and one lowercase `master_zone` entry without importing unproven entities or rewiring the Fugitive arc. Hash gates prove the EoS Ground and tile were unchanged. The dormant cinematic identifier is documented as intended project reuse, not treated as proof that its dialogue, actors, camera, music, choreography, transitions, or cleanup are canonical or complete.

## Collision and lifecycle

The BMA-derived obstacle grid has one collision layer and 3,802 solid cells; its canonical collision hash is `6325171524c91210845ff95362c2e17bb2c06c91380a49fbd70d2332630b7945`. On the primary load, exact PMDO moved the actor from a clear aligned footprint by `(0, 8)` and rejected the adjacent solid-footprint move with `(0, 0)`. Both probes passed.

The native lifecycle then captured all 816 primary ticks, exited and finalized the Ground, re-entered the same Ground, captured reload tick 0, exited and finalized it again, and entered an inert sink. Two `ground_exit`, `sink_entered`, and `final_cleanup` probes all reported `PASS`; the strict lifecycle checker closed both declared loads and observed terminal `end`. PMDO does not self-close on the validator's terminal event, so the bounded wrapper terminated its dedicated process group only after durable final evidence existed. The wrapper exited 0 and no descendant remained.

## Renderer recovery

PMDO loads its single-file extracted SDL by absolute path. The untouched runtime remains under `.runtime-cache/dotnet-custom/`; only the separate `.runtime-cache/dotnet-headless/` extraction uses the patched SDL. Forced OpenGL ES 3, absolute ANGLE GLES and EGL paths, and the pinned SwiftShader ICD initialized the renderer. `engine.log` records PMDO 0.8.12, ANGLE/SwiftShader identity, both Ground loads/finalizations, and the sink load.

## Evidence

- `validation_record.json` — required runtime, visual, animation, collision, lifecycle, cleanup, classification, destination, and promotion fields.
- `provenance.json` — ROM, plan, converter, engine, identity, canonical source, historical variants, routing analysis, and artifact provenance.
- `promotion_record.json` — passing gates, additive installation, zone registration, no-overwrite assertions, and exact hashes.
- `report.json` — complete pixel metrics and capture hashes for all 817 runtime samples.
- `events.jsonl` — untouched 2,473-event exact-PMDO stream.
- `fixture_manifest.json` — exact source hashes, movement probes, and all 816 planned ticks.
- `actual/` — untouched representative PMDO captures at primary tick 0, primary tick 2687, and reload tick 0.
- `comparisons/` — durable side-by-side comparative PNGs for those three samples.
- `runtime.log`, `index.log`, `engine.log`, `comparison.log` — preserved execution and renderer logs.
- `post_promotion_index.log` — exact PMDO 0.8.12 index pass over a fixture rebuilt from bytes read back from the promoted destinations.
- `commands.sh` — bounded exact-hash reproduction recipe with both ANGLE paths, actual event-path monitoring, progress reporting, and process-group cleanup.
- `evidence_hashes.sha256` — SHA-256 manifest for evidence, promoted files, variants, governing records, and validation tools.

Only canonical Ground map/tile reconstruction, runtime behavior, and non-destructive additive registration are claimed. Canonical events, characters, movement choreography, cameras, dialogue, music, VFX, and cinematics remain subsequent milestones. Dungeon restitution remains retained and separately validated; this overworld Ground does not alter any dungeon relationship.
