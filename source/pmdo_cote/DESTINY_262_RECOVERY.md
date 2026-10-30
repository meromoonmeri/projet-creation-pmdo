# Destiny — état de récupération des 262 entrées

**État au 30 octobre 2026 : l’inventaire des 262 occurrences est réconcilié et le ZIP Quest autonome PMDO 0.8.12 `destiny` est construit avec les 246 Grounds récupérables.** Les 16 sources sans Ground sont conservées dans l’inventaire et explicitement exclues, sans placeholder. Après le build, le ZIP exact a passé le probe natif Ground 246/246, le chargement natif de la zone et l’audit TileGuide des 1 059 feuilles (2 773 093 coordonnées, zéro manquante); son CRC et ses hashes passent également. Le test est headless : aucun rendu graphique, gameplay ou certification de jouabilité. Les anciens probes de candidates restent historiques et sont distingués du rapport post-build attaché au SHA exact du ZIP. Le final 262 reste incomplet.

Le registre détaillé est [`destiny_262_inventory.json`](destiny_262_inventory.json). Il conserve les chemins, commits/blob IDs, hashes Ground, références de tilesets, doublons, statuts de chargement et blocages par entrée. Le contrôle suivi [`verify_destiny_262_inventory.py`](verify_destiny_262_inventory.py) réconcilie le registre et les résultats runtime consignés : `python3 source/pmdo_cote/verify_destiny_262_inventory.py`.

**Reprise du 30 octobre 2026 — écran-titre, ZIP autonome et runtime :** le constructeur [`create_destiny_map_quest.py`](create_destiny_map_quest.py) intègre le composant Destiny décrit dans [`destiny_title_screen_component/`](destiny_title_screen_component/), en conservant le `Mod.xml`/UUID stable et le namespace `destiny`. Le ZIP final embarque le manifeste source (OID Git, SHA-256) et le rapport d’intégration; l’écran-titre a passé les contrôles statiques, mais n’a pas été rendu dans PMDO. Pour les probes post-build, le runtime et ses assets de base ont été restaurés depuis les commits épinglés, uniquement dans `.cache`; aucun binaire ni asset de jeu n’est ajouté à Git. Le package de 232 574 307 octets et ses anciens probes ne décrivent pas le ZIP final courant.

## Réconciliation de l’inventaire

**126 Grounds d’archives + 39 chemins Ground de branche + 97 Grounds générés = 262 occurrences source.** L’inventaire généré contient 98 Grounds; `pmd_destiny_menu_nuit` est l’entrée auxiliaire exclue du total annoncé.

Ces 262 occurrences ne sont pas 262 contenus distincts : le calcul SHA-256 donne **229 contenus Ground exacts** et **33 occurrences supplémentaires de doublons**. Les occurrences et leur provenance ne sont pas fusionnées.

| Source | Occurrences | Contenus SHA-256 distincts | État de récupération |
|---|---:|---:|---|
| Six ZIP d’archives | 126 | 106 | Grounds récupérés exactement; 126/126 occurrences PASS au probe Ground-only PMDO 0.8.12 |
| Chemins Ground de branche | 39 | 26 | 21 Grounds source exacts + 5 grilles vides reconstruites depuis les données carte source; 13 toujours bloquées par assets manquants/non établis |
| Builds générés | 97 | 97 | 50 Grounds reconstruits exactement, 41 sources reconnues dans le prototype par `sourceGroundSha256`, 3 sorties reconstruites aux hashes divergents (probe seulement), 3 sorties originales attendues toujours sans correspondance exacte (candidates non exactes conservées à part) |

L’assemblage de probe Ground-only comprend **246 occurrences** : 126 ZIP + 26 branche (21 exactes et 5 reconstruites) + 94 générées (50 exactes, 41 normalisées à partir d’une source Ground exacte, 3 variantes de hash explicitement signalées). Il conserve les 262 lignes source; les **13 occurrences asset-blocked** et les **3 sorties originales générées sans hash exact disponible** y sont inscrites comme non testables, sans substitut. Leurs candidates non exactes sont conservées dans le rapport `DESTINY_16_RECOVERY.md`, hors de cet assemblage. Les doublons sont conservés sous des IDs de probe distincts. Ces 246 essais ne constituent ni 246 contenus uniques ni une validation de jouabilité. Six Grounds générés ont par ailleurs une entrée sur cellule bloquée ou invalide selon le masque statique.

