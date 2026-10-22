--[[
    D55P11A_n06a3903.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P11A/n06a3903.ssb
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

local n06a3903 = {}

function n06a3903.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- bgm_PlayFadeIn [161, 0, 256] : BGM IllusionStoneChamber non mappé
        -- back_SetGround(D55P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_tationCommon layer [1] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- NON CONVERTI : SetPositionInitial []
        -- NON CONVERTI : SetPositionInitial []
        -- NON CONVERTI : SetPositionInitial []
        -- (parallèle) NPC_CHAAREMU, NPC_METAMON_OTACHI, NPC_SAANAITO
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_METAMON_OTACHI)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
            end,
        })
        -- performer 0
        GROUND:TeleportTo(CH('PLAYER'), 276, 292)
        -- (parallèle) NPC_CHAAREMU, NPC_METAMON_OTACHI, NPC_SAANAITO, PLAYER_CHARMS
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetPositionMark (acteur NPC_METAMON_OTACHI)
                -- NON CONVERTI : SetDirection (acteur NPC_METAMON_OTACHI)
            end,
            function()
                -- NON CONVERTI : SetPositionMark (acteur NPC_CHAAREMU)
                -- NON CONVERTI : SetDirection (acteur NPC_CHAAREMU)
            end,
            function()
                -- NON CONVERTI : SetPositionMark (acteur NPC_SAANAITO)
                -- NON CONVERTI : SetDirection (acteur NPC_SAANAITO)
            end,
            function()
                -- NON CONVERTI : SetPositionMark (acteur PLAYER_CHARMS)
                -- NON CONVERTI : SetDirection (acteur PLAYER_CHARMS)
            end,
        })
        -- screen_FlushOut [1, 0, 8, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Sad')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' After watching you...\n\nI feel like I can trust you, so...') -- FUT_N06A3903_001 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I have a request.') -- FUT_N06A3903_002 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : SetEffect (acteur PLAYER_CHARMS)
        -- NON CONVERTI : WaitEffect (acteur PLAYER_CHARMS)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' A request?') -- FUT_N06A3903_003 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Sad')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Yes.\n Team AWD...') -- FUT_N06A3903_004 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Team AWD needs to be punished.') -- FUT_N06A3903_005 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        UI:ResetSpeaker()
        GAME:FadeOut(true, 30)
        -- screen_FlushIn [1, 0, 1, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[n06a3903] scène interrompue : '..tostring(err)) end
end

return n06a3903
