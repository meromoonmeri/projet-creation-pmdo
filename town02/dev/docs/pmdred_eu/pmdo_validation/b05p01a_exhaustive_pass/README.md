# b05p01a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b05p01a` is canonical EU `MAP_TEAM_BASE_SQUIRTLE_CONSTRUCTION` (map ID 34, map-file ID 35). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

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

- `Data/Ground/b05p01a.rsground`: `f617340ce51405200b35b2159d75e419f91399aec1eaca0b7d2882c156535857`
- `Content/Tile/b05p01a_Base.tile`: `ff7f4ddc12bc5c32551f77194c9cbf262a94d295a81d9cbb6275640aed0fd94c`
- one registry insertion at index 166, immediately after `b04p02c`; BOM/order preserved; post SHA-256 `da759c3960ad54ada646c132e70cfbd7953a7d05439a14660b0f4ba1ddda7682`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b05p01a/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
