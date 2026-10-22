# `b06p01c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `b330e078bd329b3b8ad667532ebe34c06a4b3171deadbd3bdab62df566fbbd51`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b06p01c.rsground` (`4870b7471c108346f9f2133c7bf90a21bbead72fa75b85d83ab78fd1c7b9d9a0`), retained unchanged;
- historical tile `RESERVE/red_tiles/b06p01c_Base.tile` (`2398db32660589463a0b9212e4ffe7ada44e80f2d9481488a50679c98c81935a`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 42, map-file ID 43, Ground-place ID 10 as `MAP_TEAM_BASE_INSIDE_TOTODILE_BASIC`. The visual source combines `B06P01C`, `B06P01Cc`, `B06P01Cm`, `B06P01C1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b06p01c_exhaustive_pass/`.
