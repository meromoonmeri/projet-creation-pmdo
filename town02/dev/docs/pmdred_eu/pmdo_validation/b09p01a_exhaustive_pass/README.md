# b09p01a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b09p01a` is canonical EU `MAP_TEAM_BASE_CHARMANDER_CONSTRUCTION` (map ID 58, map-file ID 59). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 97 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 24 primary boundary samples through tick 83, plus reload tick 0;
- **25/25 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 6 unique primary frames;
- 1 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3698 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b09p01a.rsground`: `3e1563a0a12855ee15bf03c5ca0e8c6908212779b094282d706da28a87d2d22d`
- `Content/Tile/b09p01a_Base.tile`: `556c13c01482ffcf0ee8dd632d17fd49da502e994dbff888cd9d61f3fde18281`
- one registry insertion at index 190, immediately after `b08p02c`; BOM/order preserved; post SHA-256 `64424d58a509f1be2264077c42a95040310813d64a55daf7f86e94cf13e8f864`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b09p01a/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
