# Exclusivité du périmètre Ch.6-32

Question vérifiée : *les 51 zones du Builder sont-elles les seules implémentations actives, et une ancienne zone / un ancien générateur / un ancien script peut-il reprendre la main ?*

| Mesure | Valeur |
|---|---|
| definitions | 51 |
| zones | 89 |
| perimeter_zones | 51 |
| out_of_scope_zones | 38 |
| broken_references | 11 |
| unguarded_legacy_writers | 0 |
| errors | 0 |
| blocked | 11 |

**Erreurs : 0 — points bloqués (décision narrative requise) : 11**

## Bloqué — décision narrative requise (11)

| Contrôle | Sujet | Détail |
|---|---|---|
| `dungeon_references` | `Data/Script/halcyon/DazzlingPlaza.lua` | ContinueDungeon('gloomy_forest', 7) : le donjon reconstruit n'a que 3 segment(s) |
| `dungeon_references` | `Data/Script/halcyon/TownRaid.lua` | ContinueDungeon('gloomy_forest', 7) : le donjon reconstruit n'a que 3 segment(s) |
| `dungeon_references` | `Data/Script/halcyon/ground/palier_celeste/init.lua` | ContinueDungeon('sky_tower', 2) : le donjon reconstruit n'a que 1 segment(s) |
| `dungeon_references` | `Data/Script/halcyon/ground/palier_celeste/init.lua` | ContinueDungeon('sky_tower', 2) : le donjon reconstruit n'a que 1 segment(s) |
| `dungeon_references` | `Data/Script/halcyon/ground/palier_celeste/init.lua` | ContinueDungeon('sky_tower', 2) : le donjon reconstruit n'a que 1 segment(s) |
| `dungeon_references` | `Data/Script/halcyon/ground/poisonous_forest_entrance/init.lua` | EnterDungeon('poisonous_forest') : zone inexistante |
| `dungeon_references` | `Data/Script/halcyon/ground/poisonous_forest_miniboss/forgotten_marsh_miniboss_ch_9.lua` | ContinueDungeon('poisonous_forest') : zone inexistante |
| `dungeon_references` | `Data/Script/halcyon/ground/poisonous_forest_miniboss/forgotten_marsh_miniboss_ch_9.lua` | ContinueDungeon('poisonous_forest') : zone inexistante |
| `dungeon_references` | `Data/Script/halcyon/ground/poisonous_forest_miniboss/forgotten_marsh_miniboss_ch_9.lua` | ContinueDungeon('poisonous_forest') : zone inexistante |
| `dungeon_references` | `Data/Script/halcyon/ground/poisonous_forest_relay/init.lua` | EnterDungeon('poisonous_forest') : zone inexistante |
| `dungeon_references` | `Data/Script/halcyon/ground/tour_ciel_sommet/init.lua` | ContinueDungeon('sky_tower', 5) : le donjon reconstruit n'a que 1 segment(s) |

## Ce que ce rapport ne prétend pas

- Il ne remplace pas l'exécution du moteur : la conformité statique n'est pas une validation runtime.
- Il ne touche pas aux zones hors périmètre : elles restent la responsabilité de leurs auteurs.
