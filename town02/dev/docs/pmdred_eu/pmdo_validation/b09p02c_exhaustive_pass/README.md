# b09p02c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b09p02c` is canonical EU `MAP_TEAM_BASE_TORCHIC_BASIC` (map ID 63, map-file ID 64). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 199 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 58 primary boundary samples through tick 159, plus reload tick 0;
- **59/59 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 27 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3208 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b09p02c.rsground`: `c64ac06556de2c2550be06e198d4f429aa6f68493c874dd203cbb849a19aff43`
- `Content/Tile/b09p02c_Base.tile`: `a6aef8ccf4a4ababbfe2c698c453a5a922f939d5b3de69b2d421d13ae9f790df`
- one registry insertion at index 195, immediately after `b09p02b`; BOM/order preserved; post SHA-256 `161df135baad6c9b23b8f2b8e2ef9d92cdda2ce2b2bb36a53a114712e440274c`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b09p02c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
