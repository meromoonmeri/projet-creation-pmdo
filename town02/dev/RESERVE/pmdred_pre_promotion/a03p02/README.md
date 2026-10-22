# `a03p02` pre-promotion record

Migration d'intégration du 2026-08-12. Le Ground actif antérieur est conservé octet pour octet sous `RESERVE/pmdred_pre_promotion/a03p02/a03p02.rsground` (`ca7278d2c16e3843a089ab20904b7c3b5d85542d24987573604ffe12e83c9ff3`). La tuile historique en conflit est conservée sous `RESERVE/pmdred_pre_promotion/a03p02/a03p02_Base.tile` (`5d492bd32d1c0fbebce449bf85624865d333eb5743b0acb5adacf5ce7fb9cf2a`) et reste active à `Content/Tile/a03p02_Base.tile`; la tuile PMD Red candidate (`076d64fb6b4f86ef10fc0861a1b2cf4e01f4d88a434b220c886575c6fe30898c`) est installée octet pour octet sous l'alias unique `a03p02_pmdred_Base`. Seules les 1386 valeurs `Sheet` du Ground intégré pointent vers cet alias. Les 1 Markers et 0 Spawners du projet sont préservés sans modification dans le Ground canonique; tout autre champ provient du candidat ROM EU authentifié. L'entrée existante de `master_zone.json` reste exactement à l'index 309; SHA-256 `182f2a76a5a572807409183936c74a9df906731e34d002c12c712516ef708359` inchangé.

- `RESERVE/red_grounds/a03p02.rsground` (`62afb6275c527e997ec5225505328559f14a9671fd07a684b8b7b6de1d1bc749`), conservé inchangé;
- `RESERVE/red_tiles/a03p02_Base.tile` (`076d64fb6b4f86ef10fc0861a1b2cf4e01f4d88a434b220c886575c6fe30898c`), conservé inchangé;
- scripts, routes, variantes, aliases et autres entrées existantes conservés.

Identité ROM EU: map 170, map-file 179, place 35, `MAP_FUGITIVES_BLIZZARD_ROAD`. Ressources: `A03P02`, `D10P01c`, `D10P01m`. Seul le Ground graphique avec ses entités d'intégration préservées est promu; événements, acteurs, musique et routing ne sont pas revendiqués.
