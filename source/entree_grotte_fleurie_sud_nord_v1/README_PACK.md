# Entrée Grotte Fleurie sud → nord (4:3) — projet PMDO 0.8.12 (EGF1)

Recréation de la **capture PMDO de l'utilisateur** (`reference/capture_pmdo_source.png`, 637×471) : falaises ocre stratifiées, entrée de grotte à dents/stalactites au nord, sentier de sable rosé sud → nord, prairie verte fleurie (rouge/jaune/bleu), rochers ocre, buissons ronds aux angles sud. Les deux Pokémon de la capture (Mudkip + Pokémon gris) sont **retirés**.

Projet d'édition autonome `entree_grotte_fleurie_sud_nord` : Ground `egf1_entree_grotte_fleurie`, **768 × 576 px** (96 × 72 cases de 8 px, `TexSize=1`, ≈ 2,4 × 2,4 écrans PMDO).

## Installer

- **Projet séparé** : copier `entree_grotte_fleurie_sud_nord` dans `PMDO/MODS/`, l'activer, puis ouvrir le Ground.
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe quilée) | fixe |
| 01 | Entrée sombre (grotte) | fixe |
| 02 | Herbe | fixe |
| 03 | Fleurs au vent | 8 × 10 ticks |
| 04 | Sentier sable rosé | fixe |
| 05 | Rochers ocre | fixe |
| 06 | Buissons | fixe |
| 07 | Falaises ocre | fixe |
| 08 | Papillons générés | 48 × 5 ticks, boucle 4 s |
| 09 | vide, `Layer=4` (Top) | — |

**Pas d'eau** dans la référence : aucun calque eau/scintillements.

## Marqueurs et collisions

- `entrance` au sud, sur le sentier ; `donjon_seuil` sous l'entrée sombre, au nord. **Aucun warp.**
- Herbe, sentier et emplacements des fleurs praticables ; rochers, buissons, falaises et grotte bloquent. Chemin libre 16 × 16 px vérifié sur la grille. **À contrôler en jeu.**

## Méthode et provenance

- **Rendu généré** d'après la capture (grotte = magenta), sol généré séparément puis **quilting d'herbe saine** (touffes parasites retirées).
- **Étalonnage colorimétrique par matière** vers la capture (correction multiplicative, texture préservée).
- Normalisation uniforme ×0,642857 (1200×896 → 771×576), recadrage centré 768 (1 px / 2 px), réduction **par classe** (moyenne pondérée BOX, attribution exclusive), palette commune 96 couleurs.
- **Fleurs au vent** : pixels des fleurs du décor, cisaillement horizontal ancré au pied (amplitude 1,6 px, 8 phases sinusoïdales fermées) — mouvement créé par nous.
- **Papillons** : planche EJN1 réutilisée (dessin généré), 4 boucles en huit, trajectoires créées par nous.
- **Entrée sombre** : remplissage procédural dégradé — généré, pas une tuile native.
- Aucun matériau n'est présenté comme tuile canonique native ; tout est généré/recalculé dans la DA PMD.

## Fidélité couleur (distance euclidienne RVB vs capture, seuil 35)

Même classifieur couleur exclusif des deux côtés (Pokémon de la capture masqués), mesurée sur le décor généré étalonné pleine résolution :

| Matière | Distance |
|---|---:|
| Herbe | 1,7 |
| Sentier | 2,8 |
| Falaises / rochers | 2,5 |
| Buissons | 2,4 |
| Fleurs rouges | 0,9 |
| Fleurs jaunes | 5,2 |
| Fleurs bleues | 3,7 |

Détail dans `manifest.json` (`fidelity.mesures`, `etalonnage.stats`). Revue : `review/EGF1_scene_t000.png`, `review/EGF1_decor_etalo.png`, `masques/EGF1_masque_mousse_nettoyee.png`.

## Contrôles

- `test_build.py` : **9 tests PASS** (formats, alpha binaire, sans magenta, couverture, boucles fleurs/papillons, fidélité, ORA/scène, accès 16×16, roundtrip Ground/tuiles/index).
- `verify.py` : **2005 contrôles indépendants OK** (recomposition exacte, cadences, roundtrip tuiles 8 px, installateur en simulation, fidélité recalculée).
- **Aucun test dans PMDO** (`runtime_tested: false`) ; **approbation artistique non demandée** (`art_approved: false`).

## Limites

- Recréation interprétative : la disposition suit la capture mais n'est pas une copie pixel exacte du jeu.
- La mousse verte parasite peinte par le générateur dans les falaises a été retirée par inpainting ocre (masque fourni).
- Le sol généré contenait des touffes parasites : nettoyé par quilting d'herbe saine (`bruts/sol_complet_genere.png` → `bruts/sol_complet.png`).
