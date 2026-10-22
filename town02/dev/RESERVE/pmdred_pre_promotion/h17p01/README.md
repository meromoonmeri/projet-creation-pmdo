# `h17p01` pre-promotion record

Le Ground canonique, l'alias `Content/Tile/h17p01_pmdred_Base.tile` et l'entrée de zone étaient absents avant la promotion du 2026-08-12. La tuile historique `Content/Tile/h17p01_Base.tile` (`1868e04d61e382a54db847ba8091eae8cc9cb50031b836b0d7689cb6960fef9d`), utilisée par `Data/Ground/pre_tonnerre.rsground` (`8ff656e56418a772dbb969d658d348e5c172b935b74bcd7b0e09d2793df04d1a`), est conservée inchangée. La tuile candidate PMD Red (`16c4a5f7b6971530817ec4735b9d575afe4b798d138975caafd9c5fc84751edf`) est promue octet pour octet sous l'alias unique `h17p01_pmdred_Base`; seules les 30240 valeurs sérialisées `Sheet` de `h17p01.rsground` pointent vers cet alias. SHA-256 pré-promotion de `master_zone.json`: `a98a7f6f66de3f19377d98d4f10ecf2ccfa430ab8ed6031d08307340e1936fc4`. Promotion additive.

- `RESERVE/red_grounds/h17p01.rsground` (`a25320dab6218095f4c00e1de782b1cf9a58add99b743155cd6f1916d2b6d671`), conservé inchangé;
- `RESERVE/red_tiles/h17p01_Base.tile` (`1868e04d61e382a54db847ba8091eae8cc9cb50031b836b0d7689cb6960fef9d`), conservé inchangé;
- scripts, routes, variantes et entrées existantes conservés; `pre_tonnerre.rsground` n'est pas modifié.

Identité ROM EU: map 145, map-file 151, place 9, `MAP_FRIEND_AREA_POWER_PLANT`. Ressources: `H17P01`, `H17P01c`, `H17P01m`. Seul le Ground graphique est promu; événements, acteurs, musique et routing ne sont pas revendiqués.
