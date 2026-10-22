# b03p02c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b03p02c` is canonical EU `MAP_TEAM_BASE_SKITTY_BASIC` (map ID 27, map-file ID 28). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

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

- `Data/Ground/b03p02c.rsground`: `a386e03bbbac02882c2a1fa109cb5b62cff896eddd68e3c3cc04c0e67e3c551a`
- `Content/Tile/b03p02c_Base.tile`: `ad1ffe29272457999ae976b16b5d447183fbf83b4d09bb4f508e1d097f37f142`
- one registry insertion at index 159, immediately after `b03p02b`; BOM/order preserved; post SHA-256 `b017904539c1f707c73fa0cbaac77d24badd41a8b2a128055a429cdb31f006b6`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b03p02c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
