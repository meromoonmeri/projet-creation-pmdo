# `b05p01a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `fe83c3186422feec468775c8ce99805bb1e7fcd945a6ef54a24ee79139e8c23c`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b05p01a.rsground` (`f375e8b5fade65be2ba82801257ee63ecce2c9d78f0ed28939f6c339f7e1f00d`), retained unchanged;
- historical tile `RESERVE/red_tiles/b05p01a_Base.tile` (`ff7f4ddc12bc5c32551f77194c9cbf262a94d295a81d9cbb6275640aed0fd94c`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 34, map-file ID 35, Ground-place ID 10 as `MAP_TEAM_BASE_SQUIRTLE_CONSTRUCTION`. The visual source combines `B05P01A`, `B05P01Ac`, `B05P01Am`, `B05P01A1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b05p01a_exhaustive_pass/`.
