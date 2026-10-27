# Tilesets de la bibliothèque

Ce dossier reçoit les fichiers `.tile` **livrés avec** les cartes de `../grounds/`.
Il est volontairement vide en v1 (2026-10-27) :

- Les grosses sheets des deux cartes livrées (`00_ciel`, `v2_promontoire_jour_03`,
  `terrain*`…) n'existent que dans l'installation PMDO / le dépôt `projet-pmdo`
  de l'utilisateur : elles sont à rapatrier ici, une par une, avec leur provenance
  notée dans `../CREDITS.md`.
- Les `.tile` de référence présents dans ce dépôt (`Altere_Pond_*`, `Metano_*`
  sous `source/*/references/`, « natifs » des chantiers) contiennent des pixels
  de filiation PMD Sky (pool PMDO/RawAsset) : la bibliothèque **ne redistribue
  pas** ces pixels. Les compositions `.rsground`, elles, sont importées avec
  l'accord de leur auteur (voir `../PROVENANCE.md` et `../CREDITS.md`).

Le `../manifest.json` donne, carte par carte, la liste exacte des sheets utilisées,
leur présence dans le dépôt et leur chemin. Pour rendre une carte affichable :
déposer ses `.tile` ici (et dans `quest_pmdo_0812/Content/Tile/`), vérifier
l'unicité des basenames, puis reconstruire l'index du mod avec
`../outils/construire_index_tiles.py`.
