# Zone de réveil — prairie de Sky Peak face à l'océan (jour, aube, nuit) — projet PMDO 0.8.12

Projet d'édition autonome, namespace `zone_reveil_prairie_horizon`. C'est **la première scène** : le Pokémon se réveille dans une grande prairie fleurie de Sky Peak, au bord d'un promontoire plat. En contrebas s'étend l'océan animé comme dans PMD Ciel ; l'écume et les bulles viennent au pied de la prairie. À l'horizon, une mer de nuages et des cimes enneigées, et des nuages qui passent.

Trois Grounds, même disposition, mêmes collisions :

| Ground | Ambiance |
|---|---|
| `zrv1_zone_reveil_jour` | plein jour, ciel bleu |
| `zrv1_zone_reveil_aube` | aube, ciel rose, soleil levant et son reflet |
| `zrv1_zone_reveil_nuit` | nuit, pleine lune, reflet argenté, étoiles |

**Aucun warp** : c'est une base d'édition, pas une aventure jouable. **Non testé dans PMDO.**

## Installer

- **Mod séparé** : copier `zone_reveil_prairie_horizon` dans `PMDO/MODS/`, activer le mod, puis ouvrir les Grounds dans l'éditeur (mode développeur).
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis la même commande sans `--dry-run`. L'installeur ne remplace jamais un fichier existant différent, et fusionne l'index des tuiles après une sauvegarde.

## Calques (bas → haut, identiques dans les trois Grounds)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe unie) | fixe |
| 01 | Herbe (et touffes) | fixe |
| 02 | Chemin | fixe |
| 03 | Fleurs | fixe |
| 04 | Rochers | fixe |
| 05 | Buissons | fixe |
| 06 | Panorama : ciel, cimes, mer de nuages (et lune ou soleil) | fixe |
| 07 | Mer : rotation de palette de PMD Ciel (carte s01p02a, palette 7) | 10 × 10 ticks |
| 08 | Écume au pied de la prairie (s01p02a, palette 8) | 10 × 10 ticks |
| 09 | Bulles qui naissent, gonflent et éclatent | 24 × 5 ticks |
| 10 | Scintillements : reflets (jour), paillettes (aube), étoiles (nuit) | 24 × 5 ticks |
| 11 | Nuages qui passent, deux rangées en parallaxe | 192 × 8 ticks |
| 12 | Vide, `Layer=4` (Top) | — |

Les banques sont préfixées `ZRV1J_`, `ZRV1A_` et `ZRV1N_` (jour, aube, nuit).

## Marqueurs et collisions

- `reveil` : au bord nord de la prairie, au centre, tourné vers le nord (l'océan). C'est là que le héros se réveille.
- `entrance` : au bord sud, sur le chemin. C'est la sortie de la zone et l'arrivée quand on y revient.
- La mer, l'écume, le panorama, les rochers et les buissons sont bloqués. L'herbe, les fleurs et le chemin sont praticables.

## Origine des pixels

- **Terrain, panorama, nuages** : générés avec les captures en référence (GIF Sky Peak, planche des cimes `232233.png`, nuit native de PMD Ciel). Ce sont des pixels générés, pas des tuiles natives.
- **Mer et écume de jour** : couleurs et cadence **exactes** de la carte s01p02a de PMD Ciel (palettes 7 et 8, 10 crans de 10 ticks), relevées dans la ROM. Le motif des bandes est dessiné par nous, sur le profil mesuré dans le jeu.
- **Aube et nuit** : les couleurs de la mer sont transposées depuis les bruts de ces ambiances. Les nuages de nuit reprennent les couleurs exactes des nuages de la nuit native.
- **Bulles, scintillements, trajets des nuages** : créés par nous.
