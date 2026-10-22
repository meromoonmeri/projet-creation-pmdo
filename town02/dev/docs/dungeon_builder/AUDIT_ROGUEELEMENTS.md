# Audit RogueElements — capacités réelles vérifiées dans le code source

> **RECTIFICATIF 2026-08-23 — ce document historique n'est plus un gate de
> production.** Voir `AUDIT_CORRECTIF_ENGINE_CANONICAL_2026-08-23.md` et
> `ENGINE_PROTOTYPE_NATIVE.md`. Les sources RogueEssence/PMDC sont désormais
> disponibles et ont invalidé trois affirmations ci-dessous : `AddLargeRoomStep`
> existe dans RogueEssence ; le `try/catch` de `MapGen.ApplyGenSteps` empêche
> `DetectIsolatedStairsStep` de déclencher à lui seul la régénération ; `re_sim`
> n'est pas fidèle (`random.Random`, sémantique de fusion différente) et ne peut
> certifier aucune production.

**Date** : 2026-08-22
**Méthode** : lecture intégrale des sources upstream `audinowho/RogueElements`
(clonées et lues fichier par fichier, HEAD `a3869ec`), croisée avec le
vocabulaire réellement sérialisé dans les 44 zones existantes de ce dépôt
(`Data/Zone/*.json`), et avec `SkyTemple/rogueelements-pmd-asp`.

