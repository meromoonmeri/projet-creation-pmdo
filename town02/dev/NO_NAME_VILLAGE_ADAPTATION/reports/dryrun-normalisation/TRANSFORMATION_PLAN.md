# Plan de transformation ×0,125 — DRY-RUN, aucune écriture

**Read-only.** Aucun fichier modifié. `rmvillage` byte-identique. Aucun asset
PMU touché, aucun décor ajouté ou supprimé, aucun réaménagement de level design.

Facteur validé : **NNV ×0,125** · **Pokémon ×1** · **PMU/PMDO ×1**.

---

## 1. Fichiers concernés — 56 au total

| Catégorie | Nb | Transformation |
|---|---:|---|
| **Tilesets `.tile`** | 8 | images 64→8 px, **NEAREST** uniquement |
| **Grounds `.rsground`** | 2 | `TexSize`, `obstacles`, coordonnées |
| **Bundles `.layers.json.gz`** | 6 | `tex_size`, `dimensions_px` |
| **Manifests** | 13 | métriques + hashes régénérés |
| **`entities_patch.json`** | 1 | positions ÷8 |
| **Résumés JSON** | 5 | métriques |
| **Runtime reports** | 9 | **à invalider** (re-test obligatoire) |
| **Scripts `.lua`** | 12 | **INCHANGÉS** — aucune coordonnée en dur |

Les 8 tilesets couvrent les 4 saisons **plus** leur miroir `living/`. Les deux
Grounds sont `summer` et `summer_living`.

## 2. Dimensions avant → après

| Élément | Avant | Après |
|---|---:|---:|
| Monde | 4992 × 4992 px | **624 × 624 px** |
| Cellule de tuile | 64 px | **8 px** |
| `TexSize` | 8 | **1** |
| Grille de tuiles | 78 × 78 | **78 × 78 (inchangée)** |
| Grille de collision | 624 × 624 | **78 × 78** |
| Cellule de collision | 8 px | **8 px (invariante)** |

**Point clé** : la grille de tuiles ne change pas. Les *données* de layers
(quelle tuile à quelle position) sont **strictement préservées** ; seules les
*images* du tileset sont réduites.

## 3. Coordonnées avant → après

| Entité | Avant | Après |
|---|---|---|
| `Entry_North` | (2496, 64) | (312, 8) |
| `Entry_South` | (2496, 4928) | (312, 616) |
| `Entry_West` | (64, 2496) | (8, 312) |
| `Entry_East` | (4928, 2496) | (616, 312) |
| `SourceSpawn_106317` | (2208, 4928) | (276, 616) |
| `SourceSpawn_106319` | (992, 3520) | (124, 440) |

**Règle stricte** :
- **positions (X, Y)** → divisées par 8 ;
- **tailles d'entités (markers 16×16, Pokémon)** → **INCHANGÉES**, elles
  appartiennent au référentiel PMDO ;
- **portes** `Exit_Door_*` → supprimées avec les maisons NNV.

## 4. Collisions

Les obstacles ne sont **pas** divisés : une case fait toujours 8 px. C'est leur
**nombre** qui passe de 624×624 à 78×78. La grille doit être **re-dérivée**
depuis les masques solides réduits, jamais rééchantillonnée.

`624 / 8 = 78` — division exacte, aucun arrondi.

## 5. Layers

Aucune modification structurelle : 15 layers, mêmes noms, même ordre, mêmes
visibilités, mêmes occupations. Seul `tex_size` passe de 8 à 1.

## 6. Quatre saisons

| Saison | `TexSize` | Grille | Layers | Géométrie |
|---|---:|---:|---:|---|
| spring | 8 → 1 | 78×78 | 15 | identique |
| summer | 8 → 1 | 78×78 | 15 | identique |
| autumn | 8 → 1 | 78×78 | 15 | identique |
| winter | 8 → 1 | 78×78 | 15 | identique |

**Transformation appliquée en une seule opération atomique** sur les quatre
bundles et leurs huit tilesets, pour garantir l'alignement. Les différences
saisonnières restent exactement celles des sources (hiver : `groundtex` vide,
végétation réduite).

## 7. Animations

Les cycles de sprites sont stockés **dans les tilesets** (`Frames`,
`FrameLength`). Ils suivent la réduction des images sans changement de timing
ni d'ordre. Aucune donnée d'animation n'est perdue.

## 8. Particules — HORS PÉRIMÈTRE

`winter/particles/` (`ssnow1`, `ssnow2`, `spttrail01`) reste
`conversion_status: UNIMPLEMENTED`. **Non modifié** par cette transformation,
conformément à votre consigne. Audit séparé requis.

## 9. Arrondis

| Donnée | Divisible par 8 ? |
|---|---|
| Monde 4992 | oui (624) |
| Collision 624 | oui (78) |
| Coordonnées d'entités | **oui — 0 exception** |
| `entities_patch.json` | **oui — 0 exception** |
| `Exit_Door_106508` X=940 | **non** — sans objet, porte supprimée |

## 10. Données non transformables automatiquement

1. **Runtime reports** — les 9 fichiers deviennent obsolètes. Le runtime
   PMDO 0.8.12 devra être **re-testé** sur les quatre saisons.
2. **Hashes de manifests** — tous les SHA-256 changent, à régénérer.
3. **Particules** — hors périmètre, décision séparée.
4. **Perte pixel** — irréversible sur les lignes 1 px ; régénération possible
   depuis `data.win` (`2f33b595…`).

## 11. Isolation des assets PMU — vérifiée

| Contrôle | Résultat |
|---|---|
| Chemin PMU vs périmètre NNV | **aucune intersection** |
| `docs/pmuniverse_buildings/` | hors `NO_NAME_VILLAGE_ADAPTATION/generated/` |
| 143 hashes SHA-256 suivis | `verify_pmuniverse_buildings.py` |
| 48 structures confirmées | `test_structure_autonomy.py` |

Les buildings PMU restent **strictement ×1**. Toute réduction accidentelle
serait détectée par ces deux vérificateurs.

## 12. Rendu final simulé

`FINAL_RENDER_pokemon_nnv_pmu.png` combine :

- **terrain NNV ×0,125** (NEAREST, palette préservée) ;
- **building PMU `tiles0_0367` natif ×1** (145×170, non redimensionné) ;
- **Pokémon PMDO natif ×1** (sprite réel extrait de `Content/Chara/1.chara`,
  dessiné 20×23 px, collider 16×16).

Résultat : le Pokémon, la maison, les arbres, les rochers et les chemins
appartiennent visiblement au **même monde**. Un Pokémon devant la porte a une
présence crédible ; les arbres le dominent sans l'écraser.

---

## Ordre d'exécution proposé (non exécuté)

1. Sauvegarde des artefacts actuels (hashes déjà suivis).
2. Réduction NEAREST des 8 tilesets.
3. Mise à jour `TexSize` 8→1 sur les 2 Grounds et 6 bundles.
4. Re-dérivation des collisions 624→78.
5. Division des positions d'entités par 8, tailles préservées.
6. Régénération des 13 manifests et 5 résumés.
7. Invalidation des 9 runtime reports.
8. Re-test runtime PMDO 0.8.12 sur les 4 saisons.
9. Revue visuelle avant certification.

## Statut

`TRANSFORMATION_PLAN_READY_AWAITING_GO`. Rien n'est appliqué. J'attends votre
validation finale explicite pour lancer l'étape 1.
