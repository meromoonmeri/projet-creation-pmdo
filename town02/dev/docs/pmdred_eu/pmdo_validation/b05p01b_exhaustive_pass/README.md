# b05p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b05p01b` is canonical EU `MAP_TEAM_BASE_SQUIRTLE_FINAL` (map ID 35, map-file ID 36). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 175 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 50 primary boundary samples through tick 127, plus reload tick 0;
- **51/51 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 32 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3767 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b05p01b.rsground`: `97294d20b1e8df42e440fd1bd32c4133ac477a2a39da1fcf78c5ee296ddb36e4`
- `Content/Tile/b05p01b_Base.tile`: `12654bc24939fe1075de678bd7b382496c029c3b30caf8ec8f59042ef5338c79`
- one registry insertion at index 167, immediately after `b05p01a`; BOM/order preserved; post SHA-256 `b5757cf45f5e13399eb90931cd9f34aebe751eab1500de718d54cf13eda98707`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b05p01b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
