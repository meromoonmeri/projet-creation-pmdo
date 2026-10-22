# b09p02a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b09p02a` is canonical EU `MAP_TEAM_BASE_INSIDE_CHARMANDER_CONSTRUCTION` (map ID 61, map-file ID 62). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 4705 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 1560 primary boundary samples through tick 3359, plus reload tick 0;
- **1561/1561 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 36 unique primary frames;
- 3 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3202 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b09p02a.rsground`: `199a1846af2b159cc4e701d41538784226a552f00ac36b891fdd2900e6e76c4f`
- `Content/Tile/b09p02a_Base.tile`: `9706a7b3404e05ba899ea5ff8282252c5c3e8a9569a8b8335676d72a4da4dbf0`
- one registry insertion at index 193, immediately after `b09p01c`; BOM/order preserved; post SHA-256 `dbd13427422a4f9706450244984d515ebe8f0f216ea633b7d783cd7a07af3f21`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b09p02a/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
