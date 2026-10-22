# `b07p01a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `d5a03031705bc2b3f20e13c8d19aac6e05d42ee3e3b1cc99e9eee211ce1575a8`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b07p01a.rsground` (`560fffc87e77eaf1c2123f9ceb84fbafdf332e941588ac52cacc7dcbf15a5d3c`), retained unchanged;
- historical tile `RESERVE/red_tiles/b07p01a_Base.tile` (`ff7f4ddc12bc5c32551f77194c9cbf262a94d295a81d9cbb6275640aed0fd94c`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 46, map-file ID 47, Ground-place ID 10 as `MAP_TEAM_BASE_MUDKIP_CONSTRUCTION`. The visual source combines `B07P01A`, `B05P01Ac`, `B05P01Am`, `B05P01A1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b07p01a_exhaustive_pass/`.
