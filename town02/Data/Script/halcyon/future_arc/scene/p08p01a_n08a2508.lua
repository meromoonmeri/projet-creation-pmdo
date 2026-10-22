--[[
    P08P01A_n08a2508.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/n08a2508.ssb
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

local n08a2508 = {}

function n08a2508.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
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
        pcall(function() SOUND:PlayBGM('Growing Anxiety.ogg', true) end) -- OhNo
        GAME:WaitFrames(30)
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
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
        UI:WaitShowDialogue('Sableye: Wheh-heh-heh!') -- FUT_N08A2508_001 (FR optionnel)
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
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Grovyle!\n You can\'t fail\nthis time!') -- FUT_N08A2508_002 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Humph!\n I should say the\nsame thing!') -- FUT_N08A2508_003 (FR optionnel)
        UI:WaitShowDialogue(' Let\'s go!') -- FUT_N08A2508_004 (FR optionnel)
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
    PrintInfo('[n08a2508] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return n08a2508
