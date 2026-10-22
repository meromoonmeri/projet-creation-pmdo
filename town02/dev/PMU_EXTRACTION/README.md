# PMU canonical source extraction (phase 1)

This directory contains the reproducible, source-first recovery pipeline for **Pokémon Mystery Universe** maps. It deliberately does **not** contain a PMDO converter. The public SQL snapshot (`s1`–`s2000`) is source-certified, while the overall discovery scope remains `PARTIAL`: all 140 public V9 caches are blocked by the unpublished deployment key, including cache-only `s3000`, and six historical tile values retain `UNKNOWN` semantics. Phase 2 is now authorized only for this explicitly certified SQL snapshot and lives in the separate `PMU_ADAPTATION/` pipeline; blocked or unresolved content is never promoted.

## Immutable input boundary

The pipeline reads, but never writes, the upstream clones under:

- `.runtime-cache/pmu/PMU-Client`
- `.runtime-cache/pmu/PMU-Server`
- `.runtime-cache/pmu/Scripts`

It does not use city PNG screenshots as geometry. Geometry and visuals come exclusively from V9 `.dat`, SQL `map_*` rows, `.tile` archives, and the original C# loader/renderer behavior.

## Reproduce

```bash
python3 -m venv .runtime-cache/pmu-venv
.runtime-cache/pmu-venv/bin/pip install -r PMU_EXTRACTION/requirements.lock
.runtime-cache/pmu-venv/bin/python PMU_EXTRACTION/tests.py
.runtime-cache/pmu-venv/bin/python PMU_EXTRACTION/pmu_pipeline.py all
```

Bulk outputs are intentionally written under `.runtime-cache/pmu-extraction/` to keep the roughly 900 MiB derived corpus out of Git. The `publish` step writes the global index, complete map table and audit summary to `PMU_EXTRACTION/reports/`; byte-identical source/animated PNG copies for both exact Grassroot records and Snowbasin are retained under `reports/critical-maps/`.

## Pipeline stages

1. `audit` — repositories, revisions, assets, provenance and authoritative source paths;
2. `sql` — streaming parse of the 1.15 GB `pmu_data.sql` member, importing all `sNNN` standard maps;
3. `dat` — exact .NET-compatible TripleDES implementation; decodes and round-trips caches only when the checked-in key applies, otherwise records a reproducible `BLOCKED` result without key guessing;
4. `tiles` — exact archive index parse plus decode validation of every embedded tile;
5. `canonical` — revision-aware union of decodable SQL maps and V9 caches, per-map structured JSON/manifests/Markdown and direct graph;
6. `render` — full-size base and animated-replacement PNGs using the original layer semantics;
7. `sheets` — 32 contact sheets used only as an audit index;
8. `inventory` — exhaustive animation/NPC/object/story/script/trigger indexes, unknown-value report, deduplicated graphic exceptions and statically proved scripted graph edges;
9. `validate` — hashes, dimensions, grid completeness, animation and contact-sheet coverage, then scoped source certification;
10. `publish` — tracked JSON/Markdown index, complete 2,000-row table, summary and critical-city PNG copies.

## Canonical selection

For a map available from both SQL and client cache, the highest revision wins. The V9 `.dat` wins a revision tie because it is the exact local output written by `MapHelper.SaveLocalMap` after the server packet was loaded. Every overlap retains a structural comparison and both provenance paths.

## Rendering contract

- logical coordinates are inclusive: `0..MaxX`, `0..MaxY`;
- tile size is 32×32 px;
- layer order is Ground, Mask, Mask2, Fringe, Fringe2;
- each animated field replaces its paired base field while animation state is on;
- the state toggles every 250 ms (500 ms period);
- tile ID `0` is skipped, matching `MapRenderer`;
- out-of-range tile IDs fall back to tile `0`, matching `Tileset.GetTileGraphic`, and are reported;
- source captures use the white background of `MapViewer.CaptureMapImage`;
- full source PNGs include `MaxX+1` by `MaxY+1` cells. The integrated whole-map screenshot has a documented off-by-one bug and is not allowed to discard the final row/column.

See [`docs/source-chain.md`](docs/source-chain.md), [`docs/status-model.md`](docs/status-model.md), and [`docs/phase-boundary.md`](docs/phase-boundary.md).
