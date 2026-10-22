--[[
    D55P21A_n06a1001.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P21A/n06a1001.ssb
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

local n06a1001 = {}

function n06a1001.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- bgm_PlayFadeIn [139, 0, 256] : BGM BoulderQuarry non mappé
        SV.Scenario.Side = 45 -- flag_SetScenario(SCENARIO_SIDE, scenario=45, level=5)
        -- back_SetGround(D55P21A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- NON CONVERTI : SetPositionInitial []
        -- NON CONVERTI : SetPositionInitial []
        -- (parallèle) NPC_CHAAREMU, NPC_SAANAITO, PLAYER_CHARMS
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
            end,
        })
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        -- NON CONVERTI : MovePositionMark (acteur PLAYER_CHARMS)
        GAME:WaitFrames(9)
        -- NON CONVERTI : MovePositionMark (acteur NPC_CHAAREMU)
        GAME:WaitFrames(12)
        -- NON CONVERTI : MovePositionMark (acteur NPC_SAANAITO)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(6)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(4)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- NON CONVERTI : Turn2DirectionLives (acteur PLAYER_CHARMS)
        GAME:WaitFrames(6)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_CHAAREMU)
        GAME:WaitFrames(4)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_SAANAITO)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'ve come pretty far.') -- FUT_N06A1001_001 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_CHAAREMU)
        GAME:WaitFrames(3)
        -- NON CONVERTI : Turn2DirectionLives (acteur PLAYER_CHARMS)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I think it\'s going to get more\ndifficult from here on.') -- FUT_N06A1001_002 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s proceed with caution.') -- FUT_N06A1001_003 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[n06a1001] scène interrompue : '..tostring(err)) end
end

return n06a1001
