# b05p02c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b05p02c` is canonical EU `MAP_TEAM_BASE_TOTODILE_BASIC` (map ID 39, map-file ID 40). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 5785 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 1920 primary boundary samples through tick 5759, plus reload tick 0;
- **1921/1921 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 180 unique primary frames;
- 4 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3307 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b05p02c.rsground`: `b14b8d5d9b4ddf57f95f660810951ad7cc61e9c28d408a4248c8a114abe1b4b5`
- `Content/Tile/b05p02c_Base.tile`: `11eb7a8724b4dd0a971e69161d62e7f47ac6eac57e8d246bfecb9f1fee46f2e1`
- one registry insertion at index 171, immediately after `b05p02b`; BOM/order preserved; post SHA-256 `c6854876026d741a894e6585546c11ffc527ec8ee509a7fefdc817b03d8dbf66`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b05p02c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
