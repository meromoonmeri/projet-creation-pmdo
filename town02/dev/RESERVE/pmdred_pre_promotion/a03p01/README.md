# `a03p01` pre-promotion record

Migration d'intégration du 2026-08-12. Le Ground actif antérieur est conservé octet pour octet sous `RESERVE/pmdred_pre_promotion/a03p01/a03p01.rsground` (`b274410f90ad2ef7f0e9c2cbdbb4e68959db2dca25b94b3452f3d67a5a5280dc`). La tuile historique en conflit est conservée sous `RESERVE/pmdred_pre_promotion/a03p01/a03p01_Base.tile` (`4b8f2b3729a32685206ee5c37bc346e53b83685da4a9bdb6964bbb4d1f4642b0`) et reste active à `Content/Tile/a03p01_Base.tile`; la tuile PMD Red candidate (`877fd56336e417ed7690db8baeeedf465657eaf37a345d2010fa356333bf8cf4`) est installée octet pour octet sous l'alias unique `a03p01_pmdred_Base`. Seules les 4320 valeurs `Sheet` du Ground intégré pointent vers cet alias. Les 1 Markers et 0 Spawners du projet sont préservés sans modification dans le Ground canonique; tout autre champ provient du candidat ROM EU authentifié. L'entrée existante de `master_zone.json` reste exactement à l'index 308; SHA-256 `182f2a76a5a572807409183936c74a9df906731e34d002c12c712516ef708359` inchangé.

- `RESERVE/red_grounds/a03p01.rsground` (`b274410f90ad2ef7f0e9c2cbdbb4e68959db2dca25b94b3452f3d67a5a5280dc`), conservé inchangé;
- `RESERVE/red_tiles/a03p01_Base.tile` (`877fd56336e417ed7690db8baeeedf465657eaf37a345d2010fa356333bf8cf4`), conservé inchangé;
- scripts, routes, variantes, aliases et autres entrées existantes conservés.

Identité ROM EU: map 169, map-file 178, place 35, `MAP_FUGITIVES_SNOW_FOREST`. Ressources: `A03P01`, `A03P01c`, `A03P01m`. Seul le Ground graphique avec ses entités d'intégration préservées est promu; événements, acteurs, musique et routing ne sont pas revendiqués.
