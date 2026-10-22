# `b07p02a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `753e3b279e1bdd7e29851f1b9958c19fa269f363bd650ab18c696c7630295389`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b07p02a.rsground` (`78bfe2cab5266663df421f23e125a6f0ffbfd1184b4de450b344cce40cca31ce`), retained unchanged;
- historical tile `RESERVE/red_tiles/b07p02a_Base.tile` (`9c6f1beb39b7034bb768b1239413b0b7342fb345065e368eb779fe109d8c10f8`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 49, map-file ID 50, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_MUDKIP_CONSTRUCTION`. The visual source combines `B07P02A`, `B05P02c`, `B05P02Am`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b07p02a_exhaustive_pass/`.
