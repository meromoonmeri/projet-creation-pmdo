# `b03p02b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `124689eec5ffa5be1c65dd5a426b34b4f3962f53723bbc5381d4db4fef9c5a80`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b03p02b.rsground` (`2e2144d84b65b27d4255d0858ab6e7613ab1308092d19f692304209b1d1fde86`), retained unchanged;
- historical tile `RESERVE/red_tiles/b03p02b_Base.tile` (`ec8f5ab4cfea9b73de418a74b4c104b3eb564386ad556a9e391e0e4f70aa6cbe`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 26, map-file ID 27, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_EEVEE_FINAL`. The visual source combines `B03P02B`, `B01P02c`, `B01P02Bm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b03p02b_exhaustive_pass/`.
