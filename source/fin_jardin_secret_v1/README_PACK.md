# Fin Jardin secret — arène de fin (4:3) — projet PMDO 0.8.12

Projet d’édition autonome `fin_jardin_secret` : Ground `fsg1_fin_jardin_secret`
au **format 4:3 vaste** (768 × 576 px, 96 × 72 cases de 8 px, `TexSize=1`).

Zone de fin qui prolonge l’entrée Jardin secret (EJS1). Biome et portée
choisis par l’agent pour la suite de la série. **À confirmer.**

## Installer

- **Projet séparé** : copier `fin_jardin_secret` dans `PMDO/MODS/`, activer, ouvrir le Ground.
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe moyenne) | fixe |
| 01 | Prairie (allée jaune) | fixe |
| 02 | Herbe | fixe |
| 03 | Ombres | fixe |
| 04 | Fleurs | fixe |
| 05 | Rochers | fixe |
| 06 | Arbres | fixe |
| 07 | Haies | fixe |
| 08 | Souche (pleine, pas de trou) | fixe |
| 09 | Fond vert sombre | fixe |
| 10 | Rayon (rampe exacte du rip) | 24 × 5 ticks |
| 11 | Lucioles | 24 × 5 ticks |
| 12 | vide, `Layer=4` (Top) | — |

La scène boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- `entrance` au sud (allée), `boss` au centre, `objectif` au pied de la souche nord.
  **Aucun warp, aucune sortie, pas de `donjon_seuil`.**
- Prairie, herbe, ombres, fleurs reliées au sud : praticable. Haies, arbres, rochers, souche, fond, rayon : bloqués.
  Lucioles visuelles. Chemin 16 × 16 vérifié sur la grille. **À contrôler en jeu.**

## Limites

- Terrain : dessin généré d’après `secretgarden.png`. Rayon / lucioles : couleurs exactes du rip.
- Ce ne sont pas des tuiles natives ni des animations officielles.
- Tests moteur : aucun. `art_approved: false`.
