# b06p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b06p01b` is canonical EU `MAP_TEAM_BASE_TOTODILE_FINAL` (map ID 41, map-file ID 42). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

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

- `Data/Ground/b06p01b.rsground`: `fe503070fcb328563aa1275c9a617a4ab55360e2438e97073be91c189d3fda4d`
- `Content/Tile/b06p01b_Base.tile`: `0920e12315134ad5827e5e147746f2d413e79eaf112eafd90fd98910d12a1042`
- one registry insertion at index 173, immediately after `b06p01a`; BOM/order preserved; post SHA-256 `b330e078bd329b3b8ad667532ebe34c06a4b3171deadbd3bdab62df566fbbd51`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b06p01b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
