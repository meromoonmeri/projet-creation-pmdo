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
        UI:WaitShowDialogue(' Hmm...') -- FUT_M17A0301_001 (FR optionnel)
        -- case 0: ' Hmm...'
        -- case 1: ' Hmm...'
        UI:WaitShowDialogue(' How did we end up this way?') -- FUT_M17A0301_002 (FR optionnel)
        -- case 3: ' How did we end up this way?'
        -- case 4: ' How did we end up this way?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        GAME:WaitFrames(30)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I think what happened was...\n\nDusknoir grabbed us...') -- FUT_M17A0301_003 (FR optionnel)
        UI:SetCenter(false)
        -- case 6: ' I think what happened was...[K]\n[CS:N]Dusknoir[CR] grabbed us...'
        -- case 7: ' I think what happened was...[K]\n[CS:N]Dusknoir[CR] grabbed us...'
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Then he dragged us into the\ndimensional hole...') -- FUT_M17A0301_004 (FR optionnel)
        UI:SetCenter(false)
        -- case 9: ' Then he dragged us into the\ndimensional hole...'
        -- case 10: ' Then he dragged us into the\ndimensional hole...'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Huh?!\n Wait, so is this maybe...') -- FUT_M17A0301_005 (FR optionnel)
        -- case 12: ' Huh?![K] Wait, so is this maybe...'
        -- case 13: ' What?![K] Wait, so is this maybe...'
        UI:WaitShowDialogue(' Is this...\nthe future?!') -- FUT_M17A0301_006 (FR optionnel)
        -- case 15: ' Is this...[K]the future?!'
        -- case 16: ' Is this...[K]the future?!'
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(20)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GAME:WaitFrames(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(' But that\'s...!\n I don\'t\nbelieve this!') -- FUT_M17A0301_007 (FR optionnel)
        UI:SetCenter(false)
        -- case 18: " But that's...![K] I don't\nbelieve this!"
        -- case 19: " But that's...![K] I can't\nbelieve this!"
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I mean, this is the future?!') -- FUT_M17A0301_008 (FR optionnel)
        UI:SetCenter(false)
        -- case 21: ' I mean, this is the future?!'
        -- case 22: ' I mean, this is the future?!'
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Why are we even here?') -- FUT_M17A0301_009 (FR optionnel)
        UI:SetCenter(false)
        -- case 24: ' Why are we even here?'
        -- case 25: ' Why are we even here?'
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(20)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GAME:WaitFrames(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Ugh...but...') -- FUT_M17A0301_010 (FR optionnel)
        -- case 27: ' Ugh...but...'
        -- case 28: ' Ugh...but...'
        UI:WaitShowDialogue(' This whole room is built in a\nway unlike anything I\'ve ever seen!') -- FUT_M17A0301_011 (FR optionnel)
        -- case 30: " This whole room is built in a\nway unlike anything I've ever seen!"
        -- case 31: " This whole room is constructed\nin a way unlike anything I've ever seen!"
        UI:WaitShowDialogue(' Now that I\'ve had time to\nthink...\n Maybe this actually is...') -- FUT_M17A0301_012 (FR optionnel)
        -- case 33: " Now that I've had time to\nthink...[K] Maybe this actually is..."
        -- case 34: " Now that I've had time to\ndigest this...[K] Maybe this actually is..."
        UI:WaitShowDialogue(' The future!') -- FUT_M17A0301_013 (FR optionnel)
        -- case 36: ' The future!'
        -- case 37: ' The future!'
        UI:WaitShowDialogue(' ........................') -- FUT_M17A0301_014 (FR optionnel)
        -- case 39: ' ........................'
        -- case 40: ' ........................'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- ExecuteCommon(LOOK_AROUND_FAST_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Waah! [hero]!') -- FUT_M17A0301_015 (FR optionnel)
        -- case 42: ' Waah! [hero]!'
        -- case 43: ' Waah! [hero]!'
        UI:WaitShowDialogue(' Did we really end up in the\nfuture?!') -- FUT_M17A0301_016 (FR optionnel)
        -- case 45: ' Did we really end up in the\nfuture?!'
        -- case 46: ' Did we really end up in the\nfuture?!'
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Ugh, now what are we supposed\nto do?') -- FUT_M17A0301_017 (FR optionnel)
        -- case 48: ' Ugh, now what are we supposed\nto do?'
        -- case 49: ' Ugh, now what should we do?'
        UI:WaitShowDialogue(' So, if...') -- FUT_M17A0301_018 (FR optionnel)
        -- case 51: ' So, if...'
        -- case 52: ' So, if...'
        UI:WaitShowDialogue(' If this place is the future...') -- FUT_M17A0301_019 (FR optionnel)
        -- case 54: ' If this place is the future...'
        -- case 55: ' If this place is the future...'
        UI:WaitShowDialogue(' How are we supposed to get\nback to our world?') -- FUT_M17A0301_020 (FR optionnel)
        -- case 57: ' How are we supposed to get\nback to our world?'
        -- case 58: ' How are we supposed to get\nback to our world?'
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO table SE id 7187
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        GAME:WaitFrames(20)
        GAME:EnterGroundMap('p05p02a', 'Main_Entrance_Marker') -- transition P05P02A2
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        GAME:WaitFrames(50)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
            end,
        })
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
            end,
        })
        GAME:WaitFrames(30)
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(1)
        GROUND:MoveToPosition(CH('Sableye_1'), 252, 200, false, 2.0)
        GAME:WaitFrames(10)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 252, 220, false, 3.0)
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('Teammate1'), 236, 228, false, 3.0)
        GAME:WaitFrames(5)
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('PLAYER'), 268, 228, false, 3.0)
        GAME:WaitFrames(5)
        -- supervision_cting layer [2] (structurel)
        GAME:WaitFrames(1)
        GROUND:MoveToPosition(CH('Sableye_2'), 252, 184, false, 2.0)
        GAME:WaitFrames(10)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        -- supervision_cting layer [3] (structurel)
        GAME:WaitFrames(1)
        GROUND:MoveToPosition(CH('Sableye_3'), 228, 184, false, 2.0)
        GAME:WaitFrames(10)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        -- supervision_cting layer [4] (structurel)
        GAME:WaitFrames(1)
        -- (parallèle) NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), 276, 184, false, 2.0)
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Down, 15)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7188') end) -- TODO table SE id 7188
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_4')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBGM('Oh No!.ogg', true) end) -- OhNo
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' They\'re awake.\n How convenient.') -- FUT_M17A0301_021 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' All right.\n We\'ll do this quick.') -- FUT_M17A0301_022 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Do this quick? Do what?!') -- FUT_M17A0301_023 (FR optionnel)
        -- case 62: ' Do this quick? Do what?!'
        -- case 63: ' Do this quick? Do what?!'
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_1'), 252, 236, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), 252, 204, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), 220, 220, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), 284, 220, false, 3.0)
            end,
        })
        GAME:WaitFrames(10)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
            end,
        })
        -- ExecuteCommon(LOOK_AROUND_FAST_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LOOK_AROUND_FAST_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.DownRight, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.DownLeft, 15)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7189') end) -- TODO table SE id 7189
        GAME:FadeOut(false, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(Wh-what?!)') -- FUT_M17A0301_024 (FR optionnel)
        -- case 65: '(Wh-what?!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Waah! They have me\nblindfolded!\n I can\'t see!') -- FUT_M17A0301_025 (FR optionnel)
        -- case 67: " Waah! They have me\nblindfolded![K] I can't see!"
        -- case 68: " Waah! They blindfolded me![K]\nI can't see a thing!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Come with us.') -- FUT_M17A0301_026 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Ow! Quit shoving!') -- FUT_M17A0301_027 (FR optionnel)
        -- case 71: ' Ow! Quit shoving!'
        -- case 72: " Ow! Don't shove me!"
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO table SE id 7187
        -- PARTIEL : WaitSe [7187]
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Ugh...\n This blindfold makes it\nimpossible to tell where I\'m going...') -- FUT_M17A0301_028 (FR optionnel)
        -- case 74: " Ugh...[K] This blindfold makes it\nimpossible to tell where I'm going..."
        -- case 75: " Ugh...[K] This blindfold makes it\nimpossible to tell where I'm going..."
        UI:WaitShowDialogue(' Where are they taking us?') -- FUT_M17A0301_029 (FR optionnel)
        -- case 77: ' Where are they taking us?'
        -- case 78: ' But where are they taking us?'
        UI:ResetSpeaker()
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO table SE id 7187
        -- PARTIEL : WaitSe [7187]
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' We\'re here.') -- FUT_M17A0301_030 (FR optionnel)
        UI:ResetSpeaker()
        GAME:EnterGroundMap('s04p01a', 'Main_Entrance_Marker') -- transition S04P01A
        GAME:FadeIn(0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7189') end) -- TODO table SE id 7189
        GAME:FadeOut(true, 30)
        -- PARTIEL : WaitSe [7189]
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0301] scène interrompue : '..tostring(err)) end
end

return m17a0301
