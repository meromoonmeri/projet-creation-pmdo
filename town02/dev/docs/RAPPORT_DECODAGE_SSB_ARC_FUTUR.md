# RAPPORT — DÉCODAGE COMPLET DU BYTECODE SSB (Arc du Futur)

**Date : 2026-08-09 · Source : `pret/pmd-sky/files/language-specific/US/SCRIPT/`**
**Statut : ✅ COMPLET — bytecode SSB décodé (plus « PARTIEL »).**

---

## 1. MÉTHODE — format SSB identifié et cause de l'échec skytemple

### 1.1 Le format SSB (Explorers of Sky, région US)
- **Header US** (`SsbHeaderUs`, 12 octets) : `nb_constants u16`, `nb_strings u16`, `const_strings_start u16×2`, `const_table_length u16×2`, `strings_EN u16×2`, `unknown u16`.
- **Puis** (à partir de `data_offset` = 12) : `start_of_const_table u16×2`, `nb_routines u16`, **table des routines** (6 octets : offset u16×2, type u16, linked u16), **bytecode des ops**, **table de constantes**, **table des strings**.
- **Op** : `u16 opcode` + params (chaque param `u16`), params selon la table `op_codes__by_id` du script_data (`-1` = longueur variable, préfixe u16).

### 1.2 Pourquoi `FileType.SSB.deserialize` échouait (AssertionError)
**Cause exacte** : `Pmd2XmlReader.load_default()` charge le XML **EU** (`game_region: EU, game_edition: EoS_EU`). Le handler choisit alors `SsbHeaderEu` (18 octets, **5 langues**) alors que les fichiers de `pret/pmd-sky` sont **US** (12 octets, **1 langue**) → l'assertion `cursor == start_of_const_table` échoue.

**Solution** : les opcodes EU/US sont **identiques** (même jeu). On construit le modèle directement :
```python
sd = Pmd2XmlReader.load_default()          # script_data (opcodes identiques US/EU)
h  = SsbHeaderUs(data)                     # header US explicite
ssb = Ssb(data, h, h.data_offset, sd.script_data, string_codec=sd.string_encoding)
src, _ = ssb.to_explorerscript()           # décompilation Explorerscript complète
```

**Validation** : le fichier `m17a0302.ssb` (15526 octets) se décode intégralement : 1 routine, **1651 ops**, 212 strings, curseur final = 15526 = taille exacte du fichier ✅. Le fichier est **standard**, pas « non-standard ».

---

## 2. INVENTAIRE — 24 scènes décompilées (0 échec)

| Zone | Scène | Ops | Taille .exps | Contenu |
|---|---|---|---|---|
| **P05P01A** (trône) | m17a0103 | — | 2.8 Ko | Dusknoir rapporte la capture au maître |
| | m19a0102 | — | 2.3 Ko | `BGM_PLANETS_PARALYSIS`, la traque |
| | n08a2008 | — | 10 Ko | analyse stratégique (Passage of Time, Celebi) |
| **P05P02A** (prison) | m17a0104 | — | 8.9 Ko | réveil, « we're locked up » |
| | m17a0201 | — | 1.4 Ko | test des portes |
| | m17a0301 | — | 19 Ko | **transition `back_SetGround(LEVEL_S04P01A)`** (embranchement !) |
| **P05P03A** (pieux) | **m17a0302** | **1651** | **71 Ko** | **le poteau d'exécution — la scène complète** |
| | m26a06d3 | 236 | 7.6 Ko | l'évasion (corde coupée) |
| **P05P04A** (fuite) | m17a0401 | — | 7.7 Ko | la fuite avec Grovyle |
| | m17a0403 | — | 4 Ko | `BGM_PLANETS_PARALYSIS` |
| **P06P01A** (ascension) | m18a0401 | — | 79 Ko | l'ascension (longue scène) |
| | m26a0614 | — | 1.9 Ko | remerciements |
| **P07P01A** (refuge) | m18b1401 | — | 43 Ko | « Secret of the Planet's Paralysis » |
| | m26a06e6 | — | 2.7 Ko | « we have to get back » |
| **P08P01A** (Celebi) | m19a0601 | — | 22 Ko | où est Celebi |
| | m19d0612 | — | 1 Ko | « prevent the planet's paralysis » |
| | n08a2308/2408/2508/2608 | — | 8-15 Ko | scènes NPC |
| **P09P01A** (Passage) | m19b1001 | — | 39 Ko | le Passage of Time (18 marqueurs) |
| | m19b1007 | — | 24 Ko | Dusknoir avoue la manipulation |
| | m19b1009 | — | 9.8 Ko | « our time-traveling path has been shattered » |
| | m19d1072 | — | 5 Ko | la confrontation finale |

