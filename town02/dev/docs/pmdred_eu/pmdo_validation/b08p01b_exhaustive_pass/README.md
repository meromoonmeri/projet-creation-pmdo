# b08p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b08p01b` is canonical EU `MAP_TEAM_BASE_PSYDUCK_FINAL` (map ID 53, map-file ID 54). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 175 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 50 primary boundary samples through tick 127, plus reload tick 0;
- **51/51 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 32 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3767 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b08p01b.rsground`: `6fed61eef06bc26a837b6307c926b131534415df70f666c2eba3b3f7aae23dec`
- `Content/Tile/b08p01b_Base.tile`: `5e51476307085eb94c96d604552211ddd4212245cab1e8aba71054272a680827`
- one registry insertion at index 185, immediately after `b08p01a`; BOM/order preserved; post SHA-256 `a2097ffa7a7167ebc2b539d490fe861ff1ef7bca4815b87b81e8c0ce1fdabe26`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b08p01b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
