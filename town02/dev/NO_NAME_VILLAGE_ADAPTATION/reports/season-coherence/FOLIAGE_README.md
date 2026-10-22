# Feuillage assorti à la saison

## Le défaut

Le village entier vire à l'orange en automne et à la neige en hiver. Mais deux
bâtiments gardaient un feuillage **vert vif** en toute saison :

| Frame | Bâtiment | Verdure |
|---|---|---:|
| 0 | sanctuaire | 30,3 % |
| 2 | maison à feuilles | 65,7 % |

Plus l'asset du propriétaire, posé sur `objplayerhouse` : **47,7 %** de verdure.

Le verrou `verify_season_building_coherence.py` exigeait qu'un bâtiment soit
pixel-identique aux 4 saisons. C'est juste pour la pierre, le bois et la tuile.
Ça ne l'est pas pour des **feuilles**.

## La teinte n'est pas inventée

Elle est mesurée sur les sprites d'arbres que NNV utilise **réellement**, ceux
déclarés dans `season-vm-evidence.json` — médiane HSV sur ~99 000 px opaques :

| Saison | Sprite | H | S | V |
|---|---|---:|---:|---:|
| printemps | `bgtree` | 0,410 | 0,744 | 0,690 |
| été | `bgsmtree` | 0,310 | 0,641 | 0,655 |
| automne | `bgautree` | 0,094 | 0,725 | 0,898 |
| hiver | `bgwntree` | 0,649 | 0,207 | 0,890 |

L'été sert de référence : la planche PMU est authorée en teintes d'été. Le
décalage appliqué est celui qui mène de `bgsmtree` à l'arbre de la saison visée.

## Ce qui est recoloré, et ce qui ne l'est pas

Seuls les pixels verts : teinte ∈ [0,18 ; 0,45], saturation > 0,25, valeur > 0,12.
**Vérifié à l'image, frame par frame** — la sélection prend les feuilles et le
corps végétal, mais épargne l'or du sanctuaire, les coffres, le rouge, les murs
crème, l'auvent rose, le bois et le pain.

Le décalage porte sur la **teinte et la saturation**, jamais sur la luminosité :
les nervures claires et les dessous sombres survivent. Une feuille reste lisible
comme une feuille.

Le masque est calculé **une seule fois** et réutilisé pour les 4 saisons :
aucune dérive de bord possible.

## Un seuil de matérialité, décidé sur preuve visuelle

Le premier passage recolorait **4 frames sur 4**. Or le four à pain (frame 1) et
la maison-Pokémon (frame 3) n'ont pas de verdure — seulement **6 px** et
**248 px** détectés.

Je les ai **regardés** : ce sont des **liserés de contour et de l'antialiasing**,
pas des feuilles. Les recolorer aurait posé une frange orange ou lavande autour
de bâtiments qui n'ont aucune végétation.

Seuil retenu : **10 %** de pixels opaques. La coupure est franche — 30,3 % et
65,7 % d'un côté, 3,1 % et 0,08 % de l'autre. Les frames sous le seuil sont
recopiées **octet pour octet**, donc structurellement incapables de diverger.

## Le verrou renversé pour le feuillage

`verify_season_building_coherence.py` appliquait une seule règle : tout doit être
identique. Il déclarait maintenant `DIVERGENT` avec 23 601 divergences — sur un
comportement **voulu**.

Il applique désormais deux exigences **opposées** :

```
maçonnerie (hors masque) -> DOIT être identique aux 4 saisons
feuillage  (dans masque) -> DOIT différer ; un feuillage figé est un DÉFAUT
```

Le masque n'est pas redupliqué : il est **importé** de
`seasonalize_building_foliage.py`. Deux copies des seuils divergeraient un jour.

État actuel : **25 412 px de maçonnerie comparés, 0 divergence · 7 867 px de
feuillage, 0 figé · verdict `COHERENT`**.

### Testé par mutation, dans les deux sens

| Mutation | Attendu | Obtenu |
|---|---|---|
| 1 px de maçonnerie repeint en hiver | échec | `DIVERGENT`, 1 divergence, sortie 1 ✅ |
| 4 saisons rendues identiques (feuillage figé) | échec | `DIVERGENT`, 7 867 figés, sortie 1 ✅ |

Un verrou qui ne sait pas échouer ne prouve rien. Celui-ci échoue sur les deux
défauts opposés.

## Ce qui n'est pas prouvé

Le rendu et la cohérence sont vérifiés à l'image. Le **chargement PMDO 0.8.12**
ne l'est pas : ni `dotnet` ni `mono` disponibles ici. `NOT_CERTIFIED`.
