# `b01p02b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `7232335622cb411610aca609869b4b2326c0b4ca16d43327976cbf85cecddd44`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b01p02b.rsground` (`b23349ac4e73e2f8ea0ddbae56945924cdfb283ad1d5d0c1e11dc406296615dd`), retained unchanged;
- historical tile `RESERVE/red_tiles/b01p02b_Base.tile` (`ec8f5ab4cfea9b73de418a74b4c104b3eb564386ad556a9e391e0e4f70aa6cbe`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 14, map-file ID 15, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_PIKACHU_FINAL`. The visual source combines `B01P02B`, `B01P02c`, `B01P02Bm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b01p02b_exhaustive_pass/`.
