# Audit correctif moteur / écosystème / chaîne canonique — 2026-08-23

## Verdict exécutif

Le dépôt contenait déjà un « Dungeon Builder » et 51 zones générées. Elles
chargeaient dans PMDO, mais ce fait avait été transformé à tort en verdict
« canonique / prêt production ».

L'audit présent corrige cette conclusion :

- la chaîne native RogueElements fonctionne et a maintenant été prouvée par le
  vrai moteur sur **48 floors isolés** ;
- les trois profils éprouvés (`branching`, `looping`, `large_rooms`) produisent
  des graphes variés, connectés, avec salles, halls, branches, culs-de-sac et
  boucles ;
- les 51 définitions historiques ne possèdent pas encore la provenance
  catégorielle exigée et 50 déclarent des pièges jamais exportés ;
- l'audit a trouvé dans Sinister Woods : 14 floors procéduraux contre **12
  procéduraux + 1 fixe**, Wooper absent, Bonsly supplémentaire, shops / Monster
  Houses / météo activés malgré des chances ROM nulles ; Wooper/Bonsly et les
  features ont été corrigés dans la définition, tandis que le nombre de floors
  et le câblage final restent volontairement bloqués jusqu'à la reconstruction ;
- par conséquent, **aucun batch n'est autorisé**. Le nouveau gate canonique est
  fail-closed (`canonical-audit`, `generate`, `generate-all`).

Cette correction ne supprime et ne remplace aucun donjon canonique, Ground ou
`.rsmap`. Aegis Cave / Ruines Fendues reste hors périmètre.

---

## 1. Mise à jour et état Git initial

- branche de travail imposée :
  `arena/01a02f98-new-era-abyss-to-ascension-v4` ;
- la branche distante du même nom n'existait pas encore ;
- branche Arena parente vérifiée :
  `origin/arena/01a02b39-new-era-abyss-to-ascension-v4` =
  `0f691fa37ca484c3b6ab6599597db2f0483fd15e` ;
- `HEAD` était exactement sur ce commit, arbre propre ;
- scan initial : **23 073 fichiers suivis**, environ **4,0 Gio**.

## 2. Inventaire réel du dépôt

| Ressource | Mesure |
|---|---:|
| `Data/Ground/*.rsground` | 437 |
| `RESERVE/red_grounds/*.rsground` | **245** |
| `RESERVE/sky_grounds/*.rsground` | 467 |
| `Data/Map/*.rsmap` | 62 |
| `RESERVE/maps/*.rsmap` | 148 |
| `Content/Tile/*.tile` | 980 |
| `RESERVE/red_tiles/*.tile` | 245 |
| définitions `DungeonDefs/canonical` | **51** |
| zones actives `Data/Zone/*.json` (hors index) | 89 |
| floors déclarés par les 51 définitions | 1 429 |

### DTEF

- PMDCollab/RawAsset HEAD `03c80dad` : **185 dossiers** sous `TileDtef`
  (certains sont des rôles séparés `Floor`/`Wall`/`Secondary`, donc 185 n'est
  pas un nombre de packages complets).
- Importés et possédés par le mod dans `Data/AutoTile` : **2 triplets** :
  `sinister_woods_b41` et `northwind_field`.
- Catalogue PMDO de base attesté par les données : **156 triplets complets**.
- La valeur historique « 23 packages importés » n'est pas confirmée.

### DumpAsset

DumpAsset HEAD `3e767571` contient exactement :

- **18 `.rsground`** ;
- 122 `.rsmap` ;
- 208 `.tile` ;
- 948 `.chara` ;
- 1 026 `.portrait`.

Les 18 Grounds sont bien ceux du jeu de base (camps, guilde, finales, etc.), pas
18 arènes canoniques PMD Red.

---

## 3. Sources upstream réellement inspectées

