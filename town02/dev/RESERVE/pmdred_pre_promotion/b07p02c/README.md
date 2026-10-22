# `b07p02c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `07180e1987eedd5d1af3529709e7c4fc415d40199e5aba4dffbddf3345371309`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b07p02c.rsground` (`14a4015073b21944f1bbf2dddf807940658761b0558fbfd9aa2b24b18fd9623b`), retained unchanged;
- historical tile `RESERVE/red_tiles/b07p02c_Base.tile` (`4a7eb9c34fe92861dc80230da6961c60903fce06f0466f2602b8bcafebe0172a`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 51, map-file ID 52, Ground-place ID 11 as `MAP_TEAM_BASE_PSYDUCK_BASIC`. The visual source combines `B07P02C`, `B05P02Cc`, `B05P02Cm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b07p02c_exhaustive_pass/`.
