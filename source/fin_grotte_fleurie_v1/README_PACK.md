# Fin Grotte Fleurie — le FOND du donjon (4:3) — projet PMDO 0.8.12 (FGF1)

Demande : « **et fait le fond de la Grotte fleurie** ». FGF1 est la **salle la plus profonde** de la Grotte Fleurie, celle où l'on arrive après l'entrée EGF1 / EGF2 : une **salle fermée** ceinte de parois ocre stratifiées sur les quatre côtés, un sol d'herbe tapissé de bouquets rouge / jaune / bleu, un **chemin de sable rosé** qui monte du sud vers la clairière centrale, et au nord un **autel fleuri de pierre claire** posé devant un passage sombre.

Format **768 × 576 px** (96 × 72 cases de 8 px, `TexSize=1`, ≈ 2,4 × 1,8 écran PMDO), identique aux autres fins de la série (`fin_star_cave`, …).

## Installer

- **Projet séparé** : copier `fin_grotte_fleurie` dans `PMDO/MODS/`, l'activer, puis ouvrir le Ground `fgf1_fin_grotte_fleurie`.
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer sans `--dry-run`.
- EGF1 et EGF2 sont **conservées intactes** (lots et namespaces distincts) : les trois cartes coexistent.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe quilée depuis le décor) | fixe |
| 01 | Passage sombre derrière l'autel | fixe |
| 02 | Herbe | fixe |
| 03 | Fleurs au vent | 8 × 10 ticks |
| 04 | Sentier sable rosé | fixe |
| 05 | Rochers ocre | fixe |
| 06 | Autel fleuri (estrade de pierre claire) | fixe |
| 07 | Lueur de l'autel | 12 × 10 ticks, halo tramé qui respire |
| 08 | Parois de la salle | fixe |
| 09 | Pétales qui tombent | 24 × 5 ticks, chute + oscillation, boucle fermée |
| 10 | vide, `Layer=4` (Top) | — |

**Pas d'eau.** Scène : PPCM **240 ticks = 4 s**.

## Marqueurs et collisions

- `entrance` au sud sur le sentier · `boss` dans la clairière centrale (zone libre 32 × 32 px) · `objectif` au pied de l'autel.
- **Aucun warp, aucune sortie** : c'est un fond de donjon, le raccordement à EGF1/EGF2 reste à faire dans l'éditeur.
- Herbe, sentier et emplacements de fleurs praticables ; parois, rochers, autel et passage sombre bloquent.
- **Chemin libre 16 × 16 px vérifié** entrée → autel **et** entrée → arène (BFS). **À contrôler en jeu.**

## Méthode et provenance

- Rendu généré **4:3** référencé sur la capture PMDO utilisateur (`../entree_grotte_fleurie_sud_nord_v1/reference/capture_pmdo_source.png`) et sur le décor EGF1 ; le passage derrière l'autel est en **magenta** dans le brut, aucun Pokémon.
- **Sol** : quilting d'herbe saine prélevée dans le décor, puis étalonné.
- **Étalonnage colorimétrique par matière** vers la capture (classifieur exclusif commun, Pokémon masqués).
- **Autel** : masque dédié « pierre claire » (luminance > 165, saturation < 70) restreint à la zone nord, retiré des autres matières, puis dilaté de 2 px.
- Mousse verte parasite retirée par inpainting ocre ; pixels non classés rattachés à la matière la plus proche, **grotte protégée** (les stalactites restent de la roche).
- Normalisation uniforme ×0,642857 (1200×896 → 771×576), recadrage centré 768, réduction **par classe**, palette commune 96 couleurs + palette fleurs dédiée 32.
- **Fleurs au vent**, **lueur** et **pétales** : mouvements créés par nous (halo tramé et sprite de pétale 4 × 4 procéduraux). Aucun matériau n'est une tuile canonique native.

## Fidélité couleur (seuil 35) et contrôles

Valeurs mesurées dans `manifest.json` (`fidelity.mesures`) et reportées après build. Tests : `test_build.py`, vérification aveugle : `verify.py`, packaging : `package.py`.

## Limites

- **Aucun test dans PMDO** (`runtime_tested: false`) ; **approbation artistique non demandée** (`art_approved: false`).
- Recréation interprétative : ambiance et matières fidèles à la capture, pas une copie pixel exacte du jeu.
- **Non versée au mod unique validé** `guilde_entrees_sud_nord` (19 cartes) : en attente de validation.
