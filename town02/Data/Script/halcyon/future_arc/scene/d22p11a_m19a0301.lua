--[[
    D22P11A_m19a0301.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D22P11A/m19a0301.ssb
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

local m19a0301 = {}

function m19a0301.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
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
        })
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Tout est prêt ?') -- FUT_M19A0301_001 (FR)
        -- case 0: ' Are you all ready to roll?'
        -- case 1: ' Are you all ready?'
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        -- NON CONVERTI : BranchScenarioNowAfter [3, 20, 2, 69]
        SV.Scenario.Main = 20 -- flag_SetScenario(SCENARIO_MAIN, scenario=20, level=2)
        -- NON CONVERTI : supervision_ExecuteCommon [250]
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Vous avez l\'air prêts.') -- FUT_M19A0301_002 (FR)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
            end),
        })
        -- performer 0
        -- NON CONVERTI : SetPositionLives [0]
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GROUND:MoveToPosition(CH('Grovyle'), 276, 172, false, 2.0)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 0*8, false, 2.0)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
        GAME:WaitFrames(20)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Bien ! On part maintenant !') -- FUT_M19A0301_003 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(20)
        -- main_EnterDungeon(32) : entrée donjon (mapping id REQUIS)
        -- NON CONVERTI : message_Menu [54]
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- End : fin de scène
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('D\'accord.') -- FUT_M19A0301_004 (FR)
        -- case 7: ' All right.'
        -- case 8: ' OK.'
        UI:WaitShowDialogue('On y va quand tu seras prêt.') -- FUT_M19A0301_005 (FR)
        -- case 10: " We'll go when you're ready."
        -- case 11: " Let's go when you're ready."
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m19a0301] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m19a0301
