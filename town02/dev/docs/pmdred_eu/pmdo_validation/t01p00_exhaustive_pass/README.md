# `t01p00` exhaustive exact-PMDO validation

## Verdict

`PASS` — promoted non-destructively on 2026-08-12 after complete applicable validation in exact PMDO 0.8.12.

| Gate | Result |
| --- | --- |
| Full-RGBA visual comparison | 25/25 full-map runtime samples pixel-exact at 960×720; 0 mismatched pixels; maximum channel delta 0 |
| Opacity | 25/25 fully opaque |
| Tiles and palettes | Authenticated raw EU BPL/BPC/BPA/BMA reference matched exact PMDO output at every planned sample |
| Animation | Six-frame BPA channel; all 24 two-local-cycle boundary ticks through tick 83 passed, plus reload tick 0 |
| Collision | One BMA layer with 8,685 solid cells; clear movement `(0, 8)` and blocked movement `(0, 0)` both passed |
| Lifecycle | Two loads, two exits, one same-Ground re-entry, and strict event order passed |
| Cleanup/reload | Four cleanup probes passed; reload tick 0 remained full-RGBA exact; terminal `end` observed |
| Destination | `Data/Ground/t01p00.rsground`; `Content/Tile/t01p00_Base.tile` |
| Promotion | `PROMOTED_NON_DESTRUCTIVELY`; both destinations were absent and were created exclusively |

The exact PMDO executable SHA-256 was `faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327`. The authenticated EU ROM SHA-256 was `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`.

## Exhaustive animation plan

The canonical Ground has one six-frame BPA tile channel. Its PMDO durations are `[7, 7, 7, 7, 7, 7]`, for a 42-tick local cycle. The primary run covered the complete two-local-cycle transition-boundary plan:

`[0, 6, 7, 13, 14, 20, 21, 27, 28, 34, 35, 41, 42, 48, 49, 55, 56, 62, 63, 69, 70, 76, 77, 83]`

Every primary sample and reload tick 0 matched the independent canonical EU-ROM renderer over the complete 960×720 RGBA image. The durable PNG set preserves representative first, last, and post-reload comparisons; `report.json` preserves metrics and hashes for all 25 samples.

## Authoritative identity and repository divergence

The authenticated manifest identifies `t01p00` as canonical debug ID 1, map ID 1, map file ID 1, Ground place ID 2, and weather ID 9. The pinned `pret/pmd-red` technical enum calls map ID 1 `MAP_POKEMON_SQUARE`.

At the time of this pass, repository records conflicted around the legacy Pokémon Square alias: `docs/pmdred_extraction_tracabilite.md` identified `T00P01` as Pokémon Square, while `docs/canonical/red/upstream_ground_aliases.json` mapped `place_pokemon.rsground` to `t00p01.rsground`. The adjacent `t01p01` record shared canonical debug ID 1 and Ground place ID 2 but used map ID/map file ID 2, so this promotion deliberately recorded only the proven map-ID-1 identity and deferred the alias. The subsequent exhaustive `t01p01` pass proved map ID 2 as `MAP_WHISCASH_POND`; `docs/pmdred_eu/pmdo_validation/t01p01_exhaustive_pass/` now records the evidence and the resulting correction of `place_pokemon.rsground` to proven `t01p00.rsground`.

The canonical `t01p00` source is classified as Pokémon Square and is not itself a cinematic, arena, or boss Ground. No project script reference to `t01p00` was found in this scoped pass.

## Renderer recovery

PMDO loads its single-file extracted SDL by absolute path. The original extraction under `.runtime-cache/dotnet-custom/` was preserved untouched; a separate adapted extraction under `.runtime-cache/dotnet-headless/` received only the patched SDL. Forced OpenGL ES 3, absolute existing ANGLE GLES and EGL libraries (`SDL_VIDEO_GL_DRIVER` and `SDL_VIDEO_EGL_DRIVER`), and the pinned SwiftShader ICD then initialized PMDO's renderer successfully. `engine.log` is PMDO's append-only daily log and intentionally retains the preceding renderer diagnostics; only the successful 06:40:59 indexing session and 06:41:29 validator session form this pass's runtime evidence. Those two sessions durably record the exact ANGLE/SwiftShader renderer identity. The tracked patch remains `tools/patches/pmdo-0.8.12-headless-sdl.patch`.

## Evidence

- `validation_record.json` — durable per-Ground record covering every required runtime, classification, divergence, provenance, destination, and promotion field.
- `provenance.json` — ROM, plan, converter, engine, canonical identity, candidate, and artifact provenance.
- `promotion_record.json` — passing gates, absent-destination assertions, exclusive-create method, and candidate/destination hashes.
- `report.json` — complete pixel metrics and capture hashes for all 25 runtime samples.
- `events.jsonl` — untouched 97-event exact-PMDO stream.
- `fixture_manifest.json` — fixture inputs, movement probes, source hashes, and complete tick set.
- `actual/` — untouched representative PMDO captures at primary tick 0, primary tick 83, and reload tick 0.
- `comparisons/` — durable side-by-side comparative PNGs for the same three representative samples.
- `runtime.log`, `index.log`, `engine.log`, `comparison.log` — preserved execution and renderer logs.
- `commands.sh` — bounded recovery recipe with exact hash gates, actual event-path monitoring, and process-group cleanup.
- `evidence_hashes.sha256` — SHA-256 manifest for evidence, promoted files, governing source records, and conflicting identity records.

Only the canonical Ground map/tile reconstruction is claimed here. Events, characters, choreography, cameras, dialogue, music, VFX, and cinematics are separate subsequent milestones.
