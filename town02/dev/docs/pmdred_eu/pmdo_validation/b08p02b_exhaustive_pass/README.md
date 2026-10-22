# b08p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b08p02b` is canonical EU `MAP_TEAM_BASE_INSIDE_PSYDUCK_FINAL` (map ID 56, map-file ID 57). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

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

- `Data/Ground/b08p02b.rsground`: `c3b06a21afd3d3a87e7e752d006838e6bd611e80c147a60f65f514d07e1c741d`
- `Content/Tile/b08p02b_Base.tile`: `dea8e4f2bb697348525eee8629b920d7a7f0cee45c607704099c99761f0256a4`
- one registry insertion at index 188, immediately after `b08p02a`; BOM/order preserved; post SHA-256 `4713e7135e0b4d3822c9da37c0d66575230909c6750ed43ef76519b33d61888a`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b08p02b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
