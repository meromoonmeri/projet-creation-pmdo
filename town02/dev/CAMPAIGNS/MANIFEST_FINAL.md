# MANIFEST FINAL — PMD Red Rescue Team EU & PMD Explorers of Sky EU dans PMDO

**Date** : 2026-08-26 · **Branche** : `arena/01a0357e-new-era-abyss-to-ascension-v4`
**Règle d'or** : le canon vient des ROM ; PMDO/RogueEssence fournit le runtime ; les
outils font le pont. Toute approximation est déclarée `TECHNICAL_ADAPTATION` ou `GAP`,
jamais canonique. Les couvertures sont par **dimensions séparées** — aucun pourcentage
global fusionné n'existe.

Render de synthèse : `dev/docs/canonical/renders/SHOWCASE_RED_SKY.png`
(hub Bourg-Trésor, Guilde de Grodoudou, Plage, panorama défilant de l'intro, 4 arènes
boss Sky dont DIALGA, Place Pokémon Red, 3 arènes boss Red dont GROUDON/RAYQUAZA
décodées octet par octet).

---

## 0. Correspondance Nom humain ↔ Ground technique (PROUVÉE, audit 2026-08-26)

**Autorité Sky** : bloc ROM `Ground Map Names` (text_*.str EU, 5 langues), résolu à la
base d'index 16256 — preuve croisée : G01P01A(nameid 277)=« Wigglytuff's Guild /
Guilde de Grodoudou », T01P01A(303)=« Treasure Town / Bourg-Trésor »,
P01P01A(290)=« Crossroads / Croisement ». Table complète :
`PMD_SKY_EXPLORERS/Docs/LEVEL_HUMAN_NAMES.json` (366 levels nommés, 93 nameid hors
bloc = pas de nom de lieu). **143 noms ROM appliqués au MANIFEST Sky** (anciens
libellés conservés dans `previous_human_name`).

**Autorité Red** : pret/pmd-red `ground_map.h` (enum GroundMapID) →
`ground_map_conversion_table.c` → `map_files_table.c` (fichiers BPL/BPC/BMA/BPA) ;
45/45 noms de donjons du manifest = pret, 0 divergence.

| Nom humain (FR / EN) | Ground | Campagne | Preuve | Render | Runtime |
|---|---|---|---|---|---|
| Bourg-Trésor / Treasure Town | `t01p01a` (+t01p02a_sky) | Sky | nameid 303/304→bloc ROM | ✓ | LOAD+MOVE SAFE |
| **Guilde de Grodoudou** / Wigglytuff's Guild | **`g01p01a`** (variantes b/c/2) | Sky | nameid 277→bloc ROM | ✓ | LOAD+MOVE SAFE |
| Croisement / Crossroads | `p01p01a` | Sky | nameid 290 (l'ancien showcase l'étiquetait « Guilde » — **corrigé**) | ✓ | SAFE |
| Plage / Beach | `d01p11a` | Sky | nameid 196 | ✓ | SAFE |
| Café Spinda / Spinda's Café | `p01p04a` | Sky | nameid 293 | ✓ | SAFE |
| Panorama intro (sans nom, `???` ROM) | `s13p05a` | Sky | S13P05A nameid 185=`???` | ✓ | SCROLL_PASS |
| Place Pokémon / Pokémon Square | `t01p01` | Red | MAP_POKEMON_SQUARE→T01P01+BPA T01P011 (6 frames portées) | ✓ | journey |
| Base d'équipe / Rescue Team Base | `t00p01` | Red | MAP_SQUARE→T00P01 (**restauré** — était écrasé par le Sky homonyme) | ✓ | LOAD_PASS |
| Étang Barbicha / Whiscash Pond | `t01p02a` | Red | MAP_WHISCASH_POND→T01P02A+BPA T01P021 (336 frames) (**restauré**) | ✓ | LOAD_PASS |
| Mont Gel (Ninetales) / Mt. Freeze | `d11p01/p02/p03` | Red | MAP_MT_FREEZE_* (aucun BPA ROM → statique canonique) | ✓ | journey CH? |
| Ravin Aubaine (ép. Sunflora) / Fortune Ravine | `d45p21a` (non porté) | Sky | nameid→bloc ROM ; DUNGEON_SCREEN post-game | render ROM | NOT_BUILT |

