# AUDIT EXHAUSTIF — Cinématique canonique de la météorite (PMD Red Rescue Team)

Date : 2026-08-06 — Statut : **audit terminé, ZÉRO modification / portage / conversion / remplacement / commit.**
Source primaire : `pret/pmd-red` (master). Chaque affirmation est référencée `fichier:ligne`.
Toute information non démontrée par les sources est déclarée **INCONNUE** (aucune hypothèse).

---

## RÉPONSES AUX 2 QUESTIONS (vérifiées dans les sources)

### Q1 — Xatu se situe-t-il bien sur la Colline des Anciens ?
**OUI, dans PMD Red, à deux endroits différents, tous deux nommés « Hill of the Ancients » :**

1. **Rencontre précoce** — map **192** `MAP_HILL_OF_THE_ANCIENTS` (script `gs192`, fond `D07P02.bpl`/`A04P01c.bpc` — `src/ground_map_conversion_table.c:1355-1359`, `src/map_script_table.c:333`, `src/map_files_table.c:1212-1217`). Xatu (portrait 2) : « What is it? Have you reason to see me? », remise de la *Clear Wing*, récit des « mirage Pokémon » = Rayquaza (`src/data/ground/ground_data_d07p02_station.h:56-103`).
2. **Scène de la météorite** — map **171** `MAP_SUMMIT_SUNSET` (script `gs171`, fond `A04P01.*`) dont le lieu affiché est précisément `GROUND_PLACE_HILL_OF_THE_ANCIENTS` = « Hill of the Ancients » (`src/ground_map_conversion_table.c:1207-1212` ; `src/ground_place.c:28`). Xatu (portrait 3, commenté « Xatu is 3 ») y est présent et parlant : « Kwaaaaaaaaaah! », création de la **Teleport Gem**, « Fear not! The star is no more. », explication du départ du héros (`ground_data_a04p01_station.h` : g3, g5, g7).
   Le journal d'aventure confirme : entrée [0] = « Reached the Hill of the Ancients. », entrée [2] = « Prevented the meteor's collision. » (`src/strings.c:82-84`).

**NB New Era** : le mod possède déjà une ground `colline_anciens` (30×20 tuiles, 240×160 px) avec Xatu sur un éperon rocheux (`Data/Ground/colline_anciens.rsground`, `Data/Script/halcyon/ground/colline_anciens/init.lua`), mais c'est **une scène originale du mod** (le script le dit explicitement : « Le CONTENU de la vision est propre à New Era »), pas la scène canonique A04P01.

### Q2 — La météorite est-elle visible en train d'être détruite par l'ultra-laser ?
**Dans la ROM canonique (vérifié dans les scripts) :**
- La **météorite EST visible** dans la scène de destruction (map **173** `MAP_COMET`, fond `A04P03.*`) :
  - elle est **peinte dans le décor** : l'analyse des pixels de `data/map_bg/A04P03.bpc` (fond 36×54 tuiles = 288×432 px) révèle un objet sombre/brunâtre dans le ciel étoilé, haut-centre (zone x≈115-171, y≈0-42) ;
  - elle est **aussi un effet sol** (`GroundEffectData`) : positions (17,36) et (18,33) avec scripts caméra + animation (voir §5).
- La **destruction par l'ultra-laser (Hyper Beam) est montrée par une rafale de FLASHS BLANCS plein écran + tremblement de caméra** (`gs173` g3) :
  `FLASH_FROM(blanc, 16)` → WAIT(120) → `FLASH_TO(blanc, 8)` → WAIT(5) → `FLASH_FROM(8)` → WAIT(20) → `FLASH_TO(8)` → WAIT(5) → `FLASH_FROM(8)` → WAIT(30) → `FLASH_TO(45)` → WAIT(30), le tout avec micro-tremblement caméra `0x97(1,0,0)` et fanfare 508 (`src/data/ground/ground_data_a04p03_station.h:82-111`).
- **Aucun sprite de rayon n'est affiché par le script** de la cutscene sol : le « rayon » est implicite (il pourrait être l'animation d'effet `0x56(0x135)` sur l'effet kind 3 en (18,33), dont le contenu graphique est une donnée ROM **non extraite** — voir §5).

