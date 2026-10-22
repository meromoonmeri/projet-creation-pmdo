# `b04p02b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `f5dc523d13aa832bdaeafb37dc6ebd8ce2dd3295c49f553e9bfbc602d37f3227`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b04p02b.rsground` (`510625639bf086ef46d64871a928ae1bbe83b8a8399d67aff7fbe421c04b30b0`), retained unchanged;
- historical tile `RESERVE/red_tiles/b04p02b_Base.tile` (`ec8f5ab4cfea9b73de418a74b4c104b3eb564386ad556a9e391e0e4f70aa6cbe`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 32, map-file ID 33, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_SKITTY_FINAL`. The visual source combines `B04P02B`, `B01P02c`, `B01P02Bm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b04p02b_exhaustive_pass/`.
