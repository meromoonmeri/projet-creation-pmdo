# Analyse préparatoire — 5 zones NNV, anomalie Exit_*, divergence connection-evidence

**READ-ONLY.** Aucun fichier modifié, aucune conversion, aucune intégration PMU,
aucun commit. Rapport d'aide à la décision.

---

# A. Les 4 intérieurs manquants

Les quatre partagent une structure remarquablement homogène.

## Profil commun

| Propriété | Valeur |
|---|---|
| Dimensions | **1920×1280 px** (identiques pour les 4) |
| Grille de tuiles | **30×20 cellules de 64 px** |
| Tilesets | `tlcavewl` (index 15) + `tlspring` (index 29), **64×64 px** |
| Tile layers | 2 par zone (`Black`/`black` + `grass1`/`Tiles_1`) |
| Transitions | **1 sortie** chacune (`objtransit`) → `rmvillage` |
| Saisonnalité | **AUCUNE** — absents du système saisonnier |
| Variantes `living/` | **AUCUNE** |
| Statut extraction | `EXTRACTED` |
| Statut conversion | `UNIMPLEMENTED` |

## Détail par zone

| Zone | ID | Layers | Instances | Solides | Spawns | Sprites | Sortie → rmvillage |
|---|---:|---:|---:|---:|---:|---:|---|
| `playerhouse` | 10 | 11 | 32 | 10 | **2** | 11 | (992,704) → (1000,3480) |
| `loggerhouse` | 52 | 11 | 25 | 11 | 1 | 7 | (704,1024) → (1152,2144) |
| `hunterhouse` | 43 | 10 | 32 | 9 | 1 | 4 | (576,832) → (3968,2272) |
| `carpenterhouse` | 55 | 9 | 29 | 11 | 1 | 3 | (1056,1024) → (2256,800) |

### Statuts d'instances (gate fail-closed déjà en place)

| Zone | `EXTRACTED` | `REVIEW_REQUIRED` | `ADAPTATION_REQUIRED` |
|---|---:|---:|---:|
| `playerhouse` | 9 | **20** | 3 |
| `loggerhouse` | 10 | **13** | 2 |
| `hunterhouse` | 8 | **22** | 2 |
| `carpenterhouse` | 10 | **17** | 2 |

**72 instances sur 118 sont `REVIEW_REQUIRED`.** C'est le principal obstacle :
mobilier et objets d'intérieur dont l'adaptation n'est pas prouvée. Une
conversion aujourd'hui produirait des intérieurs partiellement vides.

### Particularités

- `playerhouse` possède **2 spawn points** (les autres 1) et le seul layer
  `stuff` — c'est la maison du joueur, avec dialogues (`text[]` dans son
  creation code : *« I don't think I'm ready to leave yet »*).
- `hunterhouse` a un layer `puddle` (flaque) unique.
- `loggerhouse` a 3 layers `Assets_*` masqués (variantes non affichées).
- Les layers `Assets_1/2/3` sont `visible=False` dans les quatre : contenu
  alternatif présent mais inactif — à **ne pas** importer sans preuve.

## Échelle — point vérifié

Une erreur d'interprétation évitée : le champ `grid_px = 16` de l'inventaire est
la **grille d'édition GameMaker** (snap), pas la taille de tuile. Les tuiles
réelles sont **64×64 px**, confirmé via `Backgrounds.json.gz`
(`tlcavewl`, `tlspring`) et par le calcul 30×20 × 64 = 1920×1280.

**Conséquence : les intérieurs prennent le même facteur ×0,125 que `rmvillage`.**

| | Source | Après ×0,125 | `TexSize` |
|---|---:|---:|---:|
| Monde | 1920×1280 | **240×160 px** | — |
| Cellule | 64 px | **8 px** | **1** |
| Grille | 30×20 | 30×20 (inchangée) | — |

240×160 px est une taille d'intérieur PMDO plausible
(cf. `guild_bedroom_hallway` 480 px, `post_office` 384×312).

## Équivalent PMDO envisagé

Grounds `TexSize 1`, un par intérieur, sans variante saisonnière ni `living/` —
soit **4 Grounds**, contre 8 artefacts pour `rmvillage`.

---

# B. Anomalie `Exit_*` — analyse et correction proposée

## Mesures

| Bande | Avant normalisation | Après | Attendu |
|---|---|---|---|
| `Exit_North` | (0,0) 4992×8 | (0,0) **4992×8** | non mis à l'échelle |
| `Exit_West` | (0,0) 8×4992 | (0,0) **8×4992** | non mis à l'échelle |
| `Exit_South` | (0,4984) 4992×8 | (0,**623**) **4992×8** | position OK, taille non |

Les positions ont suivi le facteur, **les dimensions non**. Cause identifiée :
ma règle « tailles d'entités natives » visait les markers et Pokémon (16×16,
référentiel PMDO) ; elle s'est appliquée à tort à ces bandes, qui sont de la
**géométrie NNV**.

## Représentation source

Les `objtransit` de `rmvillage` sont des sprites 64×64 mis à l'échelle :

