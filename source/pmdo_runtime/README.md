# PMDO installé depuis RUNTIMEPMDO — tests natifs

## Provenance vérifiée

- Dépôt : `meromoonmeri/RUNTIMEPMDO`.
- Commit : `61c005e1dc9fd4eee6e6e7fcde77364de33d291e`.
- Archive : `pmdc-linux-x64.zip`, **77 503 089 octets**.
- SHA-256 : `c64f72afd27b96d5a870f71e44d05ee1e952909e86b9a53d0479163763c61577`.
- Ce hash correspond au champ `digest` de l’asset officiel PMDC v0.8.12, ID `406230348`.
- Version observée dans le journal du vrai exécutable : **0.8.12.0**, .NET **8.0.26**.

Le ZIP est téléchargé comme blob Git par l’API GitHub : cela évite l’hôte des releases qui échouait. Les fichiers `PMDO/PMDO` directement présents dans le dépôt sont des pointeurs LFS ; c’est bien l’archive complète qui a été utilisée.

Installation locale, ignorée par Git : `.cache/pmdo-runtime/engine/PMDO/`.

## Ressources de base

L’archive du moteur ne contient pas le jeu complet. Le premier lancement signalait `Base/PathParams.xml` absent. Les ressources ont été récupérées dans `audinowho/DumpAsset`, commit `3e767571f9dd94270b848b3a73de9bec2553a2eb`, par l’API tarball, puis extraites dans l’installation de cache. Le manque des ressources de base est résolu.

Ne pas archiver dans le dépôt de création les centaines de Mo de ressources, les exécutables, les dépendances ni les guides générés par le test.

## Tests exécutés

| Test | Résultat |
|---|---|
| CRC du ZIP et hash comparé à la release officielle | PASS |
| `./PMDO -help` | PASS, code 0 |
| `./PMDO -dev` avant ressources | Échec : Base/PathParams.xml absent |
| `./PMDO -dev` après ressources | Crash natif, code 139 |
| `-dev` avec chemin des bibliothèques embarquées et SDL offscreen | Crash natif, code 139 |
| `./PMDO -guide` | Lecture des données et génération de trois guides ; arrêt au timeout pendant les rencontres, pas un test complet |
| Chargeur Ground réel, sans affichage | **PASS : 20 cartes**, code 0 |

Le crash graphique n’est pas encore diagnostiqué. L’absence d’un environnement d’affichage fonctionnel est à traiter, mais ne suffit pas à prouver la cause exacte du crash. Aucun rendu de carte, déplacement ou animation n’a été validé par ce test.

## Test du vrai chargeur des cartes

`verify_ground_runtime.py` utilise uniquement la copie de cache. Il extrait le pack livré dans les MODS de cette copie et ajoute temporairement `test_ground_load.lua` au script de démarrage. Le script appelle réellement :

```lua
DataManager.Instance:GetGround(assetName)
```

Ce n’est plus le lecteur Python de JSON : le chargeur, le binder et les callbacks de désérialisation sont ceux du binaire PMDO 0.8.12. Les vingt cartes du pack `cotes_metano_abyss_0812_pmdo.zip` ont été chargées.

Assertions : carte non nulle, dimensions attendues, `TexSize=1`, neuf calques, présence d’un calque d’entités. Le hook initialise `GraphicsManager.DungeonTexSize=3`, valeur nécessaire à la reconstruction de la grille de collision normalement initialisée avec les graphismes. **Il n’initialise pas de GPU et ne charge pas les textures dans le moteur graphique.** Il quitte ensuite le processus, avant la génération du guide.

Le fichier `Data/Script/origin/main.lua` original est restauré après l’essai, y compris si la commande échoue. Le test ne modifie ni l’archive livrée ni les scripts du projet utilisateur.

```sh
python source/pmdo_runtime/verify_ground_runtime.py
```

Résultats : `ground_load_results.tsv`. Contexte et limites : `runtime_status.json`.

## Portée

