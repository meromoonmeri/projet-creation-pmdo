# b02p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b02p02b` is canonical EU `MAP_TEAM_BASE_INSIDE_MEOWTH_FINAL` (map ID 20, map-file ID 21). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 28 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 1 primary boundary samples through tick 0, plus reload tick 0;
- **2/2 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 1 unique primary frames;
- 0 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3178 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b02p02b.rsground`: `28d28128dcc98ee7b3930e21020a74922e5be4fb9c1bd11fbe2553c8fe32ba25`
- `Content/Tile/b02p02b_Base.tile`: `ec8f5ab4cfea9b73de418a74b4c104b3eb564386ad556a9e391e0e4f70aa6cbe`
- one registry insertion at index 152, immediately after `b02p02a`; BOM/order preserved; post SHA-256 `d5f3086e90480dcfc9b5aa487e6533d95d610d6376a2b6820ebdfc69c037e84f`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b02p02b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
