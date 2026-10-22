# `t01p01` exhaustive exact-PMDO validation

## Verdict

`PASS` — promoted on 2026-08-12 by an integration-preserving migration after exhaustive validation of the **exact merged artifact** in PMDO 0.8.12.

| Gate | Result |
| --- | --- |
| Full-RGBA visual comparison | 217/217 full-map runtime samples pixel-exact at 960×720; 0 mismatched pixels; maximum channel delta 0 |
| Opacity | 217/217 fully opaque |
| Tiles and palettes | Authenticated raw EU BPL/BPC/BPA/BMA reference matched exact PMDO output at every planned sample |
| Animation | Six-frame BPA tile channel plus six-frame BPL palette channel; all 216 two-local-cycle boundary ticks through combined-cycle tick 335 passed, plus reload tick 0 |
| Collision | One BMA layer with 8,685 solid cells; clear movement `(0, 8)` and blocked movement `(0, 0)` both passed |
| Lifecycle | Two loads, two exits, one same-Ground re-entry, and strict event order passed |
| Cleanup/reload | Four cleanup probes passed; reload tick 0 remained full-RGBA exact; terminal `end` observed; no PMDO orphan remained |
| Project integration | Two markers and one teammate spawner were migrated unchanged; the fixture proved every other serialized value canonical and all 217 integrated-artifact renders stayed exact |
| Classification | Canonical source: Whiscash Pond, not cinematic/arena/boss. Project reuse: Fugitive cinematic Ground; not arena/boss |
| Destination | `Data/Ground/t01p01.rsground`; `Content/Tile/t01p01_Base.tile` |
| Promotion | `PROMOTED_INTEGRATION_PRESERVING_MIGRATION`; exact former destination bytes retained under `RESERVE/pmdred_pre_promotion/t01p01/` |

The exact PMDO executable SHA-256 was `faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327`. The authenticated EU ROM SHA-256 was `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`.

## Integration-preserving canonical migration

Blindly copying the bare regenerated candidate would have removed project integration required by existing Lua. The former active Ground contained:

- `Main_Entrance_Marker`;
- `Cutscene_Marker`;
- the `Teammate1` / `TEAMMATE_1` spawner.

Those three entities were copied unchanged onto the authenticated canonical visual/collision/animation candidate. The fixture builder's explicit integration gate compared the merged JSON against the authenticated bare candidate and accepted only ordered additive `Markers`/`Spawners`; all other values, including map characters and Ground objects, had to remain canonical. The bare canonical Ground hash was `8626f4b563697c5b4fc7dd387d3cfec7f1c337ea18c8b2cf75b2f6bd920f293c`; the exact integrated Ground loaded, captured, compared, and promoted was `f1677cd5e68eb0d78cd5073171b528cc9263ef8484825438105cb9fad92964d6`.

This migration corrected the former Ground's false Pokémon Square comment, noncanonical `EdgeView`, missing background parallax, and incorrect animation frame lengths without discarding its project entities. The exact former Ground and tile remain in reserve at hashes `4f14a203...` and `498b3223...`. Existing Fugitive Lua was not rewritten. This Ground pass does **not** claim that arc, its cinematics, dialogue, choreography, music, or actors are reconstructed or fully validated.

## Exhaustive animation plan

The canonical Ground has one six-frame BPA tile channel with PMDO durations `[7, 7, 7, 7, 7, 7]` (42 ticks) and one six-frame BPL palette channel with durations `[4, 4, 4, 4, 4, 4]` (24 ticks). Cells use the tile channel alone, palette channel alone, or both; the combined local cycle is 168 ticks. The primary run covered the authenticated schema-v2 transition-boundary union for every used channel combination over two complete local cycles: 216 ticks from 0 through 335.

All 216 primary samples and reload tick 0 matched the independent canonical EU-ROM renderer over the complete 960×720 RGBA image. Twenty-four distinct RGBA states were observed. The durable PNG set preserves representative first, last, and post-reload comparisons; `report.json` preserves metrics and hashes for all 217 samples.

## Authoritative identity and alias correction

The authenticated manifest identifies `t01p01` as canonical debug ID 1, map ID 2, map file ID 2, Ground place ID 2, and weather ID 9. At the pinned `pret/pmd-red` technical source, ground-map enum index 2 is `MAP_WHISCASH_POND`. It is therefore Whiscash Pond, not Pokémon Square.

The adjacent `t01p00` exact pass already proved map ID 1 as `MAP_POKEMON_SQUARE`. With both sides now proven independently, `docs/canonical/red/upstream_ground_aliases.json` was corrected from `place_pokemon.rsground -> t00p01.rsground` to `place_pokemon.rsground -> t01p00.rsground`. No named legacy Ground was deleted. Historical extraction reports and reserve comments that retain earlier labels remain unchanged as historical evidence and are not used as authority.

## Renderer recovery

PMDO loads its single-file extracted SDL by absolute path. The original extraction under `.runtime-cache/dotnet-custom/` remained untouched; only the separate adapted extraction under `.runtime-cache/dotnet-headless/` contains the patched SDL. Forced OpenGL ES 3, absolute ANGLE GLES and EGL paths (`SDL_VIDEO_GL_DRIVER` and `SDL_VIDEO_EGL_DRIVER`), and the pinned SwiftShader ICD initialized the renderer. `engine.log` records PMDO 0.8.12, ANGLE/SwiftShader identity, both Ground loads, both finalizations, and the inert sink load. The native validator emitted its terminal event before bounded process-group shutdown; the wrapper exited 0 and no descendant remained.

## Evidence

- `validation_record.json` — required per-Ground runtime, visual, animation, collision, lifecycle, cleanup, classification, integration, destination, and promotion fields.
- `provenance.json` — ROM, plan, converter, engine, identity, canonical baseline, integration, reserve, and artifact provenance.
- `promotion_record.json` — passing gates, entity-only migration proof, reserve assertions, atomic replacement method, alias correction, and candidate/destination hashes.
- `report.json` — complete pixel metrics and capture hashes for all 217 runtime samples.
- `events.jsonl` — untouched 673-event exact-PMDO stream.
- `fixture_manifest.json` — tested integrated source hashes, additive-entity proof, movement probes, and the complete tick set.
- `actual/` — untouched representative PMDO captures at primary tick 0, primary tick 335, and reload tick 0.
- `comparisons/` — durable side-by-side comparative PNGs for those same three samples.
- `runtime.log`, `index.log`, `engine.log`, `comparison.log` — preserved execution and renderer logs.
- `commands.sh` — bounded reconstruction and validation recipe with both ANGLE paths, exact hash gates, actual event-path monitoring, and process-group cleanup.
- `evidence_hashes.sha256` — SHA-256 manifest for evidence, promoted files, reserves, governing source records, alias record, and validation tools.

Only canonical Ground map/tile reconstruction and preservation of the pre-existing integration entities are claimed here. Canonical events, characters, movement choreography, cameras, dialogue, music, VFX, and cinematics remain subsequent milestones.
