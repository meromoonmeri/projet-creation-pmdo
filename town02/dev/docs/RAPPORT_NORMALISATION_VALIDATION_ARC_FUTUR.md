# RAPPORT DE SYNTHÈSE — NORMALISATION & VALIDATION — ARC DU FUTUR (24 scènes)

Date : 2026-08-09 — Branche `arena/019fd882-new-era-abyss-to-ascension-v4`

## Statut global

**Le décodage SSB est terminé et certifié. La couche intermédiaire canonique
est construite et validée à 100 %. Les 24 scènes sont converties en Lua PMDO
(couche 4, générées + syntaxe validée). Restent : dialogues FR (clés FUT_*),
tables anim/SE/effets (ROM), import des 8 grounds, tests runtime PMDO.**

## Les 4 couches (aucune fusion)

```
1. SSB Sky original (bytecode)        pret/pmd-sky, ROM USA — INTACT
        ↓
2. IR canonique JSON                  docs/ssb_ir/<ZONE>_<scene>.json
        ↓
3. Adaptation New Era                 docs/ssb_adaptation/ (cast, tables, dialogues)
        ↓
4. Lua PMDO (RogueEssence)            convertisseur — jouable dans le mod
```

## 1. Validation IR canonique — 24/24 scènes ✅

Rapport détaillé : `docs/RAPPORT_VALIDATION_IR_SSB.md` · données :
`docs/ssb_ir/`.

| Contrôle | Résultat |
|---|---|
| Scènes traitées | **24/24** |
| Opérations totales | **7035** |
| `cursor == file_size` (parseur consomme exactement le fichier) | **24/24 ✅** |
| Opcodes inconnus | **0** |
| Paramètres non résolus | **0** |
| Énumérés non documentés (id valide, nom absent XML) | **5** : `SetEffect` 640 (×3), 645, 651 — valeur numérique conservée, NON CONVERTIS tant que non identifiés |
| Contre-vérification modèle skytemple (ops/constantes/strings/routines) | **24/24 ✅** |

Pipeline de parsing vérifié : header US 12 o → `start_of_const_table` +
`nb_routines` → table routines (6 o/entrée) → bytecode (`u16` opcode + params
`u16`, `-1` = longueur variable) → table offsets constantes → constantes →
strings EN. Résolution des paramètres identique au désassembleur officiel
(ENUM_ARGUMENTS + point fixe 1/256 + PositionMark 4 params).

## 2. Matrice de couverture — 97,6 % convertibles

Rapport : `docs/MATRICE_COUVERTURE_SSB_LUA.md` · données :
`docs/ssb_ir/_coverage_summary.json`.

| Statut | Ops | % |
|---|---|---|
| OK (idiome attesté direct) | 3726 | 53,0 % |
| ADAPT (idiome OK, dépend de la couche New Era) | 3142 | 44,6 % |
| PARTIEL (approximatif — signalé) | 163 | 2,3 % |
| NON (aucun équivalent PMDO) | 4 | 0,06 % |

Les 4 NON : `bgm2_PlayFadeIn` / `bgm2_FadeOut` (2e canal BGM — PMDO n'a qu'un
canal) et `message_Mail` ×2 (système de courrier absent). Aucune commande n'est
ignorée silencieusement : toute op PARTIELLE/NON est listée exhaustivement dans
la matrice.

89 opcodes mappés, tous compris. Les principales tables REQUISES pour lever le
statut ADAPT : animations (id PMD2 → nom PMDO), SE (id → nom SE), effets de
sprite (id → emote/VFX), BGM (Sky → .ogg New Era), grounds (Sky → ground
importé), dialogues (Sky → FR New Era).

## 3. Graphe des scènes — transitions conservées

Rapport : `docs/GRAPHE_SCENES_ARC_FUTUR.md` · données :
`docs/ssb_ir/_scene_graph.json`.

- Chaque scène pose son ground (`back_SetGround(<zone>)`) puis se déroule.
- **Embranchement critique conservé** : `m17a0301 → back_SetGround(S04P01A)`
  (retour vers le présent) + `back_ChangeGround(P05P02A2)`.
- Couches décor (`back2_SetGround`) : S04P01A (m26a0614), V09P04A (P07),
  V12P01A/V13P01A (m19b1001), V14P01A/P03A/P04A (m19b1007).