**Dans le port actuel du mod** (`Data/Script/halcyon/ground/tour_celeste_sommet/init.lua`, `PlayPostVictory`) : la séquence est un enchaînement `BossFX.Flash` + `BossFX.ShakeScreen` + `PlayBattleSE("Heavy Earthquake.ogg")` + `CharSetAnim(rayquaza,"Shoot")`, avec un flash positionné au point écran (bx, 40). **Il n'y a NI météorite visible NI rayon visible** : les commentaires « beam SingleEmitter » / « La météorite apparaît au nord » décrivent une intention non implémentée (aucun appel de création de beam/sprite de météorite dans le code). Les dialogues TCS_016-021 (« ULTRALASER !!! Le rayon fend les nuages ! ») sont des **textes originaux du mod**, absents de PMD Red.

---

## 1. CORRESPONDANCE DES IDS — VERROUILLÉE SANS AMBIGUÏTÉ

Valeurs numériques de l'enum `GroundMapID` (`include/constants/ground_map.h`, comptées par script) :

| ID | Map | Script | Fichiers fond | Lieu affiché |
|----|-----|--------|---------------|--------------|
| **171** | `MAP_SUMMIT_SUNSET` | `gGroundScript_gs171` (fichier `ground_data_a04p01_station.h`, `SELECT_MAP(171)`) | `A04P01.bpl` / `A04P01c.bpc` / `A04P01m.bma` / `A04P011.bpa` | **Hill of the Ancients** |
| **173** | `MAP_COMET` | `gGroundScript_gs173` (fichier `ground_data_a04p03_station.h`, `SELECT_MAP(173)`) | `A04P03.bpl` / `A04P03c.bpc` / `A04P03m.bma` (pas de BPA) | « direction » (scène) |
| 192 | `MAP_HILL_OF_THE_ANCIENTS` | `gs192` (`ground_data_d07p02_station.h`) | `D07P02.bpl` + `A04P01c.bpc`/`A04P01m.bma`/`A04P011.bpa` (réutilisés) | Hill of the Ancients |
| 175/176 | `MAP_NIGHT_SKY_1/2` | `gs175/gs176` | `A05P01.*`/`A05P02.*` | — (ciel nocturne, autres scènes) |

Références : `src/map_script_table.c:312,314,333` ; `src/ground_map_conversion_table.c:1207-1212 (171), 1220-1226 (173), 1355-1359 (192)` ; `src/map_files_table.c:1086-1091 (SUMMIT_SUNSET→A04P01), 1098-1103 (COMET→A04P03), 1212-1217` ; `src/ground_files_table.c:707-710` (index 23-26 = « A04P01 », « A04P011 », « A04P01c », « A04P01m »).

> **Correction d'erreur de l'audit précédent** : `A04P01` n'est **pas** `MAP_COMET`. `A04P01.*` = les graphismes de **`MAP_SUMMIT_SUNSET`** (la scène de la colline, script gs171). `MAP_COMET` utilise les graphismes **`A04P03.*`** et le script **gs173**.

