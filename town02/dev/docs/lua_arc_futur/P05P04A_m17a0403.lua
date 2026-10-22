--[[
    P05P04A_m17a0403.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P04A/m17a0403.ssb
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

local m17a0403 = {}

function m17a0403.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('Planet\'s Paralysis.ogg', true) end) -- PlanetsParalysis
        -- back_SetGround(P05P04A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' It\'s as if...\nall movement...') -- FUT_M17A0403_001 (FR optionnel)
        -- case 0: " It's as if...[K]all movement..."
        -- case 1: " It's as if...[K]all movement..."
        UI:WaitShowDialogue(' It\'s as if everything\'s stopped.') -- FUT_M17A0403_002 (FR optionnel)
        -- case 3: " It's as if everything's stopped."
        -- case 4: " It's as if everything's stopped."
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Exactly.') -- FUT_M17A0403_003 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8978') end) -- TODO table SE id 8978
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpRight, 15)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What?!') -- FUT_M17A0403_004 (FR optionnel)
        -- case 7: ' What?!'
        -- case 8: ' What?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue(' Wheh-heh-heh!') -- FUT_M17A0403_005 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Left, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 15)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Wah! I hear those Sableye!') -- FUT_M17A0403_006 (FR optionnel)
        -- case 11: ' Wah! I hear those [CS:N]Sableye[CR]!'
        -- case 12: ' Wah! I hear those [CS:N]Sableye[CR]!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' We have to keep running!') -- FUT_M17A0403_007 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1.5*8, CH('Grovyle').Position.Y + 160*8, false, 3.0)
        GAME:WaitFrames(5)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1.5*8, CH('PLAYER').Position.Y + 160*8, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1.5*8, CH('Teammate1').Position.Y + 160*8, false, 3.0)
            end,
        })
        GAME:WaitFrames(30)
        SOUND:FadeOutBGM(180)
        GAME:FadeOut(false, 60)
        -- WaitBgm : PARTIEL
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0403] scène interrompue : '..tostring(err)) end
end

return m17a0403
