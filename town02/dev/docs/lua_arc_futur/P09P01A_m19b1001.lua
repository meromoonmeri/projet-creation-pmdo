--[[
    P09P01A_m19b1001.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P09P01A/m19b1001.ssb
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

local m19b1001 = {}

function m19b1001.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Oh!\n I see it now!') -- FUT_M19B1001_001 (FR optionnel)
        UI:WaitShowDialogue(' There it is!') -- FUT_M19B1001_002 (FR optionnel)
        UI:ResetSpeaker()
        GAME:FadeOut(false, 0)
        GAME:FadeIn(0)
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
        pcall(function() SOUND:PlayBGM('Time Gear Remix.ogg', true) end) -- TimeGearRemix
        GAME:WaitFrames(90)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 416, false, 2.0)
        GROUND:MoveToPosition(CH('Celebi'), 284, 404, false, 2.0)
        GAME:WaitFrames(20)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Grovyle'), 316, 404, false, 2.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Teammate1'), 280, 428, false, 2.0)
            end,
        })
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 324, 428, false, 2.0)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Is that...\nthe Passage of Time?') -- FUT_M19B1001_003 (FR optionnel)
        -- case 2: ' Is that...[K]the Passage of Time?'
        -- case 3: ' Is that...[K]the Passage of Time?'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        -- (parallèle) ATTENDANT1, NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Celebi'), CH('Teammate1'))
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s right.\n That\'s the Passage\nof Time.') -- FUT_M19B1001_004 (FR optionnel)
        UI:WaitShowDialogue(' I went through that to go to\nthe past.') -- FUT_M19B1001_005 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Celebi, only you can open the\nPassage of Time.') -- FUT_M19B1001_006 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Do your thing.') -- FUT_M19B1001_007 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Sure.') -- FUT_M19B1001_008 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
        GROUND:MoveToPosition(CH('Celebi'), CH('Celebi').Position.X + 0.7969*8, CH('Celebi').Position.Y + 0*8, false, 1.594)
        SOUND:FadeOutBGM(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
        })
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Stop there!\n That will do!') -- FUT_M19B1001_009 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What...?\n That voice!') -- FUT_M19B1001_010 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' It... It can\'t be...') -- FUT_M19B1001_011 (FR optionnel)
        -- case 12: " It... It can't be..."
        -- case 13: " It... It can't be..."
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Hello to you all.\n It\'s been a while.') -- FUT_M19B1001_012 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
            end,
        })
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(1)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 308, false, 3.0)
        pcall(function() SOUND:PlayBGM('The Power of Darkness.ogg', true) end) -- ThePowerOfDarkness
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' N-Necrozma!') -- FUT_M19B1001_013 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Necrozma...') -- FUT_M19B1001_014 (FR optionnel)
        -- case 17: ' [CS:N]Dusknoir[CR]...'
        -- case 18: ' [CS:N]Dusknoir[CR]...'
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 416, false, 1.0)
        GROUND:MoveToPosition(CH('Necrozma'), 300, 348, false, 1.0)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Your scurrying carried you far...') -- FUT_M19B1001_015 (FR optionnel)
        UI:WaitShowDialogue(' But sad to say...\n That\'s all\nover now.') -- FUT_M19B1001_016 (FR optionnel)
        UI:ResetSpeaker()
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Celebi'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('Celebi'), CH('Celebi').Position.X + 1*8, CH('Celebi').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 0*8, false, 2.0)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 0*8, false, 2.0)
            end,
        })
        GAME:WaitFrames(5)
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 0*8, false, 2.0)
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Celebi'), 'Idle', true) end) -- placeholder sûr
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        -- supervision_cting layer [2] (structurel)
        GAME:WaitFrames(1)
