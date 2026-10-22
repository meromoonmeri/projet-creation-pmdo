# Audit exhaustif de géométrie procédurale — Floors, salles et couloirs

Date : 2026-08-07  
Périmètre : `Data/Zone/*.json`, RogueElements/RogueEssence, 36 zones procédurales et 424 patrons de plancher.

## Méthode

L’audit ignore volontairement : tilesets, musique, espèces, objets, météo cosmétique et dialogues. Il compare uniquement la structure qui détermine la forme des étages :

- `InitGridPlanStep` : dimensions des cellules et de la grille ;
- `GridPathBranch`, `GridPathGrid`, `GridPathCircle` : graphe des salles ;
- ratios de salles, halls et branches ;
- `RoomGen*` : forme et dimensions des salles ;
- `RoomGenAngledHall` et autres halls : largeur, hauteur, biais de virage ;
- `ConnectGridBranchStep` : connexions supplémentaires ;
- `DrawGridToFloorStep` ;
- stencils, blobs, Perlin, eau et suppression des îlots ;
- paramètres numériques des générateurs.

Deux niveaux sont produits :

1. **copie exacte** : même séquence de GenSteps et mêmes paramètres ;
2. **similarité de signature** : proportion de briques structurelles identiques.

Outil reproductible :

```bash
python3 tools/audit_geometry_uniqueness.py
```

## Verdict général

**NON CONFORME.** Plusieurs donjons utilisent exactement la structure d’un autre donjon. Changer le tileset, les Pokémon ou la musique ne change pas ce verdict : les salles et couloirs restent les mêmes.

## Imports canoniques

### Sinister Woods (`gloomy_forest`) — copie exacte de `relic_forest`

Les segments procéduraux 0, 1 et 3 de Sinister Woods partagent un patron exact avec les cinq étages de `relic_forest` :

- grille : cellules 10×10, grille 2×3, murs 3 ;
- `GridPathBranch` ;
- RoomRatio 90–91 % ;
- BranchRatio 0–25 % ;
- salles `RoomGenRound` 5–10 × 5–10 ;
- couloirs `RoomGenAngledHall`, largeur/hauteur 0–0 ;
- connexions supplémentaires 75 % ;
- mêmes blobs et mêmes filtres de connectivité.

**Verdict : violation majeure.** Les Grounds D04P01/D04P02 sont canoniques, mais les floors entre eux ne reproduisent pas une identité propre à Sinister Woods : ils héritent de Relic Forest.

### Aegis Cave (`cloven_ruins`) — copie exacte de `crooked_cavern`

Les labyrinthes Glace, Roche, Acier et le Puits utilisent le même cœur que les deux segments de Crooked Cavern :

- grille : cellules 7×7, grille 4×4, murs 5 ;
- `GridPathBranch` ;
- RoomRatio 70–81 % ;
- BranchRatio 50–101 % ;
- salles `RoomGenCave` 5–8, avec variante 8–12 ;
- halls tournants 2–5, biais 90 ;
- reconnexion 50 % ;
- même dessin final et mêmes filtres.

Similarité globale : **64,7 %**, mais les patrons de floors procéduraux sont des copies exactes.

**Verdict : violation majeure.** Les puzzles Zarbi et arènes fixes différencient la progression, mais la géométrie des labyrinthes reste celle de Crooked Cavern. Les trois secteurs Aegis devraient au minimum avoir des signatures Glace/Roche/Acier distinctes.

### Sky Tower (`sky_tower`) — dérivée de `vast_steppe`

Aucun floor n’est une copie binaire exacte, mais la signature atteint **65,2 %** avec Grande Steppe. Les deux utilisent :

- cellules 10×10 ;
- `GridPathGrid`, RoomRatio 100, HallRatio 10 ;
- salles `RoomGenCave` ;
- mêmes halls très étroits avec HallTurnBias 0 ;
- reconnexion 75 % ;
- mêmes étapes Perlin + Blob + suppression d’îlots.

Différences actuelles :

- Sky Tower : grille 3×4, salles 9–13, eau/vide 55–65 % ;
- Grande Steppe : grille 3×3, salles 8–10, eau 45–46 %.

**Verdict : forte dérivation, pas copie exacte.** Techniquement distinct, mais insuffisant pour garantir une sensation de montée verticale propre à Sky Tower. La structure de graphe et les couloirs restent ceux de Grande Steppe.

## Autres copies exactes trouvées

### `waterfall_pond` ↔ `poisonous_forest`

Les quatre blocs procéduraux de chaque zone sont identiques : même grille 2×3, mêmes salles rondes, mêmes couloirs nuls/étroits, mêmes ratios et reconnexion 75 %.

