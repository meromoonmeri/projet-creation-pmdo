# `b01p02a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `882fabd41bb7ebe348e4ce729ac9c9da169ee973f81a4b01b5702aa5c5d74345`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b01p02a.rsground` (`b97f625c3510e3cd937f1e3fa0268be4dceca01c32759f76085be17a6aadf6d6`), retained unchanged;
- historical tile `RESERVE/red_tiles/b01p02a_Base.tile` (`7f260e40b2e42f19f5197bac1468fdf2a9eb39aee38e50470723a1391f913e94`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 13, map-file ID 14, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_PIKACHU_CONSTRUCTION`. The visual source combines `B01P02A`, `B01P02c`, `B01P02Am`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b01p02a_exhaustive_pass/`.
