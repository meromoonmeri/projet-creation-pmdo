# `b03p01a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `7705f3fba1bf680fc012c442f2c96926e601538a850ae2b485fd408d76293ebc`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b03p01a.rsground` (`2a9f644832d9c4915a2c896a476252e6c2a45e19aece625d6fd96a94b5226a6c`), retained unchanged;
- historical tile `RESERVE/red_tiles/b03p01a_Base.tile` (`d6a7088978d33196fab79b0285b505b84a6de86b01914033c8d0ac502fa7d4ba`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 22, map-file ID 23, Ground-place ID 10 as `MAP_TEAM_BASE_EEVEE_CONSTRUCTION`. The visual source combines `B03P01A`, `B01P01Ac`, `B01P01Am`, `B01P01A1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b03p01a_exhaustive_pass/`.
