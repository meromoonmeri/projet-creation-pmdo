# `b02p02a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `06cdafb983f335b8dae8a097a4b96e6674bc8606d0542bb3a9db028e5b8a46e5`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b02p02a.rsground` (`863b27ec09832886b40fdda9f66567fe9052721fd60f5bd5fdb5690a06b26978`), retained unchanged;
- historical tile `RESERVE/red_tiles/b02p02a_Base.tile` (`7f260e40b2e42f19f5197bac1468fdf2a9eb39aee38e50470723a1391f913e94`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 19, map-file ID 20, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_MEOWTH_CONSTRUCTION`. The visual source combines `B02P02A`, `B01P02c`, `B01P02Am`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b02p02a_exhaustive_pass/`.
