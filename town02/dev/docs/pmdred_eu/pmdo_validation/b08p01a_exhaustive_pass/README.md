# b08p01a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b08p01a` is canonical EU `MAP_TEAM_BASE_PSYDUCK_CONSTRUCTION` (map ID 52, map-file ID 53). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 175 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 50 primary boundary samples through tick 127, plus reload tick 0;
- **51/51 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 32 unique primary frames;
- 3 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3715 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b08p01a.rsground`: `0ce749994cd68f14fff9ac7e64bf61af0e2752df92e37ce340d1764101162ee6`
- `Content/Tile/b08p01a_Base.tile`: `ff7f4ddc12bc5c32551f77194c9cbf262a94d295a81d9cbb6275640aed0fd94c`
- one registry insertion at index 184, immediately after `b07p02c`; BOM/order preserved; post SHA-256 `37dc793cec832f1aab11bfb6a683ed306fc8584fe567b4442ac52bf6626dd913`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b08p01a/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
