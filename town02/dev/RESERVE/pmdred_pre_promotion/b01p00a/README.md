# `b01p00a` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `0a1c5280b99157323a914d9f029a19f243c80e2d27ff041d1bd63807f9183226`. Promotion was additive.

No same-name historical Ground or tile exists under `RESERVE/red_grounds/` or `RESERVE/red_tiles/`; no active project asset, script, route, variant, or alias was removed or rewritten.

Authenticated European-ROM extraction identifies canonical debug ID 10, map ID 9, map-file ID 10, Ground-place ID 10 as `MAP_TEAM_BASE_PIKACHU_BASIC`. The visual source combines `B01P00A` with `B01P01Ac`, `B01P01Am`, and `B01P01A1`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, construction-state routing, or the other team-base species/interior variants.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b01p00a_exhaustive_pass/`.
