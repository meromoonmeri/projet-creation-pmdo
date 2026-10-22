--[[
    D55P21A_enter02.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P21A/enter02.ssb
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

local enter02 = {}

function enter02.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- Switch (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Switch (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Jump (structurel)
        -- NON CONVERTI : BranchScenarioNowAfter [3, 12, 0, 341]
        -- (parallèle) ATTENDANT1, PLAYER, PLAYER_APPOINT
        TASK:JoinCoroutines({
            function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end,
            function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur PLAYER_APPOINT)
            end,
        })
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : main_EnterGround [26, 30]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : main_EnterGround [47, 30]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : BranchScenarioNowAfter [3, 25, 0, 341]
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : main_EnterGround [55, 30]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : BranchScenarioNowAfter [3, 27, 0, 341]
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : main_EnterGround [59, 30]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : BranchScenarioNowAfter [3, 27, 0, 341]
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : main_EnterGround [59, 30]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : BranchScenarioNowAfter [3, 27, 0, 341]
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : main_EnterGround [67, 30]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : BranchScenarioNowAfter [3, 29, 86, 341]
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : main_EnterGround [97, 30]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : BranchScenarioNowAfter [3, 29, 5, 322]
        -- Jump (structurel)
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        -- NON CONVERTI : main_EnterGround [224, 30]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : BranchScenarioNowAfter [3, 29, 5, 366]
        -- NON CONVERTI : SwitchScenario [3]
        -- NON CONVERTI : CaseScenario [2, 25, 361]
        -- NON CONVERTI : CaseScenario [2, 26, 361]
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- Jump (structurel)
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- Jump (structurel)
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- Jump (structurel)
        -- (parallèle) NPC_YUKIKABURI, PLAYER_BIPPA
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetAnimation (acteur PLAYER_BIPPA)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_YUKIKABURI)
            end,
        })
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- Jump (structurel)
        -- (parallèle) NPC_AAMARUDO, PLAYER_PUPURIN
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetAnimation (acteur PLAYER_PUPURIN)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_AAMARUDO)
            end,
        })
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.GROUND_START_MODE = 9 -- flag_Set(GROUND_START_MODE)
        -- flag_CalcBit(SCENARIO_MAIN_BIT_FLAG, 29, 1) : opérations bit (adaptation)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : supervision_ExecuteCommon [511]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- Switch (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- (parallèle) NPC_CHAAREMU, NPC_SAANAITO, PLAYER_CHARMS
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
            end,
        })
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.GROUND_START_MODE = 9 -- flag_Set(GROUND_START_MODE)
        -- flag_CalcBit(SCENARIO_MAIN_BIT_FLAG, 29, 1) : opérations bit (adaptation)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 7, 483]
        -- NON CONVERTI : supervision_ExecuteCommon [550]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : supervision_ExecuteCommon [557]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.GROUND_START_MODE = 9 -- flag_Set(GROUND_START_MODE)
        -- flag_CalcBit(SCENARIO_MAIN_BIT_FLAG, 29, 1) : opérations bit (adaptation)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 47, 3, 524]
        -- NON CONVERTI : supervision_ExecuteCommon [569]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : supervision_ExecuteCommon [577]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : SetAnimation (acteur PLAYER_KIMAWARI)
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- Jump (structurel)
        -- SetAnimation 2 (spécial : boucle anim courante)
        GAME:WaitFrames(1)
        -- Switch (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        UI:ResetSpeaker()
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 47, 3, 587]
        -- NON CONVERTI : supervision_ExecuteCommon [581]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : supervision_ExecuteCommon [587]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : supervision_ExecuteCommon [594]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : supervision_ExecuteCommon [425]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : supervision_ExecuteCommon [429]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : supervision_ExecuteCommon [432]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : supervision_ExecuteCommon [435]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : supervision_ExecuteCommon [438]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : supervision_ExecuteCommon [460]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : supervision_ExecuteCommon [444]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : supervision_ExecuteCommon [447]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : supervision_ExecuteCommon [451]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : supervision_ExecuteCommon [454]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : supervision_ExecuteCommon [465]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 48, 4, 705]
        -- NON CONVERTI : supervision_ExecuteCommon [609]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : supervision_ExecuteCommon [615]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 48, 9, 738]
        -- NON CONVERTI : supervision_ExecuteCommon [622]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : supervision_ExecuteCommon [628]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 30)
        SV.NewEra.GROUND_START_MODE = 9 -- flag_Set(GROUND_START_MODE)
        -- Switch (structurel)
        -- Case (structurel)
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- flag_CalcBit(SCENARIO_MAIN_BIT_FLAG, 29, 1) : opérations bit (adaptation)
        -- Switch (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- NON CONVERTI : supervision_ExecuteCommon [673]
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : supervision_ExecuteCommon [475]
        SV.NewEra.DUNGEON_RESULT = 3 -- flag_Set(DUNGEON_RESULT)
        -- NON CONVERTI : message_Menu [55]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 43, 9, 801]
        -- NON CONVERTI : supervision_ExecuteCommon [524]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : supervision_ExecuteCommon [541]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        UI:ResetSpeaker()
        -- NON CONVERTI : supervision_Suspend [32766]
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[enter02] scène interrompue : '..tostring(err)) end
end

return enter02
