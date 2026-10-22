# `b01p01b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `bc22b90d6769a785668ad7ea3c48f9716c93c3f881b00fab091e221d5fcd4c0e`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b01p01b.rsground` (`c32e48d187a76dbd9d3fa50cbaf1cec48bcc33db83307a9627c77d867b70e4c0`), retained unchanged;
- historical tile `RESERVE/red_tiles/b01p01b_Base.tile` (`61c7bf8768db5e0b0769e5235392d493ba16310355fd3bdf79a9d5015119f812`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 11, map-file ID 12, Ground-place ID 10 as `MAP_TEAM_BASE_PIKACHU_FINAL`. The visual source combines `B01P01B`, `B01P01Bc`, `B01P01Bm`, `B01P01B1`, `B01P01B3`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b01p01b_exhaustive_pass/`.
