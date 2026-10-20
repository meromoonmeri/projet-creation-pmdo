# Guilde Treehouse — fins de donjon (21 salles de boss / trésor) — mod PMDO 0.8.12

Ce dossier est un mod d'édition autonome, namespace `guilde_fins_donjons`. Il regroupe les **21 salles de fin de donjon** de la série (les 15 biomes de `guilde_entrees_sud_nord`, avec les deux variantes de Givre, plus Océan Kyogre et Old Castle / Chambre Dorée). Chaque carte est un Ground animé au format 4:3 vaste (`768 × 576 px`, `96 × 72` cases de `8 px`), avec ses collisions, ses bords nord/côtés fermés et trois marqueurs : `entrance` (arrivée au sud), le marqueur central d'arène (`boss` / `arene` / `kyogre`) et le marqueur d'objectif au nord (`objectif` / `source` / `embleme` / `cle_de_voute` / `cristal` / `belvedere` / `azurill` / `sceau` / `joyau`). **Aucune sortie, aucun `donjon_seuil`, aucun warp** : c'est une base d'édition, pas une aventure jouable.

**Aucune carte n'a encore été testée dans PMDO.**

## Installer

- **Mod séparé** : copier le dossier `guilde_fins_donjons` dans `PMDO/MODS/`, activer le mod, puis ouvrir les Grounds dans l'éditeur (mode développeur).
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis la même commande sans `--dry-run`. L'installeur ne remplace jamais un fichier existant différent, et fusionne l'index des tuiles après en avoir fait une sauvegarde.

## Cartes

| # | Ground | Carte | Taille | Calques | Animations (frames × ticks) | Marqueurs |
|---|---|---|---|---|---|---|
| 1 | `fvs1_fin_vapeur_sommet` | Vapeur (Steam Cave Peak) | 768 × 576 | 9 | 4 × 10, 24 × 5 | `entrance` (384, 560), `boss` (376, 344), `source` (376, 224) |
| 2 | `fcf1_fin_cratere_fosse` | Cratère (Dark Crater Pit) | 768 × 576 | 10 | 4 × 10, 6 × 10, 24 × 5 | `entrance` (384, 560), `boss` (376, 288), `embleme` (376, 96) |
| 3 | `frp1_fin_ruine_puits` | Ruine (Sealed Ruin Pit) | 768 × 576 | 9 | 6 × 10, 8 × 5, 24 × 5 | `entrance` (384, 560), `boss` (384, 288), `cle_de_voute` (376, 176) |
| 4 | `fgg1_fin_givre_grotte` | Givre V1 (Grotte gelée) | 768 × 576 | 9 | 4 × 10, 6 × 10, 48 × 5 | `entrance` (384, 560), `boss` (376, 312), `cristal` (376, 232) |
| 5 | `fgg2_fin_givre_aurore` | Givre V2 (Belvédère aurore) | 768 × 576 | 10 | 4 × 10, 12 × 10, 48 × 5 | `entrance` (384, 560), `boss` (376, 304), `belvedere` (376, 184) |
| 6 | `fbs1_fin_bristle_sommet` | Bristle (Mt. Bristle Peak) | 768 × 576 | 7 | 12 × 10, 24 × 5 | `entrance` (384, 560), `boss` (384, 288), `azurill` (376, 160) |
| 7 | `fjs1_fin_jungle_sud` | Jungle (Sanctuaire sud) | 768 × 576 | 9 | 48 × 5 | `entrance` (376, 560), `boss` (384, 296), `objectif` (376, 176) |
| 8 | `foc1_fin_ocean_kyogre` | Océan (Fosse de Kyogre) | 768 × 576 | 11 | 12 × 5, 12 × 20, 16 × 15, 24 × 10, 48 × 5 | `entrance` (384, 560), `kyogre` (368, 200), `sceau` (376, 296) |
| 9 | `fwc1_fin_waterfall_cave` | Waterfall Cave (Salle du joyau) | 768 × 576 | 9 | 12 × 5, 24 × 10 | `entrance` (376, 560), `arene` (384, 312), `joyau` (376, 224) |
| 10 | `ful2_fin_underground_lake` | Underground Lake (Sanctuaire) | 768 × 576 | 11 | 4 × 10, 12 × 10, 24 × 5 | `entrance` (384, 560), `boss` (376, 320), `objectif` (376, 248) |
| 11 | `fmf3_fin_mystifying_forest` | Mystifying Forest (Clairière) | 768 × 576 | 12 | 4 × 10, 48 × 5 | `entrance` (376, 560), `boss` (376, 304), `objectif` (376, 232) |
| 12 | `fsm1_fin_sables_mouvants` | Sables mouvants (Fosse) | 768 × 576 | 10 | 12 × 10, 24 × 5 | `entrance` (376, 560), `boss` (384, 440), `objectif` (352, 160) |
| 13 | `fst1_fin_star_cave` | Star Cave (Caverne étoilée) | 768 × 576 | 9 | 24 × 5 | `entrance` (384, 560), `boss` (384, 320), `objectif` (384, 152) |
| 14 | `fct3_fin_clairiere_tropicale` | Clairière tropicale (Sanctuaire) | 768 × 576 | 14 | 24 × 5 | `entrance` (368, 560), `boss` (376, 360), `objectif` (384, 208) |
| 15 | `fcv5_fin_couloir_violet` | Couloir violet (Chambre du cristal) | 768 × 576 | 12 | 24 × 5 | `entrance` (384, 560), `boss` (384, 368), `objectif` (376, 216) |
| 16 | `fmt4_fin_mt_thunder` | Mt. Thunder (Pic d'orage) | 768 × 576 | 13 | 48 × 5 | `entrance` (384, 560), `boss` (384, 288), `objectif` (376, 168) |
| 17 | `fjs5_fin_jardin_secret` | Jardin secret (Sanctuaire) | 768 × 576 | 16 | 24 × 5 | `entrance` (384, 560), `boss` (384, 304), `objectif` (376, 128) |
| 18 | `foc2_fin_old_castle` | Old Castle (Chambre Dorée) | 768 × 576 | 12 | 24 × 5 | `entrance` (384, 560), `boss` (376, 288), `objectif` (376, 160) |
| 19 | `fam1_fin_amp_plains` | Amp Plains (Arène de foudre) | 768 × 576 | 12 | 24 × 5 | `entrance` (384, 560), `boss` (376, 288), `objectif` (376, 184) |
| 20 | `faw1_fin_apple_woods` | Apple Woods (Grand Pommier Doré) | 768 × 576 | 12 | 24 × 5 | `entrance` (384, 560), `boss` (376, 304), `objectif` (376, 256) |
| 21 | `flc1_fin_lac_cristal` | Lac Cristal (Sanctuaire du Prisme) | 768 × 576 | 12 | 24 × 5 | `entrance` (384, 560), `boss` (376, 288), `objectif` (376, 200) |

Toutes les 21 cartes sont au format 4:3 vaste 768 × 576 px et ont un calque Top vide (`Layer=4`) en dernier.

## Scripts

Chaque carte a son script `Data/Script/guilde_fins_donjons/ground/<carte>/init.lua` autonome (aucun warp).

## Limites

- Terrains générés à partir de captures des jeux (rendu généré référencé) ; seuls les scintillements Métano utilisés dans FVS1 et FUL2 sont des tuiles natives.
- Les autres animations sont créées pour ces cartes : ce ne sont pas les animations officielles.
- Collisions et marqueurs vérifiés sur la grille, pas en jeu.
