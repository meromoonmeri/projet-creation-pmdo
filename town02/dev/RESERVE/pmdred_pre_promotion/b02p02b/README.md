# `b02p02b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `1d2ac656947d94445693edd36431924341544c70ba0fd9d54bb8d2a4bd8ce7d2`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b02p02b.rsground` (`e85bd035fea7759571688049c28a4ded6b8ea685117eeef76f4cb6ea6375e95a`), retained unchanged;
- historical tile `RESERVE/red_tiles/b02p02b_Base.tile` (`ec8f5ab4cfea9b73de418a74b4c104b3eb564386ad556a9e391e0e4f70aa6cbe`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 20, map-file ID 21, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_MEOWTH_FINAL`. The visual source combines `B02P02B`, `B01P02c`, `B01P02Bm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b02p02b_exhaustive_pass/`.
