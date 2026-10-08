# Fin Clairière tropicale — arène de fin (4:3) — projet PMDO 0.8.12

Projet d’édition autonome `fin_clairiere_tropicale` : Ground `fct1_fin_clairiere_tropicale`
au **format 4:3 vaste** (768 × 576 px, 96 × 72 cases de 8 px, `TexSize=1`).

Zone de fin qui prolonge l’entrée Clairière tropicale (ETC1). Biome et portée
choisis par l’agent pour la suite de la série. **À confirmer.**

**État** : méthode et gabarit ouverts ; les PNG, le Ground et l’aperçu **ne sont pas encore produits**
(cette extraction n’embarque pas les bruts ; la génération n’a pas eu lieu).

## Installer (quand le paquet existera)

- **Projet séparé** : copier `fin_clairiere_tropicale` dans `PMDO/MODS/`, activer, ouvrir le Ground.
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis sans `--dry-run`.

## Calques prévus (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe de clairière, aussi sous la jungle) | fixe |
| 01 | Herbe praticable | fixe |
| 02 | Ombres | fixe |
| 03 | Dalles de sable | fixe |
| 04 | Touffes et cailloux | fixe |
| 05 | Fleurs (hibiscus) | fixe |
| 06 | Jungle dense | fixe |
| 07 | Palmiers | fixe |
| 08 | Canopée (si présente) | fixe |
| 09 | Papillons (planche ETC1) | 24 × 5 ticks |
| 10 | vide, `Layer=4` (Top) | — |

## Marqueurs et collisions

- `entrance` au sud, `boss` au centre, `objectif` au nord. **Aucun warp, aucune sortie.**
- Herbe / dalles praticables ; jungle, palmiers, fleurs bloqués. **À contrôler en jeu.**

## Limites

- Terrain : dessin généré d’après `large.S01P03A…png`. Papillons : poses d’ETC1, trajectoires créées par nous.
- Ce ne sont pas des tuiles natives ni des animations officielles.
- Tests moteur : aucun. `art_approved: false`.
