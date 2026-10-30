# État de conversion du catalogue PMDO

## Décision de finition retenue

Le seuil retenu est une **carte d’exploration PMDO** : terrain natif, tuiles résolues, grille de collisions, marker d’entrée et trajet praticable. Une sortie/transition est ajoutée seulement si les sources la prévoient. Aucun tracé, collision, warp ou gameplay ne sera inventé à partir d’un simple aperçu ou d’un ORA.

## Inventaire statique des archives épinglées

Le catalogue contient **394 aperçus/pages** et **315 archives**. L’inspection des ZIP/ORA a trouvé :

| Catégorie de structure | Archives | Interprétation |
|---|---:|---|
| Paquets PMDO autonomes (`Mod.xml`, `index.idx`, tiles et Ground) | 109 | Format natif complet; cela ne certifie pas les collisions ni le gameplay. |
| Ground + tiles, sans `Mod.xml` et/ou index autonome | 30 | Fragments PMDO à compléter ou à fusionner après vérification de leurs dépendances. |
| Sources de calques/images (PNG/ORA) sans Ground autonome | 128 | Reconstruction PMDO requise; aucune collision ne sera déduite sans source de conception. |
| Bundles de ressources seulement | 5 | Tuiles/fonds sans Ground vérifié. |
| Autres livrables/images | 43 | Association à une carte et contenu à examiner. |

Dans les archives, il y a **397 occurrences de fichiers `.rsground`**, soit **280 contenus distincts** par SHA-256 et 360 chemins de Ground distincts (plusieurs versions/packages se recouvrent). Ces nombres ne sont donc ni 397 cartes uniques, ni 394 cartes déjà jouables.

### Contrôles statiques sur les 397 Ground

Les contrôles lisent les JSON natifs, les grilles de collision, markers et références dans les ZIP. Les résultats qui nécessitent une revue (catégories susceptibles de se chevaucher) sont :

- **208** occurrences sont assemblées sous le namespace `destiny` et chargées par PMDO 0.8.12.0 (**208/208 PASS** au test natif headless décrit ci-dessous). Parmi elles, 207 passent les filtres conservateurs natifs; la 208e est la Zone Bassin Chauffant, ajoutée après vérification de ses deux accès source. Son marker `entrance_sud` reste intact et un alias canonique `entrance` reprend exactement le même collider. Ce résultat certifie la désérialisation, pas la correspondance visuelle des collisions ni la navigation effective en jeu.
- Dans les **208** Ground du package, **13** portent un marker de sortie explicitement nommé. Douze sont sur case marchable et reliées à l’entrée; l’une (`sortie_nord` de l’Île flottante Zénith) est bloquée et reste signalée pour revue, sans déplacement ni warp. Les **195** autres n’ont pas de marker de sortie reconnu. Le lot d’exploration 01 contient neuf sorties canoniques vérifiées; la Zone Bassin Chauffant ajoute une sortie nord source, sans transition automatique.
- Les **189 occurrences hors package** se répartissent en **115 anciennes versions** (66×0.7.15.1, 44×0.7.4.0, 5×0.8.9.0) à migrer et retester, et **74 Ground 0.8.12.0** qui échouent à au moins un filtre conservateur (collision entièrement libre, entrée non reconnue/bloquée ou ressource manquante). Ces catégories se chevauchent comme l’indique l’audit détaillé dans le JSON.
- **173** ont une grille dont toutes les cases ont `Tags = 0` (aucun obstacle encodé); **14** n’ont pas de marker d’entrée reconnu; **10** ont une référence de tileset absente de la même archive; **2** ont une entrée bloquée ou située hors de la grille. Une contre-vérification des **460 références de fond** dans les **139 archives Ground** ne trouve aucune ressource de fond absente.
- **382** n’ont pas de marker nommé `exit`, `sortie`, `destination`, `warp` ou `door` (détection aussi des suffixes directionnels comme `sortie_nord`). Quinze occurrences ont un nom d’accès/sortie explicite, dont deux markers de scène cinématique qui ne sont pas inclus dans le catalogue jouable.

L’absence de marker de sortie n’est pas automatiquement une erreur si la conception décrit une scène terminale; l’absence de collisions libres n’est pas une preuve que le dessin est praticable. Chaque cas doit être tranché à partir des sources de conception. Le test natif valide le chargement PMDO, pas le rendu GPU, l’éditeur, les transitions de quête ou les collisions comparées au dessin.

## Premier lot assemblé

`build_exploration_batch01.py` produit l’archive ignorée par Git :

`exports/pmdo/PMD_Destiny_Exploration_Lot01_0812.zip`

Elle réunit les neuf Ground vérifiés : **RAZ1, RAZ2, RAZ3, EAF1, RAF1, RAF2, RAF3, CPL1 et PVC1**. Le builder épingle les archives sources et leurs blob-SHA, conserve les Ground et `.tile` byte pour byte, rassemble les scripts sous `Data/Script/destiny/`, puis reconstruit un index PMDO à partir des tuiles réellement incluses. Les collisions n’ont pas été retouchées; les scripts sources sont des modules vides/no-op et aucun warp n’est ajouté.

Validations réussies sur le package généré : CRC de l’archive, XML/namespace `destiny`, 9 Ground JSON PMDO 0.8.12, 104 tilesets/index-nodes cohérents, références de frames résolues et chemin libre entre les markers d’entrée et de sortie pour chaque carte. Le chargeur natif de PMDO 0.8.12 a ensuite chargé les **9/9 Ground** (dimensions, `TexSize`, calques et entités vérifiés), via `source/pmdo_runtime/verify_destiny_batch01.py`. Taille ZIP : environ 13,3 Mo. **Ce test headless ne valide ni le rendu graphique, ni l’éditeur, ni les transitions de quête.**

