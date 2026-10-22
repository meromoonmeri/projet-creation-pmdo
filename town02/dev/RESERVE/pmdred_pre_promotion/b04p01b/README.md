# `b04p01b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `00fc899c91ef76631b3d1c75fb14b85b3f72ee1fd00c98374c1e44f502b65cab`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b04p01b.rsground` (`c4a5784fc89657ad2e033e8223c475ebfc793e504a0121f5499dfeb70f74ba10`), retained unchanged;
- historical tile `RESERVE/red_tiles/b04p01b_Base.tile` (`917e0ffa07eced179eda7e362ca75a3f6aa53a877752b728cc86009300d5e4a1`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 29, map-file ID 30, Ground-place ID 10 as `MAP_TEAM_BASE_SKITTY_FINAL`. The visual source combines `B04P01B`, `B01P01Bc`, `B01P01Bm`, `B01P01B1`, `B04P01B3`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b04p01b_exhaustive_pass/`.
