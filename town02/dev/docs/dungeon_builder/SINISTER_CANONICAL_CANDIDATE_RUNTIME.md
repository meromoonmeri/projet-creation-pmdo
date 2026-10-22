# Validation runtime de la génération — moteur RogueEssence

Chaque ligne vient d'un appel réel à `ZoneSegmentBase.GetMap(ZoneGenContext)`.
Les métriques topologiques proviennent du `FloorPlan` construit par RogueElements ;
aucun simulateur Python et aucun rendu pixel ne servent à certifier la géométrie.

- zones testées : **1**
- itérations : **10**
- générations tentées : **130**
- réussies : **130**
- échecs moteur : **0**
- floors construits mais invalides : **0**

## Traversabilité moteur

- étages analysés : **130**
- escaliers tous atteignables : **130**
- étages avec cellules praticables isolées : **0**

## Échecs

Aucun échec remonté par l'appel moteur.

## Par donjon

| Donjon | Floors | Rooms min/moy/max | Halls min/moy/max | Branches | Culs-de-sac | Boucles | Dist. entrée→escalier | ms moy |
|---|---:|---|---|---|---|---|---|---:|
| `gloomy_forest` | 130 | 4/10.4/18 | 5/13.9/25 | 1/2.9/8 | 0/3.0/8 | 0/1.2/5 | 15/38.1/88 | 14.5 |

Ligne terminale : `{"event": "end", "attempted": 130, "generated": 130, "failures": 0, "non_traversable": 0, "invalid": 0}`
