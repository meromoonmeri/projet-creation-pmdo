--[[
    D55P21A_n06a1101.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P21A/n06a1101.ssb
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

local n06a1101 = {}

function n06a1101.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- (parallèle) NPC_CHAAREMU, NPC_SAANAITO, PLAYER_CHARMS
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
                -- NON CONVERTI : Turn2Direction (acteur NPC_SAANAITO)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
                -- NON CONVERTI : Turn2Direction (acteur NPC_CHAAREMU)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
                -- NON CONVERTI : Turn2Direction (acteur PLAYER_CHARMS)
            end,
        })
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 6, 59]
        SV.Scenario.Side = 45 -- flag_SetScenario(SCENARIO_SIDE, scenario=45, level=6)
        -- main_EnterDungeon(151) : entrée donjon (mapping id REQUIS)
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[n06a1101] scène interrompue : '..tostring(err)) end
end

return n06a1101
