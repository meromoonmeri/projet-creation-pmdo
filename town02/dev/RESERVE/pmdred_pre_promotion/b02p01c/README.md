# `b02p01c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `e402d602ce3f6dd6221b524f7b55bf3760a1723a34b1ec8ce9075d8de81e197b`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b02p01c.rsground` (`a0970c4ce8201e1251ec248d38c3876d815fe5558521759c3295b79d668fcada`), retained unchanged;
- historical tile `RESERVE/red_tiles/b02p01c_Base.tile` (`b31cab976de89db462835ee40aa0d2e42af0752e36d68eea063a94fa6380063b`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 18, map-file ID 19, Ground-place ID 10 as `MAP_TEAM_BASE_INSIDE_MEOWTH_BASIC`. The visual source combines `B02P01C`, `B02P01Cc`, `B02P01Cm`, `B02P01C1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b02p01c_exhaustive_pass/`.
