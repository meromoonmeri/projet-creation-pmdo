# RAPPORT D'AUDIT — Cinématique canonique de la Météorite (PMD Red Rescue Team)

**Date** : 2026-08-06
**Directive** : reproduction à l'identique, interdiction d'inventer/recréer/simuler des assets, arrêt et signalement si une ressource manque.
**État** : **AUDIT COMPLET — AUCUNE modification effectuée, AUCUN fichier importé.**

---

## 1. RESSOURCES CANONIQUES RETROUVÉES (source : `pret/pmd-red`)

### 1.1 Le script complet de la cinématique (LA référence maîtresse)

**Fichier** : `pret/pmd-red/src/data/ground/ground_data_a04p01_station.h`
**Map** : `A04P01` = `MAP_COMET` (la météorite) — script `gGroundScript_gs171`
**Correspondance vérifiée** : `ground_map_conversion_table.c` → `[MAP_COMET] = { .mapFileTableId = MAP_FILE_ID_COMET }` et `ground_files_table.c` → `[23-26] = A04P01`.

Le script contient **8 secteurs (g0-g7)** avec le déroulé exact, les timings, les dialogues, les positions d'acteurs et d'effets :

| Secteur | Contenu canonique |
|---|---|
| **g0** | Entrée : `BGM_STOP`, `JUMP_SCRIPT(COMMON_ENTER)` |
| **g1** | `BGM_SWITCH(MUS_WORLD_CALAMITY)`, `FLASH_FROM(32 blanc)`, `AWAIT_CUE(3)`, eff : `CAMERA_END_PAN`→`CAMERA_INIT_PAN`, `WAIT(60)`, `ALERT_CUE(5)` — dialogues : « From the sky! Comes a star! » / « ...It is huge... A giant of a star! » / « The star, it falls. It falls straight to us. » |
| **g2** | `BGM_SWITCH(MUS_WORLD_CALAMITY)`, `FLASH_TO(32 blanc)`, eff : pan caméra, `WAIT(60)` — dialogues : « Disasters in nature... » / « The balance of the world, it has been upset... » / « All because of the star... » / « ...If it keeps coming... It will crash into this world. » |
| **g3** | Scène Xatu/Rayquaza : `BGM_FADEOUT(30)`, `WAIT(60)`, `BGM_SWITCH(WORLD_CALAMITY)`, `FANFARE_PLAY2(465)` (cri Rayquaza), `FANFARE_PLAY2(489)`, `FANFARE_PLAY(212)` (obtention Gemme de Téléportation), `WAIT_FANFARE1(212)` — **10+ dialogues officiels** dont : « Ah, good of you to come. » (Xatu), « Kwaaaaaaaaaah! » (Rayquaza), « It is almost ready. The Teleport Gem... », « Now, {NAME_0}. Accept! », « This will deliver you to the world of the sky. », les VARIANTs du partenaire (« We need to see Rayquaza and ask it to blow up that falling star, right? »...), MSG_QUIET héros (« ...Yes... And when that wish comes true... ») |
| **g4-g7** | Secteurs suivants (le héros reçoit la Gemme, départs) |

### 1.2 Positions exactes des acteurs (`GroundLivesData`)

| Acteur | kind | Position (demi-tuiles) |
|---|---|---|
| Héros | 0 | (18,44), (20,5), ... |
| Partenaire | 1 | (22,44), (22,44), ... |
| Xatu | 2 | (20,41), (20,34), (20,33), ... |
| Rayquaza (portrait/voix) | 3 | (20,30), (21,38), ... |

### 1.3 Positions exactes des effets (`GroundEffectData`)
(20,34), (20,35), (20,30), (21,38), (23,38), (19,38), (21,40), (20,47), (20,46), (18,44) — en demi-tuiles.

### 1.4 Musique canonique
`MUS_WORLD_CALAMITY` (= **GIANT_STAR_APPROACHING**), `MUS_RAYQUAZAS_DOMAIN` — définies dans `include/constants/bg_music.h` (lignes 24, 31).

### 1.5 Fanfares canoniques (IDs GBA)
- **465** = cri de Rayquaza (Kwaaaaaah)
- **489** = fabrication de la Gemme
- **212** = obtention d'objet (Gemme de Téléportation)

### 1.6 La map A04P01 (ciel + météorite)
`data/map_bg/A04P01.bpl` (palettes) + `A04P01c.bpc` (tuiles) + `A04P01m.bma` (layout) + `A04P011.bpa` (animation).

### 1.7 Sprites officiels Rayquaza
`graphics/ax/mon/rayquazacutscene/` — 374 sprites GBA.

### 1.8 Commandes de script identifiées (table `include/constants/script_cmd.h` + `include/data_script.h`)

