# `b01p01a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `b7c0b933ec73b3c6078f748209c8aa2b872e7ee1690811ede66c714bb7c2dc6d`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b01p01a.rsground` (`006b9961bb22e2ef728a7c8fba324626bc7f3f3426e64db34d5a90020bf127d2`), retained unchanged;
- historical tile `RESERVE/red_tiles/b01p01a_Base.tile` (`d6a7088978d33196fab79b0285b505b84a6de86b01914033c8d0ac502fa7d4ba`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 10, map-file ID 11, Ground-place ID 10 as `MAP_TEAM_BASE_PIKACHU_CONSTRUCTION`. The visual source combines `B01P01A`, `B01P01Ac`, `B01P01Am`, `B01P01A1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b01p01a_exhaustive_pass/`.
