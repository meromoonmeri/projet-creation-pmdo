# b04p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b04p02b` is canonical EU `MAP_TEAM_BASE_INSIDE_SKITTY_FINAL` (map ID 32, map-file ID 33). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

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

- `Data/Ground/b04p02b.rsground`: `c95e20ff4b94a82401487be63afd05f64193e9c6f3c2250610f99d569cef0e54`
- `Content/Tile/b04p02b_Base.tile`: `ec8f5ab4cfea9b73de418a74b4c104b3eb564386ad556a9e391e0e4f70aa6cbe`
- one registry insertion at index 164, immediately after `b04p02a`; BOM/order preserved; post SHA-256 `2ea3c748286efe8aea235849ebc54327c3be77048674ec9ded768dfaba36d40a`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b04p02b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
