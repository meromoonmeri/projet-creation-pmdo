# Strict phase boundary

## Phase 1 — partially certified

The public server SQL snapshot of 2,000 maps is `SOURCE_CERTIFIED` for canonical IR and raster. The global phase remains `PARTIAL` because 140 encrypted client caches are blocked (137 overlap the SQL IDs and `s3000` is cache-only) and six tile values have no public enum semantics. Their statuses remain explicit; no ciphertext or inferred meaning is promoted.

## Phase 2 — authorized for the certified snapshot only

The separate `PMU_ADAPTATION/` pipeline may now consume the explicitly certified `s1`–`s2000` SQL structures and immutable PNG references. It may not consume or invent `s3000`, decrypt V9 caches, erase the six unknown semantics, or overwrite anything under the phase-1 output roots.

No PMDO scale adaptation, image interpolation, `.rsground` generation, PMDO collision conversion, or PMDO runtime test belongs in this directory. The existing Agent A runtime/headless PMDO method is reused rather than replaced. Every adaptation remains non-certified until its own native Ground, collision, visual comparison, and exact PMDO runtime gates pass.
