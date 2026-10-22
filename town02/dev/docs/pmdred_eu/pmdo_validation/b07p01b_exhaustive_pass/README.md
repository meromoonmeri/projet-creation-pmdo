# b07p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b07p01b` is canonical EU `MAP_TEAM_BASE_MUDKIP_FINAL` (map ID 47, map-file ID 48). The authenticated v2.0.1-eu candidate was loaded in isolation by exact PMDO 0.8.12, compared against the independent raw-EU-ROM renderer, reloaded/re-entered, promoted additively, read back, and indexed again. No existing script, route, alias, variant, or historical reserve asset was replaced. This Ground-only pass does not claim story/event integration.

## Exhaustive gates

- exact PMDO `faf9755c…`, active patched SDL `2cec7b5f…`;
- engine-requested normal unload `NORMAL_EXIT`, exact wait status `0`, TERM watchdog not sent, no SIGSEGV, forced kill, or orphan;
- 175 native events, terminal `end`, two `LOAD_PASS`/`SAFE` loads;
- 50 primary boundary samples through tick 127, plus reload tick 0;
- **51/51 full-RGBA pixel-exact and fully opaque**, zero mismatched pixels, maximum channel delta zero, 32 unique primary frames;
- 2 animation channel(s), all cell-local schedules through two complete cycles;
- 1 collision layer(s), 3767 solid cells, successful movement and blocking policy pass;
- entry, exit, same-Ground re-entry, sink/final cleanup, terminal, and orphan-process gates pass;
- post-promotion exact-PMDO indexing pass (`3df47e3b…`).

## Promotion

- `Data/Ground/b07p01b.rsground`: `391a22fbd5a609f8a9864d3bd4d22a8af75319aa9a89ec882edf949096dc543d`
- `Content/Tile/b07p01b_Base.tile`: `83f25ae821e8055af5bf31a714a07ee7dabf766f72036ed61e6d342a1e89c251`
- one registry insertion at index 179, immediately after `b07p01a`; BOM/order preserved; post SHA-256 `fd8f322ab2d78c8b9610ed1e46ba024c9a76a8e911adceb1f59000c0999af976`
- pre-promotion record: `RESERVE/pmdred_pre_promotion/b07p01b/README.md`

Complete metrics, events, engine logs, provenance, records, representative captures, commands, and integrity hashes are retained in this directory. Resume at the next canonical Ground recorded by `../RESUME.md`.
