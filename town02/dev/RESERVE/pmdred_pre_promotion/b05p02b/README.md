# `b05p02b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `5e81da668eca1842e88103c1d90a441d96dfb620075c6732b386a4d0bdd6a221`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b05p02b.rsground` (`353c01f916a681a91af300ca8f2f33ab13ec48f2b15d41b08a3d9875e8835de2`), retained unchanged;
- historical tile `RESERVE/red_tiles/b05p02b_Base.tile` (`b589283f5822564edf2d3f39633c3dd11fb720a760263f667a883a8f58142e37`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 38, map-file ID 39, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_SQUIRTLE_FINAL`. The visual source combines `B05P02B`, `B05P02c`, `B05P02Bm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b05p02b_exhaustive_pass/`.