**Fichiers produits** : `V4/docs/ssb_decoded/<ZONE>_<scène>.exps` (24 fichiers, Explorerscript lisible).

---

## 3. LE CAST ORIGINAL (noms japonais des espèces → à remplacer par New Era)

| ACTOR (décompilé) | Espèce japonaise | Pokémon | Rôle dans la scène | **Cast New Era** |
|---|---|---|---|---|
| `ACTOR_NPC_YONOWAARU` (121) | ヨノワール | **Dusknoir** | le maître des sbires qui ordonne l'exécution | Dusknoir (allié du futur) |
| `ACTOR_NPC_YONOWAARU_N8` (70) | Dusknoir | Dusknoir | variante | Dusknoir |
| `ACTOR_NPC_YAMIRAMI` + 2..6 (≈700) | ヤミラミ | **Sableye** | les sbires/gardiens | les sbires de Necrozma |
| `ACTOR_NPC_SEREBII` (100) | セレビィ | **Celebi** | l'alliée qui guide | Celebi / équivalent New Era |
| `ACTOR_PLAYER` (266) | — | le héros | ligoté aux pieux | le héros New Era |
| `ACTOR_PLAYER_FUTURE` (75) | — | le héros du futur | l'incarnation future | le héros du futur New Era |
| `ACTOR_ATTENDANT1` (554) | — | (serviteur) | ligoté aux pieux | le partenaire New Era |

---

## 4. CHORÉGRAPHIE COMPLÈTE — m17a0302 (le poteau d'exécution, 1651 ops)

**Déroulé (ordre exact des commandes, extrait significatif) :**

1. `back_SetGround(LEVEL_P05P03A)` — la zone (stockade).
2. `supervision_StationCommon(0)` / `supervision_Acting(0)` — setup.
3. `camera_SetMyself<performer 0>()` — caméra sur le performer.
4. `SetAnimation<actor ACTOR_ATTENDANT1>(78)` — **animation 78 = ligoté**.
5. `screen_FadeIn(1, 120)` — fondu d'entrée (120 frames).
6. `se_Play(8964)` — SFX.
7. `SetEffect<actor ACTOR_ATTENDANT1>(EFFECT_SHOCKED, 3)` — choc.
8. `message_SetFace(ACTOR_ATTENDANT1, FACE_PAIN, FACE_POS_TOP_R_FACEINW)` — portrait douleur.
9. **Dialogue** : « Wh-where is this?! » (3 variantes `$PARTNER_TALK_KIND`).
10. `SlidePositionOffset<actor ACTOR_ATTENDANT1>(1, 1, 0)` → `Wait(2)` → `(1, -1, 0)` → `Wait(2)` → ×4 — **le ligoté se débat** (oscillation latérale).
11. Dialogue : « They have me trussed up. I can't move... ».
12. `se_Play(8711)`, `SetAnimation<actor ACTOR_PLAYER>(78)` — le héros aussi ligoté.
13. `Turn2Direction<actor ACTOR_ATTENDANT1>(4, 10, DIR_DOWNLEFT)` — rotation.
14. `SetEffect<actor ACTOR_PLAYER>(EFFECT_EXCLAMATION_MARK, 3)` — point d'exclamation.
15. `Turn2Direction<actor ACTOR_PLAYER>(4, 10, DIR_DOWNRIGHT)`.
16. Dialogues avec portraits FACE_SURPRISED.
17. `bgm_PlayFadeIn(BGM_IN_THE_FUTURE, 0, 256)` — **la musique du futur**.
18. Arrivée des sbires : `MovePositionMark<actor ...>(1, Position<'m43', 33, 99.5>)` — **positions flottantes exactes**.
19. `Turn2Direction<actor ACTOR_NPC_YONOWAARU>(4, 10, DIR_DOWNRIGHT)` etc.
20. `bgm_FadeOut(180)` — fondu musique.
21. `MovePositionMark<actor ACTOR_NPC_YONOWAARU>(1.1992, Position<'m45', 28.5, 116.5>)` — **Dusknoir rejoint les pieux (28.5, 116.5)** — cohérent avec le .ssa.
22. `screen_FadeOut(1, 60)` → `Wait(80)`.
23. `$SCENARIO_MAIN_BIT_FLAG[8] = 1` — flag.
24. `$COMPULSORY_SAVE_POINT = 14` — point de sauvegarde.
25. `CallCommon(CORO_HANYOU_SAVE_FUNC)` — sauvegarde.

