# `a03p03` pre-promotion record

Migration d'intégration du 2026-08-12. Le Ground actif antérieur est conservé octet pour octet sous `RESERVE/pmdred_pre_promotion/a03p03/a03p03.rsground` (`056e711e49f8f9ae7b5067458d66ba2c758e42ca3b96fb60e0e58946c9bb52ae`). La tuile historique en conflit est conservée sous `RESERVE/pmdred_pre_promotion/a03p03/a03p03_Base.tile` (`314207f03b49c0908a801ee10ee0cbcb29c700d8500539444625e56da05489f9`) et reste active à `Content/Tile/a03p03_Base.tile`; la tuile PMD Red candidate (`fa9b2e916bf28714e4614964f7589d6ef83e81754ee358c147c09c975a7a5281`) est installée octet pour octet sous l'alias unique `a03p03_pmdred_Base`. Seules les 4320 valeurs `Sheet` du Ground intégré pointent vers cet alias. Les 1 Markers et 0 Spawners du projet sont préservés sans modification dans le Ground canonique; tout autre champ provient du candidat ROM EU authentifié. L'entrée existante de `master_zone.json` reste exactement à l'index 310; SHA-256 `182f2a76a5a572807409183936c74a9df906731e34d002c12c712516ef708359` inchangé.

- `RESERVE/red_grounds/a03p03.rsground` (`056e711e49f8f9ae7b5067458d66ba2c758e42ca3b96fb60e0e58946c9bb52ae`), conservé inchangé;
- `RESERVE/red_tiles/a03p03_Base.tile` (`fa9b2e916bf28714e4614964f7589d6ef83e81754ee358c147c09c975a7a5281`), conservé inchangé;
- scripts, routes, variantes, aliases et autres entrées existantes conservés.

Identité ROM EU: map 171, map-file 180, place 35, `MAP_SUMMIT_SUNSET`. Ressources: `A03P03`, `A03P03c`, `A03P03m`. Seul le Ground graphique avec ses entités d'intégration préservées est promu; événements, acteurs, musique et routing ne sont pas revendiqués.
