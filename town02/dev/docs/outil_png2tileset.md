# `png2tileset.py` — convertir un PNG en tileset RogueEssence/PMDO

> **Rien n'a été testé en jeu.** Tout ce qui suit est vérifié par lecture du
> moteur et par mesure sur les fichiers du dépôt.

Un PNG (illustration d'arène, planche de tuiles dessinée à la main, capture)
devient une planche `.tile` indexée, et si on veut une carte de combat
`.rsmap` ou un décor `.rsground` prêts à charger.

---

## Commandes

```bash
# 1. Inspecter sans rien écrire : découpage, résidu, taux de doublons
python3 tools/png2tileset.py decoupe image.png --tile 24

# 2. Créer seulement la planche .tile (+ réindexation)
python3 tools/png2tileset.py importer image.png Nom_Planche --tile 24 --apply

# 3. Créer une CARTE DE COMBAT complète (.rsmap)
python3 tools/png2tileset.py carte image.png Nom_Planche sortie.rsmap \
        --tile 24 --sol 560,700 --apply

# 4. Créer un DÉCOR (.rsground)
python3 tools/png2tileset.py ground image.png Nom_Planche sortie.rsground \
        --grid 8 --sol 560,700 --apply

# 5. Relire une planche existante et en sortir un aperçu
python3 tools/png2tileset.py verifier MtBristlePeak
```

| option | rôle |
|---|---|
| `--tile N` | taille de tuile (**24** = donjon, valeur de `GraphicsManager.TileSize`) |
| `--grid N` | pas de grille d'un ground (**8** × `TexSize`) |
| `--align X,Y` | décale le découpage, pour choisir où tombe la coupe |
| `--seuil N` | % d'opacité minimum pour retenir une tuile (défaut 1) |
| `--sol X,Y` | **pixel échantillon du terrain marchable** — voir plus bas |
| `--apply` | écrit réellement ; sans lui, simple essai à blanc |

---

## Les trois pièges du format, et comment l'outil les traite

### 1. L'alpha est **prémultiplié** — le piège principal

`BaseSheet.ImportTex` (l.188-192) applique `premultiply(tex, false)` à
l'import, et `BaseSheet.Load` (l.63-73) **ne l'applique pas**. Les octets
stockés dans un `.tile` sont donc déjà prémultipliés.

Mesure de confirmation sur `Metano_Town_Objects` : **45 760 pixels d'alpha 0
testés, 0 avec un RGB non nul**, et tous les pixels d'alpha partiel
respectent `RGB ≤ A`. C'est la signature du prémultiplié.

Écrire un PNG standard donnerait des **halos clairs** sur tous les bords
transparents. L'outil prémultiplie à l'écriture et dé-prémultiplie à la
lecture.

**Un bug attrapé par le test de non-régression.** La dé-prémultiplication
n'est pas réversible sans perte : elle divise par l'alpha, et sur un alpha
faible l'erreur d'arrondi explose. Cas réel, pixel (1,2) de la tuile
(161,2) de `Metano_Town_Objects` :

```
stocké (191,127,63, a=4)  →  droit (255,255,255)  [saturé]
                          →  restocké (4,4,3)     [127/255 d'écart]
```

D'où un **mode brut** : `lire_planche(nom, brut=True)` +
`ecrire_planche(..., deja_premultiplie=True)` copient les octets d'origine
sans conversion. C'est ce qu'il faut pour **copier ou ré-empaqueter** une
planche existante.

### 2. La déduplication est **native au format**

Les tuiles identiques partagent le même offset. Ce n'est pas une
optimisation ajoutée : `Metano_Town_Base` déclare 35 646 entrées pour bien
moins d'images réelles. L'outil déduplique donc à l'écriture.

### 3. L'index conditionne l'affichage

`GraphicsManager.GetTile` lit la position dans `Content/Tile/index.idx`.
Une planche absente de l'index renvoie 0 → **tuile d'erreur affichée**.
L'outil appelle donc `rebuild_tile_index.py` après chaque écriture.

---

## Détection sol / mur

**Sans `--sol`** : heuristique de luminance, les tuiles les plus claires
sont supposées marchables. Rapide, mais elle se trompe dès qu'il y a un
ciel clair. Sur l'arène de Tornadus elle classait **le ciel et les nuages
en terrain marchable** (ciel lum 225 > plateforme lum 138).

**Avec `--sol X,Y`** : on échantillonne la tuile contenant ce pixel et on
retient celles de même profil — luminance **et saturation**. C'est la
saturation qui tranche proprement :

| zone | luminance | saturation |
|---|---|---|
| plateforme (sol) | 138 | **10** |
| corniche (sol) | 137 | **10** |
| ciel / nuage | 225 | **44** |
| roche sombre (mur) | 68 | 17 |

Résultat sur l'arène de Tornadus : le ciel est exclu, la plateforme
centrale et les corniches sont retenues.

⚠️ Cette détection reste une **aide au dégrossissage**, pas une vérité.
Un terrain de combat doit toujours être revérifié (connectivité, positions
des combattants) avant usage — c'est le rôle des outils de validation
existants.

---

## Contrôles automatiques

L'outil refuse ou signale :

- un PNG qui **n'est pas un multiple** de la taille de tuile — il annonce
  le résidu en pixels et prévient qu'il sera ignoré (sur l'image de
  Tornadus : `reste 23x23 px`) ;
