# Tilesets de la bibliothèque

Ce dossier reçoit les fichiers `.tile` **livrés avec** les cartes de `../grounds/`.
Il est volontairement vide en v1 (2026-10-27) :

- Les grosses sheets des deux cartes livrées (`00_ciel`, `v2_promontoire_jour_03`,
  `terrain*`…) n'existent que dans l'installation PMDO / le dépôt `projet-pmdo`
  de l'utilisateur : elles sont à rapatrier ici, une par une, avec leur provenance
  notée dans `../CREDITS.md`.
- Les seuls `.tile` présents dans ce dépôt pour ces cartes sont des sheets de
  référence Halcyon (`Altere_Pond_*`, `Metano_*` sous `source/*/references/`) ou
  des reconstructions « natifs » de chantiers inspirés de Métano : tant que
  l'accord de l'auteur d'origine n'est pas obtenu (voir `../PROVENANCE.md`),
  ils ne sont **pas** recopiés dans la bibliothèque.

Le `../manifest.json` donne, carte par carte, la liste exacte des sheets utilisées,
leur présence dans le dépôt et leur chemin. Pour rendre une carte affichable :
déposer ses `.tile` ici (et dans `quest_pmdo_0812/Content/Tile/`), vérifier
l'unicité des basenames, puis reconstruire l'index du mod avec
`../outils/construire_index_tiles.py`.