| Projet | Commit inspecté | Rôle constaté |
|---|---|---|
| RogueElements | `a3869ec8` | plans, RNG, rooms, halls, terrain, spawners génériques |
| RogueEssence | `a03f2eac` | runtime, scènes, données, LevelGen PMDO, Lua, sérialisation |
| PMDC | `a5ef70a8` | règles Pokémon et GenSteps spécialisés |
| PMDODump | `21ec4abd` | DataGenerator, docs d'assets, zones de référence |
| RawAsset | `03c80dad` | DTEF et ressources brutes |
| DumpAsset | `3e767571` | données binaires PMDO distribuées |
| swablu | `80bfc2cf` | import DTEF Explorers via `skytemple-dtef`, pas convertisseur PMDO |
| rogueelements-pmd-asp | `d24422b5` | exemple minimal de composition RogueElements |
| PMDOTutorial | tags v0.1 → v0.8 | progression Ground → Map → multi-floor → cutscene → boss → SV |
| pret/pmd-red | `bf0092d0` | source primaire exploitable des données PMD Red |

Les pages wiki avec suffixe `.html` fournies dans la demande sont vides ; leurs
pages canoniques sans suffixe (`Floor_Generation_Steps`, `Grid_Path_Steps`,
`Creating_Dungeons_from_Scratch`) ont été consultées.

---

## 4. Constat moteur précis

### RNG et génération

- `IGenContext` expose `IRandom Rand`, `InitSeed(ulong)` et `FinishGen()`.
- `ReRandom` est `xoshiro256**`, initialisé par `SplitMix64`.
- `Zone.GetMap` dérive une seed par segment, floor et compteur de revisite avec
  `ReNoise`; il tente au maximum cinq générations **uniquement si une exception
  s'échappe** de `GetMap`.
- `ChanceFloorGen` utilise `ReRandom(zoneContext.Seed)` pour sélectionner un
  `IFloorGen`, puis le générateur sélectionné réutilise la même seed. C'est le
  mécanisme natif retenu pour varier le profil en production.

### Piège important : les erreurs de GenStep ne régénèrent pas automatiquement

`MapGen.ApplyGenSteps` enveloppe chaque `postProc.Apply(map)` dans un `try/catch`
et transmet l'exception à `GenContextDebug.DebugError`. Dans RogueEssence,
`DiagManager.logRogueElementsError` journalise l'erreur mais ne la relance pas.

Conséquences :

- `DetectIsolatedStairsStep` peut signaler une erreur sans déclencher les cinq
  nouvelles tentatives de `Zone.GetMap` ;
- `DetectIsolatedStep` ne lance même pas d'exception en build Release : il écrit
  sur la console puis retourne ;
- l'ancien rapport affirmait à tort que ces steps « rejettent et régénèrent ».

La validation post-génération moteur est donc obligatoire. Une vraie
régénération automatique de qualité nécessite soit une modification minimale du
runtime, soit un mécanisme PMDO existant qui laisse remonter l'échec ; aucun
second moteur procédural ne doit être créé pour contourner ce point.

### Grilles et plans

- `GridPathBranch` construit un arbre couvrant selon `RoomRatio` et
  `BranchRatio`, avec dix tentatives au maximum.
- `GridPathCircle` construit une boucle périphérique puis des chemins intérieurs.
- `GridPathGrid` place des salles périphériques et un maillage interne.
- `GridPathTwoSides` place deux bords de salles et des traverses.
- `GridPathCross` est une croix structurelle déterministe, dont les room gens
  gardent cependant leurs dimensions/formes aléatoires.
- `GridPathTiered` est dans RogueEssence ; `GridPathTreads`, `GridPathEdge`,
  `GridPathBeetle` et `GridPathPyramid` sont fournis au-dessus par PMDC.
- `AddLargeRoomStep` **existe bien dans RogueEssence**. L'ancien audit disait
  seulement qu'il n'existait pas dans RogueElements, puis assimilait trop vite
  toute la fonction à `CombineGridRoomStep`. Les deux ont des comportements
  distincts : bulldozer/entrées autorisées contre fusion de cellules existantes.
- `FloorStairsDistanceStep` de PMDC fournit une plage min/max en distance
  Manhattan entre origines de rooms ; il ne mesure pas le vrai chemin de tiles
  et conserve un fallback qui peut sortir de la plage. Le BFS runtime reste
  l'autorité de fair-play.

