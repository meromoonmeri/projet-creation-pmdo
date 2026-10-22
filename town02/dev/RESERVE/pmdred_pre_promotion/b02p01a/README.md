# `b02p01a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `d66bdda6e1f9639b33e4c741a6b5d06552d0c8d993f25839b8b9d73df1fb6ec4`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b02p01a.rsground` (`3abd3c1b01570039013bf63579b7c0873759d731ed46c7aa03d54b9ac8f1dee2`), retained unchanged;
- historical tile `RESERVE/red_tiles/b02p01a_Base.tile` (`d6a7088978d33196fab79b0285b505b84a6de86b01914033c8d0ac502fa7d4ba`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 16, map-file ID 17, Ground-place ID 10 as `MAP_TEAM_BASE_MEOWTH_CONSTRUCTION`. The visual source combines `B02P01A`, `B01P01Ac`, `B01P01Am`, `B01P01A1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b02p01a_exhaustive_pass/`.
