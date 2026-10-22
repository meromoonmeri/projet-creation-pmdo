# `b05p02c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `0b693e2a99c047e95faf73128aa130b793f51a5ea30c790497f3322d2a37139d`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b05p02c.rsground` (`57bc4be8710e1b01f4ba7d888060b3203c788f5a49e7b8b40310db68b4980f32`), retained unchanged;
- historical tile `RESERVE/red_tiles/b05p02c_Base.tile` (`4a7eb9c34fe92861dc80230da6961c60903fce06f0466f2602b8bcafebe0172a`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 39, map-file ID 40, Ground-place ID 11 as `MAP_TEAM_BASE_TOTODILE_BASIC`. The visual source combines `B05P02C`, `B05P02Cc`, `B05P02Cm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b05p02c_exhaustive_pass/`.