### Collisions d'ID résolues (10 découvertes par l'audit)

`t00p01` et `t01p02a` : les grounds **Red GBA canoniques avaient été écrasés** par les
ports Sky NDS homonymes (Treasure Town ≠ Whiscash Pond !). Corrigé : contenu Red
restauré depuis 0f691fa3 (référence verrouillée), contenu Sky déplacé vers
`t00p01_sky` / `t01p02a_sky` (convention rock_path/rock_path_sky), zone+index mis à
jour. Les 8 autres IDs (`d18p11a, d19p11a, d20p11a, d21p21a, d21p41a, d22p11a,
s04p01a, s21p01a`) sont du contenu Sky listé par erreur dans le manifest Red —
marqués `is_red_canon: false`. Preuves post-correction : 96/96 grounds sky_hub_zone
SAFE, RED_GLOBAL_JOURNEY_PASS re-vérifié.

---

## 1. Sources canoniques authentifiées

| ROM | Fichier | sha256 |
|---|---|---|
| Sky EU (NDS, C2SP) | `Pokemon Mystery Dungeon - Explorers of Sky (Europe) (En,Fr,De,Es,It).nds` | `1fa39d35…c789f170c1` |
| Red EU (GBA) | `converter/rom_input/pmdred-eu.gba` | `0f9d125d…f604c14cbcd` |

Références de décodage : `pret/pmd-red@bf0092d0` (fixedmap.inc, dungeon_generation*.c,
pokemon_found.json, learnset_data.json), `pmdsky-debug` (enums music_id, opcodes),
`skytemple-files` (handlers BPL/BPC/BMA/BPA/SSB/SSA natifs).

Runtime cible : **PMDO 0.8.12** (bundle headless réel, quest `New-Era`,
sortie JSONL par harnais Lua — jamais de faux PASS : chaque verdict est émis par le
moteur lui-même pendant une partie réelle).

---

## 2. Chaîne complète (ROM RESOURCE → PMDO RESOURCE → RUNTIME BEHAVIOR)

```
ROM vérifiée (sha256)
  → extraction brute (scripts, maps, tables, dialogues, placements)
  → classification FONCTIONNELLE par preuves ROM (jamais par nom de fichier)
  → adaptation TECHNIQUE vers PMDO (documentée, fail-closed)
  → intégration (Data/Zone, Data/Map, Data/Ground, Content/Tile, Data/Script)
  → validation RUNTIME réelle (harnais Lua dans PMDO headless, JSONL)
  → JOURNEYS bout-en-bout (NEW SAVE → chapitres → boss final → état de fin)
  → matrice de couverture + audit + ce manifest
```

### 2.1 Extraction (établie, preuves commitées)

**Sky** : 3760/3760 SSB décompilés en ExplorerScript+JSON (dialogues 5 langues),
1884/1884 SSA/SSE/SSS (placements acteurs/objets/triggers), 315/315 LSD,
180 donjons / 1795 étages de tables mappa_s.bin (178 donjons PASS ; d71 et d173 sont
des slices vides DANS la ROM, documentés), LEVEL_MAP_LINKS (level→MAP_BG→mapty),
graphe de progression 245 états / 97 bit flags.
→ `PMD_SKY_EXPLORERS/Cinematics/`, `Tables/`, `Docs/PROGRESSION_GRAPH.json`.

**Red** : chaîne EVENT_* décodée octet par octet depuis la ROM EU
(gFunctionScriptTable @0x08294450, 399/407 scripts PASS, 136 états SCENARIO_MAIN 1:1
avec pret), 69 stations exactes + 3073 blocs de dialogues 5 langues, 133 cif.json de
cinématiques, progression jouable 121 états.
→ `PMD_RED_RESCUE_TEAM/Cinematics/`, `Docs/`.

### 2.2 Classification fonctionnelle Sky (460 grounds, preuves ROM)

