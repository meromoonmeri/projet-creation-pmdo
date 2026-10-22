# Sinister Woods — smoke test moteur du candidat non-production

> **Statut : NON-PRODUCTION / NON-CANONIQUE.** Ce test valide la mécanique
> native nouvellement émise (ChanceFloorGen, placements, DTEF, topologie), pas
> encore le parcours canonique. La définition conserve temporairement 14 floors
> au lieu des 12 procéduraux + D04P02 fixe ; le gate interdit donc toute écriture
> dans `Data/Zone`.

## Exécution

- miroir hard-link jetable sous `/tmp`, aucune donnée canonique modifiée ;
- binaire PMDO 0.8.12 officiel, RogueElements exécuté par
  `ZoneSegmentBase.GetMap` ;
- 3 itérations des 14 floors actuels : **42 générations** ;
- résultat moteur : **42/42**, 0 exception échappée, 0 floor invalide selon les
  métriques natives.

## Topologie native

| Mesure | Min | Moyenne | Max |
|---|---:|---:|---:|
| Rooms | 7 | 15,00 | 22 |
| Halls | 6 | 17,40 | 29 |
| Branches | 1 | 5,29 | 10 |
| Culs-de-sac | 1 | 3,79 | 8 |
| Boucles | 0 | 2,45 | 7 |
| Distance BFS entrée→escalier | 16 | 42,48 | 97 |
| Cellules praticables | 311 | 1061,86 | 2096 |

- 42 signatures structurelles brutes distinctes sur 42 ;
- profils réellement choisis par la seed PMDO : branching 14, looping 10,
  large_rooms 18 ;
- 0 composante de rooms déconnectée ;
- 0 cellule praticable isolée ;
- 0 escalier inaccessible.

## Contenu placé par les steps natifs

| Mesure | Min | Moyenne | Max |
|---|---:|---:|---:|
| Objets | 6 | 7,05 | 8 |
| Pokémon | 2 | 4,55 | 8 |
| Wonder Tiles | 0 | 2,57 | 3 |

Les six floors sans Wonder Tile sont les floors globaux 13–14 encore présents
dans l'ancienne découpe mais exclus de la plage canonique 1–12. Ils disparaîtront
lors de la réconciliation du nombre de floors. Sur les 36 générations couvrant
les floors canoniques 1–12, `tile_wonder:3` est présent dans 36/36.

## Visuel / DTEF

Les 42 maps utilisent exclusivement les AutoTiles réellement chargés :

- `sinister_woods_b41_floor` ;
- `sinister_woods_b41_wall`.

Le terrain secondaire n'apparaît pas car aucune eau/lave n'est demandée par les
records PMD Red de ce candidat.

## Preuve brute

`docs/dungeon_builder/runtime/sinister_candidate_native_smoke.jsonl` contient,
pour chaque génération : seed, profil sélectionné, rooms, dimensions/formes,
halls/longueurs, graphe, branches, culs-de-sac, boucles, distance escalier,
accessibilité, items, mobs, effets et AutoTiles.