Cette validation concerne le **dernier pack de vingt Ground déjà livré**, pas les sept nouvelles falaises et trois entrées encore en préparation. Elle apporte une preuve de désérialisation native ; elle ne remplace pas le test visuel dans l’éditeur. Les anciens rapports `native_runtime_tested: false` sont les rapports historiques de construction, antérieurs à cet essai : ce rapport est leur complément, pas une certification rétroactive de rendu.

## PMD Destiny — lot d’exploration 01

`verify_destiny_batch01.py` installe le ZIP généré dans cette copie de cache, injecte temporairement un hook Lua, puis lance le binaire réel avec `-guide -quest destiny`. Le hook appelle `DataManager.Instance:GetGround` pour les neuf cartes et vérifie dimensions, `TexSize`, nombre de calques et couche d’entités. Il restaure `Data/Script/origin/main.lua` dans un bloc `finally`.

Résultat : **9/9 PASS** dans `destiny_batch01_ground_load_results.tsv`. Le ZIP contient cette preuve dans `destiny/Documentation/runtime_ground_load_results.tsv` et marque `runtimePMDOTested: true` dans son manifeste. Le test est headless : il ne valide ni GPU/textures à l’écran, ni éditeur, ni transitions de quête.

```sh
python3 source/pmdo_runtime/verify_destiny_batch01.py
```

## PMD Destiny — catalogue 0.8.12, 208 Ground

`verify_destiny_catalogue_0812.py` installe l’archive du catalogue de candidates puis charge tous ses Ground dans le vrai binaire PMDO 0.8.12.0, en onze lots de vingt maximum. Le hook Lua appelle `DataManager.Instance:GetGround` et vérifie l’objet, la grille, `TexSize=1` et le nombre de calques attendu. Le script de démarrage original est restauré après chaque processus, même en cas d’échec.

Résultat actuel : **208/208 PASS**, soit 100 % des Ground contenus dans l’archive; rapport par carte : `destiny_catalogue_208_ground_load_results.tsv`, également inclus dans le ZIP sous `destiny/Documentation/runtime_ground_load_results.tsv`. Le manifeste du ZIP marque `runtimePMDOTested: true`. SHA-256 du ZIP testé : `31578a4312f30a9e7ab5889b9a13e540a0aed68365ab802692a0955bae27386a` (**215 007 662 octets**). Le précédent essai 207/207 (`destiny_catalogue_207_ground_load_results.tsv`) est conservé comme rapport historique.

```sh
python3 source/pmdo_runtime/verify_destiny_catalogue_0812.py
```

Cette preuve concerne les 208 Ground du prototype historique; elle ne valide ni le rendu, ni les collisions contre le dessin, le spawn/navigation, l’éditeur ou les transitions. Elle ne couvre pas les 189 autres occurrences qui restaient hors de ce prototype. Le périmètre source a depuis été réconcilié à 262 occurrences : un overlay partiel de 246 Grounds avec assets, puis une quête-cartothèque autonome `destiny` de 246 cartes, ont été produits et passés aux probes natifs. Les 16 restantes sans Ground sont consignées sans substitut; le final de 262 reste incomplet et aucune installation n’a été faite dans le PMDO utilisateur.

## Vérificateur d’archives Ground à métadonnées variables

`verify_destiny_ground_archive_0812.py` est le nouveau probe générique à utiliser pour les archives candidates, notamment celles qui mélangent plusieurs versions sérialisées ou des `TexSize` différents. Pour chaque carte, il lit `Ground.Version`, `Object.TexSize`, les dimensions logiques de `Layers[*].Tiles` et le nombre de calques; il vérifie ces valeurs contre les champs `groundVersion`/`Version`, `texSize`, `grid` et `layers` du manifeste quand ils existent. Il ne suppose pas `TexSize=1`. Le hook Lua initialise toujours `GraphicsManager.DungeonTexSize=3` (réglage requis du chargeur headless), puis vérifie le `TexSize` propre à chaque Ground.

