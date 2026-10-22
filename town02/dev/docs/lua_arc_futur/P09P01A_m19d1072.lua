--[[
    P09P01A_m19d1072.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P09P01A/m19d1072.ssb
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

local m19d1072 = {}

function m19d1072.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- back_SetGround(P09P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- screen_FlushOut [1, 0, 8, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' We shall be rid of you for\nall time!') -- FUT_M19D1072_001 (FR optionnel)
        UI:WaitShowDialogue(' This is the end...\nfor you!') -- FUT_M19D1072_002 (FR optionnel)
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
        UI:WaitShowDialogue(' Wheh-heh-heh!') -- FUT_M19D1072_003 (FR optionnel)
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
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Urk...') -- FUT_M19D1072_004 (FR optionnel)
        -- case 3: ' Urk...'
        -- case 4: ' Urk...'
        UI:WaitShowDialogue(' Hey, [hero]! Grovyle!\n\nYou can\'t give up!') -- FUT_M19D1072_005 (FR optionnel)
        -- case 6: " Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!"
        -- case 7: " Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!"
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Gah...\n You say not to give up...?') -- FUT_M19D1072_006 (FR optionnel)
        UI:WaitShowDialogue(' But what can we possibly do in\nthis bleak situation?') -- FUT_M19D1072_007 (FR optionnel)
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' We have to think!') -- FUT_M19D1072_008 (FR optionnel)
        -- case 11: ' We have to think!'
        -- case 12: ' We have to think!'
        UI:ResetSpeaker()
        GAME:FadeOut(false, 30)
        -- screen_FlushIn [1, 0, 1, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m19d1072] scène interrompue : '..tostring(err)) end
end

return m19d1072
