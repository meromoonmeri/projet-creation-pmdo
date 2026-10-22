# Retrait des deux maisons PMU hors parcelle

## Le défaut

Le village comptait **6 bâtiments PMU** pour **4 parcelles NNV**.

Le commit `9de06a7d` — intitulé sans ambiguïté *« **Add two more** PMU houses on
real NNV clearings »* — avait ajouté deux maisons sur des clairières, avec des
emplacements inventés (`hamlet_center`, `hamlet_south`) qui ne correspondent à
aucune structure NNV existante :

| Frame | Asset | Taille | Position | Parcelle |
|---|---|---:|---|---|
| 0 | — | 122×120 | (50, 361) | `objplayerhouse` |
| 1 | — | 116×99 | (102, 181) | `objloggerhouse` |
| 2 | — | 115×98 | (478, 215) | `objhunterhouse` |
| 3 | — | 126×94 | (176, 3) | `objcarpenterhouse` |
| **4** | `tiles9_0361` | 110×98 | (304, 272) | **aucune** ❌ |
| **5** | `tiles9_0380` | 125×88 | (432, 456) | **aucune** ❌ |

La demande était de **remplacer** les 4 structures NNV, pas d'en ajouter.
Ces deux maisons n'ont jamais été demandées.

## Le retrait ne se limitait pas aux sprites

Poser ces deux maisons avait aussi **modifié le terrain** sous elles. Mesuré
contre l'état d'avant `9de06a7d` :

| Élément | Quantité |
|---|---:|
| `Decorations` ajoutées | 2 |
| Cellules d'herbe effacées (`NNV grass0`) | 715 |
| Cellules d'herbe effacées (`NNV grass1`) | 480 |
| Cellules de collision 8 px posées | 219 |

Retirer seulement les sprites aurait laissé **deux clairières pelées avec des
murs invisibles**. Les trois modifications sont annulées ensemble.

## Restauration, pas reconstruction

Le terrain n'est ni redessiné ni extrapolé : il est **relu dans le Ground tel
qu'il était avant** `9de06a7d`. La géométrie est vérifiée identique avant toute
écriture (TexSize 1, grille 78, mêmes 15 couches) — sinon l'outil refuse.
Chaque cellule restaurée est copiée depuis la donnée historique.

## Résultat vérifié

| Contrôle | Valeur |
|---|---|
| `Decorations` | `[0,1,2,3,4,5]` → **`[0,1,2,3]`** |
| Frames de la planche | 6 → **4** |
| Planche identique aux 4 saisons | ✅ |
| Herbe restaurée | 1 195 cellules |
| Collision restaurée | 219 cellules |
| Bâtiments de parcelle touchés | **aucun** (0–3 intacts) |
| Relecture après écriture | `[0,1,2,3]` ✅ |

Les 4 saisons rematérialisées affichent **4 bâtiments chacune**, vérifié aussi
à l'image sur `GROUND_ALL_SEASONS.png` : plus de maisons parasites, terrain
intact, aucune clairière pelée.

## Un verrou périmé, corrigé au passage

`verify_season_building_coherence.py` exigeait `len(placed) == 6` en dur. Après
retrait, il renvoyait **`DIVERGENT` avec 0 divergence réelle** — un verdict
d'échec sur un état correct. Le seuil est désormais `EXPECTED_BUILDINGS = 4`,
« une structure par parcelle NNV », et le test est revérifié par mutation :
1 pixel repeint ⇒ `DIVERGENT`, sortie 1.

Résultat actuel : **4 bâtiments, 33 279 px opaques comparés, 0 divergence,
`COHERENT`**.
