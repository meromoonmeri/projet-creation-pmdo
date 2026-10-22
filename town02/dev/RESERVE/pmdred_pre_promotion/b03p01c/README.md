# `b03p01c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `a0b3840f87c56b2fdf927e387f19274829553d3548c88419a8993c7609c1afee`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b03p01c.rsground` (`94a37ad4290a247de161a8ccaa0e27aa2a14c9d69ff4a645dcc74b858a2ce2fb`), retained unchanged;
- historical tile `RESERVE/red_tiles/b03p01c_Base.tile` (`9863d6597da8f9c8db0a025d4b9cdcbdfcff949446c2e2dba79b231a0a886d8b`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 24, map-file ID 25, Ground-place ID 10 as `MAP_TEAM_BASE_INSIDE_EEVEE_BASIC`. The visual source combines `B03P01C`, `B03P01Cc`, `B03P01Cm`, `B03P01C1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b03p01c_exhaustive_pass/`.
