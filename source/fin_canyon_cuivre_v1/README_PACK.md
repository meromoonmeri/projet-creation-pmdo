# Fin Canyon Cuivré — arène naturelle (FCC1) — PMDO 0.8.12

Zone de fin au fond de la caverne, construite à partir de la composition choisie par l'utilisateur. Le cahier des charges confirmé pour cette arène est : **aucun cristal**, **aucune dalle ni carrelage au sol**, et une finition qui conserve le thème cuivré de la caverne. Le nom « Canyon Cuivré » décrit le lot de travail ; ce n'est pas un nom canonique fourni par l'utilisateur.

Carte 4:3 vaste : **768 × 576 px**, soit **96 × 72 cases de 8 px** (`TexSize=1`). La composition fait arriver le joueur par le sud, ouvre un large espace central, et garde la paroi rocheuse au nord.

## Calques (bas → haut)

| # | Calque | Contenu |
|---|---|---|
| 00 | Sol complet | Base cuivrée réutilisée de l'entrée EOC1, sous la partition opaque |
| 01 | Sol | Sol naturel praticable issu de la composition sélectionnée |
| 02 | Ombres | Pixels sombres du sol, séparés par mesure locale; décoratifs et praticables |
| 03 | Parois | Roche cuivrée, galets et rebord de l'arène |
| 04 | Végétation | Petite plante verte détectée automatiquement depuis le RGB et les composantes connexes |
| 05 | Top | Calque vide (`Layer=4`) |

Tous les pixels visibles proviennent du décor sélectionné, réduits uniformément sans étirement puis harmonisés par une palette commune de 96 couleurs, sans tramage. La segmentation n'ajoute ni dalle, ni cristal, ni objet d'arène.

## Marqueurs, collisions et raccord

- `entrance` au sud, `boss` au centre de l'arène, `objectif` au nord.
- Les trois repères ont un collider de 16 × 16 px et sont uniquement des marqueurs d'édition : aucun personnage, objet, événement ou téléportation n'est créé.
- Le masque de marche est contrôlé sur une grille de 8 px; des chemins 16 × 16 px de l'arrivée vers le centre et vers l'objectif nord sont testés.
- **Aucune sortie, aucun warp, aucun `donjon_seuil`.**
- À contrôler dans PMDO en jeu : ce checkout ne contient pas le runtime PMDO.

## Provenance et limites

- `bruts/decor.png` est la composition retenue : option 2 choisie par l'utilisateur après sa correction « sans cristal / sans dalles ». Ce rendu généré est une image-guide, pas une capture canonique ni une banque de tuiles certifiée.
- Le fichier compagnon de sol dédié n'a pas été produit : deux appels au générateur n'ont renvoyé aucune image. `bruts/sol_complet_reutilise.png` est une copie intacte du sol de l'entrée EOC1 (même caverne et même palette), utilisée comme calque de base. Les calques opaques du décor recouvrent cette base sur toute la scène.
- Le biome/cadrage « Canyon Cuivré » est un choix de travail de l'agent; seule la direction visuelle sans cristal ni dallage a été explicitement confirmée.
- `art_approved: false`; `runtime_tested: false`.

## Livrables

- `renders/fin_canyon_cuivre_v1/FCC1_projet_pmdo_0812.zip` : projet Ground, banques `.tile`, index et installeur.
- `renders/fin_canyon_cuivre_v1/FCC1_calques_png_8px.zip` : calques, masques, sources, ORA, manifeste et aperçu.
- `.cache/fin_canyon_cuivre_v1/FCC1_calques.ora` : document OpenRaster à calques.
- `renders/fin_canyon_cuivre_v1/review/FCC1_scene_t000.png` : image à l'échelle du jeu; `review/index.html` : aperçu interactif avec calques et collisions.
- `apercu_fin_canyon_cuivre_v1.html` : aperçu web autonome à la racine.

## Reproduire

```sh
.venv/bin/python source/fin_canyon_cuivre_v1/build.py
.venv/bin/python -m unittest source.fin_canyon_cuivre_v1.test_build -v
.venv/bin/python source/fin_canyon_cuivre_v1/verify.py
.venv/bin/python source/fin_canyon_cuivre_v1/package.py
```

Les fichiers générés de staging restent dans `.cache/`; les aperçus et archives sont sous `renders/`.
