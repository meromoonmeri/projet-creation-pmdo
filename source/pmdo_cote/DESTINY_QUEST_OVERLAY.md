# Overlay de cartes — quête PMDO Destiny

Le builder historique produit un **prototype de 208 Grounds**. Un overlay candidat partiel de 246 a ensuite servi à créer une **nouvelle quête-cartothèque autonome `destiny`**, avec `Mod.xml` et zone développeur `exploration_cartes`; elle contient tous les 246 Grounds disponibles et leurs dépendances. Ce n’est pas le final de 262 occurrences : 16 sources restent sans Ground. Le package autonome réutilise exactement le UUID stable du prototype 208; il ne remplace aucun dossier de quête utilisateur et n’ajoute pas de scénario, écran-titre personnalisé ou zone narrative.

## Résultat dans la quête

- Le prototype historique contient **208 Grounds**. Le nouveau package [`PMD_Destiny_Map_Quest_246_0812.zip`](../../exports/pmdo/PMD_Destiny_Map_Quest_246_0812.zip) est une quête autonome : namespace `destiny`, UUID `1da28568-6363-5c51-8caa-9430b42862f0`, `ModType=Quest`, PMDO 0.8.12.0.
- Sa zone développeur `exploration_cartes` énumère les **246 Grounds** inclus. Le vrai DataManager PMDO a chargé la zone et confirmé 246 `GroundMaps`, zéro segment narratif. Le probe Ground natif de l’archive exacte passe 246/246 en 13 lots.
- L’archive contient 1 059 TileSheets, 33 fonds et la provenance des 262 occurrences. Les 13 assets bloqués et 3 Grounds générés absents restent listés sans map factice.
- Cette nouvelle cartothèque n’ajoute aucun warp, scénario, combat, écran-titre personnalisé ni liaison narrative. Elle n’altère pas une quête ou un `Mod.xml` extérieur; elle n’est pas certifiée jouable ni graphiquement rendue.

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

Cette dernière commande produit l’overlay-source `exports/pmdo/PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip` (**220 654 226 octets**, CRC PASS, 246 Grounds, 1 059 tilesets, 33 fonds, aucun `Mod.xml`). Le ZIP temporaire du catalogue source est supprimé après construction. Cet overlay a ensuite servi à générer la quête-cartothèque autonome :

```sh
python3 source/pmdo_cote/create_destiny_map_quest.py --force
python3 source/pmdo_runtime/verify_destiny_ground_archive_0812.py --package .cache/destiny-recovery/destiny-map-quest-246/destiny --expected-count 246 --batch-size 20 --results source/pmdo_runtime/destiny_map_quest_246_ground_runtime_results.tsv
python3 source/pmdo_runtime/verify_destiny_quest_zone_0812.py
python3 source/pmdo_cote/create_destiny_map_quest.py --finalize-validation
```

La dernière commande produit [`PMD_Destiny_Map_Quest_246_0812.zip`](../../exports/pmdo/PMD_Destiny_Map_Quest_246_0812.zip), une Quest complète au sens PMDO (Mod.xml/namespace `destiny`, données Ground, index tile et zone développeur). Ground et `exploration_cartes` ont été chargés dans le runtime PMDO 0.8.12 headless. Le scénario/rendu visuel n’est pas testé. Le package ZIP est ignoré par Git (plus de 100 MB); ses scripts, inventaire et rapports sont versionnés.

## Installer la cartothèque autonome

1. Ferme PMDO et sauvegarde tout dossier `PMDO/MODS/destiny` déjà présent.
2. Extrais `PMD_Destiny_Map_Quest_246_0812.zip` dans `PMDO/MODS/`; le résultat doit contenir `PMDO/MODS/destiny/Mod.xml`.
3. Relance PMDO et sélectionne la quête **PMD Destiny — Catalogue d’exploration 0.8.12**.
4. En mode développeur, ouvre `exploration_cartes`. La zone a été chargée en runtime avec 246 `GroundMaps`.

Le package réutilise le UUID stable du prototype 208 (`1da28568-6363-5c51-8caa-9430b42862f0`). Si tu as déjà ta propre quête `destiny`, ne remplace pas son dossier par la cartothèque : utilise plutôt l’overlay ci-dessous afin de conserver son `Mod.xml`.

## Option : intégrer l’overlay à une quête existante

1. Ferme PMDO et sauvegarde le dossier de quête existant.
2. Extrais `PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip` dans un dossier temporaire.
3. Vérifie d’abord la cible :

   ```sh
   python3 installer_destiny_overlay.py "CHEMIN/PMDO/MODS/quest_pmd_destiny" --dry-run
   ```

