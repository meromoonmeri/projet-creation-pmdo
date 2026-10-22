# `t01p03` pre-promotion record

The canonical lowercase destinations did **not** exist before the 2026-08-12 promotion:

- `Data/Ground/t01p03.rsground` — absent;
- `Content/Tile/t01p03_Base.tile` — absent;
- `Data/Zone/master_zone.json` did not list `t01p03` (pre-promotion SHA-256 `e1c4e4c1647e1ecea7841588b23913af038898bf51554216585b590241007e6a`).

There were therefore no destination bytes to copy into this directory. The promotion was additive, not a replacement.

The following independent historical/project assets are deliberately retained unchanged:

| Purpose | Ground | Tile | SHA-256 |
| --- | --- | --- | --- |
| Historical PMD Red import | `RESERVE/red_grounds/t01p03.rsground` | `RESERVE/red_tiles/t01p03_Base.tile` | Ground `006135f66045ccb1a36ac3855c78db4dc1cb666871b16204d7aea7d0fe30be48`; tile `e9cc3757a07f1d618961ed491a56362c5da09150801345c0445cd876ce260195` |
| Existing project Post Office implementation | `Data/Ground/post_office.rsground` | `Content/Tile/PostOffice.tile` | Ground `66aefb5ebefa768a8bd903121ed301158f59c0ee65bd031936c1368165537ff4`; tile `11a0ac7c85a210d33add380f65c1e2e9fdcde6c60f6d0f7723f43388dafa9814` |
| Active Explorers of Sky urban variant | `Data/Ground/sky_eos_t01p03a.rsground` | `Content/Tile/T01p03a_Base.tile` | Ground `ae15f5c34443a882a1a028a86a67e3e33cb81e2931f0c1e33c56f6d8d512b710`; tile `2857ff3a7fd607e5efb593ab883e436bf32b97e3773064b8d97c6edbe125523b` |

## Identity erratum

The old reserve Ground comment and the 2026-08-07 historical animation audit label `t01p03` as `MAP_FILE_ID_PELIPPER_POST_OFFICE`. That label is one enum slot early and is **not** propagated into the canonical promotion.

Fresh authenticated European-ROM extraction gives `t01p03` canonical debug ID 4, map ID/file ID 5, and Ground place ID 4. In the pinned `pret/pmd-red` `GroundMapID` enum, index 5 is `MAP_PELIPPER_POST_OFFICE_INSIDE`; the exterior symbol is index 4 and belongs to the preceding authenticated `t01p02b` record. The retained reserve comment is historical metadata, not identity authority.

The old Red reserve also contains an unproven `Main_Entrance_Marker`; the regenerated canonical candidate contains no entities. The marker was used only on an isolated fixture copy for runtime entry and was not imported into the promoted Ground. The existing `post_office` Ground, its `PostOffice` tile, French gameplay script, entities, music, and route remain separate and untouched. The EoS `sky_eos_t01p03a` variant and its script remain separately registered and unchanged.

A dormant `Data/Script/halcyon/arc_fugitif/scene/t01p03.lua` file also exists, but it has no `FugitiveArc`/`FugitiveCinematics` registration and no lowercase Ground init. Promotion does not route or claim that deferred scene.

The promoted lowercase Ground and tile are byte-identical to the authenticated, exact-PMDO-tested regenerated candidate. Full evidence is under `docs/pmdred_eu/pmdo_validation/t01p03_exhaustive_pass/`.
