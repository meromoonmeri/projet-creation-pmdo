# `b04p01a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `b017904539c1f707c73fa0cbaac77d24badd41a8b2a128055a429cdb31f006b6`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b04p01a.rsground` (`edfc021ad0ff0d7af4286a7cb873a9a208d1e083bc1b4f5e936b5a74d066f408`), retained unchanged;
- historical tile `RESERVE/red_tiles/b04p01a_Base.tile` (`d6a7088978d33196fab79b0285b505b84a6de86b01914033c8d0ac502fa7d4ba`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 28, map-file ID 29, Ground-place ID 10 as `MAP_TEAM_BASE_SKITTY_CONSTRUCTION`. The visual source combines `B04P01A`, `B01P01Ac`, `B01P01Am`, `B01P01A1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b04p01a_exhaustive_pass/`.
