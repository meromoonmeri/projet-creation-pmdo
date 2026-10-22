# `b09p01b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `64424d58a509f1be2264077c42a95040310813d64a55daf7f86e94cf13e8f864`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b09p01b.rsground` (`3959e00f18b18814c83525b27439c25db021bdf4561783a9cf5c69d90b36b510`), retained unchanged;
- historical tile `RESERVE/red_tiles/b09p01b_Base.tile` (`ad3712dd43e2f934c89e818b77a278d6aea2cac7bcecdaf5f7a8be338591fc7b`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 59, map-file ID 60, Ground-place ID 10 as `MAP_TEAM_BASE_CHARMANDER_FINAL`. The visual source combines `B09P01B`, `B09P01Bc`, `B09P01Bm`, `B09P01B1`, `B09P01B3`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b09p01b_exhaustive_pass/`.