4. Si la simulation confirme `ModType=Quest`, namespace `destiny`, version `0.8.12.0` et aucune collision, lance l’installation :

   ```sh
   python3 installer_destiny_overlay.py "CHEMIN/PMDO/MODS/quest_pmd_destiny"
   ```

L’installateur d’overlay sauvegarde les index/zone à modifier, conserve le `Mod.xml`/UUID, fusionne `Content/Tile/index.idx` et refuse les conflits d’assets. Il ne crée aucun warp, scénario ou zone narrative.
## Portée / vérification honnête

Le prototype de 208 Grounds n’est pas le livrable demandé de 262 occurrences. Le registre [`destiny_262_inventory.json`](destiny_262_inventory.json) réconcilie **126 ZIP + 39 chemins de branche + 97 Grounds générés = 262 occurrences**, **229 hashes Ground distincts** et **33 occurrences dupliquées** conservées avec leur provenance.

La récupération a avancé depuis le premier audit : les **cinq Grounds de branche dont la grille native était vide** ont été reconstruits à partir des coordonnées de carte, atlas `.tile`, frames, collisions et markers présents dans leurs exports source. Le résultat PMDO 0.8.12.0 est consigné dans [`destiny_empty_branch_reconstruction_0812_results.tsv`](../pmdo_runtime/destiny_empty_branch_reconstruction_0812_results.tsv) : 5/5 Grounds chargés, 33 nœuds TileGuide lus et 89 875 coordonnées uniques référencées résolues. Il s’agit d’une preuve headless de désérialisation et de références de tuiles, **pas** d’un test de rendu ni de jouabilité; `artApproved` et `playabilityCertified` restent faux.

Le staging Ground-only des **246 occurrences actuellement disponibles** est maintenant passé par le probe natif PMDO 0.8.12 en 13 lots : **246/246 Grounds PASS** (Version, TexSize, dimensions et couches attendues par carte). Le stage associé a aussi chargé **1 059 TileSheets**, 33 fonds et `TileGuide.Load` a résolu **2 773 093 coordonnées uniques, 0 manquante sur 246/246 cartes**. Les 74 frames sérialisées sans nom de feuille sont ignorées comme frames vides/transparents; aucune coordonnée avec un nom de feuille n’est omise. Rapports : [`destiny_candidate_246_ground_runtime_results.tsv`](../pmdo_runtime/destiny_candidate_246_ground_runtime_results.tsv), [`destiny_candidate_246_tileguide_runtime_results.tsv`](../pmdo_runtime/destiny_candidate_246_tileguide_runtime_results.tsv) et [`destiny_candidate_246_tileguide_summary.json`](../pmdo_runtime/destiny_candidate_246_tileguide_summary.json). Le rendu et la jouabilité restent non testés.

Les 246 sont 126 ZIP + 26 branche (21 exactes, 5 reconstruites) + 94 générées (50 exactes, 41 reliées au prototype par le hash source, 3 variantes de build avec hash divergent explicitement signalées). Le registre des 262 lignes conserve aussi les **13 occurrences branchées bloquées** et `generated_002/007/029`, sans Ground de sortie : aucune carte factice n’est créée. Les trois variantes ne sont pas qualifiées de sources exactes; six autres entrées générées ont de plus un spawn statiquement bloqué/invalide.

Un **overlay partiel réel** est maintenant assemblé : [`PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip`](../../exports/pmdo/PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip), CRC PASS, 246 Grounds distincts avec provenance, 1 059 TileSheets, 33 fonds, sans `Mod.xml`. Son archive exacte a passé le probe Ground natif **246/246 en 13 lots** (`destiny_candidate_246_overlay_ground_runtime_results.tsv`). Les 1 059 `.tile` et 33 `.dir` de l’archive sont SHA-256 identiques aux assets du staging TileGuide qui a passé 246/246 et résolu 2 773 093 coordonnées; l’archive n’ajoute ni géométrie ni collisions. Le candidat comprend le manifeste des 262 occurrences et signale les 16 occurrences sans Ground disponible, sans placeholder.

Le final demandé de **262 occurrences n’est pas achevé** : les 13 assets source bloqués et les trois Grounds générés absents ne peuvent pas devenir des cartes. À la place, une **nouvelle quête-cartothèque `destiny` de 246 cartes** est fournie dans le ZIP autonome, avec le même UUID stable que le prototype 208; ses 246 Grounds et sa zone `exploration_cartes` ont passé les probes natifs headless. Aucun dossier PMDO utilisateur n’était monté dans le workspace, donc le package n’a pas été copié dans une installation personnelle. Rien n’a été inventé pour les 16 entrées sans Ground; aucun warp, géométrie, collision ou liaison narrative n’a été ajouté.
