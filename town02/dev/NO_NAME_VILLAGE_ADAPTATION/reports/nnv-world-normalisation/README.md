# Normalisation de NNV vers l'échelle du monde PMDO

Audit **read-only**. Rien n'est modifié : ni `Data/`, ni `rmvillage`, ni les
saisons, ni les collisions, ni les Pokémon. Aucun placement PMU, aucun
redimensionnement appliqué. **Calcul du facteur uniquement.**

## Correction de direction

L'audit précédent prenait NNV comme référence et concluait
`PMU_NEEDS_SCALE_ADAPTATION`. **C'était la mauvaise direction.** La référence
est le monde PMDO (`metano_town`) ; NNV est la source à normaliser. Les Pokémon
gardent leur échelle PMDO et ne sont jamais redimensionnés.

## Réponses aux 8 questions

### 1. Unité monde PMDO réelle

**8 px** — la cellule de collision. Vérifié : la loi
`grille_collision == grille_tuiles × TexSize` est respectée par **423 Grounds
sur 428** (5 violations pré-existantes, hors périmètre). Un Pokémon fait
16×16 px = **2×2 unités monde**, dans toutes les maps.

### 2. Unité monde de `metano_town`

`TexSize` 1 → cellule de tuile **8 px** = 0,5 Pokémon. Monde 1512 px = 94 Pokémon.

### 3. Unité monde actuelle de NNV

`TexSize` 8 → cellule de tuile **64 px** = 4,0 Pokémon. Monde 4992 px = 312 Pokémon.

### 4. Rôle réel de `TexSize`

`cellule = TexSize × 8`. **`TexSize` ne change pas l'unité monde** : il change la
quantité de monde couverte par une cellule de tileset. À `TexSize` 8, une cellule
NNV couvre 4 Pokémon là où metano en couvre 0,5.

### 5. Conversion des textures NNV

Tuiles source GameMaker : **64 et 128 px**. Le convertisseur fait du 1:1 strict,
sans rééchantillonnage. Densité d'art mesurée : **4**. **Le ×4 est dans la source
d'origine**, il n'a pas été introduit par la conversion.

### 6. Facteur de normalisation — mesuré, pas déduit de la densité

Mesure d'objets réels contre la cible metano :

| Élément | NNV actuel | ×0,5 | **×0,25** | ×0,125 | Cible metano |
|---|---:|---:|---:|---:|---:|
| Maison | 59,2 | 29,6 | **14,8** | 7,4 | 9,4 |
| Arbre | 24,3 | 12,2 | **6,1** | 3,0 | 3,0 |
| Rocher | 12,2 | 6,1 | **3,1** | 1,5 | 1,5 |
| Plante | 10,9 | 5,5 | **2,7** | 1,4 | 1,0 |
| **Écart moyen** | 738 % | 319 % | **109 %** | **15 %** | — |

*(en Pokémon de 16 px)*

**Le meilleur ajustement numérique est ×0,125 (15 % d'écart).**
**Mais ×0,125 n'est pas réalisable sans perte.**

### Pourquoi 8 (cellules) ≠ 4 (densité) — la question centrale

Les deux nombres mesurent des choses différentes :

- **8** = rapport des cellules logiques (64 px / 8 px). Combien de monde couvre
  une cellule de tileset.
- **4** = densité de stockage de l'art (1 pixel d'art = 4×4 px réels).

Ils diffèrent d'un facteur **2** parce que les motifs NNV sont **aussi dessinés
plus grands** : une maison NNV fait ~237 pixels d'art de large, une maison
metano ~150. Soit ~1,6×.

**Sur-taille totale = densité (4) × motif (~2) ≈ 8.**

Seule la partie « densité » peut être retirée sans perte. La partie « motif »
est un choix artistique de l'auteur, inscrit dans le dessin lui-même.

### Contrainte de perte, vérifiée

| Division | Résultat | Sans perte ? |
|---|---|---|
| /2 | 474×420 | **oui** |
| /4 | 237×210 | **oui** |
| /8 | dimensions non divisibles | **non — détruit 1 pixel d'art sur 2** |

## Réponse simple

```
ÉCHELLE PMDO DE RÉFÉRENCE : unité monde 8 px, Pokémon 16 px (2×2 unités),
                            cellule de tuile 8 px (TexSize 1)
ÉCHELLE ACTUELLE NNV      : unité monde 8 px (correcte), MAIS cellule de tuile
                            64 px (TexSize 8) et art en densité 4
RATIO NNV → PMDO          : 8 en cellule logique = densité 4 × motif ~2
FACTEUR DE CONVERSION NNV : ×0,25 (recommandé, sans perte)
                            ×0,125 serait l'ajustement parfait mais détruit
                            la moitié du détail — non recommandé sans votre
                            décision explicite d'accepter cette perte
```

### Cohérence après normalisation ×0,25

```
POKÉMON APRÈS NORMALISATION : COHÉRENT (jamais redimensionné, reste 16×16)
POKÉMON ↔ ARBRE             : COHÉRENT      (6,1 vs 3,0 — même ordre)
POKÉMON ↔ MAISON            : COHÉRENT      (14,8 vs 9,4 — 1,6× plus grand)
POKÉMON ↔ ROCHER            : COHÉRENT      (3,1 vs 1,5 — même ordre)
POKÉMON ↔ TERRAIN           : COHÉRENT      (1,0 vs 0,5 Pokémon/cellule)
```

À ×0,25, NNV reste **~1,6× plus généreux** que metano — un village aux grandes
maisons, mais jouable et lisible. Aucun rapport n'est aberrant.

À ×1 (état actuel), en revanche : `NON COHÉRENT` sur les quatre rapports, avec
un écart moyen de 738 %.

## Conséquence pratique

À ×0,25, la cellule de tuile NNV passe de 64 px à **16 px**, soit `TexSize 2`.
La map passerait de 4992 px à **1248 px**, contre 1512 px pour metano : deux
villages de taille comparable. C'est cohérent.

## Recommandation

**×0,25**, seul facteur à la fois réellement normalisant et strictement sans
perte : il retire exactement l'agrandissement ×4 que la source GameMaker avait
figé. Le ×1,6 résiduel est un parti pris artistique, pas un défaut technique.

Si vous préférez la correspondance exacte avec metano, ×0,125 est possible mais
**détruit définitivement la moitié du détail** — cela doit être une décision
explicite de votre part, pas une conséquence silencieuse.

## Reproduire

```bash
cd NO_NAME_VILLAGE_ADAPTATION/tools
python3 audit_nnv_world_normalisation.py
```

Rapport machine : `nnv-world-normalisation.json`.
Simulation visuelle : `NORMALISATION_x1_x05_x025_x0125.png`.

## Statut

`AUDIT_COMPLETE_AWAITING_VALIDATION`. Aucune modification, `rmvillage`
byte-identique. J'attends votre validation du facteur avant toute suite.