## Cinq grilles de branche vides reconstruites depuis source

Les cinq exports Arena contenaient déjà une carte 96×72, les couches, coordonnées de tuiles par cellule, atlas et frames d’animation, masque de collision, `Walls` et markers source; seule la grille native `Layers[*].Tiles` du Ground sérialisé était vide. Le convertisseur [`reconstruct_empty_branch_grounds.py`](reconstruct_empty_branch_grounds.py) traduit ces coordonnées exactes et ces atlas `.tile` personnalisés en TileSheets natifs RogueEssence, puis remplit les couches. Il ne déduit ni ne crée topologie, collision, marker, sortie, warp ou scénario.

Le manifeste de construction consigne les empreintes des cinq Grounds source et sorties, les 33 conversions TileSheet, les collisions/markers conservés et l’audit statique. Résultat du probe PMDO 0.8.12.0, conservé dans [`destiny_empty_branch_reconstruction_0812_results.tsv`](../pmdo_runtime/destiny_empty_branch_reconstruction_0812_results.tsv) :

- **5/5 Grounds chargés** en 96×72, avec respectivement 7, 8, 7, 7 et 9 couches;
- **33 nœuds** de TileSheet lus par `TileGuide.Load` natif;
- **89 875 coordonnées uniques** référencées dans les cinq Grounds résolues par `TileGuide.GetPosition`, zéro coordonnée manquante;
- `obstacles`, `Walls` et `Entities` conservés à l’identique; les marqueurs source sont atteignables par BFS statique à quatre voisins.

Résultat : preuve de désérialisation et de résolution d’index seulement. Le mode headless `-guide` ne construit pas `GraphicsManager.TileIndex`; le rendu GPU, la fidélité du dessin, les collisions effectives, le spawn joueur, la navigation et la jouabilité **n’ont pas été testés**. `artApproved: false` et `playabilityCertified: false` demeurent inchangés. Les sorties natives du convertisseur sont un staging ignoré par Git; le résultat de probe et la provenance sont conservés dans le dépôt. Pour recréer ce staging à partir du commit Arena en lecture seule :

```sh
python3 source/pmdo_cote/fetch_empty_branch_source_exports.py
python3 -m venv .cache/destiny-recovery/venv
.cache/destiny-recovery/venv/bin/python -m pip install pillow
.cache/destiny-recovery/venv/bin/python source/pmdo_cote/reconstruct_empty_branch_grounds.py
```

Le test PMDO décrit dans `source/pmdo_runtime/README.md` exige en plus le runtime et les ressources de base dans `.cache/pmdo-runtime`.

## Probe Ground-only natif PMDO 0.8.12 — 246 occurrences

Le staging reproductible est construit par [`build_destiny_246_ground_probe_input.py`](../pmdo_runtime/build_destiny_246_ground_probe_input.py) à partir des 262 lignes de l’inventaire; il est conservé sous `.cache/destiny-recovery/candidate-246-ground-probe/` et est explicitement **non installable**. Le runtime natif a validé **246/246 occurrences en 13 lots (12×20 + 6)**; le rapport complet est [`destiny_candidate_246_ground_runtime_results.tsv`](../pmdo_runtime/destiny_candidate_246_ground_runtime_results.tsv). Chaque occurrence récupérable/reconstruite a son propre `mapId` même quand ses octets Ground sont un doublon. Le probe est lancé avec `GraphicsManager.DungeonTexSize=3` et compare le `Version`, `TexSize`, dimensions logiques et nombre de couches sérialisés pour chaque Ground; il ne fixe pas `TexSize=1`.

