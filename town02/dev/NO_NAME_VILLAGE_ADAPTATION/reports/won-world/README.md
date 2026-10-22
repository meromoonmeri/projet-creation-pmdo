# Waves of Nostalgia fusionné avec No Name Village

## Ce qui existait avant, et pourquoi ça ne suffisait pas

`docs/waves_nostalgia_structures/` contenait **4 bâtiments découpés** sur
5 cartes, dont 3 marquées `NO_QUALIFYING_BUILDING`. C'est une bibliothèque de
sprites, pas un village.

Le monde réel compte **16 cartes** `overw*` dans la ROM.

## La ROM, récupérée et vérifiée

`WavetoNostalgia.NDS` du dépôt `meromoonmeri/PMD-RED-PMDO-PORT`.

```
sha256  5d2b5c7b9942c7eca2115d486eec69b9060418b09fc215ad6f104d46b544f0db
taille  152 547 776 octets
```

Ce SHA est **identique** à celui déjà déclaré dans le manifeste versionné :
c'est bien la ROM d'origine du projet, pas un substitut.

L'hôte LFS `github-cloud.githubusercontent.com` répond `000` depuis ce bac à
sable. `codeload.github.com` résout les pointeurs côté serveur — c'est le seul
contournement, déjà éprouvé sur ce projet.

## Les 16 cartes

| Groupe | Cartes |
|---|---|
| Village | `overw1` |
| Variantes horaires | `overw1e` (soir), `overw1n` (nuit), `overwf` (fête) |
| Annexes extérieures | `overw2` sentier, `overw3` rivière, `overw4` plage, `overw4a` plage gelée, `overw4n` plage nuit, `overw5` clairière, `overw5e` clairière soir |
| Intérieurs | `overwh`, `overwhn`, `overwyh`, `overwhb`, `overwhbn` |

## Aucun rescale — les trois référentiels coïncident

```
Waves of Nostalgia   8 px par tuile
unité monde PMDO     8 px
NNV normalisé ×0,125 8 px
```

Rapport **1**. Convertir revient à recopier. Mesuré sur les 16 cartes.

## Un défaut de rendu évité

Un appel naïf `bma.to_pil(bpc, bpl, [], ...)` fait émettre des centaines de
`contains invalid tile reference. Replaced with 0.` : les tuiles animées (eau,
feuillage, feu) deviennent des trous — **silencieusement** si on ne lit pas
`stderr`.

Les BPA sont déclarées dans `bg_list.dat`, non devinables depuis le nom de
fichier. Elles sont lues là et passées au rendu.

## Collision native, jamais déduite d'une image

Le `.bma` porte une valeur par cellule de 8 px. Elle est recopiée telle quelle.

**Défaut trouvé et résolu sur preuve.** Six cartes sortaient à `collision = 0`,
soit des mondes entièrement traversables où l'on aurait franchi maisons et mer.
Ce sont **exactement** les variantes horaires. Vérification : elles déclarent
`number_of_collision_layers == 0` et partagent la grille **exacte** de leur
carte de jour (6/6). Le moteur réutilise la collision du jour.

Elle est donc **héritée explicitement**, l'origine est consignée, et l'héritage
est **refusé** si les grilles diffèrent. Résultat : **0 carte sans collision**,
vérifié à l'image sur `overw1n`.

## Saisonnalisation — deux défauts corrigés

**1. Le sol restait vert.** La pelouse WoN vit à H 0,155–0,18, *juste* sous
l'ancien seuil de 0,18. En hiver, le feuillage virait au lavande pendant que le
sol restait jaune-vert d'été. Borne descendue à **0,155**.

Elle ne peut pas descendre plus bas : à H 0,111 se trouve `(255,223,159)`,
couleur **exactement partagée** par la pelouse claire et le chemin de sable.
Recolorer peindrait les chemins. Vérifié à l'image.

**2. L'automne était rose fluo.** Un décalage rigide de teinte supposait que
tout le feuillage partage celle de l'arbre d'été. Faux : la verdure s'étale de
0,155 à 0,45. Le décalage de −0,216 envoyait la pelouse à H 0,037 — du **rouge**.

Remplacé par un **recentrage** de l'écart autour de la teinte cible
(`HUE_SPREAD = 0,45`). Automne roux, hiver lavande, nuances préservées.

NNV revalidé après ces deux changements : `COHERENT`, 23 313 px de maçonnerie
0 divergence, 9 966 px de feuillage 0 figé.

## Les liaisons

**6 liaisons, 12 sens, réciprocité vérifiée, 0 refus.** 24 `init.lua` générés,
syntaxe validée par un vrai parseur Lua (24/24).

Une sortie est posée au milieu du plus long segment de bord **réellement
franchissable**, mesuré dans la grille de collision (≥ 3 cellules libres). Si
aucun bord n'en offre, la liaison est refusée et consignée — jamais forcée sur
une falaise.

### Deux origines, jamais confondues

| Origine | Sens |
|---|---|
| `canonical` | transition présente dans les scripts `.ssb` de la ROM |
| `adaptation` | **couture créée pour ce mod** |

La jonction `overw1 ↔ rmvillage` est marquée **`adaptation`** : elle n'existe
dans aucune des deux sources, NNV ignore WoN et réciproquement. La présenter
comme canonique serait un mensonge.

### Variantes horaires non reliées à pied

`overw1n` est le *même lieu* à un autre moment. Le moteur les substitue ; on ne
marche pas de `overw1` à `overw1n`. Aucune sortie n'est posée entre elles.

### Topologie obtenue

```
nnv_rmvillage  ←→  overw1  ←→  overw3  ←→  overw5
                     ↕
                   overw2
                     ↕
                   overw4  ←→  overw4a
```

`WORLD_MERGED.png` montre le monde assemblé.

## Ce qui n'est pas fait

- Les **5 intérieurs** ne sont pas câblés : ils se rejoignent par une porte, pas
  par un bord de carte. Il faut désigner quelle maison ouvre sur quel intérieur.
- Les **objets et PNJ** ne sont pas importés : les `.ssa` ne contiennent que des
  placeholders de scène, le mobilier est peint dans les cartes.
- Le côté **NNV** de la jonction n'a pas encore sa sortie : `rmvillage` a déjà
  son `init.lua`, y ajouter la sortie touche un fichier suivi.
- **Runtime PMDO 0.8.12** jamais exécuté : ni `dotnet` ni `mono` ici.
  `NOT_CERTIFIED`.

Les Grounds (68 Mo) restent hors Git sous `.runtime-cache/won-grounds/`,
reproductibles par `tools/convert_won_grounds.py`.
