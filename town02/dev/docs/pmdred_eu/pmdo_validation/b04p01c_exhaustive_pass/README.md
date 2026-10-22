# b04p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b04p01c` is canonical EU `MAP_TEAM_BASE_INSIDE_SKITTY_BASIC` (map ID 30, map-file ID 31). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- 223 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 66 primary boundary samples through tick 191, plus reload tick 0;
- **67/67 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 37 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3706 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b04p01c.rsground`: `301106a61d582b0406ca1117a11f5252c87ac78cc737797696156fad886c1aab`
- `Content/Tile/b04p01c_Base.tile`: `ab0fecd3745354fa2cef6cc3ac009023617549e62b7215be77599b554c121c25`
- one registry insertion at index 162, immediately after `b04p01b`; BOM/order preserved; post SHA-256 `dfb89cb66b06d44fbb5f77931eb56949072387e646b507ea97fabd9e0e9b987c`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b04p01c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
