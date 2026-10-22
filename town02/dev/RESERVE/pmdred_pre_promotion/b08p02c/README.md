# `b08p02c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `4713e7135e0b4d3822c9da37c0d66575230909c6750ed43ef76519b33d61888a`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b08p02c.rsground` (`cfe43407cfaf1b41822f6371fb00d8ffec1b95eda010c73f83264b9d7489db0e`), retained unchanged;
- historical tile `RESERVE/red_tiles/b08p02c_Base.tile` (`4a7eb9c34fe92861dc80230da6961c60903fce06f0466f2602b8bcafebe0172a`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 57, map-file ID 58, Ground-place ID 11 as `MAP_TEAM_BASE_CHARMANDER_BASIC`. The visual source combines `B08P02C`, `B05P02Cc`, `B05P02Cm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b08p02c_exhaustive_pass/`.
