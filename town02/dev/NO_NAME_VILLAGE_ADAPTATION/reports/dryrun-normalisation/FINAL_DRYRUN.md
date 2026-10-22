# DRY-RUN FINAL ×0,125 — simulation complète, aucune écriture

**Read-only.** Aucun fichier de `Data/`, aucun Ground, aucune saison, aucune
structure remplacée, aucun asset final créé. `rmvillage` byte-identique.

---

## Les 12 réponses demandées

### 1. Échelle PMDO de référence
- unité monde = **8 px** (cellule de collision, invariante sur 423 Grounds)
- `TexSize 1` → cellule de tuile **8 px**
- Pokémon = **16×16 px** = 2×2 unités monde
- maison type = **114 px** médian (7,12 Pokémon)
- petit décor / rocher = **24 px** médian (1,50 Pokémon)

### 2. Échelle NNV actuelle
- `TexSize 8` → cellule de tuile **64 px**
- monde 4992 px, grille de tuiles 78×78, collision 624×624
- maison 948 px, arbre 389 px, rocher 196 px

### 3. Facteur mathématique NNV → PMDO
```
cellule PMDO / cellule NNV = 8 / 64 = 0,125
```
Sur-taille décomposée : **densité d'art (×4) × motif dessiné (×2) = ×8**.
La densité seule n'imposait donc pas ×0,25 — c'est bien ×0,125.

### 4. Taille d'un Pokémon avant / après
**16×16 px → 16×16 px. INCHANGÉE.** Le Pokémon n'est jamais redimensionné ;
c'est le monde NNV qui vient à lui.

### 5–8. Rapports Pokémon ↔ décor

| Rapport | NNV avant | NNV après ×0,125 | Cible PMDO | Verdict |
|---|---:|---:|---:|---|
| **Pokémon ↔ arbre** | 24,3 Pk | **3,00 Pk** | 3,0 | **COHÉRENT** |
| **Pokémon ↔ maison** | 59,2 Pk | **7,38 Pk** | 7,12 | **COHÉRENT** |
| **Pokémon ↔ rocher** | 12,2 Pk | **1,50 Pk** | 1,50 | **COHÉRENT** (exact) |
| **Pokémon ↔ terrain** | 4,00 Pk/cellule | **0,50 Pk/cellule** | 0,50 | **COHÉRENT** (exact) |

Le rocher normalisé tombe **exactement** sur la médiane du petit décor PMDO
(24 px, mesurée sur 336 colliders réels).

### 9. Taille native des buildings PMU comparables
48 structures confirmées : **40–212 px** de large, médiane **98 px**
(6,1 Pokémon). Structures PMDO metano : 88–304 px, médiane 114 px
(7,1 Pokémon). **Les deux populations se recouvrent** → PMU est déjà à
l'échelle PMDO. Aucun redimensionnement, ni ×4 ni ×0,25.

### 10. Intégration des buildings PMU ×1 dans NNV normalisée

| Facteur | Maison NNV | / médiane PMU | Verdict |
|---|---:|---:|---|
| ×1 | 948 px | 9,67× | PMU minuscule |
| ×0,25 | 237 px | 2,42× | PMU encore 2,4× trop petit |
| **×0,125** | **118 px** | **1,21×** | **PMU s'intègre** |

Preuve : `FINAL_4SEASONS_x0125_with_native_PMU.png` — le building
`tiles0_0367` (145×170, jamais redimensionné) se lit comme une maison du
village dans les quatre saisons.

### 11. Perte exacte de détail induite par ×0,125

Mesurée sur le **motif réel** (résolution de dessin), pas sur les octets :

| Métrique | Maison | Terrain (4 saisons) |
|---|---:|---:|
| Pixels d'art altérés | 25,7 % | **6,8 %** |
| Pixels opaques altérés | 29,9 % | — |
| **Silhouette divergente** | **1,4 %** | **4,2–4,6 %** |
| **Palette perdue** | **1/54 couleur** | **0–4/34** |
| Détails isolés de 1 px altérés | 65 % (683 → 445) | — |

**Nature exacte de la perte** : la silhouette, les masses de couleur et la
palette survivent presque intégralement. Ce qui se dégrade, ce sont les
**lignes fines de 1 pixel** — hachures du toit, joints de planches.

**Alternative testée et rejetée** : le rééchantillonnage BOX (moyenne) préserve
mieux la structure mais fabrique **399 couleurs au lieu de 53** — interdit par
la règle pixel-faithful. **NEAREST reste le seul procédé conforme.**

**Atténuation** : la source GameMaker est vérifiée
(`data.win`, SHA-256 `2f33b595…`). La transformation est **reproductible** à
tout facteur, même si le fichier produit n'est pas inversible.

### 12. Géométrie identique sur les 4 saisons

| Saison | `TexSize` | Grille | Layers | Géométrie |
|---|---:|---:|---:|---|
| spring | 8 | 78×78 | 15 | **IDENTIQUE** |
| summer | 8 | 78×78 | 15 | **IDENTIQUE** |
| autumn | 8 | 78×78 | 15 | **IDENTIQUE** |
| winter | 8 | 78×78 | 15 | **IDENTIQUE** |

Les empreintes d'occupation par layer sont alignées ; l'hiver ne diffère que
par son **contenu saisonnier** (`groundtex` vide, végétation réduite), jamais
par sa géométrie. Perte homogène sur les quatre (6,7–6,8 %) : aucune saison
n'est désavantagée.

---

## Géométrie après transformation

| Élément | Avant | Après ×0,125 |
|---|---:|---:|
| Monde | 4992 px | **624 px** |
| Cellule de tuile | 64 px | **8 px** |
| `TexSize` | 8 | **1** |
| Grille de tuiles | 78×78 | **78×78 (inchangée)** |
| Grille de collision | 624×624 | **78×78** |
| Maison | 948 px | 118 px |
| Arbre | 389 px | 48 px |
| Rocher | 196 px | 24 px |

**Arrondis** : un seul cas, `Exit_Door_106508` (X=940, non divisible par 8) —
**sans objet**, les portes sont supprimées avec les maisons.

**Règle sur les entités** : positions ÷8 ; **tailles des markers et Pokémon
INCHANGÉES** (16×16, référentiel PMDO).

---

## Réserves à connaître avant validation

1. **Perte irréversible sur les lignes fines** — 65 % des détails 1 px altérés.
   Visible de près sur les toitures ; peu perceptible en jeu à l'échelle
   normale, mais réel.
2. **Monde compact** — 624 px contre 1512 px pour Metano. NNV deviendra un
   village nettement plus petit que Metano.
3. **Largeur de chemin** — 5 cellules après normalisation, contre 13,8 pour la
   médiane des Grounds PMDO ouverts. Assumé : cette statistique confond
   chemins et clairières, et NNV est ouvert à 63,4 %.
4. **Particules hiver** (`ssnow1`, `ssnow2`, `spttrail01`) — assets séparés,
   **non couverts** par ce dry-run, à traiter explicitement.

---

## Conclusion

```
PMDO  = étalon           (cellule 8 px, Pokémon 16 px)
NNV   = ×0,125 vers cet étalon
PMU   = natif ×1, jamais redimensionné
```

Les quatre rapports Pokémon↔décor deviennent **COHÉRENTS**, et un building PMU
natif cesse de paraître minuscule.

## Statut

`FINAL_DRYRUN_COMPLETE_AWAITING_APPROVAL`. Aucune modification appliquée.
J'attends votre validation explicite avant toute transformation réelle.