UI:SetSpeaker(CH('Sableye_1'))
        UI:WaitShowDialogue(' Wheh-heh-heh!') -- FUT_M19B1001_017 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII, NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_1'), 216, 364, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), 384, 364, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), 204, 396, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), 396, 396, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), 208, 428, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), 392, 428, false, 3.0)
            end,
        })
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(12)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(7)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(5)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' The Sableye too...') -- FUT_M19B1001_018 (FR optionnel)
        -- case 23: ' The [CS:N]Sableye[CR] too...'
        -- case 24: ' The [CS:N]Sableye[CR] too...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Humph.\n That\'s crafty, Necrozma.') -- FUT_M19B1001_019 (FR optionnel)
        UI:WaitShowDialogue(' You allowed us to roam free, but\nyou kept your eye on us the whole time...') -- FUT_M19B1001_020 (FR optionnel)
        UI:WaitShowDialogue(' So you could capture Celebi as\nwell as us.') -- FUT_M19B1001_021 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What?!\n So you mean we were...') -- FUT_M19B1001_022 (FR optionnel)
        -- case 29: ' What?![K] So you mean we were...'
        -- case 30: ' What?![K] So you mean we were...'
        UI:WaitShowDialogue(' followed the whole time?!') -- FUT_M19B1001_023 (FR optionnel)
        -- case 32: ' followed the whole time?!'
        -- case 33: ' followed the whole time?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Humph. I didn\'t see this coming.') -- FUT_M19B1001_024 (FR optionnel)
        UI:WaitShowDialogue(' It\'s all my fault, Celebi.') -- FUT_M19B1001_025 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Oh?\n Apologies don\'t suit your\nstyle, my dear Grovyle!') -- FUT_M19B1001_026 (FR optionnel)
        UI:WaitShowDialogue(' And do you honestly think that I\ncan be caught? Tee-hee!') -- FUT_M19B1001_027 (FR optionnel)
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
        -- (parallèle) NPC_JUPUTORU, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + -8*8, false, 1.0)
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Left, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Right, 15)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 0.5*8, CH('Grovyle').Position.Y + -8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Celebi'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Celebi'), CH('Celebi').Position.X + 0.5*8, CH('Celebi').Position.Y + 8*8, false, 1.0)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 0.5*8, CH('PLAYER').Position.Y + -8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 0.5*8, CH('Teammate1').Position.Y + 8*8, false, 1.0)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
        -- (parallèle) NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Celebi'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(10)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Everyone!\n Are you ready\nto fight?!') -- FUT_M19B1001_028 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Huh?!\n You bet I am!') -- FUT_M19B1001_029 (FR optionnel)
        -- case 40: ' Huh?![K] You bet I am!'
        -- case 41: ' What?![K] Of course!'
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' We\'re going to power our\nway through!') -- FUT_M19B1001_030 (FR optionnel)
        UI:WaitShowDialogue(' We\'ll push them aside...\n\nThen dive into the Passage of Time!') -- FUT_M19B1001_031 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' G-got it!') -- FUT_M19B1001_032 (FR optionnel)
        -- case 45: ' G-got it!'
        -- case 46: ' G-got it!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Right, 15)
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Ha! So you\'ll resist?') -- FUT_M19B1001_033 (FR optionnel)
        UI:WaitShowDialogue(' Spare yourself the effort.\n\nYou have no chance of succeeding.') -- FUT_M19B1001_034 (FR optionnel)
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
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' We won\'t know for sure...\nuntil\nwe try!') -- FUT_M19B1001_035 (FR optionnel)
        UI:WaitShowDialogue(' Necrozma!\n You and me! Now!') -- FUT_M19B1001_036 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Grovyle.\n Are you really such a\nfool to think that I\'d come alone?') -- FUT_M19B1001_037 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Wh-what?!') -- FUT_M19B1001_038 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        GAME:WaitFrames(5)
        -- (parallèle) ATTENDANT1, NPC_SEREBII, NPC_YONOWAARU
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Necrozma'), Direction.Up, 15)
            end,
        })
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Now, Master Necrozma!') -- FUT_M19B1001_039 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7434') end) -- TODO table SE id 7434
        GAME:FadeOut(false, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Whoa!\n It turned pitch black!') -- FUT_M19B1001_040 (FR optionnel)
        -- case 55: ' Whoa![K] It turned pitch black!'
        -- case 56: ' Waah![K] It turned pitch black!'
        UI:ResetSpeaker()
        -- PARTIEL : WaitSe [7434]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5143') end) -- TODO table SE id 5143
        GAME:FadeIn(5)
        GAME:WaitFrames(2)
        GAME:FadeOut(false, 5)
        GAME:WaitFrames(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5143') end) -- TODO table SE id 5143
        GAME:FadeIn(5)
        GAME:WaitFrames(2)
        GAME:FadeOut(false, 5)
        GAME:WaitFrames(30)
        -- PARTIEL : WaitSe [5143]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6930') end) -- TODO table SE id 6930
        -- message_ImitationSound : PARTIEL
        -- PARTIEL : WaitSe [6930]
        UI:ResetSpeaker()
        -- PARTIEL : back2_SetMode [4]
        -- back2_SetGround(V12P01A) : couche décor (overlay scène, adaptation)
        -- PARTIEL : back2_SetEffect [7, 0]
        -- camera2_SetPositionMark [2, 2, 19, 15] : PARTIEL
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7431') end) -- TODO table SE id 7431
        -- screen2_FadeIn [1, 30] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(15)
        -- camera2_SetPositionMark [2, 2, 58, 15] : PARTIEL
        GAME:WaitFrames(4)
        -- camera2_SetPositionMark [2, 2, 97, 15] : PARTIEL
        GAME:WaitFrames(90)
        -- PARTIEL : WaitSe [7431]
        -- screen2_FadeOut [1, 30] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(30)
        -- back2_SetGround(V13P01A) : couche décor (overlay scène, adaptation)
        -- camera2_SetPositionMark [2, 2, 19, 17] : PARTIEL
        -- supervision_cting layer [3] (structurel)
        pcall(function() SOUND:PlayBGM('Planet\'s Paralysis.ogg', true) end) -- PlanetsParalysis
        -- screen2_FadeIn [1, 30] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(30)
        GAME:WaitFrames(60)
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
        GAME:WaitFrames(90)
        -- screen2_FadeOut [1, 60] : couche décor (overlay scène, adaptation)
        UI:ResetSpeaker()
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        GAME:WaitFrames(30)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Waaah!') -- FUT_M19B1001_041 (FR optionnel)
        -- case 60: ' Waaah!'
        -- case 61: ' Waaah!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That...\n That\'s...!') -- FUT_M19B1001_042 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Grovyle!\n What is it?! What is\nthat thing?!') -- FUT_M19B1001_043 (FR optionnel)
        -- case 64: ' [CS:N]Grovyle[CR]![K] What is it?! What is\nthat thing?!'
        -- case 65: ' [CS:N]Grovyle[CR]![K] What is it?! What is\nthat?!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Necrozma'), Direction.Down, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s...\nPrimal...\nNecrozma...') -- FUT_M19B1001_044 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What!?!\n That is?!') -- FUT_M19B1001_045 (FR optionnel)
        -- case 68: ' What!?![K] That is?!'
        -- case 69: ' What!?![K] That is?!'
        UI:WaitShowDialogue(' That\'s Primal Necrozma?!') -- FUT_M19B1001_046 (FR optionnel)
        -- case 71: " That's Primal [CS:N]Dialga[CR]?!"
        -- case 72: " That's Primal [CS:N]Dialga[CR]?!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What\'s wrong, Grovyle?\n\nWhere\'s your bravado now?') -- FUT_M19B1001_047 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Gah...') -- FUT_M19B1001_048 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' My dear Grovyle...') -- FUT_M19B1001_049 (FR optionnel)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Urf...\n This...\nis it for us...') -- FUT_M19B1001_050 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Huh?! Why?!') -- FUT_M19B1001_051 (FR optionnel)
        -- case 78: ' Huh?! Why?!'
        -- case 79: ' What?! Why?!'
        UI:WaitShowDialogue(' Aren\'t we going to fight?!') -- FUT_M19B1001_052 (FR optionnel)
        -- case 81: " Aren't we going to fight?!"
        -- case 82: " Aren't we going to fight?!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' It\'s hopeless...\n Necrozma on his\nown is one thing...') -- FUT_M19B1001_053 (FR optionnel)
        UI:WaitShowDialogue(' But we don\'t stand a chance\nagainst Necrozma.') -- FUT_M19B1001_054 (FR optionnel)
        UI:WaitShowDialogue(' You two have kept up so well...') -- FUT_M19B1001_055 (FR optionnel)
        UI:WaitShowDialogue(' I\'m sorry to let you down.\n\nThis is where it ends.') -- FUT_M19B1001_056 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' But...') -- FUT_M19B1001_057 (FR optionnel)
        -- case 88: ' But...'
        -- case 89: ' But...'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        GAME:WaitFrames(30)
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 0.5*8, CH('Grovyle').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.UpRight, 15)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' I surrender, Necrozma.') -- FUT_M19B1001_058 (FR optionnel)
        UI:WaitShowDialogue(' Do with me...as you will.') -- FUT_M19B1001_059 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' My d-d-dear Grovyle!') -- FUT_M19B1001_060 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What\'s the matter, Grovyle?') -- FUT_M19B1001_061 (FR optionnel)
        UI:WaitShowDialogue(' It\'s not like you to give up\nso easily.') -- FUT_M19B1001_062 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Yes.\n I am giving up.') -- FUT_M19B1001_063 (FR optionnel)
        UI:WaitShowDialogue(' But...\nhope is still alive.') -- FUT_M19B1001_064 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Celebi, you remember...') -- FUT_M19B1001_065 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Necrozma'))
        UI:SetCenter(true)
        UI:WaitShowDialogue(' That last time...\nwhen I traveled\nback in time to prevent the planet\'s paralysis...') -- FUT_M19B1001_066 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I wasn\'t alone.\n There was\nanother.') -- FUT_M19B1001_067 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What?!\n Grovyle, you didn\'t come\nto our world by yourself?!') -- FUT_M19B1001_068 (FR optionnel)
        -- case 101: " What?![K] [CS:N]Grovyle[CR], you didn't come\nto our world by yourself?!"
        -- case 102: " What?![K] [CS:N]Grovyle[CR], you didn't come\nto our world alone?!"
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s right.\n I had a partner.') -- FUT_M19B1001_069 (FR optionnel)
        UI:WaitShowDialogue(' We headed to the past together.') -- FUT_M19B1001_070 (FR optionnel)
        UI:WaitShowDialogue(' But when we were going through\nthe Passage of Time, we had trouble...') -- FUT_M19B1001_071 (FR optionnel)
        UI:WaitShowDialogue(' We became separated.') -- FUT_M19B1001_072 (FR optionnel)
        UI:WaitShowDialogue(' My partner should still be back\nin the world of the past.') -- FUT_M19B1001_073 (FR optionnel)
        UI:WaitShowDialogue(' Even if I am eliminated...') -- FUT_M19B1001_074 (FR optionnel)
        UI:WaitShowDialogue(' My partner will see our mission\nthrough to the end.') -- FUT_M19B1001_075 (FR optionnel)
        UI:WaitShowDialogue(' My partner will prevent the\nplanet\'s paralysis.') -- FUT_M19B1001_076 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(180)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' .....................') -- FUT_M19B1001_077 (FR optionnel)
        -- message_KeyWait (le dialogue bloque déjà)
        UI:WaitShowDialogue(' Ha!\n Ha-ha-ha! Hoo-hoo-ha!') -- FUT_M19B1001_078 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Necrozma'))
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Necrozma'))
            end,
            function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Necrozma'))
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What\'s...\n What\'s so funny?') -- FUT_M19B1001_079 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Ha!\n So you claim someone went\nto the past with you...') -- FUT_M19B1001_080 (FR optionnel)
        UI:WaitShowDialogue(' Incidentally, what\'s the name of\nyour partner?') -- FUT_M19B1001_081 (FR optionnel)
        UI:WaitShowDialogue(' Go on. Say the name.') -- FUT_M19B1001_082 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Why ask such a thing?') -- FUT_M19B1001_083 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Can\'t tell me?') -- FUT_M19B1001_084 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' No, that\'s not true.\n My partner\'s\nname is [hero].') -- FUT_M19B1001_085 (FR optionnel)
        UI:WaitShowDialogue(' My best friend...') -- FUT_M19B1001_086 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(What?!)') -- FUT_M19B1001_087 (FR optionnel)
        -- case 122: '(What?!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Uh...what?!') -- FUT_M19B1001_088 (FR optionnel)
        -- case 124: ' Uh...what?!'
        -- case 125: ' Wh-what?!'
        UI:WaitShowDialogue(' Grovyle!\n You said\n[hero]?!') -- FUT_M19B1001_089 (FR optionnel)
        -- case 127: ' [CS:N]Grovyle[CR]![K] You said\n[hero]?!'
        -- case 128: ' [CS:N]Grovyle[CR]![K] Did you say\n[hero]?!'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Well, this is [hero]\nright here!') -- FUT_M19B1001_090 (FR optionnel)
        UI:SetCenter(false)
        -- case 130: ' Well, this is [hero]\nright here!'
        -- case 131: ' Well, this is [hero]\nright here!'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('Celebi'), CH('PLAYER'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What?!') -- FUT_M19B1001_091 (FR optionnel)
        UI:WaitShowDialogue(' You\'re...\n[hero]?') -- FUT_M19B1001_092 (FR optionnel)
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' ...\nNo...\nit can\'t be. It isn\'t.') -- FUT_M19B1001_093 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' The [hero] I know isn\'t\na Pokémon.') -- FUT_M19B1001_094 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        UI:SetCenter(true)
        UI:WaitShowDialogue(' The [hero] that I\nknow...\nis a human.') -- FUT_M19B1001_095 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What?!') -- FUT_M19B1001_096 (FR optionnel)
        -- case 138: ' What?!'
        -- case 139: ' What?!'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('Hidden Highland.ogg', true) end) -- HiddenHighland
        -- SetAnimation id 49 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Necrozma'), 'Idle', true) end) -- placeholder sûr
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Hoo-hoo-ha!\n Precisely!') -- FUT_M19B1001_097 (FR optionnel)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Necrozma'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Necrozma'))
            end,
        })
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('Grovyle'), CH('Necrozma'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Celebi'), CH('Necrozma'))
            end,
        })
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Necrozma'), 'Idle', true) end) -- placeholder sûr
        UI:SetCenter(true)
        UI:WaitShowDialogue(' My good fellow! Grovyle, that\nis unmistakably your friend [hero]!') -- FUT_M19B1001_098 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What?!') -- FUT_M19B1001_099 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That Pokémon you see was once\na human!') -- FUT_M19B1001_100 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Necrozma'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Wh-what?!') -- FUT_M19B1001_101 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Master Necrozma had given me a\nmission...') -- FUT_M19B1001_102 (FR optionnel)
        UI:WaitShowDialogue(' It was to get rid of you,\nGrovyle, and [hero]. Because you fled\nto the past.') -- FUT_M19B1001_103 (FR optionnel)
        UI:WaitShowDialogue(' I traveled through time in\npursuit of you both.') -- FUT_M19B1001_104 (FR optionnel)
        UI:WaitShowDialogue(' In the past, I gathered\nintelligence that might help me find you.') -- FUT_M19B1001_105 (FR optionnel)
        UI:ResetSpeaker()
        GAME:FadeOut(true, 30)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m19b1001] scène interrompue : '..tostring(err)) end
end

return m19b1001
