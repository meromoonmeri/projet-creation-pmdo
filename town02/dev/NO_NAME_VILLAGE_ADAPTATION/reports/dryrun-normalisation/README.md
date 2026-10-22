# DRY-RUN comparatif — NNV ×0,25 vs ×0,125

**Read-only.** Aucun fichier de `Data/`, aucun Ground, aucune saison, aucun
sprite, aucune collision, aucun building n'est modifié. Sorties uniquement dans
ce dossier de rapport.

## Conclusion

```
PMDO SCALE        = cellule 8 px (TexSize 1), Pokémon 16 px, maison ~114 px
NNV CURRENT SCALE = cellule 64 px (TexSize 8), maison 948 px
NNV → PMDO        = ×0,125
PMU BUILDINGS     = NATIF ×1, jamais redimensionnés
```

```
POKÉMON ↔ ARBRE   : COHÉRENT      (3,04 vs 3,0 Pokémon)
POKÉMON ↔ MAISON  : COHÉRENT      (7,41 vs 7,12 Pokémon)
POKÉMON ↔ ROCHER  : COHÉRENT      (1,53 vs 1,5 Pokémon)
POKÉMON ↔ TERRAIN : COHÉRENT      (cellule 8 px = 0,5 Pokémon, identique PMDO)
```

**Vous aviez raison : ×0,125 est la vraie normalisation.** Je corrige ma
recommandation ×0,25 précédente.

## Ce qui a fait basculer la décision

Le critère décisif n'est pas une statistique de largeur de chemin, c'est
**l'intégration des buildings PMU à leur taille native** — le problème concret
que vous aviez signalé (« ils paraissent minuscules »).

| Facteur | Maison NNV | Maison / médiane PMU | Verdict |
|---|---:|---:|---|
| ×1 natif | 948 px | **9,67×** | PMU minuscule |
| ×0,25 | 237 px | **2,42×** | **PMU encore 2,4× trop petit** |
| **×0,125** | **118 px** | **1,21×** | **PMU s'intègre naturellement** |

La preuve visuelle `PMU_IN_NNV_x025_vs_x0125.png` le montre : le même building
`tiles0_0367` (145×170, jamais redimensionné) flotte dans un décor
surdimensionné à ×0,25, alors qu'à ×0,125 il domine sa parcelle comme une
véritable maison de village.

## Densité du pixel art ≠ échelle du monde

Distinction respectée : la densité d'art ×4 n'impose **pas** un facteur ×0,25.
Elle décrit comment l'art est *stocké*. L'échelle du monde se mesure à
l'occupation réelle, et elle donne ×0,125 — car le motif NNV est lui-même
dessiné ~2× plus grand que le motif PMDO. Sur-taille totale = 4 × 2 = 8.

## Tableau comparatif complet

| Critère | ×0,25 | ×0,125 | Référence PMDO |
|---|---:|---:|---:|
| Monde | 1248 px | 624 px | 1512 px (metano) |
| Cellule de tuile | 16 px | **8 px** | **8 px** |
| `TexSize` | 2 | **1** | **1** |
| Grille collision | 156 | 78 | 189 |
| Grille de tuiles | 78×78 | 78×78 | inchangée |
| Maison | 237 px / 14,8 Pk | **118 px / 7,4 Pk** | **114 px / 7,1 Pk** |
| Arbre | 97 px / 6,1 Pk | **48 px / 3,0 Pk** | **~3,0 Pk** |
| Rocher | 49 px / 3,1 Pk | **24 px / 1,5 Pk** | **~1,5 Pk** |
| Terrain/cellule | 1,0 Pk | **0,5 Pk** | **0,5 Pk** |
| Ratio PMU | 2,42× (trop petit) | **1,21× (naturel)** | 1,0 |
| Pokémon | 16×16 inchangé | 16×16 inchangé | 16×16 |

**×0,125 aligne `TexSize`, la cellule et les quatre rapports Pokémon sur PMDO.**

## Contraintes techniques

**Arrondis** — un seul cas : `Exit_Door_106508` en X=940 (non divisible par 8).
**Sans objet** : les quatre portes sont supprimées avec les maisons NNV
(décision déjà validée). Monde (4992) et grille (624) sont divisibles.

**Perte de pixels** — c'est le coût réel. La densité d'art est 4 ; le second
halving dépasse cette densité :

| Facteur | Tuiles sans perte (été) | Réversible |
|---|---:|---|
| ×0,25 | **100 %** | oui |
| ×0,125 | **1 %** | non (~17 % des octets) |

**Atténuation** : la source GameMaker est préservée et vérifiée
(`data.win`, SHA-256 `2f33b595…`). Une régénération à n'importe quel facteur
reste possible — la transformation est donc *reproductible* même si le fichier
produit n'est pas *inversible*.

**Taille du monde** — à ×0,125 NNV fait 624 px contre 1512 px pour Metano. NNV
deviendrait un village compact. C'est cohérent avec 78×78 cellules de collision
et son taux d'ouverture de 63,4 %, mais c'est un changement notable à assumer.

## Tension mesurée et assumée

Sur la seule métrique « largeur de chemin », ×0,25 collait mieux : les Grounds
PMDO ouverts (≥55 % libre) ont une médiane de 13,8 cellules ; ×0,25 donne 10,0
et ×0,125 donne 5,0.

J'ai priorisé la cohérence structurelle et l'intégration PMU, pour une raison
mesurée : la « longueur de segment libre » confond **chemins** et **clairières**.
NNV étant ouvert à 63,4 %, ses grandes étendues gonflent artificiellement cette
statistique — elles ne sont pas des couloirs. Les rapports Pokémon↔objets et
l'intégration PMU sont des indicateurs plus directs de l'échelle perçue.

## Portée de la transformation

**Fichiers qui seraient modifiés** (aucun ne l'est aujourd'hui) :

- 4 tilesets : `NNV_rmvillage_{Spring,Summer,Autumn,Winter}_Source.tile`
- 1 Ground complet : `summer/.../nnv_rmvillage_summer.rsground`
- 3 bundles : `{spring,autumn,winter}/.../*.layers.json.gz`
- Le miroir `living/` : 4 environnements + `summer_living.rsground`
- 4 manifests + `seasons_summary.json` + `season_router_manifest.json`
- `life/entities_patch.json` (coordonnées des entités Pokémon)

**Règle sur les entités** :

- **positions (X,Y)** → divisées par le facteur ;
- **tailles d'entités (markers 16×16, Pokémon)** → **INCHANGÉES**, elles
  appartiennent au référentiel PMDO ;
- **portes** → supprimées avec les maisons.

**Quatre saisons** : signature identique (TexSize 8, 78×78, 15 layers) dans les
quatre. Le facteur doit leur être appliqué **en une seule opération** pour
préserver l'alignement.

**Animations / particules** : les cycles de sprites sont dans les tilesets et
suivent la réduction. Les particules hiver (`ssnow1`, `ssnow2`, `spttrail01`)
sont des assets séparés, à traiter explicitement — non couverts par ce dry-run.

## Reproduire

```bash
cd NO_NAME_VILLAGE_ADAPTATION/tools
python3 dryrun_normalisation_compare.py
```

## Statut

`DRY_RUN_COMPLETE_AWAITING_APPROVAL`. Aucune écriture, aucune décision
d'intégration. `rmvillage` byte-identique. J'attends votre feu vert.

Point à trancher avant toute application : **acceptez-vous la perte de ~17 %
du détail** inhérente à ×0,125, sachant que la source permet une régénération ?
