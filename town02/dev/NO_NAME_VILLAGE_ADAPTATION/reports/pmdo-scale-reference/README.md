# Référentiel d'échelle PMDO — audit définitif

Audit **read-only**. Aucune modification : ni `Data/`, ni map, ni sprite, ni
asset PMU, ni collision, ni saison. Les rendus sont des artefacts de rapport.

**Règle fixée pour toute l'intégration future :**

```
PMDO = étalon d'échelle
NNV  = monde à normaliser
PMU  = assets à intégrer ensuite, à l'échelle établie ici
```

Les Pokémon ne sont jamais redimensionnés. NNV conserve son identité
artistique ; seule sa représentation dans le référentiel PMDO change.

---

## Réponse sans ambiguïté

```
ÉCHELLE DE RÉFÉRENCE PMDO :
    unité monde       = 8 px (cellule de collision)
    Pokémon           = 16 px = 2×2 unités monde
    cellule de terrain= 8 px (TexSize 1)
    maison type       = 114 px médian = 7,1 Pokémon
    arbre type        = ~48 px = 3,0 Pokémon
    rocher type       = ~24 px = 1,5 Pokémon

ÉCHELLE ACTUELLE NNV :
    unité monde       = 8 px (correcte)
    cellule de terrain= 64 px (TexSize 8)  ← l'anomalie
    Pokémon           = 0,25 cellule (au lieu de 2)
    maison            = 948 px = 59,2 Pokémon

RAPPORT NNV → PMDO :
    8   (64 px / 8 px)
    décomposé en : densité d'art (×4) × motif artistique (×2)

FACTEUR DE NORMALISATION NNV :
    ×0,125   (dérivé de la loi PMDO, confirmé par la mesure)

ÉCHELLE FUTURE DES BUILDINGS PMU :
    ×1 — les assets PMU sont DÉJÀ à l'échelle PMDO native
```

### Cohérence après normalisation ×0,125

```
POKÉMON ↔ ARBRE   : COHÉRENT   (3,04 vs 3,00 — écart 1,3 %)
POKÉMON ↔ MAISON  : COHÉRENT   (7,41 vs 7,10 — écart 4,3 %)
POKÉMON ↔ ROCHER  : COHÉRENT   (1,53 vs 1,50 — écart 2,1 %)
POKÉMON ↔ TERRAIN : COHÉRENT   (0,50 vs 0,50 — exact)
```

### Question finale

> **« Après normalisation, un Pokémon standard PMDO placé dans NNV a-t-il la
> même présence visuelle relative que dans les Grounds PMDO validés ? »**

| Facteur | Réponse |
|---|---|
| ×1 (actuel) | **NON** — le décor est ~8× trop grand |
| ×0,25 | **NON** — le décor reste ~2× trop grand |
| **×0,125** | **OUI** |

---

## Méthode : la loi, pas la moyenne d'erreurs

Le facteur n'est **pas** choisi pour minimiser une erreur. Il découle de la loi
d'échelle PMDO, vérifiée sur **423 Grounds sur 428** :

```
grille_collision = grille_tuiles × TexSize
cellule_px       = TexSize × 8
```

La cellule PMDO doit valoir 8 px. NNV vaut 64 px. → **8/64 = 0,125.**

**Confirmation indépendante** par mesure d'objets réels :

| Élément | NNV ×0,125 | Cible PMDO | Écart |
|---|---:|---:|---:|
| Maison | 7,41 Pokémon | 7,10 | 1,3 % |
| Arbre | 3,04 | 3,00 | 1,3 % |
| Rocher | 1,53 | 1,50 | 2,1 % |

Les deux méthodes convergent — ce n'est pas un ajustement de courbe.

## Corpus de référence élargi

`metano_town` n'est pas la seule vérité. Corpus analysé :

- **423 Grounds** conformes à la loi ; **409 en TexSize 1** (cellule 8 px).
  NNV en TexSize 8 est le **seul cas** de ce type.
- **Pokémon 16×16 px** dans 100 % des Grounds peuplés (`bourg_comptoir`,
  `testmap`, `sky_wigglytuff_guild_main`, `metano_town`, `ledian_dojo`…).
