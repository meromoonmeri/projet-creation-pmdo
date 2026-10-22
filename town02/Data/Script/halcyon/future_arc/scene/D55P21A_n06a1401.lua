--[[
    D55P21A_n06a1401.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P21A/n06a1401.ssb
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

local n06a1401 = {}

function n06a1401.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Worried')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Everyone...\nall right?') -- FUT_N06A1401_001 (FR optionnel)
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
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetDirection (acteur NPC_CHAAREMU)
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetDirection (acteur NPC_SAANAITO)
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetDirection (acteur PLAYER_CHARMS)
                -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
                -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
            end),
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
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
                -- NON CONVERTI : Turn2Direction (acteur NPC_CHAAREMU)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
                -- NON CONVERTI : Turn2Direction (acteur PLAYER_CHARMS)
            end),
        })
        GAME:WaitFrames(10)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_CHAAREMU)
        GAME:WaitFrames(6)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_SAANAITO)
        GAME:WaitFrames(30)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Yeah.\n I\'m fine.') -- FUT_N06A1401_002 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : Turn2DirectionLives (acteur PLAYER_CHARMS)
        GAME:WaitFrames(6)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_SAANAITO)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I\'m all right too.\n But I was a\nlittle unprepared.') -- FUT_N06A1401_003 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' They were a little stronger...\n\nthan I expected.') -- FUT_N06A1401_004 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_CHAAREMU)
        GAME:WaitFrames(6)
        -- NON CONVERTI : Turn2DirectionLives (acteur PLAYER_CHARMS)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Worried')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' What should we do?\n Look for\nanother way?') -- FUT_N06A1401_005 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_SAANAITO)
        GAME:WaitFrames(6)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_CHAAREMU)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Worried')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' No.\n If we do that, there\'s a\nchance we\'ll get even more lost...') -- FUT_N06A1401_006 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' And it will take a while.') -- FUT_N06A1401_007 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Anyhow...\n We should think of a\nway to cross over there somehow.') -- FUT_N06A1401_008 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Yeah.') -- FUT_N06A1401_009 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Got it.') -- FUT_N06A1401_010 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[n06a1401] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return n06a1401
