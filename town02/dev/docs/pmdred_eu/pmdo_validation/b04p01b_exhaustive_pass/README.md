# b04p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b04p01b` is canonical EU `MAP_TEAM_BASE_SKITTY_FINAL` (map ID 29, map-file ID 30). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

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

- `Data/Ground/b04p01b.rsground`: `38fed8453dd3b4e958575dc595e1a5b117e62de85100abde62f94662584899e2`
- `Content/Tile/b04p01b_Base.tile`: `917e0ffa07eced179eda7e362ca75a3f6aa53a877752b728cc86009300d5e4a1`
- one registry insertion at index 161, immediately after `b04p01a`; BOM/order preserved; post SHA-256 `42a326ce18e221cf49af3c5919cfda84713914dd930ea8f2865751ebb8c86427`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b04p01b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
