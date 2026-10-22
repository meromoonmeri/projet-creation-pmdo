# Audit de provenance — Sinister Woods / `gloomy_forest`

**Date :** 2026-08-18
**Statut :** audit ROM EU + ancien travail terminé, aucune suppression,
remplacement ou régénération effectuée.

Ce document répond à la question de provenance avant toute modification de la
zone. Les sources externes ont été restaurées avec les hashes verrouillés par
`tools/restore_pmdred_eu_validation_runtime.sh`.

## 1. Autorités utilisées

- ROM PMD Red EU :
  `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`,
  `33 554 432` octets ;
- manifeste : `docs/pmdred_eu/ground_manifest.json`, SHA-256
  `02a5d8699ceef50c8195fccedcd455694121983f23869070e5b42b6dfb4e9730` ;
- décompilation technique : `pret/pmd-red` au commit
  `bf0092d0e34fd8e49b859a0b5f96f00740faa42d` ;
- assets PMDO de base : DumpAsset au commit verrouillé
  `9d864d1425f002b051e7a54fffc639988d8ef9c9`, arbre de 11 485 fichiers
  validé par le manifeste de restauration.

## 2. Données ROM réellement associées à Sinister Woods

### 2.1 Ground de scène D04P01 — entrée

La table EU donne :

| Élément | Valeur |
|---|---|
| stable Ground | `d04p01` |
| conversion | type `1` archive-backed |
| map ID | `189` |
| map-file ID | `198` |
| Ground place | `16` |
| ressources | `D04P01`, `D04P01c`, `D04P01m` |
| BPA | aucun slot |
| BPL | 8 palettes, aucune animation de palette |
| BPC | 126 chunks, 210 tuiles déclarées, slots BPA vides |
| BMA | 57×48 tuiles, 1 couche graphique, 1 couche collision |
| collision | 2 444 solides / 292 cases marchables |

Ressources normalisées issues du manifeste :

- `D04P01` BPL : 484 octets,
  `435eb6d4f10cf8a1bbe2eda091768ccf9d56413c31df02d76cd316b6249b04ca` ;
- `D04P01c` BPC : 8 954 octets normalisés,
  `b642bc41f3b027bde2b74c890dff63e2d34cf5e6dff6599c8fb71533432aa3cb` ;
- `D04P01m` BMA : 548 octets normalisés,
  `4af70fdac05f83ade76d5e42828a59063266a6dea82f037ab6a0d94bdd7b6d5c`.

Ancien travail retrouvé :

- `Data/Ground/d04p01.rsground` — Ground actif, intégration historique ;
- `Content/Tile/d04p01_Base.tile` —
  `b879546cf2a0784f94905ec98836dac480bf009291c6a97f7d218884554ae00d` ;
- `RESERVE/red_grounds/d04p01.rsground` et
  `RESERVE/red_tiles/d04p01_Base.tile` — inventaire historique ;
- `RESERVE/red_cinematics/d04p01.cif.json` — séquence source résumée ;
- `RESERVE/red_scene_reference/d04p01.lua` — référence d'intégration, pas un
  graphe EU complet certifié.

La scène D04P01 et son Ground graphique possèdent donc une provenance ROM
complète pour le chemin Ground archive-backed. Cela ne certifie pas encore le
port PMDO complet de ses acteurs, événements et chorégraphie.

### 2.2 Ground de scène D04P02 — clairière/final

La table EU donne :

| Élément | Valeur |
|---|---|
| stable Ground | `d04p02` |
| conversion | type `11` dungeon-backed direct |
| map ID | `190` |
| map-file ID | `199` |
| dungeon ID | `3` — Sinister Woods |
| compteur ROM | 14 lignes avec dummy, 13 étages jouables |
| ligne sélectionnée | 13 |
| ressources archive associées | `D04P02`, `D04P02c`, `D04P02m` |
| BPA | aucun slot dans la ligne Ground archive |
| BPL | 7 palettes, aucune animation de palette |
| BPC | 154 chunks, slots BPA vides |
| BMA | 69×72 tuiles, 1 couche graphique, 1 couche collision |
| collision | 4 210 solides / 758 cases marchables |

Ressources archive Ground normalisées :

- `D04P02` BPL : 424 octets,
  `bf5114dc757c5c6929c19704a5da1191cfa867acebae60135f845c8a7c44c2a4` ;
- `D04P02c` BPC : 7 090 octets normalisés,
  `87226d8183e8c1b583d4ab59166aadad6588fa2f42b87420df1429d71c040f3d` ;
- `D04P02m` BMA : 186 octets normalisés,
  `59b562807414421b8ddd27e4a79e2c803d0e4247c461d9a0c76898a442658f47`.