### Cycle scènes / Lua / données

- `GameManager.ScreenMainCoroutine` maintient la scène courante ;
  `MoveToZone` exécute sortie de map, changement/initialisation de zone,
  `OnEnterSegment`, chargement map/Ground puis `Init`/`Enter`.
- Ground : `GroundMap.OnInit` initialise les entités, joue callback `Init`, puis
  publie l'évènement service ; `OnEnter`, `Update` et `OnExit` suivent le même
  modèle.
- Dungeon : `Zone.GetMap` construit la map à partir du segment ; la seed réelle
  est journalisée par le moteur.
- Lua : les fonctions exposées sont installées après les singletons ; les
  callbacks sont transformés en itérateurs de coroutine Lua et conduits par le
  `CoroutineManager` C#.
- Il n'existe pas de classe `SaveManager` dans ce HEAD. La responsabilité est
  répartie entre `DataManager`, `GameProgress`, `Serializer` et
  `LuaEngine.SaveData/LoadSavedData` pour les `SV`.
- `DataManager` charge les `index.idx`, résout les namespaces de mod et contrôle
  les versions lors de la lecture des sauvegardes/replays.

---

## 5. Audit correctif de l'ancien Builder

### Points valides

- définitions externes JSON ;
- émission de vrais `$type` RogueElements/RogueEssence/PMDC ;
- DTEF via `MapTextureStep`, pas d'autotile maison en production ;
- Grounds/`.rsmap` et scripts déjà inventoriés ;
- 146 tests historiques passaient avant correction ;
- un ancien stress test moteur avait généré 4 287 maps sans crash de chargement.

### Points invalides ou insuffisants

1. `re_sim` n'est pas un portage fidèle : il utilise `random.Random` au lieu de
   `ReRandom`; sa fusion de rooms interprétait `combine_rate` comme un
   pourcentage alors que `CombineGridRoomStep.MergeRate` est un nombre de
   tentatives ; l'ordre des steps divergeait de l'export. Il reste uniquement un
   aperçu non certifiant et n'alimente plus aucun gate de production.
2. Un seul profil était choisi au moment d'écrire le JSON. Une seed d'authoring
   était inscrite dans le commentaire. La production ne variait donc pas la
   famille architecturale avec la seed runtime.
3. Les rapports de « topologie » provenaient majoritairement du simulateur, pas
   du `FloorPlan` natif.
4. Les traps sont déclarés dans 50 définitions mais `zone_export.py` ne les
   émet pas. `mystery` n'est pas implémenté non plus.
5. Les probabilités de shop/Monster House étaient converties en valeurs fixes
   45/30, sans utiliser les octets de chance de `main_data.inc`.
6. Les profils de géométrie étaient choisis par une table de « nature »
   manuelle et non dérivés floor par floor des paramètres ROM.
7. Les 51 définitions n'avaient pas de provenance structurée par catégorie.
8. `READY_FOR_GENERATION` signifiait « références chargeables », pas « canon
   prouvé ».
9. Sinister Woods était utilisé comme référence validée alors que sa définition
   contredit directement la ROM et que son câblage `canonical_ground` renvoie
   encore vers un troisième segment procédural.
10. Le fallback de conversion objets essayait toutes les familles de préfixes :
    `ITEM_WARP_ORB` devenait silencieusement `seed_warp`. Ce fallback a été
    supprimé ; une correspondance absente reste désormais explicitement absente.

---

## 6. Prototype moteur isolé — preuve obtenue

Commande reproductible :

```bash
python3 tools/dungeon_builder.py prototype \
  --per-profile 16 \
  --workdir /tmp/dungeon-builder-engine-prototype \
  --report
```

Le script crée un miroir hard-link jetable, ajoute uniquement la zone
`__dungeon_builder_prototype`, puis lance le binaire PMDO 0.8.12 headless. Aucun
fichier canonique n'est modifié.

Résultat :

