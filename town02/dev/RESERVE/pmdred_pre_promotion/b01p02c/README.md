# `b01p02c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `3c086654ff04243a797ad50e92f9685e3737782d93c93e8b64db93665212869c`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b01p02c.rsground` (`2e280e57cc58999b6c4d502dce97a5e433de426cc5c5e1dd62bf8c4bed829aff`), retained unchanged;
- historical tile `RESERVE/red_tiles/b01p02c_Base.tile` (`ad1ffe29272457999ae976b16b5d447183fbf83b4d09bb4f508e1d097f37f142`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 15, map-file ID 16, Ground-place ID 11 as `MAP_TEAM_BASE_MEOWTH_BASIC`. The visual source combines `B01P02C`, `B01P02Cc`, `B01P02Cm`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b01p02c_exhaustive_pass/`.
