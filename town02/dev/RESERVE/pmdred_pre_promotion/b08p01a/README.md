# `b08p01a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `507ce05845fff7d10e667975ba47ee252e1ad1b7e7f786fe6c4dacedc898b48e`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b08p01a.rsground` (`41b51d3063f8bfeab84960cab6124b03dd3ea4c5c90c887c1866dc8cd671a190`), retained unchanged;
- historical tile `RESERVE/red_tiles/b08p01a_Base.tile` (`ff7f4ddc12bc5c32551f77194c9cbf262a94d295a81d9cbb6275640aed0fd94c`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 52, map-file ID 53, Ground-place ID 10 as `MAP_TEAM_BASE_PSYDUCK_CONSTRUCTION`. The visual source combines `B08P01A`, `B05P01Ac`, `B05P01Am`, `B05P01A1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b08p01a_exhaustive_pass/`.