Le même map-file ID `199` est relié par la table directe au chemin runtime
`GroundMap_SelectDungeon`. Pour ce chemin, la reconstruction existante
`docs/pmdred_eu/dungeon_grounds/d04p02/evidence.json` prouve précisément les
ressources matérielles ROM :

| Ressource dungeon | Fonction | Taille/hash pertinent |
|---|---|---|
| `b65fon` | FON matériel | 6 752 octets décompressés, `320c8a7b…c4459b6` |
| `b65cel` | CEL | 4 500 octets décompressés, `068b915a…4cca4ffc` |
| `b65emap0` | EMAP spécial | 576 octets décompressés, `c53dfa87…49ab8b7` |
| `b65pal` | PAL GBA | `5a3e4485…c5db2a4` |
| `b65canm` | CANM | 32 records, 16 actifs, racine `6e9681b2…9ed462` |

Le bundle direct conserve la composition EMAP 24×24, les chunks runtime et la
collision ROM. Il a été régénéré indépendamment et validé : 27 relations,
204 streams AT4PX et 131 frames.

Ancien travail retrouvé :

- `RESERVE/pmdred_direct/grounds/d04p02.rsground` et
  `RESERVE/pmdred_direct/tiles/d04p02_DirectBase.tile` — candidat exact de la
  voie dungeon-backed, toujours staging ;
- `RESERVE/red_grounds/d04p02.rsground` et
  `RESERVE/red_tiles/d04p02_Base.tile` — ancien inventaire, explicitement non
  réutilisé comme autorité de la voie directe ;
- `Data/Ground/sinister_woods_clearing.rsground` et
  `Content/Tile/SinisterWoodsFinalCanonical_Base.tile` — restitution historique
  active de l'ancien agent, mais pas le candidat direct `d04p02` certifié par le
  bundle ROM dungeon-backed.

Il n'existe pas de `Data/Ground/d04p02.rsground` live dans l'état actuel : le
candidat exact reste bien sous `RESERVE/pmdred_direct/`.

## 3. Données de donjon procédural Sinister Woods

`pret/pmd-red` confirme la source gameplay, sans fournir dans ce checkout un
fichier de tileset PMD Red équivalent au `BPL/BPC/BMA` Ground :

- `data/dungeon/SinisterWoods/floor_id.json` : 13 tables de floors ;
- `data/dungeon/SinisterWoods/pokemon_found.json` : rencontres et probabilités ;
- `data/dungeon/SinisterWoods/main_data.inc` : données binaires de tables ;
- `include/constants/dungeon.h` : `DUNGEON_SINISTER_WOODS = 3` ;
- `include/constants/cutscenes.h` : trois états
  `ATTEMPT1`, `ATTEMPT2`, `POSTSTORY` ;
- `include/constants/ground_place.h` : place dungeon Sinister Woods.

La ROM et le manifeste prouvent donc deux niveaux distincts :

1. les Grounds/cinématiques D04P01/D04P02 et leurs ressources graphiques
   identifiables ;
2. le donjon procédural ID 3, ses tables, son compteur d'étages et son chemin
   matériel `b65*` pour le Ground direct.

Le porteur PMDO procédural ne doit pas confondre le Ground fixe D04P02 avec la
reconstruction de tous les étages générés du donjon.

## 4. Provenance exacte des assets actuellement signalés

### 4.1 `relic_forest_blob_*`

Ces six maps ne proviennent pas de la ROM PMD Red EU ni des ressources `D04P01`
/`D04P02` :

- `Data/Map/relic_forest_blob_*.rsmap` possède six hashes verrouillés par
  `tools/test_relic_forest_blob_dependencies.py` ;
- `Content/Tile/Relic_Forest_Blob_*.tile` fournit les six feuilles associées ;
- `Data/Zone/relic_forest.json` les charge encore par cinq `LoadBlobStep` ;
- l'audit précédent a démontré que `Data/Zone/gloomy_forest.json` les chargeait
  aussi par trois étapes clonées, soit 18 références étrangères ;
- la correction de câblage de ce checkout retire ces trois étapes de
  `gloomy_forest` ainsi que ses trois `ReverseRelicForest`, sans toucher à la
  zone Relic Forest ;
- `docs/pmdred_eu/narrative_migration/relic_forest_blob_regression/REPORT.md`
  donne explicitement la provenance historique : commit PMDO/New Era
  `55860b9a5eb48697a3cea3a8bdfce5f0529d6141`, restauration des six maps oubliées
  de Relic Forest.

Conclusion : `relic_forest_blob_*` est **NEW_ERA_NATIVE / RELIC_FOREST**, pas
`PMD_RED_EU_CANON`. Sa résolution technique PMDO est validée pour Relic Forest
et elle ne constitue plus une dépendance runtime de Sinister Woods. Les six
maps et leurs six sheets restent conservés parce que Relic Forest les utilise ;
la preuve complète de séparation et de transitivité est
`SINISTER_WOODS_RELIC_FOREST_SEPARATION_2026-08-18.md`.

