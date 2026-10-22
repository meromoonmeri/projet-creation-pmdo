# `b06p02c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `284cad6c4df01ee7990f83c3a00f1102fa0b8d08f3875e8782f93110c56ae9e3`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b06p02c.rsground` (`03198e72cc088127dcc6397f605637c9ebae490ac9f7febd80b72f28efbe3724`), retained unchanged;
- historical tile `RESERVE/red_tiles/b06p02c_Base.tile` (`4a7eb9c34fe92861dc80230da6961c60903fce06f0466f2602b8bcafebe0172a`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 45, map-file ID 46, Ground-place ID 11 as `MAP_TEAM_BASE_MUDKIP_BASIC`. The visual source combines `B06P02C`, `B05P02Cc`, `B05P02Cm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b06p02c_exhaustive_pass/`.
