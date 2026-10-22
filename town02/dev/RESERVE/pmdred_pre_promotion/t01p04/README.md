# `t01p04` pre-promotion record

The canonical lowercase destinations did **not** exist before the 2026-08-12 promotion:

- `Data/Ground/t01p04.rsground` — absent;
- `Content/Tile/t01p04_Base.tile` — absent;
- `Data/Zone/master_zone.json` did not list `t01p04` (pre-promotion SHA-256 `e7b2adbfc57cede69c3a727d9f53efa0dcb775b76138e33fe2f2934e54d2a5b3`).

There were therefore no destination bytes to copy into this directory. The promotion was additive, not a replacement.

| Retained purpose | Ground | Tile | SHA-256 |
| --- | --- | --- | --- |
| Historical PMD Red import | `RESERVE/red_grounds/t01p04.rsground` | `RESERVE/red_tiles/t01p04_Base.tile` | Ground `c2453bd295ed18dc4311d8716f52e32c1b6d24443fadc02fa47a6a158ed96b85`; tile `2565ce1c27e242fb80ef4fc7243e238b026acd353a261a460f65cd4406fea504` |
| Active Explorers of Sky variant | `Data/Ground/sky_eos_t01p04a.rsground` | `Content/Tile/T01p04a_Base.tile` | Ground `3ec253e892b96679965fa94415cd2b3e548a77353a80f2bed672dc7b0e663615`; tile `459040d2ad04625c399c48284d401e0df4ecf3a198051f4e80271780f41e4c5b` |
| Existing project dojo | `Data/Ground/dojo_ossatueur.rsground` | `Content/Tile/T01P03A_layer1.tile` | Ground `33a70829e41a36b9525b72f1bfcbd37c668591af69b00828707b5dece4d58947`; tile `8741387be82be686b462682dc06e087c1b66946ad63598bc76f1271efc9f4330` |

## Identity erratum

The old reserve comment and 2026-08-07 historical animation audit label `t01p04` as `MAP_FILE_ID_PELIPPER_POST_OFFICE_INSIDE`. Fresh authenticated European-ROM extraction gives canonical debug ID 5, map ID/file ID 6, and Ground place ID 5. Pinned `pret/pmd-red` enum index 6 is `MAP_MAKUHITA_DOJO`; the Post Office interior is index 5 and belongs to authenticated `t01p03`. The stale label is not propagated, while reserve bytes remain untouched.

The reserve Ground's unproven `Main_Entrance_Marker` was not imported; the canonical candidate has no entities. A fixture-only marker enabled runtime entry. The active EoS variant, project dojo, their scripts/routes/entities, and dormant `arc_fugitif/scene/t01p04.lua` remain unchanged and are not claimed validated by this Ground-only pass.

The promoted files are byte-identical to the authenticated exact-PMDO-tested candidate. Full evidence is under `docs/pmdred_eu/pmdo_validation/t01p04_exhaustive_pass/`.