Les Ground distincts sont testés par groupes de 20 maximum. L’archive n’est jamais modifiée : les fichiers sont copiés dans une quête jetable `destiny_ground_archive_probe` sous `.cache/pmdo-runtime`; un ID dangereux, homonyme conflictuel ou différent de `Object.AssetName` peut être aliasé uniquement dans cette copie de test. Le script restaure `Data/Script/origin/main.lua` après chaque processus et supprime uniquement son MOD temporaire. Les doublons identiques restent des lignes séparées du rapport et pointent vers le même test runtime.

Résultats ici : **208/208 PASS en 11 lots** pour le ZIP catalogue actuel (`destiny_ground_archive_208_runtime_results.tsv`); **126/126 PASS en 6 lots** pour les Ground extraits des ZIP candidats (`destiny_zip_candidates_ground_runtime_results.tsv`); et **246/246 PASS en 13 lots** pour l’assemblage de probe Ground-only des 262 occurrences (`destiny_candidate_246_ground_runtime_results.tsv`). Ce dernier staging conserve 262 lignes de provenance, dont 246 Grounds à IDs runtime distincts; les 13 occurrences asset-blocked et les 3 Grounds générés sans sortie restent consignés sans placeholder. Les trois reconstructions générées dont le hash ne correspond pas à l’inventaire sont incluses uniquement comme variantes explicitement signalées (`generated_030/031/035`), jamais comme reconstructions exactes.

Le probe 246 couvre les Versions 0.7.4.0, 0.7.10.0, 0.7.12.0, 0.7.15.1, 0.7.17.0, 0.8.9.0, 0.8.11.0 et 0.8.12.0; il a lu 243 cartes à `TexSize=1` et 3 à `TexSize=3`. Un test **séparé** a chargé les mêmes 246 Grounds avec `TileGuide.Load`, **1 059 TileSheets**, et résolu **2 773 093 coordonnées uniques (0 manquante, 246/246 cartes PASS)**; 74 frames sans nom de feuille sont des frames transparentes/vides, exclues des coordonnées référencées. LuminousSpring et LuminousSpringAnim sont les assets de base PMDO 0.8.12 (statut `base` dans les sources), pas des substituts inventés. Rapports TileGuide : `destiny_candidate_246_tileguide_runtime_results.tsv` et `destiny_candidate_246_tileguide_summary.json`; staging exact sous `.cache/destiny-recovery/candidate-246-tileguide/`, assemblé par `build_destiny_246_tileguide_stage.py`. Un essai ciblé séparé avait aussi chargé `Brine_Cave_Entrance` (0.8.11.0, 27×21) et `luminous_spring` (0.7.4.0, 25×25), les deux avec `TexSize=3`. L’assembleur Ground-only précédent est `build_destiny_246_ground_probe_input.py`; son staging se trouve sous `.cache/destiny-recovery/candidate-246-ground-probe/`.

Ces essais confirment que le nouveau probe ne confond pas la grille collision brute (multipliée par TexSize) avec les dimensions logiques du Ground. Le staging de probe est **Ground-only et non installable** : il ne contient pas les TileSheets/fonds/scripts du candidat et ne teste pas leur chargement/rendu. Une quête-cartothèque autonome `destiny` est maintenant produite dans `PMD_Destiny_Map_Quest_246_0812.zip`; l’archive exacte passe 246/246 Ground en 13 lots, et le vrai DataManager charge `exploration_cartes` avec 246 `GroundMaps`/0 segment narratif. Résultats : `destiny_map_quest_246_zip_ground_runtime_results.tsv` et `destiny_map_quest_246_zone_runtime_results.tsv`. Le final de 262 reste incomplet (16 sources sans Ground); le ZIP n’a pas été copié dans une installation PMDO utilisateur, absente du workspace.

