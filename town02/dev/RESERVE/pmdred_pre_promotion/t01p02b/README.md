# `t01p02b` pre-promotion record

The canonical lowercase destinations did **not** exist before the 2026-08-12 promotion:

- `Data/Ground/t01p02b.rsground` — absent;
- `Content/Tile/t01p02b_Base.tile` — absent;
- `Data/Zone/master_zone.json` did not list `t01p02b` (pre-promotion SHA-256 `e699a00529d631701e7e964ea291cb24420fb32c51b0574d941c1c581230afe1`).

There were therefore no destination bytes to copy into this directory. The promotion was additive, not a replacement.

The following independent historical/project assets are deliberately retained unchanged:

| Purpose | Ground | Tile | SHA-256 |
| --- | --- | --- | --- |
| Historical PMD Red import | `RESERVE/red_grounds/t01p02b.rsground` | `RESERVE/red_tiles/t01p02b_Base.tile` | Ground `896f4bc4d1a5c821275a9cf611494e263002185ecdd8808810227fa79822383f`; tile `ed0ff744feb5ddba0f7d38e54b6a63352f84825e5cd96caaaa1c649ca49fdc11` |
| Existing project Post Office implementation | `Data/Ground/post_office.rsground` | `Content/Tile/PostOffice.tile` | Ground `66aefb5ebefa768a8bd903121ed301158f59c0ee65bd031936c1368165537ff4`; tile `11a0ac7c85a210d33add380f65c1e2e9fdcde6c60f6d0f7723f43388dafa9814` |

## Identity erratum

The old reserve Ground comment and the 2026-08-07 historical animation audit label `t01p02b` as `MAP_FILE_ID_WHISCASH_POND_OPEN`. That label is stale and is **not** propagated into the canonical promotion.

Fresh authenticated European-ROM extraction gives `t01p02b` canonical debug ID 3, map ID/file ID 4, and Ground place ID 3. In the pinned `pret/pmd-red` `GroundMapID` enum, index 4 is `MAP_PELIPPER_POST_OFFICE`; `MAP_WHISCASH_POND_OPEN` is index 3 and belongs to the preceding `t01p02a` extraction record. The retained reserve comment is historical metadata, not identity authority.

The old Red reserve also contains an unproven `Main_Entrance_Marker`; the regenerated canonical candidate contains no entities. The marker was used only on an isolated fixture copy for runtime entry and was not imported into the promoted Ground. The existing `post_office` Ground, its `PostOffice` tile, French gameplay script, entities, music, and route remain separate and untouched.

The promoted lowercase Ground and tile are byte-identical to the authenticated, exact-PMDO-tested regenerated candidate. Full evidence is under `docs/pmdred_eu/pmdo_validation/t01p02b_exhaustive_pass/`.
