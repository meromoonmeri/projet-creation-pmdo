# b01p02c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b01p02c` is canonical EU `MAP_TEAM_BASE_MEOWTH_BASIC` (map ID 15, map-file ID 16). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 28 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 1 primary boundary samples through tick 0, plus reload tick 0;
- **2/2 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 1 unique primary frames;
- 0 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3156 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b01p02c.rsground`: `90ab72038c4a73a7d5ac89c99ee8bbc92d07526575403d584ff0ba3e450b8b16`
- `Content/Tile/b01p02c_Base.tile`: `ad1ffe29272457999ae976b16b5d447183fbf83b4d09bb4f508e1d097f37f142`
- one registry insertion at index 147, immediately after `b01p02b`; BOM/order preserved; post SHA-256 `d66bdda6e1f9639b33e4c741a6b5d06552d0c8d993f25839b8b9d73df1fb6ec4`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b01p02c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
