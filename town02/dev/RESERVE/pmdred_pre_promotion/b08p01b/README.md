# `b08p01b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `37dc793cec832f1aab11bfb6a683ed306fc8584fe567b4442ac52bf6626dd913`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b08p01b.rsground` (`30e8227776e6e5c0f9c9f4e66dd436cea9b10fe253c2ac0b499f9c68114a2eb4`), retained unchanged;
- historical tile `RESERVE/red_tiles/b08p01b_Base.tile` (`5e51476307085eb94c96d604552211ddd4212245cab1e8aba71054272a680827`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 53, map-file ID 54, Ground-place ID 10 as `MAP_TEAM_BASE_PSYDUCK_FINAL`. The visual source combines `B08P01B`, `B05P01Bc`, `B05P01Bm`, `B05P01B1`, `B08P01B3`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b08p01b_exhaustive_pass/`.
