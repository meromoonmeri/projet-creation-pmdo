# Overlay de cartes — quête PMDO Destiny

Le builder historique du catalogue produit toujours un **prototype de 208 Grounds** pour la quête PMDO 0.8.12 **Destiny existante**. Un nouveau chemin d’assemblage a également produit un **overlay candidat partiel de 246 Grounds** avec dépendances; ni l’un ni l’autre n’est le final de 262 occurrences. L’overlay ne crée pas une deuxième quête et ne remplace pas `Mod.xml` : namespace `destiny`, UUID, écran-titre, données de départ et zones narratives restent ceux de la quête installée.

## Résultat dans la quête

- Le prototype ajoute les **208 Grounds** de son catalogue avec leurs tilesets, fonds et scripts. L’archive précédente faisait environ 209 MB et nécessitait environ 3,1 GB une fois extraite.
- La zone développeur `exploration_cartes` est créée ou actualisée. Elle énumère les fichiers `.rsground` présents dans la quête après l’installation — pas seulement les Ground du catalogue. Cette liste dynamique ne garantit pas que chaque fichier puisse se charger, s’afficher ou se parcourir.
- La zone n’ajoute aucun warp, scénario, combat ni liaison entre les cartes. Une entrée bloquée dans l’inventaire n’est pas transformée en aperçu par sa seule présence dans une liste.
- L’installateur fusionne `Content/Tile/index.idx`, simule les changements avec `--dry-run` et refuse les conflits au lieu d’écraser des ressources.

## Construire le prototype actuel

Depuis la racine du dépôt :

```sh
python3 source/pmdo_cote/build_playable_catalogue_0812.py
python3 source/pmdo_cote/build_destiny_quest_overlay.py
```

La seconde commande produit `exports/pmdo/PMD_Destiny_Quest_Overlay_0812.zip`. Le builder calcule les comptes depuis le manifeste catalogue au lieu d’imposer 208; un smoke build CRC du prototype 208 a réussi (208 Grounds, 1170 tilesets, 6 fonds, 208 scripts). Cela ne valide pas le périmètre 262. Pour ce prototype historique, l’option `--inventory source/pmdo_cote/destiny_262_inventory.json` ajoute seulement le registre en documentation; elle ne crée pas de mapping. Le constructeur candidat 246, lui, écrit `sourceEntryId` sur chaque Ground et garde les 262 occurrences dans `sourceOccurrences`, y compris les 16 sans Ground.

Le candidat partiel de 246 se reconstruit à partir des sources récupérées et du probe natif :

```sh
python3 source/pmdo_cote/build_destiny_246_ground_probe_input.py
python3 source/pmdo_runtime/verify_destiny_ground_archive_0812.py --package .cache/destiny-recovery/candidate-246-ground-probe --expected-count 246 --batch-size 20 --results source/pmdo_runtime/destiny_candidate_246_ground_runtime_results.tsv
python3 source/pmdo_cote/build_destiny_246_tileguide_stage.py
python3 source/pmdo_runtime/verify_destiny_246_tileguide_0812.py
python3 source/pmdo_cote/build_destiny_246_overlay_candidate.py
```

Cette dernière commande a produit `exports/pmdo/PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip` (**220 654 226 octets**, CRC PASS, 246 Grounds, 1 059 tilesets, 33 fonds, aucun `Mod.xml`). Le ZIP temporaire de catalogue source est supprimé après construction pour économiser l’espace disque. Le paquet partiel n’est pas le livrable 262 et n’a pas été installé dans la quête, absente du workspace. Les ZIP d’export sont ignorés par Git; le code de construction, le manifeste d’inventaire et les rapports restent versionnés.

## Installer dans la quête existante

1. Ferme PMDO et sauvegarde `PMDO/MODS/quest_pmd_destiny`.
2. Extrais l’overlay dans un dossier temporaire.
3. Vérifie d’abord la cible :

   ```sh
   python3 installer_destiny_overlay.py "CHEMIN/PMDO/MODS/quest_pmd_destiny" --dry-run
   ```

4. Si la simulation confirme `ModType=Quest`, namespace `destiny`, version `0.8.12.0` et aucune collision, installe :

   ```sh
   python3 installer_destiny_overlay.py "CHEMIN/PMDO/MODS/quest_pmd_destiny"
   ```

   Sous Windows, `py` peut remplacer `python3`.

5. Relance PMDO en mode développeur avec Destiny, puis ouvre **Exploration des cartes (dev)** (`exploration_cartes`). Les fichiers Ground restent dans `Data/Ground`; la zone de prévisualisation ne modifie pas la progression.

