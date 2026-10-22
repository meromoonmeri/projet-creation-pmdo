# Rendus PNG des zones NNV au format PMDO

Rendus complets, lus **depuis les fichiers PMDO transformés** (post-normalisation
×0,125). Aucun fichier de map modifié pour les produire.

## Fichiers

| Fichier | Contenu |
|---|---|
| `nnv_spring.png` | rmvillage printemps, 624×624 px |
| `nnv_summer.png` | rmvillage été, 624×624 px |
| `nnv_autumn.png` | rmvillage automne, 624×624 px |
| `nnv_winter.png` | rmvillage hiver, 624×624 px |
| `NNV_ALL_SEASONS.png` | planche comparative des 4 saisons |

Chaque rendu est la map **entière**, tous layers visibles composités dans
l'ordre de profondeur, à l'échelle PMDO native (`TexSize 1`, cellule 8 px).

## Portée : une seule zone existe en PMDO

**Seule `rmvillage` a été convertie au format PMDO.** Les rendus ci-dessus
couvrent donc l'intégralité de ce qui existe aujourd'hui.

La source NNV contient **98 rooms** :

| Catégorie | Nombre | État PMDO |
|---|---:|---|
| `world` (extérieurs) | 72 | **non converties** |
| `system` | 13 | exclues (menus, écrans) |
| `interior` | 7 | **non converties** |
| `cave` | 6 | **non converties** |

Les 4 maisons de `rmvillage` (`playerhouse`, `loggerhouse`, `hunterhouse`,
`carpenterhouse`) ont des intérieurs dans la source, mais ils ne sont pas
encore convertis — les portes actuelles pointent vers des cibles absentes.

## Ce que montrent les rendus

Le village complet est lisible : quatre maisons, chemins de terre, murets de
pierre, clairières, bois dense en périphérie. Les quatre saisons partagent
exactement la même géométrie et ne diffèrent que par leur contenu saisonnier —
l'hiver ayant en plus ses traces rouges et son `groundtex` vide, conformément
aux données source.

## Reproduire

Le rendu est produit par composition directe des layers depuis les
`.rsground` / `.layers.json.gz` et leurs tilesets `.tile`, via le lecteur natif
`read_tile_sheet` (dépremultiplication alpha incluse).

## Statut

Rendus de contrôle. La map reste `APPLIED_NOT_CERTIFIED` : le runtime
PMDO 0.8.12 n'a pas pu être relancé (bundle headless absent du cache).