Structure de la cinématique complète (2 cutscenes sol + 1 cutscene donjon + 1 système global) :
- **gs171** (map 171) : scène de la colline — approche de l'étoile, Xatu/Alakazam, Teleport Gem, décision d'aller à la Tour Ciel, puis **réveil après la destruction** (« The star is no more. ») et **départ du héros**. 8 groupes (g0..g7), 2667 lignes.
- **gs173** (map 173) : **« The End »** — destruction de l'étoile par Rayquaza (flashs blancs + shake + fanfare 508). 4 groupes (g0..g3), 161 lignes.
- **`src/dungeon_cutscene_rayquaza.c`** : cutscene de **donjon** (sommet de la Tour Ciel, avant combat) — arrivée de Rayquaza, cri (son 0x1da), flashs de couleur d'écran de donjon, HP barre 600, `MUS_RAYQUAZAS_DOMAIN`/`MUS_BATTLE_WITH_RAYQUAZA`. **Ne montre pas la destruction de la météorite.**
- **`GroundScriptModifyBGM`** (`src/ground_script.c:4265-4274`) : pendant la phase `QUEST_IN_WORLD_CALAMITY` (`include/constants/event_flag.h:21`, commentaire ligne 211 : « World calamity music is forced. Partner awaits in Pokémon Square for you to confirm you're ready for Sky Tower. »), **toute** `BGM_SWITCH` est forcée vers `MUS_WORLD_CALAMITY`.

---

## 2. RESSOURCES CANONIQUES UTILISÉES — LISTE EXHAUSTIVE

### 2.1 Scripts sol (dans le repo, lisibles)
- `src/data/ground/ground_data_a04p01_station.h` — script **gs171** (scène colline + réveil + adieux), 2667 lignes.
- `src/data/ground/ground_data_a04p03_station.h` — script **gs173** (destruction), 161 lignes.
- `src/data/ground/ground_data_d07p02_station.h` — script **gs192** (rencontre Xatu précoce).
- `src/map_script_table.c` (liaison map→script), `src/map_files_table.c` + `src/ground_files_table.c` + `src/ground_map_files_1.c:27-36` (liaison map→fichiers), `src/ground_map_conversion_table.c` (lieu + flag), `src/data_script.h` (macros→opcodes), `include/constants/script_cmd.h` (enum), `src/ground_script.c` (moteur).

### 2.2 Fonds de carte (dans le repo, blobs)
- `data/map_bg/A04P01.bpl` (4004 o), `A04P011.bpa` (5812 o, overlay palettes animées), `A04P01c.bpc` (21828 o), `A04P01m.bma` (516 o) — map 171. Dimensions du calque : 39×75 tuiles = **312×600 px**, 146 chunks, 1 couche. Analyse pixels : colline sable/crépuscule (dominantes RGB≈(192,160,96), ciel (32,32,96), orange (224,128,0)).
- `data/map_bg/A04P03.bpl` (2912 o), `A04P03c.bpc` (24304 o), `A04P03m.bma` (424 o) — map 173. Dimensions : 36×54 tuiles = **288×432 px**, 145 chunks, 2 couches. Analyse pixels : ciel nocturne étoilé (dominante bleu profond (0,64,160)) + **objet sombre/brunâtre haut-centre (météorite dans le décor)**.

### 2.3 Sprites Pokémon (dans le repo, PNG)
- `graphics/ax/mon/rayquazacutscene/` : **374 fichiers** (sprites officiels de la cutscene Rayquaza).
- `graphics/ax/mon/rayquaza/` : ~809 entrées au total (sprites Rayquaza).
- `graphics/ax/mon/xatu/` : **82 fichiers** (sprite Xatu).

### 2.4 Audio (identifiants **dans le repo** ; **données audio dans la ROM uniquement**)
- `include/constants/bg_music.h` : `MUS_WORLD_CALAMITY = 19` (commenté « GIANT_STAR_APPROACHING »), `MUS_RAYQUAZAS_DOMAIN = 26`, `MUS_AFTERMATH = 41` (valeurs vérifiées par comptage).
- Fanfares (IDs m4a bruts, **noms inconnus**, ROM) :
  - **465** — chant de Xatu (« Kwaaaaaaaaaah! ») — `a04p01` g3 (2×) et g5 (réveil) ;
  - **489** — 2e chant de Xatu (fin de la Teleport Gem) ;
  - **500** — acclamation (« We're counting on you! ») ;
  - **474** — cri « Kwaaaaaaaaah! » (MSG_OVERHEARD, g5) ;
  - **508** — fanfare de la destruction (gs173 g1/g2) ;
  - **212** — fanfare d'obtention d'objet (MSG_INSTANT « received the Teleport Gem » + `WAIT_FANFARE1(212)`).
- Sons de donjon nommés en commentaire (`src/dungeon_cutscene_rayquaza.c:98,120,...`) : **0x1da = Rayquaza Cry**, 0x1f6 = flash, 0x1f8 = drop-in.
- Moteur : `src/music.c` (`m4aSongNumStart`), `src/music_util.c` (`PlayFanfareSE`).

### 2.5 Flashs / caméra / tremblement (code dans le repo)
- `src/palette_util.c` : `sub_80999E8` (début fade-out), `sub_80999FC` (début fade-in), `sub_8099A5C/8099AFC` (FLASH_FROM/TO), `sub_8099B94` (flash en cours ?). `PALUTIL_KIND_05` = « Blend Pals [0,13] puis [16,30] » vers la couleur donnée (blanc) (`include/constants/palette_util.h`).
- `src/code_809D148.c` : système caméra `sUnknown_20399E8` — `sub_809D124` (0x97), `sub_809D170/158` (CAMERA_INIT_PAN/END_PAN = 0x98/0x99), `sub_809D25C` (update/frame), `sub_809D234` (pan en cours ?).
- `src/ground_map.c:454-456` (MAP_SUMMIT_SUNSET : init `sub_80A3BB0(...,1)` + `sub_80A3B80`), `:459` (MAP_COMET : `gUnknown_2026E4E = 0x1010`), `:1436-1442` (MAP_SUMMIT_SUNSET : caméra couche 0 seule).

### 2.6 Effets sol (la météorite comme effet) — voir §5

### 2.7 Dialogues canoniques (textes **dans le repo**, liste intégrale de la scène)
Voir Annexe A. (Tous les textes cités sont extraits verbatim des fichiers.)

### 2.8 Tables de liaison / objets de la map
- gs171 : 0 objet, 0 event ; **lives** (NPCs) : positions et ids dans `s_gs171_g*_s0_lives[]` ; **effets** : `s_gs171_g*_s0_effs[]` ; 11 liens (links) vers d'autres maps.
- gs173 : 0 objet, 0 event ; 1 lien (18,6) ; 2 effets (g3 : (17,36) kind 0, (18,33) kind 3).

---

## 3. OPCODES BRUTS — FONCTIONS EXACTES DANS LE MOTEUR GBA

(vérifiées dans `src/ground_script.c` — dispatch principal `ExecuteScriptCommand` ligne 1514+, continuation asynchrone dans `HandleAction` lignes 490+ ; enum `include/constants/script_cmd.h` ; macros `include/data_script.h`)

| Opcode brut | Macro / nom | Fonction exacte (code) | Réf. |
|---|---|---|---|
| **0x22** | — | `sub_80999E8(argShort)` : démarre un **fade-out de palette** de durée argShort, puis attend `sub_8099B94()` (fade en cours) | 1913, 550-557 (continuation) |
| **0x23** | — | `sub_80999FC(argShort)` : démarre un **fade-in de palette**, puis attend la fin | 1919 |
| **0x27/0x28** | `FLASH_FROM`/`FLASH_TO` | `sub_8099A5C/sub_8099AFC(kind, durée, RGB)` : **blend de palette vers la couleur** (PALUTIL_KIND_05 = blanc) | 1944-1963 |
| **0x2d** | — | **Sous-commandes** (argByte) : 0=reset portrait, 1-3/4-6/7-9=changement de sprite/animation de live (`sub_80A2500/252C/2558`), 10=compte d'étages ; utilisés avec argByte 7 et 9 | 1986-2045 |
| **0x2e** | `PORTRAIT`/`PORTRAIT_REP` | Configure le portrait de l'intervenant | 2060+ |
| **0x3b** | — | `scriptData->unk2A = 0` : **remise à zéro d'un compteur interne** (pas de « condition ») — contre-commentaire du decomp (TODO erroné) | 2137-2139 |
| **0x44** | `BGM_SWITCH` | `GroundScriptModifyBGM(id)` (forçage MUS_WORLD_CALAMITY pendant la crise) puis `StartNewBGM_` | 2195-2201 |
| **0x49/0x4C** | `FANFARE_PLAY`/`PLAY2` | `PlaySoundWithVolume(id, 256)` (lance la fanfare/SE) | 2219-2220 |
| **0x4e** | `FANFARE_FADEOUT2` | `FadeOutSound(id, frames)` | 2225-2226 |
| **0x52** | — | `setFlags(parent, arg1)` : pose des flags d'objet (0x00010000 / 0x00020000) | 2267 |
| **0x53** | — | `clearFlags(parent, arg1)` (0x1f) | 2271 |
| **0x54** | `SELECT_ANIMATION` | `setEventIndex(parent, argShort)` : change l'animation du live (ex. 52 = « allongé/évanoui » au réveil) | 2278 |
| **0x56** | — | `func38(parent, arg1, argShort)` : pour les **effets**, `CallbackEffectSetUnk_80AD670` → pose `unk140 = arg1` (=0 → 448). `unk140` est consommé dans `GroundEffect_Action` par `sub_80A7040` : **joue l'animation `arg1` du sprite de l'effet** (ids 0x69/6a/6b/6c=105-108, 0xa0/a1/a4/a5/a6=160-166, 0x135=309) | 2290, 668+ (ground_effect.c), 784-786 (ground_effect.c) |
| **0x59** | — | `moveRelative(parent, (argShort<<8, arg1<<8))` : déplacement relatif en fixe 1/256 px (ex. −0xe0 = −224 px vers le haut) | 2306-2311 |
| **0x84** | — | Groupe marche : `pos2 = pos1 + (arg1<<8, arg2<<8)`, vitesse argShort (HYPOT) : **marche vers un offset relatif** (« Accept! » : le héros avance de (−24,−24) puis recule) | 2462-2472 |
| **0x89** | — | `setDirection(arg1)` + `unk30=vitesse` + `unk2A=frames` ; en continuation : **glisse dans la direction à la vitesse donnée pendant `unk2A` frames** (effets/caméra) | 2564-2567, 758-773 (continuation) |
| **0x93** | `CMD_UNK_93` | Groupe rotation : `unk2A=0` ; en continuation, **rotation progressive vers une direction/cible** (ex. `CMD_UNK_93(4,DIR_TRANS_10,34)` = se tourner vers l'entité 34) | 2659, 780-853 (continuation) |
| **0x97** | — | `sub_809D124(argShort, arg1, arg2)` : **configure le tremblement de caméra** — `unk24` = mode (1 : micro-shake période 4 ; 2 : shake fort), `unk28` = amplitude, `unk2C` = période ; consommé dans `sub_809D25C` (case unk24) | 2677, code_809D148.c:76,188,251-271 |
| **0x98/0x99** | `CAMERA_INIT_PAN`/`CAMERA_END_PAN` | `sub_809D170` / `sub_809D158` : enregistre/annule un **pan de caméra** sur le suivi d'un live/objet/effet (unk0=1/2/3) | 2696-2720, code_809D148.c:103-115 |
| **0xc6** | `CJUMP_UNK_C6` | `val = sub_80A8C2C(arg1)` = **espèce du live d'index arg1** (résolveur `sub_80A7AE8`) puis saut conditionnel (avec `COND_EQUAL` = 0xcc) — branche « membre d'équipe présent ? » | 2992+3018, ground_lives.c:1193-1201 |
| **0xde** | — | Attente asynchrone : `func50_spriteRelated(parent)` = **animation du sprite en cours ?** (pour les effets : `unk140 != 0`) | 542-549 (continuation), ground_effect.c:695-701 |
| **0xdf** | — | Attente asynchrone : `sub_8099B94()` = **fade/flash de palette en cours ?** | 557-563 (continuation) |
| **0xdb** | `WAIT` | Attente de `argShort` frames | continuation 508-533 |
| **0xe3/e4** | `AWAIT_CUE`/`ALERT_CUE` | Synchronisation entre scripts parallèles (locks `gScriptLocks`) | 871-880, 3258-3262 |
| **0xe8/e9** | `CALL_SCRIPT`/`JUMP_SCRIPT` | Appel/saut vers un script de fonction (table `gFunctionScriptTable`) | 3270-3277 |

---

## 4. NATURE EXACTE DE LA MÉTÉORITE (question 5)

La météorite est un **SYSTÈME COMBINÉ**, démontré par les sources :

1. **Décor (background)** : elle est peinte dans les tuiles du fond de la map COMET (`A04P03.bpc`) — objet sombre/brunâtre haut-centre du ciel étoilé (vérifié par analyse de pixels ; le fichier est dans le repo).
2. **Effets sol (GroundEffect)** : des objets `GroundEffectData` (kind 0/3/4/5) placés en (17,36)/(18,33) [gs173], (20,34)/(20,30)/(20,35)/(21,38)/(23,38)/(19,38)/(21,40)/(20,46)/(18,44)/(20,42)/(20,47) [gs171], pilotés par scripts (0x59 déplace, 0x89 glisse, 0x56 joue des animations 105-108/160-166/309, 0x52 pose des flags). **Leurs SPRITES proviennent de la table `gUnknown_8117E8C` (`src/ground_sprite_data.c:117-127`), qui est une « Dummy trailing list » entièrement NULLe dans le decomp** → le visuel exact des effets est une **donnée ROM non extraite** (INCONNU dans pret/pmd-red). Même chose pour `gGroundEffectTypes` (déclaré `extern` dans `ground_effect.c:52`, jamais défini dans le repo) qui mappe kind→type/flags.
3. **Palette animée** : overlay `A04P011.bpa` pour la map 171 (pas de BPA pour 173).
4. **Flashs plein écran** : système de blend de palette (`palette_util.c`), PALUTIL_KIND_05 vers blanc.
5. **Caméra/tremblement** : pans (0x98/0x99) + shake (0x97) + traitement spécial par map (`ground_map.c`).

**Conclusion** : la météorite = décor (tuiles) + effets sol (sprites ROM non extraites) + palette/overlay + flashs/caméra. Le sprite « météorite » lui-même n'existe **pas en tant que fichier nommé** dans le repo (aucun fichier `*meteor*`/`*comet*` dans graphics/ ou data/).

---

## 5. RESSOURCES RÉELLEMENT ABSENTES DE NEW ERA

| Ressource | Détail | Preuve |
|---|---|---|
| **Musique MUS_WORLD_CALAMITY** (id 19, « Giant Star Approaching ») | absente des 148 fichiers audio du mod ; aucun nom approchant | `bg_music.h:24` ; liste `Content/Music/*.ogg` (V4 HEAD) |
| **Musique MUS_RAYQUAZAS_DOMAIN** (id 26) | absente | `bg_music.h:31` ; liste ogg |
| **Musique MUS_AFTERMATH** (id 41) | absente | `bg_music.h:46` ; liste ogg |
| **Fanfares 465/474/489/500/508/212** | IDs m4a ROM, non extraits, non présents dans le mod | scripts a04p01/a04p03 |
| **Données audio ROM** (toutes pistes m4a) | le decomp ne contient pas les .sinc ; extraction nécessite la ROM | `music.c` (m4a) |
| **Sprite des effets (météorite)** | table `gUnknown_8117E8C` NULLe (ROM) | `ground_sprite_data.c:117-127` |
| **Table `gGroundEffectTypes`** (kind→type/flags) | ROM non extraite | `ground_effect.c:52` |
| **Animations d'effet 0x56** (105-108, 160-166, 309, 448) | dépendent du fichier axmain ROM de l'effet | `ground_effect.c:784-786` + `ground_sprite.c:772+` |
| **Map sol canonique A04P01/A04P03 dans le mod** | 306 grounds du mod : ni `a04p01` ni `a04p03` (seule une `colline_anciens` custom 240×160) | `git ls-tree HEAD Data/Ground/` |
| **Scénario canonique (dialogues/timings/Teleport Gem)** | non présent dans le mod (TCS_016-021 = textes originaux du mod) | `tour_celeste_sommet/strings.fr.resx:18-23` |
| **Cutscene « The End » (flashs 8/8/8/45)** | le mod utilise des équivalents BossFX (flashs + shake), pas la séquence exacte | `tour_celeste_sommet/init.lua:47-115` |
| **Météorite visible / rayon visible** | le port actuel ne crée aucun sprite météorite ni rayon | `tour_celeste_sommet/init.lua` (aucun appel de création) |

---

## 6. RESSOURCES DÉJÀ PRÉSENTES DANS NEW ERA (ou accessibles)

| Ressource | Où | Statut |
|---|---|---|
| **`a04p01.rsground` / `a04p03.rsground`** (fonds canoniques convertis) | dépôt `meromoonmeri/PMD-RED-PMDO-PORT`, `output/Grounds/` (246 grounds ; aussi a04p02, a04p04) | convertis, **pas encore importés** dans le mod |
| Ground `colline_anciens` + script Xatu | V4 `Data/Ground/colline_anciens.rsground` + script | présent (scène originale du mod) |
| Grounds `tour_celeste_entree/relais/sommet` + scripts (boss Rayquaza) | V4 (commits 8ae6e29, 83cf229) | présents (approche non canonique) |
| `Content/Music/Sky Tower.ogg`, `Summit.ogg` | V4 | présents (substituts non canoniques déjà utilisés) |
| `Content/Sound/Heavy Earthquake.ogg` (+ variants) | V4 | présent |
| Sprites Rayquaza (374 cutscene + ~809 totaux) | `pret/pmd-red graphics/ax/mon/` | disponibles (non importés) |
| Sprite Xatu (82) | idem | disponible |
| Tilesets/tools de conversion BPL/BPC/BMA/BPA→rsground | PMD-RED-PMDO-PORT (`tools/`) | opérationnels (245-246 maps converties) |

---

## 7. ÉLÉMENTS RESTANT À PORTER POUR UNE REPRODUCTION STRICTEMENT IDENTIQUE

1. **Importer les 2 maps canoniques** : `a04p01.rsground` (Colline des Anciens, 312×600) et `a04p03.rsground` (COMET, 288×432) depuis `PMD-RED-PMDO-PORT` + leurs tuiles `*_Base.tile` dans `Data/Ground` / `Content/Tile` du mod, + index.
2. **Porter le script gs171 en Lua RogueEssence** : dialogues canoniques verbatim, timings WAIT exacts, positions des entités, Teleport Gem (fanfare + message), VARIANTs partenaire, branche « membres d'équipe », séquence réveil/départ.
3. **Porter le script gs173 en Lua** : BGM_WORLD_CALAMITY → RAYQUAZAS_DOMAIN, fanfare 508, **flashs blancs 16/8/8/8/45 exacts** + tremblement caméra.
4. **Audio canonique** : MUS_WORLD_CALAMITY / MUS_RAYQUAZAS_DOMAIN / MUS_AFTERMATH + fanfares 465/474/489/500/508/212 → **extraction ROM** (nécessite la ROM fournie par l'utilisateur) ou **autorisation explicite** de substitution documentée (interdite par défaut).
5. **Visuel météorite** : si la ROM est fournie, extraire les sprites des effets (table `gUnknown_8117E8C` + `gGroundEffectTypes` + animations 0x56) ; sinon, la reproduction ne peut montrer que le décor A04P03 + flashs (la météorite peinte dans le fond reste visible).
6. **Portraits/dialogues** : utiliser les sprites Xatu (82) et Rayquaza (374) officiels si import souhaité.
7. **Mécanique de phase** : le forçage `MUS_WORLD_CALAMITY` pendant `QUEST_IN_WORLD_CALAMITY` est transposable en flag SV.
8. **Raccord scénaristique** : la cinématique canonique suppose le contexte « Tour Ciel → destruction → réveil à la colline → départ » ; intégration avec la zone `tour_celeste` existante à décider (le mod a déjà une fin de zone avec Rayquaza).

---

## 8. POINTS NON DÉMONTRÉS — DÉCLARÉS INCONNUS (conformément à la directive)

1. **Visuel exact des effets sol** (météorite en mouvement, rayons, éclats) : table ROM `gUnknown_8117E8C` NULLe dans le decomp → **inconnu**.
2. **Signification exacte des animations 0x56** (105-108, 160-166, 309) : dépend du fichier axmain ROM de chaque effet → **inconnu**.
3. **Identité audio des fanfares 465/474/489/500/508/212** : IDs m4a bruts sans table dans le decomp (seul 212 est identifiable par usage : fanfare d'obtention d'objet) → **inconnu**.
4. **Sémantique précise de `gUnknown_2026E4E = 0x1010`** sur MAP_COMET : le code (`code_8040094_1.c:96-97`) montre un compteur incrémenté par pas de 0x101, mais la signification visuelle exacte n'est pas démontrée → **inconnu**.
5. **Chronologie exacte du déclenchement scénaristique** (quel script de quête charge la map 171/173) : la liaison map↔script est vérifiée, mais la chaîne du script de quête principal n'a pas été tracée individuellement dans cet audit → **non tracé** (aucune hypothèse émise).
6. **Le contenu du fond « objet sombre » d'A04P03** : l'analyse de pixels confirme un objet dans le ciel, mais son apparence exacte (forme/détails) n'est pas démontrable sans extraction visuelle → partiellement **inconnu**.

---

## ANNEXE A — Dialogues canoniques (extraits verbatim, script gs171 / gs173)

(g1) « From the sky! Comes a star! » / « ...It is huge... A giant of a star! » / « The star, it falls. It falls straight to us. »
(g2) « Disasters in nature... There were many... » / « The balance of the world, it has been upset... » / « All because of the star. The star that slowly comes closer. » / « ...If it keeps coming... It will crash into this world. It shall be terrible. » / « Something must be done... »
(g3) « Ah, good of you to come. » (Alakazam) / « Kwaaaaaaaaaah! » (Xatu, ×2) / « Wh-...what's going on? What is {NAME_3} doing? » (partenaire) / « It is almost ready. The Teleport Gem... » / « .........It is made. » / « This... This is the Teleport Gem. » / « This will deliver you to the world of the sky. » / « Now, {NAME_0}. Accept! » / « {NAME_0}'s team received the Teleport Gem. » / « That was made using the powers of psychics. By me, {NAME_2}, and... Oh? A Ghost-type Pokémon. We received help from it. ...Gone away, it seems... » / « Hahaha! It must be bashful. Let it be. » / « Now... I must ask you this one last time. This journey will be fraught with considerable danger. Will you still go? » / VARIANTs partenaire (« We need to see Rayquaza and ask it to blow up that falling star, right? » …) / héros : « (...Yes... And when that wish comes true...) » « (Gardevoir said...) »
(g4) héros : « (............) » « (This will be my last adventure... With {NAME_1}...) » / partenaire : « {NAME_0}! Let's do this right! » / Xatu : « We're counting on you! {NAME_1}! {NAME_0}! »
(g5) « .........Hey. » / « ...Hey, can you hear... » / « Snap out of it! » / « (...Huh...? This place...) » / « ............Urgggh...... » / « ...Regained consciousness! » (Alakazam) / « Oooooooohhhhh! » / « (...I'm sure of it...) » « (...I'm sure... Back there... Gengar saved me...) » / « ...Maybe... Did Gengar save {NAME_0} too? » / « Awesome, you're alive! You really had all of us worried! » (Lombre) / « You were incredible! » (Charizard) / « Snivel... I'm so glad you're safe! It's fantastic! » (Caterpie) / « Everyone... Thank you. But... » / « What about the star?! What happened to it?! » / **« Kwaaaaaaaaah! » (overheard)** / **« Fear not! The star is no more. » / « Though it will not be right away... The disasters shall soon be calmed. » (Xatu)** / « Be calm. {NAME_8} is safe. » / « We did it, {NAME_0}! We've won peace! » (partenaire)
(g6) « Yippee! This is the greatest! » / « This calls for a celebration! » / « Let me shoot my Hydro Pump to kick it off! » (Charizard) / « Whoa, hold on there! Don't you point those things at me! Face the other way! » (Lombre) / « No, no! Let it loose! Hahaha! » / « I'll secure him so he can't get away. » / « {NAME_0}... »
(g7) « Snivel... {NAME_0}... Why... I don't understand... » (Caterpie) / « Why? Why was it necessary to leave us...? » (Charizard) / « Just upped and went like that... Why now? Why when the world's been saved? » (Lombre) / « This was coming... Our world, it was saved by {NAME_0}. » / « I look back now... When bound for the sky, {NAME_0} seemed... As if resigned. Resigned to accept what was to come. » (Xatu) / « ............ I think I know... » / « {NAME_0} became a Pokémon to save us... » / « And when... When the star was destroyed... {NAME_0} knew that would be the time to leave... » / « Why... Why didn't {NAME_0} tell me earlier...? » / « Those words couldn't be spoken. » / « As much as you are heart-broken now... {NAME_0} must have felt the same pain of leaving. » / « Try to understand, {NAME_1}. » (Alakazam) / « Sob... {NAME_0}... » (partenaire)

(gs173) : aucun dialogue — uniquement flashs, fanfares, musique, caméra et un effet animé.