| Instance | Position | Scale | Emprise |
|---|---|---|---:|
| 106153 | (-64,-128) | 40,0 × 1,0 | 2560×64 |
| 106154 | (5056,-128) | 1,0 × 41,5 | 64×2656 |
| 106155 | (-192,-128) | 1,0 × 41,5 | 64×2656 |
| 106156 | (-64,5056) | 40,0 × 1,0 | 2560×64 |

Le convertisseur ne les a pas repris tels quels : il a créé des bandes de bord
pleine largeur (4992×8), ce qui est déjà une simplification.

## Convention PMDO mesurée

Sur **80 entités de bord** relevées dans les Grounds validés, **71 sont des
bandes courtes et localisées** (`North_Exit` 72×8, `East_Exit` 16×96,
`Top_Left_Exit` 48×8…). Seules 9 couvrent tout un bord.

## Deux options

| Option | Résultat | Conformité PMDO |
|---|---|---|
| **A — division mécanique /8** | `Exit_North` 624×8, `Exit_West` 8×624, `Exit_South` 624×8 | cohérent, mais bande pleine (minoritaire) |
| **B — convention PMDO** | 64×8 alignée sur l'`Entry` correspondant : North (288,0), West (0,288), South (288,616) | conforme à 71/80 cas |

**Recommandation : option A.** Elle corrige strictement le défaut d'échelle sans
changer le design des transitions. L'option B est un choix de game design (forcer
le joueur vers un point de passage précis) qui vous revient.

**Impact connexions** : aucune destination ne change ; seule l'emprise du
déclencheur bouge. À revalider en runtime.

## Anomalie connexe — `Exit_East` absent

`Entry_East` existe (616,312) mais **`Exit_East` n'existe pas**, alors que la
source déclare 4 transitions de bord. Vérifié dans la sauvegarde
pré-normalisation : **déjà absent**. Anomalie du convertisseur, **antérieure**
à mes travaux. Le bord Est est donc une entrée sans sortie.

---

# C. Divergence `connection-evidence.json` — cause identifiée

Ligne 56 de `tools/build_source_reports.py` :

```python
for transition in row["transitions"]:
    transition_rows.append({..., "destination": "UNVERIFIED_BYTECODE"})
```

La valeur est **écrite en dur**. Le script n'a jamais tenté de résoudre les
destinations : il collecte les `objtransit` et leur assigne systématiquement
`UNVERIFIED_BYTECODE`. Ce n'est pas un échec de décodage, c'est une **absence
d'implémentation**, assumée à l'époque (`status: PARTIAL`, et le rapport dit
lui-même que « le prochain gate doit résoudre les destinations de chaque
RoomCC »).

Les destinations **sont** pourtant disponibles : les 695 creation codes
décompilés contiennent `newroom = <id>`, dont **252 avec une destination**.
J'ai reconstruit 238 arêtes sur 81 rooms par cette voie.

`convert_environment_room.py` les résout d'ailleurs déjà, d'où les 8
`mapped_transitions` corrects du manifest de `rmvillage`.

**Conclusion** : artefact obsolète, non erroné. Sa régénération est possible et
sûre — mais je ne l'ai pas faite, comme demandé.

---

# D. Intégrité de `rmvillage` — vérifiée

| Contrôle | Résultat |
|---|---|
| Fichiers suivis modifiés pendant cet audit | **0** |
| Tilesets référencés | **1 seul**, `NNV_rmvillage_Summer_Source` |
| Assets PMU dans la map | **0** |
| Assets PMDO dans la map | **0** |
| Morceaux d'autres maps | **0** |
| `Decorations` | 1 groupe *Décor*, **vide** |
| Terrain NNV | **conservé intégralement** |

La règle est tenue : terrain NNV original + adaptation contrôlée, aucune
recomposition arbitraire.

---

# Décision — comment adapter les 5 zones

| Zone | Facteur | Saisons | `living/` | Grounds | Blocage principal |
|---|---:|---:|---:|---:|---|
| `rmvillage` | ×0,125 ✔ fait | 4 | 4 | 8 | bandes `Exit_*`, `Exit_East`, connexions mortes |
| `playerhouse` | ×0,125 | 1 | 0 | 1 | 20 instances `REVIEW_REQUIRED` |
| `loggerhouse` | ×0,125 | 1 | 0 | 1 | 13 `REVIEW_REQUIRED` |
| `hunterhouse` | ×0,125 | 1 | 0 | 1 | 22 `REVIEW_REQUIRED` |
| `carpenterhouse` | ×0,125 | 1 | 0 | 1 | 17 `REVIEW_REQUIRED` |

**Objectif 5/5** : 4 Grounds à produire. Facteur unique ×0,125 pour tout NNV.

## Ordre logique proposé

1. Corriger les bandes `Exit_*` (option A) et statuer sur `Exit_East`.
2. Trancher les 72 instances `REVIEW_REQUIRED` des intérieurs — c'est le vrai
   travail, il demande vos arbitrages sur le mobilier.
3. Convertir les 4 intérieurs en ×0,125.
4. Rétablir les 8 connexions.
5. Régénérer `connection-evidence.json`.
6. Runtime PMDO 0.8.12 sur l'ensemble.
7. **Seulement ensuite** : intégration PMU zone par zone.

## Statut

`ANALYSE_COMPLETE_AWAITING_DECISION`. Rien n'est appliqué.
