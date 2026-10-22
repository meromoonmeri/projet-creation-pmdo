# b04p02a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b04p02a` is canonical EU `MAP_TEAM_BASE_INSIDE_SKITTY_CONSTRUCTION` (map ID 31, map-file ID 32). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 28 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 1 primary boundary samples through tick 0, plus reload tick 0;
- **2/2 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 1 unique primary frames;
- 0 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3173 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b04p02a.rsground`: `5e216732747bfb0ec89a2ac463529b8232bc662b35c8b004ce16dd07766fceb1`
- `Content/Tile/b04p02a_Base.tile`: `7f260e40b2e42f19f5197bac1468fdf2a9eb39aee38e50470723a1391f913e94`
- one registry insertion at index 163, immediately after `b04p01c`; BOM/order preserved; post SHA-256 `f5dc523d13aa832bdaeafb37dc6ebd8ce2dd3295c49f553e9bfbc602d37f3227`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b04p02a/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
