# b01p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b01p01c` is canonical EU `MAP_TEAM_BASE_INSIDE_PIKACHU_BASIC` (map ID 12, map-file ID 13). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 223 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 66 primary boundary samples through tick 191, plus reload tick 0;
- **67/67 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 37 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3701 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b01p01c.rsground`: `25ed1c8ec607c839f05e7d4702164ed44f5abef32ec0c2b094ee7c61812e0a9f`
- `Content/Tile/b01p01c_Base.tile`: `7b998782764c4c2f48eb2db9ab391ab63cb5dd5ffcaab38599ced5ea7f19a1c2`
- one registry insertion at index 144, immediately after `b01p01b`; BOM/order preserved; post SHA-256 `882fabd41bb7ebe348e4ce729ac9c9da169ee973f81a4b01b5702aa5c5d74345`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b01p01c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