- une carte de **combat** demandée en tuiles ≠ 24 px (`--force` pour
  passer outre) ;
- un pas de grille de ground qui n'est pas un multiple de 8.

Après chaque écriture, il **relit la planche** et la compare à la source,
puis affiche `VERIFICATION : OK` ou `ECHEC`.

---

## Résultats mesurés

**Non-régression** — relire une planche du jeu, la réécrire, la relire :

| planche | tuiles | taille | écart |
|---|---|---|---|
| `MtBristlePeak` | 7 047 | 8 px | **0/255** |
| `Metano_Town_Objects` | 16 766 | 8 px | **0/255** |
| `MountainPeak` | 572 | 24 px | **0/255** |
| `Metano_Town_Base` | 35 646 | 8 px | **0/255** |

**Bout en bout** — l'image de l'arène de Tornadus (1128×1344, recadrée au
multiple de 24) convertie en `.rsmap`, puis rendue et comparée au PNG
source :

```
pixels différents : 0 / 1 516 032
écart max : 0
```

47 × 56 = 2 632 tuiles, dont 2 632 uniques (aucun doublon dans cette
illustration).

L'index régénéré après nettoyage est **identique à l'original** ; les
baselines du dépôt sont inchangées (**12 / 849**).


---

## Mode `anime` — nuages et cascades qui bougent

```bash
python3 tools/png2tileset.py anime image.png Nom sortie.rsground \
        --grid 8 --frames 4 --herite ground_existant --apply
```

| option | rôle |
|---|---|
| `--frames N` | nombre d'images de la boucle (défaut 4) |
| `--framelen N` | durée d'une image (défaut 10, la cadence de l'eau du mod) |
| `--vit-eau N` | px de chute par image (défaut 3) |
| `--vit-nuage N` | px de dérive horizontale par image (défaut 1) |
| `--herite G` | reprend les entités d'un ground existant |

### Le patron est natif, pas inventé

Relevé tel quel sur la rivière de `metano_town.rsground` :

```
Frames = [ {Sheet: Metano_Town_River_Animation_1, TexLoc:(45,186)},
           {Sheet: ..._2, TexLoc:(45,186)}, ... ]   FrameLength = 10
```

Le mod compte déjà **8 273 cellules** construites ainsi. L'outil remplit
le même moule : une planche par image, mêmes coordonnées.

**Deux vitesses, une seule cadence** : les nuages dérivent à 1 px/image,
l'eau tombe à 3 px/image. Le décalage est cyclique, donc la boucle est
invisible. Seules les cellules qui bougent sont dupliquées — sur Cloven
Ruins, **3 611 sur 24 310**, pas toute la carte.

### Séparer la cascade du ciel : le vrai piège

Cascade et ciel ont **la même couleur bleue** :

| | RGB |
|---|---|
| cascade | (43,97,181) · (81,160,236) |
| ciel | (191,211,239) |

Un seuil `B - R > 70` marquait donc **tout le pourtour du ciel** comme eau
qui tombe — 106 831 px au lieu de 10 236. Vérifié visuellement : le
masque débordait sur tout le fond.

Trois critères de forme sont nécessaires, appliqués sur les blocs
connexes :

