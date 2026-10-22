--[[
    D55P41A_n06a1801.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P41A/n06a1801.ssb
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
require 'halcyon.future_arc.FutureScene'

local n06a1801 = {}

function n06a1801.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- back_SetGround(D55P41A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- supervision_cting layer [1] (structurel)
        -- supervision_cting layer [2] (structurel)
        -- supervision_cting layer [3] (structurel)
        -- supervision_cting layer [4] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- object 450 (v38p06a1) : contexte objet
        FutureScene.ObjectSetAnim('v38p06a1', 11, 0, 3, Direction.Down, 1) -- objet 450, anim 11 (table REQUISE)
        -- object 451 (v38p03a1) : contexte objet
        FutureScene.ObjectSetAnim('v38p03a1', 14, 0, 3, Direction.Down, 1) -- objet 451, anim 14 (table REQUISE)
        -- NON CONVERTI : bgm2_PlayFadeIn (un seul canal BGM dans PMDO)
        GAME:FadeIn(30)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' GRR...\n GRAA-HAHAHAHA...\n\nGRAA-HAHAHAHA-HAHAHAHA.') -- FUT_N06A1801_001 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Grooooooaaaaaahh...') -- FUT_N06A1801_002 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        -- NON CONVERTI : SetEffect (acteur NPC_BOSUGODORA)
        -- NON CONVERTI : WaitEffect (acteur NPC_BOSUGODORA)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Eeeeek...\n R-run...\n R-run...') -- FUT_N06A1801_003 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        -- NON CONVERTI : SetEffect (acteur NPC_KODORA)
        GAME:WaitFrames(4)
        -- NON CONVERTI : SetEffect (acteur NPC_KODORA5)
        GAME:WaitFrames(3)
        -- NON CONVERTI : SetEffect (acteur NPC_KODORA3)
        GAME:WaitFrames(4)
        -- NON CONVERTI : SetEffect (acteur NPC_KODORA4)
        GAME:WaitFrames(3)
        -- NON CONVERTI : SetEffect (acteur NPC_KODORA2)
        GAME:WaitFrames(4)
        -- NON CONVERTI : SetEffect (acteur NPC_KODORA6)
        -- NON CONVERTI : WaitEffect (acteur NPC_KODORA6)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' RUUUUUUUNNNNN!') -- FUT_N06A1801_004 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : SetAnimation (acteur NPC_BOSUGODORA)
        -- NON CONVERTI : SlidePositionOffset (acteur NPC_BOSUGODORA)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_10250') end) -- TODO SE 10250 (None)
        -- NON CONVERTI : SetAnimation (acteur NPC_BOSUGODORA)
        -- NON CONVERTI : WaitAnimation (acteur NPC_BOSUGODORA)
        GAME:WaitFrames(20)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        -- supervision_emoveActing layer [1] (structurel)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        -- NON CONVERTI : Turn2Direction (acteur NPC_SAANAITO)
        GAME:WaitFrames(3)
        -- NON CONVERTI : Turn2Direction (acteur NPC_CHAAREMU)
        GAME:WaitFrames(3)
        -- NON CONVERTI : Turn2Direction (acteur PLAYER_CHARMS)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(3)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(3)
        -- ExecuteCommon(LOOK_AROUND_DOWN_FUNC_SERIES) : gestuelle parallèle à implémenter
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7430') end) -- TODO SE 7430 (SE_NUM_EVENT_MAIN18_MIKARUGE_06)
        -- (parallèle) NPC_KODORA3, NPC_KODORA6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA3)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA6)
            end),
        })
        -- (parallèle) NPC_KODORA2, NPC_KODORA3, NPC_KODORA5, NPC_KODORA6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA3)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA6)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA2)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA5)
            end),
        })
        -- supervision_emoveActing layer [4] (structurel)
        -- (parallèle) NPC_KODORA, NPC_KODORA2, NPC_KODORA4, NPC_KODORA5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA2)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA5)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA)
            end),
            TASK:BranchCoroutine(function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA4)
            end),
        })
        -- supervision_emoveActing layer [3] (structurel)
        -- supervision_emoveActing layer [2] (structurel)
        GAME:WaitFrames(35)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Hee!\n They panicked and\nran off...') -- FUT_N06A1801_005 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : MovePositionMark (acteur NPC_CHAAREMU)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'re Team Charm, don\'t\nunderestimate us!') -- FUT_N06A1801_006 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : Turn2DirectionLives (acteur PLAYER_CHARMS)
        GAME:WaitFrames(3)
        -- NON CONVERTI : Turn2Direction (acteur NPC_CHAAREMU)
        GAME:WaitFrames(3)
        -- NON CONVERTI : Turn2Direction (acteur NPC_SAANAITO)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Well, at least we won\'t be\nheld back anymore.') -- FUT_N06A1801_007 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s keep moving.') -- FUT_N06A1801_008 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 252, 136, false, 2.0)
        -- NON CONVERTI : MovePositionMark (acteur PLAYER_CHARMS)
        GAME:WaitFrames(9)
        -- NON CONVERTI : MovePositionMark (acteur NPC_CHAAREMU)
        GAME:WaitFrames(6)
        -- NON CONVERTI : MovePositionMark (acteur NPC_SAANAITO)
        GAME:WaitFrames(15)
        -- NON CONVERTI : bgm2_FadeOut (un seul canal BGM dans PMDO)
        GAME:FadeOut(false, 60)
        GAME:WaitFrames(60)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[n06a1801] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return n06a1801
