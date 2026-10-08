# Fin Couloir violet — arène de fin (4:3) — projet PMDO 0.8.12

Projet d’édition autonome `fin_couloir_violet` : Ground `fvl1_fin_couloir_violet`
au **format 4:3 vaste** (768 × 576 px, 96 × 72 cases de 8 px, `TexSize=1`).

Zone de fin qui prolonge l’entrée Couloir violet (ECV1). Biome et portée
choisis par l’agent pour la suite de la série. **À confirmer.**

## Installer

- **Projet séparé** : copier `fin_couloir_violet` dans `PMDO/MODS/`, activer, ouvrir le Ground.
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (mauve, aussi sous les rochers) | fixe |
| 01 | Sol praticable | fixe |
| 02 | Ombres au pied des parois | fixe |
| 03 | Gravillons | fixe |
| 04 | Blocs (amas dans l’arène) | fixe |
| 05 | Rochers (murs) | fixe |
| 06 | Vide (navy des bords) | fixe |
| 07 | Éboulis (gravillons exacts du rip) | 24 × 5 ticks |
| 08 | Poussière (planche ECV1) | 24 × 5 ticks |
| 09 | vide, `Layer=4` (Top) | — |

La scène boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- `entrance` au sud (couloir), `boss` au centre, `objectif` au pied de l’alcôve nord.
  **Aucun warp, aucune sortie, pas de `donjon_seuil`.**
- Sol, ombres et gravillons reliés au sud : praticable. Rochers, blocs, vide : bloqués.
  Éboulis et poussière visuels. Chemin 16 × 16 vérifié sur la grille. **À contrôler en jeu.**

## Limites

- Terrain : dessin généré d’après `large.S05P03A…png`. Gravillons : pixels exacts du rip.
  Poussière : poses d’ECV1, placement créé par nous.
- Ce ne sont pas des tuiles natives ni des animations officielles.
- Tests moteur : aucun. `art_approved: false`.