Le staging rassemble 126 Grounds ZIP exacts, 21 Grounds de branche exacts, 5 reconstructions depuis les grilles source, 50 builds générés aux hashes attendus, 41 Grounds sources reliés au prototype par `sourceGroundSha256` et 3 sorties générées aux hashes divergents. Ces trois variantes (`generated_030/031/035`) ne sont **pas** qualifiées exactes. Le registre des 262 occurrences conserve séparément les 13 entrées bloquées par assets et `generated_002/007/029`, dont les sorties originales attendues ne sont pas retrouvées à hash exact; trois variantes non exactes sont conservées à part et exclues du staging.

Versions testées : 46 × 0.7.15.1, 179 × 0.8.12.0, 4 × 0.8.9.0, 9 × 0.7.4.0, 3 × 0.7.12.0, 3 × 0.7.17.0, 1 × 0.8.11.0 et 1 × 0.7.10.0. `TexSize` : 243 × 1 et 3 × 3. Les Grounds `TexSize=3` `Brine_Cave_Entrance` (0.8.11.0, 27×21) et `luminous_spring` (0.7.4.0, 25×25) avaient aussi PASS individuellement dans l’essai ciblé précédent.

Le staging séparé `candidate-246-tileguide` charge **1 059 TileSheets** et résout **2 773 093 coordonnées uniques, zéro manquante, 246/246 Grounds PASS**; 74 frames avec `Sheet` vide sont des frames transparentes/vides et ne nomment aucun tileset. Les `.tile` et `.dir` sont sourcés depuis leur archive/commit/build ou les ressources PMDO de base (`LuminousSpring*` a le statut `base`), jamais depuis un dessin inventé. Rapports : [`destiny_candidate_246_tileguide_runtime_results.tsv`](../pmdo_runtime/destiny_candidate_246_tileguide_runtime_results.tsv) et [`destiny_candidate_246_tileguide_summary.json`](../pmdo_runtime/destiny_candidate_246_tileguide_summary.json). Cela ne certifie toujours pas le rendu, la correspondance dessin/collision, spawn, collisions en jeu, navigation, sortie, warp ou jouabilité. Les Grounds anciens ne sont pas pour autant migrés.

Un **overlay candidat partiel de 246 occurrences** a été construit à `exports/pmdo/PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip` : **220 654 226 octets, SHA-256 `43ca364de835f46816f315d6c4bb9aeb4edb6b351ecf7a3d05caa074e0ddef10`, CRC PASS, 246 Grounds, 1 059 TileSheets, 33 fonds, sans `Mod.xml`**. Son probe Ground natif passe 246/246 en 13 lots : [`destiny_candidate_246_overlay_ground_runtime_results.tsv`](../pmdo_runtime/destiny_candidate_246_overlay_ground_runtime_results.tsv). `installer_destiny_overlay.validate_overlay` accepte ses 246 Grounds et compare les Versions/TexSize par carte (8 Versions, TexSize 1/3); les 1 092 assets Tile/BG concordent par SHA-256 avec le staging TileGuide.

Le package **standalone `destiny`** final est [`PMD_Destiny_Map_Quest_246_0812.zip`](../../exports/pmdo/PMD_Destiny_Map_Quest_246_0812.zip), **234 272 499 octets, SHA-256 `e3b2e559697bd682dd718573623a9c0dd30f60e24da62a820b7001810c2cc26f`, CRC PASS**. Il contient le `Mod.xml` Quest PMDO 0.8.12.0 (namespace `destiny`, UUID stable `1da28568-6363-5c51-8caa-9430b42862f0`), l’écran-titre Destiny, les 246 Grounds et une zone `exploration_cartes` qui les liste tous.

Contrôle statique indépendant du ZIP final : CRC des **1 361 membres**, SHA-256 conforme pour **246/246 Grounds** et **1 339/1 339 fichiers du manifeste**, 1 059 TileSheets, 33 fonds de carte + 3 fonds d’écran-titre, identité et zone correctes, inventaire de 262 occurrences et 16 exclusions sans placeholder. Tests unitaires statiques de l’intégration écran-titre, de l’overlay et du probe metadata : **13/13 PASS**.

