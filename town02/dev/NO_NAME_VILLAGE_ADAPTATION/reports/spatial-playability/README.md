# Échelle spatiale et confort de jeu — audit définitif

Audit **read-only**. Aucune modification de NNV, aucun asset ajouté ou retiré,
aucun terrain importé, aucun ajustement manuel.

## Conclusion

> **Pour obtenir une NNV agréable à jouer et visuellement cohérente avec
> l'échelle PMDO, le facteur recommandé est ×0,25.**

C'est le **seul** facteur techniquement valide qui place **3 critères sur 3**
dans la bande PMDO, **sans aucune perte de pixel**.

## Ce qui a changé par rapport à mon audit précédent

Mon audit `d691158` recommandait **×0,125**. **Il était faux, et je le corrige.**

L'erreur : je comparais la **résolution du dessin** (pixels d'art) au lieu de
**l'emprise dans le monde** (cellules de collision). Faire coïncider un dessin
de 118 px avec un dessin de 114 px ne dit rien sur l'espace que la maison
occupe, ni sur la largeur des chemins, la taille des parcelles ou les distances.

Or la grille de collision fait **8 px dans NNV comme dans tous les Grounds
PMDO**. Elle mesure donc déjà l'espace monde dans l'unité de PMDO. C'est la
bonne règle, et elle donne un résultat différent.

## Méthode

Corpus de référence : **192 Grounds PMDO validés** (TexSize 1, ≥ 60 cellules,
avec structures réelles) — villages, places, rues, zones construites,
végétalisées et ouvertes. Pas seulement `metano_town`.

Mesures, toutes en cellules de collision de 8 px :

- **largeur des chemins** = longueurs de segments libres contigus ;
- **emprise des structures** = composantes connexes bloquées ;
- **densité** = ratio libre/bloqué.

## Résultats

| Facteur | Cellule | TexSize | Critères OK | Écart moyen | Sans perte | Valide |
|---|---:|---:|---:|---:|---|---|
| ×1 (natif) | 64 px | 8 | 1/3 | 257,5 % | oui | oui |
| ×0,5 | 32 px | 4 | 1/3 | 105,6 % | oui | oui |
| **×0,25** | **16 px** | **2** | **3/3** | **36,1 %** | **oui** | **oui** |
| ×0,125 | 8 px | 1 | 1/3 | 55,3 % | **non (−17 %)** | oui |

### Détail ×0,25 — tout est dans la bande

| Mesure | NNV ×0,25 | En Pokémon | PMDO médian | Bande | Verdict |
|---|---:|---:|---:|---|---|
| Chemin médian | 10,0 cellules | 5,0 | 10,0 | 6–18,4 | **OK** (exact) |
| Chemin p75 | 23,5 | 11,8 | 17,0 | 10,3–26 | **OK** |
| Emprise structure | 13,8 | 6,9 | 46,0 | 12–66 | **OK** |

### Détail ×0,125 — deux échecs

| Mesure | NNV ×0,125 | En Pokémon | PMDO médian | Bande | Verdict |
|---|---:|---:|---:|---|---|
| Chemin médian | 5,0 cellules | 2,5 | 10,0 | 6–18,4 | **HORS** — trop étroit |
| Chemin p75 | 11,8 | 5,9 | 17,0 | 10,3–26 | OK |
| Emprise structure | 6,9 | 3,4 | 46,0 | 12–66 | **HORS** — écrasé |

×0,125 produit précisément le **monde sous-dimensionné** que vous vouliez
éviter : chemins de 2,5 Pokémon de large, bâtiments compressés, circulation
étranglée. Et il coûte 17 % du détail.

## Les deux erreurs opposées, mesurées

- **×1 natif — monde surdimensionné.** Chemin médian de 40 cellules =
  20 Pokémon de large. Un Pokémon paraît minuscule, les trajets sont
  interminables. C'est le défaut actuel.
- **×0,125 — monde sous-dimensionné.** Chemin de 2,5 Pokémon, structures à
  3,4 Pokémon. Le Pokémon paraît énorme, les espaces de circulation
  disparaissent.
- **×0,25 — équilibre.** Chemin de 5 Pokémon : on croise confortablement,
  la map reste lisible, le Pokémon appartient au décor.

## Un constat que le facteur ne peut pas corriger

`espace libre` : NNV **63,4 %** contre **21 %** en médiane PMDO.

C'est un **ratio**, donc invariant à l'échelle : **aucun facteur ne le
changera**. NNV est un village intrinsèquement plus aéré, plus forestier, que
la moyenne PMDO. C'est un parti pris de level design, pas un défaut d'échelle.

Conséquence concrète : même à ×0,25, NNV restera plus ouvert que Metano. Si
vous voulez une densité de bâti comparable, cela relèvera d'un travail de
**placement** (ajouter des structures), pas d'un redimensionnement.

## Ce que ×0,25 implique concrètement

| Élément | Effet |
|---|---|
| **Sol** | cellule 64 px → 16 px (`TexSize 2`) ; motif inchangé, densité d'art 4 → 1 |
| **Chemins** | 40 → 10 cellules = 5 Pokémon de large, exactement la médiane PMDO |
| **Parcelles** | divisées par 4 ; restent généreuses mais parcourables |
| **Bâtiments** | maison 948 → 237 px ≈ 14,8 Pokémon, dans la bande PMDO |
| **Arbres** | 389 → 97 px ≈ 6 Pokémon, cohérent avec un grand arbre PMDO |
| **Distances** | trajets divisés par 4 ; monde 4992 → 1248 px, comparable aux 1512 px de Metano |
| **Densité** | inchangée en ratio (63 % libre) : NNV reste aéré |
| **Pokémon** | jamais redimensionné ; passe de « minuscule » à intégré au décor |

**Sans perte** : la densité d'art NNV est 4, donc diviser par 4 retire
exactement l'agrandissement figé dans la source GameMaker. Réversible à 100 %,
nearest-neighbour, sans interpolation ni recoloration.

## Preuve visuelle

`GAMEPLAY_SCALE_COMPARISON.png` — même surface de monde affichée pour chaque
hypothèse, avec un carré rouge de 16 px (1 Pokémon) comme étalon constant.

À ×1 on ne voit qu'un pan de toiture ; à ×0,5 une façade ; à **×0,25 une maison
entière avec sa cour, son chemin et ses arbres** — cadrage comparable à
`metano_town` ; à ×0,125 la scène devient dense et les éléments menus.

## Échelle des assets PMU

Inchangée et confirmée : **×1**. Les structures PMU sont déjà à l'échelle PMDO
native (`tiles0_0367` = 145×170 px, identique à un composant maison de Metano).
Une fois NNV normalisée à ×0,25, elles s'y intégreront directement, sans
transformation, pixel-faithful.

## Reproduire

```bash
cd NO_NAME_VILLAGE_ADAPTATION/tools
python3 audit_spatial_playability.py
```

Rapport machine : `spatial-playability.json`.

## Statut

`AUDIT_COMPLETE_AWAITING_VALIDATION`. Aucune transformation appliquée,
`rmvillage` byte-identique.
