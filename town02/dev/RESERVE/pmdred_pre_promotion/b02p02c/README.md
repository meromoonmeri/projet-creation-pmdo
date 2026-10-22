# `b02p02c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `d5f3086e90480dcfc9b5aa487e6533d95d610d6376a2b6820ebdfc69c037e84f`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b02p02c.rsground` (`c3357308d2f02c7cc49d579dea7a221018df30ac79162e31d57fcbf733dc2443`), retained unchanged;
- historical tile `RESERVE/red_tiles/b02p02c_Base.tile` (`ad1ffe29272457999ae976b16b5d447183fbf83b4d09bb4f508e1d097f37f142`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 21, map-file ID 22, Ground-place ID 11 as `MAP_TEAM_BASE_EEVEE_BASIC`. The visual source combines `B02P02C`, `B01P02Cc`, `B01P02Cm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b02p02c_exhaustive_pass/`.
