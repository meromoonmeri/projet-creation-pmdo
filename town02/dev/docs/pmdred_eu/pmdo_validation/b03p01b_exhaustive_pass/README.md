# b03p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b03p01b` is canonical EU `MAP_TEAM_BASE_EEVEE_FINAL` (map ID 23, map-file ID 24). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 97 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 24 primary boundary samples through tick 83, plus reload tick 0;
- **25/25 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 6 unique primary frames;
- 1 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3767 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b03p01b.rsground`: `6ce5f31699cb3d5946898116c5deca1ecf8851a79ae91b07d9a84fa7cf28c8e6`
- `Content/Tile/b03p01b_Base.tile`: `5f99e441ae5d88ad97797422ca4dc19635017b590b2bef18c75586bb55b902ff`
- one registry insertion at index 155, immediately after `b03p01a`; BOM/order preserved; post SHA-256 `a0b3840f87c56b2fdf927e387f19274829553d3548c88419a8993c7609c1afee`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b03p01b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
