# Parité profils ↔ steps RogueElements, et conformité de l'export

Généré par `python3 tools/dungeon_builder.py verify`.

## 1. Parité `ArchitectureProfile` ↔ `re_sim` ↔ `zone_export`

| Profil | Step émis dans la zone | Classe simulée | Salles (formes/tailles/poids) | Connect % | Combine | DefaultRatio | HallTurnBias |
|---|---|---|---|---|---|---|---|
| `branching` | `RogueElements.GridPathBranch` | `GridPathBranch` | square 5-10x4-8 (w10), round 5-9x5-9 (w6), cave 6-11x5-9 (w5), cross 6-10x6-10 (w3) | 15 | 0 | [0, 10] | 60 |
| `crossroads` | `RogueElements.GridPathCross` | `GridPathCross` | square 5-10x4-8 (w10), round 5-9x5-9 (w6), cave 6-11x5-9 (w5), cross 6-10x6-10 (w3) | 30 | 20 | [0, 15] | 45 |
| `dense` | `RogueElements.GridPathBranch` | `GridPathBranch` | square 3-7x3-6 (w10), round 4-7x4-7 (w5), cave 4-8x4-7 (w4) | 45 | 10 | [15, 35] | 55 |
| `large_rooms` | `RogueElements.GridPathBranch` | `GridPathBranch` | square 8-15x7-12 (w10), round 8-13x7-12 (w6), cave 9-15x7-12 (w4) | 45 | 20 | [0, 15] | 35 |
| `lattice` | `RogueElements.GridPathGrid` | `GridPathGrid` | square 5-10x4-8 (w10), round 5-9x5-9 (w6), cave 6-11x5-9 (w5), cross 6-10x6-10 (w3) | 20 | 5 | [0, 15] | 30 |
| `looping` | `RogueElements.GridPathBranch` | `GridPathBranch` | square 5-10x4-8 (w10), round 5-9x5-9 (w6), cave 6-11x5-9 (w5), cross 6-10x6-10 (w3) | 65 | 0 | [5, 20] | 40 |
| `mixed` | `RogueElements.GridPathBranch` | `GridPathBranch` | square 5-10x4-8 (w10), round 5-9x5-9 (w6), cave 6-11x5-9 (w5), cross 6-10x6-10 (w3) | 55 | 25 | [5, 25] | 50 |
| `ring` | `RogueElements.GridPathCircle` | `GridPathCircle` | square 5-10x4-8 (w10), round 5-9x5-9 (w6), cave 6-11x5-9 (w5), cross 6-10x6-10 (w3) | 25 | 10 | [0, 15] | 45 |
| `tiered` | `RogueEssence.LevelGen.GridPathTiered` | `GridPathTiered` | square 5-10x4-8 (w10), round 5-9x5-9 (w6), cave 6-11x5-9 (w5), cross 6-10x6-10 (w3) | 20 | 15 | [5, 20] | 35 |
| `twosides` | `RogueElements.GridPathTwoSides` | `GridPathTwoSides` | square 5-10x4-8 (w10), round 5-9x5-9 (w6), cave 6-11x5-9 (w5), cross 6-10x6-10 (w3) | 25 | 15 | [0, 15] | 50 |

**Résultat : parité vérifiée** (10 profils).


## 2. Conformité des `GenSteps` exportés

- `$type` distincts émis : **63**
- inconnus des zones livrées : **0**
- champs inconnus : **0**
