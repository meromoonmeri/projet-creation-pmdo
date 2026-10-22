# MATRICE DE COUVERTURE — SSB → Lua PMDO — ARC DU FUTUR

Pipeline : `SSB ops totales → ops comprises → ops converties → ops non converties`.

Statuts : **OK** = idiome attesté · **ADAPT** = idiome OK mais dépend de la couche d'adaptation
New Era (acteurs/dialogues/BGM/grounds/anims/SE/effets) · **PARTIEL** = approximatif (signalé, jamais
silencieux) · **NON** = aucun équivalent PMDO (explicitement NON CONVERTI).

## Récapitulatif global (7035 ops sur 24 scènes)

- Ops totales : **7035**
- Ops comprises (opcode connu + sémantique établie) : **7035 (100.0%)**
- Ops converties (OK + ADAPT) : **6868 (97.6%)**
  - OK direct : **3726** (53.0%)
  - ADAPT (couche New Era requise) : **3142** (44.7%)
- Ops partielles (approximatives, signalées) : **163** (2.3%)
- Ops NON converties : **4** (0.1%)

## Par scène

| Zone | Scène | Ops | Comprises | OK | ADAPT | PARTIEL | NON | Taux converti |
|---|---|---|---|---|---|---|---|---|
| P05P01A | m17a0103 | 59 | 59 | 29 | 24 | 6 | 0 | 89.8% |
| P05P01A | m19a0102 | 56 | 56 | 29 | 21 | 6 | 0 | 89.3% |
| P05P01A | n08a2008 | 195 | 195 | 84 | 105 | 4 | 2 | 96.9% |
| P05P02A | m17a0104 | 152 | 152 | 92 | 58 | 2 | 0 | 98.7% |
| P05P02A | m17a0201 | 18 | 18 | 7 | 9 | 0 | 2 | 88.9% |
| P05P02A | m17a0301 | 322 | 322 | 190 | 128 | 4 | 0 | 98.8% |
| P05P03A | m17a0302 | 1651 | 1651 | 889 | 732 | 30 | 0 | 98.2% |
| P05P03A | m26a06d3 | 236 | 236 | 131 | 103 | 2 | 0 | 99.2% |
| P05P04A | m17a0401 | 117 | 117 | 61 | 52 | 4 | 0 | 96.6% |
| P05P04A | m17a0403 | 84 | 84 | 47 | 35 | 2 | 0 | 97.6% |
| P06P01A | m18a0401 | 642 | 642 | 419 | 220 | 3 | 0 | 99.5% |
| P06P01A | m26a0614 | 32 | 32 | 17 | 13 | 2 | 0 | 93.8% |
| P07P01A | m18b1401 | 535 | 535 | 268 | 253 | 14 | 0 | 97.4% |
| P07P01A | m26a06e6 | 53 | 53 | 29 | 21 | 3 | 0 | 94.3% |
| P08P01A | m19a0601 | 389 | 389 | 185 | 201 | 3 | 0 | 99.2% |
| P08P01A | m19d0612 | 15 | 15 | 7 | 7 | 1 | 0 | 93.3% |
| P08P01A | n08a2308 | 206 | 206 | 97 | 101 | 8 | 0 | 96.1% |
| P08P01A | n08a2408 | 136 | 136 | 78 | 56 | 2 | 0 | 98.5% |
| P08P01A | n08a2508 | 97 | 97 | 53 | 39 | 5 | 0 | 94.8% |
| P08P01A | n08a2608 | 359 | 359 | 181 | 176 | 2 | 0 | 99.4% |
| P09P01A | m19b1001 | 776 | 776 | 354 | 406 | 16 | 0 | 97.9% |
| P09P01A | m19b1007 | 545 | 545 | 278 | 231 | 36 | 0 | 93.4% |
| P09P01A | m19b1009 | 239 | 239 | 134 | 100 | 5 | 0 | 97.9% |
| P09P01A | m19d1072 | 121 | 121 | 67 | 51 | 3 | 0 | 97.5% |

