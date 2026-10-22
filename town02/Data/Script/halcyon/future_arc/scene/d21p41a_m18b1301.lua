--[[
    D21P41A_m18b1301.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D21P41A/m18b1301.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Chorégraphie 1:1 (déplacements, positions, timings, animations, caméra,
    fades, SFX, BGM, transitions, flags, embranchements). Seul le CAST change :
    Dusknoir/Grovyle (alliés), Sableye (sbires de Necrozma), Celebi, héros/
    partenaire ; le maître du futur = Necrozma (Dialga absent). Les dialogues
    canoniques sont joués (cast appliqué), la clé FUT_* en commentaire sert
    d'éventuelle passe FR. Les tables anim/SE/effets manquantes sont marquées
    TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'
require 'halcyon.future_arc.FutureScene'

local m18b1301 = {}

function m18b1301.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- back_SetGround(D21P41A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GROUND:CharSetAnim(CH('Grovyle'), 'Float', false) -- param 29 = anim 20 (Float)
        -- SetOutputAttribute [2] : PARTIEL
        -- object 61 (d21p41a1) : contexte objet
        FutureScene.ObjectSetAnim('d21p41a1', 1, 0, 3, Direction.Down, 1) -- objet 61, anim 1 (table REQUISE)
        -- SetAnimation 44 : NON CONVERTI (param absent de la table officielle)
        -- bgm_PlayFadeIn [112, 30, 256] : BGM StaticNoise non mappé
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Spiritomb'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('AAARGH... OOOOH... ARRGH !') -- FUT_M18B1301_001 (FR)
        UI:WaitShowDialogue('OOOOH... ARRGH !... GWAAAAAAH !') -- FUT_M18B1301_002 (FR)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 5143 (SE_NUM_EVENT_EFF_FLASH_HEAVY)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        GAME:WaitFrames(10)
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 5143 (SE_NUM_EVENT_EFF_FLASH_HEAVY)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        -- PARTIEL : WaitSe [5143]
        -- NON CONVERTI : bgm2_PlayFadeIn (un seul canal BGM dans PMDO)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        GAME:WaitFrames(30)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Ouah ! Qu-qu\'est-ce qui se passe ?') -- FUT_M18B1301_003 (FR)
        -- case 2: " Whoa! Wh-what's happening?"
        -- case 3: " Waah! Wh-what's happening?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Spiritomb'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('UGWAAAAAAAAAAH ![br]GAAAAAAAAH !') -- FUT_M18B1301_004 (FR)
        UI:ResetSpeaker()
        -- NON CONVERTI : bgm2_FadeOut (un seul canal BGM dans PMDO)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7429') end) -- TODO SE 7429 (None)
        -- SetAnimation 25 : NON CONVERTI (param absent de la table officielle)
        pcall(function() GROUND:CharWaitAnim(CH('Spiritomb')) end)
        -- SetAnimation 26 : NON CONVERTI (param absent de la table officielle)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        GAME:WaitFrames(60)
        -- MoveHeight [2, 8] : LocHeight (table alt. REQUISE)
        GAME:WaitFrames(1)
        -- MoveHeight [2, 0] : LocHeight (table alt. REQUISE)
UI:SetSpeaker(CH('Spiritomb'))
        UI:WaitShowDialogue('Eeep !') -- FUT_M18B1301_005 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7428') end) -- TODO SE 7428 (None)
        -- object 61 (d21p41a1) : contexte objet
        FutureScene.ObjectSetAnim('d21p41a1', 18, 0, 3, Direction.Down, 1) -- objet 61, anim 18 (table REQUISE)
        -- object 61 (d21p41a1) : contexte objet
        -- WaitAnimation sur objet d21p41a1 : PARTIEL
        -- object 61 (d21p41a1) : contexte objet
        FutureScene.ObjectSetAnim('d21p41a1', 19, 0, 3, Direction.Down, 1) -- objet 61, anim 19 (table REQUISE)
        -- object 61 (d21p41a1) : contexte objet
        -- NON CONVERTI : Slide2PositionMark [32972, 2, 2, 40, 28]
        -- object 61 (d21p41a1) : contexte objet
        pcall(function() GROUND:Hide(CH('Spiritomb').EntName) end)
        -- PARTIEL : WaitSe [7428]
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8963') end) -- TODO SE 8963 (SE_NUM_EVENT_SIGN_HATENA_03)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        -- MoveHeight [2, 8] : LocHeight (table alt. REQUISE)
        GAME:WaitFrames(1)
        -- MoveHeight [2, 0] : LocHeight (table alt. REQUISE)
UI:SetSpeaker(CH('Spiritomb'))
        UI:WaitShowDialogue('Eeep !') -- FUT_M18B1301_006 (FR)
        UI:WaitShowDialogue('F-f-fuyons !') -- FUT_M18B1301_007 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7447') end) -- TODO SE 7447 (None)
        -- (parallèle) NPC_MIKARUGE, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 47 : NON CONVERTI (param absent de la table officielle)
                -- SetAnimation 1024 : NON CONVERTI (param absent de la table officielle)
                GROUND:MoveToPosition(CH('Spiritomb'), 136, 228, false, 5.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
            end),
        })
        GAME:WaitFrames(5)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpLeft, 15)
        pcall(function() GROUND:Hide(CH('Spiritomb').EntName) end)
        GAME:WaitFrames(30)
        -- PARTIEL : WaitSe [7447]
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8961') end) -- TODO SE 8961 (SE_NUM_EVENT_SIGN_ASE_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Qu-qu\'est-ce que c\'était... ?[br]Que s\'est-il passé ?') -- FUT_M18B1301_008 (FR)
        -- case 9: ' Wh-what was that...?[K]\nWhat was all that about?'
        -- case 10: ' Wh-what was that...?[K]\nWhat was all that about?'
        UI:ResetSpeaker()
        GROUND:AnimateToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + -1*8, false, 2.0)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Ils ont pris peur et se sont enfuis.') -- FUT_M18B1301_009 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpRight, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
            end),
        })
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Massko !') -- FUT_M18B1301_010 (FR)
        -- case 13: ' [CS:N]Grovyle[CR]!'
        -- case 14: ' [CS:N]Grovyle[CR]!'
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 372, 192, false, 2.0)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), 336, 172, false, 2.0)
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), 372, 196, false, 2.0)
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Ça va ?') -- FUT_M18B1301_011 (FR)
        -- case 16: ' Are you all right?'
        -- case 17: ' Are you all right?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Ouais... Ça va aller...') -- FUT_M18B1301_012 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Tu peux te lever ?') -- FUT_M18B1301_013 (FR)
        -- case 20: ' Can you get up?'
        -- case 21: ' Can you get up?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('D\'une manière ou d\'une autre... Argh !') -- FUT_M18B1301_014 (FR)
        UI:ResetSpeaker()
        -- SetAnimation 31 : NON CONVERTI (param absent de la table officielle)
        pcall(function() GROUND:CharWaitAnim(CH('Grovyle')) end)
        -- SetAnimation 2 (spécial : boucle anim courante)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ce Pokémon... Il était rusé.') -- FUT_M18B1301_015 (FR)
        UI:WaitShowDialogue('Il s\'est introduit dans mon corps par le nez et en a pris le contrôle...') -- FUT_M18B1301_016 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Alors c\'était un mauvais Pokémon.') -- FUT_M18B1301_017 (FR)
        -- case 26: ' So that was a bad Pokémon.'
        -- case 27: ' So that was a bad Pokémon.'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('Time Gear Remix.ogg', true) end) -- TimeGearRemix
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Non. Ce n\'est pas vrai.') -- FUT_M18B1301_018 (FR)
        UI:WaitShowDialogue('Ce Spiritomb était probablement furieux que nous ayons pénétré sur son territoire.') -- FUT_M18B1301_019 (FR)
        UI:WaitShowDialogue('Il faisait peur... parce que sa colère lui avait fait perdre tout contrôle.') -- FUT_M18B1301_020 (FR)
        UI:WaitShowDialogue('Mais vous avez vu ce qui s\'est passé quand la situation a mal tourné : il s\'est enfui.') -- FUT_M18B1301_021 (FR)
        UI:WaitShowDialogue('C\'est normalement un Pokémon timide.') -- FUT_M18B1301_022 (FR)
        UI:WaitShowDialogue('Il existe beaucoup de Pokémon de ce genre dans votre avenir.') -- FUT_M18B1301_023 (FR)
        UI:WaitShowDialogue('Des Pokémon qui devraient être bons...') -- FUT_M18B1301_024 (FR)
        UI:WaitShowDialogue('Mais les ténèbres perpétuelles de ce monde les ont rendus amers et malfaisants.') -- FUT_M18B1301_025 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Je vois...') -- FUT_M18B1301_026 (FR)
        -- case 37: ' I see...'
        -- case 38: ' I see...'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('De bons Pokémon qui deviennent mauvais à cause de ce monde...') -- FUT_M18B1301_027 (FR)
        -- case 40: ' Good Pokémon going bad because\nof this world...'
        -- case 41: ' Good Pokémon going bad because\nof this world...'
        UI:WaitShowDialogue('Ça me rend triste.') -- FUT_M18B1301_028 (FR)
        -- case 43: ' That makes me sad.'
        -- case 44: ' That makes me sad.'
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hé ! Vous deux !') -- FUT_M18B1301_029 (FR)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        UI:SetCenter(true)
        UI:WaitShowDialogue('Alors, allez-vous enfin me faire confiance ?') -- FUT_M18B1301_030 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('Un peu ?') -- FUT_M18B1301_031 (FR)
        -- case 48: ' Ummm...[K]somewhat?'
        -- case 49: ' Ummm...[K]somewhat?'
        UI:WaitShowDialogue('Pour être honnête, je ne te fais pas vraiment confiance, mais...') -- FUT_M18B1301_032 (FR)
        -- case 51: " To be honest, I don't really trust\nyou, but..."
        -- case 52: " I'll admit it. I don't really trust\nyou, but..."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Humph ! Je te l\'ai déjà dit.') -- FUT_M18B1301_033 (FR)
        UI:WaitShowDialogue('Il n\'y a aucune raison de continuer ensemble s\'il n\'y a pas de confiance entre nous.') -- FUT_M18B1301_034 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Je m\'en vais.') -- FUT_M18B1301_035 (FR)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 0.5*8, CH('Grovyle').Position.Y + 32*8, false, 1.0)
        GAME:WaitFrames(15)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownRight, 15)
        GAME:WaitFrames(15)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Attends !') -- FUT_M18B1301_036 (FR)
        -- case 57: ' Oh, wait!'
        -- case 58: ' Oh, wait!'
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue('Je n\'ai pas dit que je ne te croyais pas !') -- FUT_M18B1301_037 (FR)
        UI:SetCenter(false)
        -- case 60: " I didn't say I don't believe you!"
        -- case 61: " I didn't say I don't believe you!"
        UI:SetCenter(true)
        UI:WaitShowDialogue('Pour être honnête...') -- FUT_M18B1301_038 (FR)
        UI:SetCenter(false)
        -- case 63: ' To be perfectly honest...'
        -- case 64: ' To be perfectly honest...'
        UI:SetCenter(true)
        UI:WaitShowDialogue('Nous ne savons plus quoi penser.') -- FUT_M18B1301_039 (FR)
        UI:SetCenter(false)
        -- case 66: " We don't know what's what\nanymore."
        -- case 67: " We don't know what's what\nanymore."
        UI:SetCenter(true)
        UI:WaitShowDialogue('C\'est pourquoi nous voulons en apprendre le plus possible.') -- FUT_M18B1301_040 (FR)
        UI:SetCenter(false)
        -- case 69: " That's why we want to know as\nmuch as we can learn."
        -- case 70: " That's why we want to know as\nmuch as we can learn."
        UI:SetCenter(true)
        UI:WaitShowDialogue('Et...') -- FUT_M18B1301_041 (FR)
        UI:SetCenter(false)
        -- case 72: ' And...'
        -- case 73: ' And...'
        UI:SetCenter(true)
        UI:WaitShowDialogue('Oui, je ne te fais toujours pas entièrement confiance, Massko, mais...') -- FUT_M18B1301_042 (FR)
        UI:SetCenter(false)
        -- case 75: " Yeah, I still don't completely\ntrust you, [CS:N]Grovyle[CR], but..."
        -- case 76: " It's true I still don't completely\ntrust you, [CS:N]Grovyle[CR], but..."
        UI:SetCenter(true)
        UI:WaitShowDialogue('Mais ce que tu as dit se tient...') -- FUT_M18B1301_043 (FR)
        UI:SetCenter(false)
        -- case 78: ' But what you said does make\nsome sense...'
        -- case 79: ' But what you said does make\nsome sense...'
        UI:SetCenter(true)
        UI:WaitShowDialogue('Ça semble logique.') -- FUT_M18B1301_044 (FR)
        UI:SetCenter(false)
        -- case 81: ' It just seems to be logical.'
        -- case 82: ' It just seems to be logical.'
        UI:SetCenter(true)
        UI:WaitShowDialogue('Alors, s\'il te plaît... Massko, dis-nous ce que tu sais.') -- FUT_M18B1301_045 (FR)
        UI:SetCenter(false)
        -- case 84: ' So, please?[K] [CS:N]Grovyle[CR], please tell\nus what you know.'
        -- case 85: ' So, please?[K] [CS:N]Grovyle[CR], please tell\nus what you know.'
        UI:SetCenter(true)
        UI:WaitShowDialogue('Parle-nous de ce futur...') -- FUT_M18B1301_046 (FR)
        UI:SetCenter(false)
        -- case 87: ' Tell us about this future...'
        -- case 88: ' Tell us about this future...'
        UI:SetCenter(true)
        UI:WaitShowDialogue('et pourquoi tu es venu dans notre monde, Massko !') -- FUT_M18B1301_047 (FR)
        UI:SetCenter(false)
        -- case 90: ' and why you came to our world,\n[CS:N]Grovyle[CR]!'
        -- case 91: ' and why you came to our world,\n[CS:N]Grovyle[CR]!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.UpLeft, 15)
        GAME:WaitFrames(10)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Et si tout ce que je vous raconte n\'était qu\'un tissu de mensonges ?') -- FUT_M18B1301_048 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ce n\'est pas grave. Je ne prendrai pas immédiatement tout ce que tu diras pour la vérité.') -- FUT_M18B1301_049 (FR)
        -- case 94: " It's all right.[K] I won't accept\neverything you say as the truth right away."
        -- case 95: " It's all right.[K] I won't accept\neverything you say at face value right away."
        UI:WaitShowDialogue('Je vais écouter, puis décider.') -- FUT_M18B1301_050 (FR)
        -- case 97: " I'll listen, then decide."
        -- case 98: " I'll listen, then decide."
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(120)
        -- WaitBgm : PARTIEL
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Bon... très bien. Suivez-moi.') -- FUT_M18B1301_051 (FR)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 456, 244, false, 1.594)
        GAME:WaitFrames(30)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 0.7969*8, CH('PLAYER').Position.Y + 48*8, false, 1.594)
                GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 0.7969*8, CH('PLAYER').Position.Y + 80*8, false, 1.594)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 0.7969*8, CH('Teammate1').Position.Y + 64*8, false, 1.594)
                GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 0.7969*8, CH('Teammate1').Position.Y + 80*8, false, 1.594)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 0.7969*8, CH('Grovyle').Position.Y + 80*8, false, 1.594)
            end),
        })
        GAME:WaitFrames(15)
        GAME:FadeOut(false, 60)
        GAME:WaitFrames(60)
        -- NON CONVERTI : message_Menu [55]
        -- flag_CalcBit(SCENARIO_MAIN_BIT_FLAG, 8, 1) : opérations bit (adaptation)
        SV.Scenario.CompulsorySavePoint = 15 -- flag_Set(COMPULSORY_SAVE_POINT)
        -- HANYOU_SAVE_FUNC : point de sauvegarde obligatoire (à brancher)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m18b1301] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m18b1301