## Catalogue assemblé et chargé — 208 Ground PMDO 0.8.12

Le builder `build_playable_catalogue_0812.py` assemble les 208 occurrences candidates dans :

`exports/pmdo/PMD_Destiny_Catalogue_Exploration_0812.zip`

Le ZIP fait **215 007 662 octets**, rassemble **1 170 tilesets** et six fonds issus de **101 archives**, et fournit 208 identifiants uniques `AssetName` tout en conservant les **121 contenus Ground distincts** et leurs provenances. Les cartes, tuiles et scripts source sont inclus; les grilles de collision sont intactes. Seul le marker PMDO `entrance` du Bassin Chauffant est un alias au collider source `entrance_sud`; aucun point de sortie ne reçoit de warp. Le manifeste, les crédits et les rapports sont intégrés au ZIP.

Le binaire officiel PMDO **0.8.12.0** a chargé tous les Ground via `DataManager.Instance:GetGround`, en 11 lots : **208/208 PASS**. Dimensions, `TexSize=1` et nombre de calques ont été vérifiés. Rapport détaillé : `source/pmdo_runtime/destiny_catalogue_208_ground_load_results.tsv`; vérificateur reproductible : `source/pmdo_runtime/verify_destiny_catalogue_0812.py`. SHA-256 du ZIP testé : `31578a4312f30a9e7ab5889b9a13e540a0aed68365ab802692a0955bae27386a`. Le manifeste signale **103 occurrences (45 contenus Ground)** dont les notes source demandent une revue; une occurrence supplémentaire a un marker de sortie bloqué. Ces cas ne sont pas certifiés jouables.

Cette réussite certifie le chargement/désérialisation native uniquement. Elle **ne certifie pas encore** le rendu des textures et fonds, la justesse des collisions face au dessin, la progression/navigation effective, les transitions ou l’édition en jeu. Le manifeste signale **103 occurrences (45 contenus Ground)** dont les notes source demandent une revue, plus un marker de sortie bloqué; elles ne sont pas certifiées jouables. Les **195 cartes sans sortie reconnue** restent sans warp; l’Île flottante Zénith conserve aussi un marker `sortie_nord` bloqué. Les **189 autres occurrences Ground** (dont 115 versions anciennes) et les sources graphiques sans Ground ne sont pas encore converties. Le catalogue complet n’est donc pas terminé.

## Revue ciblée des sources 0.8.9.0 et des assets retrouvés

Deux designs plus anciens disposent d’atlas `.tile` exploitables, mais ne sont pas simplement renommés en 0.8.12 :

- `altere_pond.rsground` existe dans quatre archives, sous un contenu Ground identique (`665f18e…`). Un des ZIP (Antre Harmonie V3) fournit les neuf feuilles référencées; les headers natifs et **27 196** coordonnées de frames ont été vérifiés. Ce Ground contient toutefois un MapChar, un spawner, deux GroundObjects et deux markers; les archives n’ont pas de `Mod.xml`, d’`index.idx` autonome ni de script Ground. Les autres copies n’apportent pas toutes les feuilles. Il reste à migrer/tester le Ground et à intégrer ses dépendances, donc il n’est pas inclus.
- `vast_steppe_entrance.rsground` est un autre Ground 0.8.9.0 distinct. Ses six feuilles et **6 981** coordonnées de frames valident statiquement; le marker source `Main_Entrance_Marker` tombe sur une case marchable. Mais l’archive de référence n’a ni `Mod.xml`, ni index ni script et le Ground porte trois spawners et trois GroundObjects. Il n’est pas certifié jouable; son nom reste **Vast Steppe Entrance**, pas une correspondance avec Vallons Fleuris.
- Les deux variantes `cliffdaytest` de la cinématique Pichu ont bien un marker `Dazzling_Entry_South`, mais aussi un MapChar, trois spawners et des scripts de scène qui dépendent de `common`. Elles restent dans le registre, hors du package d’exploration tant que leurs dépendances/scénario ne sont pas revus.

Ces contrôles de fichiers et de coordonnées ne remplacent pas une migration et un chargement/runtime en jeu; aucun de ces designs n’a été ajouté au ZIP.

## Écran-titre PMD Destiny

La référence demandée est épinglée dans `source/pmdo_cote/TITLE_SCREEN_REFERENCE.md` : note de provenance au commit `053072d8064438e3bd6b278416e4af18c9d605fc` et rendu compagnon au commit `0e691d647a661f3c2a79984eda2d39686d4f0dfc`. Le ZIP d’exploration n’inclut pas ces ressources ni ne change l’écran de démarrage; leur intégration reste réservée à la future fusion dans `town02`. La source les marque non testées dans le moteur.

## Suite sans approximation

Les autres Ground et sources graphiques restent à traiter, sans suppression du catalogue. Pour chaque carte restante, il faut établir depuis son README, ses calques codés, son masque ou un plan explicite : la zone marchable, obstacles, entrée et éventuelle sortie/liaison. Les fragments `Ground + tiles` seront ensuite empaquetés en respectant leur version et leurs dépendances. Les aperçus/ORA sans ces informations restent **bloqués pour revue**, plutôt que transformés en faux niveaux jouables.

Les cartes préparées dans ce dépôt sont une étape **avant** leur intégration dans `town02`; le namespace technique du lot est `destiny`. Les attributions d’origine sont conservées dans `CREDITS.md` dans l’archive.