1. **plus haut que large** (`h > w × 1,6`) — une chute est verticale ;
2. **étroit** (`w < 12 %` de l'image) — le ciel forme un bloc immense ;
3. **détaché des bords** — sept langues de ciel longeaient le cadre et
   passaient les deux premiers tests.

Résultat : les **deux vraies cascades** (x 148-185 et x 976-1012) isolées,
les blocs de ciel de 27 164 et 29 598 px écartés.

### Aucune bande noire

`ScrollEdge.Blank` (0) affiche le vide ; **`Clamp` (1) bride la caméra aux
bords** (`BaseGroundScene.cs:136-153`). C'est la valeur de 232 des 276
grounds du mod, et l'outil la force.

L'outil **refuse** en plus toute carte plus petite que l'écran
(320 × 240) : en dessous, le moteur centre la carte et laisse du vide.
Aegis Cave fait 1144 × 1360, soit **3,6 × 5,7 écrans**.

### Collisions par logique spatiale

**Ce qui ne marche pas.** La couleur seule ne sépare pas le marchable de
l'infranchissable :

| | RGB |
|---|---|
| chemin de terre | (205,187,97) |
| herbe | (207,186,97) — **identique à 1 près** |
| falaise | (173,148,77) — voisine de l'herbe |

La rugosité locale ne tranche pas davantage (herbe 8,6 · arbre 14,0 ·
falaise 15,0 — les plages se recouvrent), ni la distance au vide
(falaise nord 70 px, herbe 72 px). Premier jet : 28 % de sol praticable
et **deux spawners d'équipiers dans la roche**.

**Ce qui marche : trois matières, trois signatures.**

| matière | critère | pourquoi |
|---|---|---|
| **vide** | `B-R > 25` ou blanc saturé | hors de l'île il n'y a que du ciel |
| **feuillage** | vert **et** luminance < 110 | l'herbe est verte aussi, mais claire |
| **roche** | `B > 100` et `R > B` | canal **bleu** haut (118-187) vs sol jaune-vert bas (59-98) |

Le canal bleu est la trouvaille : relevé en échantillonnant les colonnes
rocheuses une par une, c'est le seul axe qui sépare franchement la roche
beige du sol jaune.

**Puis on raisonne en cellules, pas en pixels.** Le moteur ne connaît que
des cellules : on calcule la *fraction* d'obstacle par cellule
(`--seuil-obs`, défaut 0,45), puis on supprime les amas de moins de
3 cellules (`--amas`) — un obstacle isolé au milieu d'une esplanade est
du bruit de texture, pas un rocher. Cela retire ~500 fausses collisions.

**Deux garde-fous automatiques :**

- **Contrôle de jouabilité** : parcours depuis le marqueur d'entrée. Si
  moins de 80 % du sol est atteignable, l'outil prévient que la carte est
  morcelée et suggère de baisser `--seuil-obs`.
- **Dégagement des entités** : les collisions sont calculées *après* le
  repositionnement, donc une entité peut atterrir sur un arbre que
  l'ancienne carte ignorait. L'outil cherche la cellule libre la plus
  proche **entourée de cellules libres** — un personnage occupe ~20 px,
  une case isolée entre deux rochers ne suffit pas. C'est exactement le
  cas rencontré : TEAMMATE_2 posé dans un massif d'arbres, recalé une
  première fois sur une case libre mais enclavée, puis correctement en
  (512,1088) après durcissement du critère.

Résultat sur Aegis Cave : **69 % de sol praticable**, **98 %** de ce
sol connexe depuis l'entrée, entrée du donjon atteignable, **0 entité en
défaut**.

### Entités préservées

`--herite` reprend marqueur d'entrée, spawners d'équipiers et objets
scriptés, puis les **repositionne** à l'échelle de la nouvelle carte.
Sans cela, remplacer un décor casserait tous les scripts qui le
référencent. Contrôle après coup sur Aegis Cave : **6 entités, 0 en
défaut**, et l'entrée du donjon est atteignable depuis le point
d'arrivée (17 963 cases connexes).

### Résultat mesuré

| contrôle | résultat |
|---|---|
| rendu vs PNG source | **0 pixel d'écart** / 1 555 840 |
| relecture des planches | 20 699 tuiles, **0 écart** |
| animation | ~130 000 px changent entre deux images |
| entités hors sol | **0 / 6** (après dégagement auto) |
| sol praticable | 16 874 / 24 310 cellules (**69 %**) |
| connexité depuis l'entrée | **98 %** |
| baselines | **12 / 849**, inchangées |