L’installateur crée des sauvegardes `.pre_destiny_maps.bak` pour les index et le JSON de zone s’ils doivent changer. Il conserve les autres zones, le `Mod.xml` et les fichiers existants. Si un Ground ou tileset homonyme contient déjà des octets différents, l’installation s’arrête avant les copies.

## Portée / vérification honnête

Le prototype de 208 Grounds n’est pas le livrable demandé de 262 occurrences. Le registre [`destiny_262_inventory.json`](destiny_262_inventory.json) réconcilie **126 ZIP + 39 chemins de branche + 97 Grounds générés = 262 occurrences**, **229 hashes Ground distincts** et **33 occurrences dupliquées** conservées avec leur provenance.

La récupération a avancé depuis le premier audit : les **cinq Grounds de branche dont la grille native était vide** ont été reconstruits à partir des coordonnées de carte, atlas `.tile`, frames, collisions et markers présents dans leurs exports source. Le résultat PMDO 0.8.12.0 est consigné dans [`destiny_empty_branch_reconstruction_0812_results.tsv`](../pmdo_runtime/destiny_empty_branch_reconstruction_0812_results.tsv) : 5/5 Grounds chargés, 33 nœuds TileGuide lus et 89 875 coordonnées uniques référencées résolues. Il s’agit d’une preuve headless de désérialisation et de références de tuiles, **pas** d’un test de rendu ni de jouabilité; `artApproved` et `playabilityCertified` restent faux.

Le staging Ground-only des **246 occurrences actuellement disponibles** est maintenant passé par le probe natif PMDO 0.8.12 en 13 lots : **246/246 Grounds PASS** (Version, TexSize, dimensions et couches attendues par carte). Le stage associé a aussi chargé **1 059 TileSheets**, 33 fonds et `TileGuide.Load` a résolu **2 773 093 coordonnées uniques, 0 manquante sur 246/246 cartes**. Les 74 frames sérialisées sans nom de feuille sont ignorées comme frames vides/transparents; aucune coordonnée avec un nom de feuille n’est omise. Rapports : [`destiny_candidate_246_ground_runtime_results.tsv`](../pmdo_runtime/destiny_candidate_246_ground_runtime_results.tsv), [`destiny_candidate_246_tileguide_runtime_results.tsv`](../pmdo_runtime/destiny_candidate_246_tileguide_runtime_results.tsv) et [`destiny_candidate_246_tileguide_summary.json`](../pmdo_runtime/destiny_candidate_246_tileguide_summary.json). Le rendu et la jouabilité restent non testés.

Les 246 sont 126 ZIP + 26 branche (21 exactes, 5 reconstruites) + 94 générées (50 exactes, 41 reliées au prototype par le hash source, 3 variantes de build avec hash divergent explicitement signalées). Le registre des 262 lignes conserve aussi les **13 occurrences branchées bloquées** et `generated_002/007/029`, sans Ground de sortie : aucune carte factice n’est créée. Les trois variantes ne sont pas qualifiées de sources exactes; six autres entrées générées ont de plus un spawn statiquement bloqué/invalide.

Un **overlay partiel réel** est maintenant assemblé : [`PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip`](../../exports/pmdo/PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip), CRC PASS, 246 Grounds distincts avec provenance, 1 059 TileSheets, 33 fonds, sans `Mod.xml`. Son archive exacte a passé le probe Ground natif **246/246 en 13 lots** (`destiny_candidate_246_overlay_ground_runtime_results.tsv`). Les 1 059 `.tile` et 33 `.dir` de l’archive sont SHA-256 identiques aux assets du staging TileGuide qui a passé 246/246 et résolu 2 773 093 coordonnées; l’archive n’ajoute ni géométrie ni collisions. Le candidat comprend le manifeste des 262 occurrences et signale les 16 occurrences sans Ground disponible, sans placeholder.

Le final demandé de **262 cartes n’est pas achevé** : les 13 assets source bloqués et trois Grounds générés absents ne peuvent pas être affichés comme cartes, et aucune installation réelle n’a été exécutée car aucun dossier de quête Destiny (`Mod.xml`) n’est présent dans le workspace. L’installateur accepte maintenant `Version` et `TexSize` par carte (tests unitaires PASS) tout en exigeant une cible Quest PMDO 0.8.12 namespace `destiny`; il n’altère pas le `Mod.xml`/UUID. Dès que la quête locale est accessible, il reste à lancer `--dry-run` puis l’installation et à vérifier la zone `exploration_cartes`. Rien n’a été inventé pour les occurrences bloquées; aucun warp, géométrie ou collision manquants n’a été ajouté.
