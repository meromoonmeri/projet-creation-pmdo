# `a01p01` exhaustive exact-PMDO validation

## Verdict

`PASS` — promoted non-destructively on 2026-08-12 after complete applicable validation in exact PMDO 0.8.12.

| Gate | Result |
| --- | --- |
| Full-RGBA visual comparison | 2/2 runtime samples pixel-exact; 0 mismatched pixels; maximum channel delta 0 |
| Opacity | 2/2 fully opaque |
| Animation | Static Ground: no BPL/BPA animation channels; the complete planned set is tick 0, validated on primary load and reload |
| Collision | Canonical BMA has 0 collision layers and 0 solid cells; unrestricted movement `(0, 8)` passed; blocked probe correctly not applicable |
| Lifecycle | Two loads, two exits, one same-Ground re-entry, and strict event order passed |
| Cleanup/reload | Four cleanup probes passed; reload tick 0 remained full-RGBA exact; terminal `end` observed |
| Destination | `Data/Ground/a01p01.rsground`; `Content/Tile/a01p01_Base.tile` |
| Promotion | `PROMOTED_NON_DESTRUCTIVELY`; both destinations were absent and were created exclusively |

The exact PMDO executable SHA-256 was `faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327`. The authenticated EU ROM SHA-256 was `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`.

## Classification and project reuse

The canonical source identity is map ID 163, `MAP_PERSONALITY_TEST_CYAN`: a static cyan personality-test background. It is an interactive event background, not a canonical cinematic, arena, or boss Ground.

The project separately reuses the same stable ID for `Data/Script/halcyon/arc_fugitif/scene/a01p01.lua`, which defines `a01p01.Cutscene`. That project reuse is therefore classified as cinematic, separately from the canonical source identity. In accordance with the mandated milestone order, the existing Fugitive-arc script was not changed, rebuilt, validated, or claimed complete by this Ground-only pass.

## Evidence

- `validation_record.json` — durable per-Ground record covering every required runtime, classification, provenance, destination, and promotion field.
- `provenance.json` — ROM, plan, converter, engine, canonical identity, candidate, and artifact provenance.
- `promotion_record.json` — passing gates, absent-destination assertions, exclusive-create method, and candidate/destination hashes.
- `report.json` — complete metrics for both runtime samples.
- `events.jsonl` — untouched exact-PMDO event stream.
- `fixture_manifest.json` — fixture inputs, spawn/probe plan, source hashes, and requested tick set.
- `actual/` — untouched primary and reload PMDO captures.
- `comparisons/` — durable side-by-side comparative PNGs for primary and reload tick 0.
- `runtime.log`, `index.log`, `comparison.log` — preserved execution logs.
- `commands.sh` — bounded recovery recipe using the validator's actual fixed event path and process-group cleanup.
- `evidence_hashes.sha256` — SHA-256 manifest for the evidence, promoted files, and governing source records.

Only the canonical Ground map/tile reconstruction is claimed here. Events, characters, movement choreography, cameras, dialogue, music, VFX, and cinematics are separate subsequent milestones.
