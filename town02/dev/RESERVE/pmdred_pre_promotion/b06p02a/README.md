# `b06p02a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `cc175ca1cf9edc7184c9c47f758aac31d56e0885ebd6e262c6682045cc1f8610`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b06p02a.rsground` (`21536d8e620a02a393e55ab113da304a664e75fd1aab85e4c3239adc3575692f`), retained unchanged;
- historical tile `RESERVE/red_tiles/b06p02a_Base.tile` (`9c6f1beb39b7034bb768b1239413b0b7342fb345065e368eb779fe109d8c10f8`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 43, map-file ID 44, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_TOTODILE_CONSTRUCTION`. The visual source combines `B06P02A`, `B05P02c`, `B05P02Am`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b06p02a_exhaustive_pass/`.
