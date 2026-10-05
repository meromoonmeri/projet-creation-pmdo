# Fin Clairière tropicale — arène naturelle (FTL1) — PMDO 0.8.12

Map suivante de la file locale après Fin Star Cave (FST1), suivant `REPRISE_MAPS.md`. La clairière tropicale est donc un choix de continuité de l'agent; l'utilisateur a demandé de passer à la map suivante sans nommer cette zone. La portée précise et le nom canonique restent à confirmer.

Carte 4:3 vaste : **768 × 576 px**, soit **96 × 72 cases de 8 px** (`TexSize=1`). Arrivée par le passage sud, grand espace d'arène au centre, alcôve sous les racines de l'arbre au nord. Le sol reste naturel (terre et herbe), **sans cristal, dalles, tuiles ni carrelage**.

## Calques (bas → haut)

| # | Calque | Contenu |
|---|---|---|
| 00 | Sol complet | Herbe complète éditable sous la scène |
| 01 | Sol | Sol naturel de la clairière et passages |
| 02 | Ombres | Détails sombres de l'herbe source, praticables |
| 03 | Jungle | Pixels verts classés automatiquement par composantes connexes |
| 04 | Fleurs | Pétales saturés détectés en rouge/rose/jaune puis séparés automatiquement |
| 05 | Parois | Lisière de jungle, arbres, racines et bord de l'arène |
| 06 | Top | Calque vide (`Layer=4`) |

La composition et le sol complet sont normalisés uniformément de 1200 × 896 px à 768 × 576 px (après padding de 2 px en haut et en bas). Le gazon clair est doucement rapproché des mesures de couleur enregistrées dans le manifeste d'ETC1; les détails foncés et les fleurs ne sont pas recolorés. Les groupes terrain, jungle, racines et fleurs ont des palettes séparées, sans tramage.

## Marqueurs, collisions et raccord

- `entrance` au sud, `boss` dans la grande arène centrale, `objectif` au nord sous les racines.
- Collisions sur grille de 8 px; chemin 16 × 16 px vérifié de l'entrée au centre et à l'objectif. Les feuilles/fleurs décoratives ne ferment pas la clairière.
- Les marqueurs sont des repères d'édition uniquement; aucun personnage, objet, événement ou déclencheur de transition n'est créé.
- **Aucune sortie, aucun warp, aucun `donjon_seuil`.**
- À vérifier dans PMDO en jeu; le runtime n'est pas installé dans le checkout.

## Provenance et limites

- `bruts/decor.png` et `bruts/sol_complet.png` ont été générés pour ce lot, sans image canonique en entrée.
- Le nom de fichier canonique d'ETC1 est consigné dans sa génération et son manifeste, mais l'image de référence et les bruts ETC1 ne sont pas présents dans ce checkout. Le README, le builder et le manifeste d'ETC1 ont servi à cadrer le biome et à récupérer ses moyennes RGB. La correction colorimétrique est donc indicative; elle ne prouve pas une fidélité au rip.
- La composition générée n'est ni une capture canonique ni un tileset natif certifié. `art_approved: false`; `runtime_tested: false`.
- « Clairière tropicale », le layout d'arène et le préfixe FTL1 sont des choix de travail de l'agent, pas des choix explicitement nommés par l'utilisateur.

## Livrables

- `renders/fin_clairiere_tropicale_v1/FTL1_projet_pmdo_0812.zip` : projet Ground, banques `.tile`, index et installeur.
- `renders/fin_clairiere_tropicale_v1/FTL1_calques_png_8px.zip` : calques, masques, sources, ORA, manifeste et aperçu.
- `.cache/fin_clairiere_tropicale_v1/FTL1_calques.ora` : document OpenRaster à calques.
- `renders/fin_clairiere_tropicale_v1/review/FTL1_scene_t000.png` et `review/index.html` : rendu à l'échelle native, calques et collisions.
- `apercu_fin_clairiere_tropicale_v1.html` : aperçu web autonome à la racine.

## Reproduire

```sh
.venv/bin/python source/fin_clairiere_tropicale_v1/build.py
.venv/bin/python -m unittest source.fin_clairiere_tropicale_v1.test_build -v
.venv/bin/python source/fin_clairiere_tropicale_v1/verify.py
.venv/bin/python source/fin_clairiere_tropicale_v1/package.py
```
