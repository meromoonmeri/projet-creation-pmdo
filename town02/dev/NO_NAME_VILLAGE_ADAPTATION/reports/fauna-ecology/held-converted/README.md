# Les 15 rooms HELD — converties en Grounds PMDO, dans leur saison native

Les **109 entités HELD** attendaient deux choses : le terrain saisonnier prouvé
(fait, `HELD_SEASONAL_TERRAIN.md`) et la **conversion en Ground PMDO**.
La conversion est produite ici.

## Résultat

15 rooms sur 15 converties puis normalisées ×0,125.
**0 échec, 0 tuile non résolue, 100 % de couverture partout.**

| Room | Saison native | Couverture | Cellules bloquantes |
|---|---|---:|---:|
| `rm14` | automne | 100,0 % | 1 264 |
| `rm23` | automne | 100,0 % | 926 |
| `rm24` | automne | 100,0 % | 1 775 |
| `rm25` | automne | 100,0 % | 2 019 |
| `rm33` | automne | 100,0 % | 1 737 |
| `rm34` | automne | 100,0 % | 1 440 |
| `rm35` | automne | 100,0 % | 1 918 |
| `rm43` | automne | 100,0 % | 1 847 |
| `rm44` | automne | 100,0 % | 1 679 |
| `rm45` | automne | 100,0 % | 1 832 |
| `rm37` | **hiver** | 100,0 % | 1 689 |
| `rm58` | **hiver** | 100,0 % | 1 756 |
| `rm59` | **hiver** | 100,0 % | 1 645 |
| `rm67` | **hiver** | 100,0 % | 2 103 |
| `rm69` | **hiver** | 100,0 % | 1 655 |

Géométrie identique pour les 15 : monde **624 px**, `TexSize` **1**, grille de
collision **78**, cellule de tuile **8 px**.

## La saison n'est pas une étiquette, elle repeint la carte

Un premier passage forçait `--season summer`. Le convertisseur **substitue le
tileset** de chaque couche selon la table saisonnière : les 5 rooms d'hiver
ressortaient avec un **sol vert** au lieu de la neige. Mesuré sur `rm58` :
source dominée par (197,211,232), converti par (105,182,91).

`tools/detect_native_season.py` détermine la saison depuis la donnée seule, par
vote sur l'index de `Background` de chaque couche `Tiles`. Il retrouve
**exactement** le classement 10 automne / 5 hiver établi par
`HELD_SEASONAL_TERRAIN.md` avec une **autre méthode** (familles d'objets
`objau*` / `objwn*`). Deux méthodes indépendantes, même résultat.

Effet mesurable de la correction : la couverture passe de **98,5–99,3 %** à
**100 % sur les 15**.

## Vérification visuelle

`ALL_NOPROOF_COLLISION.png`, voile rouge sur les cellules bloquantes. Regardé :
les 10 rooms d'automne sont orangées, les 5 d'hiver enneigées, la collision
épouse troncs, falaises et bords d'eau. Aucun gris de fond : pas de trou.

## Ce qui reste

`promotion_allowed` reste **`false`** pour les 109 entités. Il reste :

- les **blockers du convertisseur**, conservés sans filtrage : faune non liée
  au moteur, transitions non résolues, couches `Effect` non portées ;
- le **runtime PMDO 0.8.12**, jamais exécuté ici — ni `dotnet` ni `mono`.
  Statut `NOT_CERTIFIED`.

Grounds hors Git sous `.runtime-cache/nnv-held-grounds/`, reproductibles :
`python3 tools/convert_noproof_rooms.py --rooms rm14 … --outdir …`.
