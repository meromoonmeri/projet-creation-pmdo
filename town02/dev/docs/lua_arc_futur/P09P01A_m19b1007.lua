--[[
    P09P01A_m19b1007.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P09P01A/m19b1007.ssb
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

local m19b1007 = {}

function m19b1007.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('Hidden Highland.ogg', true) end) -- HiddenHighland
        -- back_SetGround(P09P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- object 141 (p09p01a1) : contexte objet
        local obj_141 = OBJ('p09p01a1') -- objet 141
        GROUND:ObjectSetAnim(obj_141, 1, 0, 3, Direction.Down, 1) -- anim 1 (table REQUISE)
        -- performer 3
        -- SetEffect [640, 3] : performer 3 non mappé (PARTIEL)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' So that [hero] developed\namnesia...') -- FUT_M19B1007_001 (FR optionnel)
        UI:WaitShowDialogue(' and was transformed into a\nPokémon...') -- FUT_M19B1007_002 (FR optionnel)
        UI:WaitShowDialogue(' which must be because of the\naccident during your time travel...') -- FUT_M19B1007_003 (FR optionnel)
        UI:WaitShowDialogue(' Well, [hero]\'s memory\nloss was a lucky stroke for me!') -- FUT_M19B1007_004 (FR optionnel)
        UI:WaitShowDialogue(' After all, your partner failed to\nrecognize who I am.') -- FUT_M19B1007_005 (FR optionnel)
        UI:WaitShowDialogue(' It was quite easy to win over\nyour partner\'s trust.') -- FUT_M19B1007_006 (FR optionnel)
        UI:WaitShowDialogue(' And it was also easy to drag\nthem to the future when the time came!') -- FUT_M19B1007_007 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('TearyEyed')
        UI:WaitShowDialogue(' Urk...\n Necrozma really was lying!') -- FUT_M19B1007_008 (FR optionnel)
        -- case 7: ' Urk...[K] [CS:N]Dusknoir[CR] really was lying!'
        -- case 8: ' Urk...[K] [CS:N]Dusknoir[CR] really was lying!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Which left you, Grovyle...\n\nthe last part of the job to finish.') -- FUT_M19B1007_009 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' .....................') -- FUT_M19B1007_010 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(180)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(I was a human from the future...?)') -- FUT_M19B1007_011 (FR optionnel)
        -- case 12: '(I was a human from the future...?)'
        UI:WaitShowDialogue('(And I was Grovyle\'s partner on a mission to\nprevent the planet\'s paralysis?)') -- FUT_M19B1007_012 (FR optionnel)
        -- case 14: "(And I was [CS:N]Grovyle[CR]'s partner on a mission to\nprevent the planet's paralysis?)"
        UI:WaitShowDialogue('(And that\'s how I ended up in [partner]\'s\nworld?)') -- FUT_M19B1007_013 (FR optionnel)
        -- case 16: "(And that's how I ended up in [partner]'s\nworld?)"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Grovyle and [hero]!\n\nWith the both of you here...') -- FUT_M19B1007_014 (FR optionnel)
        UI:WaitShowDialogue(' Everything will end when we\nfinally dispose of you.') -- FUT_M19B1007_015 (FR optionnel)
        UI:WaitShowDialogue(' That will finally put an end to\nGrovyle\'s glimmer of hope!') -- FUT_M19B1007_016 (FR optionnel)
        UI:WaitShowDialogue(' Everything ends! Everything ends\nfor you!\n Ha-ha-hoo-hoo-ha!') -- FUT_M19B1007_017 (FR optionnel)
        -- SetAnimation id 49 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Necrozma'), 'Idle', true) end) -- placeholder sûr
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(120)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('TearyEyed')
        UI:WaitShowDialogue(' Urgh! Necrozma...\nno...') -- FUT_M19B1007_018 (FR optionnel)
        -- case 22: ' Urgh! [CS:N]Dusknoir[CR]...[K]no...'
        -- case 23: ' Urgh! [CS:N]Dusknoir[CR]...[K]no...'
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Necrozma'), 'Idle', true) end) -- placeholder sûr
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' Necrozma!') -- FUT_M19B1007_019 (FR optionnel)
        -- case 25: ' [CS:N]Dusknoir[CR]!'
        -- case 26: ' [CS:N]Dusknoir[CR]!'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('Planet\'s Paralysis.ogg', true) end) -- PlanetsParalysis
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Ha! Have you finally come to\nterms with your fate?') -- FUT_M19B1007_020 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' G-Grovyle!') -- FUT_M19B1007_021 (FR optionnel)
        -- case 29: ' [CS:N]G-Grovyle[CR]!'
        -- case 30: ' [CS:N]G-Grovyle[CR]!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' [hero]!') -- FUT_M19B1007_022 (FR optionnel)
        UI:SetCenter(false)
        -- case 32: ' [hero]!'
        -- case 33: ' [hero]!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' We shall be rid of you for\nall time!') -- FUT_M19B1007_023 (FR optionnel)
        UI:WaitShowDialogue(' This is the end...\nfor you!') -- FUT_M19B1007_024 (FR optionnel)
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Wheh-heh-heh!') -- FUT_M19B1007_025 (FR optionnel)
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) ATTENDANT1, NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 15)
            end,
        })
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + -8*8, false, 1.0)
        GAME:WaitFrames(15)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 15)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Urk...') -- FUT_M19B1007_026 (FR optionnel)
        -- case 38: ' Urk...'
        -- case 39: ' Urk...'
        UI:WaitShowDialogue(' Hey, [hero]! Grovyle!\n\nYou can\'t give up!') -- FUT_M19B1007_027 (FR optionnel)
        -- case 41: " Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!"
        -- case 42: " Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!"
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Gah...\n You say not to give up...?') -- FUT_M19B1007_028 (FR optionnel)
        UI:WaitShowDialogue(' But what can we possibly do in\nthis bleak situation?') -- FUT_M19B1007_029 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' We have to think!') -- FUT_M19B1007_030 (FR optionnel)
        -- case 46: ' We have to think!'
        -- case 47: ' We have to think!'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) ATTENDANT1, NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + -8*8, false, 1.0)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8965') end) -- TODO table SE id 8965
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' I know!') -- FUT_M19B1007_031 (FR optionnel)
        -- case 49: ' I know!'
        -- case 50: ' I know!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Celebi!\n Can your time travel\nability transport us just the short distance into\nthe Passage of Time?') -- FUT_M19B1007_032 (FR optionnel)
        -- case 52: ' [CS:N]Celebi[CR]![K] Can your time travel\nability transport us just the short distance into\nthe Passage of Time?'
        -- case 53: ' [CS:N]Celebi[CR]![K] Can your time travel\nability transport us just the short distance into\nthe Passage of Time?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Down, 15)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' It won\'t be easy with Necrozma\nhere!') -- FUT_M19B1007_033 (FR optionnel)
        UI:WaitShowDialogue(' Necrozma is the Temporal\nPokémon... It controls time itself!') -- FUT_M19B1007_034 (FR optionnel)
        UI:WaitShowDialogue(' Even if I can make us travel in\ntime, he\'ll have no trouble exposing it!') -- FUT_M19B1007_035 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + -8*8, false, 1.0)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Even a little will do!\n Please!') -- FUT_M19B1007_036 (FR optionnel)
        -- case 58: ' Even a little will do![K] Please!'
        -- case 59: ' It just has to work for an\ninstant![K] Please!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Attack!') -- FUT_M19B1007_037 (FR optionnel)
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Wheh-heh-heh!') -- FUT_M19B1007_038 (FR optionnel)
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Time to travel!') -- FUT_M19B1007_039 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7435') end) -- TODO table SE id 7435
        -- supervision_cting layer [1] (structurel)
        -- SetAnimation id 12 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(2)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 12 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 12 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(2)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 12 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 12 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(2)
        -- SetAnimation id 12 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(4)
        GAME:FadeOut(true, 15)
        pcall(function() GROUND:RemoveCharacter(CH('Grovyle')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Celebi')) end)
        pcall(function() GROUND:RemoveCharacter(CH('PLAYER')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Teammate1')) end)
        -- supervision_emoveActing layer [1] (structurel)
        GAME:WaitFrames(60)
        GAME:FadeIn(15)
        -- PARTIEL : WaitSe [7435]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, NPC_YONOWAARU
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharSetEmote(CH('Sableye_1'), 'shock', 3)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharSetEmote(CH('Sableye_2'), 'shock', 3)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharSetEmote(CH('Sableye_3'), 'shock', 3)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharSetEmote(CH('Sableye_4'), 'shock', 3)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharSetEmote(CH('Sableye_6'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Necrozma'), 'exclaim', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Wheh-heh...?') -- FUT_M19B1007_040 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8963') end) -- TODO table SE id 8963
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(7)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(2)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(3)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(5)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(4)
        -- ExecuteCommon(LOOK_AROUND_DOWN_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' They v-v-\nvanished?') -- FUT_M19B1007_041 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Necrozma'), Direction.Up, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Master Necrozma!') -- FUT_M19B1007_042 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GAME:FadeOut(false, 15)
        GAME:WaitFrames(30)
        -- PARTIEL : back2_SetMode [4]
        -- back2_SetGround(V14P01A) : couche décor (overlay scène, adaptation)
        -- camera2_SetPositionMark [2, 2, 19, 17] : PARTIEL
        -- supervision_cting layer [3] (structurel)
        -- object 265 (v15p01a2) : contexte objet
        local obj_265 = OBJ('v15p01a2') -- objet 265
        GROUND:ObjectSetAnim(obj_265, 1, 0, 3, Direction.Down, 1) -- anim 1 (table REQUISE)
        -- screen2_FadeIn [1, 15] : couche décor (overlay scène, adaptation)
        -- object 265 (v15p01a2) : contexte objet
        local obj_265 = OBJ('v15p01a2') -- objet 265
        GROUND:ObjectSetAnim(obj_265, 20, 0, 3, Direction.Down, 1) -- anim 20 (table REQUISE)
        -- object 265 (v15p01a2) : contexte objet
        -- WaitAnimation sur objet v15p01a2 : PARTIEL
        -- object 265 (v15p01a2) : contexte objet
        local obj_265 = OBJ('v15p01a2') -- objet 265
        GROUND:ObjectSetAnim(obj_265, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        -- object 265 (v15p01a2) : contexte objet
        -- WaitAnimation sur objet v15p01a2 : PARTIEL
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        -- object 265 (v15p01a2) : contexte objet
        local obj_265 = OBJ('v15p01a2') -- objet 265
        GROUND:ObjectSetAnim(obj_265, 3, 0, 3, Direction.Down, 1) -- anim 3 (table REQUISE)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6930') end) -- TODO table SE id 6930
        -- message_ImitationSound : PARTIEL
        -- PARTIEL : WaitSe [6930]
        -- screen2_FadeOut [1, 15] : couche décor (overlay scène, adaptation)
        UI:ResetSpeaker()
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        -- supervision_emoveActing layer [3] (structurel)
        -- back2_SetGround(V14P03A) : couche décor (overlay scène, adaptation)
        -- PARTIEL : back2_SetEffect [7, 0]
        -- camera2_SetPositionMark [2, 2, 19, 18] : PARTIEL
        -- screen2_FadeIn [1, 15] : couche décor (overlay scène, adaptation)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7437') end) -- TODO table SE id 7437
        -- camera2_SetPositionMark [2, 2, 58, 18] : PARTIEL
        GAME:WaitFrames(4)
        -- camera2_SetPositionMark [2, 2, 97, 18] : PARTIEL
        GAME:WaitFrames(180)
        -- PARTIEL : se_FadeOut [7437, 60]
        -- screen2_FadeOut [1, 15] : couche décor (overlay scène, adaptation)
        -- back2_SetGround(V14P04A) : couche décor (overlay scène, adaptation)
        -- PARTIEL : back2_SetEffect [9, 0]
        -- camera2_SetPositionMark [2, 2, 19, 13] : PARTIEL
        -- supervision_cting layer [2] (structurel)
        -- object 268 (v15p01a3) : contexte objet
        local obj_268 = OBJ('v15p01a3') -- objet 268
        GROUND:ObjectSetAnim(obj_268, 9, 0, 3, Direction.Down, 1) -- anim 9 (table REQUISE)
        -- screen2_FadeIn [1, 15] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7448') end) -- TODO table SE id 7448
        -- object 268 (v15p01a3) : contexte objet
        local obj_268 = OBJ('v15p01a3') -- objet 268
        GROUND:ObjectSetAnim(obj_268, 17, 0, 3, Direction.Down, 1) -- anim 17 (table REQUISE)
        -- PARTIEL : back2_SetEffect [7, 60]
        -- PARTIEL : WaitSe [7448]
        -- screen2_FadeOut [1, 15] : couche décor (overlay scène, adaptation)
        -- supervision_emoveActing layer [2] (structurel)
        -- back2_SetGround(V14P01A) : couche décor (overlay scène, adaptation)
        -- camera2_SetPositionMark [2, 2, 19, 17] : PARTIEL
        -- supervision_cting layer [3] (structurel)
        -- object 265 (v15p01a2) : contexte objet
        local obj_265 = OBJ('v15p01a2') -- objet 265
        GROUND:ObjectSetAnim(obj_265, 1, 0, 3, Direction.Down, 1) -- anim 1 (table REQUISE)
        -- object 265 (v15p01a2) : contexte objet
        -- SetOutputAttribute sur objet v15p01a2 : PARTIEL
        -- object 265 (v15p01a2) : contexte objet
        -- NON CONVERTI : SetPositionMark sur objet v15p01a2
        -- screen2_FadeIn [1, 15] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(30)
        -- object 265 (v15p01a2) : contexte objet
        local obj_265 = OBJ('v15p01a2') -- objet 265
        GROUND:ObjectSetAnim(obj_265, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        -- object 265 (v15p01a2) : contexte objet
        -- WaitAnimation sur objet v15p01a2 : PARTIEL
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        -- object 265 (v15p01a2) : contexte objet
        local obj_265 = OBJ('v15p01a2') -- objet 265
        GROUND:ObjectSetAnim(obj_265, 3, 0, 3, Direction.Down, 1) -- anim 3 (table REQUISE)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6930') end) -- TODO table SE id 6930
        -- message_ImitationSound : PARTIEL
        pcall(function() SOUND:PlayBGM('Strong Blast Noise.ogg', true) end) -- StrongBlastNoise
        -- screen2_WhiteOut [1, 2] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(2)
        -- screen2_FadeIn [1, 2] : couche décor (overlay scène, adaptation)
        -- camera2_SetPositionMark [2, 2, 58, 17] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 97, 17] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 19, 47] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 58, 47] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 97, 47] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 19, 77] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 58, 77] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 97, 77] : PARTIEL
        GAME:WaitFrames(2)
        -- screen2_WhiteOut [1, 15] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(60)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 15)
        UI:ResetSpeaker()
        GAME:FadeOut(false, 0)
        GAME:FadeIn(0)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m19b1007] scène interrompue : '..tostring(err)) end
end

return m19b1007
