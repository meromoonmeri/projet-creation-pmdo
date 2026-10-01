# Zone de réveil V2 — prairie de Sky Peak face à l'océan (jour, aube, crépuscule, nuit) — projet PMDO 0.8.12

Projet d'édition autonome, namespace `zone_reveil_prairie_horizon_v2`. C'est **la première scène** : le Pokémon se réveille dans une grande prairie fleurie de Sky Peak, au bord d'un promontoire plat, face à l'océan.

La V2 garde **la disposition de la V1** : même prairie, mêmes collisions, mêmes marqueurs. Seuls la mer et l'arrière-plan sont refaits, et chacun a son propre calque :

- **Mer** : générée avec la carte V24P04A de PMD Ciel en référence, et animée selon les lois relevées dans la ROM. Les crêtes naissent en houle sombre sous l'horizon, grandissent en descendant et roulent vers la prairie (12 crans de 10 ticks). Comme dans V24P04A, chaque crête couvre presque tout le motif de 96 px, et une fine ligne de houle continue court sous chaque rangée : il n'y a pas de trou entre les vagues. L'horizon scintille (16 crans de 4 ticks).
- **Ondes** : les fines lignes de houle et les plaques de reflets clairs que le générateur avait peintes dans la mer restaient figées. Elles ont leur propre calque et bougent maintenant au rythme de la houle : chacune décrit l'orbite de l'eau sous les vagues (un va-et-vient d'avant en arrière et de haut en bas), et l'ondulation descend vers le rivage avec les crêtes. Les plaques claires s'éteignent un instant, comme les reflets. La mer de fond est rebouchée avec son propre grain.
- **Écume et bulles** : celles de la V1, au pied de la prairie.
- **Montagne** : celle de la V1. Ses flancs descendent jusqu'à l'horizon.
- **Nuages** : un banc posé sur l'horizon, sans nuage rogné, qui défile lentement **derrière** la montagne. Il fait toute la largeur de l'écran (768 px) : trois bancs générés différents sont raccordés bout à bout, donc **aucun nuage ne revient deux fois à l'écran** (avant, un banc de 256 px se répétait trois fois). La profondeur va de l'avant vers l'arrière : mer, montagne, nuages.
- **Lune (nuit), soleil levant (aube), soleil couchant (crépuscule)** : chacun a un reflet sur la mer, dessiné au générateur. Ses traits ondulent au rythme de la houle, la déformation descend vers le rivage avec les crêtes, et quelques traits s'éteignent un instant.
- **Fleurs** : les têtes se balancent comme dans le GIF de Sky Peak (cycle A B A C).

Quatre Grounds, même disposition, mêmes collisions :

| Ground | Ambiance |
|---|---|
| `zrv2_zone_reveil_jour` | plein jour, ciel bleu |
| `zrv2_zone_reveil_aube` | aube, ciel du violet au rose, soleil levant et son reflet doré |
| `zrv2_zone_reveil_crepuscule` | crépuscule, ciel du violet à l'orange, soleil couchant à demi derrière les nuages, reflet rouge orangé |
| `zrv2_zone_reveil_nuit` | nuit, pleine lune derrière le sommet, reflet, étoiles qui scintillent |

**Aucun warp** : c'est une base d'édition, pas une aventure jouable. **Non testé dans PMDO.**

## Installer

- **Mod séparé** : copier `zone_reveil_prairie_horizon_v2` dans `PMDO/MODS/`, activer le mod, puis ouvrir les Grounds dans l'éditeur (mode développeur).
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis la même commande sans `--dry-run`. L'installeur ne remplace jamais un fichier existant différent. Il sauvegarde l'index des tuiles avant de le fusionner.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe unie) | fixe |
| 01 | Ciel | fixe |
| 02 | Étoiles (nuit seulement) | 24 × 5 ticks |
| 03 | Lune ou soleil (nuit, aube, crépuscule) | fixe |
| 04 | Nuages : le banc défile de 2 px par cran, sur une boucle de 768 px (toute la largeur) | 384 × 16 ticks |
| 05 | Montagne | fixe |
| 06 | Mer (fond) | fixe |
| 07 | Ondes : lignes de houle et reflets clairs peints dans la mer, en orbite au rythme de la houle | 12 × 10 ticks |
| 08 | Scintillement de l'horizon | 16 × 4 ticks |
| 09 | Houle et crêtes | 12 × 10 ticks |
| 10 | Reflet de la lune ou du soleil (nuit, aube, crépuscule) | 12 × 10 ticks |
| 11 | Écume au pied de la prairie (celle de la V1) | 10 × 10 ticks |
| 12 | Bulles (celles de la V1) | 24 × 5 ticks |
| 13 | Herbe | fixe |
| 14 | Chemin | fixe |
| 15 | Fleurs | 4 × 12 ticks |
| 16 | Rochers | fixe |
| 17 | Buissons | fixe |
| 18 | Vide, `Layer=4` (Top) | — |

Les banques sont préfixées `ZRV2J_`, `ZRV2A_`, `ZRV2C_` et `ZRV2N_` (jour, aube, crépuscule, nuit). Toutes les boucles se referment ; la plus longue fait 6144 ticks, soit 102 s (les nuages).

## Marqueurs et collisions

Ils sont repris tels quels de la V1 :

- `reveil` : au bord nord de la prairie, au centre, tourné vers l'océan. C'est là que le héros se réveille.
- `entrance` : au bord sud, sur le chemin. C'est la sortie de la zone.
- La mer, l'arrière-plan, les rochers et les buissons sont bloqués. L'herbe, les fleurs et le chemin sont praticables.

## Origine des pixels

- **Prairie** (herbe, chemin, fleurs, rochers, buissons) : ce sont les calques de la V1, eux-mêmes générés avec le GIF de Sky Peak en référence. Au crépuscule, les couleurs viennent d'une édition générée du décor de la V1, recalée au pixel près, par la même recette que l'aube et la nuit de la V1.
- **Écume et bulles** : celles de la V1 (palette 8 de s01p02a). Au crépuscule, la palette est transposée de la même façon.
- **Reflets** : une planche générée de trois colonnes (lune, aube, crépuscule). Chaque trait est replacé sous l'astre.
- **Ciel et mer, crêtes, banc de nuages, lune et soleil** : générés avec les captures de V24P04A et V24P02A en référence.
- **Montagne** : la montagne de la V1, redessinée seule à partir de son recadrage.

Ce sont des pixels générés, pas des tuiles natives.

- **Cadences** (houle 12 × 10, scintillement 16 × 4, motif de 96 px) : relevées dans la ROM (pret/pmd-sky, carte v24p04a).
- **Aube, crépuscule, nuit** : les couleurs du ciel, de la mer, de la montagne et des nuages sont transposées depuis les bruts de ces ambiances.
- **Balancement des fleurs** : mesuré sur le GIF de Sky Peak.
- **Trajet des nuages, raccord des trois bancs, mouvement des reflets et des ondes, étoiles** : créés par nous.
- **Les petits pics sombres** de la mer de nuages de la V1 ne sont pas repris.
