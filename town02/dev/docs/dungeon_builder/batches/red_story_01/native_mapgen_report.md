# Validation runtime de la génération — moteur RogueEssence

Chaque ligne vient d'un appel réel à `ZoneSegmentBase.GetMap(ZoneGenContext)`.
Les métriques topologiques proviennent du `FloorPlan` construit par RogueElements ;
aucun simulateur Python et aucun rendu pixel ne servent à certifier la géométrie.

- zones testées : **2**
- itérations : **10**
- générations tentées : **80**
- réussies : **80**
- échecs moteur : **0**
- floors construits mais invalides : **0**

## Traversabilité moteur

- étages analysés : **80**
- escaliers tous atteignables : **80**
- étages avec cellules praticables isolées : **0**

## Échecs

Aucun échec remonté par l'appel moteur.

## Par donjon

| Donjon | Floors | Rooms min/moy/max | Halls min/moy/max | Branches | Culs-de-sac | Boucles | Dist. entrée→escalier | ms moy |
|---|---:|---|---|---|---|---|---|---:|
| `thunderwave_cave` | 50 | 6/9.9/16 | 6/14.6/30 | 1/2.5/6 | 0/3.0/8 | 0/0.9/5 | 17/46.4/88 | 12.6 |
| `tiny_woods` | 30 | 5/7.1/8 | 10/13.5/17 | 1/2.4/5 | 0/0.8/3 | 1/2.3/6 | 14/36.6/65 | 20.2 |

Ligne terminale : `{"event": "end", "attempted": 80, "generated": 80, "failures": 0, "non_traversable": 0, "invalid": 0}`
