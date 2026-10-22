--[[
    D55P11A_n06a0901.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P11A/n06a0901.ssb
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

local n06a0901 = {}

function n06a0901.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Worried')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Hmm...\n Looks like we didn\'t do\nso well.') -- FUT_N06A0901_001 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Happy')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Well, it happens sometimes.\n\nThis kind of thing. [M:H8]') -- FUT_N06A0901_002 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Anyway, let\'s head back for a\nlittle while.') -- FUT_N06A0901_003 (FR optionnel)
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
            function()
                -- NON CONVERTI : SetDirection (acteur NPC_CHAAREMU)
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
            end,
            function()
                -- NON CONVERTI : SetDirection (acteur NPC_SAANAITO)
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
            end,
            function()
                -- NON CONVERTI : SetDirection (acteur PLAYER_CHARMS)
                -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
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
        GAME:WaitFrames(20)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Don\'t be so slow!') -- FUT_N06A0901_004 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' If we don\'t hurry, Team AWD\nwill get that treasure before us!') -- FUT_N06A0901_005 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' There\'s no need to get so\nflustered like that, Medicham.') -- FUT_N06A0901_006 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Worried')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' That\'s right.\n I don\'t know how\nstrong Team AWD is...') -- FUT_N06A0901_007 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' It seems like this treasure is a\nreally difficult one to find...') -- FUT_N06A0901_008 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Don\'t you think that taking our\ntime and not being so impatient would be the\nbest way to explore this place?') -- FUT_N06A0901_009 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Anyway...\n Once we\'re done\ngetting ready, we\'ll head out again.') -- FUT_N06A0901_010 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[n06a0901] scène interrompue : '..tostring(err)) end
end

return n06a0901
