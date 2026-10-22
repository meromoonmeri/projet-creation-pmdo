# b02p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b02p01b` is canonical EU `MAP_TEAM_BASE_MEOWTH_FINAL` (map ID 17, map-file ID 18). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

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

- `Data/Ground/b02p01b.rsground`: `56ff8d17e40fda1739530a95a453a3aeb21aba4f70ef6d05f4854fdecb9f2cd7`
- `Content/Tile/b02p01b_Base.tile`: `7355317e5fb617763b1f28ef578cb175ba7b9b95bdf49ce63708e3b2f7c26530`
- one registry insertion at index 149, immediately after `b02p01a`; BOM/order preserved; post SHA-256 `e402d602ce3f6dd6221b524f7b55bf3760a1723a34b1ec8ce9075d8de81e197b`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b02p01b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
