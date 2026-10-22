# `b06p02b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `f89499ffe48f4067148efa890707c1bcdb6053ebd517d42ce2e3baab0e1a554c`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b06p02b.rsground` (`d7be08ea87bf700f9e783a8e31647e3e3263e2a3e383ed1cc83df7d3c8845426`), retained unchanged;
- historical tile `RESERVE/red_tiles/b06p02b_Base.tile` (`b589283f5822564edf2d3f39633c3dd11fb720a760263f667a883a8f58142e37`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 44, map-file ID 45, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_TOTODILE_FINAL`. The visual source combines `B06P02B`, `B05P02c`, `B05P02Bm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b06p02b_exhaustive_pass/`.
