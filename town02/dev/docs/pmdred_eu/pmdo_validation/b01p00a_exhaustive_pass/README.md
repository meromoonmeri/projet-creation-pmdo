# b01p00a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b01p00a` is the canonical EU basic Pikachu team-base exterior (`MAP_TEAM_BASE_PIKACHU_BASIC`; map ID 9, map-file/Ground-place ID 10). The authenticated v2.0.1-eu candidate was loaded in an isolated fixture by exact PMDO 0.8.12, checked against an independently rendered raw-EU-ROM reference, read back from its promoted destinations, and indexed again by exact PMDO. No pre-existing destination, script, route, alias, variant, or reserve asset was replaced.

This is Ground-only validation. It does not claim canonical story events, actors, entrances, music, team-base construction-state routing, interiors, or species variants.

## Exhaustive evidence

| Gate | Result |
|---|---:|
| Exact runtime | PMDO 0.8.12, executable `faf9755c…` |
| Active patched SDL | reproducible `2cec7b5f…` |
| Native validator events | 97; terminal `end` seen |
| Primary/reload loads | 2/2 `LOAD_PASS`, 2/2 `SAFE` |
| Primary samples | 24 boundary samples, ticks 0–83 |
| Reload samples | tick 0 |
| Full-RGBA comparisons | **25/25 pixel-exact** |
| Fully opaque captures | **25/25** |
| Mismatched pixels | **0** |
| Maximum channel delta | **0** |
| Unique primary RGBA frames | 6 |
| Tile animation | BPA channel 0, 6 × 7 ticks |
| Cycle coverage | two complete 42-tick local cycles |
| Collision | one layer, 3,652 solid cells, movement + blocking pass |
| Lifecycle | entry, exit, same-Ground re-entry, cleanup, unload/reload pass |
| State leakage/stale assets/orphans/locks | none observed |
| Post-promotion indexing | exact-PMDO pass, log `3df47e3b…` |

The comparator report contains metrics for all 25 samples. Three representative actual and side-by-side comparative PNGs are tracked: primary tick 0, final boundary tick 83, and reload tick 0. The complete report records all six primary RGBA animation states.

## Promotion and preservation

- `Data/Ground/b01p00a.rsground`: `5b52c0152eac8352bc364e362113d1ff9f73f710d558a64a06ba93d11aa4b449`
- `Content/Tile/b01p00a_Base.tile`: `d6a7088978d33196fab79b0285b505b84a6de86b01914033c8d0ac502fa7d4ba`
- `Data/Zone/master_zone.json`: one `b01p00a` at index 141, immediately after `t01p07`; BOM preserved; post-edit SHA-256 `b7c0b933…`
- no same-name historical reserve Ground or tile existed
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b01p00a/README.md`

## Durable contents

- `validation_record.json` — one-Ground runtime, visual, animation, collision, lifecycle, classification, destination, and restitution record.
- `promotion_record.json` — additive installation and read-back/index gates.
- `provenance.json` — ROM, extraction, candidate, runtime, and hash provenance.
- `report.json` — complete 25-sample pixel and runtime comparison report.
- `events.jsonl`, `runtime.log`, `engine.log`, `index.log`, and `post_promotion_index.log` — primary engine evidence.
- `actual/` and `comparisons/` — representative durable PNG evidence.
- `commands.sh` — bounded, create-only exact reproduction using Agent A’s method.
- `evidence_hashes.sha256` — integrity manifest for this bundle and relevant promoted/dependency files.

Resume the canonical campaign from `docs/pmdred_eu/pmdo_validation/RESUME.md` at `b01p01a`; `b01p00a` raises durable progress to 12/219 validated and promoted, with 207 remaining.
