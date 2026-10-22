# `b06p01b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `675eea9c9e433a9227975f92bfccc8922fe67b978320e521d9487c96a697491b`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b06p01b.rsground` (`60404810fe8e737e25e27bc2524c9ee918d61eb963ba4b225153bf51a1adda99`), retained unchanged;
- historical tile `RESERVE/red_tiles/b06p01b_Base.tile` (`0920e12315134ad5827e5e147746f2d413e79eaf112eafd90fd98910d12a1042`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 41, map-file ID 42, Ground-place ID 10 as `MAP_TEAM_BASE_TOTODILE_FINAL`. The visual source combines `B06P01B`, `B05P01Bc`, `B05P01Bm`, `B05P01B1`, `B06P01B3`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b06p01b_exhaustive_pass/`.
