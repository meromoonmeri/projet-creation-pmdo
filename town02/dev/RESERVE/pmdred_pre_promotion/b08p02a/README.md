# `b08p02a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `66a740d35aa3f4b0a24df47eb9e3cab87d5dc0635a5d16cca141ef74496003bd`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b08p02a.rsground` (`52f0fc0c2cea2a90a945a4a0f42f0da5f3c2de2a8d4a9ad0cd2a610be8a53fb1`), retained unchanged;
- historical tile `RESERVE/red_tiles/b08p02a_Base.tile` (`9c6f1beb39b7034bb768b1239413b0b7342fb345065e368eb779fe109d8c10f8`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 55, map-file ID 56, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_PSYDUCK_CONSTRUCTION`. The visual source combines `B08P02A`, `B05P02c`, `B05P02Am`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b08p02a_exhaustive_pass/`.
