# PMD Red EU archive-backed Ground campaign — final audit

**PASS — 219/219 canonical archive-backed Grounds validated, promoted, and archived.**

- Canonical IDs: **219 unique**, with no missing or duplicate ID.
- Runtime PASS and promoted: **219/219**; remaining: **0**; checkpoint integrity: **PASS**.
- Durable validation records: **219**; promotion records: **219**; promoted destination hash checks: **438/438 PASS**.
- Evidence integrity: **219/219 PASS** under the established historical progressive-manifest policy.
- Strict continuation from `h17p01` through `s06_spa`: **72 Grounds**, **22353** runtime RGBA samples, all exact and fully opaque. Every one terminated through `RogueEssence.GameBase.LoadPhase.Unload` with `NORMAL_EXIT`, return code 0, no watchdog signal, SIGSEGV, forced kill, or residual process.
- `h17p01`: exact candidate tile preserved as `h17p01_pmdred_Base`; 30,240 exact `Sheet` aliases; historical tile and `pre_tonnerre` preserved.
- Integration-preserving migrations retained project Markers/Spawners while keeping every non-entity visual/collision/animation value canonical; conflicting historical tiles remain preserved for the three `a03` aliases.
- The separate 27 dungeon-backed relationships remain retained and outside this archive-backed completion.

Machine-readable results and aggregate record hashes are in [`FINAL_AUDIT.json`](FINAL_AUDIT.json). The campaign stops here before any narrative port.
