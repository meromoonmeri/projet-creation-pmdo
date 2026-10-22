--[[
    D55P41A_n06a1301.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P41A/n06a1301.ssb
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

local n06a1301 = {}

function n06a1301.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        SV.Scenario.Side = 45 -- flag_SetScenario(SCENARIO_SIDE, scenario=45, level=7)
        -- PARTIEL : back_SetDungeonBanner [152, 0] (bannière)
        GAME:FadeIn(16)
        GAME:WaitFrames(60)
        GAME:FadeOut(false, 16)
        GAME:WaitFrames(15)
        -- back_SetGround(D55P41A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- object 451 (v38p03a1) : contexte objet
        local obj_451 = OBJ('v38p03a1') -- objet 451
        GROUND:ObjectSetAnim(obj_451, 12, 0, 3, Direction.Down, 1) -- anim 12 (table REQUISE)
        GAME:WaitFrames(1)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- NON CONVERTI : bgm2_PlayFadeIn (un seul canal BGM dans PMDO)
        GAME:FadeIn(30)
        -- NON CONVERTI : MovePositionMark (acteur PLAYER_CHARMS)
        GAME:WaitFrames(9)
        -- NON CONVERTI : MovePositionMark (acteur NPC_CHAAREMU)
        GAME:WaitFrames(12)
        -- NON CONVERTI : MovePositionMark (acteur NPC_SAANAITO)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(4)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(4)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- NON CONVERTI : Turn2DirectionLives (acteur PLAYER_CHARMS)
        GAME:WaitFrames(4)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_CHAAREMU)
        GAME:WaitFrames(9)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_SAANAITO)
        GAME:WaitFrames(10)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Huh?\n Something about this place\nseems different somehow.') -- FUT_N06A1301_001 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' So far the path has been pretty\nstraight without ever diverging...') -- FUT_N06A1301_002 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Worried')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Maybe we got lost without\nrealizing it...') -- FUT_N06A1301_003 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        -- NON CONVERTI : SetEffect (acteur NPC_CHAAREMU)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Surprised')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Oh no!\n Don\'t tell me we\'re lost!?') -- FUT_N06A1301_004 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' What do we do...?\n We should\njust try to keep moving forward, right...?') -- FUT_N06A1301_005 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Before we entered...\nthose other\nexploration teams told us about this.') -- FUT_N06A1301_006 (FR optionnel)
        UI:SetCenter(false)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_CHAAREMU)
        GAME:WaitFrames(4)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_SAANAITO)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' This is probably the\ncomplex labyrinth.') -- FUT_N06A1301_007 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' So rather than getting worried\nabout being lost...') -- FUT_N06A1301_008 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Think that this is a place where\neveryone gets lost, so it\'s only natural\nthat you\'ll get lost...') -- FUT_N06A1301_009 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Happy')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Wouldn\'t that help\nyou relax? [M:H8]') -- FUT_N06A1301_010 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Happy')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Sounds about right. ♪') -- FUT_N06A1301_011 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I think this might be a detour...') -- FUT_N06A1301_012 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' But eventually we\'ll figure it\nout...I think.') -- FUT_N06A1301_013 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Anyway, let\'s keep going\nand see.') -- FUT_N06A1301_014 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : bgm2_FadeOut (un seul canal BGM dans PMDO)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Wait!\n You!') -- FUT_N06A1301_015 (FR optionnel)
        UI:SetCenter(false)
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8973 (SE_NUM_EVENT_SIGN_SHOCK_03)
        -- NON CONVERTI : SetEffect (acteur PLAYER_CHARMS)
        GAME:WaitFrames(4)
        -- NON CONVERTI : SetEffect (acteur NPC_CHAAREMU)
        GAME:WaitFrames(2)
        -- NON CONVERTI : SetEffect (acteur NPC_SAANAITO)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(2)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(4)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- message_KeyWait (le dialogue bloque déjà)
        -- NON CONVERTI : bgm2_PlayFadeIn (un seul canal BGM dans PMDO)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' You! Where did you come from?!') -- FUT_N06A1301_016 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' This is my...\n How could you not know\nthis is Aggron\'s territory?!') -- FUT_N06A1301_017 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : Turn2Direction (acteur PLAYER_CHARMS)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Really?\n We didn\'t know.') -- FUT_N06A1301_018 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Graa-ha-ha-ha-ha!\n\nYou didn\'t know...') -- FUT_N06A1301_019 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' If you didn\'t know...\nthen allow\nme to teach you...') -- FUT_N06A1301_020 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' What happens...to those who\ntrespass here!') -- FUT_N06A1301_021 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Come on out!\n Lairon!') -- FUT_N06A1301_022 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Lairon: Groooaaahh!') -- FUT_N06A1301_023 (FR optionnel)
        UI:ResetSpeaker()
        -- NON CONVERTI : bgm2_FadeOut (un seul canal BGM dans PMDO)
        pcall(function() SOUND:PlayBGM('Oh No!.ogg', true) end) -- OhNo
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5130') end) -- TODO SE 5130 (None)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        GAME:WaitFrames(6)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(2)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(4)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        pcall(function() SOUND:PlayBattleSE('SSB_SE_10247') end) -- TODO SE 10247 (None)
        -- object 451 (v38p03a1) : contexte objet
        local obj_451 = OBJ('v38p03a1') -- objet 451
        GROUND:ObjectSetAnim(obj_451, 21, 0, 3, Direction.Down, 1) -- anim 21 (table REQUISE)
        GAME:WaitFrames(6)
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(15)
        -- NON CONVERTI : SetEffect (acteur PLAYER_CHARMS)
        GAME:WaitFrames(4)
        -- NON CONVERTI : SetEffect (acteur NPC_CHAAREMU)
        GAME:WaitFrames(2)
        -- NON CONVERTI : SetEffect (acteur NPC_SAANAITO)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0.5, 0.5))
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 252, 256, false, 2.0)
        -- (parallèle) NPC_KODORA, PLAYER_CHARMS
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA)
            end,
            function()
                -- NON CONVERTI : SlidePositionOffset (acteur PLAYER_CHARMS)
                -- NON CONVERTI : Turn2Direction (acteur PLAYER_CHARMS)
            end,
        })
        GAME:WaitFrames(2)
        -- NON CONVERTI : SlidePositionOffset (acteur NPC_CHAAREMU)
        -- NON CONVERTI : Turn2Direction (acteur NPC_CHAAREMU)
        GAME:WaitFrames(2)
        -- NON CONVERTI : SlidePositionOffset (acteur NPC_SAANAITO)
        -- NON CONVERTI : Turn2Direction (acteur NPC_SAANAITO)
        GAME:WaitFrames(2)
        -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA2)
        -- (parallèle) NPC_KODORA, NPC_KODORA2, NPC_KODORA3
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : Turn2Direction (acteur NPC_KODORA)
            end,
            function()
                -- NON CONVERTI : Turn2Direction (acteur NPC_KODORA2)
            end,
            function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA3)
            end,
        })
        -- NON CONVERTI : Turn2Direction (acteur NPC_KODORA3)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5130') end) -- TODO SE 5130 (None)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        GAME:WaitFrames(6)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(2)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(4)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        pcall(function() SOUND:PlayBattleSE('SSB_SE_10247') end) -- TODO SE 10247 (None)
        -- object 450 (v38p06a1) : contexte objet
        local obj_450 = OBJ('v38p06a1') -- objet 450
        GROUND:ObjectSetAnim(obj_450, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        GAME:WaitFrames(6)
        -- supervision_cting layer [2] (structurel)
        GAME:WaitFrames(15)
        -- NON CONVERTI : SetEffect (acteur PLAYER_CHARMS)
        GAME:WaitFrames(4)
        -- NON CONVERTI : SetEffect (acteur NPC_CHAAREMU)
        GAME:WaitFrames(2)
        -- NON CONVERTI : SetEffect (acteur NPC_SAANAITO)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0.5, 0.5))
        -- (parallèle) NPC_KODORA4, PLAYER_CHARMS
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA4)
            end,
            function()
                -- NON CONVERTI : SlidePositionOffset (acteur PLAYER_CHARMS)
                -- NON CONVERTI : Turn2Direction (acteur PLAYER_CHARMS)
            end,
        })
        GAME:WaitFrames(2)
        -- NON CONVERTI : SlidePositionOffset (acteur NPC_CHAAREMU)
        -- NON CONVERTI : Turn2Direction (acteur NPC_CHAAREMU)
        GAME:WaitFrames(2)
        -- NON CONVERTI : SlidePositionOffset (acteur NPC_SAANAITO)
        -- NON CONVERTI : Turn2Direction (acteur NPC_SAANAITO)
        GAME:WaitFrames(2)
        -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA5)
        -- (parallèle) NPC_KODORA4, NPC_KODORA5, NPC_KODORA6
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : Turn2Direction (acteur NPC_KODORA4)
            end,
            function()
                -- NON CONVERTI : Turn2Direction (acteur NPC_KODORA5)
            end,
            function()
                -- NON CONVERTI : Move2PositionMark (acteur NPC_KODORA6)
            end,
        })
        -- NON CONVERTI : Turn2Direction (acteur NPC_KODORA6)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' GRAA-HAHAHAHA-HAHAHAHA!!\n\nGRAA-HAHAHAHA-HAHAHAHA-HAHAHAHA!!') -- FUT_N06A1301_024 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5130') end) -- TODO SE 5130 (None)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(2)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(4)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        pcall(function() SOUND:PlayBattleSE('SSB_SE_10247') end) -- TODO SE 10247 (None)
        -- supervision_cting layer [3] (structurel)
        -- (parallèle) NPC_BOSUGODORA, PLAYER_CHARMS
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetEffect (acteur PLAYER_CHARMS)
                -- NON CONVERTI : Turn2DirectionLives (acteur PLAYER_CHARMS)
                -- NON CONVERTI : SlidePositionOffset (acteur PLAYER_CHARMS)
            end,
            function()
                -- NON CONVERTI : SetAnimation (acteur NPC_BOSUGODORA)
                -- NON CONVERTI : SlidePositionMark (acteur NPC_BOSUGODORA)
            end,
        })
        GAME:WaitFrames(1)
        -- NON CONVERTI : SetEffect (acteur NPC_CHAAREMU)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_CHAAREMU)
        -- NON CONVERTI : SlidePositionOffset (acteur NPC_CHAAREMU)
        GAME:WaitFrames(1)
        -- NON CONVERTI : SetEffect (acteur NPC_SAANAITO)
        -- NON CONVERTI : Turn2DirectionLives (acteur NPC_SAANAITO)
        -- NON CONVERTI : SlidePositionOffset (acteur NPC_SAANAITO)
        GAME:WaitFrames(2)
        -- NON CONVERTI : WaitAnimation (acteur NPC_BOSUGODORA)
        -- NON CONVERTI : SetAnimation (acteur NPC_BOSUGODORA)
        GAME:WaitFrames(30)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We show no mercy to those who\ninvade our territory!') -- FUT_N06A1301_025 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' That\'s the law of this land!') -- FUT_N06A1301_026 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(60)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Huh?\n We apologize that\nwe wandered into your territory, but we\ndidn\'t know...') -- FUT_N06A1301_027 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' But regardless, don\'t you think\nit\'s a little unreasonable to attack us without\nlistening to our reason?') -- FUT_N06A1301_028 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Happy')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We haven\'t done anything to\nthis place...') -- FUT_N06A1301_029 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' And we don\'t intend to fight.') -- FUT_N06A1301_030 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- bgm_PlayFadeIn [165, 0, 256] : BGM TeamCharmsTheme non mappé
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Sigh')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' But...\n If you\'re going to insist\non fighting...') -- FUT_N06A1301_031 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Then we have no choice!\n\nWe\'ll be your opponents!') -- FUT_N06A1301_032 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Humph!\n You ladies are\nconsiderably cheerful!') -- FUT_N06A1301_033 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' However!') -- FUT_N06A1301_034 (FR optionnel)
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
        UI:WaitShowDialogue(' That composure...\n How long can\nyou keep it up?!') -- FUT_N06A1301_035 (FR optionnel)
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
        UI:WaitShowDialogue(' Let\'s go! Lairon!\n\nGet them!!') -- FUT_N06A1301_036 (FR optionnel)
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
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA)
            end,
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA5)
            end,
        })
        GAME:WaitFrames(3)
        -- (parallèle) NPC_KODORA3, NPC_KODORA4
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA3)
            end,
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA4)
            end,
        })
        GAME:WaitFrames(3)
        -- (parallèle) NPC_KODORA2, NPC_KODORA6
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA2)
            end,
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA6)
            end,
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Lairon: Groooaaahh!') -- FUT_N06A1301_037 (FR optionnel)
        GAME:WaitFrames(24)
        -- (parallèle) NPC_KODORA, NPC_KODORA5
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA)
            end,
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA5)
            end,
        })
        GAME:WaitFrames(3)
        -- (parallèle) NPC_KODORA2, NPC_KODORA4
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA4)
            end,
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA2)
            end,
        })
        GAME:WaitFrames(3)
        -- (parallèle) NPC_KODORA3, NPC_KODORA6
        TASK:JoinCoroutines({
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA3)
            end,
            function()
                -- NON CONVERTI : SetEffect (acteur NPC_KODORA6)
            end,
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
        UI:WaitShowDialogue(' Medicham! Lopunny!\nHere they come!') -- FUT_N06A1301_038 (FR optionnel)
        UI:SetCenter(false)
        -- NON CONVERTI : WaitAnimation (acteur NPC_SAANAITO)
        UI:ResetSpeaker()
        -- NON CONVERTI : SetAnimation (acteur NPC_CHAAREMU)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Anytime!') -- FUT_N06A1301_039 (FR optionnel)
        UI:SetCenter(false)
        -- NON CONVERTI : WaitAnimation (acteur NPC_CHAAREMU)
        UI:ResetSpeaker()
        -- NON CONVERTI : SetAnimation (acteur PLAYER_CHARMS)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' OK.\nLet\'s go! [M:H8]') -- FUT_N06A1301_040 (FR optionnel)
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
  if not ok then PrintInfo('[n06a1301] scène interrompue : '..tostring(err)) end
end

return n06a1301
