# b04p01a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b04p01a` is canonical EU `MAP_TEAM_BASE_SKITTY_CONSTRUCTION` (map ID 28, map-file ID 29). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 97 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 24 primary boundary samples through tick 83, plus reload tick 0;
- **25/25 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 6 unique primary frames;
- 1 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3652 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b04p01a.rsground`: `26ec7bf821c6c2dd997abc97e401f293ee50c45c73e144c054ccb4134104d6e9`
- `Content/Tile/b04p01a_Base.tile`: `d6a7088978d33196fab79b0285b505b84a6de86b01914033c8d0ac502fa7d4ba`
- one registry insertion at index 160, immediately after `b03p02c`; BOM/order preserved; post SHA-256 `00fc899c91ef76631b3d1c75fb14b85b3f72ee1fd00c98374c1e44f502b65cab`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b04p01a/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
