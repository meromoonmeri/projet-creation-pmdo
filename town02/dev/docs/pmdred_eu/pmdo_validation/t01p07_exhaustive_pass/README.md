# t01p07 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`t01p07` is the canonical EU **Luminous Cave** Ground (`MAP_LUMINOUS_CAVE`,
map/file/place ID 8). The authenticated v2.0.1-eu candidate was loaded in an
isolated fixture by exact PMDO 0.8.12, checked against an independently rendered
raw-EU-ROM reference, read back from its promoted destinations, and indexed
again by exact PMDO. No pre-existing destination, script, route, or historical
reserve asset was replaced.

This is Ground-only validation. Luminous Cave is classified separately as a
**cinematic/evolution interior** (`cinematic=true`, `arena=false`, `boss=false`),
but this milestone does not claim canonical dialogue, choreography, music, or
narrative routing.

## Exhaustive evidence

| Gate | Result |
|---|---:|
| Exact runtime | PMDO 0.8.12, executable `faf9755c…` |
| Active patched SDL | reproducible `2cec7b5f…` |
| Native validator events | 313; terminal `end` seen |
| Primary/reload loads | 2/2 `LOAD_PASS`, 2/2 `SAFE` |
| Primary samples | 96 boundary samples, ticks 0–479 |
| Reload samples | tick 0 |
| Full-RGBA comparisons | **97/97 pixel-exact** |
| Fully opaque captures | **97/97** |
| Mismatched pixels | **0** |
| Maximum channel delta | **0** |
| Unique primary RGBA frames | 19 |
| Palette animation | channels 1–3, each 24 × 10 ticks |
| Cycle coverage | two complete 240-tick local cycles |
| Collision | one layer, 2,357 solid cells, movement + blocking pass |
| Lifecycle | entry, exit, same-Ground re-entry, cleanup, unload/reload pass |
| State leakage/stale assets/orphans/locks | none observed |
| Post-promotion indexing | exact-PMDO pass, log `3df47e3b…` |

The comparator report contains metrics for all 97 samples. Three representative
actual and side-by-side comparative PNGs are tracked: primary tick 0, the final
boundary tick 479, and reload tick 0. Ticks 0 and 479 render identically because
479 is the last sampled tick before the 480-tick two-cycle boundary; the complete
report still records 19 unique primary RGBA frames.

## Provenance reconciliation

The previously tracked v2.0.0 candidate audit reported `t01p07` as Ground
`bf0982e6…` / tile `f5ffa239…`. Exact-engine validation of `h26p01` subsequently
exposed a finite-prefix pseudo-period bug. Converter v2.0.1 requires animation
periods to divide the closed cycle, and the strengthened audit checks two full
local cycles. Authenticated restoration regenerated `t01p07` as Ground
`cc7ce085…` / tile `456d26b0…`.

Only those v2.0.1 bytes were placed in the fixture, compared, and promoted. The
older reported hashes remain explicit historical provenance in
`provenance.json` and the preserved v2.0.0 reports; they are not relabeled as
tested bytes.

## Promotion and preservation

- `Data/Ground/t01p07.rsground`: `cc7ce085938d10aa4d564e6037e0ea0671ab1736f08448b38c6ad9c517a35546`
- `Content/Tile/t01p07_Base.tile`: `456d26b0fd97241ec47db70822d18604a291bd65f99032f4a5e84c0c5273327f`
- `Data/Zone/master_zone.json`: one `t01p07` at index 140, immediately after
  `t01p05`; BOM preserved; post-edit SHA-256 `0a1c5280…`
- historical Ground retained: `RESERVE/red_grounds/t01p07.rsground`
  (`27ee868a…`)
- historical tile retained: `RESERVE/red_tiles/t01p07_Base.tile`
  (`f5ffa239…`)
- pre-promotion record: `RESERVE/pmdred_pre_promotion/t01p07/README.md`

## Durable contents

- `validation_record.json` — one-Ground runtime, visual, animation, collision,
  lifecycle, classification, destination, and restitution record.
- `promotion_record.json` — additive installation and readback/index gates.
- `provenance.json` — ROM, extraction, candidate, runtime, hash, and historical
  candidate reconciliation.
- `report.json` — complete 97-sample pixel and runtime comparison report.
- `events.jsonl`, `runtime.log`, `engine.log`, `index.log`, and
  `post_promotion_index.log` — primary engine evidence.
- `actual/` and `comparisons/` — representative durable PNG evidence.
- `commands.sh` — bounded, create-only restoration and exact reproduction.
- `evidence_hashes.sha256` — integrity manifest for this bundle and relevant
  promoted/reserve/dependency files.

Resume the complete campaign from
`docs/pmdred_eu/pmdo_validation/RESUME.md`; `t01p07` raises durable progress to
11/219 validated and promoted, with 208 remaining.
