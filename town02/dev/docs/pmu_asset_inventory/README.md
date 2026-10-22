# Inventaire d’assets Pokémon Mystery Universe (PMU)

## Autorité source

- dépôt : `https://github.com/Sprinkoringo/PMU-Client`
- commit épinglé : `c25c01f9879369647cd5a19731b2e4e5acd33e67`
- licence déclarée par le dépôt : MIT (`LICENSE`)
- attribution complémentaire obligatoire : `Asset Credits.txt`

Les crédits PMU signalent également des arrangements, des extractions et des contributions de plusieurs auteurs. La provenance PMU doit donc être conservée avec chaque asset même si le dépôt contient une licence MIT.

## Résultat exhaustif du premier audit

Le client épinglé contient **2 659 fichiers** hors métadonnées Git, dont :

- 11 archives graphiques `.tile` ;
- 52 486 enregistrements PNG 32×32 intégrés dans ces archives ;
- 550 PNG ordinaires ;
- 751 fichiers `.sprite` ;
- 751 fichiers `.portrait` ;
- 140 fichiers de données de maps `.dat`.

L’inventaire de chaque archive, ses dimensions déclarées, son SHA-256 et ses comptes se trouvent dans `inventory.json`.

## Extraction sans morceau de map

Le format PMU `.tile` stocke chaque tuile comme un PNG 32×32 indépendant. Le script `tools/inventory_pmu_assets.py` copie uniquement l’enregistrement PNG complet, octet pour octet :

- aucun recadrage ;
- aucun redimensionnement ;
- aucune recoloration ;
- aucune reconstruction depuis une map ;
- aucune extraction partielle d’une tuile.

Un filtre géométrique strict a trouvé **1 189 candidats uniques** dont la zone alpha visible reste entièrement à l’intérieur du PNG 32×32. Ils sont conservés sous `isolated_candidates/`, avec une planche par archive. Ce filtre ne suffit pas à prouver qu’un candidat est un objet : certains sont des effets, icônes ou éléments techniques.

## Premier lot d’objets vérifiés visuellement

`qualified_small_objects.json` contient **83 enregistrements source autonomes** de `Tiles5.tile`, vérifiés visuellement comme petits objets, mobilier ou décorations complets.

Le manifeste de livraison est disponible sous deux formes :

- `manifest.json` : identité stable, catégorie, archive/index source, chemin PNG, dimensions, taille, SHA-256, boîte alpha et statuts de chaque objet ;
- `manifest.png` : rendu lisible 1000×2022 avec les 83 objets agrandis en nearest-neighbor, leurs identifiants, libellés, catégories et préfixes SHA-256.

Le lot comprend notamment :

- livres ouverts et fermés, lettre, parchemin et journal ;
- pots, vases, fleurs et plantes en pot ;
- tables/tabourets, tapis et coussins ;
- tonneaux, baquets, coffre ou meuble ;
- étagère, bibliothèque, cadres et carte murale ;
- bougies, candélabres, lampe et service à thé ;
- bouteilles, encrier et plume, clés, pièces et anneaux ;
- boucliers, lance, cor, chaînes et grilles ;
- peluche, bambou, pierres, baies et petits accessoires.

Aucun stand Kecleon complet et autonome n’est encore qualifié dans ce lot. Les grands bâtiments, comptoirs et stands visibles dans les archives sont généralement composés de plusieurs tuiles. Ils restent `ADAPTATION_REQUIRED` et ne doivent pas être présentés comme objets autonomes ni posés sur NNV sans preuve d’assemblage source.

## Statuts

- inventaire de fichiers PMU : `COMPLETE_FOR_PINNED_CLIENT_COMMIT`
- inventaire des 11 archives et 52 486 enregistrements : `STRUCTURALLY_VALID`
- 1 189 enregistrements géométriquement isolés : `CANDIDATES_ONLY`
- 83 petits objets : `VISUALLY_REVIEWED_STANDALONE_SOURCE_RECORD`
- conversion PMDO `.dir` : `NOT_RUN`
- validation PMDO 0.8.12 : `NOT_RUN`
- placement sur NNV : `NOT_PLACED`
- promotion : `FORBIDDEN_UNTIL_PMDO_CONVERSION_AND_RUNTIME_VALIDATION`

## Reproduction et vérification

```bash
PYTHONPATH=/chemin/vers/pillow \
python3 tools/inventory_pmu_assets.py \
  --client /chemin/vers/PMU-Client \
  --out docs/pmu_asset_inventory

python3 tools/verify_pmu_asset_inventory.py
```