> **Limite d'environnement, déclarée honnêtement.** Le sandbox n'a accès qu'à
> `github.com` et `pypi.org` : ni le SDK .NET, ni NuGet, ni `dot.net`, ni
> `raw.githubusercontent.com` ne sont joignables, et les dépôts `RogueEssence`
> / `PMDO` ne sont pas publics à ces URL. Il est donc **impossible d'exécuter
> RogueElements en C# dans cet environnement**. Le prototype a donc été
> construit comme un **portage Python fidèle des algorithmes lus** (voir
> `tools/dungeon_builder/re_sim/`, chaque fichier cite la source C# portée) :
> il sert exclusivement à **mesurer et valider hors-ligne** les paramètres. La
> production, elle, n'utilise **aucun moteur parallèle** : le builder émet des
> `GenSteps` RogueElements/RogueEssence/PMDC natifs que le moteur exécute avec
> son propre RNG. Toute conclusion ci-dessous est tirée du code C# lu, pas
> d'une supposition sur un nom de classe.

---

## 1. `IGenContext`, RNG et seeds

| Élément lu | Fichier | Ce qu'il fait réellement |
|---|---|---|
| `IGenContext` | `MapGen/IGenContext.cs` | Expose `IRandom Rand` + `InitSeed(ulong)`. **Toute** la génération passe par ce RNG : aucun step n'a de seed propre. |
| `IRandom` / `ReRandom` | `Rand/IRandom.cs`, `Rand/ReRandom.cs` | Générateur réimplémenté (déterministe pour une seed donnée) : `Next()`, `Next(max)`, `Next(min,max)`. |
| `RandRange` | `Rand/RandRange.cs` | `Min` inclusif / `Max` exclusif, `Pick(rand)`. C'est **le** type de tous les paramètres numériques variables des steps (largeur de salle, ratio, etc.). |
| `RandBinomial` | `Rand/RandBinomial.cs` | `Trials` + `Percent` → quota aléatoire. Utilisé par `ConnectGridBranchStep` et par les `SpreadPlanQuota` de PMDO (shops, monster houses). |
| `SpawnList<T>` / `SpawnRangeList<T>` | `Rand/SpawnList.cs`, `Rand/SpawnRangeList.cs` | Listes pondérées (avec plage d'étages pour la version Range) : c'est le mécanisme natif des tables de salles, de Pokémon et d'objets. |
| `MapGen.GenerateMap` | `MapGen/MapGen.cs` | Ordonne les steps par `Priority` puis les applique séquentiellement sur le contexte. |

**Conséquences appliquées par le Builder** : la seed de production vient du
runtime (`InitSeed` par le jeu à chaque entrée) ; le builder n'écrit jamais de
seed dans `Data/Zone`. Un test (`test_no_precomputed_layout_in_output`) vérifie
qu'aucun champ `Seed` ni layout figé n'apparaît dans la zone produite.

## 2. Squelette d'un étage : `GridFloorGen` vs `RoomFloorGen`

Deux familles, toutes deux natives et utilisées dans ce dépôt :

* **Grille** (`IRoomGridGenContext`) : `InitGridPlanStep` → `GridPath*` →
  (`ConnectGridBranchStep`, `SetGridDefaultsStep`, `CombineGridRoomStep`) →
  `DrawGridToFloorStep` → `DrawFloorToTileStep`.
  Les 327 `GridFloorGen` déjà présents dans `Data/Zone` confirment que c'est le
  chemin standard du projet ; c'est celui retenu par le Builder.
* **Plan libre** (`IFloorPlanGenContext`) : `InitFloorPlanStep` →
  `FloorPathBranch` → `ConnectBranchStep` / `AddConnectedRoomsStep` /
  `AddDisconnectedRoomsRandStep` → `DrawFloorToTileStep` (24 `RoomFloorGen`
  présents). Disponible, non retenu pour Sinister Woods (moins de contrôle sur
  la densité par cellule), mais l'architecture du builder permet de l'ajouter
  comme nouveau `path` de profil.

### `GridPlan` (`MapGen/Grid/GridPlan.cs`, 825 lignes lues)
* `InitSize(w,h,widthPerCell,heightPerCell,cellWall,wrap)` : grille de cellules,
  chaque cellule pouvant contenir une salle ; `CellWall >= 1` obligatoire.
* `AddRoom(Rect,…)` accepte des **salles multi-cellules** (grandes salles).
* `SetHall(LocRay4,…)` pose un couloir entre deux cellules adjacentes.
* `GetAdjacentRooms(i)` : voisinage **réel** (via halls) → c'est ce qui définit
  culs-de-sac (1 voisin) et embranchements (≥3 voisins).
* `ChooseRoomBounds` : `ProposeSize` de la salle, **clampée à la cellule**, puis
  position **aléatoire** dans la cellule → deux générations ne posent jamais les
  salles au même endroit même à structure égale.
* `ChooseHallBounds` : calcule le rectangle du couloir entre deux salles, avec
  découpe en deux tronçons quand les bordures ne se recouvrent pas
  (`GridHallGroup.HallParts`) → couloirs coudés de longueurs variables.
* `Wrap` : grilles cycliques supportées (non utilisé ici).

**Confirmé** : la grille n'impose pas des salles carrées identiques ; taille,
forme et position varient par salle et par génération.

## 3. Les `GridPath*` réellement disponibles

| Classe | Fichier lu | Paramètres réels | Topologie produite |
|---|---|---|---|
| `GridPathBranch<T>` | `Grid/Paths/IGridPathBranch.cs` | `RoomRatio`, `BranchRatio`, `NoForcedBranches` | Arbre couvrant : `BranchRatio` 0 = ver, 50 = arbre, 100+ = arbre très ramifié. Produit **embranchements + culs-de-sac**. Boucle de secours ×10 si le quota de salles n'est pas atteint. |
| `GridPathCircle<T>` | `Grid/Paths/IGridPathCircle.cs` | `CircleRoomRatio`, `Paths` | Anneau périphérique (**boucle garantie**) + `Paths` chemins internes en marche aléatoire → chemins alternatifs. |
| `GridPathGrid<T>` | `Grid/Paths/IGridPathGrid.cs` | `RoomRatio`, `HallRatio` | Maillage interne de cellules-couloirs + salles au périmètre → **beaucoup de boucles**. |
| `GridPathTwoSides<T>` | `Grid/Paths/GridPathTwoSides.cs` | `GapAxis` | Deux rangées de salles reliées par de **longs couloirs traversants**. |
| `GridPathCross<T>` | `Grid/Paths/GridPathCross.cs` | — | Croix centrée : hub + quatre branches. |
| `GridPathSpecific<T>` | `Grid/Paths/GridPathSpecific.cs` | `SpecificGridRoomPlan` | Placement scripté (utile pour un étage imposé). |
| `GridPathTiered` / `GridPathTreads` | **côté RogueEssence**, pas RogueElements | `Data/Zone` en contient 31 occurrences (`RogueEssence.LevelGen.GridPathTiered`) | Étages en paliers. Non porté dans le simulateur (source RogueEssence non accessible) → **non utilisé par le builder pour l'instant**, limite déclarée. |

## 4. Salles : tailles et formes natives

Lues dans `MapGen/Rooms/` : `RoomGenSquare` (rectangle), `RoomGenRound`
(ellipse, test exact `IsTileWithinRoom` porté), `RoomGenCross` (croix avec
`MajorWidth`/`MinorWidth`…), `RoomGenCave` (blob), `RoomGenBlocked` (salle avec
bloc de terrain interne), `RoomGenBump`, `RoomGenSpecific`, plus
`RoomGenDefault` (cellule de 1 tuile servant de nœud de couloir).
Chacune a ses `RandRange Width/Height` → **les tailles sont aléatoires par
salle**, et le tirage se fait dans une `SpawnList` pondérée : plusieurs formes
peuvent coexister sur le même étage.

`PermissiveRoomGen`/`IPermissiveRoomGen` : distinction salle / couloir.
`RoomGen.PrepareSize` + `PrepareFulfillableBorders` + `AskBorderFromRoom` +
`DigAtBorder` garantissent qu'un couloir trouve **toujours** une ouverture
praticable dans la salle (auto-tunneling) → pas de connexion morte.

## 5. Couloirs

`RoomGenAngledHall<T>` (`Rooms/Halls/RoomGenAngledHall.cs`) : `HallTurnBias`
(0-100) décide entre couloir droit et couloir coudé ; `Brush`
(`DefaultHallBrush`, `SquareHallBrush`, `TerrainHallBrush`) contrôle la largeur
et le terrain du couloir. Les longueurs varient mécaniquement avec la taille
des cellules et la position aléatoire des salles.

## 6. Connexions, boucles et grandes salles

* `ConnectGridBranchStep<T>` (lu intégralement) : détecte les **culs-de-sac**
  (`GetAdjacentRooms(i).Count == 1`), remonte le couloir jusqu'au premier
  embranchement, puis reconnecte un pourcentage (`ConnectPercent`, tiré par
  `RandBinomial`) → **c'est le mécanisme natif de création de boucles et de
  chemins alternatifs**.
* `SetGridDefaultsStep<T>` : convertit une proportion (`DefaultRatio`) de salles
  de passage en simples nœuds de couloir → varie la densité salle/couloir.
* `RogueEssence.LevelGen.CombineGridRoomStep` (121 usages dans le dépôt) :
  fusionne des cellules adjacentes en **grande salle** (`Combos` = taille 1×2,
  2×1, 2×2 + `GiantRoom`), avec `MergeRate` aléatoire.
* `AddLargeRoomStep` n'existe **pas** sous ce nom dans RogueElements : la
  fonctionnalité correspondante est `CombineGridRoomStep` (grille) et
  `AddConnectedRoomsRandStep` (plan libre). Vérifié, pas supposé.

## 7. Escaliers, terrain, validation de connectivité

* `FloorStairsStep<T,E,X>` : place entrée + sortie dans des salles distinctes en
  respectant `MinDistance` et des `Filters` (ici : connectivité principale, hors
  `BossRoom`).
* `DetectIsolatedStairsStep` : **rejette la carte** si l'escalier n'est pas
  atteignable → la validation de traversabilité est native.
* `DetectIsolatedStep`, `EraseIsolatedStep`, `EraseIsolatedFromSpawnStep` :
  suppression/érosion des zones inaccessibles.
* Terrain : `PerlinWaterStep`, `BlobWaterStep`, `AddWaterStep`,
  `DropDiagonalBlockStep`, stencils (`MapTerrainStencil`,
  `NoChokepointTerrainStencil`…) — eau/lave gérées nativement, et
  `NoChokepointTerrainStencil` empêche l'eau de couper un passage obligatoire.
* Spawns : `RandomRoomSpawnStep`, `RoomSpawnStep`, `TerminalSpawnStep`,
  `DueSpawnStep`, `PickerSpawner`, `MultiStepSpawner` — objets/Pokémon/pièges
  placés uniquement sur des cases valides du plan.

## 8. Côté PMDO/PMDC (vérifié dans les zones du dépôt)

`PMDC.LevelGen.ShopStep` (Kecleon complet : `Mobs`, `StartMob`,
`SecurityStatus`, `Personality`), `PMDC.LevelGen.MonsterHouseStep` +
`SpreadHouseZoneStep`, `SpreadVaultZoneStep` (salles coffres/clés),
`ItemSpawnZoneStep`, `TeamSpawnZoneStep`, `MoneySpawnZoneStep`,
`TileSpawnZoneStep` (pièges/dalles), `DefaultMapStatusStep` (météo),
`MapTextureStep` (auto-tilesets DTEF), `LoadGen` + `MappedRoomStep` (étage fixe
chargé depuis un `.rsmap`).

**Conclusion : rien de ce que demande le cahier des charges ne nécessite un
moteur maison.** Le Builder n'ajoute que : (a) une couche de configuration
(définitions JSON), (b) des profils qui composent ces steps, (c) un simulateur
hors-ligne de validation, (d) l'export et les rapports.

## 9. Ce qui a été démontré par le prototype

Voir `docs/dungeon_builder/PROTOTYPE_METRICS.md` (54 étages, 9 profils, seeds
issues de l'entropie OS) : rooms 4→29 par étage, halls 6→31, branches 0→12,
culs-de-sac 0→7, boucles 0→8, aires de salles de 9 à 240 tuiles, 100 % des
étages acceptés traversables avec escalier atteignable, et **aucune signature
structurelle dupliquée**.


---

## 10. Relecture de vérification (2026-08-23) — capacités natives non encore exploitées

Deuxième passe complète sur les sources clonées (`audinowho/RogueElements`,
HEAD `a3869ec`), pour répondre à une question précise : *reste-t-il du natif que
le Builder réimplémenterait ou ignorerait ?*

| Fichier relu | Capacité | Décision |
|---|---|---|
| `Tiles/Water/PerlinWaterStep.cs` (+`WaterStep`, `IPerlinWaterStep`) | Champs d'eau/lave par bruit de Perlin : `WaterPercent`, `OrderComplexity`, `OrderSoftness`, `Bowl`, `Terrain`, `TerrainStencil` | **Adopté** : bloc `variation.terrain` dans la définition → `PerlinWaterStep` natif émis. |
| `Tiles/Water/NoChokepointTerrainStencil.cs` | Refuse toute pose de terrain qui créerait un goulot d'étranglement | **Adopté** : enveloppe systématique quand `protect_paths` (défaut) → la traversabilité reste garantie par le moteur lui-même. |
| `Tiles/Water/BlobWaterStep.cs`, `BlobTileStencil`, `MultiBlobStencil` | Taches de terrain localisées | Disponible, non exposé pour l'instant (le Perlin couvre le besoin actuel). |
| `Grid/SetGridSpecialRoomStep.cs` | Remplace une salle de la grille par une salle spéciale dimensionnée | Retenu pour les Treasure/Key rooms — **à brancher** avec `PMDC.SpreadVaultZoneStep` (déjà présent dans les zones du dépôt). |
| `FloorPlan/AddDisconnectedRoomsRandStep.cs` | Salles secondaires déconnectées (zones cachées) | Disponible ; nécessite `RoomFloorGen`, hors du chemin `GridFloorGen` retenu. |
| `FloorPlan/ResizeFloorStep.cs`, `ClampFloorStep.cs` | Redimensionnement du plancher (utilisé par les coffres PMDC) | Utilisé indirectement via les templates PMDC. |
| `Rooms/RoomGenBump.cs`, `RoomGenBlocked.cs` | Salles bosselées / salles à bloc interne | `RoomGenBlocked` déjà émis par les combos de grandes salles ; `RoomGenBump` disponible pour un futur profil. |
| `Grid/Paths/GridPathSpecific.cs` | Grille scriptée | Réservé aux étages imposés ; non utilisé (contraire au besoin d'aléatoire). |

Conclusion inchangée : **aucun générateur maison n'est nécessaire**, et les deux
seules capacités qui manquaient au Builder (terrain natif, salles spéciales de
grille) sont désormais soit branchées, soit identifiées avec leur classe native
exacte. La parité `profiles.py` ↔ `re_sim` ↔ `steps.py` reste vérifiée
mécaniquement (`dungeon_builder verify`), et la conformité de l'export a de
nouveau détecté deux erreurs réelles pendant cette passe : un champ `Amount`
inexistant sur `MobSpawnStep`, et les champs `TileStencil`/`Global`/`Negate`
(et non `TerrainStencil`/`Terrain`) sur `NoChokepointTerrainStencil`.


---

## 11. Sources du moteur enfin accessibles (2026-08-23, via PMDCollab/PMDC)

Le dépôt `PMDCollab/PMDC` (submodules inclus) est accessible : il embarque
**RogueEssence** et **MapGenTest**. Deux points restés ouverts sont donc clos :

| Élément | Résultat |
|---|---|
| `GridPathTiered` | **Lu intégralement** (`RogueEssence/LevelGen/Floors/GenSteps/FloorPlan/GridPathTiered.cs`, 129 lignes) : `TierAxis` + `TierConnections`, chaînage complet des tiers le long d'un axe puis N ponts aléatoires entre tiers consécutifs. **Porté** dans le simulateur et exposé comme profil `tiered`, avec parité vérifiée. |
| `GridPathTreads` | **N'existe pas** : aucune classe de ce nom dans RogueElements ni dans RogueEssence. La mention initiale était erronée ; plus rien à porter. |
| `MapGenTest` | Harnais de génération **headless** du moteur (`-quest <mod>`, touche F2 = *stress test* de toutes les zones). C'est désormais l'outil de validation runtime recommandé : `tools/runtime/run_mapgen_check.sh`. |

Le Builder expose donc **10 profils**, tous adossés à une classe native lue en
source : `GridPathBranch`, `GridPathCircle`, `GridPathGrid`, `GridPathTwoSides`,
`GridPathCross` (RogueElements) et `GridPathTiered` (RogueEssence).
