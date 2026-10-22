# b05p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b05p02b` is canonical EU `MAP_TEAM_BASE_INSIDE_SQUIRTLE_FINAL` (map ID 38, map-file ID 39). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 1465 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 480 primary boundary samples through tick 1919, plus reload tick 0;
- **481/481 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 233 unique primary frames;
- 4 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3295 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b05p02b.rsground`: `1b0a8c19401817acc0bea9024e94ee92b5fd0df375393af0fc1ca1880e3e3ae7`
- `Content/Tile/b05p02b_Base.tile`: `dea8e4f2bb697348525eee8629b920d7a7f0cee45c607704099c99761f0256a4`
- one registry insertion at index 170, immediately after `b05p02a`; BOM/order preserved; post SHA-256 `0b693e2a99c047e95faf73128aa130b793f51a5ea30c790497f3322d2a37139d`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b05p02b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
