# `b05p01c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `b5757cf45f5e13399eb90931cd9f34aebe751eab1500de718d54cf13eda98707`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b05p01c.rsground` (`df7c512e5449b4813eee2eed513e6134adedda153cb2791efbe376ba4900513b`), retained unchanged;
- historical tile `RESERVE/red_tiles/b05p01c_Base.tile` (`3466ff6dbae5bcfce5dca4bed313265859834ada5f402aaebab6cae8967264ad`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 36, map-file ID 37, Ground-place ID 10 as `MAP_TEAM_BASE_INSIDE_SQUIRTLE_BASIC`. The visual source combines `B05P01C`, `B05P01Cc`, `B05P01Cm`, `B05P01C1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b05p01c_exhaustive_pass/`.
