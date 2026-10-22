# `b04p01c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `42a326ce18e221cf49af3c5919cfda84713914dd930ea8f2865751ebb8c86427`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b04p01c.rsground` (`b4c1d7ff41cf3b3ea4196a97ee6d266c8cee12389ac925c9b977300e218064d3`), retained unchanged;
- historical tile `RESERVE/red_tiles/b04p01c_Base.tile` (`032ec67447f36b0ddaeb562c090203c74b1dab3ad41612878a55c98622a0d7f3`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 30, map-file ID 31, Ground-place ID 10 as `MAP_TEAM_BASE_INSIDE_SKITTY_BASIC`. The visual source combines `B04P01C`, `B04P01Cc`, `B04P01Cm`, `B04P01C1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b04p01c_exhaustive_pass/`.