**Types de commandes présentes (toutes) :** back_SetGround, supervision_*, camera_SetMyself, performer, SetAnimation, screen_FadeIn/Out, se_Play, SetEffect, WaitEffect, WaitExecuteLives, message_SetFace, message_FacePositionOffset, message_SwitchTalk/CaseText/DefaultText, CallCommon, SlidePositionOffset, Turn2Direction, MovePositionMark, Wait, bgm_PlayFadeIn, bgm_FadeOut, sound_Stop, variables $SCENARIO/$, conditions (switch/case), end.

**Autres scènes remarquables :**
- **m17a0301** (prison) : contient `back_SetGround(LEVEL_S04P01A)` = **embranchement vers S04P01A** (une autre zone du monde du futur).
- **m17a0401** (fuite) : la course avec Grovyle, `sound_Stop()`.
- **m19b1001** (Passage of Time) : 18 marqueurs de position, `BGM_TIME_GEAR`.
- **m26a06d3** (évasion) : `bgm_PlayFadeIn(BGM_MEMORIES_RETURNED, 0, 256)`.

---

## 5. MUSIQUES CANONIQUES DE L'ARC (décompilées)

| BGM (id Explorerscript) | Scène |
|---|---|
| `BGM_IN_THE_FUTURE` | P05P02A, P05P03A, P07P01A |
| `BGM_PLANETS_PARALYSIS` | P05P01A, P05P04A |
| `BGM_TIME_GEAR` / `BGM_TIME_GEAR_REMIX` | P07P01A, P09P01A, P05P01A |
| `BGM_IN_THE_DEPTHS_OF_THE_PIT` | P05P03A |
| `BGM_MEMORIES_RETURNED` | P05P03A, P06P01A, P07P01A |
| `BGM_IN_THE_HANDS_OF_FATE` | P06P01A |

---

## 6. STATUT FINAL

**Bytecode SSB : ✅ COMPLET** — les 24 scènes de l'arc du futur sont décompilées en Explorerscript avec toutes les commandes (déplacements, directions, vitesses, animations, timings, caméra, fades, téléportations, effets, SFX, BGM, conditions, embranchements, synchronisation). Fichiers : `V4/docs/ssb_decoded/*.exps`.

**Pipeline complet pour l'import PMDO** :
```
BMA/BPC/BPL (décor) + SSA (positions initiales) + SSB COMPLET (chorégraphie)
        ↓
scène complète → chorégraphie Lua PMDO
```

Prochaine étape : traduction de chaque scène en Lua PMDO avec le cast New Era (Necrozma = maître aux yeux rouges, Dusknoir/Grovyle = alliés, sbires = serviteurs de Necrozma, Dialga absent).
