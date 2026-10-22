# `b06p01a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `c6854876026d741a894e6585546c11ffc527ec8ee509a7fefdc817b03d8dbf66`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b06p01a.rsground` (`72f8d203c06621160fa66c4751661cad960c3cc1aaa09080cc54eca7cc61c6ab`), retained unchanged;
- historical tile `RESERVE/red_tiles/b06p01a_Base.tile` (`ff7f4ddc12bc5c32551f77194c9cbf262a94d295a81d9cbb6275640aed0fd94c`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 40, map-file ID 41, Ground-place ID 10 as `MAP_TEAM_BASE_TOTODILE_CONSTRUCTION`. The visual source combines `B06P01A`, `B05P01Ac`, `B05P01Am`, `B05P01A1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b06p01a_exhaustive_pass/`.
