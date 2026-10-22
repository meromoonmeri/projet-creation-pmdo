# b05p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b05p01c` is canonical EU `MAP_TEAM_BASE_INSIDE_SQUIRTLE_BASIC` (map ID 36, map-file ID 37). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 175 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 50 primary boundary samples through tick 127, plus reload tick 0;
- **51/51 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 32 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3711 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b05p01c.rsground`: `88018d6116f0332b16f577d217167b448cb3d5420d984a04ae4e19b345094327`
- `Content/Tile/b05p01c_Base.tile`: `3466ff6dbae5bcfce5dca4bed313265859834ada5f402aaebab6cae8967264ad`
- one registry insertion at index 168, immediately after `b05p01b`; BOM/order preserved; post SHA-256 `63b98211b80cc815148f163b2dc5afc6d293f73a980985a53f99905303e2fcd8`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b05p01c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
