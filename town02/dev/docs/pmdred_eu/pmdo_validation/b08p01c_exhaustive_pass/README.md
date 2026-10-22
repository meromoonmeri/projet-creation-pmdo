# b08p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b08p01c` is canonical EU `MAP_TEAM_BASE_INSIDE_PSYDUCK_BASIC` (map ID 54, map-file ID 55). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 175 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 50 primary boundary samples through tick 127, plus reload tick 0;
- **51/51 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 32 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3712 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b08p01c.rsground`: `3e4a53493197d74bd2968e92b94b25cbbfd86c4d8bc5c91be94ad295303d2f0b`
- `Content/Tile/b08p01c_Base.tile`: `869e3676829c05f63ea982c4655975027a5cc5e0edf43b8322ba5e281ba43d79`
- one registry insertion at index 186, immediately after `b08p01b`; BOM/order preserved; post SHA-256 `66a740d35aa3f4b0a24df47eb9e3cab87d5dc0635a5d16cca141ef74496003bd`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b08p01c/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
