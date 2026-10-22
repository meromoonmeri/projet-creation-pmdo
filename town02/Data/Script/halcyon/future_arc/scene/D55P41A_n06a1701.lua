--[[
    D55P41A_n06a1701.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P41A/n06a1701.ssb
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

local n06a1701 = {}

function n06a1701.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- PARTIEL : back_SetDungeonBanner [152, 0] (bannière)
        GAME:FadeIn(16)
        GAME:WaitFrames(60)
        GAME:FadeOut(false, 16)
        GAME:WaitFrames(15)
        -- back_SetGround(D55P41A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        -- NON CONVERTI : SetEffect (acteur NPC_BOSUGODORA)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' GRAA-HAHAHAHA-HAHAHAHA!!') -- FUT_N06A1701_001 (FR optionnel)
        UI:SetCenter(false)
        -- message_KeyWait (le dialogue bloque déjà)
        -- NON CONVERTI : SetEffect (acteur NPC_BOSUGODORA)
        -- NON CONVERTI : WaitEffect (acteur NPC_BOSUGODORA)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' You again!\n Did you come here\nfor another fight?!') -- FUT_N06A1701_002 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' You just don\'t learn!\n\nGRAA-HAHAHAHA-HAHAHAHA!!') -- FUT_N06A1701_003 (FR optionnel)
        UI:SetCenter(false)
        -- NON CONVERTI : SetEffect (acteur NPC_BOSUGODORA)
        -- message_KeyWait (le dialogue bloque déjà)
        -- NON CONVERTI : SetEffect (acteur NPC_BOSUGODORA)
        -- NON CONVERTI : WaitEffect (acteur NPC_BOSUGODORA)
        UI:ResetSpeaker()
        -- bgm_PlayFadeIn [165, 0, 256] : BGM TeamCharmsTheme non mappé
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Hee-hee!\n Did you think we\'d just\nstumble back in here without thinking?') -- FUT_N06A1701_004 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Last time didn\'t go so well...') -- FUT_N06A1701_005 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Don\'t you think we\'d be\nplanning something this time?') -- FUT_N06A1701_006 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' This time, we won\'t lose!') -- FUT_N06A1701_007 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Humph!\n As usual, you\'re only\ngood at talking!') -- FUT_N06A1701_008 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' It\'s fine!') -- FUT_N06A1701_009 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' How many times are you going to\ncome here...') -- FUT_N06A1701_010 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5127') end) -- TODO SE 5127 (None)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        GAME:WaitFrames(10)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Just looking for a fight!?') -- FUT_N06A1701_011 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5127') end) -- TODO SE 5127 (None)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        GAME:WaitFrames(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5127') end) -- TODO SE 5127 (None)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        -- PARTIEL : WaitSe [5127]
        GAME:WaitFrames(15)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s go! Lairon!\n\nGet them!') -- FUT_N06A1701_012 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(1)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(3)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(1)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(3)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(1)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(6)
        -- (parallèle) NPC_KODORA, NPC_KODORA5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA5)
            end),
        })
        GAME:WaitFrames(3)
        -- (parallèle) NPC_KODORA3, NPC_KODORA4
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA3)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA4)
            end),
        })
        GAME:WaitFrames(3)
        -- (parallèle) NPC_KODORA2, NPC_KODORA6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA2)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA6)
            end),
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Lairon: GROOOAAAAHH!!') -- FUT_N06A1701_013 (FR optionnel)
        GAME:WaitFrames(24)
        -- (parallèle) NPC_KODORA, NPC_KODORA5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA5)
            end),
        })
        GAME:WaitFrames(3)
        -- (parallèle) NPC_KODORA2, NPC_KODORA4
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA4)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA2)
            end),
        })
        GAME:WaitFrames(3)
        -- (parallèle) NPC_KODORA3, NPC_KODORA6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA3)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA6)
            end),
        })
        UI:ResetSpeaker()
        -- NON CONVERTI : Turn2Direction (acteur NPC_SAANAITO)
        -- NON CONVERTI : SlidePositionOffset (acteur NPC_SAANAITO)
        GAME:WaitFrames(3)
        -- NON CONVERTI : Turn2Direction (acteur NPC_CHAAREMU)
        -- NON CONVERTI : SlidePositionOffset (acteur NPC_CHAAREMU)
        GAME:WaitFrames(18)
        -- NON CONVERTI : SetAnimation (acteur NPC_SAANAITO)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Medicham! Lopunny!\nHere they come!') -- FUT_N06A1701_014 (FR optionnel)
        UI:SetCenter(false)
        -- NON CONVERTI : WaitAnimation (acteur NPC_SAANAITO)
        UI:ResetSpeaker()
        -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Anytime!') -- FUT_N06A1701_015 (FR optionnel)
        UI:SetCenter(false)
        -- NON CONVERTI : WaitAnimation (acteur NPC_CHAAREMU)
        UI:ResetSpeaker()
        -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' OK.\nLet\'s go! [M:H8]') -- FUT_N06A1701_016 (FR optionnel)
        UI:SetCenter(false)
        -- NON CONVERTI : WaitAnimation (acteur PLAYER_CHARMS)
        UI:ResetSpeaker()
        -- NON CONVERTI : supervision_SpecialActing [24, 0, 0]
        -- NON CONVERTI : supervision_SpecialActing [25, 0, 0]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_10249') end) -- TODO SE 10249 (None)
        -- NON CONVERTI : supervision_SpecialActing [26, 0, 0]
        GAME:WaitFrames(120)
        GAME:FadeOut(true, 30)
        -- NON CONVERTI : supervision_SpecialActing [3, 0, 0]
        -- main_EnterDungeon(152) : entrée donjon (mapping id REQUIS)
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[n06a1701] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return n06a1701
