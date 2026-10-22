--[[
    P05P02A_m17a0201.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P02A/m17a0201.ssb
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

local m17a0201 = {}

function m17a0201.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        SV.Scenario.Main = 18 -- flag_SetScenario(SCENARIO_MAIN, scenario=18, level=2)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(It\'s no good.\n Like [partner] said, these\ndoors won\'t open.)') -- FUT_M17A0201_001 (FR optionnel)
        -- case 2: "(It's no good.[K] Like [partner] said, these\ndoors won't open.)"
        UI:WaitShowDialogue('(It sure looks like we\'ve been locked up!)') -- FUT_M17A0201_002 (FR optionnel)
        -- case 4: "(It sure looks like we've been locked up!)"
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0201] scène interrompue : '..tostring(err)) end
end

return m17a0201
