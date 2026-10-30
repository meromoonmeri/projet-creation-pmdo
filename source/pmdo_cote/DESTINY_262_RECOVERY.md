# Destiny — état de récupération des 262 entrées

**État : inventaire réconcilié, probe Ground-only de 246 occurrences PASS, intégration finale et certification de jouabilité inachevées.** Le registre conserve chaque occurrence, ses doublons et sa provenance. Le staging 246 est un outil de test jetable (sans TileSheets/fonds/scripts), pas un overlay; aucun overlay final de 262 occurrences n’a encore été construit ni installé dans `exploration_cartes`.

Le registre détaillé est [`destiny_262_inventory.json`](destiny_262_inventory.json). Il conserve les chemins, commits/blob IDs, hashes Ground, références de tilesets, doublons, statuts de chargement et blocages par entrée. Le contrôle suivi [`verify_destiny_262_inventory.py`](verify_destiny_262_inventory.py) réconcilie le registre et les résultats runtime consignés : `python3 source/pmdo_cote/verify_destiny_262_inventory.py`.

## Réconciliation de l’inventaire

**126 Grounds d’archives + 39 chemins Ground de branche + 97 Grounds générés = 262 occurrences source.** L’inventaire généré contient 98 Grounds; `pmd_destiny_menu_nuit` est l’entrée auxiliaire exclue du total annoncé.

Ces 262 occurrences ne sont pas 262 contenus distincts : le calcul SHA-256 donne **229 contenus Ground exacts** et **33 occurrences supplémentaires de doublons**. Les occurrences et leur provenance ne sont pas fusionnées.

| Source | Occurrences | Contenus SHA-256 distincts | État de récupération |
|---|---:|---:|---|
| Six ZIP d’archives | 126 | 106 | Grounds récupérés exactement; 126/126 occurrences PASS au probe Ground-only PMDO 0.8.12 |
| Chemins Ground de branche | 39 | 26 | 21 Grounds source exacts + 5 grilles vides reconstruites depuis les données carte source; 13 toujours bloquées par assets manquants/non établis |
| Builds générés | 97 | 97 | 50 Grounds reconstruits exactement, 41 sources reconnues dans le prototype par `sourceGroundSha256`, 3 sorties reconstruites aux hashes divergents (probe seulement), 3 Grounds sans sortie disponible |

L’assemblage de probe Ground-only comprend **246 occurrences** : 126 ZIP + 26 branche (21 exactes et 5 reconstruites) + 94 générées (50 exactes, 41 normalisées à partir d’une source Ground exacte, 3 variantes de hash explicitement signalées). Il conserve les 262 lignes source; les **13 occurrences asset-blocked** et les **3 Grounds générés sans sortie** y sont inscrits comme non testables, sans substitut. Les doublons sont conservés sous des IDs de probe distincts. Ces 246 essais ne constituent ni 246 contenus uniques ni une validation de jouabilité. Six Grounds générés ont par ailleurs une entrée sur cellule bloquée ou invalide selon le masque statique.

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

Le staging rassemble 126 Grounds ZIP exacts, 21 Grounds de branche exacts, 5 reconstructions depuis les grilles source, 50 builds générés aux hashes attendus, 41 Grounds sources reliés au prototype par `sourceGroundSha256` et 3 sorties générées aux hashes divergents. Ces trois variantes (`generated_030/031/035`) ne sont **pas** qualifiées exactes. Le registre des 262 occurrences conserve séparément les 13 entrées bloquées par assets et `generated_002/007/029`, dont aucun Ground de sortie n’est disponible; aucun placeholder n’est produit.

Versions testées : 46 × 0.7.15.1, 179 × 0.8.12.0, 4 × 0.8.9.0, 9 × 0.7.4.0, 3 × 0.7.12.0, 3 × 0.7.17.0, 1 × 0.8.11.0 et 1 × 0.7.10.0. `TexSize` : 243 × 1 et 3 × 3. Les Grounds `TexSize=3` `Brine_Cave_Entrance` (0.8.11.0, 27×21) et `luminous_spring` (0.7.4.0, 25×25) avaient aussi PASS individuellement dans l’essai ciblé précédent.

