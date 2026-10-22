--[[
    D20P11A_m18b0501.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D20P11A/m18b0501.ssb
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

local m18b0501 = {}

function m18b0501.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- back_SetGround(D20P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        -- bgm_PlayFadeIn [41, 0, 256] : BGM SealedRuin non mappé
        GAME:WaitFrames(30)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), 256, 212, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), 216, 212, false, 2.0)
            end),
        })
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 360, 212, false, 2.0)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), 376, 212, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), 344, 212, false, 2.0)
            end),
        })
        GAME:WaitFrames(20)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Depuis le départ de Massko, le chemin était tout droit, sans aucun embranchement.') -- FUT_M18B0501_001 (FR)
        -- case 0: " Since [CS:N]Grovyle[CR] left, it's been one\nstraight shot without any branching paths."
        -- case 1: " Since [CS:N]Grovyle[CR] left, it's been one\nstraight shot without any branching paths."
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        GAME:WaitFrames(20)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Donc Massko devrait être devant nous.') -- FUT_M18B0501_002 (FR)
        -- case 3: ' So [CS:N]Grovyle[CR] should be\nahead of us.'
        -- case 4: ' So [CS:N]Grovyle[CR] should be ahead of\nus on this same path.'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('Allons-y, [hero] !') -- FUT_M18B0501_003 (FR)
        -- case 6: " Let's go, [hero]!"
        -- case 7: " Let's go, [hero]!"
        UI:WaitShowDialogue('Rattrapons Massko !') -- FUT_M18B0501_004 (FR)
        -- case 9: " Let's catch up to [CS:N]Grovyle[CR]!"
        -- case 10: " Let's catch up to [CS:N]Grovyle[CR]!"
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m18b0501] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m18b0501
