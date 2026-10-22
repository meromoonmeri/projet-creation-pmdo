--[[
    D55P21A_n06a1501.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P21A/n06a1501.ssb
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

local n06a1501 = {}

function n06a1501.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Worried')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Hmm...\n Looks like we didn\'t do\nso well.') -- FUT_N06A1501_001 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Happy')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'ll do better\nnext time. [M:H8]') -- FUT_N06A1501_002 (FR optionnel)
        UI:SetCenter(false)
        -- message_KeyWait (le dialogue bloque déjà)
        GAME:FadeOut(false, 60)
        UI:ResetSpeaker()
        -- CallCommon(FADE_OUT_ALL_AFTER) : helper à implémenter
        -- back_SetGround(D55P21A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- NON CONVERTI : SetPositionInitial []
        -- NON CONVERTI : SetPositionInitial []
        -- (parallèle) NPC_CHAAREMU, NPC_SAANAITO, PLAYER_CHARMS
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetDirection (acteur NPC_CHAAREMU)
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
            end,
            function()
                -- NON CONVERTI : SetDirection (acteur NPC_SAANAITO)
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
            end,
            function()
                -- NON CONVERTI : SetDirection (acteur PLAYER_CHARMS)
                -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
            end,
        })
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- (parallèle) NPC_CHAAREMU, NPC_SAANAITO, PLAYER_CHARMS
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
            end,
        })
        GAME:FadeIn(30)
        -- bgm_PlayFadeIn [139, 0, 256] : BGM BoulderQuarry non mappé
        GAME:WaitFrames(30)
        -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
        GAME:WaitFrames(10)
        -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
        GAME:WaitFrames(7)
        -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
        -- NON CONVERTI : WaitAnimation (acteur NPC_SAANAITO)
        -- (parallèle) NPC_CHAAREMU, NPC_SAANAITO, PLAYER_CHARMS
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
                -- NON CONVERTI : Turn2Direction (acteur NPC_CHAAREMU)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
                -- NON CONVERTI : Turn2DirectionLives (acteur PLAYER_CHARMS)
            end,
        })
        GAME:WaitFrames(10)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_CHAAREMU)
        GAME:WaitFrames(6)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_SAANAITO)
        GAME:WaitFrames(9)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Worried')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' ...\nLooks like we\'re right back\nhere again...') -- FUT_N06A1501_003 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : Turn2DirectionLives (acteur PLAYER_CHARMS)
        GAME:WaitFrames(4)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_SAANAITO)
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- NON CONVERTI : SetEffect (acteur NPC_CHAAREMU)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Angry')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I don\'t like wandering in circles\naimlessly! I don\'t!') -- FUT_N06A1501_004 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s hurry up and go!') -- FUT_N06A1501_005 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : SetEffect (acteur NPC_CHAAREMU)
        -- NON CONVERTI : WaitEffect (acteur NPC_CHAAREMU)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[n06a1501] scène interrompue : '..tostring(err)) end
end

return n06a1501
