--[[
    D18P11A_m17a0504.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D18P11A/m17a0504.ssb
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

local m17a0504 = {}

function m17a0504.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        SV.Scenario.Main = 18 -- flag_SetScenario(SCENARIO_MAIN, scenario=18, level=3)
        -- back_SetGround(D18P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('La Paralysie de la Planète...') -- FUT_M17A0504_001 (FR)
        -- case 0: " The planet's paralysis..."
        -- case 1: " The planet's paralysis..."
        UI:WaitShowDialogue('C\'est vrai : cet endroit ressemble exactement à ce que Noctunoir nous avait décrit.') -- FUT_M17A0504_002 (FR)
        -- case 3: " It's true that this place appears\njust like [CS:N]Dusknoir[CR] described it."
        -- case 4: " Sure, this place resembles\n[CS:N]Dusknoir[CR]'s description."
        UI:WaitShowDialogue('Mais tout de même...') -- FUT_M17A0504_003 (FR)
        -- case 6: ' But even then...'
        -- case 7: ' But even then...'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
        GAME:WaitFrames(15)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        UI:SetCenter(true)
        UI:WaitShowDialogue('J\'ai du mal à comprendre pourquoi la planète est paralysée dans le futur.') -- FUT_M17A0504_004 (FR)
        UI:SetCenter(false)
        -- case 9: " It's hard to understand how the\nplanet has been paralyzed in the future."
        -- case 10: " It's hard to understand how the\nplanet has been paralyzed in the future."
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 15)
            end),
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Libre à vous de croire... ou de rejeter... ce que je vous dis.') -- FUT_M17A0504_005 (FR)
        UI:WaitShowDialogue('De toute façon, je vous suggère de partir dès que possible.') -- FUT_M17A0504_006 (FR)
        UI:WaitShowDialogue('J\'y vais. Ne laissez pas ces Ténéfix vous attraper.') -- FUT_M17A0504_007 (FR)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 388, 140, false, 1.594)
        GAME:WaitFrames(10)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Right, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
            end),
        })
        pcall(function() GROUND:Hide(CH('Grovyle').EntName) end)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Urk... [hero].') -- FUT_M17A0504_008 (FR)
        -- case 15: ' Urk... [hero].'
        -- case 16: ' Urk... [hero].'
        UI:WaitShowDialogue('Je ne sais plus quoi penser.') -- FUT_M17A0504_009 (FR)
        -- case 18: " I don't know what to think\nanymore."
        -- case 19: " I don't know what to think\nanymore."
        UI:WaitShowDialogue('La Paralysie de la Planète n\'était-elle pas censée être provoquée par la disparition des Rouages du Temps ?') -- FUT_M17A0504_010 (FR)
        -- case 21: " Wasn't the planet's paralysis\nsupposed to be caused by all those Time Gears\ngoing missing?"
        -- case 22: " Wasn't the planet's paralysis\nsupposed to be caused by all those Time Gears\ngoing missing?"
        UI:WaitShowDialogue('C\'est pourquoi nous avons tous essayé d\'empêcher Massko de voler les Rouages du Temps.') -- FUT_M17A0504_011 (FR)
        -- case 24: " That's why we all tried to stop\n[CS:N]Grovyle[CR] from stealing the Time Gears."
        -- case 25: " That's why we all tried to stop\n[CS:N]Grovyle[CR] from stealing the Time Gears."
        UI:WaitShowDialogue('Nous avons fait tout ce que nous étions censés faire, non ?') -- FUT_M17A0504_012 (FR)
        -- case 27: ' We did everything we were\nsupposed to, right?'
        -- case 28: ' We did everything we were\nsupposed to, right?'
        UI:WaitShowDialogue('Uxie et les autres ont dit qu\'ils remettraient les Rouages du Temps à leur place.') -- FUT_M17A0504_013 (FR)
        -- case 30: " [CS:N]Uxie[CR] and the others said they'd\nreturn the Time Gears to their rightful places."
        -- case 31: ' [CS:N]Uxie[CR] and the others said they\nwould return the recaptured Time Gears to\ntheir rightful places.'
        UI:WaitShowDialogue('C\'était censé empêcher la Paralysie de la Planète !') -- FUT_M17A0504_014 (FR)
        -- case 33: " That was supposed to prevent\nthe planet's paralysis!"
        -- case 34: " That should have prevented the\nplanet's paralysis!"
        UI:WaitShowDialogue('Mais malgré tous nos efforts...') -- FUT_M17A0504_015 (FR)
        -- case 36: ' But despite all our efforts...'
        -- case 37: ' But despite all our efforts...'
        UI:WaitShowDialogue('Alors pourquoi la planète est-elle encore paralysée... dans notre avenir ?') -- FUT_M17A0504_016 (FR)
        -- case 39: ' Why is the planet still\nparalyzed...[K]in our future?'
        -- case 40: ' Why is the planet still\nparalyzed...[K]in our future?'
        UI:ResetSpeaker()
        -- ExecuteCommon(HEAD_SHAKE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Arrgh ! Je ne sais plus qui croire ni quoi penser !') -- FUT_M17A0504_017 (FR)
        -- case 42: " Arrgh! I don't know who or what\nto believe anymore!"
        -- case 43: " Arrgh! I don't know who or what\nto believe anymore!"
        UI:ResetSpeaker()
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Hi-hi-hi !') -- FUT_M17A0504_018 (FR)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(30)
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
            end),
        })
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Waah ! Les Ténéfix !') -- FUT_M17A0504_019 (FR)
        -- case 46: ' Waah! The [CS:N]Sableye[CR]!'
        -- case 47: ' Waah! The [CS:N]Sableye[CR]!'
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('On ne peut pas rester ici, [hero] !') -- FUT_M17A0504_020 (FR)
        -- case 49: " We can't stick around here,\n[hero]!"
        -- case 50: " We can't stay here,\n[hero]!"
        UI:WaitShowDialogue('Préparons-nous vite et repartons !') -- FUT_M17A0504_021 (FR)
        -- case 52: " Let's get ready quickly so we\ncan get rolling!"
        -- case 53: " Let's get ready quickly so we\ncan get moving!"
        UI:ResetSpeaker()
        -- bgm_PlayFadeIn [39, 0, 256] : BGM ChasmCave non mappé
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m17a0504] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m17a0504