### 4.2 `treeshroud_forest_1_*`

La correspondance actuelle est :

- avant promotion, `Data/Zone/gloomy_forest.json` →
  `treeshroud_forest_1_floor/wall/secondary` ; depuis la promotion contrôlée,
  la zone utilise `sinister_woods_b41_floor/wall/secondary` et la feuille
  `SinisterWoodsB41`, sous namespace propre ;
- assets physiques de la source PMDO restaurée :
  `Content/Tile/TreeshroudForest1.tile`,
  `Data/AutoTile/treeshroud_forest_1_*.json`,
  `Content/Music/Treeshroud Forest.ogg` ;
- ces assets sont dans DumpAsset, pas dans le manifeste ROM Ground EU ;
- les mêmes autotiles sont utilisés par plusieurs autres zones PMDO et par des
  réserves (`relic_forest`, `new_era_zone_03`, etc.).

Hashes DumpAsset relevés :

- `TreeshroudForest1.tile` :
  `b9d08bd6cf1aeab3c4822512cdd1d7ca3971aedfe4a41ee726bedae562f25bfa` ;
- `treeshroud_forest_1_floor.json` :
  `595f352478b72e381f62743183d3943f1efcb8fad942f01a1aa14cfa701998b3` ;
- `treeshroud_forest_1_wall.json` :
  `1da6b6eb054718ba0e2345d3bb1365574cc1c2b5f77d193b9021ffc61550d3b9` ;
- `treeshroud_forest_1_secondary.json` :
  `75603b88a9646732000908c4a7e2b2fc86c3211473acd1bd25e8c5b1dc1b52d7`.

Conclusion : `treeshroud_forest_1_*` est **PMDO_NATIVE / DumpAsset**, mais la
chaîne actuelle ne possède pas encore une preuve ROM EU établissant que ce
triplet est le matériau graphique exact du donjon GBA ID 3. Son nom apparaît
dans le dépôt comme un autotile PMDO réutilisé, pas comme une référence vers
`D04P01`, `D04P02` ou `b65*`.

## 5. Verdict de provenance

| Élément | Provenance démontrée | Statut canonique PMD Red |
|---|---|---|
| D04P01 BPL/BPC/BMA | ROM EU, map-file 198 | `PMD_RED_EU_CANON`, Ground graphique validé |
| D04P02 BPL/BPC/BMA | ROM EU, map-file 199 | `PMD_RED_EU_CANON`, Ground direct/legacy séparé |
| b65 FON/CEL/EMAP/PAL/CANM | ROM EU, dungeon ID 3 | `PMD_RED_EU_CANON`, direct dungeon path validé |
| `floor_id.json` / spawns | pret/pmd-red technique verrouillé | `PMD_RED_EU_CANON` pour données gameplay |
| `SinisterWoodsFinalCanonical_Base` | ancien travail/rip Ground | preuve visuelle historique, pas équivalence dungeon procédurale complète |
| `relic_forest_blob_*` | ancien contenu Relic Forest, commit 55860 | `NEW_ERA_NATIVE`, non canonique Sinister Woods |
| `treeshroud_forest_1_*` | DumpAsset PMDO natif, conservé pour Relic/New Era | non canonique Sinister Woods |
| `sinister_woods_b41_*` / `SinisterWoodsB41` | ROM EU b41 + adapter PMDO CANM, promotion unique | matériau procédural Sinister Woods promu, runtime validé |

## 6. Conséquence et mise à jour de promotion

L'audit ne conclut plus à une absence de données ROM. Les données graphiques
ROM existent pour les Grounds D04, pour la ligne finale `b65*` et pour les
lignes procédurales `b41*`. La comparaison a démontré que Treeshroud n'est pas
équivalent à b41.

La route correcte a été exécutée :

- conserver les BPL/BPC/BMA D04 et le bundle direct déjà validés ;
- dériver le matériau b41 depuis la ROM avec provenance, CEX, palettes et CANM ;
- promouvoir le matériau sous `SinisterWoodsB41` et `sinister_woods_b41_*`, pas
  sous les noms Treeshroud partagés ;
- conserver les six blobs Relic Forest et tous leurs consommateurs intactes ;
- valider l'index, le runtime des segments 0/1/3 et la régression Relic Forest.

Preuve : `docs/pmdred_eu/dungeon_grounds/SINISTER_WOODS_B41_PROMOTION_2026-08-19.md`.
Les cinématiques, acteurs et chaînes narratives PMD Red complètes restent une
étape séparée et non certifiée.

Aucune suppression, substitution ou régénération PNG des assets partagés
Treeshroud n'a été effectuée.
réalisée pendant cet audit.
