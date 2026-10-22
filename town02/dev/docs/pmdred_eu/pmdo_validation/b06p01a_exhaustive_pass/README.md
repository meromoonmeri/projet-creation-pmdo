# b06p01a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b06p01a` is canonical EU `MAP_TEAM_BASE_TOTODILE_CONSTRUCTION` (map ID 40, map-file ID 41). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 175 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 50 primary boundary samples through tick 127, plus reload tick 0;
- **51/51 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 32 unique primary frames;
- 3 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3715 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b06p01a.rsground`: `34dafd0f7abc393d2f38df7087b8d94264705d04d5c2cba2e28858c6177cfadd`
- `Content/Tile/b06p01a_Base.tile`: `ff7f4ddc12bc5c32551f77194c9cbf262a94d295a81d9cbb6275640aed0fd94c`
- one registry insertion at index 172, immediately after `b05p02c`; BOM/order preserved; post SHA-256 `675eea9c9e433a9227975f92bfccc8922fe67b978320e521d9487c96a697491b`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b06p01a/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
