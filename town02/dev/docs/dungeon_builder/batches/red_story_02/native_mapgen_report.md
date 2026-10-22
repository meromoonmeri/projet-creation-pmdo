# Validation runtime PMDO 0.8.12 — Silent Chasm + Great Canyon

Chaque ligne vient d'un appel réel `ZoneSegmentBase.GetMap(ZoneGenContext)`
dans PMDO 0.8.12 avec SwiftShader + SDL2 patché (offscreen).
Aucun simulateur, aucune preuve inventée.

- zones testées : **2**
- itérations : **10**
- générations tentées : **210**
- réussies : **210**
- échecs moteur : **0**
- floors invalides : **0**
- floors non-traversables : **0**

## Par donjon

| Donjon | Floors | Rooms min/med/max | Halls min/med/max | Loops min/med/max | Branches | Dead-ends |
|---|---:|---|---|---|---|---|
| `silent_chasm` | 90 | 10/13/18 | 24/34/51 | 1/5/57 | 1/5/12 | 0/1/5 |
| `great_canyon` | 120 | 4/12/18 | 7/33/63 | 1/4/58 | 1/5/12 | 0/1/5 |

## Preuve d'aléatoirité

- seeds distinctes: 210 uniques sur 210 générations (aucune répétition)
- profils utilisés: silent_ring, silent_lattice, canyon_ring, canyon_lattice
