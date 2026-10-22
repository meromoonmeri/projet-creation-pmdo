# Certification status model

Statuses are explicit and monotonic only when their prerequisites are met:

- `DISCOVERED` — input or relation has been located but not decoded;
- `EXTRACTED` — decoded into the canonical structured representation and structurally validated;
- `RENDERED` — complete source-sized PNG frame(s) were produced from validated structures and tiles;
- `SOURCE_CERTIFIED` — extraction, provenance, assets, rendering, hashes, graph checks and visual audit are all complete;
- `PARTIAL` — some required material exists but one or more required checks failed or remain absent;
- `BLOCKED` — cannot proceed because a declared prerequisite is not met;
- `UNKNOWN` — the available sources do not provide a value;
- `UNVERIFIED` — a value or interpretation exists but lacks enough source evidence or validation.

A successful automated render does not silently become `SOURCE_CERTIFIED`. The report retains `RENDERED` until all IR/PNG hashes and dimensions, animation coverage, contact sheets, exceptional-reference analysis and visual review pass the `validate` command.

Certification is scoped rather than inflated. The 2,000-map public SQL snapshot can be `SOURCE_CERTIFIED` for structure/raster while the global phase remains `PARTIAL`. A map stays `PARTIAL` when its alternate V9 cache comparison is `BLOCKED` or a tile semantic is `UNKNOWN`; each component status is retained in its `certification` object. PMDO runtime status remains `NOT_STARTED` and can never be inferred from source rendering.
