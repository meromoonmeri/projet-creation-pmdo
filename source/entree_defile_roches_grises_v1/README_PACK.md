# EDR1 — Entrée du Défilé des Roches grises

**Projet d'édition PMDO 0.8.12**, 768 × 576 px (4:3 vaste), 96 × 72 cases de **8 px**, `TexSize=1`.
Préfixe unique `EDR1`, namespace `entree_defile_roches_grises`, Ground `edr1_entree_defile_roches_grises`.

Nouvelle entrée choisie par l'agent après le choix utilisateur « Nouveau biome » le 16 octobre 2026.
Le nom est descriptif : **aucune identification officielle du lieu ROM D46P11A n'est revendiquée**.

## Méthode et origine

- Référence ROM **D46P11A**, rendue depuis `pret/pmd-sky` au commit
  `c8073235b39746a7ee74e6cea16c730bd91a1e67`, via `skytemple-files` 1.8.5.
  Le rendu est statique (1 frame, aucun BPA, pas d'animation de palette).
- Deux générations avec **la référence fournie en image** : décor sur magenta, puis sol complet.
  Prompts exacts conservés dans `generation.json`. Bruts 1200 × 896 conservés.
- Segmentation pleine résolution, réduction **par classe**, facteur uniforme 576/896,
  largeur arrondie à 771 puis recadrage centré à 768 ; aucune interpolation entre matières.
- Palette commune de 96 couleurs sans dither. La profondeur est traitée séparément.
- Les **pixels du terrain sont générés**, pas extraits de tuiles ROM.
  « Natif » qualifie ici la grille et les formats `.tile`, `index.idx`, `.rsground` ;
  cela ne rend pas le dessin officiel ou pixel-exact.
- Profondeur de la faille : aplat recalculé avec une couleur exacte du rip.
  Poussière au vent : dessins et mouvements calculés, couleurs exactes du rip.
  **Ce ne sont pas des animations officielles.**

## Calques, du bas vers le haut

| # | Fonction | Animation |
|---|---|---|
| 00 | Sol complet continu, aussi sous les parois | fixe |
| 01 | Sol praticable, fissures et graviers du décor conservés | fixe |
| 02 | Pixels d'ombre existants dans le sol | fixe |
| 03 | Talus, pieds de parois et gravats (bloquants) | fixe |
| 04 | Parois rocheuses et racines sèches | fixe |
| 05 | Profondeur bleu-noir dans la faille nord | fixe |
| 06 | Poussière discrète au vent | 24 × 5 ticks |
| 07 | `Top` vide (`Layer=4`) pour vos éléments d'avant-plan | — |

Boucle : **120 ticks, 2 secondes à 60 ticks/s**. Transparence binaire, RGB nuls sous alpha nul.
Les racines restent dans les parois : elles ne sont pas artificiellement isolées par couleur.
L'ORA contient les calques dans le bon ordre, première phase de poussière seulement.

## Accès et collisions

`entrance` au sud ; `donjon_seuil` au nord, sur le sol avant la faille.
Chemin libre pour un personnage **16 × 16 px** vérifié sur la grille 8 px.
Les parois, la faille et les talus sont bloquants.
**Aucun warp ni destination de donjon liée** : le seuil est un marqueur d'édition uniquement.
Vue de contrôle : `review/EDR1_collisions_marqueurs.png`. À contrôler en jeu.

## Reproduire

Depuis la racine du dépôt, avec Python 3.11+ :

```sh
python -m venv .venv
.venv/bin/pip install -r source/entree_defile_roches_grises_v1/requirements.txt
.venv/bin/python source/entree_defile_roches_grises_v1/build.py
.venv/bin/python -m unittest source.entree_defile_roches_grises_v1.test_build -v
.venv/bin/python source/entree_defile_roches_grises_v1/verify.py
.venv/bin/python source/entree_defile_roches_grises_v1/package.py
```

Le build fonctionne **hors ligne** avec les fichiers versionnés : pas besoin de télécharger
les anciens ZIP absents de l'extraction. Le gabarit réel 0.8.12 est déjà présent dans
`source/cote_v5_expeditions/references/ExplorersOfSkyOrigins__drenched_bluff_entrance.rsground`.
Le manifeste enregistre son SHA-256. Ses entités, décorations, collisions et références graphiques
sont remplacées ; aucun scénario du gabarit n'est conservé.

Sorties régénérables, non versionnées : `renders/entree_defile_roches_grises_v1/` et
`.cache/entree_defile_roches_grises_v1/entree_defile_roches_grises/`.
Le paquet contient le projet PMDO, les PNG par fonction et un aperçu HTML autonome.

## Installer

- Copier le dossier `entree_defile_roches_grises` du ZIP projet dans `PMDO/MODS/` ; activer le mod
  dans PMDO Dev puis ouvrir `edr1_entree_defile_roches_grises`.
- Dans un mod existant : fermer PMDO, extraire **tout** le ZIP puis
  `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, ensuite sans `--dry-run`.
  L'index est fusionné ; les cartes et graphiques différents ne sont pas écrasés.
- Pour importer les PNG manuellement : **PNG to Tileset, 8 px**, sans redimensionnement.
  Conserver les basenames `EDR1_*` uniques.

## Limites explicites

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Les tests Python de reconstruction du Ground et des banques ne remplacent ni le chargeur réel,
ni l'ouverture dans l'éditeur, ni le déplacement en jeu.
La fidélité publiée est une **mesure de couleur**, pas une preuve de volumes ou de raccords.
Le sol généré est légèrement plus clair que la référence ; ses distances mesurées figurent
séparément pour le brut et pour la sortie dans `manifest.json`.
La découpe sol/talus est un contour relevé sur le brut : le contrôle des collisions reste nécessaire.
Aucun ancien lot ni aucune branche sœur n'est modifié ou fusionné.
