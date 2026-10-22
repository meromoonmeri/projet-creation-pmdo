# `b05p02a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `63b98211b80cc815148f163b2dc5afc6d293f73a980985a53f99905303e2fcd8`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b05p02a.rsground` (`d9cd667a5df9ac09bce39124d53ce9e2eb857ce71472683a404a03d6adc1db9b`), retained unchanged;
- historical tile `RESERVE/red_tiles/b05p02a_Base.tile` (`9c6f1beb39b7034bb768b1239413b0b7342fb345065e368eb779fe109d8c10f8`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 37, map-file ID 38, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_SQUIRTLE_CONSTRUCTION`. The visual source combines `B05P02A`, `B05P02c`, `B05P02Am`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b05p02a_exhaustive_pass/`.