## Table de mapping par opcode (89 opcodes de l'arc)

| Opcode | Catégorie | Statut | Idiome PMDO | Note |
|---|---|---|---|---|
| `Move2PositionMark` | ACTEUR | **ADAPT** | déplacement direct vers marqueur | GROUND:AnimateToPosition / MoveToPosition (sans pathfinding) |
| `Move2PositionOffset` | ACTEUR | **ADAPT** | déplacement relatif direct | idem |
| `MoveHeight` | ACTEUR | **ADAPT** | changement d'altitude | chara.LocHeight (vol/saut) — valeurs Sky -> pixels |
| `MovePositionMark` | ACTEUR | **ADAPT** | déplacement vers marqueur | GROUND:MoveToPosition(chara, sx*8, sy*8) — positions SSA (tuiles) -> pixels |
| `MovePositionOffset` | ACTEUR | **ADAPT** | déplacement relatif | GROUND:MoveToPosition(chara, pos.x+dx, pos.y+dy) |
| `SetAnimation` | ACTEUR | **ADAPT** | animation | GROUND:CharSetAnim(chara, nomPMDO, loop) — TABLE anim Sky->PMDO REQUISE (id par espèce) |
| `SetDirection` | ACTEUR | **ADAPT** | direction immédiate | chara.Direction = dir |
| `SetEffect` | ACTEUR | **ADAPT** | effet de sprite | GROUND:CharSetEmote / CharSetDrawEffect / PlayVFX — TABLE effets Sky->PMDO REQUISE ; ids 640/645/651 NON CONVERTIS |
| `SetOutputAttribute` | ACTEUR | **PARTIEL** | attribut de sortie (bulle ?) | sémantique à confirmer — approximatif |
| `SetPositionMark` | ACTEUR | **ADAPT** | téléportation vers marqueur | GROUND:TeleportTo |
| `SetPositionOffset` | ACTEUR | **ADAPT** | téléportation relative | GROUND:TeleportTo(chara, x, y, dir) |
| `Slide2PositionOffset` | ACTEUR | **ADAPT** | glissement relatif direct | idem |
| `SlidePositionMark` | ACTEUR | **ADAPT** | glissement vers marqueur | idem |
| `SlidePositionOffset` | ACTEUR | **ADAPT** | glissement relatif | GROUND:AnimateToPosition (easing) |
| `Turn2Direction` | ACTEUR | **ADAPT** | rotation vers direction | GROUND:CharAnimateTurnTo(chara, dir, frames) — speed/rot -> frames |
| `Turn2DirectionLives` | ACTEUR | **ADAPT** | rotation d'un acteur | idem |
| `WaitAnimation` | ACTEUR | **OK** | attente fin d'animation | GROUND:CharWaitAnim(chara) |
| `WaitEffect` | ACTEUR | **OK** | attente fin d'effet | GAME:WaitFrames |
| `WaitBgm` | AUDIO | **PARTIEL** | attente musique | GAME:WaitFrames approximatif |
| `WaitSe` | AUDIO | **PARTIEL** | attente fin de SE | GAME:WaitFrames approximatif |
| `bgm2_FadeOut` | AUDIO | **NON** | fondu 2e canal BGM | idem — NON CONVERTI |
| `bgm2_PlayFadeIn` | AUDIO | **NON** | 2e canal BGM | PMDO : un seul canal BGM — NON CONVERTI |
| `bgm_FadeOut` | AUDIO | **OK** | fondu musique | SOUND:FadeOutBGM(dur) |
| `bgm_PlayFadeIn` | AUDIO | **ADAPT** | musique | SOUND:PlayBGM('xxx.ogg', true) — TABLE BGM Sky->New Era REQUISE |
| `bgm_Stop` | AUDIO | **OK** | arrêt musique | SOUND:StopBGM() |
| `se_FadeOut` | AUDIO | **PARTIEL** | fondu SE | idem |
| `se_Play` | AUDIO | **ADAPT** | effet sonore | SOUND:PlayBattleSE('EVT_...') — TABLE SE Sky->PMDO REQUISE |
| `se_Stop` | AUDIO | **PARTIEL** | arrêt SE | pas d'arrêt SE direct PMDO (StopBGM ne couvre pas les SE) |
| `sound_Stop` | AUDIO | **PARTIEL** | arrêt de tous les SE | idem |
| `camera2_SetEffect` | CAMERA | **PARTIEL** | effet sous-caméra | idem approximatif |
| `camera2_SetPositionMark` | CAMERA | **PARTIEL** | sous-caméra vers marqueur | équivalent overlay/parallaxe approximatif |
| `camera_SetEffect` | CAMERA | **ADAPT** | effet caméra (shake) | GROUND:MoveScreen(ScreenMover(0, intensité, durée)) |
| `camera_SetMyself` | CAMERA | **PARTIEL** | caméra suit le performer | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| `back2_SetEffect` | DECOR | **PARTIEL** | effet couche décor | idem |
| `back2_SetGround` | DECOR | **ADAPT** | couche décor (image de fond) | overlay image de la scène (MECANIQUE SCENE FUTUR/RIZEAU) |
| `back2_SetMode` | DECOR | **PARTIEL** | mode couche décor | sémantique à confirmer |
| `back_ChangeGround` | DECOR | **ADAPT** | change de ground | idem |
| `back_SetBanner2` | DECOR | **PARTIEL** | bannière chapitre | UI:WaitShowTitle(title) approximatif |
| `back_SetDungeonBanner` | DECOR | **PARTIEL** | bannière donjon | UI:WaitShowTitle approximatif |
| `back_SetGround` | DECOR | **ADAPT** | change de ground | transition -> ground New Era (GAME:EnterGroundMap) — TABLE grounds REQUISE |
| `screen2_FadeIn` | ECRAN | **ADAPT** | fondu de la couche décor | overlay scène (fond) — MECANIQUE DU RIDEAU/SCENE DU FUTUR |
| `screen2_FadeOut` | ECRAN | **ADAPT** | fondu sortie couche décor | idem |
| `screen2_WhiteOut` | ECRAN | **ADAPT** | voile blanc couche décor | idem |
| `screen_FadeIn` | ECRAN | **OK** | fondu entrée | GAME:FadeIn(dur) |
| `screen_FadeInAll` | ECRAN | **OK** | fondu entrée toutes couches | GAME:FadeIn(dur) |
| `screen_FadeOut` | ECRAN | **OK** | fondu sortie | GAME:FadeOut(false, dur) |
| `screen_FadeOutAll` | ECRAN | **OK** | fondu sortie toutes couches | GAME:FadeOut(false, dur) |
| `screen_FlushIn` | ECRAN | **ADAPT** | fondu coloré entrée | FlashEmitter(StartColor r,g,b) / BossFX.Overlay |
| `screen_FlushOut` | ECRAN | **ADAPT** | fondu coloré sortie | idem |
| `screen_WhiteOut` | ECRAN | **OK** | voile blanc | GAME:FadeOut(true, dur) |
| `screen_WhiteOutAll` | ECRAN | **OK** | voile blanc toutes couches | GAME:FadeOut(true, dur) |
| `flag_CalcBit` | ETAT | **ADAPT** | bit de variable | opérations bit sur SV |
| `flag_Set` | ETAT | **ADAPT** | écriture variable | SV.<var> = valeur — table variables Sky->SV REQUISE |
| `flag_SetScenario` | ETAT | **ADAPT** | variable scénario | SV.Scenario[...] = valeur (SCENARIO_MAIN_BIT_FLAG, COMPULSORY_SAVE_POINT) |
| `main_EnterDungeon` | ETAT | **ADAPT** | entre dans un donjon | GAME:EnterDungeon / EnterGroundMap — mapping id |
| `CallCommon` | FLOW | **ADAPT** | routine commune Sky -> helper Lua | table routines communes (WAIT_START_FUNC, END_TALK, HANYOU_SAVE_FUNC...) -> équivalent New Era |
| `CaseMenu` | FLOW | **OK** | branchement menu | UI:BeginChoiceMenu / UI:WaitForChoice |
| `CaseText` | FLOW | **OK** | branchement texte | if/else Lua sur SV |
| `DefaultText` | FLOW | **OK** | texte par défaut d'un switch | else Lua |
| `Destroy` | FLOW | **OK** | détruit l'acteur/objet courant | GROUND:RemoveCharacter / Hide |
| `End` | FLOW | **OK** | fin de scène | return |
| `ExecuteCommon` | FLOW | **ADAPT** | routine commune parallèle | idem, via TASK |
| `Hold` | FLOW | **PARTIEL** | pause maintenue | pas d'équivalent exact : GAME:WaitFrames(1) + var |
| `Jump` | FLOW | **OK** | goto structuré | traduit en structure Lua (if/label) |
| `Wait` | FLOW | **OK** | attente frames | GAME:WaitFrames(n) |
| `WaitExecuteLives` | FLOW | **OK** | attente coroutine acteur | TASK joint la coroutine de l'acteur |
| `WaitExecuteObject` | FLOW | **OK** | attente coroutine objet | idem |
| `WaitExecutePerformer` | FLOW | **OK** | attente coroutine performer | idem |
| `lives` | FLOW | **OK** | structurel (contexte acteur) | parallèle Sky -> TASK:BranchCoroutine en Lua |
| `object` | FLOW | **OK** | structurel (contexte objet) | variable cible Lua |
| `performer` | FLOW | **OK** | structurel (contexte performer) | variable cible Lua |
| `supervision_Acting` | FLOW | **OK** | lance une chorégraphie parallèle d'acteur | TASK:BranchCoroutine |
| `supervision_RemoveActing` | FLOW | **OK** | arrête la chorégraphie parallèle | annulation coroutine |
| `supervision_StationCommon` | FLOW | **OK** | pose l'acteur en mode stationnaire | AI:DisableCharacterAI / action idle |
| `message_Close` | MESSAGE | **OK** | ferme le dialogue | UI:ResetSpeaker() |
| `message_CloseEnforce` | MESSAGE | **OK** | ferme le dialogue (forcer) | UI:ResetSpeaker() |
| `message_EmptyActor` | MESSAGE | **OK** | locuteur vide | UI:SetSpeaker('\\uE040', true, '', -1, '', Gender.Unknown) |
| `message_FacePositionOffset` | MESSAGE | **PARTIEL** | décalage du portrait | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| `message_ImitationSound` | MESSAGE | **PARTIEL** | son d'imitation vocale | SOUND:PlayBattleSE approximatif |
| `message_KeyWait` | MESSAGE | **OK** | attente clé | UI:WaitShowDialogue bloque déjà — GAME:WaitFrames court si besoin |
| `message_Mail` | MESSAGE | **NON** | courrier (système absent de PMDO) | à remplacer par un dialogue / rien — NON CONVERTI |
| `message_ResetActor` | MESSAGE | **OK** | réinitialise le locuteur | UI:ResetSpeaker() |
| `message_SetActor` | MESSAGE | **ADAPT** | définit le locuteur | UI:SetSpeaker(chara) — acteur mappé New Era |
| `message_SetFace` | MESSAGE | **ADAPT** | portrait + émotion | UI:SetSpeaker(chara) + GeneralFunctions.SetEmotion(face Sky -> émotion New Era) |
| `message_SetFaceOnly` | MESSAGE | **ADAPT** | portrait sans dialogue | idem sans UI:WaitShowDialogue |
| `message_SwitchMenu` | MESSAGE | **OK** | menu de choix | UI:BeginChoiceMenu |
| `message_SwitchMonologue` | MESSAGE | **ADAPT** | bascule de monologue | idem |
| `message_SwitchTalk` | MESSAGE | **ADAPT** | bascule de locuteur selon variable | if/else sur SV (variable Sky -> SV New Era) |
| `message_Talk` | MESSAGE | **ADAPT** | dialogue | UI:SetSpeaker + UI:WaitShowDialogue(STRINGS:FormatKey(CLE)) — texte = couche d'adaptation FR |

