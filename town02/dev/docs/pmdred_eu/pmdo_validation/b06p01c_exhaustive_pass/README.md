# b06p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b06p01c` is canonical EU `MAP_TEAM_BASE_INSIDE_TOTODILE_BASIC` (map ID 42, map-file ID 43). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 175 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 50 primary boundary samples through tick 127, plus reload tick 0;
- **51/51 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 32 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3711 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b06p01c.rsground`: `3825ed3f36959a7ef70a2ca84dc410536d8dd3543d458172cdf7daaaae60f23b`
- `Content/Tile/b06p01c_Base.tile`: `2398db32660589463a0b9212e4ffe7ada44e80f2d9481488a50679c98c81935a`
- one registry insertion at index 174, immediately after `b06p01b`; BOM/order preserved; post SHA-256 `cc175ca1cf9edc7184c9c47f758aac31d56e0885ebd6e262c6682045cc1f8610`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b06p01c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
