# `b07p02b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `833e573725fb88e024259e5673ad8753f11a9e9874b89fd501f3e573ab421bf3`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b07p02b.rsground` (`663d7f0fe27f7731d62aa22f7487e342123ab1f40a667e9eb990efe0dd62e934`), retained unchanged;
- historical tile `RESERVE/red_tiles/b07p02b_Base.tile` (`b589283f5822564edf2d3f39633c3dd11fb720a760263f667a883a8f58142e37`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 50, map-file ID 51, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_MUDKIP_FINAL`. The visual source combines `B07P02B`, `B05P02c`, `B05P02Bm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b07p02b_exhaustive_pass/`.
