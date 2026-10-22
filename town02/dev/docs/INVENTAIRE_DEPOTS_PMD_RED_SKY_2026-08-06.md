# INVENTAIRE DES DÉPÔTS PMD-RED-PMDO-PORT / PMD-SKY-PMDO-PORT — Structure vérifiée & inventaire des donjons

**Date** : 2026-08-06 — **Objet** : exploration réelle et inventaire exhaustif des sources obligatoires avant tout import canonique.
**Méthode** : chaque affirmation ci-dessous a été **vérifiée directement dans les dépôts** (clone des branches, lecture des fichiers, comptage). Rien n'est supposé par analogie.

---

## 1. STRUCTURE RÉELLE DES TROIS DÉPÔTS (vérifiée)

### 1.1 `meromoonmeri/PMD-RED-PMDO-PORT` — 2 branches, contenus différents

> ⚠️ **Constat important** : la branche par défaut (HEAD) est **`master`**, mais les frameworks demandés vivent sur **`main`**. Les deux branches contiennent des choses différentes.

**Branche `master`** (25 Mo) — l'export pixel-perfect des Grounds :
- `output/Grounds/` : **245 `.rsground`** (A/B/D/H/S/T/W), dont 33 nommés en français (`foret_tendre_oree`, `bois_sombres_oree`, `parvis_celeste`, `tour_ciel_sommet`, `place_pokemon`…)
- `output/Tiles/` : **245 `.tile`** associés (`A01p01_Base.tile`, `D06p02_Base.tile`…)
- `tools/` : `pmdred_lib.py`, `recover_33_maps.py`, `recover_all_maps.py`
- `map_dependencies.json` (245 entrées bpl/bpc/bma), `GROUND_AUDIT.md` (audit pixel-perfect 100 %), `COVERAGE_245_MAPS_REPORT.md`, `RECOVERY_33_MAPS_REPORT.md`, `mass_pixel_perfect_audit.py`
- Pas de framework ni de données de donjon sur cette branche.

**Branche `main`** — les deux frameworks + intégration :
- `PMDRed_PMDO_Framework/` — framework GBA (Red/Blue Rescue Team)
- `PMDSky_PMDO_Framework/` — framework NDS (Explorers of Sky)
- `NewEra_Integration/` : `map_sky_red_to_new_era.py` (stratégie de mapping New Era, script de démonstration)
- `pmd_red_extraction/` : `pmd_red_index.json` (245 cartes), `PMD_RED_EXTRACTION_REPORT.md`
- `uploads/` : documents de travail (plans ch8/ch12, prompts)
- `GROUND_AUDIT.md` (même audit que master)

### 1.2 `PMDRed_PMDO_Framework` (branche main) — structure vérifiée

| Dossier | Contenu vérifié | Format |
|---|---|---|
| `output/Dungeons/` | **98 fichiers XML** « FloorPlan » (1 par donjon/zone : `tiny_woods.xml`, `mt_thunder.xml`, `fiery_field.xml`, `wish_cave.xml`, `bug_maze.xml`…) | XML RogueElements : `<Name>`, `<Spawns><MobSpawn Species Rate>` — **aucune géométrie**, pas de `<Floors>` |
| `intermediate/dungeons/dungeons.json` | **98 donjons** GBA indexés (`DUNGEON_TINY_WOODS`…) avec `id` (0-97) + `spawns` | JSON |
| `Data/Cinematics/` | **136 `.cif.json`** (scènes `a01p01`…`d13p03`, `t01p01`) | JSON séquence (Audio/Camera/Animation/Dialog/Effect) |
| `Data/Script/scene/` | Scripts Lua de scènes (`a01p01.lua`, `d13p03.lua`…) | Lua |
| `docs/` | `MAP_DATABASE.md` (245 cartes), `CINEMATICS_DATABASE.md` (mécanismes GBA), `ENGINE_ANALYSIS.md`, `GAMEPLAY_SYSTEMS.md`, `ROGUE_ESSENCE_COMPLIANCE.md`, `AUDIT_GROUNDS_10_MAPS.md` | Markdown |
| `converters/` | `dungeons/dungeon_generator.py`, `grounds/bpa_anim_extractor.py`, `grounds/visual_extractor.py` | Python |
| `analyzers/dungeon_analyzer.py` | Parseur C/ASM → dungeons.json | Python |
| `PMDRed_PMDO_Converter/` | Version industrialisée (extractor, converters, validator, `compatibility_database/`, `output/cinematics_cif/`, `output/PMDO_Project/Scripts/`) | Python + JSON |
| `compatibility/engine_rules.json` | Règles moteur | JSON |

