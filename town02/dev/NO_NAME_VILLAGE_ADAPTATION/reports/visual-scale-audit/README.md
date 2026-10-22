# Audit d'échelle visuelle — NNV `rmvillage` vs `metano_town`

Audit **read-only**. Rien n'est modifié : aucun fichier de `Data/`, aucune map,
aucun asset final. Mesures, formules et rendus de comparaison uniquement.

## Conclusion

**`PMU_NEEDS_SCALE_ADAPTATION`** — facteur **×4** pour 44 des 48 structures
confirmées, **×2** pour les 4 déjà dessinées en densité 2.

## L'étalon : le Pokémon fait 16×16 px partout

Vérifié sur 10 Grounds PMDO indépendants (`metano_town`, `guild_second_floor`,
`altere_pond`, `dojo_ossatueur`…) : **le collider d'un Pokémon vaut 16×16 px
dans tous les cas, quel que soit le `TexSize`**. C'est donc une règle fiable
pour comparer deux maps. Toutes les mesures ci-dessous sont exprimées en
« Pokémon ».

## Les 7 grandeurs, séparées

| # | Grandeur | `metano_town` | NNV `rmvillage` | Rapport |
|---|---|---:|---:|---:|
| 1 | Résolution fichier `.tile` | 8 px | 64 px | 8 |
| 2 | **Densité du pixel d'art** | **1** | **4** | **4** |
| 3 | Cellule logique de tuile | 8 px | 64 px | 8 |
| 4 | `TexSize` | 1 | 8 | — |
| 5 | Tuile source réelle | 8 px | 64 / 128 px (GameMaker) | 8 |
| 6 | Grille de collision | 8 px | 8 px | **1** |
| 7 | Pokémon affiché au runtime | 16×16 px | 16×16 px | **1** |

La densité (ligne 2) est prouvée par **réversibilité exacte** en
nearest-neighbour, pas à l'œil : sur 60 tuiles échantillonnées, metano donne
densité 1 à 100 %, NNV densité 4 à 100 %.

## Le ×4 est une propriété de la source, pas du pipeline

L'inventaire GameMaker officiel déclare des tuiles source de **64×64 et
128×128 px** (`tlground`, `tlcliff`, `tlwater`…). Le convertisseur fait du 1:1
strict et n'ajoute aucun agrandissement. **Le ×4 vient donc du jeu d'origine**,
c'est une propriété du monde NNV — pas un artefact de conversion ni un upscale
de rendu.

## Mesures indépendantes convergentes

| Référence | `metano_town` | NNV | Rapport |
|---|---:|---:|---:|
| Cellule de terrain | 0,5 Pokémon | 4,0 Pokémon | 8 |
| Largeur de porte | 2,5–3,0 Pokémon | 8–12 Pokémon | ~4 |
| Largeur de maison | ~9–12 Pokémon | 59–75 Pokémon | ~6 |
| Densité de texture | 1 | 4 | **4** |

### Pourquoi trois rapports différents ? (point important)

Ils ne se contredisent pas, ils mesurent des choses différentes :

- **8** = rapport des cellules logiques. Une cellule NNV de 64 px contient
  16 pixels d'art (de 4 px), une cellule metano de 8 px en contient 8. En
  « motif », l'écart de cellule n'est donc que de 2.
- **4** = rapport de **densité de texture**. C'est celui qui gouverne la
  cohérence visuelle : à ×4, un pixel PMU aura exactement la taille d'un
  pixel NNV.
- **~6** = rapport de taille apparente des maisons. Il mélange la densité (×4)
  et un **choix artistique** : les maisons NNV sont aussi plus grandes en motif
  (~237 pixels d'art de large contre ~150 pour metano).

**Le facteur d'harmonisation à retenir est 4**, celui de la densité. Les ratios
8 et 6 ne doivent pas être appliqués : ils déformeraient les proportions.

## Réponses aux quatre rapports demandés

- **Pokémon ↔ terrain** : metano 1 Pokémon = 2 cellules ; NNV 1 Pokémon = ¼ de
  cellule. Le terrain NNV est 4× plus dense par unité de monde.
- **Pokémon ↔ maison** : metano ~9–12 Pokémon de large ; NNV 59–75. Une maison
  NNV est ~6× plus imposante face à un Pokémon.
- **Pokémon ↔ rocher / chemin** : mêmes motifs résolus sur 8 px chez metano,
  64 px chez NNV — rapport 4, cohérent avec la densité.
- **Pokémon ↔ arbre** : même logique, les arbres NNV sont dessinés en densité 4.

## Réponse directe : un Pokémon paraîtra-t-il ridiculement petit dans NNV ?

**Oui, relativement — et c'est mesuré, pas ressenti.**

Le Pokémon lui-même n'est pas rétréci : il fait 16×16 px dans NNV comme dans
metano. Mais comme le décor NNV est 4× plus dense par unité de monde, **le même
Pokémon paraît environ 4× plus petit face à un arbre ou une maison** que dans
`metano_town`. Face aux maisons NNV actuelles, l'écart perçu monte à ~6.

C'est un problème réel à traiter, mais il concerne les **sprites de
personnages**, pas les buildings : il faudra décider si les Pokémon de NNV
doivent être affichés agrandis pour rester crédibles dans ce décor. Cette
question dépasse le placement des buildings et mérite votre arbitrage séparé.

## Simulation d'harmonisation PMU (en mémoire, rien d'écrit)

| Densité native | Nombre | Facteur requis |
|---:|---:|---:|
| 1 | 44 | **×4** |
| 2 | 4 | **×2** |

Exemples, avec la taille obtenue en Pokémon :

| Structure | Natif | ×N | Harmonisé | En Pokémon |
|---|---:|---:|---:|---:|
| `tiles9_0554` | 196×230 | ×4 | 784×920 | 49,0 × 57,5 |
| `tiles0_0367` | 145×170 | ×4 | 580×680 | 36,2 × 42,5 |
| `tiles0_0357` | 88×112 | ×4 | 352×448 | 22,0 × 28,0 |
| `tiles9_0034` | 41×39 | ×4 | 164×156 | 10,2 × 9,8 |

Pour référence : maisons NNV actuelles 59–75 Pokémon, maisons metano ~9–12.
Une structure PMU en ×4 se situe donc **entre les deux**, ce qui est cohérent :
elle ne doit pas remplir l'ancienne emprise, seulement respecter la texture.

Le ×4 retenu est **entier, nearest-neighbour, sans interpolation, sans lissage,
sans recoloration** — donc réversible sans perte. C'est exactement la
transformation que l'art NNV a lui-même subie.

## Pourquoi harmoniser PMU et non NNV

NNV est la map à préserver : son mapping 1:1, ses quatre saisons, ses
collisions et son PASS runtime PMDO 0.8.12 sont déjà validés. La rééchelonner
détruirait ce travail. Ce sont les assets entrants qui s'adaptent.

## Provenance (inchangée)

`PMU.zip` reste l'**autorité canonique**. `Tiles0` et `Tiles9` sont
byte-identiques aux hashes déclarés ; `Tiles8` reste `REVIEW_REQUIRED`. Les 48
structures confirmées restent des extractions pixel-faithful.

## Reproduire

```bash
cd NO_NAME_VILLAGE_ADAPTATION/tools
python3 audit_visual_scale.py
```

Rapport machine : `visual-scale-audit.json`.

## Statut

`AUDIT_COMPLETE_AWAITING_VALIDATION`. Aucun building placé, aucune intégration,
aucun asset créé. `rmvillage` byte-identique.
