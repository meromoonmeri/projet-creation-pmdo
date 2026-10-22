# `b09p01a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `79995f56a4ddd7b2818f133811f01461461a430029947973262b25c277099ce0`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b09p01a.rsground` (`50271f4f7af9cde49aa800d31b950808e238094e773b86d10fcf592a705f086b`), retained unchanged;
- historical tile `RESERVE/red_tiles/b09p01a_Base.tile` (`556c13c01482ffcf0ee8dd632d17fd49da502e994dbff888cd9d61f3fde18281`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 58, map-file ID 59, Ground-place ID 10 as `MAP_TEAM_BASE_CHARMANDER_CONSTRUCTION`. The visual source combines `B09P01A`, `B09P01Ac`, `B09P01Am`, `B09P01A1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b09p01a_exhaustive_pass/`.
