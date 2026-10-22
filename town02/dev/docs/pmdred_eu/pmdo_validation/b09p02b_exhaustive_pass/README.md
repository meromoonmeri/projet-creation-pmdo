# b09p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b09p02b` is canonical EU `MAP_TEAM_BASE_INSIDE_CHARMANDER_FINAL` (map ID 62, map-file ID 63). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 4705 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 1560 primary boundary samples through tick 3359, plus reload tick 0;
- **1561/1561 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 6 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3234 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b09p02b.rsground`: `adcaa32a0f190e3e70d87d6268625a6f9883808173cee8c59252222f6d0ae140`
- `Content/Tile/b09p02b_Base.tile`: `de77a991e96498b3f1d7a714107a8f74a226e395f71ced915adbb811c736dab7`
- one registry insertion at index 194, immediately after `b09p02a`; BOM/order preserved; post SHA-256 `0734a00e96182bcbc6ba4c3d007fd40ebf11eef37d01de023bc54a8549be41d3`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b09p02b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
