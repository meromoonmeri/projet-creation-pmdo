# `b03p01b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `723ab4c42abbafd859bc8f5bfbdb092cd01cf7bb0c044144f7bc3ef11d154aa2`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b03p01b.rsground` (`b4c9875f18468112187abc42948fe6afc63a68adc24601075d71a5e6d7cbb074`), retained unchanged;
- historical tile `RESERVE/red_tiles/b03p01b_Base.tile` (`5f99e441ae5d88ad97797422ca4dc19635017b590b2bef18c75586bb55b902ff`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 23, map-file ID 24, Ground-place ID 10 as `MAP_TEAM_BASE_EEVEE_FINAL`. The visual source combines `B03P01B`, `B01P01Bc`, `B01P01Bm`, `B01P01B1`, `B03P01B3`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b03p01b_exhaustive_pass/`.
