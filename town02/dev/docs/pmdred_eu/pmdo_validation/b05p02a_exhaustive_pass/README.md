# b05p02a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b05p02a` is canonical EU `MAP_TEAM_BASE_INSIDE_SQUIRTLE_CONSTRUCTION` (map ID 37, map-file ID 38). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 1465 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 480 primary boundary samples through tick 1919, plus reload tick 0;
- **481/481 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 233 unique primary frames;
- 4 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3295 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b05p02a.rsground`: `5f76d3decc993635843a55cdc50fed1986db45c146d9612c453a7f57c36e0832`
- `Content/Tile/b05p02a_Base.tile`: `1387a0495a57cc1f7e07baf995632054b4a0e71329ef099ce5e65fb0def38e46`
- one registry insertion at index 169, immediately after `b05p01c`; BOM/order preserved; post SHA-256 `5e81da668eca1842e88103c1d90a441d96dfb620075c6732b386a4d0bdd6a221`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b05p02a/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
