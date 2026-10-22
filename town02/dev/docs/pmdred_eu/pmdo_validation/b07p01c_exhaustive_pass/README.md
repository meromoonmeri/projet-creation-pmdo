# b07p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b07p01c` is canonical EU `MAP_TEAM_BASE_INSIDE_MUDKIP_BASIC` (map ID 48, map-file ID 49). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 175 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 50 primary boundary samples through tick 127, plus reload tick 0;
- **51/51 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 32 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3712 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b07p01c.rsground`: `d75cfce108abf34deaf3aaaf14fdf327d0804efdc03e881d80af98b8c32fb714`
- `Content/Tile/b07p01c_Base.tile`: `9a05ae5f91de685f4bcd3d0b3ccfc1720ca04074d7f0e038cb8308f46043c4eb`
- one registry insertion at index 180, immediately after `b07p01b`; BOM/order preserved; post SHA-256 `753e3b279e1bdd7e29851f1b9958c19fa269f363bd650ab18c696c7630295389`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b07p01c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