## Ops NON converties (exhaustif)

| Scène | Seq | Op | Raison |
|---|---|---|---|
| P05P01A/n08a2008 | 20 | `bgm2_PlayFadeIn` | PMDO : un seul canal BGM — NON CONVERTI |
| P05P01A/n08a2008 | 129 | `bgm2_FadeOut` | idem — NON CONVERTI |
| P05P02A/m17a0201 | 6 | `message_Mail` | à remplacer par un dialogue / rien — NON CONVERTI |
| P05P02A/m17a0201 | 7 | `message_Mail` | à remplacer par un dialogue / rien — NON CONVERTI |

## Ops PARTIELLES (exhaustif)

| Scène | Seq | Op | Raison |
|---|---|---|---|
| P05P01A/m17a0103 | 4 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P01A/m17a0103 | 9 | `SetOutputAttribute` | sémantique à confirmer — approximatif |
| P05P01A/m17a0103 | 30 | `message_ImitationSound` | SOUND:PlayBattleSE approximatif |
| P05P01A/m17a0103 | 37 | `message_ImitationSound` | SOUND:PlayBattleSE approximatif |
| P05P01A/m17a0103 | 43 | `se_FadeOut` | idem |
| P05P01A/m17a0103 | 54 | `WaitSe` | GAME:WaitFrames approximatif |
| P05P01A/m19a0102 | 4 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P01A/m19a0102 | 9 | `SetOutputAttribute` | sémantique à confirmer — approximatif |
| P05P01A/m19a0102 | 25 | `message_ImitationSound` | SOUND:PlayBattleSE approximatif |
| P05P01A/m19a0102 | 33 | `message_ImitationSound` | SOUND:PlayBattleSE approximatif |
| P05P01A/m19a0102 | 39 | `se_FadeOut` | idem |
| P05P01A/m19a0102 | 50 | `WaitSe` | GAME:WaitFrames approximatif |
| P05P01A/n08a2008 | 0 | `sound_Stop` | idem |
| P05P01A/n08a2008 | 13 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P01A/n08a2008 | 16 | `SetOutputAttribute` | sémantique à confirmer — approximatif |
| P05P01A/n08a2008 | 18 | `SetOutputAttribute` | sémantique à confirmer — approximatif |
| P05P02A/m17a0104 | 0 | `sound_Stop` | idem |
| P05P02A/m17a0104 | 15 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P02A/m17a0301 | 6 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P02A/m17a0301 | 299 | `WaitSe` | GAME:WaitFrames approximatif |
| P05P02A/m17a0301 | 312 | `WaitSe` | GAME:WaitFrames approximatif |
| P05P02A/m17a0301 | 320 | `WaitSe` | GAME:WaitFrames approximatif |
| P05P03A/m17a0302 | 0 | `sound_Stop` | idem |
| P05P03A/m17a0302 | 5 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P03A/m17a0302 | 16 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 38 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 56 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P03A/m17a0302 | 68 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 89 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 110 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 135 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P03A/m17a0302 | 147 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 154 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 158 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 165 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 178 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 190 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 209 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 217 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 234 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 255 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P03A/m17a0302 | 368 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 375 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 394 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 427 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 434 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 441 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 456 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 753 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P05P03A/m17a0302 | 772 | `se_Stop` | pas d'arrêt SE direct PMDO (StopBGM ne couvre pas les SE) |
| P05P03A/m17a0302 | 1227 | `se_FadeOut` | idem |
| P05P03A/m17a0302 | 1381 | `WaitSe` | GAME:WaitFrames approximatif |
| P05P03A/m26a06d3 | 13 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P03A/m26a06d3 | 133 | `se_FadeOut` | idem |
| P05P04A/m17a0401 | 0 | `sound_Stop` | idem |
| P05P04A/m17a0401 | 75 | `se_FadeOut` | idem |
| P05P04A/m17a0401 | 76 | `WaitSe` | GAME:WaitFrames approximatif |
| P05P04A/m17a0401 | 83 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P04A/m17a0403 | 5 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P05P04A/m17a0403 | 82 | `WaitBgm` | GAME:WaitFrames approximatif |
| P06P01A/m18a0401 | 0 | `sound_Stop` | idem |
| P06P01A/m18a0401 | 5 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P06P01A/m18a0401 | 639 | `WaitBgm` | GAME:WaitFrames approximatif |
| P06P01A/m26a0614 | 1 | `back2_SetMode` | sémantique à confirmer |
| P06P01A/m26a0614 | 7 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P07P01A/m18b1401 | 0 | `sound_Stop` | idem |
| P07P01A/m18b1401 | 1 | `back_SetBanner2` | UI:WaitShowTitle(title) approximatif |
| P07P01A/m18b1401 | 6 | `back2_SetMode` | sémantique à confirmer |
| P07P01A/m18b1401 | 10 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P07P01A/m18b1401 | 12 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P07P01A/m18b1401 | 238 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P07P01A/m18b1401 | 278 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P07P01A/m18b1401 | 296 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P07P01A/m18b1401 | 311 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P07P01A/m18b1401 | 331 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P07P01A/m18b1401 | 404 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P07P01A/m18b1401 | 427 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P07P01A/m18b1401 | 530 | `back2_SetMode` | sémantique à confirmer |
| P07P01A/m18b1401 | 531 | `WaitBgm` | GAME:WaitFrames approximatif |
| P07P01A/m26a06e6 | 1 | `back2_SetMode` | sémantique à confirmer |
| P07P01A/m26a06e6 | 6 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P07P01A/m26a06e6 | 8 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P08P01A/m19a0601 | 0 | `sound_Stop` | idem |
| P08P01A/m19a0601 | 1 | `back_SetDungeonBanner` | UI:WaitShowTitle approximatif |
| P08P01A/m19a0601 | 9 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P08P01A/m19d0612 | 3 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P08P01A/n08a2308 | 0 | `sound_Stop` | idem |
| P08P01A/n08a2308 | 2 | `back_SetDungeonBanner` | UI:WaitShowTitle approximatif |
| P08P01A/n08a2308 | 10 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P08P01A/n08a2308 | 35 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P08P01A/n08a2308 | 47 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P08P01A/n08a2308 | 106 | `se_FadeOut` | idem |
| P08P01A/n08a2308 | 199 | `WaitSe` | GAME:WaitFrames approximatif |
| P08P01A/n08a2308 | 204 | `Hold` | pas d'équivalent exact : GAME:WaitFrames(1) + var |
| P08P01A/n08a2408 | 0 | `sound_Stop` | idem |
| P08P01A/n08a2408 | 6 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P08P01A/n08a2508 | 0 | `sound_Stop` | idem |
| P08P01A/n08a2508 | 1 | `back_SetDungeonBanner` | UI:WaitShowTitle approximatif |
| P08P01A/n08a2508 | 9 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P08P01A/n08a2508 | 90 | `WaitSe` | GAME:WaitFrames approximatif |
| P08P01A/n08a2508 | 95 | `Hold` | pas d'équivalent exact : GAME:WaitFrames(1) + var |
| P08P01A/n08a2608 | 0 | `sound_Stop` | idem |
| P08P01A/n08a2608 | 4 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P09P01A/m19b1001 | 0 | `sound_Stop` | idem |
| P09P01A/m19b1001 | 10 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P09P01A/m19b1001 | 379 | `WaitSe` | GAME:WaitFrames approximatif |
| P09P01A/m19b1001 | 390 | `WaitSe` | GAME:WaitFrames approximatif |
| P09P01A/m19b1001 | 392 | `message_ImitationSound` | SOUND:PlayBattleSE approximatif |
| P09P01A/m19b1001 | 393 | `WaitSe` | GAME:WaitFrames approximatif |
| P09P01A/m19b1001 | 395 | `back2_SetMode` | sémantique à confirmer |
| P09P01A/m19b1001 | 397 | `back2_SetEffect` | idem |
| P09P01A/m19b1001 | 398 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1001 | 402 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1001 | 404 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1001 | 406 | `WaitSe` | GAME:WaitFrames approximatif |
| P09P01A/m19b1001 | 410 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1001 | 421 | `camera2_SetEffect` | idem approximatif |
| P09P01A/m19b1001 | 425 | `message_ImitationSound` | SOUND:PlayBattleSE approximatif |
| P09P01A/m19b1001 | 429 | `camera2_SetEffect` | idem approximatif |
| P09P01A/m19b1007 | 4 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P09P01A/m19b1007 | 35 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P09P01A/m19b1007 | 121 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P09P01A/m19b1007 | 202 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P09P01A/m19b1007 | 263 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P09P01A/m19b1007 | 310 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P09P01A/m19b1007 | 344 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P09P01A/m19b1007 | 378 | `WaitSe` | GAME:WaitFrames approximatif |
| P09P01A/m19b1007 | 441 | `back2_SetMode` | sémantique à confirmer |
| P09P01A/m19b1007 | 443 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 457 | `camera2_SetEffect` | idem approximatif |
| P09P01A/m19b1007 | 461 | `message_ImitationSound` | SOUND:PlayBattleSE approximatif |
| P09P01A/m19b1007 | 462 | `WaitSe` | GAME:WaitFrames approximatif |
| P09P01A/m19b1007 | 465 | `camera2_SetEffect` | idem approximatif |
| P09P01A/m19b1007 | 468 | `back2_SetEffect` | idem |
| P09P01A/m19b1007 | 469 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 472 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 474 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 476 | `se_FadeOut` | idem |
| P09P01A/m19b1007 | 479 | `back2_SetEffect` | idem |
| P09P01A/m19b1007 | 480 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 489 | `back2_SetEffect` | idem |
| P09P01A/m19b1007 | 491 | `WaitSe` | GAME:WaitFrames approximatif |
| P09P01A/m19b1007 | 495 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 500 | `SetOutputAttribute` | sémantique à confirmer — approximatif |
| P09P01A/m19b1007 | 511 | `camera2_SetEffect` | idem approximatif |
| P09P01A/m19b1007 | 515 | `message_ImitationSound` | SOUND:PlayBattleSE approximatif |
| P09P01A/m19b1007 | 520 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 522 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 524 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 526 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 528 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 530 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 532 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 534 | `camera2_SetPositionMark` | équivalent overlay/parallaxe approximatif |
| P09P01A/m19b1007 | 538 | `camera2_SetEffect` | idem approximatif |
| P09P01A/m19b1009 | 0 | `sound_Stop` | idem |
| P09P01A/m19b1009 | 4 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P09P01A/m19b1009 | 196 | `WaitSe` | GAME:WaitFrames approximatif |
| P09P01A/m19b1009 | 209 | `WaitSe` | GAME:WaitFrames approximatif |
| P09P01A/m19b1009 | 237 | `WaitBgm` | GAME:WaitFrames approximatif |
| P09P01A/m19d1072 | 3 | `camera_SetMyself` | focus caméra PMDO si exposé ; sinon défaut (suit le héros) |
| P09P01A/m19d1072 | 25 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
| P09P01A/m19d1072 | 105 | `message_FacePositionOffset` | UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose) |