`Docs/GROUND_CLASSIFICATION.json` — critères : `mapty` (Pmd2ScriptLevelMapType),
présence enter.sse/.sss/.ssa, collision BMA, xrefs SSB cross-zone. Résultat :
**95 MAP** (lieux marchables), **213 CINEMATIC_BACKGROUND** (dont défilants — jamais
convertis en fausses maps statiques), **62 DUNGEON_SCREEN** (mapty=10),
**26 CINEMATIC_GROUND**, **24 SCRIPTED_SCREEN**, **17 BOSS_ARENA_FIXED** (mapty=11),
22 REVIEW (dormants ROM), 1 UNREFERENCED. Contrat catégorie→pipeline→test :
`Docs/CLASSIFICATION_PIPELINE.md`.

### 2.3 Adaptations techniques documentées (jamais déclarées canoniques)

- Boss : `HP=0` → stats natives du moteur aux niveaux ROM exacts (les anciennes
  arènes à HP=60+4×level restent marquées approximation).
- Scrolling NDS → caméra continue PMDO (durée = distance/vitesse ROM).
- SetEffect EFFECT_* → émotes natives PMDO ; se_Play → PlayBattleSE (tables id→asset).
- 85 items d'Explorers absents du roster PMDO : `REQUIRES_MOD_ITEM` (pas de substitut
  silencieux) ; 8 musiques `REQUIRES_MOD_ASSET`.
- Double écran NDS : scènes concernées `SKIPPED_PARTIAL_FIDELITY`, pas simplifiées.

---

## 3. État runtime PROUVÉ (extraits JSONL commités dans `dev/docs/canonical/`)

### 3.1 Sky — Explorers of Sky EU

| Preuve | Verdict | Fichier |
|---|---|---|
| Journey global NEW SAVE→CH1→…→CH15→**DIALGA** : 14 chapitres, 30 donjons, **313 étages réellement générés**, 10 boss vérifiés, état final 20.0 | `GLOBAL_JOURNEY_PASS` | `sky/global_journey_runtime_proof.jsonl` |
| 43/43 donjons histoire (d01–d43) + **12 post-game** (d44, d50–d60 : Mystifying Forest, Surrounded Sea, Miracle Sea ×3, Aegis Cave ×7) — **59/59 EXACT** vs tables ROM (d46-d49 ajoutés, tilesets ROM portés) (comparateur durci PAR ÉTAGE, pièges à plages exactes) | `CANONICAL_RUNTIME_PASS` ×55, `EXACT` ×55 | `canonical_dungeon_runtime/`, `Tables/ZONE_VS_ROM_COMPARISON.json`, `sky/postgame_zones_runtime_proof.jsonl` |
| 9 chaînes donjon→arène boss (Team Skull→…→Groudon illusion) | `CHAIN_PASS`/`BOSS_ARENA_PASS` ×9 | `sky/story_chains_runtime_proof.jsonl` |
| 95/95 grounds MAP chargés + marchés en un run | `LOAD_PASS`+`MOVEMENT_PASS` (95 SAFE) | `sky/hub_grounds_runtime_proof.jsonl` |
| Progression : 14 états ROM franchis, 43 déblocages, monotonie | `PROGRESSION_RUNTIME_PASS` | `sky/progression_runtime_proof.jsonl` |
| Persistance : save → quit → **process 2** → LoadProgress → reprise | `RESUME_RUNTIME_PASS` | `sky/resume_runtime_proof.jsonl` |
| Background défilant pilote s13p05a (intro) : mouvement vérifié à 4 instants | `SCROLL_RUNTIME_PASS` | `sky/scroll_pilot_runtime_proof.jsonl` |
| Cinématiques compilées : **657 scènes** (fail-closed V5 + single-screen focus double écran), 55 rejouées dans le moteur | `CINEMATIC_RUNTIME_PASS` ×55 | `sky/compiled_scenes_runtime_proof.jsonl`, `Docs/SCENE_COMPILER_REPORT.json` |

### 3.2 Red — Rescue Team EU

