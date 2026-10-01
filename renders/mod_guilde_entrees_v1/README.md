# Guilde Treehouse — entrées de donjon sud → nord (19 cartes) — mod PMDO 0.8.12

Ce dossier est un mod d'édition autonome, namespace `guilde_entrees_sud_nord`. Il regroupe les **19 entrées de donjon sud → nord** de la série. Chaque carte est un Ground animé, avec ses collisions et deux marqueurs : `entrance` (arrivée, au sud) et `donjon_seuil` (au pied de l'entrée, au nord). **Aucun warp** : c'est une base d'édition, pas une aventure jouable.

Série validée par l'utilisateur le 27 septembre 2026 (« BEAU TRAVAIL JE VALIDE PREPARELE MOD AVEC TOUTE CES CARTE ET LANCE LA SUITE ! ») pour les 18 cartes montrées alors. **EJS2** (jardin secret avec le temple miniature de Celebi) a été faite ensuite : **elle reste à confirmer**. **Aucune carte n'a encore été testée dans PMDO.**

## Installer

- **Mod séparé** : copier le dossier `guilde_entrees_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir les Grounds dans l'éditeur (mode développeur).
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis la même commande sans `--dry-run`. L'installeur ne remplace jamais un fichier existant différent, et fusionne l'index des tuiles après en avoir fait une sauvegarde.

## Cartes

| # | Ground | Carte | Taille | Calques | Animations (frames × ticks) | `entrance` | `donjon_seuil` |
|---|---|---|---|---|---|---|---|
| 1 | `esn1_entree_vapeur_jour` | Vapeur (Steam Cave) | 424 × 632 | 10 | 12 × 10 | (200, 616) | (208, 224) |
| 2 | `esn2_entree_vapeur_jour` | Vapeur V2 (eau Métano) | 424 × 632 | 11 | 4 × 10, 24 × 5 | (200, 616) | (208, 224) |
| 3 | `ecn1_entree_cratere` | Cratère (Dark Crater) | 424 × 632 | 10 | 4 × 10, 6 × 10, 24 × 5 | (200, 616) | (200, 176) |
| 4 | `ern1_entree_ruine` | Ruine (Sealed Ruin) | 424 × 632 | 11 | 4 × 10, 8 × 5, 24 × 5 | (200, 616) | (224, 248) |
| 5 | `egn1_entree_givre` | Givre (Frosty Forest) | 424 × 632 | 13 | 4 × 10, 48 × 5 | (200, 616) | (208, 176) |
| 6 | `ebn1_entree_bristle` | Bristle (Mt. Bristle) | 424 × 632 | 10 | 4 × 10, 12 × 10 | (168, 616) | (200, 120) |
| 7 | `ejn1_entree_jungle` | Jungle | 768 × 576 | 13 | 4 × 10, 48 × 5 | (384, 560) | (376, 96) |
| 8 | `ewc1_entree_waterfall_cave` | Waterfall Cave V1 | 768 × 576 | 16 | 4 × 10, 12 × 4 | (392, 560) | (376, 248) |
| 9 | `ewc2_entree_waterfall_cave` | Waterfall Cave V2 (s'ouvre) | 768 × 576 | 20 | 4 × 10, 12 × 4, 24 × 4 | (392, 560) | (376, 184) |
| 10 | `ewc3_entree_waterfall_cave` | Waterfall Cave V3 (se fend) | 768 × 576 | 21 | 4 × 10, 12 × 4, 24 × 4 | (392, 560) | (376, 184) |
| 11 | `eul1_entree_underground_lake` | Underground Lake | 768 × 576 | 12 | 4 × 10, 12 × 10, 24 × 5 | (384, 560) | (376, 96) |
| 12 | `emf1_entree_mystifying_forest` | Mystifying Forest | 768 × 576 | 12 | 4 × 10, 48 × 5 | (384, 560) | (368, 144) |
| 13 | `eqs1_entree_sables_mouvants` | Sables mouvants | 768 × 576 | 12 | 12 × 10, 24 × 5 | (384, 560) | (368, 152) |
| 14 | `esc1_entree_star_cave` | Star Cave | 768 × 576 | 10 | 24 × 5 | (376, 560) | (376, 120) |
| 15 | `etc1_entree_clairiere_tropicale` | Clairière tropicale | 768 × 576 | 16 | 24 × 5 | (384, 560) | (368, 160) |
| 16 | `ecv1_entree_couloir_violet` | Couloir violet | 768 × 576 | 12 | 24 × 5 | (384, 560) | (376, 88) |
| 17 | `emt1_entree_mt_thunder` | Mt. Thunder | 768 × 576 | 13 | 48 × 5 | (384, 560) | (376, 96) |
| 18 | `ejs1_entree_jardin_secret` | Jardin secret | 768 × 576 | 15 | 24 × 5 | (384, 560) | (376, 128) |
| 19 | `ejs2_entree_jardin_secret_temple` | Jardin secret V2 (Celebi) | 768 × 576 | 17 | 24 × 5 | (384, 560) | (376, 120) |

6 cartes sont au format portrait 424 × 632 (ESN1, ESN2, ECN1, ERN1, EGN1, EBN1) ; les 13 autres au format 4:3 vaste 768 × 576. Chaque carte a un calque Top vide (`Layer=4`) en dernier.

## Scripts

Chaque carte a son script `Data/Script/guilde_entrees_sud_nord/ground/<carte>/init.lua`. Ceux d'EWC2 et EWC3 exposent `ouvrir_cascade()` (cascade fermée → ouverture → ouverte, par visibilité de calques) : **non testé dans PMDO**.

## Limites

- Terrains générés à partir de captures des jeux (rendu généré référencé) ; seuls les scintillements Métano d'ESN2 et la cascade d'ECN2 (absente de ce mod) sont des tuiles natives.
- Les animations sont créées pour ces cartes : ce ne sont pas les animations officielles.
- Collisions et marqueurs vérifiés sur la grille, pas en jeu. Les seuils ne sont raccordés à aucun donjon.
