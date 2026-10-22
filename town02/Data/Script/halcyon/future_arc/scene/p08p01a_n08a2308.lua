--[[
    P08P01A_n08a2308.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/n08a2308.ssb
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

local n08a2308 = {}

function n08a2308.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        SV.Scenario.Side = 47 -- flag_SetScenario(SCENARIO_SIDE, scenario=47, level=10)
        -- PARTIEL : back_SetDungeonBanner [140, 0] (bannière)
        GAME:FadeIn(16)
        GAME:WaitFrames(60)
        GAME:FadeOut(false, 16)
        GAME:WaitFrames(15)
        -- back_SetGround(P08P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        GAME:WaitFrames(30)
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('HeroFuture'), 296, 308, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Dusknoir'), 252, 340, false, 2.0)
            end),
        })
        GAME:WaitFrames(15)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(20)
        GROUND:CharTurnToChar(CH('Dusknoir'), CH('HeroFuture'))
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Is this it, Grovyle?') -- FUT_N08A2308_001 (FR optionnel)
        UI:WaitShowDialogue(' The place you met Celebi?') -- FUT_N08A2308_002 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('HeroFuture'), CH('Dusknoir'))
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Yeah, that\'s right.') -- FUT_N08A2308_003 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...\nIt\'s quiet...') -- FUT_N08A2308_004 (FR optionnel)
        UI:WaitShowDialogue(' Was she already captured...\n\nWas she already taken away...') -- FUT_N08A2308_005 (FR optionnel)
        UI:WaitShowDialogue(' Or maybe she sensed danger and\nran away from here...') -- FUT_N08A2308_006 (FR optionnel)
        UI:WaitShowDialogue(' It\'s possible she\noutwitted them...') -- FUT_N08A2308_007 (FR optionnel)
        UI:WaitShowDialogue(' Maybe she\'s still hiding\nsomewhere nearby...') -- FUT_N08A2308_008 (FR optionnel)
        UI:WaitShowDialogue(' Could be any one of those...') -- FUT_N08A2308_009 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...\n (There\'s something strange\nabout the air here...)') -- FUT_N08A2308_010 (FR optionnel)
        UI:WaitShowDialogue(' (Celebi...\n\nShe probably left already...)') -- FUT_N08A2308_011 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(30)
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Sableye: Wheh-heh-heh!') -- FUT_N08A2308_012 (FR optionnel)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('HeroFuture'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Dusknoir'), 'exclaim', 3)
            end),
        })
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Up, 15)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6420') end) -- TODO SE 6420 (SE_NUM_EVENT_MAIN03_JUPUTORU_01_L)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_1'), 224, 292, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), 276, 268, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), 332, 292, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), 224, 348, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), 276, 372, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_6'), 332, 348, false, 3.0)
            end),
        })
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBGM('Growing Anxiety.ogg', true) end) -- OhNo
        GROUND:CharSetAnim(CH('HeroFuture'), 'Walk', true) -- param 5 = anim 0 (Walk)
        GROUND:AnimateToPosition(CH('HeroFuture'), 276, 308, false, 2.0)
        GAME:WaitFrames(5)
        GROUND:CharSetAnim(CH('Dusknoir'), 'Walk', true) -- param 5 = anim 0 (Walk)
        GROUND:AnimateToPosition(CH('Dusknoir'), 276, 340, false, 2.0)
        -- SetAnimation 2 (spécial : boucle anim courante)
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Up, 15)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YONOWAARU_N8
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.DownLeft, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.UpRight, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.DownRight, 15)
            end),
        })
        -- PARTIEL : se_FadeOut [6420, 30]
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.UpLeft, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end),
        })
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' I knew it...') -- FUT_N08A2308_013 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' They brought me right into\ntheir trap!') -- FUT_N08A2308_014 (FR optionnel)
        UI:WaitShowDialogue(' Humph. Dusknoir!\n Necrozma\'s\nnew henchman...') -- FUT_N08A2308_015 (FR optionnel)
        UI:WaitShowDialogue(' Is just as crafty and\nwicked as you are!') -- FUT_N08A2308_016 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' I am Master Necrozma\'s\nonly henchman!') -- FUT_N08A2308_017 (FR optionnel)
        UI:WaitShowDialogue(' I can\'t allow anyone to take\nmy place!') -- FUT_N08A2308_018 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Here they come!') -- FUT_N08A2308_019 (FR optionnel)
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Sableye: Wheh-heh-heh!') -- FUT_N08A2308_020 (FR optionnel)
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
        })
        UI:ResetSpeaker()
        GROUND:CharSetAnim(CH('Sableye_1'), 'Attack', false) -- param 12 = anim 2 (Attack)
        GAME:WaitFrames(2)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Attack', false) -- param 12 = anim 2 (Attack)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Attack', false) -- param 12 = anim 2 (Attack)
            end),
        })
        GAME:WaitFrames(2)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Attack', false) -- param 12 = anim 2 (Attack)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Attack', false) -- param 12 = anim 2 (Attack)
            end),
        })
        GAME:WaitFrames(2)
        GROUND:CharSetAnim(CH('Sableye_6'), 'Attack', false) -- param 12 = anim 2 (Attack)
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 5143 (SE_NUM_EVENT_EFF_FLASH_HEAVY)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        GAME:WaitFrames(10)
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 5143 (SE_NUM_EVENT_EFF_FLASH_HEAVY)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        -- PARTIEL : WaitSe [5143]
        SOUND:FadeOutBGM(30)
        -- CallCommon(BOSS_WIPE_FUNC) : helper à implémenter
        -- main_EnterDungeon(140) : entrée donjon (mapping id REQUIS)
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[n08a2308] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return n08a2308
