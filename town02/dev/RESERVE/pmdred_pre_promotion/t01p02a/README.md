# `t01p02a` pre-promotion record

The canonical lowercase destinations did **not** exist before the 2026-08-12 promotion:

- `Data/Ground/t01p02a.rsground` — absent;
- `Content/Tile/t01p02a_Base.tile` — absent;
- `Data/Zone/master_zone.json` did not list `t01p02a` (pre-promotion SHA-256 `0916663d21b09bcd6cb2ac910481efcc055b9f62999cde3d0fed87a4379f7e12`).

There were therefore no destination bytes to copy into this directory. The promotion was additive, not a replacement.

Two independent historical/project variants are deliberately retained unchanged:

| Purpose | Ground | Tile | SHA-256 |
| --- | --- | --- | --- |
| Historical PMD Red import | `RESERVE/red_grounds/t01p02a.rsground` | `RESERVE/red_tiles/t01p02a_Base.tile` | Ground `a05a273a31e4582b7077e861769c130b0f93e8f2e4dddb4e2f77052f198811d4`; tile `83161f7cf4cf40ac5e69ccb4680e87c906b6275e8bbbd4b24d3128d50bf921a7` |
| Active Explorers of Sky alias | `Data/Ground/sky_eos_t01p02a.rsground` | `Content/Tile/T01p02a_Base.tile` | Ground `39afb28922625e1505aa3a62d18140bb41380c0c4f0328277a0e6ade50a0ccfc`; tile `bc96415ece8fe8fba344159bbeec81ddee34b102a7926ea11be82d4e8338da7b` |

The EoS asset is a separate Ground with three spawners and its own `Main_Entrance_Marker`; it was not used as the PMD Red canonical baseline and was not overwritten. The old Red reserve remains historical evidence and is not promoted as canonical.

The promoted lowercase Ground and tile are byte-identical to the authenticated, exact-PMDO-tested regenerated candidate. Full evidence is under `docs/pmdred_eu/pmdo_validation/t01p02a_exhaustive_pass/`.
