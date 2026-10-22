# Promotion des Grounds Waves of Nostalgia dans New Era

## Ce qui est installé

| Élément | Nombre | Emplacement |
|---|---:|---|
| Grounds | **64** | `Data/Ground/won_<carte>_<saison>.rsground` |
| Planches de tuiles | **64** | `Content/Tile/WoN_<carte>_<saison>.tile` |
| Scripts de sortie | **24** | `Data/Script/halcyon/ground/won_*/init.lua` |
| Entrées d'index | **64** | `Content/Tile/index.idx` (741 → 805) |

16 cartes × 4 saisons = 64 Grounds.

## Audit de texture — préalable bloquant

La promotion **refuse de s'exécuter** si l'audit n'est pas `CLEAN`. Promouvoir
des textures dont l'intégrité n'est pas prouvée reviendrait à installer un bug.

`TEXTURE_AUDIT.json` — **16 cartes, 0 anomalie, verdict `CLEAN`**. Six contrôles :

1. **Fidélité pixel** — chaque Ground est recomposé depuis sa planche exactement
   comme le moteur le fera, puis comparé au rendu ROM. Égalité **stricte** exigée
   sur la saison de référence.
2. **Tuiles résolues** — 0 cellule sans texture.
3. **Cellules vides** — 0.
4. **Alignement** — `TexSize`, planche, collision et grille de tuiles concordent.
5. **Alpha prémultiplié** — aucun canal RGB supérieur à son alpha (source de halos).
6. **Divergence saisonnière** — les saisons diffèrent si et seulement s'il y a du
   feuillage.

### Vérifié par mutation, pas seulement exécuté

Un audit qui ne sait pas échouer ne prouve rien.

| Mutation | Résultat |
|---|---|
| 1 tuile repeinte en magenta (sur 1 620) | `ANOMALIES`, 64 px détectés, sortie 1 ✅ |
| 1 `TexLoc` décalé d'une cellule | `ANOMALIES`, 27 px détectés, sortie 1 ✅ |

## Le damier mauve — écarté par mesure

`GraphicsManager.GetTile()` rend `BaseSheet.LoadError()` — le damier — dès que
`TileIndex.GetPosition()` renvoie `0`, ce qui arrive si la planche est absente
d'`index.idx` **ou** si le couple `(X,Y)` n'y figure pas.

`verify_tile_index.py` sur les 64 Grounds installés :

```
tuiles vérifiées : 250 416
AUCUN DAMIER : toutes les tuiles sont résolvables
```

## Non-régression de l'index

| Contrôle | Résultat |
|---|---|
| Planches avant / après | 741 / 805 |
| Ajoutées | 64 |
| **Supprimées** | **0** |
| Entrées préexistantes intactes | ✅ comparées une à une après écriture |
| Sauvegarde avant écriture | `index.idx.pre-won.bak` |

L'index est réécrit **intégralement depuis sa propre lecture** : aucun offset
recalculé à la main. Si une entrée préexistante avait bougé, la sauvegarde
aurait été restaurée automatiquement.

## Une anomalie trouvée — et elle n'est pas de moi

`verify_tile_index.py` signale sur `metano_town.rsground` :

```
planche "" ABSENTE de index.idx -> DAMIER (cause A)
```

**Vérifié : préexistant.** La planche `""` était absente de l'index **avant**
comme **après** ma promotion, et mes 64 ajouts n'ont rien supprimé
(`set(avant) ⊆ set(après)`). `metano_town.rsground` n'est pas modifié par ce
commit — seul `index.idx` l'est.

Il s'agit de **17 frames à `Sheet: ""` / `TexLoc (0,0)`** dans la couche
`Objects Under Anim` : un motif PMDO de frame vide. Je le signale sans le
corriger : ce n'est pas mon périmètre, et le maquiller serait pire que le dire.

## Rendu depuis `Data/` — ce que lira le moteur

`INSTALLED_FROM_DATA.png` : les 4 saisons de `overw1` recomposées depuis
`Data/Ground/` et `Content/Tile/` installés, **0 tuile absente**. Regardé :
printemps vif, été, automne roux, hiver lavande, chemins de sable intacts.

## Scripts

24 `init.lua` installés, syntaxe validée par un **vrai parseur Lua** (24/24),
pas par comptage de mots-clés.

## Ce qui n'est pas prouvé

Le **runtime PMDO 0.8.12** n'a jamais été exécuté : ni `dotnet` ni `mono` dans
ce bac à sable, les hôtes .NET répondent `000`. Tout ce qui précède porte sur
les octets écrits et une composition hors moteur.

**`NOT_CERTIFIED`** — je ne peux pas affirmer que le jeu démarre et affiche ces
cartes ; je peux affirmer que rien dans la donnée ne l'en empêche.
