# `b09p02b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `dbd13427422a4f9706450244984d515ebe8f0f216ea633b7d783cd7a07af3f21`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b09p02b.rsground` (`8dcdf7bf4d25b0fd0112d8af3d3fa59705c836327d54081fe8b27388dfbc4b6d`), retained unchanged;
- historical tile `RESERVE/red_tiles/b09p02b_Base.tile` (`de77a991e96498b3f1d7a714107a8f74a226e395f71ced915adbb811c736dab7`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 62, map-file ID 63, Ground-place ID 11 as `MAP_TEAM_BASE_INSIDE_CHARMANDER_FINAL`. The visual source combines `B09P02B`, `B09P02c`, `B09P02Bm`, `B09P021`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b09p02b_exhaustive_pass/`.
