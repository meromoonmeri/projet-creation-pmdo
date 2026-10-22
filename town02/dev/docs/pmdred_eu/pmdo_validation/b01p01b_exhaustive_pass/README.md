# b01p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b01p01b` is canonical EU `MAP_TEAM_BASE_PIKACHU_FINAL` (map ID 11, map-file ID 12). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 97 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 24 primary boundary samples through tick 83, plus reload tick 0;
- **25/25 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 6 unique primary frames;
- 1 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3767 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b01p01b.rsground`: `7ad1758b66c7aec996a35d56b2298bc35a7605f2c1b01c5fd66753f71edbaabb`
- `Content/Tile/b01p01b_Base.tile`: `61c7bf8768db5e0b0769e5235392d493ba16310355fd3bdf79a9d5015119f812`
- one registry insertion at index 143, immediately after `b01p01a`; BOM/order preserved; post SHA-256 `c842cb920de7b9eed3919d00f9ace9c961098619773a02e2fae053c5871db88b`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b01p01b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