Le staging séparé `candidate-246-tileguide` charge **1 059 TileSheets** et résout **2 773 093 coordonnées uniques, zéro manquante, 246/246 Grounds PASS**; 74 frames avec `Sheet` vide sont des frames transparentes/vides et ne nomment aucun tileset. Les `.tile` et `.dir` sont sourcés depuis leur archive/commit/build ou les ressources PMDO de base (`LuminousSpring*` a le statut `base`), jamais depuis un dessin inventé. Rapports : [`destiny_candidate_246_tileguide_runtime_results.tsv`](../pmdo_runtime/destiny_candidate_246_tileguide_runtime_results.tsv) et [`destiny_candidate_246_tileguide_summary.json`](../pmdo_runtime/destiny_candidate_246_tileguide_summary.json). Cela ne certifie toujours pas le rendu, la correspondance dessin/collision, spawn, collisions en jeu, navigation, sortie, warp ou jouabilité. Les Grounds anciens ne sont pas pour autant migrés.

Un **overlay candidat partiel de 246 occurrences** a ensuite été construit à `exports/pmdo/PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip` : **220 654 226 octets, SHA-256 `43ca364de835f46816f315d6c4bb9aeb4edb6b351ecf7a3d05caa074e0ddef10`, CRC PASS, 246 Grounds, 1 059 TileSheets, 33 fonds, sans `Mod.xml`**. Le probe Ground natif a aussi passé l’archive en 13 lots : [`destiny_candidate_246_overlay_ground_runtime_results.tsv`](../pmdo_runtime/destiny_candidate_246_overlay_ground_runtime_results.tsv). La validation `installer_destiny_overlay.validate_overlay` accepte ses 246 Grounds et compare les Versions/TexSize par carte (8 Versions, TexSize 1/3); trois tests unitaires couvrent l’acceptation/rejet des métadonnées. Les hashes des 1 059 feuilles et 33 fonds dans le ZIP concordent avec le stage TileGuide. Le manifeste garde les 262 occurrences; les 16 sans Ground restent signalées, sans placeholder. Le dossier local de la quête Destiny n’est pas présent; ni `--dry-run` ni installation réelle n’ont donc été exécutés. Ce ZIP est un candidat partiel, pas l’overlay final 262 ni une installation validée.

Autres constats statiques conservés :

- les 126 Grounds ZIP ont un marqueur `entrance`; 106 sont entièrement marchables d’après leurs tags et 20 contiennent des cellules bloquées. Six portent aussi le marqueur `donjon_seuil`, qui n’a pas été interprété comme une sortie;
- les 97 Grounds générés ont un marqueur d’entrée; 91 de ces entrées tombent sur une cellule marchable, 6 sur une cellule bloquée. Quatre cartes portent un marqueur `sortie` atteignable selon le masque statique, mais aucune transition n’a été testée;
- **aucune carte des 262 n’est certifiée jouable.** Aucun spawn, masque de collision, chemin ou warp n’a été inventé ou retouché pour faire passer un test.

## Archives examinées et candidats de tilesets

Les 242 blobs ZIP uniques de `meromoonmeri/projet-pmdo` aux commits `6cca4a09380211e510ab1bea454a1b1926ef4b5a` et `2801e225fc216f2a6e87209042897f3d2f7a9fc0` ont été parcourus (2,06 Go compressés) pour rechercher les 202 noms de tilesets de branche encore non résolus; aucun ZIP n’a échoué à la lecture. Les 110 et 111 fichiers `.tile` libres de ces arbres ont aussi été vérifiés. Deux noms ont un candidat d’archive ou de fichier libre :