**Constat critique sur les spawns Red** : le code de `analyzers/dungeon_analyzer.py` **simule** l'extraction — ligne commentée : `# Simulated extraction for demonstration` — et attribue à **chaque donjon** la même liste `["zubat", "geodude", "machop"]`. Les 98 XML `output/Dungeons/*.xml` portent donc tous les mêmes 3 spawns factices (rate 10). **Le bestiaire réel GBA n'est PAS extrait dans ce framework** : seule l'identité des donjons (44 noms + id) est réelle.

### 1.3 `PMDSky_PMDO_Framework` (branche main) — structure vérifiée

| Dossier | Contenu vérifié | Format |
|---|---|---|
| `database/grounds.json` | **323 grounds NDS indexés** (id `dXXpYYa`, name, type, source `.sir0`, script_folder, connections) | JSON |
| `database/dungeon_connections.json` | **1 seule entrée complète** : Temporal Tower (entrance `d05p11a`, floors 13, midpoint `d05p31a`, boss `PrimalDialga`, arena `d05p41a`, exit `t01p01a`) | JSON |
| `database/transitions.json` | 4 warps ville (t01p01a↔t01p02a↔t01p03a↔t01p04a, vers d01p11a) | JSON |
| `database/world_graph.json` | **193 nœuds** (7 town, 20 event, 59 boss_arena, 22 dungeon_midpoint, 46 dungeon_entrance, 39 cinematic_zone) + 4 edges | JSON |
| `database/ground_cutscene_links.json` | liens ground→cinématiques (b01p01, t01p01a, d13p03) | JSON |
| `database/entity_replacement.json` | remplacements d'acteurs New Era (NPC_PARTNER→new_era_partner…) | JSON |
| `database/vfx_assets.json`, `cinematic_vfx.json` | VFX et effets de cinématiques | JSON |
| `output/Dungeons/` | **6 XML FloorPlan AVEC `<Floors>` et espèces réelles** : `temporal_tower.xml` (13F, porygon/bronzor/lunatone), `temporal_spire.xml` (10F), `spacial_rift.xml` (15F), `deep_spacial_rift.xml` (9F), `sky_peak.xml` (10F), `destiny_tower.xml` (99F, starters) | XML |
| `output/Grounds/` | **1 seul `.rsground` converti** : `b01p01_beach.rsground` (proto) | RogueEssence |
| `output/Tiles/` | **106 `.tile`** (tilesets extraits : `d01p41a_tileset.tile`, `d03p41a_tileset.tile`, `d10p21a_tileset.tile`…) + `b01p01_beach_tileset.png` | RogueEssence |
| `output/Scripts/scene/` | `dimensional_scream_01.lua`, `m01a0103.lua` | Lua |
| `intermediate/` | analyses : `b01p01_ground_analysis.json` (80×60, 2 layers, collision, entités, events), `b01p01_tileset_analysis.json`, `sir0_unpacked/`, `cinematics_ssb/` | JSON |
| `docs/` | `GROUND_FORMAT_ANALYSIS.md` (Sir0/rlcn/rlts/rlsn → PMDO), `SSB_FORMAT_ANALYSIS.md`, `TILESET_FORMAT_ANALYSIS.md`, `WAN_EXTRACTION_GUIDELINE.md`, `ENGINE_ANALYSIS_NDS.md` | Markdown |
| `extractors/`, `converters/`, `profiles/`, `validator/`, `tools/world/` | pipeline NDS→PMDO | Python |

**Constat** : le framework Sky est au stade **prototype** — la classification du monde (193 nœuds, 77 prefixes de donjons d00-d90) et 6 donjons avec étages+espèces réelles existent, mais **1 seul ground est converti en `.rsground`** (b01p01_beach). Le pipeline de conversion NDS (Sir0 → JSON → rsground) est documenté dans `GROUND_FORMAT_ANALYSIS.md`.

