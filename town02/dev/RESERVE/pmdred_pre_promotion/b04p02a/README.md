# `b04p02a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `dfb89cb66b06d44fbb5f77931eb56949072387e646b507ea97fabd9e0e9b987c`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b04p02a.rsground` (`621aea139e4f508d50ae62f4ca0f7f521afd6a779da19f6cd8e23258c35ed33f`), retained unchanged;
- historical tile `RESERVE/red_tiles/b04p02a_Base.tile` (`7f260e40b2e42f19f5197bac1468fdf2a9eb39aee38e50470723a1391f913e94`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 31, map-file ID 32, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_SKITTY_CONSTRUCTION`. The visual source combines `B04P02A`, `B01P02c`, `B01P02Am`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b04p02a_exhaustive_pass/`.
