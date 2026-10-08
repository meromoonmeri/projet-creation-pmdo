# Fin Mt. Thunder — arène de fin (4:3) — projet PMDO 0.8.12

Projet d’édition autonome `fin_mt_thunder` : Ground `ftm1_fin_mt_thunder`
au **format 4:3 vaste** (768 × 576 px, 96 × 72 cases de 8 px, `TexSize=1`).

Zone de fin qui prolonge l’entrée Mt. Thunder (EMT1). Biome et portée
choisis par l’agent pour la suite de la série. **À confirmer.**

## Installer

- **Projet séparé** : copier `fin_mt_thunder` dans `PMDO/MODS/`, activer, ouvrir le Ground.
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (sable, aussi sous les pics) | fixe |
| 01 | Sable praticable | fixe |
| 02 | Cailloux | fixe |
| 03 | Pics | fixe |
| 04 | Falaise | fixe |
| 05 | Piton (alcôve nord) | fixe |
| 06 | Ciel d’orage | fixe |
| 07 | Nuages | fixe |
| 08 | Lueurs (arc Flash du rip) | 48 × 5 ticks |
| 09 | Éclairs (sprites exacts du rip) | 48 × 5 ticks |
| 10 | vide, `Layer=4` (Top) | — |

La scène boucle en 240 ticks (4 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- `entrance` au sud (crête de sable), `boss` au centre, `objectif` au pied du piton nord.
  **Aucun warp, aucune sortie, pas de `donjon_seuil`.**
- Sable et cailloux reliés au sud : praticable. Pics, falaise, piton, ciel, nuages : bloqués.
  Éclairs et lueurs visuels. Chemin 16 × 16 vérifié sur la grille. **À contrôler en jeu.**

## Limites

- Terrain : dessin généré d’après la planche Mt. Thunder (Red Rescue Team).
  Éclairs et arc : pixels et couleurs exacts de la planche.
- Ce ne sont pas des tuiles natives ni des animations officielles.
- Tests moteur : aucun. `art_approved: false`.
