# `b04p02c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `2ea3c748286efe8aea235849ebc54327c3be77048674ec9ded768dfaba36d40a`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b04p02c.rsground` (`c84387e357ccabe47bb34a7d0062dd7030cf9b9b2a9b79e2a8607cff4a442a89`), retained unchanged;
- historical tile `RESERVE/red_tiles/b04p02c_Base.tile` (`ad1ffe29272457999ae976b16b5d447183fbf83b4d09bb4f508e1d097f37f142`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 33, map-file ID 34, Ground-place ID 11 as `MAP_TEAM_BASE_SQUIRTLE_BASIC`. The visual source combines `B04P02C`, `B01P02Cc`, `B01P02Cm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b04p02c_exhaustive_pass/`.
