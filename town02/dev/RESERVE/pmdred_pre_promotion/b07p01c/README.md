# `b07p01c` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `fd8f322ab2d78c8b9610ed1e46ba024c9a76a8e911adceb1f59000c0999af976`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b07p01c.rsground` (`9a727d66f05b70942b369d977425fbdebcc20bc6dabac3f95b2d4fca55e8ef31`), retained unchanged;
- historical tile `RESERVE/red_tiles/b07p01c_Base.tile` (`9a05ae5f91de685f4bcd3d0b3ccfc1720ca04074d7f0e038cb8308f46043c4eb`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 48, map-file ID 49, Ground-place ID 10 as `MAP_TEAM_BASE_INSIDE_MUDKIP_BASIC`. The visual source combines `B07P01C`, `B07P01Cc`, `B07P01Cm`, `B07P01C1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b07p01c_exhaustive_pass/`.
