# `h26p01` deterministic exact-PMDO focused pilot

Status: **focused pilot PASS; not promotion proof**.

This retained evidence records two isolated loads in exact PMDO 0.8.12. The primary
load captured source ticks `0,119,120,123,127,128`; the reload captured tick `0`.
All seven full-RGBA 480×312 engine captures are fully opaque and pixel-exact against
images independently rendered from the authenticated European ROM resources.
Movement over a BMA-clear cell, rejection at a BMA-solid cell, both exits, same-Ground
reload, sink transition, cleanup, and terminal lifecycle order pass.

The fixture's screenshot clock was deterministically repinned from
`EngineServiceEvents.Update` until each Draw completed. This avoids fixed-update
catch-up changing the requested source tick while the Lua screenshot coroutine is
suspended. The generated fixture script and strict event comparator are retained in
`tools/build_pmdred_eu_runtime_fixture.py` and
`tools/compare_pmdred_eu_pmdo_renders.py`.

## Files

- `report.json`: pixel metrics plus runtime/lifecycle assessment.
- `provenance.json`: runtime, ROM, candidate and artifact hashes, and explicit limits.
- `events.jsonl`: complete native fixture event stream.
- `actual/`: untouched PMDO screenshots.
- `comparisons/`: EU-reference/PMDO side-by-side PNGs for all seven focused samples.
- `runtime.log`, `index.log`: exact-engine and bounded indexing logs.
- `fixture_manifest.json`: tested candidate hashes and BMA-derived probe positions.

This pilot deliberately does **not** mark `h26p01` runtime-complete: the complete
schema-v2 schedule remains required. No file was promoted into `Data/Ground`.
