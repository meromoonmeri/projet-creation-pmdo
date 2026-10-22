# `b02p01b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `2aa418667bca9c12c61b56539f341f9e6528eb96eba4c5c4a58f68f06022fcf6`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b02p01b.rsground` (`394d79f34941b555f830cd85c7794834bb200169359fcd1fa4a830b333db9e86`), retained unchanged;
- historical tile `RESERVE/red_tiles/b02p01b_Base.tile` (`7355317e5fb617763b1f28ef578cb175ba7b9b95bdf49ce63708e3b2f7c26530`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 17, map-file ID 18, Ground-place ID 10 as `MAP_TEAM_BASE_MEOWTH_FINAL`. The visual source combines `B02P01B`, `B01P01Bc`, `B01P01Bm`, `B01P01B1`, `B02P01B3`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b02p01b_exhaustive_pass/`.
