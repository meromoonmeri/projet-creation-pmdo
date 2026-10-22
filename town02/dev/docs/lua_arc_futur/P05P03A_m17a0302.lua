--[[
    P05P03A_m17a0302.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P03A/m17a0302.ssb
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

local m17a0302 = {}

function m17a0302.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- back_SetGround(P05P03A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Struggle', true) end) -- id 78 (ligoté)
        GAME:FadeIn(120)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Wh-where is this?!') -- FUT_M17A0302_001 (FR optionnel)
        -- case 0: ' Wh-where is this?!'
        -- case 1: ' Wh-where is this?!'
        UI:ResetSpeaker()
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -1*8, false, 2.0)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' They have me trussed up.\nI can\'t move...') -- FUT_M17A0302_002 (FR optionnel)
        -- case 3: " They have me trussed up.\nI can't move..."
        -- case 4: " They have me trussed up.\nI can't move..."
        UI:WaitShowDialogue(' Wh-why is this happening?') -- FUT_M17A0302_003 (FR optionnel)
        -- case 6: ' Wh-why is this happening?'
        -- case 7: ' Wh-why is this happening?'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8711') end) -- TODO table SE id 8711
        -- supervision_emoveActing layer [0] (structurel)
        -- supervision_cting layer [1] (structurel)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
            function()
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
        })
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Hey!') -- FUT_M17A0302_004 (FR optionnel)
        -- case 9: ' Hey!'
        -- case 10: ' Hey!'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('([partner]!)') -- FUT_M17A0302_005 (FR optionnel)
        -- case 12: '([partner]!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Am I glad to see you!\n\nYou\'re OK, right?') -- FUT_M17A0302_006 (FR optionnel)
        -- case 14: " Am I glad to see you![K]\nYou're OK, right?"
        -- case 15: " Am I glad to see you![K]\nYou're OK, right?"
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Humph!') -- FUT_M17A0302_007 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' You\'re clueless about what\'s going to\nhappen...') -- FUT_M17A0302_008 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I guess you can afford to be nonchalant\nabout it.') -- FUT_M17A0302_009 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Huh?!') -- FUT_M17A0302_010 (FR optionnel)
        -- case 20: ' Huh?!'
        -- case 21: ' Huh?!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(That voice came from over there...)') -- FUT_M17A0302_011 (FR optionnel)
        -- case 23: '(That voice came from over there...)'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8711') end) -- TODO table SE id 8711
        -- supervision_emoveActing layer [1] (structurel)
        -- supervision_cting layer [2] (structurel)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
            function()
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
            function()
                -- SetAnimation id 34 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Grovyle!') -- FUT_M17A0302_012 (FR optionnel)
        -- case 25: ' [CS:N]Grovyle[CR]!'
        -- case 26: ' [CS:N]Grovyle[CR]!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' You two...\n Do you have any\ninkling about where you are?') -- FUT_M17A0302_013 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' N-no...') -- FUT_M17A0302_014 (FR optionnel)
        -- case 29: ' N-no...'
        -- case 30: ' N-no...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' This is a stockade...\n They\'re\npreparing to get rid of us for good.') -- FUT_M17A0302_015 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What?!\n G-get rid of us?!') -- FUT_M17A0302_016 (FR optionnel)
        -- case 33: ' What?![K] G-get rid of us?!'
        -- case 34: ' What?![K] G-get rid of us?!'
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Wait a second.') -- FUT_M17A0302_017 (FR optionnel)
        -- case 36: ' Wait a second.'
        -- case 37: ' Wait a second.'
        UI:WaitShowDialogue(' I can understand why they want\nto get rid of you, Grovyle.') -- FUT_M17A0302_018 (FR optionnel)
        -- case 39: ' I can understand why they want\nto get rid of you, [CS:N]Grovyle[CR].'
        -- case 40: " It's easy to understand why\nthey'd want to get rid of you, [CS:N]Grovyle[CR]."
        UI:WaitShowDialogue(' But why us?!') -- FUT_M17A0302_019 (FR optionnel)
        -- case 42: ' But why us?!'
        -- case 43: ' But why us?!'
        UI:WaitShowDialogue(' We haven\'t done anything wrong!') -- FUT_M17A0302_020 (FR optionnel)
        -- case 45: " We haven't done anything wrong!"
        -- case 46: " We haven't done anything wrong!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Humph!\n I couldn\'t care less.') -- FUT_M17A0302_021 (FR optionnel)
        UI:WaitShowDialogue(' You must have done something\nthey can\'t tolerate.') -- FUT_M17A0302_022 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        GROUND:CharSetEmote(CH('Teammate1'), 'angry', 3)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Angry')
        UI:WaitShowDialogue(' What?!') -- FUT_M17A0302_023 (FR optionnel)
        -- case 50: ' What?!'
        -- case 51: ' What?!'
        UI:WaitShowDialogue(' We haven\'t done anything bad!') -- FUT_M17A0302_024 (FR optionnel)
        -- case 53: " We haven't done anything bad!"
        -- case 54: " We haven't done anything bad!"
        UI:WaitShowDialogue(' Don\'t think that we\'re like you!') -- FUT_M17A0302_025 (FR optionnel)
        -- case 56: " Don't think that we're like you!"
        -- case 57: " Don't think that we're like you!"
        UI:ResetSpeaker()
        -- SetEffect 0 (aucun) : pas d'effet
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' I don\'t care.') -- FUT_M17A0302_026 (FR optionnel)
        UI:WaitShowDialogue(' You\'re wasting time losing your\ncool. Meanwhile, look...') -- FUT_M17A0302_027 (FR optionnel)
        UI:WaitShowDialogue(' Here they come.') -- FUT_M17A0302_028 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO table SE id 7187
        GAME:WaitFrames(30)
        -- supervision_emoveActing layer [2] (structurel)
        -- supervision_cting layer [3] (structurel)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
            function()
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
            function()
                -- SetAnimation id 34 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(60)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 772, false, 2.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_1'), 208, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_1'), 164, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), 244, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_2'), 292, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Up, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), 208, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_3'), 188, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), 244, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_4'), 268, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), 208, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_5'), 212, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
            end,
        })
        GAME:WaitFrames(45)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Down, 15)
            end,
        })
        GAME:WaitFrames(45)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7188') end) -- TODO table SE id 7188
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
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
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
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
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(45)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
            end,
        })
        GAME:WaitFrames(10)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 3.0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Waah! Who are they?!') -- FUT_M17A0302_029 (FR optionnel)
        -- case 62: ' Waah! Who are they?!'
        -- case 63: ' Waah! Who are they?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' They\'re the jailers who do all\nthe dirty work around here.') -- FUT_M17A0302_030 (FR optionnel)
        UI:WaitShowDialogue(' They also happen to be\nNecrozma\'s underlings.') -- FUT_M17A0302_031 (FR optionnel)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What?!\n The great Necrozma\'s?!') -- FUT_M17A0302_032 (FR optionnel)
        -- case 67: " What?![K] The great [CS:N]Dusknoir[CR]'s?!"
        -- case 68: " What?![K] The great [CS:N]Dusknoir[CR]'s?!"
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 772, false, 2.0)
        -- supervision_cting layer [4] (structurel)
        GAME:WaitFrames(1)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, NPC_YONOWAARU
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Necrozma'), 228, 788, false, 2.0)
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_1'), CH('Necrozma'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_2'), CH('Necrozma'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_3'), CH('Necrozma'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_4'), CH('Necrozma'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_5'), CH('Necrozma'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_6'), CH('Necrozma'))
            end,
        })
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
            end,
        })
        SOUND:FadeOutBGM(160)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Hey! It\'s Necrozma!') -- FUT_M17A0302_033 (FR optionnel)
        -- case 70: " Hey! It's [CS:N]Dusknoir[CR]!"
        -- case 71: " Hey! It's [CS:N]Dusknoir[CR]!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Lord Necrozma.\n The three have\nbeen tied to the stakes.') -- FUT_M17A0302_034 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Good.') -- FUT_M17A0302_035 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Necrozma, sir!\n\nIt\'s me, [partner]!') -- FUT_M17A0302_036 (FR optionnel)
        -- case 75: " [CS:N]Dusknoir[CR], sir![K]\nIt's me, [partner]!"
        -- case 76: " [CS:N]Dusknoir[CR], sir![K]\nIt's me, [partner]!"
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Necrozma'), 228, 768, false, 1.0)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Very well. Sableye.') -- FUT_M17A0302_037 (FR optionnel)
        UI:WaitShowDialogue(' Those three... We need to be rid\nof them.') -- FUT_M17A0302_038 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('Oh No!.ogg', true) end) -- OhNo
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What?!') -- FUT_M17A0302_039 (FR optionnel)
        -- case 80: ' What?!'
        -- case 81: ' What?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Pay them no heed.\n You may\nget ready.') -- FUT_M17A0302_040 (FR optionnel)
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
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Sableye: Wheh-heh-heh!') -- FUT_M17A0302_041 (FR optionnel)
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
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
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
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7188') end) -- TODO table SE id 7188
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
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
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
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
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(45)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 676, false, 3.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_1'), 156, 696, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), 300, 696, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), 180, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), 276, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), 212, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' W-wait a minute! Necrozma, sir!') -- FUT_M17A0302_042 (FR optionnel)
        -- case 85: ' W-wait a minute! [CS:N]Dusknoir[CR], sir!'
        -- case 86: ' W-wait a minute! [CS:N]Dusknoir[CR], sir!'
        UI:WaitShowDialogue(' What\'s wrong with you?!') -- FUT_M17A0302_043 (FR optionnel)
        -- case 88: " What's wrong with you?!"
        -- case 89: " What's wrong with you?!"
        UI:WaitShowDialogue(' Why are you doing this to us?!') -- FUT_M17A0302_044 (FR optionnel)
        -- case 91: ' Why are you doing this to us?!'
        -- case 92: ' Why are you doing this to us?!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Don\'t waste your breath...\n\nInstead...shhhh...') -- FUT_M17A0302_045 (FR optionnel)
        UI:WaitShowDialogue(' ...Keep your voices down so\nthey can\'t hear you...') -- FUT_M17A0302_046 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Urk...! Keep...my voice down?') -- FUT_M17A0302_047 (FR optionnel)
        -- case 96: ' Urk...! Keep...my voice down?'
        -- case 97: ' Urk...! Keep...my voice down?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' You two...\n If you want to\nget away...') -- FUT_M17A0302_048 (FR optionnel)
        UI:WaitShowDialogue(' ...give me your full cooperation.') -- FUT_M17A0302_049 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What...?\n Help you, Grovyle...?') -- FUT_M17A0302_050 (FR optionnel)
        -- case 101: ' What...?[K] Help you, [CS:N]Grovyle[CR]...?'
        -- case 102: ' What...?[K] Help you, [CS:N]Grovyle[CR]...?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' There\'s no time to think...\n\nor would you prefer to stick around for them?') -- FUT_M17A0302_051 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Psst...hey! You there...') -- FUT_M17A0302_052 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8978') end) -- TODO table SE id 8978
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(...!)') -- FUT_M17A0302_053 (FR optionnel)
        -- case 106: '(...!)'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...Tell me...') -- FUT_M17A0302_054 (FR optionnel)
        UI:WaitShowDialogue(' ...What can you do right now?') -- FUT_M17A0302_055 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(What?\n What can I do?)') -- FUT_M17A0302_056 (FR optionnel)
        -- case 110: '(What?[K] What can I do?)'
        UI:WaitShowDialogue('(You ask me that out of nowhere...!\n Umm...)') -- FUT_M17A0302_057 (FR optionnel)
        -- case 112: '(You ask me that out of nowhere...![K] Umm...)'
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(Wh-what to do...?)') -- FUT_M17A0302_058 (FR optionnel)
        -- case 114: '(Wh-what to do...?)'
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...No. An item\'s no good...') -- FUT_M17A0302_059 (FR optionnel)
        UI:WaitShowDialogue(' ...We\'re tied up...and unable\nto move...') -- FUT_M17A0302_060 (FR optionnel)
        UI:WaitShowDialogue(' ...It should be something you can\ndo instantaneously...') -- FUT_M17A0302_061 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(Urk...! That\'s easy for you to say...\n Ummm...)') -- FUT_M17A0302_062 (FR optionnel)
        -- case 122: "(Urk...! That's easy for you to say...[K] Ummm...)"
        -- Jump (structurel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...A move...?\n That could work,\nbut...') -- FUT_M17A0302_063 (FR optionnel)
        UI:WaitShowDialogue(' ...No! That\'s no good...') -- FUT_M17A0302_064 (FR optionnel)
        UI:WaitShowDialogue(' ...We\'re trussed up...so we\ncan\'t move...') -- FUT_M17A0302_065 (FR optionnel)
        UI:WaitShowDialogue(' ...It has to be something you can\ndo instantaneously...') -- FUT_M17A0302_066 (FR optionnel)
        UI:WaitShowDialogue(' ...It doesn\'t need to be flashy...\nCan\'t you do anything more basic...?') -- FUT_M17A0302_067 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(Urk...! You\'re not helping...\n Ummm...)') -- FUT_M17A0302_068 (FR optionnel)
        -- case 129: "(Urk...! You're not helping...[K] Ummm...)"
        -- Jump (structurel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8965') end) -- TODO table SE id 8965
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...! That\'s it... That\'ll do...') -- FUT_M17A0302_069 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' ...If it\'s just a regular attack,\nI can help too...') -- FUT_M17A0302_070 (FR optionnel)
        -- case 132: " ...If it's just a regular attack,\nI can help too..."
        -- case 133: " ...If it's just a regular attack,\nI can help too..."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...Good.') -- FUT_M17A0302_071 (FR optionnel)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
            end,
        })
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 772, false, 3.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_1'), CH('Necrozma'))
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_2'), CH('Necrozma'))
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_3'), CH('Necrozma'))
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_4'), CH('Necrozma'))
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_5'), CH('Necrozma'))
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_6'), CH('Necrozma'))
            end,
        })
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Then we are ready to begin!') -- FUT_M17A0302_072 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7196') end) -- TODO table SE id 7196
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- PARTIEL : se_Stop [7196]
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
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
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Very well.') -- FUT_M17A0302_073 (FR optionnel)
        UI:WaitShowDialogue(' But be vigilant to the end. Don\'t\ntake your eyes off them.') -- FUT_M17A0302_074 (FR optionnel)
        UI:WaitShowDialogue(' Especially that Grovyle.') -- FUT_M17A0302_075 (FR optionnel)
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
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Sableye: Wheh-heh-heh!') -- FUT_M17A0302_076 (FR optionnel)
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
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
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
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7188') end) -- TODO table SE id 7188
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
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
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
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
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(45)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
            end,
        })
        GROUND:MoveToPosition(CH('Necrozma'), CH('Necrozma').Position.X + 0.5*8, CH('Necrozma').Position.Y + 0*8, false, 1.0)
        GROUND:CharAnimateTurnTo(CH('Necrozma'), Direction.Up, 15)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Commence...\nnow!') -- FUT_M17A0302_077 (FR optionnel)
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 676, false, 3.0)
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
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Sableye: Wheh-heh-heh!') -- FUT_M17A0302_078 (FR optionnel)
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
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 0*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' ...! They\'re coming...') -- FUT_M17A0302_079 (FR optionnel)
        -- case 143: " ...! They're coming..."
        -- case 144: " ...! They're coming..."
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...Listen carefully...') -- FUT_M17A0302_080 (FR optionnel)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
            end,
        })
        UI:SetCenter(true)
        UI:WaitShowDialogue(' ...Sableye use claws to strike...') -- FUT_M17A0302_081 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' ...! Yikes...that sounds scary!') -- FUT_M17A0302_082 (FR optionnel)
        -- case 148: ' ...! Yikes...that sounds scary!'
        -- case 149: ' ...! Yikes...that sounds scary!'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 0*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...And that might just open one\navenue for escape...') -- FUT_M17A0302_083 (FR optionnel)
        UI:WaitShowDialogue(' ...The Sableye will unleash their\nFury Swipes in a frenzy...\n That\'s our chance.') -- FUT_M17A0302_084 (FR optionnel)
        UI:WaitShowDialogue(' ...If even one of their attacks\nwere to hit the ropes binding us...') -- FUT_M17A0302_085 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8978') end) -- TODO table SE id 8978
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' ...Oh, right...!\n The ropes might\ncome loose!') -- FUT_M17A0302_086 (FR optionnel)
        -- case 154: ' ...Oh, right...![K] The ropes might\ncome loose!'
        -- case 155: ' ...Oh, right...![K] The ropes might\ncome loose!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...Exactly...\nand if that happens,\nlash out with an attack, then flee!') -- FUT_M17A0302_087 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' ...B-b-but...') -- FUT_M17A0302_088 (FR optionnel)
        -- case 158: ' ...B-b-but...'
        -- case 159: ' ...B-b-but...'
        UI:WaitShowDialogue(' ...What if their Fury Swipes\ndon\'t slash the ropes...?') -- FUT_M17A0302_089 (FR optionnel)
        -- case 161: " ...What if their [CS:M]Fury Swipes[CR]\ndon't slash the ropes...?"
        -- case 162: " ...What if their [CS:M]Fury Swipes[CR]\ndon't slash the ropes...?"
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 0*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end,
        })
        UI:SetCenter(true)
        UI:WaitShowDialogue(' ...And what if...\n What if the\nSableye don\'t use Fury Swipes at all...?') -- FUT_M17A0302_090 (FR optionnel)
        UI:SetCenter(false)
        -- case 164: " ...And what if...[K] What if the\n[CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?"
        -- case 165: " ...And what if...[K] What if the\n[CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?"
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7194') end) -- TODO table SE id 7194
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Sableye: Wheh-heh-heh!') -- FUT_M17A0302_091 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' If that happens...\ndon\'t even think\nabout it.') -- FUT_M17A0302_092 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7196') end) -- TODO table SE id 7196
        -- supervision_cting layer [8] (structurel)
        -- object 138 (p05p03a2) : contexte objet
        local obj_138 = OBJ('p05p03a2') -- objet 138
        GROUND:ObjectSetAnim(obj_138, 1, 0, 3, Direction.Down, 1) -- anim 1 (table REQUISE)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Left, 15)
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Shouting')
        UI:WaitShowDialogue(' WAAAAAAH!') -- FUT_M17A0302_093 (FR optionnel)
        -- case 169: ' WAAAAAAH!'
        -- case 170: ' WAAAAAAH!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('(Urggh!)') -- FUT_M17A0302_094 (FR optionnel)
        -- case 172: '(Urggh!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' En...en...endure it!\n Wait for\nyour chance!') -- FUT_M17A0302_095 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' But if they keep going...') -- FUT_M17A0302_096 (FR optionnel)
        -- case 175: ' But if they keep going...'
        -- case 176: ' But if they keep going...'
        UI:WaitShowDialogue(' We\'ll be down before our\nchance comes!') -- FUT_M17A0302_097 (FR optionnel)
        -- case 178: " We'll be down before our\nchance comes!"
        -- case 179: " We'll be finished before our\nchance comes!"
        UI:ResetSpeaker()
        -- object 136 (p05p03a1) : contexte objet
        local obj_136 = OBJ('p05p03a1') -- objet 136
        GROUND:ObjectSetAnim(obj_136, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        GROUND:TeleportTo(CH('PLAYER'), CH('PLAYER').Position.X + 0*8, CH('PLAYER').Position.Y + 2*8)
        -- object 136 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Hey!') -- FUT_M17A0302_098 (FR optionnel)
        -- case 181: ' Hey!'
        -- case 182: ' Hey!'
        UI:ResetSpeaker()
        -- object 135 (p05p03a1) : contexte objet
        local obj_135 = OBJ('p05p03a1') -- objet 135
        GROUND:ObjectSetAnim(obj_135, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        GROUND:TeleportTo(CH('Teammate1'), CH('Teammate1').Position.X + 0*8, CH('Teammate1').Position.Y + 2*8)
        -- object 135 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(There\'s a break in the rope!)') -- FUT_M17A0302_099 (FR optionnel)
        -- case 184: "(There's a break in the rope!)"
        UI:ResetSpeaker()
        -- object 137 (p05p03a1) : contexte objet
        local obj_137 = OBJ('p05p03a1') -- objet 137
        GROUND:ObjectSetAnim(obj_137, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        GROUND:TeleportTo(CH('Grovyle'), CH('Grovyle').Position.X + 0*8, CH('Grovyle').Position.Y + 2*8)
        -- object 137 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Now!\n Attack!') -- FUT_M17A0302_100 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' Go!') -- FUT_M17A0302_101 (FR optionnel)
        -- case 187: ' Go!'
        -- case 188: ' Go!'
        UI:ResetSpeaker()
        -- PARTIEL : se_FadeOut [7196, 10]
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
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
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- object 138 (p05p03a2) : contexte objet
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_6')) end)
        -- object 136 (p05p03a1) : contexte objet
        local obj_136 = OBJ('p05p03a1') -- objet 136
        GROUND:ObjectSetAnim(obj_136, 19, 0, 3, Direction.Down, 1) -- anim 19 (table REQUISE)
        -- object 137 (p05p03a1) : contexte objet
        local obj_137 = OBJ('p05p03a1') -- objet 137
        GROUND:ObjectSetAnim(obj_137, 19, 0, 3, Direction.Down, 1) -- anim 19 (table REQUISE)
        -- object 135 (p05p03a1) : contexte objet
        local obj_135 = OBJ('p05p03a1') -- objet 135
        GROUND:ObjectSetAnim(obj_135, 19, 0, 3, Direction.Down, 1) -- anim 19 (table REQUISE)
        -- object 135 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('PLAYER'), 228, 668, false, 5.0)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Teammate1'), 276, 668, false, 5.0)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Grovyle'), 180, 668, false, 5.0)
            end,
        })
        -- object 135 (p05p03a1) : contexte objet
        local obj_135 = OBJ('p05p03a1') -- objet 135
        GROUND:ObjectSetAnim(obj_135, 12, 0, 3, Direction.Down, 1) -- anim 12 (table REQUISE)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5126') end) -- TODO table SE id 5126
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 13 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 13 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 12 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Gwah!') -- FUT_M17A0302_102 (FR optionnel)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 6.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_1'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 3*8, CH('Sableye_1').Position.Y + -8*8, false, 6.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_2'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 3*8, CH('Sableye_2').Position.Y + 8*8, false, 6.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_3'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 3*8, CH('Sableye_3').Position.Y + 0*8, false, 6.0)
            end,
        })
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_4'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 3*8, CH('Sableye_4').Position.Y + 0*8, false, 6.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 3*8, CH('Sableye_5').Position.Y + 0*8, false, 6.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_6'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 3*8, CH('Sableye_6').Position.Y + 0*8, false, 6.0)
            end,
        })
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 776, false, 4.0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Necrozma'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Wh-what is this?!') -- FUT_M17A0302_103 (FR optionnel)
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 4.0)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' There!') -- FUT_M17A0302_104 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:StopBGM()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7191') end) -- TODO table SE id 7191
        -- SetAnimation id 27 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('Grovyle')) end)
        GAME:FadeOut(true, 5)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Gaaaah!') -- FUT_M17A0302_105 (FR optionnel)
        UI:WaitShowDialogue(' We can\'t see!') -- FUT_M17A0302_106 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Compose yourselves!\n It\'s only a\nLuminous Orb!') -- FUT_M17A0302_107 (FR optionnel)
        UI:WaitShowDialogue(' Its effect wears off quickly!') -- FUT_M17A0302_108 (FR optionnel)
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
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
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        pcall(function() GROUND:RemoveCharacter(CH('PLAYER')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Teammate1')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Grovyle')) end)
        GAME:FadeIn(60)
        GAME:WaitFrames(15)
        -- PARTIEL : WaitSe [7191]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_1'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_2'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_3'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_4'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_6'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
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
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 776, false, 3.0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('Necrozma'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' B-blast it!') -- FUT_M17A0302_109 (FR optionnel)
        UI:WaitShowDialogue(' That Grovyle!\n He fled using the\nflash from that Luminous Orb as cover!') -- FUT_M17A0302_110 (FR optionnel)
        UI:WaitShowDialogue(' They won\'t get away with this!\nCome!') -- FUT_M17A0302_111 (FR optionnel)
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
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Sableye: Wheh-heh-heh!') -- FUT_M17A0302_112 (FR optionnel)
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
        GROUND:MoveToPosition(CH('Necrozma'), 228, 932, false, 3.0)
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 916, false, 4.0)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_5'), 212, 916, false, 4.0)
            end,
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_4'), 244, 916, false, 4.0)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_3'), 212, 916, false, 4.0)
            end,
        })
        GAME:WaitFrames(8)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_2'), 244, 916, false, 4.0)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_1'), 212, 916, false, 4.0)
            end,
        })
        pcall(function() GROUND:RemoveCharacter(CH('Necrozma')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_6')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_5')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_4')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_3')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_2')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_1')) end)
        GAME:WaitFrames(60)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 2.0)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7192') end) -- TODO table SE id 7192
        -- supervision_cting layer [5] (structurel)
        -- performer 4
        -- SetEffect [54, 3] : performer 4 non mappé (PARTIEL)
        -- SetAnimation id 28 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('Grovyle')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
        -- performer 4
        -- SetEffect [0, 3] : performer 4 non mappé (PARTIEL)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7192') end) -- TODO table SE id 7192
        -- supervision_cting layer [6] (structurel)
        -- performer 5
        -- SetEffect [54, 3] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- WaitEffect [] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- SetEffect [0, 3] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- SetEffect [100, 3] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- WaitEffect [] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- SetEffect [0, 3] : performer 5 non mappé (PARTIEL)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7192') end) -- TODO table SE id 7192
        -- supervision_cting layer [7] (structurel)
        -- performer 6
        -- SetEffect [54, 3] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- WaitEffect [] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- SetEffect [0, 3] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- SetEffect [100, 3] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- WaitEffect [] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- SetEffect [0, 3] : performer 6 non mappé (PARTIEL)
        GAME:WaitFrames(60)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Blecch! I got dirt in my mouth...') -- FUT_M17A0302_113 (FR optionnel)
        -- case 201: ' Blecch! I got dirt in my mouth...'
        -- case 202: ' Blecch! I got dirt in my mouth...'
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBGM('In the Depths of the Pit.ogg', true) end) -- InTheDepthsOfThePit
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(We\'re...\n We\'re safe...)') -- FUT_M17A0302_114 (FR optionnel)
        -- case 204: "(We're...[K] We're safe...)"
        UI:WaitShowDialogue('(So Grovyle can use Dig?)') -- FUT_M17A0302_115 (FR optionnel)
        -- case 206: '(So [CS:N]Grovyle[CR] can use [CS:M]Dig[CR]?)'
        UI:WaitShowDialogue('(He sure knows many moves.)') -- FUT_M17A0302_116 (FR optionnel)
        -- case 208: '(He sure knows many moves.)'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.UpRight, 15)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' We got out of that scrape...\n\nBut we\'re not out of the woods yet.') -- FUT_M17A0302_117 (FR optionnel)
        UI:WaitShowDialogue(' Let\'s get out of here, and fast.') -- FUT_M17A0302_118 (FR optionnel)
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 832, false, 2.0)
        GROUND:MoveToPosition(CH('Grovyle'), 192, 796, false, 2.0)
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('Teammate1'), 264, 796, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 264, 772, false, 2.0)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownRight, 15)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
        GAME:WaitFrames(20)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
        GAME:WaitFrames(30)
        SOUND:FadeOutBGM(180)
        GROUND:MoveToPosition(CH('Grovyle'), 228, 932, false, 2.398)
        GAME:WaitFrames(20)
        GROUND:MoveToPosition(CH('Teammate1'), 228, 932, false, 2.398)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 228, 932, false, 2.398)
        GAME:WaitFrames(30)
        GAME:FadeOut(false, 60)
        GAME:WaitFrames(80)
        -- flag_CalcBit(SCENARIO_MAIN_BIT_FLAG, 8, 1) : opérations bit (adaptation)
        SV.Scenario.CompulsorySavePoint = 14 -- flag_Set(COMPULSORY_SAVE_POINT)
        -- HANYOU_SAVE_FUNC : point de sauvegarde obligatoire (à brancher)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0302] scène interrompue : '..tostring(err)) end
end

return m17a0302