**Probes post-build PMDO 0.8.12 :** le vrai `DataManager.Instance:GetGround` a chargé **246/246 Grounds du ZIP exact en 13 lots**; les membres `Mod.xml` et `Data/Zone` extraits du ZIP ont chargé `exploration_cartes` avec 246 `GroundMaps` et 0 segment; `TileGuide.Load/GetPosition` a chargé **1 059 nœuds** et résolu **2 773 093 coordonnées uniques, zéro manquante, 246/246 cartes PASS**. Le test TileGuide lit le tree de staging ayant servi à créer le ZIP; le contrôle SHA-256 final confirme que tous les payloads manifestés dans l’archive correspondent à ce tree. Rapport post-build lié au SHA exact : [`../pmdo_runtime/destiny_final_quest_246_runtime_summary.json`](../pmdo_runtime/destiny_final_quest_246_runtime_summary.json); résultats détaillés : [`../pmdo_runtime/destiny_final_quest_246_zip_runtime_results.tsv`](../pmdo_runtime/destiny_final_quest_246_zip_runtime_results.tsv), [`../pmdo_runtime/destiny_final_quest_246_zone_runtime_results.tsv`](../pmdo_runtime/destiny_final_quest_246_zone_runtime_results.tsv) et rapports TileGuide correspondants.

`Documentation/QUEST_BUILD.json` dans le ZIP indique `runtimeValidation.statusAtBuild=NOT_RUN`, car le constructeur n’exécute pas PMDO. Ce statut décrit le build; le rapport externe ci-dessus consigne le test **post-build** du ZIP au SHA donné. Les probes sont headless : le GPU, le rendu de l’écran-titre, l’éditeur, les collisions dessinées et la jouabilité ne sont pas certifiés. La cartothèque n’ajoute ni scénario, ni zone narrative, ni placeholder; les 13 sources de branche bloquées et `generated_002/007/029` restent documentés comme exclus. Aucun fichier n’a été installé dans un PMDO utilisateur.

Autres constats statiques conservés :

- les 126 Grounds ZIP ont un marqueur `entrance`; 106 sont entièrement marchables d’après leurs tags et 20 contiennent des cellules bloquées. Six portent aussi le marqueur `donjon_seuil`, qui n’a pas été interprété comme une sortie;
- les 97 Grounds générés ont un marqueur d’entrée; 91 de ces entrées tombent sur une cellule marchable, 6 sur une cellule bloquée. Quatre cartes portent un marqueur `sortie` atteignable selon le masque statique, mais aucune transition n’a été testée;
- **aucune carte des 262 n’est certifiée jouable.** Aucun spawn, masque de collision, chemin ou warp n’a été inventé ou retouché pour faire passer un test.

## Archives examinées et candidats de tilesets

Les 242 blobs ZIP uniques de `meromoonmeri/projet-pmdo` aux commits `6cca4a09380211e510ab1bea454a1b1926ef4b5a` et `2801e225fc216f2a6e87209042897f3d2f7a9fc0` ont été parcourus (2,06 Go compressés) pour rechercher les 202 noms de tilesets de branche encore non résolus; aucun ZIP n’a échoué à la lecture. Les 110 et 111 fichiers `.tile` libres de ces arbres ont aussi été vérifiés. Deux noms ont un candidat d’archive ou de fichier libre :

- `v2_promontoire_jour_03.tile` est présent dans `livrable_cliff_nord_jour_anime_v1.zip` (SHA-256 `804772fd…`, 315 792 octets). Le ZIP contient aussi deux Grounds homonymes, mais leurs hashes ne correspondent pas aux Grounds de branche. La feuille est conservée comme **candidat non intégré**; elle ne justifie pas de remplacer les cartes;
- `Treasure_Town_Base.tile` est présent dans `renders/amp_plains_fleurie_v1/amp_plains_fleurie_v1.zip` (SHA-256 `305a7324…`). Cette copie est identique à un candidat déjà présent sous `source/cote_v4_abyss`; une variante de contenu différente existe sous `source/falaises_treasure`. La référence demeure ambiguë. Le ZIP Amp Plains a été consulté uniquement comme source d’asset : **aucun alias de carte Amp Plains ↔ Vallons Fleuris n’est créé**.

