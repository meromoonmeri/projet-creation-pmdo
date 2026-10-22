# `b08p02b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `ef3e2f18913ff28bd2182d46122ec43d956ad305d170b8b698b3b7035c11ff11`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b08p02b.rsground` (`daf6842164542d65689b52ae19567f1317957a8a671df3dbac2ba17b7fea5b98`), retained unchanged;
- historical tile `RESERVE/red_tiles/b08p02b_Base.tile` (`b589283f5822564edf2d3f39633c3dd11fb720a760263f667a883a8f58142e37`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 56, map-file ID 57, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_PSYDUCK_FINAL`. The visual source combines `B08P02B`, `B05P02c`, `B05P02Bm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b08p02b_exhaustive_pass/`.