```sh
# Recréer le staging Ground-only depuis l’inventaire et les sources déjà récupérées,
# puis tester ses 246 occurrences en 13 lots. Ce staging n’est pas un overlay.
python3 source/pmdo_runtime/build_destiny_246_ground_probe_input.py
python3 source/pmdo_runtime/verify_destiny_ground_archive_0812.py --package .cache/destiny-recovery/candidate-246-ground-probe --expected-count 246 --batch-size 20 --results source/pmdo_runtime/destiny_candidate_246_ground_runtime_results.tsv

# Ajouter les assets source et tester séparément TileGuide.Load + coordonnées.
python3 source/pmdo_cote/build_destiny_246_tileguide_stage.py
python3 source/pmdo_runtime/verify_destiny_246_tileguide_0812.py

# Le vérificateur Ground générique accepte aussi un ZIP PMDO ou tout dossier extrait.
```

Le rapport TSV donne par occurrence le `Ground.Version`, `TexSize`, dimensions, calques, SHA-256, alias de test éventuel et résultat PMDO. Ce probe valide uniquement la désérialisation native, pas le rendu, l’index TileGuide, les collisions contre le dessin, le gameplay, l’éditeur ou les transitions. Le builder du catalogue ajoute désormais `groundVersion` et `texSize` aux nouvelles lignes de manifeste; les archives existantes restent compatibles, car le vérificateur dérive ces données du JSON Ground.

## PMD Destiny — cinq Grounds source reconstruits depuis une grille vide

`source/pmdo_cote/reconstruct_empty_branch_grounds.py` convertit cinq exports Arena épinglés au commit `c2d77959d87bf334e9603b47df012bc4f1e3dd7a`. Le Ground JSON source déclarait une grille `Tiles` vide, mais les exports contenaient les coordonnées par cellule, atlas, frames, collisions et markers. Le convertisseur réutilise ces données exactes, génère 33 TileSheets natives et ne crée ni géométrie, ni collision, ni sortie, ni warp.

`fetch_empty_branch_source_exports.py` récupère les 48 fichiers source aux hashes GitHub du commit Arena épinglé, uniquement dans `.cache`; il ne modifie ni ne checkout aucune branche. Recréer ensuite le staging reconstruit avec les commandes de `source/pmdo_cote/DESTINY_262_RECOVERY.md`.

`verify_destiny_empty_branch_reconstruction.py` copie le staging dans une quête de test jetable dans `.cache/pmdo-runtime`, appelle le vrai `DataManager.Instance:GetGround`, puis lit l’index natif par `RogueEssence.Content.TileGuide.Load` et vérifie les positions de chaque coordonnée unique référencée. Le hook restaure `Data/Script/origin/main.lua` et supprime le mod temporaire. Il ne dépend pas de `GraphicsManager.TileIndex`, nul dans le démarrage headless testé.

Une réexécution nécessite le runtime PMDO 0.8.12.0 et ses ressources sous `.cache/pmdo-runtime`, décrits au début de ce README.

Résultat : **5/5 Grounds chargés** (96×72; 7, 8, 7, 7 et 9 calques), 33 nœuds d’index lus et **89 875 coordonnées de tuile uniques résolues**, zéro manquante. Résultats reproductibles consignés : `destiny_empty_branch_reconstruction_0812_results.tsv`.

Ce probe ne teste **pas** l’initialisation GPU, le rendu visuel, la fidélité collisions/dessin, les collisions en jeu, le spawn, la navigation, l’éditeur ou les transitions. Les cartes reconstruites conservent `artApproved: false` et `playabilityCertified: false`.

L’inventaire [`../pmdo_cote/destiny_262_inventory.json`](../pmdo_cote/destiny_262_inventory.json) réconcilie 126 ZIP + 39 chemins de branche + 97 Grounds générés = **262 occurrences**, 229 hashes Ground distincts et 33 occurrences dupliquées conservées. Le package Quest autonome `destiny` contient les 246 Grounds disponibles et sa zone `exploration_cartes` passe le probe natif. Treize occurrences restent bloquées par leurs assets source et `generated_002/007/029` n’ont toujours pas de Ground de sortie; le final 262 et l’installation dans le PMDO utilisateur restent en attente.