- `v2_promontoire_jour_03.tile` est présent dans `livrable_cliff_nord_jour_anime_v1.zip` (SHA-256 `804772fd…`, 315 792 octets). Le ZIP contient aussi deux Grounds homonymes, mais leurs hashes ne correspondent pas aux Grounds de branche. La feuille est conservée comme **candidat non intégré**; elle ne justifie pas de remplacer les cartes;
- `Metano_Town_Base.tile` est présent dans `renders/amp_plains_fleurie_v1/amp_plains_fleurie_v1.zip` (SHA-256 `305a7324…`). Cette copie est identique à un candidat déjà présent sous `source/cote_v4_abyss`; une variante de contenu différente existe sous `source/falaises_metano`. La référence demeure ambiguë. Le ZIP Amp Plains a été consulté uniquement comme source d’asset : **aucun alias de carte Amp Plains ↔ Vallons Fleuris n’est créé**.

Les 200 autres noms n’ont pas été trouvés dans ces ZIP ni dans ces fichiers `.tile` libres. Ce résultat n’établit pas leur absence de toutes les archives ou sources externes. Les Grounds cliff de l’archive ne remplacent pas les versions de branche.

## Vérification du build Métano Normal

Le script `source/reseau_metano_normal_v1/build.py` et ses cinq images PNG ont été exécutés dans un répertoire temporaire, sans modifier les sources. Le résultat produit cinq sheets `MetanoGen_*` et cinq Grounds `100×75`, mais ces Grounds sont en version `0.7.10.0`, avec une couche, **zéro entité et zéro cellule d’obstacle**. Les listes `ACCESS` et `LINKS` sont des notes de manifeste; elles ne créent pas de spawn ni de warp dans les Grounds. Le manifeste du build garde `art_approved: false` et `runtime_tested: false`.

Le probe PMDO 0.8.12 a échoué dès `metano_gen_accueil` : `GroundMap.ReloadEntLayer` lève `ArgumentOutOfRangeException`, puis `GetGround` renvoie `null`. Les quatre autres sorties ne sont pas testées après cet échec. **Ces sorties ne remplacent pas** les cinq Grounds de branche originaux. Aucun output généré n’est ajouté au compte de 262.

## Suite d’intégration

1. Résoudre les assets source des 13 occurrences bloquées, sans choisir une variante ambiguë ni substituer un Ground homonyme. Récupérer ou reconstruire aussi les Grounds de sortie manquants de `generated_002/007/029`; en attendant, ces 16 occurrences restent recensées et non prévisualisables.
2. Étendre l’overlay candidat au **registre complet de 262 occurrences** pour une intégration réelle : le ZIP candidat actuel embarque les 262 lignes de provenance mais seulement 246 Grounds disponibles. Garder les 33 occurrences de doublon distinctes; les 13 bloquées et trois Grounds générés manquants doivent rester non affichables, sans carte factice. Le builder d’overlay calcule ses comptes depuis le manifeste et n’impose plus 208; l’installateur valide maintenant `Version`/`TexSize` par Ground (tests unitaires PASS).
3. Installer/tester cet overlay sur une copie de la quête Destiny existante, en conservant strictement son `Mod.xml`, UUID, namespace `destiny`, écran-titre et zones narratives. Vérifier que `exploration_cartes` expose chaque Ground récupérable et que les entrées bloquées y sont signalées sans tentative de chargement.
4. Effectuer les essais de rendu dans PMDO 0.8.12 et, avant toute certification de jouabilité, valider visuellement collisions, entrée/spawn et parcours de chaque carte récupérable. Aucune sortie ou transition non présente dans les sources ne sera inventée.

Le compte de 262 est réconcilié; **l’overlay final de 262 occurrences n’est pas encore construit ni vérifié**. Voir [`DESTINY_QUEST_OVERLAY.md`](DESTINY_QUEST_OVERLAY.md) pour l’état du prototype et les instructions d’installation.