| Commande | Opcode | Effet |
|---|---|---|
| `FLASH_FROM` / `FLASH_TO` | 0x27 / 0x28 | flash de palette (blanc) avec durée |
| `BGM_SWITCH` / `BGM_STOP` / `BGM_FADEOUT` | 0x44 / 0x47 / 0x48 | musique |
| `FANFARE_PLAY2` / `FANFARE_FADEOUT2` / `FANFARE_PLAY` | 0x4C / 0x4E / 0x49 | jingles |
| `CAMERA_INIT_PAN` / `CAMERA_END_PAN` / `CAMERA_PAN` | 0x98 / 0x99 / 0x86 | caméra |
| `WAIT` | 0xDB | attente (frames) |
| `AWAIT_CUE` / `ALERT_CUE` | 0xE3 / 0xE4 | synchronisation |
| `WALK_GRID` / `ROTATE_TO` | 0x6B / — | déplacements acteurs |
| `MSG_NPC` / `MSG_VAR` / `MSG_QUIET` / `PORTRAIT` | — | dialogues/portraits |
| `SELECT_MAP` / `SELECT_ENTITIES` | 0x08 / 0x0C | contexte |

### 1.9 Commandes brutes NON déchiffrées (implémentation bytecode non documentée)
`0x22`, `0x23`, `0x2d`, `0x2e`, `0x3b`, `0x56`, `0x59`, `0x84`, `0x89`, `0x97`, `0xdf` — présentes dans le script, exécutées par le switch de `src/ground_script.c` (lignes 550-561, 758-768, 1368-1383) mais leur effet précis n'est pas documenté dans la décompilation (noms `CMD_BYTE_XX` génériques).

---

## 2. RESSOURCES RÉELLEMENT ABSENTES (arrêt et signalement)

| Ressource | Emplacement attendu | Pourquoi introuvable |
|---|---|---|
| **Musique `MUS_WORLD_CALAMITY`** (« Giant Star Approaching ») | `Content/Music/World Calamity.ogg` dans New Era | N'existe pas dans New Era (134 musiques, aucune World Calamity). La musique GBA est un ID `MUS_WORLD_CALAMITY`, pas un fichier audio versionné dans pmd-red |
| **Musique `MUS_RAYQUAZAS_DOMAIN`** | `Content/Music/Rayquaza's Domain.ogg` | Idem — absente de New Era |
| **Map A04P01 convertie** | `Data/Ground/` | Aucune conversion `.rsground` de A04P01 dans New Era |
| **Fanfares 465 / 489 / 212** | SONS GBA (pas de fichiers) | IDs GBA bruts, pas de correspondance New Era documentée |
| **Les commandes brutes** (0x22, 0x89...) | `src/ground_script.c` | Bytecode GBA partiellement décompilé : les cas existent mais les noms `CMD_BYTE_XX` ne documentent pas l'effet |
| **Sprite dédié de la météorite** | — | La météorite GBA était un effet de calque/OBJ (pas un sprite PNG versionné) — le `GROUND_AUDIT` du port RED le confirme |

---

## 3. FICHIERS MODIFIÉS / IMPORTÉS

**AUCUN.** Conformément à la directive, l'audit a été effectué avant toute modification. Rien n'a été écrit, importé ou généré.

---

## 4. POINT D'ARRÊT — décision requise

La **traduction** de cette cinématique GBA vers RogueEssence/New Era nécessite des **choix d'implémentation** qui ne sont pas « à l'identique » au niveau technique :

1. **Flashs de palette** (`FLASH_TO/FROM`, PALUTIL_KIND_05) → l'équivalent RogueEssence est `GAME:FadeOut/FadeIn` ou `BossFX.Flash` — ce sont des **équivalents RogueEssence**, interdits **sans autorisation**.
2. **Map A04P01** → conversion `.rsground` (pipeline existant, 1:1) — autorisé par les règles du projet, mais la météorite elle-même (OBJ GBA) n'a pas de sprite versionné.
3. **Musiques** → `MUS_WORLD_CALAMITY` n'existe pas ; la remplacer par Summit.ogg/Sky Tower.ogg serait un **remplacement non canonique** (ce que j'ai déjà fait dans `tour_celeste_sommet` — à révoquer ou à valider).
4. **Commandes brutes** (0x22, 0x89...) → leur effet exact n'est pas documenté ; les reproduire demanderait de décompiler davantage `ground_script.c` ou d'accepter une interprétation.

**Je m'arrête ici conformément à la directive.** Aucune reproduction n'a été entreprise. Merci de trancher :
- (a) autoriser la traduction RogueEssence des flashs/musiques (équivalents documentés),
- (b) fournir la ROM GBA pour extraire les assets manquants (musique, sprites OBJ),
- (c) ou laisser l'audit tel quel.
