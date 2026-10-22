# `t00p01` exhaustive exact-PMDO validation

## Verdict

`PASS` — promoted non-destructively on 2026-08-12 after complete applicable validation in exact PMDO 0.8.12.

| Gate | Result |
| --- | --- |
| Full-RGBA visual comparison | 2/2 full-map runtime samples pixel-exact at 1,152×888; 0 mismatched pixels; maximum channel delta 0 |
| Opacity | 2/2 fully opaque |
| Animation | Static Ground: no BPL/BPA animation channels; complete planned tick 0 validated on primary load and reload |
| Collision | One BMA layer with 6,888 solid cells; clear movement `(0, 8)` and blocked movement `(0, 0)` both passed |
| Lifecycle | Two loads, two exits, one same-Ground re-entry, and strict event order passed |
| Cleanup/reload | Four cleanup probes passed; reload tick 0 remained full-RGBA exact; terminal `end` observed |
| Destination | `Data/Ground/t00p01.rsground`; `Content/Tile/t00p01_Base.tile` |
| Promotion | `PROMOTED_NON_DESTRUCTIVELY`; both destinations were absent and were created exclusively |

The exact PMDO executable SHA-256 was `faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327`. The authenticated EU ROM SHA-256 was `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`.

## Authoritative identity and repository divergence

The authenticated manifest identifies `t00p01` as map ID 0. The pinned `pret/pmd-red` technical enum calls that ID `MAP_SQUARE` and separately calls map ID 1 `MAP_POKEMON_SQUARE`.

Repository records conflict with one another: `docs/pmdred_extraction_tracabilite.md` and `docs/canonical/red/upstream_ground_aliases.json` identify or alias `t00p01` as Pokémon Square, while `docs/INVENTAIRE_DEPOTS_PMD_RED_SKY_2026-08-06.md` calls it the team base. This promotion therefore records only the exact technical identity **Square** and does not collapse it into either conflicting label. The legacy `place_pokemon` alias was not used as proof and is retained until `t01p01` receives equivalent exact runtime validation, after which it can be corrected non-destructively with both sides proven.

The project also separately reuses `t00p01` in `Data/Script/halcyon/arc_fugitif/scene/t00p01.lua`, which defines a cutscene. That reuse is classified as cinematic but remains untouched and out of scope for this Ground-only pass.

## Evidence

- `validation_record.json` — durable per-Ground record covering every required runtime, classification, divergence, provenance, destination, and promotion field.
- `provenance.json` — ROM, plan, converter, engine, canonical identity, candidate, and artifact provenance.
- `promotion_record.json` — passing gates, absent-destination assertions, exclusive-create method, and candidate/destination hashes.
- `report.json` — complete pixel metrics for both runtime samples.
- `events.jsonl` — untouched exact-PMDO event stream.
- `fixture_manifest.json` — fixture inputs, movement probes, source hashes, and complete tick set.
- `actual/` — untouched primary and reload full-map PMDO captures.
- `comparisons/` — durable side-by-side comparative PNGs for primary and reload tick 0.
- `runtime.log`, `index.log`, `comparison.log` — preserved execution logs.
- `commands.sh` — bounded recovery recipe with actual event-path monitoring and process-group cleanup.
- `evidence_hashes.sha256` — SHA-256 manifest for evidence, promoted files, governing source records, and conflicting identity records.

Only the canonical Ground map/tile reconstruction is claimed here. Events, characters, choreography, cameras, dialogue, music, VFX, and cinematics are separate subsequent milestones.