- `main_EnterDungeon` : 140 / 30 / 32767 (n08a2308, n08a2508 — Passage du Temps).
- **Fin de m17a0302 (poteau d'exécution)** : `flag_CalcBit(SCENARIO_MAIN_BIT_FLAG, 8, 1)`
  → `flag_Set(COMPULSORY_SAVE_POINT, 14)` → `CallCommon(HANYOU_SAVE_FUNC)`.
- Routines communes observées : `MESSAGE_CLOSE_WAIT_FUNC` (390), `LOOK_AROUND_*`
  (34), `JUMP_SURPRISE/ANGRY/HAPPY_FUNC_SERIES`, `BOSS_WIPE_FUNC`, `HANYOU_SAVE_FUNC`.
- Conditions : `message_SwitchTalk(PARTNER_TALK_KIND)` (265) et
  `message_SwitchMonologue(HERO_TALK_KIND)` (57) + `CaseText` (587) — dialogues
  variant selon l'espèce du partenaire (à conserver en adaptation).

## 4. Couche d'adaptation New Era

Dossier : `docs/ssb_adaptation/` (README + cast.json + tables.json +
vocabulaire.json).

- **Cast** (directives utilisateur encodées verbatim) : Dusknoir/Grovyle =
  alliés du futur ; Sableye = sbires de Necrozma ; maître aux yeux rouges
  (P05P01A) = **Necrozma** ; Celebi = guide ; Dialga **absent** (gentil dans
  New Era) ; événements 30 ans plus tard ; climax ch.32 Necrozma+Eternatus.
- **Ré-attribution du rôle antagoniste** : les scènes où Sky fait de Dusknoir
  le méchant (m17a0301, m17a0302, m19b1007, m19b1009, m19d1072) voient leur
  couche dialogue portée par Necrozma/ses sbires. **Animations, positions,
  déplacements, embranchements : 1:1.**
- **Tables REQUISES (non inventées)** : animations (78 = ligoté…), SE (89xx…),
  effets (640/645/651) — à établir depuis les données ROM (pmdsky-debug / ROM
  USA) avant conversion complète.

## Couche 4 — Conversion Lua PMDO (FAITE, à compléter)

Rapport : `docs/RAPPORT_CONVERSION_LUA_ARC_FUTUR.md` · fichiers :
`docs/lua_arc_futur/<ZONE>_<scene>.lua` (24 modules, 6388 lignes).

| Contrôle | Résultat |
|---|---|
| Scènes converties | **24/24** |
| Syntaxe Lua validée (luaparser) | **24/24 ✅** |
| API utilisée attestée dans le mod (GROUND/GAME/UI/SOUND/TASK/AI) | ✅ (aucun appel inventé) |
| Positions | tuiles SSB → pixels ×8 (+4 si .5) — convention du port ✅ |
| Vitesses | Sky (point fixe) → PMDO px/frame ×2 (calibré mod) |
| Parallélisme `lives`/`WaitExecuteLives` | waves → `TASK:JoinCoroutines` par acteur ✅ |
| Embrachement `m17a0301 → S04P01A` | conservé (`GAME:EnterGroundMap('s04p01a')`) ✅ |
| Ops NON converties | 4 types : `bgm2_PlayFadeIn/FadeOut` (1 canal BGM), `message_Mail` (×2), `SetEffect` 640/645/651, `SetPositionMark` sur objet, `Hold` — toutes signalées en commentaire, jamais silencieuses |
| Tables REQUISES (non inventées) | animations (id → nom PMDO, placeholder Idle sûr + TODO), SE (id → nom, `SSB_SE_<id>` pcall + TODO), effets 54/100/172/640/645/651 (BossFX) |

**Dialogue** : le texte canonique Sky est conservé en commentaire de chaque
`UI:WaitShowDialogue` ; le texte joué est une clé `FUT_<SCENE>_<NNN>` à écrire
en français (couche d'adaptation, jamais fusionnée dans l'IR).

**À noter (décision narrative requise)** : dans `m17a0103` (P05P01A, repaire),
Dusknoir s'adresse au « Master Dialga ». New Era : Dusknoir est allié, le
maître est Necrozma. La ré-attribution (locuteur Sableye, ou Dusknoir face à
Necrozma) est laissée à la couche dialogue — chorégraphie conservée 1:1.

**Reste pour rendre les scènes jouables :**
1. Import des 8 grounds (p05p01a→p09p01a) avec entités nommées selon
   `ACTOR_CH` (Dusknoir, Grovyle, Sableye_1..6, Celebi, HeroFuture) ;
2. tables anim/SE/effets depuis la ROM (pmdsky-debug / ROM USA) ;
3. dialogues FR (clés FUT_*) dans `Strings/stringsEx.*.resx` ;
4. branchement des modules sur l'init.lua des grounds + runner d'arc ;
5. compilation + tests runtime PMDO (rapport final par scène).
