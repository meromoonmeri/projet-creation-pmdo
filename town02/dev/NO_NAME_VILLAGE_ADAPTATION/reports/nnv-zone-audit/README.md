# AUDIT EXHAUSTIF DE NO NAME VILLAGE — zones, adaptations, provenance

**100 % READ-ONLY.** Aucun fichier modifié, généré, corrigé ou redimensionné.
Aucun commit d'artefact de map. Ce document est un constat.

---

## 1. Périmètre réel de NNV, reconstruit depuis les connexions

Je ne me suis pas fié aux noms. J'ai décodé les **695 creation codes GML** de la
source, extrait les `newroom = <id>` et reconstruit le graphe réel :
**81 rooms** avec destinations décodées, **238 arêtes**.

Point important : l'artefact suivi `connection-evidence.json` déclare
**0/319 destinations résolues** (`UNVERIFIED_BYTECODE`). Le graphe ci-dessous
provient du GML décompilé, pas de ce rapport — c'est une **divergence à signaler**
entre deux artefacts du projet.

### Distinction zone du village / carte du monde

Depuis `rmvillage`, **74 rooms** sont accessibles de proche en proche : c'est
l'overworld entier du jeu, pas le village. Deux critères objectifs séparent les
deux :

| Critère | Rooms |
|---|---|
| Reliées par **porte** (`door = true` → room 7) | `playerhouse`, `loggerhouse`, `hunterhouse`, `carpenterhouse` |
| Reliées par **transition de bord** | `rm45`, `rm54`, `rm56`, `rm65` |

Les quatre voisines sont des cartes monde 4992×4992 **sans aucune maison**
(0 `house_instance`) : ce sont les cases adjacentes de l'overworld, **pas des
sous-zones du village**.

### Structure

```
No Name Village  (5 zones logiques)
├── rmvillage            zone extérieure — 4 maisons, 6 spawns, 8 transitions
│   ├── variantes saison : spring / summer / autumn / winter
│   └── variantes living : spring / summer / autumn / winter
├── playerhouse          intérieur, 1920×1280 — porte → rmvillage (1000,3480)
├── loggerhouse          intérieur, 1920×1280 — porte → rmvillage (1152,2144)
├── hunterhouse          intérieur, 1920×1280 — porte → rmvillage (3968,2272)
└── carpenterhouse       intérieur, 1920×1280 — porte → rmvillage (2256,800)

Bordures (overworld, hors village) : rm45 O · rm54 N · rm65 N · rm56 S
```

**Total zones logiques du village : 5.** Les saisons et `living/` sont des
**variantes**, pas des zones.

---

## 2. Matrice zone par zone

| Zone NNV | ID | Équivalent projet | Terrain NNV | Sur mesure | PMU | Struct. NNV | Saisons | Living | Connexions | Statut |
|---|---:|---|---|---|---|---|---|---|---|---|
| `rmvillage` | 7 | `generated/rmvillage/` | conservé, normalisé ×0,125 | aucun | **aucun** | 4 maisons intactes | 4/4 | 4/4 | 8 sortantes, **0 cible existante** | **PRÉSENTE ET ADAPTÉE** |
| `playerhouse` | 10 | — | — | — | — | — | 0/4 | 0/4 | orpheline | **MANQUANTE** |
| `loggerhouse` | 52 | — | — | — | — | — | 0/4 | 0/4 | orpheline | **MANQUANTE** |
| `hunterhouse` | 43 | — | — | — | — | — | 0/4 | 0/4 | orpheline | **MANQUANTE** |
| `carpenterhouse` | 55 | — | — | — | — | — | 0/4 | 0/4 | orpheline | **MANQUANTE** |

Vérification : `0 fichier` et `0 dossier` contenant `playerhouse`,
`loggerhouse`, `hunterhouse` ou `carpenterhouse` dans `generated/`, et aucun
Ground correspondant dans `Data/Ground/`.

---

## 3. Ce qui a réellement été fait sur `rmvillage`

| Question | Réponse |
|---|---|
| Terrain NNV conservé ? | **oui**, intégralement |
| Terrain redimensionné ? | **oui**, ×0,125 uniforme (NEAREST) |
| Terrain modifié / recomposé ? | **non** |
| Structures originales conservées ? | **oui**, les 4 maisons sont toujours dans les layers |
| Structures NNV remplacées ? | **non** |
| Structures PMU ajoutées ? | **NON — aucune** |
| Éléments créés pour cette zone ? | **aucun** |
| Végétation / chemins conservés ? | **oui**, non modifiés |
| Éléments d'une autre map ? | **aucun** |

### Constat central

Le Ground référence **un seul tileset** : `NNV_rmvillage_Summer_Source`,
175 412 cellules. `Decorations` contient un unique groupe *Décor* **vide**
(0 anims). `MapChars` = 0, `Spawners` = 0.

**Aucune structure PMU n'est intégrée dans la map.** Les placements PMU réalisés
lors des sessions précédentes étaient des **aperçus PNG** dans
`reports/pmu-placement/`, jamais écrits dans un Ground. Les 4 maisons NNV et
leurs portes sont **toujours présentes** : la suppression validée n'a pas été
appliquée non plus.

---

## 4. Provenance des éléments

| Élément | Provenance | Natif/Adapté | Remplace | Statut |
|---|---|---|---|---|
| Terrain, chemins, végétation, relief | **NNV ORIGINAL** | adapté (échelle ×0,125) | — | en place |
| 4 maisons + portes | **NNV ORIGINAL** | natif, non modifié | — | en place |
| Tileset saisonnier ×4 | **NNV ORIGINAL** | adapté (réduction NEAREST) | — | en place |
| Markers / spawns | **NNV ORIGINAL** | positions ÷8, tailles 16×16 natives | — | en place |
| Structures PMU | — | — | — | **non intégrées** |
| Assets PMDO | — | — | — | **non intégrés** |

