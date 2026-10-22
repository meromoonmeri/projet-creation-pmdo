# Validation runtime de la génération — moteur RogueEssence

Chaque ligne vient d'un appel réel à `ZoneSegmentBase.GetMap(ZoneGenContext)`.
Les métriques topologiques proviennent du `FloorPlan` construit par RogueElements ;
aucun simulateur Python et aucun rendu pixel ne servent à certifier la géométrie.

- zones testées : **1**
- itérations : **16**
- générations tentées : **48**
- réussies : **48**
- échecs moteur : **0**
- floors construits mais invalides : **0**

## Traversabilité moteur

- étages analysés : **48**
- escaliers tous atteignables : **48**
- étages avec cellules praticables isolées : **0**

## Échecs

Aucun échec remonté par l'appel moteur.

## Par donjon

| Donjon | Floors | Rooms min/moy/max | Halls min/moy/max | Branches | Culs-de-sac | Boucles | Dist. entrée→escalier | ms moy |
|---|---:|---|---|---|---|---|---|---:|
| `__dungeon_builder_prototype` | 48 | 8/14.2/23 | 7/17.1/31 | 1/5.2/13 | 1/3.2/6 | 0/2.8/9 | 19/39.3/84 | 18.0 |

## Prototype isolé — sélection topologique

Seuil de similarité : **0.92**. Requis : **10 variantes acceptées par profil**.
Une signature de graphe ignore l'ordre de création et les coordonnées absolues :
un même graphe de salles n'est donc pas compté comme nouveau parce que quelques tuiles bougent.

| Profil | Tentatives | Acceptées | Rejetées | Rooms | Halls | Branches | Culs-de-sac | Boucles | Signatures |
|---|---:|---:|---:|---|---|---|---|---|---:|
| `branching` | 16 | 16 | 0 | 8/9.2/11 | 7/8.8/12 | 1/2.2/4 | 2/3.5/5 | 0/0.6/2 | 16 |
| `large_rooms` | 16 | 16 | 0 | 10/13.9/17 | 13/16.6/20 | 2/4.9/7 | 1/3.1/5 | 1/2.8/5 | 16 |
| `looping` | 16 | 16 | 0 | 18/19.6/23 | 23/25.9/31 | 6/8.5/13 | 1/2.9/6 | 2/4.9/9 | 16 |

**Verdict prototype : PASS**

Ligne terminale : `{"event": "end", "attempted": 48, "generated": 48, "failures": 0, "non_traversable": 0, "invalid": 0}`
