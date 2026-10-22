# b06p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b06p02b` is canonical EU `MAP_TEAM_BASE_INSIDE_TOTODILE_FINAL` (map ID 44, map-file ID 45). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 1465 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 480 primary boundary samples through tick 1919, plus reload tick 0;
- **481/481 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 233 unique primary frames;
- 4 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3295 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b06p02b.rsground`: `ab960fe04722222d3257f42fb0e252defad095c4438ff0d817536e9690ac289c`
- `Content/Tile/b06p02b_Base.tile`: `dea8e4f2bb697348525eee8629b920d7a7f0cee45c607704099c99761f0256a4`
- one registry insertion at index 176, immediately after `b06p02a`; BOM/order preserved; post SHA-256 `284cad6c4df01ee7990f83c3a00f1102fa0b8d08f3875e8782f93110c56ae9e3`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b06p02b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