**Zéro asset de provenance incertaine. Zéro contamination inter-map.**

---

## 5. Intégrité avant / après normalisation

Comparaison avec `.runtime-cache/pre-normalisation-backup/` :

| Métrique | Avant | Après | Diagnostic |
|---|---:|---:|---|
| `TexSize` | 8 | 1 | **due à la normalisation** |
| Grille collision | 624 | 78 | **due à la normalisation** |
| Grille de tuiles | 78 | 78 | inchangé ✔ |
| Layers | 15 | 15 | inchangé ✔ |
| Cellules remplies | 38 918 | 38 918 | inchangé ✔ |
| Cellules animées | 11 120 | 11 120 | inchangé ✔ |
| Frames | 175 412 | 175 412 | inchangé ✔ |
| GroundObjects | 8 | 8 | inchangé ✔ |
| Markers | 10 | 10 | inchangé ✔ |

**Aucune disparition silencieuse.** Toutes les différences sont attendues.

---

## 6. ANOMALIE DÉTECTÉE — bandes de sortie non mises à l'échelle

| Entité | Avant | Après | Attendu |
|---|---|---|---|
| `Exit_North` | (0,0) **4992×8** | (0,0) **4992×8** | 624×8 |
| `Exit_West` | (0,0) **8×4992** | (0,0) **8×4992** | 8×624 |
| `Exit_South` | (0,4984) 4992×8 | (0,**623**) **4992×8** | (0,616) 624×8 |

Les positions ont bien été divisées, mais les **dimensions `Width`/`Height` des
bandes de transition ne l'ont pas été**. Cause : ma règle « les tailles
d'entités restent natives » visait les markers et Pokémon (16×16, référentiel
PMDO) ; elle s'est appliquée par erreur à ces bandes, qui sont de la
**géométrie NNV** et auraient dû suivre le facteur.

Conséquence : trois bandes de 4992 px de long débordent d'un monde de 624 px.
`Exit_South` est en outre à Y=623, soit la dernière ligne, au lieu de 616.

**Non corrigé**, conformément à la consigne : je signale au lieu d'agir.

Note : `Exit_East` **n'existe pas** dans le Ground alors que `Entry_East` existe
et que la source déclare 4 transitions de bord — écart présent **avant** la
normalisation, donc antérieur à mes travaux.

---

## 7. Connexions

| Transition | Cible | Ground PMDO | État |
|---|---|---|---|
| `Door_106508` | `playerhouse` | absent | **morte** |
| `Door_106509` | `hunterhouse` | absent | **morte** |
| `Door_106510` | `loggerhouse` | absent | **morte** |
| `Door_106511` | `carpenterhouse` | absent | **morte** |
| `North` | `rm54` / `rm65` | absent | **morte** |
| `West` | `rm45` | absent | **morte** |
| `South` | `rm56` | absent | **morte** |

**8 connexions sur 8 pointent vers des Grounds inexistants.** `rmvillage` est
aujourd'hui une **zone isolée**, sans entrée ni sortie fonctionnelle.

---

## 8. Listes

**Maps NNV présentes (village)** : `rmvillage`
**Maps NNV manquantes (village)** : `playerhouse`, `loggerhouse`, `hunterhouse`, `carpenterhouse`
**Maps du projet non identifiées NNV** : aucune sous `generated/`
**Équivalent incertain** : aucun

| Catégorie | Zones |
|---|---|
| Entièrement adaptées | — |
| Adaptées (terrain seul) | `rmvillage` |
| Adaptées sur mesure | **aucune** |
| Avec structures PMU | **aucune** |
| Partiellement adaptées | `rmvillage` (connexions mortes) |
| Non adaptées | les 4 intérieurs |
| Provenance incertaine | aucune |
| Connexions cassées | `rmvillage` (8/8) |

---

## 9. Résumé final

```
TOTAL ZONES LOGIQUES NNV (village)   : 5
TOTAL ZONES RETROUVÉES                : 1
TOTAL ZONES ADAPTÉES                  : 1   (terrain uniquement)
TOTAL ZONES ADAPTÉES SUR MESURE       : 0
TOTAL ZONES AVEC STRUCTURES PMU       : 0
TOTAL ZONES PARTIELLES                : 1
TOTAL ZONES NON ADAPTÉES              : 4
TOTAL ZONES MANQUANTES                : 4
TOTAL CONNEXIONS CASSÉES              : 8  (sur 8)
TOTAL ASSETS PROVENANCE INCERTAINE    : 0
TOTAL SAISONS MANQUANTES              : 16 (4 saisons × 4 intérieurs)
```

Périmètre élargi : sur les 98 rooms source, **85 sont jouables** (72 world,
7 interior, 6 cave) et **1 seule est convertie**.

## CONCLUSION : **NNV INCOMPLÈTE — TRAVAIL RESTANT**

Zones concernées :

1. `playerhouse`, `loggerhouse`, `hunterhouse`, `carpenterhouse` — à convertir ;
2. `rmvillage` — 8 connexions mortes, à rétablir une fois les cibles créées ;
3. `rmvillage` — bandes `Exit_*` non mises à l'échelle, à corriger ;
4. `Exit_East` absent, à investiguer (antérieur à la normalisation) ;
5. `connection-evidence.json` — 0/319 destinations résolues alors que le GML les
   fournit : artefact à régénérer ;
6. structures PMU — **aucune intégration réelle** à ce jour, malgré les aperçus ;
7. suppression validée des 4 maisons NNV + portes — **non appliquée**.

Ce qui est solide : le terrain NNV est conservé sans contamination, la
normalisation ×0,125 n'a rien détruit, et la provenance est intégralement
traçable.
