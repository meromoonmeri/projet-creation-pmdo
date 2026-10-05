# Entrée du Canyon Cuivré (EOC1) — projet PMDO 0.8.12

Nouvelle carte d'entrée de donjon, progression **sud → nord**, au format 4:3 vaste : **768 × 576 px**, soit **96 × 72 cases** sur une grille native de 8 px (`TexSize=1`).

Le lieu est une création originale. La référence de matière et de style est le rendu PMD Sky **`D55P11A`** (outil `source/outil_maps_pmdsky`, dépôt `pret/pmd-sky`, commit épinglé `c8073235b39746a7ee74e6cea16c730bd91a1e67`). Le nom `D55P11A` est conservé comme identifiant de source : aucun nom de donjon n'est déduit du préfixe `D55`. La référence n'est pas embarquée dans ce pack ; SHA-256 : `8f59c745f3a40fc300e767a5eafc1d6bc8610d85c733b15809d4b0bd08b58213`.

## Calques (bas → haut)

| # | Calque | Contenu |
|---|---|---|
| 00 | Sol complet | Source de sol générée séparément, sous l'ensemble du décor |
| 01 | Sol et sentier | Sol ocre praticable issu de la composition générée |
| 02 | Ombres | Pixels d'ombre séparés à partir du rendu |
| 03 | Parois | Falaises et encadrement du canyon |
| 04 | Rochers | Amas rocheux au sol, isolés du chemin |
| 05 | Végétation | Touffes vertes détourées par masque RGB et composantes connexes, sans coordonnées de plantes saisies à la main |
| 06 | Profondeur | Ombre de la bouche de grotte au nord |
| 07 | Poussière | Animation atmosphérique créée pour cette carte, 24 × 5 ticks |
| 08 | Top | Calque vide (`Layer=4`) |

Boucle de poussière : **120 ticks (2 s)**. L'animation est originale et n'est pas présentée comme une animation officielle.

## Marqueurs, collisions et raccord

- `entrance` : au sud, dans le couloir praticable.
- `donjon_seuil` : devant la bouche de grotte, au nord.
- Aucun warp ni destination de donjon n'est fourni ; `donjon_seuil` est un marqueur d'édition, pas une transition jouable.
- Les parois et gros rochers sont bloqués ; le sentier est libre. Le passage 16 × 16 px entre l'arrivée et le seuil est vérifié automatiquement.
- **À contrôler dans PMDO en jeu** : l'environnement de fabrication ne certifie pas le rendu graphique, les collisions en mouvement ni le gameplay.

## Provenance et limites

- La composition `bruts/decor.png` et le sol `bruts/sol_complet.png` sont des images générées pour EOC1, pas des captures ni des tuiles natives.
- La carte est référencée par la source PMD Sky `D55P11A`; les pixels générés ne sont pas annoncés comme pixel-exacts ou natifs.
- « Canyon Cuivré » et l'identifiant court EOC1 sont des choix de travail de l'agent ; le choix explicitement confirmé était la composition générée 1. EOC1 a été retenu après vérification des préfixes documentés dans ce checkout et des changements visibles sur les branches distantes. Les branches sœurs n'ont pas été fusionnées.
- `art_approved: false`; `runtime_tested: false`.

## Livrables générés

- `renders/entree_canyon_cuivre_sud_nord_v1/EOC1_projet_pmdo_0812.zip` : Ground, banques `.tile`, index et installateur.
- `renders/entree_canyon_cuivre_sud_nord_v1/EOC1_calques_png_8px.zip` : calques, animation, masques, sources et aperçu modifiable.
- `.cache/entree_canyon_cuivre_sud_nord_v1/EOC1_calques.ora` : document OpenRaster à calques.
- `renders/entree_canyon_cuivre_sud_nord_v1/review/EOC1_scene_t000.png` : aperçu à 768 × 576 ; `review/index.html` : aperçu avec calques et boucle animée.
- `apercu_entree_canyon_cuivre_v1.html` : page web autonome servie depuis la racine du dépôt.

## Reproduire

```sh
.venv/bin/python source/entree_canyon_cuivre_sud_nord_v1/build.py
.venv/bin/python -m unittest source.entree_canyon_cuivre_sud_nord_v1.test_build -v
.venv/bin/python source/entree_canyon_cuivre_sud_nord_v1/verify.py
.venv/bin/python source/entree_canyon_cuivre_sud_nord_v1/package.py
```

Les rendus lourds, les `.tile`, le projet PMDO de staging et les ZIP restent sous `renders/` ou `.cache/` selon les règles du dépôt.