**Verdict : copie exacte complète de géométrie.** Sanctuaire cristallin et marais ne diffèrent que par leur contenu/habillage.

### `grotte_repos` ↔ `halles_royales` ↔ `jardin_energie`

Similarité : **100 %**. Les 62 floors cumulés de ces trois zones réutilisent le même patron.

**Verdict : duplication industrielle majeure.**

### `bosquet_voile` ↔ `grotte_mystere`

Similarité : **75 %**.

**Verdict : dérivation forte à examiner.**

### Floors fixes/génériques partagés

Un patron exact est également partagé entre :

- `foret_embuscade` segment 4 ;
- `gloomy_forest` segment 6 ;
- `toundra_desolee` segment 1.

Il peut s’agir d’un segment fixe utilitaire ; sa légitimité dépend de son rôle, mais il ne doit pas être présenté comme un floor identitaire.

## Classement de gravité

| Niveau | Cas |
|---|---|
| Bloquant canonique | Sinister Woods = Relic Forest |
| Bloquant canonique | Aegis Cave = Crooked Cavern |
| Majeur canonique | Sky Tower dérivée à 65,2 % de Grande Steppe |
| Bloquant New Era | Waterfall Pond = Poisonous Forest |
| Bloquant secondaire | Grotte Repos = Halles Royales = Jardin Énergie |
| Majeur | Bosquet Voilé ≈ Grotte Mystère |

## Recommandations techniques

### Sinister Woods

Employer une topologie forestière organique : `FloorPathBranch` ou branches longues, salles irrégulières peu nombreuses, couloirs sinueux, culs-de-sac contrôlés et densification progressive vers D04P02. Ne pas reprendre la grille ronde de Relic Forest.

### Aegis Cave

Créer trois signatures :

- Glace : branches étroites, boucles et impasses ;
- Roche : grandes chambres cassées reliées par peu de corridors massifs ;
- Acier : structure rectiligne/orthogonale, halls longs et réguliers ;
- Puits : descente plus compacte et oppressante.

Le puzzle Zarbi doit s’inscrire dans ces topologies, pas seulement dans les tables de spawn.

### Sky Tower

Remplacer progressivement la grille de Grande Steppe par une montée verticale : chemins principaux plus longs, petites plateformes, connexions rares, densité décroissante et vide croissant. Les trois sections doivent employer des GenSteps différents, pas uniquement des valeurs de taille/eau différentes.

## Corrections appliquées — lot canonique

Les trois imports canoniques actifs ont reçu des signatures internes distinctes :

### Sinister Woods

- segment 0 : grille 3×4, salles 4–8, branches 35–61 %, reconnexion 55 % ;
- segment 1 : grille 4×3, salles 6–11, branches 55–86 %, reconnexion 40 % ;
- segment 3 : grille 3×5, salles 4–9, halls à biais 90, reconnexion 65 %.

Similarité avec Relic Forest après correction : **26,5 %**, contre 59,1 % et des floors exacts avant correction. Aucun floor principal n’est encore identique.

### Aegis Cave

- Glace : réseau 4×5, petites salles, branchement fort, reconnexion 35 % ;
- Roche : cellules 9×9, grandes salles 8–13, halls larges 2–4 ;
- Acier : réseau horizontal 5×3, halls rectilignes, reconnexion 15 % ;
- Puits : réseau vertical 3×5, forte profondeur de branches, reconnexion 20 %.

Similarité avec Crooked Cavern après correction : **21,2 %**, contre 64,7 % et des floors exacts avant correction.

### Sky Tower

- contreforts : grille 3×5, salles 8–12, vide 35–46 % ;
- montée : grille 3×6, salles 7–10, vide 55–66 % ;
- sommet : grille 2×7, salles 5–8, vide 70–81 %, connexions rares.

La verticalité augmente et la densité diminue à chaque segment. Similarité avec Grande Steppe : **30,6 %**, contre 65,2 % avant correction.

### Résultat après correction

- imports canoniques partageant un floor exact avec un autre donjon : **0** ;
- Aegis Cave, Sinister Woods et Sky Tower possèdent désormais des signatures propres ;
- les duplications restantes concernent les donjons New Era secondaires et un segment utilitaire, à corriger dans un lot séparé.

## Conclusion

Les trois donjons canoniques actifs ne reprennent plus la géométrie interne d’un autre donjon. Les duplications secondaires signalées restent une dette réelle : Waterfall Pond/Poisonous Forest et le trio Grotte Repos/Halles Royales/Jardin Énergie.
