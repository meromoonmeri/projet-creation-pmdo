# b01p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b01p02b` is canonical EU `MAP_TEAM_BASE_INSIDE_PIKACHU_FINAL` (map ID 14, map-file ID 15). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

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

- `Data/Ground/b01p02b.rsground`: `7d9c238334e06763df5468c85ed67568e7a41104d5f74a3d42fb96d0c176dc6e`
- `Content/Tile/b01p02b_Base.tile`: `ec8f5ab4cfea9b73de418a74b4c104b3eb564386ad556a9e391e0e4f70aa6cbe`
- one registry insertion at index 146, immediately after `b01p02a`; BOM/order preserved; post SHA-256 `3c086654ff04243a797ad50e92f9685e3737782d93c93e8b64db93665212869c`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b01p02b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
