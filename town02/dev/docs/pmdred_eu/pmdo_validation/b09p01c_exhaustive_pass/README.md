# b09p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b09p01c` is canonical EU `MAP_TEAM_BASE_INSIDE_CHARMANDER_BASIC` (map ID 60, map-file ID 61). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 97 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 24 primary boundary samples through tick 83, plus reload tick 0;
- **25/25 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 6 unique primary frames;
- 1 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3717 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b09p01c.rsground`: `19f880be1bd395edbdfb8f5e7ce432910fc0e4ab344bd7af329aaacb5d400838`
- `Content/Tile/b09p01c_Base.tile`: `1bef4bef796b7ad78a58a71abfab202c704345754342338fd576d21663829878`
- one registry insertion at index 192, immediately after `b09p01b`; BOM/order preserved; post SHA-256 `5bb6b29cf9797e1e4f51d7af737c100c57b463d25a82f1ac6c8fb6d4bda754b2`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b09p01c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
