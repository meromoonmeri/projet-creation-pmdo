# PMD Red EU — canonical Ground candidate reconstruction

## Milestone boundary

This directory records non-destructive candidate generation for the **219
canonical archive-backed Grounds**. The 27 conversion-type 10/11 Grounds are
excluded because they have their own exact-PMDO validation bundle.

The current static milestone proves candidate generation, complete source-local
graphical readback through two cycles, canonical BMA collision, and full
reconciliation with the preserved legacy reserve. Static success does **not** by
itself prove exact-PMDO loading, canonical scripts/entities, music, entries,
exits, transitions, or integration. Those gates remain mandatory per Ground.

No file under `RESERVE/red_grounds/` or `RESERVE/red_tiles/` was modified by
candidate regeneration. Active generated candidates remain in the ignored,
authenticated `.runtime-cache/pmdred-eu-remaining-regenerated-v201/` tree.

## Authority and reproducibility

- EU ROM SHA-256: `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`
- normalized resource/dependency authority: `../ground_manifest.json`
- converter: `tools/convert_red_all.py`, version `2.0.1-eu`
- authenticated generation report: `conversion_report.json` (`91f3b460…`)
- exhaustive audit: `candidate_audit.json` (`2434d193…`)
- complete generation history: `candidate_regeneration_history.json`

The converter refuses `--apply` unless the caller chooses either a
non-destructive `--output-root` or the explicit destructive
`--promote-legacy-reserve` escape hatch. Canonical subsets come from the
ROM-derived conversion table via `--conversion-set remaining|direct|all`;
filenames and the legacy inventory do not define membership.

The recommended create-only recovery path verifies or restores every locked
input and the complete generated tree:

```bash
bash tools/restore_pmdred_eu_validation_runtime.sh
python3 tools/update_pmdred_eu_validation_progress.py --check
```

A fresh throwaway regeneration can instead be produced under a new absent
output path:

```bash
python tools/convert_red_all.py \
  --source-dir .runtime-cache/pmdred-eu-ground \
  --manifest docs/pmdred_eu/ground_manifest.json \
  --conversion-set remaining \
  --apply \
  --output-root .runtime-cache/pmdred-eu-remaining-regenerated-v201-check \
  --report .runtime-cache/pmdred-eu-remaining-regenerated-v201-check/conversion_report.json

python tools/audit_pmdred_remaining_candidates.py \
  --source-dir .runtime-cache/pmdred-eu-ground \
  --candidate-root .runtime-cache/pmdred-eu-remaining-regenerated-v201-check \
  --output .runtime-cache/pmdred-eu-remaining-regenerated-v201-check/audit.json
```

## Exhaustive active result

| Check | Result |
|---|---:|
| Canonical remaining conversions | 219 |
| Successfully regenerated / passing | 219 / 219 |
| Candidate failures | 0 |
| Validated local cycles | 2 |
| Source chunk-cell ticks evaluated | 2,635,222 |
| Exact candidate tile/tick comparisons | 23,716,938 |
| BMA collision streams | 183 one-layer, 36 no-layer |
| Grounds with animated cells | 125 |
| Grounds retaining separate BMA unknown-data evidence | 15 |

For every Ground, the audit:

1. resolves `map_file_id` from the ROM-derived conversion table;
2. authenticates every normalized BPL/BPC/BMA/BPA dependency;
3. authenticates generated files against the conversion report;
4. independently compares every 8×8 PMDO tile at every relevant source-local
   tick across two complete animation cycles, including palette/BPA timing;
5. verifies camera dimensions, tile schedules, and sheet coverage;
6. independently decodes BMA auxiliary/collision streams, checks every PMDO
   obstacle tag and bound, and never reinterprets unknown BMA data as collision;
7. confirms graphics-only candidates invent no event entities; and
8. compares every candidate component and tile package with the legacy reserve.

Per-Ground dimensions, resources, timing, collision, hashes, and legacy
differences are in `candidate_audit.json`.

## Candidate-generation provenance reconciliation

Exact-engine work on `h26p01` exposed a v2.0.0 defect: the previous period
finder could accept a finite-prefix pseudo-period when equal start/end frames
made `n-k` appear periodic over only one cycle. Converter v2.0.1 requires a
period to divide the closed cycle; the audit now covers two cycles.

The old tracked reports are preserved byte-for-byte under
`history/v200_pre_period_fix/`. Their hashes and the active hashes are recorded
in `candidate_regeneration_history.json`. This matters for `t01p07`: the old
report listed Ground `bf0982e6…` / tile `f5ffa239…`, whereas authenticated
v2.0.1 restoration generated Ground `cc7ce085…` / tile `456d26b0…`. Only the
latter bytes were exact-engine tested and promoted. Nothing silently treats the
two generations as equivalent.

## Legacy reserve reconciliation

The preserved reserve is not a canonical conversion inventory:

- 201 of 219 canonical IDs overlap it; 18 canonical IDs are absent;
- 17 reserve IDs are outside the ROM-derived conversion table;
- none of the 201 overlapping Ground pairs is semantically reusable as-is;
- 144/201 tile packages are byte-identical to active EU regeneration and 57
  differ after the closed-cycle period fix;
- 109 Ground layer schedules/geometry payloads, 20 collision payloads, and all
  201 entity payloads differ;
- legacy entity differences include unauthenticated entry/event markers that a
  graphics archive cannot prove.

The 18 canonical IDs absent from the reserve are:

`a05p03f`, `a05p03g`, `a05p03i`, `a05p03s`, `b01p00a`, `s02_fre`,
`s02_ger`, `s02_ita`, `s02_spa`, `s05_fre`, `s05_ger`, `s05_ita`,
`s05_spa`, `s06_fre`, `s06_ger`, `s06_ita`, `s06_spa`, and `t01p00`.

The 17 reserve-only IDs are:

`h01p01w`, `h02p01w`, `h02p02w`, `h02p03w`, `h07p04w`, `h17p01w`,
`h19p01w`, `h29p03w`, `t01p06`, `t01p07w`, `w01`, `w03p01`, `w03p02`,
`w03p03`, `w04`, `w05`, and `w06`.

Reserve-only never means safe to delete. Weather/world-map/project roles and all
historical bytes remain preserved pending separate proof.

## Required progressive validation

Before each candidate is integrated, it still requires:

1. exact PMDO 0.8.12 load, indexing, lifecycle, and screenshot validation;
2. independent raw-EU full-map comparison over complete relevant cycles;
3. collision movement/blocking and reload probes;
4. canonical event/script/choreography, music/weather, and transition work when
   that scope becomes applicable; and
5. additive/readback promotion only after complete evidence passes.

Durable per-Ground state and exact continuation commands live under
`../pmdo_validation/`.
