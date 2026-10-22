# `b05p01b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `da759c3960ad54ada646c132e70cfbd7953a7d05439a14660b0f4ba1ddda7682`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b05p01b.rsground` (`6dcc97ed6f230782aeff8ace7621e509834dbaf1aacb5003a295b5d165a9f09b`), retained unchanged;
- historical tile `RESERVE/red_tiles/b05p01b_Base.tile` (`12654bc24939fe1075de678bd7b382496c029c3b30caf8ec8f59042ef5338c79`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 35, map-file ID 36, Ground-place ID 10 as `MAP_TEAM_BASE_SQUIRTLE_FINAL`. The visual source combines `B05P01B`, `B05P01Bc`, `B05P01Bm`, `B05P01B1`, `B05P01B3`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b05p01b_exhaustive_pass/`.
