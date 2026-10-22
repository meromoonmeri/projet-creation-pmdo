# `b07p01b` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `3ed685cc11650481cb8b12641138d66fdc6eaa5a6c79cf57ced5b9283f73714a`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/b07p01b.rsground` (`901a7b88fab9cbbc20035d5801c68718e2aa289ec42aa0a5470ca342abfc84b0`), retained unchanged;
- historical tile `RESERVE/red_tiles/b07p01b_Base.tile` (`83f25ae821e8055af5bf31a714a07ee7dabf766f72036ed61e6d342a1e89c251`), retained unchanged;
- all active project scripts, routes, variants, aliases, and existing registry entries.

Authenticated European-ROM extraction identifies canonical map ID 47, map-file ID 48, Ground-place ID 10 as `MAP_TEAM_BASE_MUDKIP_FINAL`. The visual source combines `B07P01B`, `B05P01Bc`, `B05P01Bm`, `B05P01B1`, `B07P01B3`. This pass validates and promotes the Ground graphics only; it does not claim story events, actors, entrances, music, or routing.

The exact tested bare candidate is installed without the fixture-only deterministic entry marker. Promoted bytes exactly equal the authenticated exact-PMDO-tested v2.0.1-eu candidate. Evidence: `docs/pmdred_eu/pmdo_validation/b07p01b_exhaustive_pass/`.
