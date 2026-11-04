# Entrée Grotte Fleurie V2 — version LONGUE (2:3) — projet PMDO 0.8.12 (EGF2)

Demande : « **fait la v2 la map était plus grande en longueur avec chemin etc** ». EGF2 reprend la recréation de la capture PMDO utilisateur (`../entree_grotte_fleurie_sud_nord_v1/reference/capture_pmdo_source.png`) en **deux fois plus long** : **768 × 1152 px** (96 × 144 cases de 8 px, `TexSize=1`, ≈ 2,4 × 4,8 écrans PMDO), contre 768 × 576 pour EGF1.

Le **chemin de sable rosé** entre au sud et **serpente en S sur toute la hauteur** jusqu'à la bouche de grotte à dents au nord. Prairies fleuries (rouge/jaune/bleu) de part et d'autre, rochers ocre, buissons ronds, falaises ocre stratifiées sur les deux flancs.

## Installer

- **Projet séparé** : copier `entree_grotte_fleurie_sud_nord_v2` dans `PMDO/MODS/`, l'activer, puis ouvrir le Ground `egf2_entree_grotte_fleurie`.
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer sans `--dry-run`.
- EGF1 est **conservée intacte** (lot distinct, namespace distinct) : les deux cartes coexistent.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe quilée depuis le décor) | fixe |
| 01 | Entrée sombre (grotte) | fixe |
| 02 | Herbe | fixe |
| 03 | Fleurs au vent | 8 × 10 ticks |
| 04 | Sentier sable rosé (long, en S) | fixe |
| 05 | Rochers ocre | fixe |
| 06 | Buissons | fixe |
| 07 | Falaises ocre | fixe |
| 08 | Papillons générés (6, répartis sur la longueur) | 48 × 5 ticks, boucle 4 s |
| 09 | vide, `Layer=4` (Top) | — |

**Pas d'eau** : aucun calque eau/scintillements. Scène : PPCM **240 ticks = 4 s**.

## Marqueurs et collisions

- `entrance` au sud sur le sentier ; `donjon_seuil` sous la bouche de grotte au nord. **Aucun warp.**
- Herbe, sentier et emplacements de fleurs praticables ; rochers, buissons, falaises et grotte bloquent.
- **Chemin libre 16 × 16 px vérifié sur toute la longueur** (BFS). **À contrôler en jeu.**

## Méthode et provenance

- Rendu généré **2:3 portrait** référencé sur la capture utilisateur + le décor EGF1 (grotte = magenta, aucun Pokémon).
- **Sol** : quilting d'herbe saine prélevée dans le décor V2 (pas de second rendu), puis étalonné.
- **Étalonnage colorimétrique par matière** vers la capture (classifieur exclusif commun, Pokémon masqués).
- Mousse verte parasite du générateur retirée par inpainting ocre ; pixels non classés rattachés à la matière la plus proche.
- Normalisation uniforme ×0,911392 (848×1264 → 773×1152), recadrage centré 768 (2 px / 3 px), réduction **par classe**, palette commune 96 couleurs + palette fleurs dédiée 32.
- **Fleurs au vent** et **papillons** : mouvements créés par nous ; papillons = planche générée EJN1 réutilisée. Aucun matériau n'est une tuile canonique native.

## Fidélité couleur (seuil 35) et contrôles

Valeurs mesurées dans `manifest.json` (`fidelity.mesures`) et reportées après build. Tests : `test_build.py`, vérification aveugle : `verify.py`, packaging : `package.py`.

## Limites

- **Aucun test dans PMDO** (`runtime_tested: false`) ; **approbation artistique non demandée** (`art_approved: false`).
- Recréation interprétative : disposition et matières fidèles à la capture, pas une copie pixel exacte du jeu.
- **Non versée au mod unique validé** `guilde_entrees_sud_nord` (19 cartes) : en attente de validation.
