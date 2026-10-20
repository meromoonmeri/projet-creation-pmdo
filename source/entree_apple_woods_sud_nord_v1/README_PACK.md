# Entrée Apple Woods (Bois aux Pommes) — EAW1 (768 × 576, 8 px)

Entrée de donjon sud → nord dans le biome **Apple Woods / Bois aux Pommes** (*Pokémon Donjon Mystère : Explorateurs du Temps / de l'Ombre / du Ciel*), construite à partir de la capture canonique `Apple_Woods_entrance_TDS.png` (552 × 408 px).

## Calques

| N° | Calque | Cadence |
|---:|---|---|
| 00 | Sol complet reconstruit (témoin sans objets) | fixe |
| 01 | Prairie d'herbe vert émeraude | fixe |
| 02 | Bordure d'herbe vert-jaune clair le long du sentier | fixe |
| 03 | Sentier sablonneux ocre sud → nord | fixe |
| 04 | Touffes de fleurs mauves et roses | fixe |
| 05 | Rochers ocre bordant la clairière centrale | fixe |
| 06 | Arbres feuillus verts et buissons de la moitié sud | fixe |
| 07 | Verger de pommiers chargés de pommes rouges au nord | fixe |
| 08 | Chute et rebond de pommes rouges et Pomme Parfaite dorée (`pommes_feuilles_poses.png`) | 24 × 5 ticks |
| 09 | Feuilles de pommier voletantes et éclats de pollen doré (`pommes_feuilles_poses.png`) | 24 × 5 ticks |
| 10 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` au sud sur le sentier ocre ; `donjon_seuil` au nord entre les pommiers. **Aucun warp.**
- **Collisions** : le sentier, l'herbe claire, l'herbe et les fleurs sont praticables. Les rochers ocre, les arbres feuillus et les pommiers sont bloqués. Un chemin libre de 16 × 16 px a été vérifié sur la grille (`entrance` → `donjon_seuil`). **À contrôler en jeu.**

## Limites

- **Terrain, arbres, pommiers, rochers et poses de pommes/feuilles** : dessins générés à partir de la capture `Apple_Woods_entrance_TDS.png` (`pommes_feuilles_poses.png` sur fond magenta pur `#FF00FF`). Ce ne sont pas des tuiles natives.
- **Animations** : les chutes de pommes et feuilles voletantes utilisent les poses générées sur fond magenta et sont animées par programme. Ce ne sont pas des animations officielles.
- **Moteur PMDO** : `runtime_tested: false`, `art_approved: false`.