- **336 colliders de décor** sur 49 Grounds : multiples de 8 px, 1–3 Pokémon.
- **1078 composantes autonomes** extraites de l'atlas metano : bâtiments de
  88–304 px, médiane **114 px = 7,1 Pokémon**.

## Tableau complet des facteurs

| Facteur | Cellule | TexSize | Maison | Arbre | Rocher | Terrain | Écart moyen | Sans perte | Runtime |
|---|---:|---:|---:|---:|---:|---:|---:|---|---|
| ×1 | 64 px | 8 | 59,2 | 24,3 | 12,2 | 4,00 | 714,8 % | oui | ok |
| ×0,5 | 32 px | 4 | 29,6 | 12,2 | 6,1 | 2,00 | 307,4 % | oui | ok |
| ×0,25 | 16 px | 2 | 14,8 | 6,1 | 3,1 | 1,00 | 103,7 % | oui | ok |
| **×0,125** | **8 px** | **1** | **7,4** | **3,0** | **1,5** | **0,50** | **13,0 %** | **non** | ok |
| *cible* | *8 px* | *1* | *7,1* | *3,0* | *1,5* | *0,50* | — | — | — |

## Un fait important : NNV est déjà cohérent en interne

Les proportions internes de NNV correspondent **déjà** à PMDO :

| Rapport | NNV | PMDO |
|---|---:|---:|
| arbre / maison | 0,410 | 0,423 |
| rocher / arbre | 0,504 | 0,500 |
| maison / cellule | 14,8 | 14,2 |

**Conséquence (question 9) : le facteur est UNIFORME.** Un facteur par
catégorie casserait les proportions propres de NNV. Le monde NNV est bien
construit ; seule son unité de mesure diffère.

## Le coût honnête de ×0,125

La densité d'art NNV est **4**. Diviser par 4 est sans perte ; le second
halving ne l'est pas.

- `/4` → 237×210 px, **réversible à 100 %**
- `/8` → 118×105 px, **non réversible**, ~17 % des octets diffèrent du motif /4

Mais c'est précisément l'objectif : le motif NNV est ~2× plus grand que le
motif PMDO. Le ramener à 118 px l'aligne sur les **114 px médians** de metano.

**Alternative sans perte : ×0,25** — mais NNV reste ~2× hors du référentiel
PMDO, et la réponse à la question finale devient **NON**.

C'est un arbitrage qui vous revient : fidélité pixel intégrale, ou intégration
réelle dans le référentiel PMDO.

## Échelle des buildings PMU : ×1

Découverte décisive : **`tiles0_0367` mesure 145×170 px, exactement les
dimensions d'un composant maison de `metano_town`.**

| Source | Largeur bâtiments | Médiane |
|---|---|---:|
| metano_town | 88–304 px | 114 px = 7,1 Pokémon |
| PMU (48 confirmés) | 40–212 px | 98 px = 6,1 Pokémon |

Les assets PMU sont **déjà à l'échelle PMDO native**. Ils doivent être placés
**×1, pixel-faithful**, sans agrandissement, réduction, recoloration ni
interpolation. Mon estimation antérieure d'un ×4 était fausse : elle prenait
NNV comme étalon au lieu de PMDO.

## Provenance (inchangée)

`PMU.zip` reste la **source canonique** (Git LFS activé). `Tiles0` et `Tiles9`
sont byte-identiques aux hashes déclarés ; `Tiles8` reste `REVIEW_REQUIRED`
tant que la version canonique n'a pas été lue. Aucune substitution par une
source publique.

## Reproduire

```bash
cd NO_NAME_VILLAGE_ADAPTATION/tools
python3 audit_pmdo_scale_reference.py
```

Rapport machine : `pmdo-scale-reference.json`.
Preuve visuelle : `SCALE_PROOF_nnv_vs_metano.png`.

## Statut

`AUDIT_COMPLETE_AWAITING_VALIDATION`. Aucune transformation, aucune décision
d'intégration. `rmvillage` byte-identique. J'attends votre approbation.
