--[[
    D18P11A_m17a0601.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D18P11A/m17a0601.ssb
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

local m17a0601 = {}

function m17a0601.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- bgm_PlayFadeIn [39, 0, 256] : BGM ChasmCave non mappé
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
            end),
        })
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Tout est prêt, [hero] ?') -- FUT_M17A0601_001 (FR)
        -- case 0: ' Are you all ready, [hero]?'
        -- case 1: ' Are you ready, [hero]?'
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('D\'accord ! On y va !') -- FUT_M17A0601_002 (FR)
        UI:SetCenter(false)
        -- case 5: " All right! Let's roll!"
        -- case 6: " OK! Let's go, quick!"
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
            end),
        })
        -- main_EnterDungeon(27) : entrée donjon (mapping id REQUIS)
        -- NON CONVERTI : message_Menu [54]
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('On y va quand tu seras prêt.') -- FUT_M17A0601_003 (FR)
        UI:SetCenter(false)
        -- case 8: " We'll go when you're ready."
        -- case 9: " Let's go when you're ready."
        UI:SetCenter(true)
        UI:WaitShowDialogue('Partons avant l\'arrivée des Ténéfix.') -- FUT_M17A0601_004 (FR)
        UI:SetCenter(false)
        -- case 11: " Let's get moving before those\n[CS:N]Sableye[CR] come."
        -- case 12: " Let's go before those [CS:N]Sableye[CR]\nget here."
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m17a0601] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m17a0601