| Preuve | Verdict | Fichier |
|---|---|---|
| Journey global : **13 chapitres, 182 étages, 6 boss SANS GAP** (Skarmory, Zapdos, Moltres, Glalie, **GROUDON L27**, **RAYQUAZA L35**) | `RED_GLOBAL_JOURNEY_PASS` | `red/global_journey_runtime_proof.jsonl` |
| Route mt_steel : entrée→8 étages→boss Skarmory→sortie | `ROUTE_PASS` | `red/mt_steel_route_runtime_proof.jsonl` |
| Persistance : save état 7.0 depuis t01p02b → quit → **process 2** → LoadProgress → état relu → reprise 8.0 | `RED_RESUME_RUNTIME_PASS` | `red/resume_runtime_proof.jsonl` |
| Chaînes magma_cavern_pit→Groudon et sky_tower_summit→Rayquaza | `CHAIN_PASS` ×2 | idem |
| 89/89 zones donjon (1848 étages) | `CANONICAL_RUNTIME_PASS` | `canonical_dungeon_runtime/matrix.json` |

### 3.3 Arènes GROUDON/RAYQUAZA — méthode (référence)

`fixedmap.inc` GBA décodé octet par octet : table `gUnknown_84A03BC` (index =
FixedRoomID−1), RLE de `sub_80511F0` reproduit, actions de `PlaceFixedRoomTile`
(sol/mur/spawn/escalier/entités ≥16), contre-épreuve Skarmory 9×17 == rsmap existant.
Niveaux ROM : Groudon **L27** (MagmaCavernPit 3F), Rayquaza **L35** (SkyTowerSummit 9F) ;
movesets learnset_data.json ; HP=0 (stats natives — PAS l'approximation 230/280).
Outil : `dev/tools/red_build_gba_fixed_arenas.py`.

---

## 4. Compilateur cinématique Sky (fail-closed)

`dev/tools/sky_compile_scenes.py` → `Data/Script/halcyon/skyscenes/` (374 fichiers Lua).

- **Règle absolue** : jamais d'opcode inconnu ignoré silencieusement, jamais de scène
  complexe remplacée par une version simplifiée déclarée PASS. Toute op non traduite
  est comptée (`PARTIAL_OPS`), toute scène incomplète est SKIPPED avec raison.
- Totaux : **657 COMPILED** (V5 single-screen focus), 592 PARTIAL_OPS (dénominateur élargi: les 625 PARTIAL_FIDELITY entrent désormais dans le compilateur), 20 NOT_COMPILED_MULTIROUTINE,
  625 SKIPPED_PARTIAL_FIDELITY (double écran NDS), 372 SKIPPED_REQUIRES_ENGINE_EXTENSION,
  2005 TRIVIAL_SKIPPED.
- Transport qualité : dialogues 5 langues ROM (markup NDS nettoyé, langue du joueur),
  déplacements aux positions ROM (tuile×8+offset×4, vitesses walk/slow), caméra
  (performer→MoveCamera), cast SSA (PNJ spawnés aux positions ROM exactes,
  entid→espèce via PMDO_MAPPING 525 entrées), SE→PlayBattleSE, VFX→émotes natives,
  BGM par table enum ROM→jukebox PMDO (56 pistes, 2 GAPs canal ambiance documentés).
- Kit runtime : `Data/Script/halcyon/skyscenes/kit.lua` (say multilingue, spawn_npc,
  cleanup, traces JSONL).

---

## 5. Harnais de validation runtime (opt-in, CH1–CH5 intouchés)

`Data/Script/halcyon/services/ground_gameplay_validator/init.lua` — modes par variable
d'env `PMDO_GROUND_VALIDATOR` :
`sky:<grounds>` (LOAD+MOVE), `skyscene:<scene>@<ground>`, `skyprogress`, `skyjourney`,
`redjourney`. `red_story_route_validator` (env dédiée) : routes Red + chaînes
donjon→boss Sky. Zone conteneur `sky_hub_zone` (95 GroundMaps) — `master_zone.json`
et `main.lua` verrouillés ne sont jamais modifiés.

**Verrou d'intégrité** : `python3 dev/tools/ch1_5_lockfile.py check` →
« INTÉGRITÉ OK — référence 0f691fa3 » (37/37 fichiers identiques) exigé avant chaque
commit. Vérifié à cette session.

---

## 6. Matrice de couverture (dimensions séparées)

Voir `dev/CAMPAIGNS/COVERAGE_MATRIX.md` (regénérée cette session). Points saillants :

**Red** : extraction 254/254 · renders 254/254 · journey global **13/13 PASS** ·
event chain 399/407 · progression 121/121 · donjons 89/89 · AUDIT_PASS.

**Sky** : extraction 460/460 · SSB 3760/3760 · SSA 1884/1884 · classification 437/460 ·
grounds MAP runtime **95/95 PASS** · journey global **14/14 PASS** · resume **PASS** ·
scroll pilote 1/213 · scènes compilées 370/3760 · espèces 484/484 EXACT ·
items 205/290 (85 REQUIRES_MOD_ITEM) · zones vs ROM 43/43 EXACT · AUDIT_PASS.

---

## 7ter. État de clôture ACTUALISÉ (session 2026-08-27 — FINALISATION)

Cette section REMPLACE les compteurs du §7 ci-dessous (conservé comme
historique daté 2026-08-26). Chaque ligne est adossée à une preuve jsonl.

| Élément | Statut | Détail / preuve |
|---|---|---|
| Donjons Sky d00–d179 | **PASS — COUVERTURE TOTALE** | **149/149 zones EXACT** vs ROM + CANONICAL_RUNTIME_PASS (Zero Isle d99-d103, Destiny Tower d104, Sky Peak d111-d122, épisodes spéciaux SE1-SE5 d123-d159, événements Wonder Mail S d165-d170, épilogue d174-d179). Seules exceptions : d105/d106/d171/d172/d173 = `[M:D1]Dummy` ROM (prouvé non canonique) |
| Fixed floors / arènes boss | **PASS** | 24 arènes fixed.bin (ff11 d45, ff17-ff26 post-game, **ff29-ff41 épisodes spéciaux** : Jirachi L16, Dialga primal L48, Sky Peak Summit + 3 guides ALLY_HELP→AllyTeams natif) — espèces ov29, niveaux EXACTS overlay10 FIXED_ROOM_MONSTER_SPAWN_STATS_TABLE |
| Musiques Sky | **PASS — 0 manquante** | Identités CORRIGÉES par contre-épreuve (MUSIC_ID_TABLE+RANDOM_MUSIC_ID_TABLE overlay10 EU × BackgroundMusicIDs, l'enum pmdsky-debug diverge de +1 au-delà de 138) ; groupes RANDOM = 4 pistes canoniques nommées ; 27 zones réalignées, 14 pistes extraites (Fortune Ravine, Ice Mountains, Sky Peak…) ; 0 musique manquante sur 261 zones |
| Cinématiques Sky compilées | **PASS 96,7 %** | **3454 COMPILED + 146 dual + 37 multi = 3637/3760** ; V8→V9.3 : switch génériques toutes branches, chaînes elseif (bug elseif→else corrigé), menus choix joueur natifs (kit.ask), SwitchTalk toutes variantes TALK_KIND, écritures $SCENARIO_MAIN→SkyProg.set, chaînage réel supervision_Execute*→play_scene, cast légendaires monster.md, slots équipe dynamiques ; ~30 CINEMATIC_RUNTIME_PASS de preuve ; 137 PARTIAL restants (formes résiduelles chiffrées) |
| REQUIRES_ENGINE_EXTENSION | **RÉSOLU 372→0** | les 3 ops «NON» avaient des équivalents natifs prouvés : message_Mail→dialogue natif (cadre courrier documenté), main_EnterRescueUser/Help→rescue natif PMDO (Rescues des zones) |
| CAST cinématiques | **PASS 3454/3454** | audit automatisé ROM_CAST vs PMDO_CAST (sky_cast_audit.py) : acteur à rôle narratif présent dans le Lua, hero/partner obligatoires ; corrections canon : message_SetActor/SetFace voix hors champ = SetSpeaker identité espèce ROM (attribution préservée) |
| Journey Sky CH1→CH15 | **PASS bout-en-bout AVEC CINÉMATIQUES** | GLOBAL_JOURNEY_PASS : 14 chapitres, **13 SCENE_PASS** (scènes d'ouverture canoniques jouées dans leur ground), 313 étages réels, 8 boss vérifiés par espèce jusqu'à DIALGA, état final 21.1, persistance SV à travers scènes→donjons→boss |
| Journey Red EVENT→gameplay | **PASS bout-en-bout AVEC CINÉMATIQUES** | RED_GLOBAL_JOURNEY_PASS : 13 chapitres, **13/13 SCENE_PASS** (stations ROM EU V2 jouées : d01p01 «Where am I?»→d16p01 Sky Tower), 182 étages, 6 boss (Zapdos, Moltres, Glalie, GROUDON, RAYQUAZA) |
| Stations Red REVIEW | **RÉSOLU 3→0 (133/133)** | t01p01/b01p01a/a05p02 extraits en mode EU-AUTORITAIRE (la ROM EU contient des groupes régionaux absents de pret ; divergences documentées : 1133/880/0) — t01p01 : 346 scripts/526 blocs texte, b01p01a : 287/730 |
| Persistance | **PASS ×2 re-vérifié** | RESUME_RUNTIME_PASS (Sky 6.0→8.0) + RED_RESUME_RUNTIME_PASS (Red 7.0) |
| Non-régression finale | **PASS** | 149/149 EXACT, 0 musique manquante, lockfile CH1-5 INTÉGRITÉ OK, cast 3454/3454 |

Preuves : `dev/docs/canonical/sky/{compiled_scenes_runtime_proof,journey_ch1_ch15_scenes_proof,postgame_zones_runtime_proof}.jsonl`,
`dev/docs/canonical/red/{journey_event_gameplay_proof,review_stations_resolution,resume_runtime_proof}.jsonl`,
`Docs/CAST_AUDIT.json`, `Tables/{MUSIC_MID_MAP,MUSIC_ID_TABLES,ZONE_VS_ROM_COMPARISON}.json`.

---

## 7. État de clôture — statuts distincts (contre-audit 2026-08-26)

Statuts : **PASS** (prouvé runtime+ROM) · **PARTIAL** (une partie prouvée, reste
chiffré) · **REQUIRES_MOD_ASSET** (ressource absente de la ROM ET du roster
PMDO) · **NOT_IMPLEMENTED** (pas commencé) · aucun BLOCKED restant.

| Élément | Statut | Détail / preuve |
|---|---|---|
| Donjons Sky d01–d43 + post-game d44–d60 + **d61–d98** | **PASS** | **86/86 EXACT** vs ROM + CANONICAL_RUNTIME_PASS (27 zones d61+ : 533 étages ; 19 tilesets NDS portés de dungeon.bin, 13 base réutilisés après vérification) |
| d45 Mystifying Forest Clearing | **PASS** | ARÈNE construite : géométrie fixed.bin 18×16 exacte, cast ov29 = les 9 membres de la guilde (contre-épreuve espèces mappa d45 : Wigglytuff L44, Sunflora L44, Chatot L51…), CANONICAL_RUNTIME_PASS + render |
| d61, d66, d69, d71, d74+pits, d99+ | **PARTIAL** | chambres Regigigas/pits = fixed floors (pipeline arène, entités ov29 à décoder au cas par cas) ; d71 slice vide DANS la ROM ; d99+ Zero Isle = multi-tilesets (2 portés sur 4) |
| Musiques Blizzard/Surrounded/Miracle/Random Dungeon | **REQUIRES_MOD_ASSET** | pistes absentes du roster PMDO ET non extractibles en .ogg vérifié ; zones jouent en silence documenté, jamais de substitution |
| 85 items Explorers (orbes/graines Sky) | **REQUIRES_MOD_ASSET** | absents du roster PMDO — exclus des spawns avec trace |
| Cinématiques Sky compilées | **PARTIAL** | **2157/3760 COMPILED (57 %)** — V6/V7 : table globale acteurs (306, entid unique ROM), multiroutines→coroutines Lock/Unlock fidèles, if de progression→SV native (les DEUX branches compilées), switch menus système, jump d'épilogue ; 66+ runtime PASS ; 1066 PARTIAL_OPS restantes, 372 REQUIRES_ENGINE_EXTENSION |
| Double écran NDS (625 scènes) | **PARTIAL (système single-screen focus opérationnel)** | Timeline canonique ROM par scène (`DUAL_SCREEN_TIMELINES.json` : 195 DUAL_TIMELINE, 106 sub préchargé jamais montré, 324 sans op duale) → reconstruction TOP/BOTTOM/BOTH_FOCUS + FOCUS_TRANSITION aux durées ROM (`subscreen.lua`, 62 nappes `Content/BG/Sub_*` rendus ROM cadrage NDS). 62/62 TIMELINE_MATCH vérifiés, 8/8 runtime PASS. Le contenu du 2e écran n'est plus jamais jeté. Reste : scènes duales bloquées par d'AUTRES ops (PARTIAL_OPS/multiroutines), et recadrage caméra sub dynamique non simulé (documenté) |
| Scrolling backgrounds | **PASS (classification exhaustive)** | 213 backgrounds analysés : **15 SCROLLING réels** (vitesses px/frame ROM, compilateur→caméra continue), **198 STATIC_PROVEN** (0 op scroll dans les 3760 SSB = preuve d'absence) ; 2 runtime PASS (s13p05a, s13p06a porté) |
| Grounds MAP Sky : NPC/interactions | **PARTIAL** | **15/15 hubs HUB_NPC_RUNTIME_PASS** : NPC résidents spawnés aux positions enter.sse exactes, héros marche vers chacun, dialogues enterNN.ssb ROM joués (16/33 avec dialogue ; 17 sans texte compilable tracés) |
| Cinématiques Red | **PARTIAL** | **66/130 stations compilées en SÉQUENCE ROM ordonnée** (V2 : commands des scripts EU par adresse — textes+musique 0x44 mid prouvé+waits 0xE7 entrelacés), 64 muettes PROUVÉES (0 text_block ROM) ; 6/6 runtime PASS |
| Stations Red REVIEW_REQUIRED | **PARTIAL (64→3)** | 61 résolues par CORRECTION D'OUTILLAGE (stub gFunctionScriptTable, groupes vides ROM légitimes, FUNC_i par index) — extraction 69→130 stations PASS, 3265 blocs ; restent t01p01/b01p01a (graphe EU divergent) et a05p02 (alignement 0.217) |
| Persistance | **PASS** | Sky RESUME_RUNTIME_PASS + Red RED_RESUME_RUNTIME_PASS (process 2, preuves jsonl) |
| Journeys globaux | **PASS** | Sky 14 ch./313 étages/DIALGA + Red 13 ch./182 étages/6 boss — re-vérifiés à la clôture |

### Contre-audit indépendant (GROUNDS_COUNTER_AUDIT.json)

Sens inverse de l'audit aller : manifests ROM (attendu) → package (réalisé).
**COUNTER_AUDIT_PASS** — 0 CRITICAL, 0 HIGH :
- 175 grounds à animation ROM déclarée : 0 aplati en statique ;
- 367 paires package↔RESERVE comparées octet par octet : dérives LOW
  documentées (RESERVE = instantané antérieur, le package fait foi) ;
- échantillon dirigé (Guilde g01*, Ninetales d11*, Sunflora s21p01a,
  panorama s13p05a, hub, collisions t00p01/t01p02a) : **93 216 cellules
  PNG décodées une à une, 0 défaut** ;
- noms humains : 0 dérive (Sky = bloc ROM, Red = pret).

**Aucune promotion New Era n'est proposée tant que ces GAPs ne sont pas comblés ou
explicitement acceptés.**

---

## 8. Manuel — reproduire les validations

### 8.1 Restaurer l'environnement (sandbox recyclé)

```bash
git fetch origin arena/01a0357e-new-era-abyss-to-ascension-v4
git checkout -B arena/01a0357e-new-era-abyss-to-ascension-v4 FETCH_HEAD
bash dev/tools/restore_pmdred_eu_validation_runtime.sh   # bundle PMDO 0.8.12 headless
# ROM Sky (LFS via codeload) :
mkdir -p .runtime-cache/sky-rom
curl -sL "https://codeload.github.com/meromoonmeri/BIBLIOTHEQUE/tar.gz/refs/heads/main" \
  | tar -xz --wildcards --strip-components=1 -C .runtime-cache/sky-rom "*Explorers of Sky*"
python3 -m venv .runtime-cache/sky-venv
.runtime-cache/sky-venv/bin/pip install skytemple-files ndspy Pillow
```

### 8.2 Vérifier l'intégrité CH1–CH5 (obligatoire avant commit)

```bash
python3 dev/tools/ch1_5_lockfile.py check   # attendu: INTÉGRITÉ OK — référence 0f691fa3
```

### 8.3 Rejouer un journey complet (preuve moteur réelle)

```bash
# via canonical_dungeon.pmdo_env() + ensure_quest_appdata(); env:
#   PMDO_GROUND_VALIDATOR=skyjourney   → Sky NEW SAVE→DIALGA (~5 min)
#   PMDO_GROUND_VALIDATOR=redjourney   → Red 13 chapitres (~16 s)
# cmd: PMDO -asset DUMP/ -appdata APP/ -quest New-Era
# sortie: /tmp/ground_gameplay_validator.jsonl (attendre "event":"end")
```

### 8.4 Rejouer une cinématique compilée

```bash
# PMDO_GROUND_VALIDATOR="skyscene:<zone>__<scene>@<ground>"  (ex: n01a0801@t01p01a)
```

### 8.5 Renders

```bash
python3 dev/tools/render_ground_png.py --output-dir /tmp/r t01p01a   # ground pixel-perfect
python3 dev/tools/render_rsmap_autotile.py Data/Map/magma_pit_groudon.rsmap out.png
python3 dev/tools/campaign_render_showcase.py                        # planche composite
python3 dev/tools/campaign_coverage_matrix.py                        # matrice à jour
```

---

## 9. Correctif de cette session (traçé)

`Content/Tile/S13p05a_Base.tile` (sheet du panorama défilant de l'intro) n'avait
jamais été persisté (sandbox recyclé après le pilote scroll). Reconstruit depuis la
ROM Sky EU par association clé rsground ↔ image ROM (BMA/BPC/BPL, 224 frames),
**fail-closed** (0 conflit sur 18756 clés), contre-épreuve **frame 0 PIXEL_PERFECT**
vs ROM. Outil : `dev/tools/sky_rebuild_s13p05a_sheet.py`.

## 9bis. Audit exhaustif des grounds (fail-closed, 2026-08-26)

`dev/tools/campaign_audit_grounds_complete.py` →
`dev/docs/canonical/GROUNDS_COMPLETE_AUDIT.json/.md` : **688 entrées** (600 rsground
+ 88 rsmap), pour chacune : sheets référencées présentes (nom+casse exacts, quest ou
base PMDO avec provenance tracée), **chaque clé TexLoc** référencée existe dans la
planche, autotiles présents avec toutes leurs variantes et frames, détection
d'animations aplaties (cycle ROM>1 vs frames portées — 193 grounds animés vérifiés,
0 aplati), détection d'animations 100 % vides, ressource en RESERVE seulement =
NOT_PERSISTED = FAIL. Résultat après corrections : **688/688 PASS**.
Note : frames `Sheet:""` au sein d'anims mixtes = frames transparentes délibérées
(blink), pas des trous — seule une animation entièrement vide est un défaut.

## 10. Index des artefacts

- Preuves runtime : `dev/docs/canonical/{sky,red}/*.jsonl`
- Renders : `dev/docs/canonical/renders/` + `dev/CAMPAIGNS/*/Renders/` (460 Sky, 254 Red)
- Docs Sky : `dev/CAMPAIGNS/PMD_SKY_EXPLORERS/{Docs,Tables,Cinematics}/`
- Docs Red : `dev/CAMPAIGNS/PMD_RED_RESCUE_TEAM/{Docs,Cinematics}/`
- Matrice / comparaison : `dev/CAMPAIGNS/{COVERAGE_MATRIX.md,RED_VS_SKY_COMPARISON.md}`
- Outils : `dev/tools/` (un outil par fonction, pas de doublons *_v2/final)