Les 200 autres noms n’ont pas été trouvés dans ces ZIP ni dans ces fichiers `.tile` libres. Ce résultat n’établit pas leur absence de toutes les archives ou sources externes. Les Grounds cliff de l’archive ne remplacent pas les versions de branche.

## Vérification du build Treasure Normal

Le script `source/reseau_treasure_normal_v1/build.py` et ses cinq images PNG ont été exécutés dans un répertoire temporaire, sans modifier les sources. Le résultat produit cinq sheets `TreasureGen_*` et cinq Grounds `100×75`, mais ces Grounds sont en version `0.7.10.0`, avec une couche, **zéro entité et zéro cellule d’obstacle**. Les listes `ACCESS` et `LINKS` sont des notes de manifeste; elles ne créent pas de spawn ni de warp dans les Grounds. Le manifeste du build garde `art_approved: false` et `runtime_tested: false`.

Le probe PMDO 0.8.12 a échoué dès `treasure_gen_accueil` : `GroundMap.ReloadEntLayer` lève `ArgumentOutOfRangeException`, puis `GetGround` renvoie `null`. Les quatre autres sorties ne sont pas testées après cet échec. **Ces sorties ne remplacent pas** les cinq Grounds de branche originaux. Aucun output généré n’est ajouté au compte de 262.

## Suite pour atteindre 262

1. Résoudre les assets source des 13 occurrences bloquées, sans choisir une variante ambiguë ni substituer un Ground homonyme. Retrouver les sorties originales de `generated_002/007/029` aux hashes attendus; les rebuilds disponibles pour 007/029 et la variante AGM2 pour 002 sont non exacts et restent exclus. En attendant, ces 16 occurrences restent recensées et non prévisualisables.
2. Quand ces 16 sources seront disponibles, reconstruire la même cartothèque Quest `destiny` en conservant le UUID stable `1da28568-6363-5c51-8caa-9430b42862f0`, les 33 occurrences de doublon et les statuts exacts; ne produire aucun Ground factice.
3. La quête-cartothèque 246 actuelle peut être copiée depuis le ZIP vers `PMDO/MODS/destiny`. Elle n’a pas de scénario ni transitions. Les probes headless valident les Grounds natifs, le chargement de `exploration_cartes` et la résolution TileGuide; ils ne certifient pas le rendu graphique, le spawn/navigation, les collisions effectives, l’éditeur ou la jouabilité. Aucune sortie ou transition absente des sources ne sera inventée.

Le compte source de 262 est réconcilié; **la Quest autonome `destiny` de 246 Grounds est construite et passée aux probes headless Ground, Zone et TileGuide sur le contenu du ZIP final. Le final 262, le rendu et la jouabilité ne sont pas certifiés.** Voir [`DESTINY_QUEST_OVERLAY.md`](DESTINY_QUEST_OVERLAY.md) pour les packages overlay et autonome.

## Mise à jour — récupération des 16 occurrences absentes

Un suivi séparé documente les 13 payloads Ground de branche récupérés et vérifiés à l’octet, les 3 candidates générées non exactes, leurs hashes comparés et les probes Ground natifs : [`DESTINY_16_RECOVERY.md`](DESTINY_16_RECOVERY.md). Les 13 Grounds source restent bloqués par leurs TileSheets manquants; `generated_002/007/029` n’ont toujours pas leurs sorties originales exactes. Aucune de ces 16 occurrences n’a été substituée ou intégrée à la quête.

## Provenance après la migration de marque

Les 40 entrées provenant de l’archive d’expéditions ont maintenant un `sourceLocator` et un `rebrandedGroundSha256` qui pointent vers le paquet actif Treasure. Leur `groundSha256` reste le hash du payload source exact avant renommage; il continue donc à préserver l’identité source et les 262 occurrences. Les octets et chemins d’avant migration sont archivés dans [`source_payloads_before_rename_2026-10-30.zip`](../../exports/treasure_rename/source_payloads_before_rename_2026-10-30.zip), vérifiés par [`migration_report.json`](../../exports/treasure_rename/migration_report.json). Les hashes d’origine ne sont pas remplacés par ceux des Ground modifiés uniquement dans leurs champs descriptifs.
