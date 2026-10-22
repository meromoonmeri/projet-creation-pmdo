# `b08p01c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `a2097ffa7a7167ebc2b539d490fe861ff1ef7bca4815b87b81e8c0ce1fdabe26`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b08p01c.rsground` (`80a14f4225944deb19734462540bbd268964b69dc29d6b06ed7ca1fdf3192484`), retained unchanged;
- historical tile `RESERVE/red_tiles/b08p01c_Base.tile` (`869e3676829c05f63ea982c4655975027a5cc5e0edf43b8322ba5e281ba43d79`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 54, map-file ID 55, Ground-place ID 10 as `MAP_TEAM_BASE_INSIDE_PSYDUCK_BASIC`. The visual source combines `B08P01C`, `B08P01Cc`, `B08P01Cm`, `B08P01C1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b08p01c_exhaustive_pass/`.