- **48/48** floors générés par `ZoneSegmentBase.GetMap` ;
- **0** échec moteur ;
- **0** escalier inaccessible ;
- **0** cellule praticable isolée ;
- rooms : 8 / 14,5 / 21 ;
- halls : 8 / 17,4 / 30 ;
- branches : 2 / 5,2 / 11 ;
- culs-de-sac : 1 / 3,3 / 5 ;
- boucles : 0 / 2,6 / 8 ;
- distance BFS entrée→escalier : 15 / 41 / 98.

Sélection après rejet topologique (seuil 0,92) :

| Profil | Tentatives | Acceptées | Rejetées | Signatures |
|---|---:|---:|---:|---:|
| branching | 16 | 12 | 4 | 12 |
| looping | 16 | 16 | 0 | 16 |
| large_rooms | 16 | 16 | 0 | 16 |

La première expérience a correctement **échoué** : l'ancien `large_rooms`
produisait 2–3 rooms sans branche et l'ancien `looping` supprimait parfois tous
les culs-de-sac. Les paramètres ont été ajustés dans le fixture, puis promus
seulement après la passe native ci-dessus.

Preuves :

- `docs/dungeon_builder/ENGINE_PROTOTYPE_NATIVE.md` ;
- `docs/dungeon_builder/runtime/engine_prototype_native.jsonl` (seed + métriques
  de chaque floor).

---

## 7. Nouveau gate canonique

`tools/dungeon_builder/canonical_gate.py` exige :

- provenance structurée `PMD_RED_ROM`, `PMD_SKY_ROM`, Ground de réserve,
  Raw Assets, source moteur, Bulbapedia, `INFERRED` ou `SUPPLEMENTAL` explicite ;
- catégories floor parameters, Pokémon, objets, tileset, Grounds et scènes ;
- mappings natifs des features activées ;
- état configuration validé avant `generate` ;
- état runtime validé + `batch_approved=true` avant `generate-all`.

État actuel : **0/51 configuration validée**, **0/51 runtime validé**. Ce n'est
pas une régression : c'est la correction d'un faux positif antérieur.

Pour Sinister Woods, le manifest canonique nouvellement extrait est :
`docs/canonical/red/sinister_woods_rom_manifest.json`. Il prouve :

- 13 records ;
- floors 1–12 procéduraux, floor 13 fixe (`fixedRoomNumber=2`) ;
- tileset 41 sur les procéduraux, tileset 65 sur D04P02 ;
- shop chance = 0, Monster House chance = 0, météo = 0 sur les procéduraux ;
- Wooper dans la table canonique ; Bonsly absent du canon.

---

## 8. Ordre de travail restant (bloquant)

1. Réconcilier la définition Sinister Woods avec les 12 floors procéduraux et
   D04P02 fixe/event (Wooper/Bonsly et features nulles sont déjà corrigés).
2. Finir la conversion exacte des tables objets ; le piège canonique Wonder
   Tile est désormais émis via `TileSpawnZoneStep` + placement natif.
3. Corriger le parcours pour que le Ground final canonique ne renvoie pas vers
   une arène procédurale cachée.
4. Produire un candidat Sinister en miroir jetable, au minimum dix seeds par
   floor/profil, puis test du parcours entrée → midpoint → D04P02 → boss → sortie.
5. Seulement après cette validation, passer la provenance des autres définitions
   une à une et autoriser un batch progressif.

### Smoke test intermédiaire après correction des placements

Un candidat Sinister non-production a ensuite exécuté 42 floors réels : 0
invalide, 6–8 objets, 2–7 Pokémon et 3 Wonder Tiles sur chaque floor canonique
1–12. Ce test a trouvé auparavant un défaut majeur supplémentaire : les Zone
Steps remplissaient les tables, mais aucun step ne plaçait objets, argent ou
Pokémon ; les maps runtime en contenaient donc zéro. Le Builder émet désormais
les placements natifs `DueSpawnStep`, `TerminalSpawnStep` et
`PlaceRandomMobsStep`. Voir `SINISTER_CANDIDATE_NATIVE_SMOKE.md`.

Aucune déclaration « Builder terminé » n'est justifiée avant ces étapes.
