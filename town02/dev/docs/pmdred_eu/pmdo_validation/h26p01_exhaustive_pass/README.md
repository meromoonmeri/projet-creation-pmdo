# `h26p01` exhaustive exact-PMDO validation

## Verdict

`PASS` — promoted non-destructively on 2026-08-12 after exhaustive validation in exact PMDO 0.8.12.

| Gate | Result |
| --- | --- |
| Full-RGBA visual comparison | 4,217/4,217 pixel-exact; 0 mismatched pixels; maximum channel delta 0 |
| Opacity | 4,217/4,217 fully opaque |
| Animation | All 4,216 planned primary ticks, through source tick 7,439; two complete local cycles of every distinct used dependency set |
| Collision | 2,120 BMA solid cells; clear movement `(0, 8)` and blocked movement `(0, 0)` both passed on primary load and reload |
| Lifecycle | Two loads, two exits, one same-Ground re-entry, strict event order passed |
| Cleanup/reload | Four cleanup probes passed; reload tick 0 remained pixel-exact; terminal `end` observed |
| Destination | `Data/Ground/h26p01.rsground`; `Content/Tile/h26p01_Base.tile` |
| Promotion | `PROMOTED_NON_DESTRUCTIVELY`; both destinations were absent and were created exclusively |

The PMDO executable SHA-256 was `faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327`. The authenticated EU ROM SHA-256 was `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`.

## Authoritative classification correction

The canonical source identity is map ID 155, `MAP_FRIEND_AREA_VOLCANIC_PIT`: the Friend Area **Volcanic Pit / Fosse Volcanique**. It is not canonically a story or boss Ground.

The project separately reuses `h26p01` as the chapter-23 **Volcanion boss arena** at **Forge de Vapeur** (`docs/vague6_friend_areas_boss.md:75`). Canonical source identity and project gameplay role are recorded separately in `validation_record.json`; they must not be collapsed into one classification. The project mapping row does not designate this reuse as cinematic.

## Evidence

- `validation_record.json` — durable final per-Ground record covering every required runtime and promotion field.
- `provenance.json` — ROM, plan, converter, engine, source identity, candidate, artifact, and correction provenance.
- `promotion_record.json` — gate results, absent-destination assertions, exclusive-create method, and candidate/destination hashes.
- `report.json` — complete metrics for every one of the 4,217 samples.
- `events.jsonl` — untouched exact-PMDO event stream.
- `fixture_manifest.json` — immutable fixture inputs and requested tick set.
- `actual/` — untouched PMDO screenshots at primary ticks 0 and 7,439 and reload tick 0.
- `comparisons/` — durable side-by-side comparative PNGs for those same samples.
- `runtime.log`, `index.log`, `comparison.log` — preserved execution logs.
- `commands.sh` — bounded recovery recipe, including terminal-event monitoring and PMDO termination.
- `evidence_hashes.sha256` — SHA-256 manifest for the evidence, promoted files, and governing source records.

Only the canonical Ground map/tile reconstruction is claimed here. Canonical events, characters, cameras, dialogue, music, and VFX are separate subsequent milestones and are not represented as complete by this promotion.
