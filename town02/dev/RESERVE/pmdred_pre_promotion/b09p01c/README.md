# `b09p01c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `bff3d8e5035f32ca8e77ef5ed16faa6a43f648db8e21677649e96790830ccfef`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b09p01c.rsground` (`1a20a67edb876b37f3bec29d190ed795ef2ccf132820d65a93616b05d9f0914c`), retained unchanged;
- historical tile `RESERVE/red_tiles/b09p01c_Base.tile` (`1bef4bef796b7ad78a58a71abfab202c704345754342338fd576d21663829878`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 60, map-file ID 61, Ground-place ID 10 as `MAP_TEAM_BASE_INSIDE_CHARMANDER_BASIC`. The visual source combines `B09P01C`, `B09P01Cc`, `B09P01Cm`, `B09P01C1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b09p01c_exhaustive_pass/`.
