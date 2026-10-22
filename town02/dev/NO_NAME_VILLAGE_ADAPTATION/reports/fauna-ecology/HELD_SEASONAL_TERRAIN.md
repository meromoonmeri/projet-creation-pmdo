# Les 109 HELD — le terrain saisonnier existait déjà pour 10 rooms sur 15

## Une généralisation qui n'était pas vérifiée

Les 109 entités étaient retenues avec ce motif :

> « variante de Ground de la saison non convertie/rendue ; hiver diverge à 100 %
> de l'été (mesure sur `rmvillage`) »

La mesure sur `rmvillage` est juste, et `PREUVE_SAISONNIERE.md` la documente
correctement. Mais elle a été **transposée** aux 15 autres rooms sans être
retestée sur elles.

`rmvillage` est un cas particulier : c'est la **seule** room à posséder quatre
variantes saisonnières, commutées à l'exécution par la variable globale
`season`. Pour elle, « le rendu d'été ne prouve rien pour l'hiver » est exact.

Les 15 rooms HELD ne fonctionnent pas comme ça. Chacune est peinte **dans une
seule saison, en dur**. Il n'y a pas de « variante automne de `rm14` » à
produire : `rm14` **est** la room d'automne.

| Room | Instances saisonnières | Famille |
|---|---|---|
| `rm14` | 463 `objau*` · 4 `objsp*` | automne |
| `rm44` | 997 `objau*` · 6 `objsp*` | automne |
| `rm67` | 500 `objwn*` · 19 `objsp*` | hiver |
| `rm58` | 542 `objwn*` · 21 `objsp*` | hiver |

Aucune room ne mélange automne et hiver. Et pour les 15, **la saison exigée par
les entités HELD est exactement la saison native de la room** — 15/15.

## Double vérification, parce que la famille d'objets ne suffit pas

Savoir qu'une room contient des objets d'automne ne prouve pas que l'atlas
utilisé pour placer la faune décrit bien ce terrain-là. Le PNG versionné a donc
été **reclassifié indépendamment** avec le classifieur de `build_biome_atlas.py`,
puis comparé cellule par cellule au terrain de l'atlas, sur les seules cellules
issues du rendu (`open`, `grass`, `water`, `marsh`, `snow`).

| Room | Saison | Divergence atlas ↔ rendu | Verdict |
|---|---|---:|---|
| `rm45` | automne | 0,2 % | **TERRAIN_PROVEN** |
| `rm43` | automne | 1,2 % | **TERRAIN_PROVEN** |
| `rm33` | automne | 1,4 % | **TERRAIN_PROVEN** |
| `rm44` | automne | 1,8 % | **TERRAIN_PROVEN** |
| `rm25` | automne | 2,2 % | **TERRAIN_PROVEN** |
| `rm34` | automne | 2,3 % | **TERRAIN_PROVEN** |
| `rm24` | automne | 2,5 % | **TERRAIN_PROVEN** |
| `rm23` | automne | 2,6 % | **TERRAIN_PROVEN** |
| `rm14` | automne | 3,7 % | **TERRAIN_PROVEN** |
| `rm35` | automne | 4,2 % | **TERRAIN_PROVEN** |
| `rm59` | hiver | **43,8 %** | `HELD` |
| `rm69` | hiver | **51,5 %** | `HELD` |
| `rm37` | hiver | **60,7 %** | `HELD` |
| `rm67` | hiver | **69,5 %** | `HELD` |
| `rm58` | hiver | **70,0 %** | `HELD` |

Seuil : 10 %. La coupure est nette — l'automne est sous 4,2 %, l'hiver au-dessus
de 43,8 %. Aucun cas limite à arbitrer.

## Pourquoi l'hiver échoue, précisément

La divergence hivernale n'est pas du bruit, elle est **systématique et d'un seul
type** :

| Room | Transition dominante | Cellules |
|---|---|---:|
| `rm58` | `grass` (atlas) → `open` (rendu) | 2 708 |
| `rm67` | `grass` (atlas) → `open` (rendu) | 2 442 |

L'atlas voit de l'**herbe** là où le rendu montre du **sol nu enneigé**. Le
classifieur repose sur `is_green_rgb`, et la neige NNV est un lavande très clair
qui ne déclenche ni `is_snow_rgb` (seuil 200/205/210) ni le test de vert. Les
compteurs de l'atlas le disent d'ailleurs eux-mêmes : `rm58` annonce
**2 711 cellules `grass` et 62 `snow`** pour une room enneigée.

**C'est exactement le risque décrit dans `PREUVE_SAISONNIERE.md`** : un Pokémon
placé sur une cellule `grass` qui n'est pas de l'herbe. Le fail-closed était
justifié — pour l'hiver.

## Ce qui change, et ce qui ne change pas

| | Avant | Après |
|---|---:|---:|
| Terrain saisonnier prouvé | 0 | **66** (10 rooms, automne) |
| Terrain non prouvé | 109 | **43** (5 rooms, hiver) |

