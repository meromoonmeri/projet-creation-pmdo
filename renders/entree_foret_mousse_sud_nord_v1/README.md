# Entrée de la Forêt Moussa (EFM1) — projet PMDO 0.8.12

Carte d'entrée sud → nord, **768 × 576 px, 96 × 72 cases, 8 px** (`TexSize=1`), textures **100% canonique multilayer** façon spriter pro. Un seul modèle générateur est utilisé pour les deux bruts, avec la référence D24P11A comme guide palette.

Référence : `D24P11A` (pret/pmd-sky commit `c8073235b39746a7ee74e6cea16c730bd91a1e67`, SHA `06399b45633e8dcf1979aabf9a5d693bcf5ba74885c91e943bea9de2caa6ce27`) — forêt à racines, mousse dense, troncs noueux, sentier pavé. Layout nouveau, aucune copie de composition.

## Calques (bas → haut)

| # | Calque | Contenu |
|---|---|---|
| 00 | Sol complet | Sol mousse complet généré séparément, sous tout |
| 01 | Mousse | Tapis moussu praticable issu de la composition |
| 02 | Sentier | Pavage beige en pierres, chemin dégagé |
| 03 | Ombres | Ombrages doux sous frondaisons, praticable |
| 04 | Rochers | Petits blocs gris-mousse, bloqués |
| 05 | Fleurs | Touffes roses/jaines décoratives, praticables |
| 06 | Parois | Troncs, racines noueuses, canopées denses (bloqué) |
| 07 | Caverne | Ombre profonde de la bouche nord |
| 08 | Spores | Animation de spores lumineuses, 24 × 5 ticks (2 s) — création originale |
| 09 | Top | Calque vide `Layer=4` |

Boucle spores : **120 ticks (2 s à 60 Hz)**. Palette commune **96 couleurs MEDIANCUT sans dither**, transparence binaire stricte sauf spores (alpha graduée).

## Marqueurs, collisions et raccord

- `entrance` au sud, dans le sentier mousseux.
- `donjon_seuil` devant la bouche sous racines au nord.
- Aucun warp ni destination ; marqueurs d'édition seulement.
- Parois, rochers et caverne bloqués ; sentier/mousse praticables. Chemin 16×16 px sud→nord vérifié par BFS.
- **À contrôler en jeu PMDO** : rendu graphique, collisions en mouvement et gameplay non certifiés par les seuls tests d'image.

## Provenance et fidélité

- `bruts/decor.png` (1200×896) et `bruts/sol_complet.png` (1200×896) générés avec le **même modèle unique** et la référence D24P11A. Ne sont pas des tiles natives.
- Fidélité mousse mesurée vs référence : **seuil RGBeuclidien <35** (exemple ~10). Mesure indicative, pas preuve de copie pixel.
- `art_approved: false`, `runtime_tested: false`. Textures multilayer quantifiées pro, pas tiles natives certifiées.

## Livrables

- `renders/entree_foret_mousse_sud_nord_v1/EFM1_projet_pmdo_0812.zip` — projet PMDO 0.8.12
- `renders/.../EFM1_calques_png_8px.zip` — calques, animation, ORA, manifest
- `.cache/.../EFM1_calques.ora` — OpenRaster éditable
- `renders/.../review/EFM1_scene_t000.png`, `_x2.png`, `_animee.webp`, `_collisions_marqueurs.png`
- `apercu_entree_foret_mousse_v1.html` — aperçu autonome

## Reproduire

```sh
.venv/bin/python source/entree_foret_mousse_sud_nord_v1/build.py
.venv/bin/python -m unittest source.entree_foret_mousse_sud_nord_v1.test_build -v
.venv/bin/python source/entree_foret_mousse_sud_nord_v1/verify.py
.venv/bin/python source/entree_foret_mousse_sud_nord_v1/package.py
```
