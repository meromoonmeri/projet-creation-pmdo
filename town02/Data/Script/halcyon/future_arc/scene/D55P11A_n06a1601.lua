--[[
    D55P11A_n06a1601.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P11A/n06a1601.ssb
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

local n06a1601 = {}

function n06a1601.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Hmm...\n Looks like we didn\'t do\nso well.') -- FUT_N06A1601_001 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'ll do better\nnext time. [M:H8]') -- FUT_N06A1601_002 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Anyway, let\'s head back for a\nlittle while.') -- FUT_N06A1601_003 (FR optionnel)
        UI:SetCenter(false)
        -- message_KeyWait (le dialogue bloque déjà)
        GAME:FadeOut(false, 60)
        UI:ResetSpeaker()
        -- CallCommon(FADE_OUT_ALL_AFTER) : helper à implémenter
        -- back_SetGround(D55P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- NON CONVERTI : SetPositionInitial []
        -- NON CONVERTI : SetPositionInitial []
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
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
                -- NON CONVERTI : Turn2DirectionLives (acteur PLAYER_CHARMS)
            end),
        })
        GAME:WaitFrames(10)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_CHAAREMU)
        GAME:WaitFrames(6)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_SAANAITO)
        GAME:WaitFrames(9)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' ...\nLooks like we\'re right back\nhere again...') -- FUT_N06A1601_004 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Worried')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I said we shouldn\'t be\nimpatient earlier...') -- FUT_N06A1601_005 (FR optionnel)
        UI:SetCenter(false)
        -- NON CONVERTI : Turn2DirectionLives (acteur PLAYER_CHARMS)
        GAME:WaitFrames(3)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_CHAAREMU)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' But we just can\'t take our\ntime, either.') -- FUT_N06A1601_006 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I\'m worried about how far\nTeam AWD has gotten...') -- FUT_N06A1601_007 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' That\'s true.\n We should hurry up\na little.') -- FUT_N06A1601_008 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Once you\'re ready, let\'s head out.') -- FUT_N06A1601_009 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[n06a1601] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return n06a1601
