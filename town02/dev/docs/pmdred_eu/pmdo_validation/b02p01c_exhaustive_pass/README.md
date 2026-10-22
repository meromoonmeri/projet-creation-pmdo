# b02p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b02p01c` is canonical EU `MAP_TEAM_BASE_INSIDE_MEOWTH_BASIC` (map ID 18, map-file ID 19). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 223 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 66 primary boundary samples through tick 191, plus reload tick 0;
- **67/67 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 37 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3706 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b02p01c.rsground`: `dd04e5f2a37629c087d709209965204b2164c40276d9aedc8a33d45bebb8a744`
- `Content/Tile/b02p01c_Base.tile`: `0cb36c93b111d3def5fb46bd355a6ac9fedda9482725d6b82fcb9de3b342bbe8`
- one registry insertion at index 150, immediately after `b02p01b`; BOM/order preserved; post SHA-256 `06cdafb983f335b8dae8a097a4b96e6674bc8606d0542bb3a9db028e5b8a46e5`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b02p01c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