### 1.4 Repo séparé `meromoonmeri/PMD-SKY-PMDO-PORT` (127 Mo, MAJ 2026-08-06)

> Le prompt cite `PMDSky_PMDO_Framework` comme sous-dossier du dépôt racine ; il existe **aussi** en dépôt autonome. Non cloné en entier (127 Mo) — structure à confirmer si l'import Sky est retenu ; le sous-dossier `main/PMDSky_PMDO_Framework` du dépôt racine contient déjà l'essentiel de la donnée.

---

## 2. INVENTAIRE EXHAUSTIF DES DONJONS

### 2.1 Donjons PMD Red (framework GBA) — 98 identités vérifiées

Source : `intermediate/dungeons/dungeons.json` (98 clés `DUNGEON_*`, ids 0-97) + `output/Dungeons/*.xml` (98 fichiers) + `pmd_red_index.json` + `MAP_DATABASE.md`.

Légende : **E** = Ground d'entrée (ENTRY), **M** = midpoint/relais (MID), **F** = ground de fin/arène (END), **–** = absent dans la source. Étages : **non fournis** par le framework (pas de `<Floors>`). Bestiaire : **placeholders** (non extrait). Boss : documenté dans MAP_DATABASE/CINEMATICS_DATABASE.

| Donjon (source GBA) | Map ID | E | M | F | Boss/légendaire (doc) | Notes vérifiées |
|---|---|---|---|---|---|---|
| Tiny Woods | D01P01/02 | ✅ | – | ✅ | – | 1er donjon, 4-5F (non fourni) |
| Thunderwave Cave | D02P01/02 | ✅ | – | ✅ | – | |
| Mt. Steel | D03P01/02 | ✅ | – | ✅ | – | |
| Sinister Woods | D04P01/02 | ✅ | – | ✅ | – | |
| Silent Chasm | D05P01/02 | ✅ | – | ✅ | – | |
| Mt. Thunder | D06P01/02/03 | ✅ | ✅ | ✅ | Zapdos (fin) | 3 grounds |
| Great Canyon | D07P01 | ✅ | – | – | – | pas de ground de fin |
| Hill of the Ancients | D07P02 | – | – | ✅ | Xatu (scène) | cinématique |
| Lapis Cave | D08P01/02 | ✅ | – | ✅ | – | |
| Mt. Blaze | D09P01/02/03 | ✅ | ✅ | ✅ | Moltres (fin) | 3 grounds |
| Frosty Forest | D10P01/02/03 | ✅ | ✅ | ✅ | Articuno (fin) | 3 grounds |
| Mt. Freeze | D11P01/02/03 | ✅ | ✅ | ✅ | Ninetales (fin) | 3 grounds |
| Magma Cavern | D12P01/02/04 | ✅ | ✅ | ✅ | Groudon (D12P04) | pas de D12P03 |
| Sky Tower | D13P01/02/03 | ✅ | ✅ | ✅ | Rayquaza (D13P03) | 3 grounds |
| Stormy Sea | D14P01 | – | – | ✅ | Kyogre | arène seule |
| Silver Trench | D15P01 | – | – | ✅ | Lugia | arène seule |
| Fiery Field | D16P01 | – | – | ✅ | Moltres (post-game) | arène seule |
| Lightning Field | D17P01 | – | – | ✅ | Raikou | arène seule |
| Northwind Field | D18P01 | – | – | ✅ | Articuno | arène seule |
| Mt. Faraway | D19P01 | – | – | ✅ | Ho-Oh | arène seule |
| Western Cave | D20P01 | – | – | ✅ | Mewtwo | arène seule |
| Northern Range | D21P01 | – | – | ✅ | Latios/Latias | arène seule |
| Pitfall Valley | D22P01 | – | – | ✅ | – | ground seul |
| Wish Cave | D23P01 | – | – | ✅ | Jirachi (étage 20) | ground de fin |
| Murky Cave | D24P01/02 | – | – | ✅ | – | 2 grounds (fond/autel) |
| Howling Forest | D25P01 | – | – | ✅ | Suicune | arène seule |