Espèces dont le terrain est désormais prouvé : `ledyba` 20, `dwebble` 13,
`chinchou` 10, `swanna` 9, `ariados` 7, `lotad` 7.

Restent bloquées : `piloswine` 16, `delibird` 10, `swinub` 9, `crabrawler` 4,
`ducklett` 4.

**Aucune entité n'est promue par ce rapport.** `promotion_allowed` reste `false`.
Ce qui est levé est le blocage **terrain**, et lui seul. Il manque toujours,
pour les 109 :

1. la **conversion en Ground PMDO** des 15 rooms ;
2. le **runtime PMDO 0.8.12**, inexécutable ici (ni `dotnet` ni `mono`, hôtes de
   distribution .NET à `000`).

Pour les 5 rooms d'hiver, il faut en plus **corriger `is_snow_rgb`** pour
reconnaître la neige lavande de NNV, puis régénérer l'atlas. Tant que ce n'est
pas fait, leurs 43 entités restent `HELD` — le seuil n'est pas assoupli pour
elles.

## Reproduire

```bash
python3 NO_NAME_VILLAGE_ADAPTATION/tools/audit_held_seasonal_terrain.py
```

## Statut

`TERRAIN_PROVEN_10_ROOMS · HELD_5_ROOMS · promotion_allowed=false`

---

# Mise à jour — les 5 rooms d'hiver après correction de `is_snow_rgb`

## La cause était dans le classifieur, pas dans les données

`is_snow_rgb` exigeait `r>200, g>205, b>210`, c'est-à-dire un blanc franc. Les
deux couleurs qui couvrent le sol des rooms d'hiver NNV sont **(197,211,232)**
et **(180,185,227)** : un lavande clair. Trop bleutées pour ce seuil, pas assez
vertes pour `is_green_rgb`, elles retombaient en `open`.

Nouveau discriminateur : clair, bleuté mais pas cyan (sinon c'est l'eau), et de
faible saturation. **Mesuré sur les 34 rendus versionnés** : les 5 rooms d'hiver
sortent entre **61,3 % et 69,7 %** de neige, les 29 autres plafonnent à **6,5 %**.
Séparation nette, aucun arbitrage nécessaire, aucun faux positif en automne.

## Effet sur l'atlas

| Room | Cellules reclassées | `grass` avant → après | `snow` avant → après |
|---|---:|---:|---:|
| `rm37` | 3 544 | 2 389 → **0** | 15 → **3 450** |
| `rm58` | 3 500 | 2 711 → **0** | 62 → **3 366** |
| `rm59` | 3 129 | 1 730 → **0** | 14 → **2 933** |
| `rm67` | 3 243 | 2 445 → **0** | 25 → **3 157** |
| `rm69` | 3 480 | 2 109 → **0** | 9 → **3 337** |

Plus une seule cellule d'herbe dans une room enneigée. Les classes posées par
les objets (`tree`, `rock`, `plant`) et par la collision (`blocked`) sont
**préservées** : elles ne sont pas recalculables ici, les Grounds reconvertis de
`/tmp/reconv` n'existant plus dans ce bac à sable.

## Une réserve à ne pas masquer

Après régénération, l'audit affiche **0,0 % de divergence** sur les 5 rooms.
**Ce chiffre ne prouve rien** : l'atlas vient d'être réécrit à partir de cette
même reclassification, la comparaison est donc circulaire. Il confirme que
l'écriture a bien eu lieu, rien de plus.

La vérification qui a du sens est ailleurs : les **43 positions candidates**
des entités d'hiver ont été confrontées à l'habitat déclaré de leur espèce dans
`fauna-species.json`, terrain et voisinage compris.

**43 conformes, 0 non conforme.**

`piloswine`, `swinub` et `delibird` déclarent `snow` dans leur habitat et
tombent sur des cellules `snow`. `crabrawler` sort sur `snow` près de rochers.
`ducklett` sur `rm59` tombe sur `water`/`open` en bord d'eau, conforme à son
habitat `near_water,water` ; sur `rm58` sa cellule est `open` mais à moins de
2 cases de l'eau, ce qui satisfait `near_water`.

Le placement était donc **écologiquement correct dès l'origine** — c'est
l'étiquette du terrain qui était fausse, pas la position.

## Bilan des 109

| | Avant | Après |
|---|---:|---:|
| Terrain prouvé | 0 | **109** (15 rooms) |
| Terrain non prouvé | 109 | **0** |

**Aucune promotion pour autant.** `promotion_allowed` reste `false`. Le blocage
terrain est levé sur les 15 rooms ; il reste, pour promouvoir :

1. la **conversion en Ground PMDO** des 15 rooms ;
2. le **runtime PMDO 0.8.12**, toujours inexécutable ici.

## Statut

`TERRAIN_PROVEN_15_ROOMS · promotion_allowed=false · runtime NOT_CERTIFIED`
