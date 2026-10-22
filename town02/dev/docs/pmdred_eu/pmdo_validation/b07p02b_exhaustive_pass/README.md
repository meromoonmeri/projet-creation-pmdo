# b07p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b07p02b` is canonical EU `MAP_TEAM_BASE_INSIDE_MUDKIP_FINAL` (map ID 50, map-file ID 51). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 1465 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 480 primary boundary samples through tick 1919, plus reload tick 0;
- **481/481 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 233 unique primary frames;
- 4 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3295 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b07p02b.rsground`: `cbb1b5b946d4ab6d386e3fc52f21b57f97c434f896097c85ff7c0786a86ced95`
- `Content/Tile/b07p02b_Base.tile`: `dea8e4f2bb697348525eee8629b920d7a7f0cee45c607704099c99761f0256a4`
- one registry insertion at index 182, immediately after `b07p02a`; BOM/order preserved; post SHA-256 `07180e1987eedd5d1af3529709e7c4fc415d40199e5aba4dffbddf3345371309`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b07p02b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
