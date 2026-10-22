# `b01p01c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `c842cb920de7b9eed3919d00f9ace9c961098619773a02e2fae053c5871db88b`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b01p01c.rsground` (`bd5aaaa8a68d33542cb0454047cebdf249f69515dee1980664c4b4b3ae5b517d`), retained unchanged;
- historical tile `RESERVE/red_tiles/b01p01c_Base.tile` (`b6fe765e262c6b4ce7502424ec42089eeb014c8daef9cd87a6ad57aa23352944`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 12, map-file ID 13, Ground-place ID 10 as `MAP_TEAM_BASE_INSIDE_PIKACHU_BASIC`. The visual source combines `B01P01C`, `B01P01Cc`, `B01P01Cm`, `B01P01C1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b01p01c_exhaustive_pass/`.
