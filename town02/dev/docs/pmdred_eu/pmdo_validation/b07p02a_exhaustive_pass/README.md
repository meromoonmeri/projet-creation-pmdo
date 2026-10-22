# b07p02a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b07p02a` is canonical EU `MAP_TEAM_BASE_INSIDE_MUDKIP_CONSTRUCTION` (map ID 49, map-file ID 50). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

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

- `Data/Ground/b07p02a.rsground`: `2f81249377f7bd34a7a7017ee77518f56b80598656a6414c0a92edc8cb5c13e9`
- `Content/Tile/b07p02a_Base.tile`: `1387a0495a57cc1f7e07baf995632054b4a0e71329ef099ce5e65fb0def38e46`
- one registry insertion at index 181, immediately after `b07p01c`; BOM/order preserved; post SHA-256 `833e573725fb88e024259e5673ad8753f11a9e9874b89fd501f3e573ab421bf3`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b07p02a/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
