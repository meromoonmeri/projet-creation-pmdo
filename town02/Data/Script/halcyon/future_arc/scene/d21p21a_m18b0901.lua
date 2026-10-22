--[[
    D21P21A_m18b0901.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D21P21A/m18b0901.ssb
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

local m18b0901 = {}

function m18b0901.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- bgm_PlayFadeIn [42, 0, 256] : BGM SealedRuinPit non mappé
        SV.Scenario.Main = 19 -- flag_SetScenario(SCENARIO_MAIN, scenario=19, level=3)
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
        UI:WaitShowDialogue('Nous devons bientôt atteindre le fond, [hero].') -- FUT_M18B0901_001 (FR)
        -- case 0: " We've got to be getting close to\nthe bottom now, [hero]."
        -- case 1: ' We must be getting close to the\nbottom now, [hero].'
        UI:WaitShowDialogue('Nous devons vite rattraper Massko.') -- FUT_M18B0901_002 (FR)
        -- case 3: " We've got to catch up to\n[CS:N]Grovyle[CR] soon."
        -- case 4: ' We have to catch up to [CS:N]Grovyle[CR]\nsoon.'
        UI:WaitShowDialogue('Continuons comme ça !') -- FUT_M18B0901_003 (FR)
        -- case 6: " Let's keep it up!"
        -- case 7: " Let's keep it up!"
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('PLAYER'), 228, 60, false, 2.0)
        GAME:WaitFrames(15)
        GROUND:MoveToPosition(CH('Teammate1'), 228, 60, false, 2.0)
        GAME:WaitFrames(30)
        SOUND:FadeOutBGM(180)
        GAME:FadeOut(false, 30)
        GAME:WaitFrames(180)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m18b0901] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m18b0901
