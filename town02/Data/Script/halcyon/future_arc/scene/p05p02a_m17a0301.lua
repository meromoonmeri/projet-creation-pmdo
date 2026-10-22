--[[
    P05P02A_m17a0301.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P02A/m17a0301.ssb
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

local m17a0301 = {}

function m17a0301.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        GAME:FadeOut(false, 30)
        -- back_SetGround(P05P02A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('Hmm...') -- FUT_M17A0301_001 (FR)
        -- case 0: ' Hmm...'
        -- case 1: ' Hmm...'
        UI:WaitShowDialogue('Comment en sommes-nous arrivés là ?') -- FUT_M17A0301_002 (FR)
        -- case 3: ' How did we end up this way?'
        -- case 4: ' How did we end up this way?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        GAME:WaitFrames(30)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Je pense que...[br]Noctunoir nous a attrapés...') -- FUT_M17A0301_003 (FR)
        UI:SetCenter(false)
        -- case 6: ' I think what happened was...[K]\n[CS:N]Dusknoir[CR] grabbed us...'
        -- case 7: ' I think what happened was...[K]\n[CS:N]Dusknoir[CR] grabbed us...'
        UI:SetCenter(true)
        UI:WaitShowDialogue('Puis il nous a traînés dans le trou dimensionnel...') -- FUT_M17A0301_004 (FR)
        UI:SetCenter(false)
        -- case 9: ' Then he dragged us into the\ndimensional hole...'
        -- case 10: ' Then he dragged us into the\ndimensional hole...'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO SE 8974 (SE_NUM_EVENT_MOTION_JUNP_01)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Hein ? Attends, alors c\'est peut-être...') -- FUT_M17A0301_005 (FR)
        -- case 12: ' Huh?![K] Wait, so is this maybe...'
        -- case 13: ' What?![K] Wait, so is this maybe...'
        UI:WaitShowDialogue('C\'est... l\'avenir ?!') -- FUT_M17A0301_006 (FR)
        -- case 15: ' Is this...[K]the future?!'
        -- case 16: ' Is this...[K]the future?!'
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(20)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GAME:WaitFrames(10)
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue('Mais... c\'est impossible !') -- FUT_M17A0301_007 (FR)
        UI:SetCenter(false)
        -- case 18: " But that's...![K] I don't\nbelieve this!"
        -- case 19: " But that's...![K] I can't\nbelieve this!"
        UI:SetCenter(true)
        UI:WaitShowDialogue('Je veux dire... on est vraiment dans le futur ?!') -- FUT_M17A0301_008 (FR)
        UI:SetCenter(false)
        -- case 21: ' I mean, this is the future?!'
        -- case 22: ' I mean, this is the future?!'
        UI:SetCenter(true)
        UI:WaitShowDialogue('Pourquoi on est là ?') -- FUT_M17A0301_009 (FR)
        UI:SetCenter(false)
        -- case 24: ' Why are we even here?'
        -- case 25: ' Why are we even here?'
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(20)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GAME:WaitFrames(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Argh... Mais...') -- FUT_M17A0301_010 (FR)
        -- case 27: ' Ugh...but...'
        -- case 28: ' Ugh...but...'
        UI:WaitShowDialogue('Toute cette salle est construite d\'une manière que je n\'ai encore jamais vue !') -- FUT_M17A0301_011 (FR)
        -- case 30: " This whole room is built in a\nway unlike anything I've ever seen!"
        -- case 31: " This whole room is constructed\nin a way unlike anything I've ever seen!"
        UI:WaitShowDialogue('Maintenant que j\'y pense... Peut-être que nous sommes...') -- FUT_M17A0301_012 (FR)
        -- case 33: " Now that I've had time to\nthink...[K] Maybe this actually is..."
        -- case 34: " Now that I've had time to\ndigest this...[K] Maybe this actually is..."
        UI:WaitShowDialogue('L\'avenir !') -- FUT_M17A0301_013 (FR)
        -- case 36: ' The future!'
        -- case 37: ' The future!'
        UI:WaitShowDialogue('...............') -- FUT_M17A0301_014 (FR)
        -- case 39: ' ........................'
        -- case 40: ' ........................'
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- ExecuteCommon(LOOK_AROUND_FAST_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Waah ! [hero] !') -- FUT_M17A0301_015 (FR)
        -- case 42: ' Waah! [hero]!'
        -- case 43: ' Waah! [hero]!'
        UI:WaitShowDialogue('Est-ce qu\'on a vraiment fini dans le futur ?!') -- FUT_M17A0301_016 (FR)
        -- case 45: ' Did we really end up in the\nfuture?!'
        -- case 46: ' Did we really end up in the\nfuture?!'
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Argh... Qu\'est-ce qu\'on va faire, maintenant ?') -- FUT_M17A0301_017 (FR)
        -- case 48: ' Ugh, now what are we supposed\nto do?'
        -- case 49: ' Ugh, now what should we do?'
        UI:WaitShowDialogue('Donc, si...') -- FUT_M17A0301_018 (FR)
        -- case 51: ' So, if...'
        -- case 52: ' So, if...'
        UI:WaitShowDialogue('Si cet endroit est le futur...') -- FUT_M17A0301_019 (FR)
        -- case 54: ' If this place is the future...'
        -- case 55: ' If this place is the future...'
        UI:WaitShowDialogue('Comment allons-nous rentrer dans notre monde ?') -- FUT_M17A0301_020 (FR)
        -- case 57: ' How are we supposed to get\nback to our world?'
        -- case 58: ' How are we supposed to get\nback to our world?'
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO SE 7187 (SE_NUM_EVENT_MAIN17_DOOR)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        GAME:WaitFrames(20)
        -- Transition neutralisée : FutureArc possède le routage. Source : GAME:EnterGroundMap('p05p02a', 'Main_Entrance_Marker') -- transition P05P02A2
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        GAME:WaitFrames(50)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
            end),
        })
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
            end),
        })
        GAME:WaitFrames(30)
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(1)
        GROUND:MoveToPosition(CH('Sableye_1'), 252, 200, false, 2.0)
        GAME:WaitFrames(10)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 252, 220, false, 3.0)
        GROUND:CharSetAnim(CH('Teammate1'), 'Walk', true) -- param 5 = anim 0 (Walk)
        GROUND:AnimateToPosition(CH('Teammate1'), 236, 228, false, 3.0)
        GAME:WaitFrames(5)
        GROUND:CharSetAnim(CH('PLAYER'), 'Walk', true) -- param 5 = anim 0 (Walk)
        GROUND:AnimateToPosition(CH('PLAYER'), 268, 228, false, 3.0)
        GAME:WaitFrames(5)
        -- supervision_cting layer [2] (structurel)
        GAME:WaitFrames(1)
        GROUND:MoveToPosition(CH('Sableye_2'), 252, 184, false, 2.0)
        GAME:WaitFrames(10)
        -- SetAnimation 2 (spécial : boucle anim courante)
        -- supervision_cting layer [3] (structurel)
        GAME:WaitFrames(1)
        GROUND:MoveToPosition(CH('Sableye_3'), 228, 184, false, 2.0)
        GAME:WaitFrames(10)
        -- SetAnimation 2 (spécial : boucle anim courante)
        -- supervision_cting layer [4] (structurel)
        GAME:WaitFrames(1)
        -- (parallèle) NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), 276, 184, false, 2.0)
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Down, 15)
            end),
        })
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8973 (SE_NUM_EVENT_SIGN_SHOCK_03)
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7188') end) -- TODO SE 7188 (SE_NUM_EVENT_MAIN17_YAMIRAMI_01)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_4')) end)
            end),
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBGM('Growing Anxiety.ogg', true) end) -- OhNo
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ils sont réveillés. Comme c\'est pratique.') -- FUT_M17A0301_021 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Très bien. Finissons-en vite.') -- FUT_M17A0301_022 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Vite ? Mais qu\'est-ce que vous allez faire ?!') -- FUT_M17A0301_023 (FR)
        -- case 62: ' Do this quick? Do what?!'
        -- case 63: ' Do this quick? Do what?!'
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_1'), 252, 236, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), 252, 204, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), 220, 220, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), 284, 220, false, 3.0)
            end),
        })
        GAME:WaitFrames(10)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
            end),
        })
        -- ExecuteCommon(LOOK_AROUND_FAST_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LOOK_AROUND_FAST_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.DownRight, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.DownLeft, 15)
            end),
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7189') end) -- TODO SE 7189 (SE_NUM_EVENT_MAIN17_MEKAKUSHI)
        GAME:FadeOut(false, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(Quoi ?!)') -- FUT_M17A0301_024 (FR)
        -- case 65: '(Wh-what?!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Waah ! Ils m\'ont bandé les yeux ! Je ne vois plus rien !') -- FUT_M17A0301_025 (FR)
        -- case 67: " Waah! They have me\nblindfolded![K] I can't see!"
        -- case 68: " Waah! They blindfolded me![K]\nI can't see a thing!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Viens avec nous.') -- FUT_M17A0301_026 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Aïe ! Arrêtez de me pousser !') -- FUT_M17A0301_027 (FR)
        -- case 71: ' Ow! Quit shoving!'
        -- case 72: " Ow! Don't shove me!"
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO SE 7187 (SE_NUM_EVENT_MAIN17_DOOR)
        -- PARTIEL : WaitSe [7187]
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Argh... Avec ce bandeau, impossible de savoir où je vais...') -- FUT_M17A0301_028 (FR)
        -- case 74: " Ugh...[K] This blindfold makes it\nimpossible to tell where I'm going..."
        -- case 75: " Ugh...[K] This blindfold makes it\nimpossible to tell where I'm going..."
        UI:WaitShowDialogue('Où nous emmènent-ils ?') -- FUT_M17A0301_029 (FR)
        -- case 77: ' Where are they taking us?'
        -- case 78: ' But where are they taking us?'
        UI:ResetSpeaker()
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO SE 7187 (SE_NUM_EVENT_MAIN17_DOOR)
        -- PARTIEL : WaitSe [7187]
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Nous y sommes.') -- FUT_M17A0301_030 (FR)
        UI:ResetSpeaker()
        -- Transition neutralisée : FutureArc possède le routage. Source : GAME:EnterGroundMap('s04p01a', 'Main_Entrance_Marker') -- transition S04P01A
        GAME:FadeIn(0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7189') end) -- TODO SE 7189 (SE_NUM_EVENT_MAIN17_MEKAKUSHI)
        GAME:FadeOut(true, 30)
        -- PARTIEL : WaitSe [7189]
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m17a0301] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m17a0301
