# `b09p02a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `5bb6b29cf9797e1e4f51d7af737c100c57b463d25a82f1ac6c8fb6d4bda754b2`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b09p02a.rsground` (`33b2f9dddb8b5efb7814b49606431b48754226e6aeecfeb17b59e3629a534dbb`), retained unchanged;
- historical tile `RESERVE/red_tiles/b09p02a_Base.tile` (`736104cafcda450a114285c37f4afd89c0da686118e1296e068603667727e2c9`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 61, map-file ID 62, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_CHARMANDER_CONSTRUCTION`. The visual source combines `B09P02A`, `B09P02c`, `B09P02Am`, `B09P021`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b09p02a_exhaustive_pass/`.
