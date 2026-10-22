# b09p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b09p01b` is canonical EU `MAP_TEAM_BASE_CHARMANDER_FINAL` (map ID 59, map-file ID 60). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 97 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 24 primary boundary samples through tick 83, plus reload tick 0;
- **25/25 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 6 unique primary frames;
- 1 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3776 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b09p01b.rsground`: `575e7a7245f44197e2a8e2d82c32c93efcc70499c2eb93385993067ca9c95a64`
- `Content/Tile/b09p01b_Base.tile`: `ad3712dd43e2f934c89e818b77a278d6aea2cac7bcecdaf5f7a8be338591fc7b`
- one registry insertion at index 191, immediately after `b09p01a`; BOM/order preserved; post SHA-256 `bff3d8e5035f32ca8e77ef5ed16faa6a43f648db8e21677649e96790830ccfef`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b09p01b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