**Donjons « labyrinthes » (mazes) et post-game** — fichiers XML vérifiés (bestiaire placeholder, pas d'entrance/fin en grounds) :
`normal_maze`, `fire_maze`, `water_maze`, `grass_maze`, `electric_maze`, `bug_maze`, `rock_maze`, `ground_maze`, `flying_maze`, `fighting_maze`, `ghost_maze`, `steel_maze`, `dragon_maze`, `poison_maze`, `ice_maze`, `psychic_maze`, `dark_maze`, `buried_relic`, `desert_region`, `southern_cavern`, `wyvern_hill`, `uproar_forest`, `oddity_cave`, `remains_island`, `marvelous_sea`, `fantasy_strait`, `grand_sea`, `far_off_sea`, `howling_forest_2`, `solar_cave`, `joyous_tower`, `purity_forest`, `waterfall_pond`, `meteor_cave`, `silver_trench`, `northwind_field`, `lightning_field`, `mt_faraway`, `unown_relic`, `rock_path`, `snow_path`, `boss_3/4/9`, `autopilot`, `agb_slot`, `rescue_team_base(_2)`, `rescue_team_maze`, `team_constrictor/hydro/rumblerock/shifty`, `unknown_world`, `d50/d51/d54/d61`, `pokemon_square(_2)`, `join_location_*`, `out_on_rescue`.

### 2.2 Donjons PMD Sky (framework NDS) — 77 prefixes vérifiés

Source : `database/grounds.json` (323 grounds typés) + `world_graph.json` (193 nœuds) + `output/Dungeons/*.xml` (6 avec étages+espèces réelles) + `dungeon_connections.json`.

**Classification vérifiée par prefixe `dXX`** (extrait complet des 77 prefixes avec décompte des grounds) :

| Prefixe | Entrée | Midpoint | Arène boss | Cinématique | Étages (XML si fourni) | Espèces (XML si fourni) |
|---|---|---|---|---|---|---|
| d00 | 1 | – | – | 1 | – | – |
| d01 | 3 | – | – | – | – | – |
| d02 | 1 | – | 1 | – | – | – |
| d03 | 1 | – | 1 | – | – | – |
| d04 | 1 | – | 1 | 1 | – | – |
| d05 | 1 | – | 1 | – | 13 (Temporal Tower) | porygon/bronzor/lunatone |
| d06-d09 | 1 chacun | – | – | – | – | – |
| d10 | – | 1 | 1 | – | 10 (sky_peak) | staravia/gligar/jumpluff |
| d11 | 1 | – | – | – | – | – |
| d12 | – | 1 | 1 | – | – | – |
| d13 | 1 | – | – | – | – | – |
| d14 | 1 | – | – | 1 | – | – |
| d15 | – | 1 | 1 | – | – | – |
| d16 | 1 | – | 1 | – | – | – |
| d17 | 1 | – | 1 | 4 | – | – |
| d18-d20 | 1 chacun | – | – | – | – | – |
| d21 | – | 2 | – | – | – | – |
| d22-d25 | 1 chacun | – | – | – | – | – |
| d26 | – | 1 | 1 | 1 | – | – |
| d27 | 1 | – | – | – | – | – |
| d28 | – | 1 | 1 | 4 | – | – |
| d29 | 1 | – | – | – | – | – |
| d30 | – | 1 | 1 | 3 | – | – |
| d31 | 1 | – | 2 | – | – | – |
| d32 | 1 | – | 1 | 6 | – | – |
| d34-d37 | 1/0 | – | 1 | – | – | – |
| d38 | 1 | – | – | 1 | – | – |
| d39 | – | 1 | 1 | 1 | – | – |
| d40-d41 | 1/0 | – | 1 | – | – | – |
| d42 | – | 1 | 2 | 1 | – | – |
| d43-d45 | – | 1 | 1 | 1 | – | – |
| d46 | 1 | 1 | 1 | – | – | – |
| d47-d48 | 1 | 1/0 | – | – | – | – |
| d50-d57 | 1 | 1 | 1 | 1-3 | spacial_rift 15F, deep_spacial_rift 9F, temporal_spire 10F | drowzee/xatu/gallade ; kadabra/claydol/mismagius ; porygon2/bronzong/solrock |
| d63-d71 | – | – | 1 | – | – | – |
| d73 | 1 | 1 | 2 | 8 | – | – |
| d79 | 1 | 1 | 1 | – | – | – |
| d80-d90 | – | – | 1 | – | – | – |

**Destiny Tower** (`destiny_tower.xml`) : 99 étages, espèces starters (bulbasaur/charmander/squirtle/chikorita) — pas d'entrance/arène dans la classification.

**Récapitulatif Sky** : 77 donjons identifiés ; parmi eux, ceux avec entrance ground : **46** ; avec midpoint : **22** ; avec arène de boss : **59** ; avec zone cinématique : **39**. 1 seul donjon a une entrée complète vérifiée dans `dungeon_connections.json` (Temporal Tower). **Aucun ground de donjon n'est encore converti en `.rsground`** (seul `b01p01_beach.rsground` existe, hors donjon).

### 2.3 Villes / hubs / scènes (hors donjons)

**Red** : `T00P01` (Base Équipe), `T01P01` (Place Pokémon), `T01P02A/B` (Étang Barbicha), `T01P03/04` (Poste), `T01P05/06` (Dojo), 97 Team Bases (`TEAM_BASE_*`), 3 Personality Test (`A01P01-03`), 16 cartes Arc (`A02-A05`), 6 scènes S, 58 Friend Areas (H01-H29).
**Sky** : 7 town (`t00p01`-`t01p04a`), 20 event (`s00-s99`), 39 cinematic_zone, 130 unknown.

---

## 3. RÉPONSES AUX QUESTIONS D'AUTO-VALIDATION

1. **Structure réelle vérifiée avant hypothèse ?** ✅ Oui — clone des 2 branches du dépôt racine + lecture directe des dossiers et fichiers ; constat clé : les frameworks sont sur `main`, pas sur `master`.
2. **Inventaire couvre-t-il tous les donjons ?** ✅ Red : 98 identités (dont 26 cartographiés E/M/F dans le détail + mazes/post-game listés) ; Sky : 77 prefixes avec classification complète. Les colonnes entrance/fin sont **vérifiées dans les données** (map_id ENTRY/MID/END pour Red ; type dungeon_entrance/midpoint/boss_arena pour Sky), pas devinées.
3. **Un donjon sans entrance a-t-il reçu une entrance ?** — Non : aucun donjon n'a été importé ni modifié à ce stade (ce document est un inventaire). La règle « pas d'entrance inventée » s'appliquera à l'import.
4. **Ground modifié/remplacé sans validation ?** — Non : aucune modification n'a été apportée aux dépôts sources ni au mod dans ce document.
5. **Contenu narratif ?** — Non concerné à ce stade (inventaire). Les cinématiques Red (136 `.cif.json`) et Sky (SSB analysé) seront réécrites pour New Era lors de l'import — mécanisme conservé, texte réécrit.

---

## 4. LIMITES HONNÊTES (vérifiées, à ne pas ignorer)

- **Bestiaire Red : NON extrait.** Les 98 XML et `dungeons.json` portent des placeholders identiques (zubat/geodude/machop) générés par une « simulated extraction » (code commenté dans `dungeon_analyzer.py`). L'import canonique du bestiaire Red exigera une **nouvelle extraction** depuis pret/pmd-red (`src/data/dungeon_pokemon.h`) ou une source équivalente.
- **Étages Red : NON fournis** dans le framework (aucun `<Floors>`). À extraire de pret/pmd-red.
- **Sky : prototype.** 1 seul `.rsground` converti ; la conversion des 323 grounds et des 77 donjons reste à exécuter via le pipeline documenté (`GROUND_FORMAT_ANALYSIS.md`).
- **Géométrie des donjons (salles/segments) : absente des deux frameworks.** Les XML sont des FloorPlans de spawns, pas des layouts. La géométrie **canonique des grounds** (entrance/midpoint/arène) est en revanche disponible : 245 `.rsground` pixel-perfect côté Red (branche master), 1 côté Sky.
- `PMD-SKY-PMDO-PORT` (repo autonome, 127 Mo) n'a pas été cloné en entier ; à faire si l'import Sky complet est retenu.
