# b02p01a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b02p01a` is canonical EU `MAP_TEAM_BASE_MEOWTH_CONSTRUCTION` (map ID 16, map-file ID 17). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 97 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 24 primary boundary samples through tick 83, plus reload tick 0;
- **25/25 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 6 unique primary frames;
- 1 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3652 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b02p01a.rsground`: `3fa7bb08eb49bf99633bbef16c00a44d1fc52343fd1dcc4f1aaf89b956fc66fa`
- `Content/Tile/b02p01a_Base.tile`: `d6a7088978d33196fab79b0285b505b84a6de86b01914033c8d0ac502fa7d4ba`
- one registry insertion at index 148, immediately after `b01p02c`; BOM/order preserved; post SHA-256 `2aa418667bca9c12c61b56539f341f9e6528eb96eba4c5c4a58f68f06022fcf6`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b02p01a/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
