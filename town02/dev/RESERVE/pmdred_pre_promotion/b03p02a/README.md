# `b03p02a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `3a8123aa897618dcfce41053594d179954d36f1d1859fddc0ac811143a8e102b`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b03p02a.rsground` (`ea56cb1caf7c70465e80de2343bbf395d8c1e0132e05ee6426ccb068b399d745`), retained unchanged;
- historical tile `RESERVE/red_tiles/b03p02a_Base.tile` (`7f260e40b2e42f19f5197bac1468fdf2a9eb39aee38e50470723a1391f913e94`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 25, map-file ID 26, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_EEVEE_CONSTRUCTION`. The visual source combines `B03P02A`, `B01P02c`, `B01P02Am`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b03p02a_exhaustive_pass/`.
