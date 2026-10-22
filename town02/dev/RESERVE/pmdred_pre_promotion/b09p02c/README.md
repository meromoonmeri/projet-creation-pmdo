# `b09p02c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `0734a00e96182bcbc6ba4c3d007fd40ebf11eef37d01de023bc54a8549be41d3`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b09p02c.rsground` (`a7fb243719a196fec9bd659dd1db0a6f04d9d09ce8ee50db1d9affc2c46f0add`), retained unchanged;
- historical tile `RESERVE/red_tiles/b09p02c_Base.tile` (`a6aef8ccf4a4ababbfe2c698c453a5a922f939d5b3de69b2d421d13ae9f790df`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 63, map-file ID 64, Ground-place ID 11 as `MAP_TEAM_BASE_TORCHIC_BASIC`. The visual source combines `B09P02C`, `B09P02Cc`, `B09P02Cm`, `B09P02C1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b09p02c_exhaustive_pass/`.
