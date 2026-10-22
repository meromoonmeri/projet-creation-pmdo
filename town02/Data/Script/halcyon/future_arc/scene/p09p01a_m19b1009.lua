--[[
    P09P01A_m19b1009.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P09P01A/m19b1009.ssb
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

local m19b1009 = {}

function m19b1009.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- back_SetGround(P09P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- performer 3
        -- SetEffect [640, 3] : performer 3 non mappé (PARTIEL)
        GAME:FadeIn(15)
        -- object 141 (p09p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p09p01a1', 18, 0, 3, Direction.Down, 1) -- objet 141, anim 18 (table REQUISE)
        -- object 141 (p09p01a1) : contexte objet
        -- WaitAnimation sur objet p09p01a1 : PARTIEL
        -- object 141 (p09p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p09p01a1', 3, 0, 3, Direction.Down, 1) -- objet 141, anim 3 (table REQUISE)
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
            end),
        })
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.UpRight, 15)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpRight, 15)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.UpLeft, 15)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 15)
        pcall(function() SOUND:PlayBGM('Growing Anxiety.ogg', true) end) -- OhNo
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Argh ! Notre voie temporelle a été brisée !') -- FUT_M19B1009_001 (FR)
        -- case 0: ' Ack! Our time-traveling path has\nbeen shattered!'
        -- case 1: ' Ack! Our time-traveling path has\nbeen shattered!'
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 364, false, 4.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, NPC_YONOWAARU
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Necrozma'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
            end),
        })
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('Necrozma'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Les voilà !') -- FUT_M19B1009_002 (FR)
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 276, false, 4.0)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Down, 15)
            end),
        })
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Nous étions si près du Passage du Temps !') -- FUT_M19B1009_003 (FR)
        -- case 4: ' We got so close to the Passage\nof Time!'
        -- case 5: ' We almost made it to the\nPassage of Time!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownRight, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end),
        })
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Plongez maintenant ! Vous pouvez y arriver !') -- FUT_M19B1009_004 (FR)
        UI:WaitShowDialogue('Vite ! Dans le Passage du Temps !') -- FUT_M19B1009_005 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('M-mais et toi, Celebi ?!') -- FUT_M19B1009_006 (FR)
        -- case 9: ' Wh-what about you, [CS:N]Celebi[CR]?!'
        -- case 10: ' Wh-what about you, [CS:N]Celebi[CR]?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ne t\'en fais pas pour moi ! Je t\'ai dit que j\'étais insaisissable !') -- FUT_M19B1009_007 (FR)
        UI:WaitShowDialogue('Arrêtez la Paralysie de la Planète...[br]Changez le cours de l\'histoire !') -- FUT_M19B1009_008 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Merci !') -- FUT_M19B1009_009 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Merci, Celebi !') -- FUT_M19B1009_010 (FR)
        -- case 15: ' Thanks, [CS:N]Celebi[CR]!'
        -- case 16: ' Thank you, [CS:N]Celebi[CR]!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Vous ne vous échapperez pas !') -- FUT_M19B1009_011 (FR)
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 300, false, 2.0)
        -- (parallèle) NPC_JUPUTORU, NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, NPC_YONOWAARU
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Necrozma'), 300, 316, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_1'), 268, 284, false, 2.398)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), 332, 284, false, 2.398)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), 252, 300, false, 2.398)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), 348, 300, false, 2.398)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), 252, 324, false, 2.398)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_6'), 348, 324, false, 2.398)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Grovyle'), 300, 228, false, 2.0)
            end),
        })
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 300, 228, false, 2.0)
        GAME:WaitFrames(15)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), 300, 228, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Grovyle'), 'DeepBreath', false) -- param 30 = anim 21 (DeepBreath)
                pcall(function() GROUND:CharWaitAnim(CH('Grovyle')) end)
            end),
        })
        pcall(function() GROUND:Hide(CH('Grovyle').EntName) end)
        GROUND:CharSetAnim(CH('PLAYER'), 'LeapForth', false) -- param 77 = anim 28 (LeapForth)
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        pcall(function() GROUND:Hide(CH('PLAYER').EntName) end)
        GROUND:CharSetAnim(CH('Teammate1'), 'LeapForth', false) -- param 77 = anim 28 (LeapForth)
        pcall(function() GROUND:CharWaitAnim(CH('Teammate1')) end)
        pcall(function() GROUND:Hide(CH('Teammate1').EntName) end)
        -- (parallèle) NPC_SEREBII, NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                CH('Sableye_1').Direction = Direction.UpRight
            end),
            TASK:BranchCoroutine(function()
                CH('Sableye_2').Direction = Direction.UpLeft
            end),
            TASK:BranchCoroutine(function()
                CH('Sableye_3').Direction = Direction.UpRight
            end),
            TASK:BranchCoroutine(function()
                CH('Sableye_4').Direction = Direction.UpLeft
            end),
            TASK:BranchCoroutine(function()
                CH('Sableye_5').Direction = Direction.UpRight
            end),
            TASK:BranchCoroutine(function()
                CH('Sableye_6').Direction = Direction.UpLeft
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Down, 15)
            end),
        })
        SOUND:FadeOutBGM(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7435') end) -- TODO SE 7435 (SE_NUM_EVENT_MAIN19_LIGHT_04)
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(10)
        GAME:FadeOut(true, 15)
        -- PARTIEL : WaitSe [7435]
        pcall(function() GROUND:Hide(CH('Celebi').EntName) end)
        -- supervision_emoveActing layer [1] (structurel)
        -- object 141 (p09p01a1) : contexte objet
        pcall(function() GROUND:Hide(CH('Celebi').EntName) end)
        -- performer 3
        -- SetEffect [0, 3] : performer 3 non mappé (PARTIEL)
        -- performer 4
        -- SetEffect [651, 3] : performer 4 non mappé (PARTIEL)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7439') end) -- TODO SE 7439 (SE_NUM_EVENT_MAIN19_LIGHT_05)
        GAME:WaitFrames(80)
        GAME:FadeIn(15)
        -- PARTIEL : WaitSe [7439]
        pcall(function() SOUND:PlayBGM('Rising Fear.ogg', true) end) -- AnotherStaticNoise
        GAME:WaitFrames(30)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, NPC_YONOWAARU
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Necrozma'), 'exclaim', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_1'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_2'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_3'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_4'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_6'), 'shock', 3)
            end),
        })
        GAME:WaitFrames(70)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Gah...') -- FUT_M19B1009_012 (FR)
        UI:ResetSpeaker()
        GAME:WaitFrames(60)
        SOUND:FadeOutBGM(120)
        GAME:FadeOut(false, 90)
        -- WaitBgm : PARTIEL
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m19b1009] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m19b1009
