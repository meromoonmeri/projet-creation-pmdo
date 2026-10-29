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

Cette preuve porte sur la désérialisation native des Ground. Elle ne valide pas le rendu des images, les collisions contre le dessin, le spawn/navigation en jeu, l’éditeur ni les transitions/liaisons de quête. Les **189 autres occurrences Ground** et les sources graphiques sans Ground restent hors de ce package et nécessitent encore migration ou revue de conception. Le catalogue n’est donc pas complet/jouable de bout en bout.
