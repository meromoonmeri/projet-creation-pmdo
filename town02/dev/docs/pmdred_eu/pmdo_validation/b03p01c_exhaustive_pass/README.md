# b03p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b03p01c` is canonical EU `MAP_TEAM_BASE_INSIDE_EEVEE_BASIC` (map ID 24, map-file ID 25). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 223 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 66 primary boundary samples through tick 191, plus reload tick 0;
- **67/67 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 37 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3691 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b03p01c.rsground`: `b478905d1321cdc3f01c49c04dc99cb6f79f26c3518a874ea6be6103395a9426`
- `Content/Tile/b03p01c_Base.tile`: `1441dd9d579b9778c2d98e8e43e20272537399152d66db1fc0ad38bdb90f0e56`
- one registry insertion at index 156, immediately after `b03p01b`; BOM/order preserved; post SHA-256 `3a8123aa897618dcfce41053594d179954d36f1d1859fddc0ac811143a8e102b`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b03p01c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
