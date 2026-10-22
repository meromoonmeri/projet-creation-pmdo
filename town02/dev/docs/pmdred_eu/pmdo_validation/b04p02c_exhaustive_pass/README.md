# b04p02c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b04p02c` is canonical EU `MAP_TEAM_BASE_SQUIRTLE_BASIC` (map ID 33, map-file ID 34). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

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

- `Data/Ground/b04p02c.rsground`: `4e7383382b0e4225bf93b91b70aa25dbcc713f08e3d84bda7ed12a64599f0f77`
- `Content/Tile/b04p02c_Base.tile`: `ad1ffe29272457999ae976b16b5d447183fbf83b4d09bb4f508e1d097f37f142`
- one registry insertion at index 165, immediately after `b04p02b`; BOM/order preserved; post SHA-256 `fe83c3186422feec468775c8ce99805bb1e7fcd945a6ef54a24ee79139e8c23c`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b04p02c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
