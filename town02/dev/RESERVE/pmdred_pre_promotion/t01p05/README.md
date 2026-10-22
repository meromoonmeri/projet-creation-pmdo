# `t01p05` pre-promotion record

The lowercase canonical Ground, tile, and zone entry were absent before the 2026-08-12 promotion. Pre-promotion `master_zone.json` SHA-256: `af9267c42bd2ada57dc5324d28fdc592dc7cba6fc3e5f883bfcf1778c53fe5f2`. Promotion was additive.

Retained unchanged:

- historical Ground `RESERVE/red_grounds/t01p05.rsground` (`c3ddb58426d42816878e5d20dcdef4c5244279ad9c36959bb8914fbd68364543`) and tile `RESERVE/red_tiles/t01p05_Base.tile` (`84f5ad7da2f15dfdd32827627996206834ec85550ed7e36403c13a66eaa9019d`);
- active French project dojo `Data/Ground/dojo_ossatueur.rsground` (`33a70829e41a36b9525b72f1bfcbd37c668591af69b00828707b5dece4d58947`), its tile and script;
- dormant `Data/Script/halcyon/arc_fugitif/scene/t01p05.lua` (`1cba252c452a4f75a5caef5b8754585c7f78c96b7a4fa36393e33e7f76a50372`).

## Identity erratum

The reserve comment and old audit call `t01p05` `MAP_FILE_ID_MAKUHITA_DOJO`. Authenticated EU extraction gives map/file ID 7; pinned enum index 7 is `MAP_MAKUHITA_DOJO_INSIDE`. Exterior ID 6 is authenticated `t01p04`. Canonical records correct this one-slot stale label without modifying reserve bytes.

The reserve entrance marker was not promoted because the canonical candidate has no entities. A marker existed only on the isolated test copy. The project dojo and dormant, unrouted three-dialogue-line Fugitive scene were not modified or claimed validated.

Promoted bytes exactly equal the authenticated exact-PMDO-tested candidate. Evidence: `docs/pmdred_eu/pmdo_validation/t01p05_exhaustive_pass/`.
