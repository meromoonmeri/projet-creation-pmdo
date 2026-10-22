# `b03p02c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `c3f27cf2f64ff413ace70ffc8ddad1f50562453543b2afe497fe8bfb59124048`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b03p02c.rsground` (`16bb3b4e87b78bf36a4efd179e8314dd0075270c2514aa56e902750ef7fef121`), retained unchanged;
- historical tile `RESERVE/red_tiles/b03p02c_Base.tile` (`ad1ffe29272457999ae976b16b5d447183fbf83b4d09bb4f508e1d097f37f142`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 27, map-file ID 28, Ground-place ID 11 as `MAP_TEAM_BASE_SKITTY_BASIC`. The visual source combines `B03P02C`, `B01P02Cc`, `B01P02Cm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b03p02c_exhaustive_pass/`.
