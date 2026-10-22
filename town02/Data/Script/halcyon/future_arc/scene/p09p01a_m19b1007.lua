--[[
    P09P01A_m19b1007.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P09P01A/m19b1007.ssb
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

local m19b1007 = {}

function m19b1007.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('Hidden Highland.ogg', true) end) -- HiddenHighland
        -- back_SetGround(P09P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- object 141 (p09p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p09p01a1', 1, 0, 3, Direction.Down, 1) -- objet 141, anim 1 (table REQUISE)
        -- performer 3
        -- SetEffect [640, 3] : performer 3 non mappé (PARTIEL)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ainsi, [hero] est devenu amnésique...') -- FUT_M19B1007_001 (FR)
        UI:WaitShowDialogue('et a été transformé en Pokémon...') -- FUT_M19B1007_002 (FR)
        UI:WaitShowDialogue('sans doute à cause de l\'accident survenu pendant votre voyage dans le temps...') -- FUT_M19B1007_003 (FR)
        UI:WaitShowDialogue('La perte de mémoire de [hero] a été un heureux hasard pour moi !') -- FUT_M19B1007_004 (FR)
        UI:WaitShowDialogue('Après tout, ton partenaire n\'a pas reconnu qui je suis.') -- FUT_M19B1007_005 (FR)
        UI:WaitShowDialogue('Il m\'a été très facile de gagner sa confiance.') -- FUT_M19B1007_006 (FR)
        UI:WaitShowDialogue('Et tout aussi facile de l\'entraîner dans le futur le moment venu !') -- FUT_M19B1007_007 (FR)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('TearyEyed')
        UI:WaitShowDialogue('Argh... Necrozma mentait vraiment !') -- FUT_M19B1007_008 (FR)
        -- case 7: ' Urk...[K] [CS:N]Dusknoir[CR] really was lying!'
        -- case 8: ' Urk...[K] [CS:N]Dusknoir[CR] really was lying!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Il ne me restait donc plus que toi, Massko...[br]la dernière partie du travail à achever.') -- FUT_M19B1007_009 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('............') -- FUT_M19B1007_010 (FR)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(180)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(J\'étais un humain du futur...?)') -- FUT_M19B1007_011 (FR)
        -- case 12: '(I was a human from the future...?)'
        UI:WaitShowDialogue('(Et j\'étais le partenaire de Massko, chargé avec lui d\'empêcher la Paralysie de la Planète ?)') -- FUT_M19B1007_012 (FR)
        -- case 14: "(And I was [CS:N]Grovyle[CR]'s partner on a mission to\nprevent the planet's paralysis?)"
        UI:WaitShowDialogue('(Et c\'est comme ça que j\'ai fini dans le monde de [partner] ?)') -- FUT_M19B1007_013 (FR)
        -- case 16: "(And that's how I ended up in [partner]'s\nworld?)"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Massko et [hero] ![br]Avec vous deux ici...') -- FUT_M19B1007_014 (FR)
        UI:WaitShowDialogue('Tout s\'achèvera lorsque nous nous serons enfin débarrassés de vous.') -- FUT_M19B1007_015 (FR)
        UI:WaitShowDialogue('Cela mettra enfin un terme à la lueur d\'espoir de Massko !') -- FUT_M19B1007_016 (FR)
        UI:WaitShowDialogue('Tout s\'achève ! Tout s\'achève pour vous ! Ha-ha-hoo-hoo-ha !') -- FUT_M19B1007_017 (FR)
        GROUND:CharSetAnim(CH('Necrozma'), 'Float', true) -- param 49 = anim 20 (Float)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(120)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('TearyEyed')
        UI:WaitShowDialogue('Urgh ! Necrozma... non...') -- FUT_M19B1007_018 (FR)
        -- case 22: ' Urgh! [CS:N]Dusknoir[CR]...[K]no...'
        -- case 23: ' Urgh! [CS:N]Dusknoir[CR]...[K]no...'
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- SetAnimation 2 (spécial : boucle anim courante)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('Necrozma !') -- FUT_M19B1007_019 (FR)
        -- case 25: ' [CS:N]Dusknoir[CR]!'
        -- case 26: ' [CS:N]Dusknoir[CR]!'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- PlanetsParalysis
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ha ! As-tu enfin accepté ton destin ?') -- FUT_M19B1007_020 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('M-Massko !') -- FUT_M19B1007_021 (FR)
        -- case 29: ' [CS:N]G-Grovyle[CR]!'
        -- case 30: ' [CS:N]G-Grovyle[CR]!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue('[hero] !') -- FUT_M19B1007_022 (FR)
        UI:SetCenter(false)
        -- case 32: ' [hero]!'
        -- case 33: ' [hero]!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Nous allons nous débarrasser de vous une fois pour toutes !') -- FUT_M19B1007_023 (FR)
        UI:WaitShowDialogue('C\'est la fin... pour vous !') -- FUT_M19B1007_024 (FR)
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hi-hi-hi !') -- FUT_M19B1007_025 (FR)
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        -- (parallèle) ATTENDANT1, NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 15)
            end),
        })
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + -8*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 8*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + -8*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 8*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + -8*8, false, 1.0)
        GAME:WaitFrames(15)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 15)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Urk...') -- FUT_M19B1007_026 (FR)
        -- case 38: ' Urk...'
        -- case 39: ' Urk...'
        UI:WaitShowDialogue('Hé, [hero] ! Massko ![br]N\'abandonnez pas !') -- FUT_M19B1007_027 (FR)
        -- case 41: " Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!"
        -- case 42: " Hey, [hero]! [CS:N]Grovyle[CR]![K]\nYou can't give up!"
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Argh... Tu nous dis de ne pas abandonner... ?') -- FUT_M19B1007_028 (FR)
        UI:WaitShowDialogue('Mais que pouvons-nous faire dans une situation aussi désespérée ?') -- FUT_M19B1007_029 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('Il faut réfléchir !') -- FUT_M19B1007_030 (FR)
        -- case 46: ' We have to think!'
        -- case 47: ' We have to think!'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) ATTENDANT1, NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + -8*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 8*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + -8*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 8*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + -8*8, false, 1.0)
        GAME:WaitFrames(30)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8965 (SE_NUM_EVENT_SIGN_NOTICE_02)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Je sais !') -- FUT_M19B1007_031 (FR)
        -- case 49: ' I know!'
        -- case 50: ' I know!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Celebi ! Ton pouvoir de voyage temporel peut-il nous transporter sur une courte distance dans le Passage du Temps ?') -- FUT_M19B1007_032 (FR)
        -- case 52: ' [CS:N]Celebi[CR]![K] Can your time travel\nability transport us just the short distance into\nthe Passage of Time?'
        -- case 53: ' [CS:N]Celebi[CR]![K] Can your time travel\nability transport us just the short distance into\nthe Passage of Time?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Down, 15)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ce ne sera pas facile avec Necrozma ici !') -- FUT_M19B1007_033 (FR)
        UI:WaitShowDialogue('Necrozma est le Pokémon Temporel... Il contrôle le temps lui-même !') -- FUT_M19B1007_034 (FR)
        UI:WaitShowDialogue('Même si je parviens à nous faire voyager dans le temps, il n\'aura aucun mal à repérer notre trajectoire !') -- FUT_M19B1007_035 (FR)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + -8*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 8*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + -8*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 8*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + -8*8, false, 1.0)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Même un tout petit peu suffira ! S\'il te plaît !') -- FUT_M19B1007_036 (FR)
        -- case 58: ' Even a little will do![K] Please!'
        -- case 59: ' It just has to work for an\ninstant![K] Please!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Attaque !') -- FUT_M19B1007_037 (FR)
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hi-hi-hi !') -- FUT_M19B1007_038 (FR)
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
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
                GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
        })
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est parti pour le voyage temporel !') -- FUT_M19B1007_039 (FR)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7435') end) -- TODO SE 7435 (SE_NUM_EVENT_MAIN19_LIGHT_04)
        -- supervision_cting layer [1] (structurel)
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
        GAME:WaitFrames(4)
        GAME:FadeOut(true, 15)
        pcall(function() GROUND:Hide(CH('Grovyle').EntName) end)
        pcall(function() GROUND:Hide(CH('Celebi').EntName) end)
        pcall(function() GROUND:Hide(CH('PLAYER').EntName) end)
        pcall(function() GROUND:Hide(CH('Teammate1').EntName) end)
        -- supervision_emoveActing layer [1] (structurel)
        GAME:WaitFrames(60)
        GAME:FadeIn(15)
        -- PARTIEL : WaitSe [7435]
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, NPC_YONOWAARU
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharSetEmote(CH('Sableye_1'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharSetEmote(CH('Sableye_2'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharSetEmote(CH('Sableye_3'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharSetEmote(CH('Sableye_4'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharSetEmote(CH('Sableye_6'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Necrozma'), 'exclaim', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end),
        })
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hi-hi-hi... ?') -- FUT_M19B1007_040 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8963') end) -- TODO SE 8963 (SE_NUM_EVENT_SIGN_HATENA_03)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(7)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(2)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(3)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(5)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(4)
        -- ExecuteCommon(LOOK_AROUND_DOWN_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ils ont d-disparu ?') -- FUT_M19B1007_041 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Necrozma'), Direction.Up, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Maître Necrozma !') -- FUT_M19B1007_042 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GAME:FadeOut(false, 15)
        GAME:WaitFrames(30)
        -- PARTIEL : back2_SetMode [4]
        -- back2_SetGround(V14P01A) : couche décor (overlay scène, adaptation)
        -- camera2_SetPositionMark [2, 2, 19, 17] : PARTIEL
        -- supervision_cting layer [3] (structurel)
        -- object 265 (v15p01a2) : contexte objet
        FutureScene.ObjectSetAnim('v15p01a2', 1, 0, 3, Direction.Down, 1) -- objet 265, anim 1 (table REQUISE)
        -- screen2_FadeIn [1, 15] : couche décor (overlay scène, adaptation)
        -- object 265 (v15p01a2) : contexte objet
        FutureScene.ObjectSetAnim('v15p01a2', 20, 0, 3, Direction.Down, 1) -- objet 265, anim 20 (table REQUISE)
        -- object 265 (v15p01a2) : contexte objet
        -- WaitAnimation sur objet v15p01a2 : PARTIEL
        -- object 265 (v15p01a2) : contexte objet
        FutureScene.ObjectSetAnim('v15p01a2', 18, 0, 3, Direction.Down, 1) -- objet 265, anim 18 (table REQUISE)
        -- object 265 (v15p01a2) : contexte objet
        -- WaitAnimation sur objet v15p01a2 : PARTIEL
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        -- object 265 (v15p01a2) : contexte objet
        FutureScene.ObjectSetAnim('v15p01a2', 3, 0, 3, Direction.Down, 1) -- objet 265, anim 3 (table REQUISE)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6930') end) -- TODO SE 6930 (SE_NUM_EVENT_MAIN10_HOUKOU)
        -- message_ImitationSound : PARTIEL
        -- PARTIEL : WaitSe [6930]
        -- screen2_FadeOut [1, 15] : couche décor (overlay scène, adaptation)
        UI:ResetSpeaker()
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        -- supervision_emoveActing layer [3] (structurel)
        -- back2_SetGround(V14P03A) : couche décor (overlay scène, adaptation)
        -- PARTIEL : back2_SetEffect [7, 0]
        -- camera2_SetPositionMark [2, 2, 19, 18] : PARTIEL
        -- screen2_FadeIn [1, 15] : couche décor (overlay scène, adaptation)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7437') end) -- TODO SE 7437 (SE_NUM_EVENT_MAIN19_WING)
        -- camera2_SetPositionMark [2, 2, 58, 18] : PARTIEL
        GAME:WaitFrames(4)
        -- camera2_SetPositionMark [2, 2, 97, 18] : PARTIEL
        GAME:WaitFrames(180)
        -- PARTIEL : se_FadeOut [7437, 60]
        -- screen2_FadeOut [1, 15] : couche décor (overlay scène, adaptation)
        -- back2_SetGround(V14P04A) : couche décor (overlay scène, adaptation)
        -- PARTIEL : back2_SetEffect [9, 0]
        -- camera2_SetPositionMark [2, 2, 19, 13] : PARTIEL
        -- supervision_cting layer [2] (structurel)
        -- object 268 (v15p01a3) : contexte objet
        FutureScene.ObjectSetAnim('v15p01a3', 9, 0, 3, Direction.Down, 1) -- objet 268, anim 9 (table REQUISE)
        -- screen2_FadeIn [1, 15] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7448') end) -- TODO SE 7448 (SE_NUM_EVENT_MAIN19_LIGHT_06)
        -- object 268 (v15p01a3) : contexte objet
        FutureScene.ObjectSetAnim('v15p01a3', 17, 0, 3, Direction.Down, 1) -- objet 268, anim 17 (table REQUISE)
        -- PARTIEL : back2_SetEffect [7, 60]
        -- PARTIEL : WaitSe [7448]
        -- screen2_FadeOut [1, 15] : couche décor (overlay scène, adaptation)
        -- supervision_emoveActing layer [2] (structurel)
        -- back2_SetGround(V14P01A) : couche décor (overlay scène, adaptation)
        -- camera2_SetPositionMark [2, 2, 19, 17] : PARTIEL
        -- supervision_cting layer [3] (structurel)
        -- object 265 (v15p01a2) : contexte objet
        FutureScene.ObjectSetAnim('v15p01a2', 1, 0, 3, Direction.Down, 1) -- objet 265, anim 1 (table REQUISE)
        -- object 265 (v15p01a2) : contexte objet
        -- SetOutputAttribute sur objet v15p01a2 : PARTIEL
        -- object 265 (v15p01a2) : contexte objet
        -- NON CONVERTI : SetPositionMark sur objet v15p01a2
        -- screen2_FadeIn [1, 15] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(30)
        -- object 265 (v15p01a2) : contexte objet
        FutureScene.ObjectSetAnim('v15p01a2', 18, 0, 3, Direction.Down, 1) -- objet 265, anim 18 (table REQUISE)
        -- object 265 (v15p01a2) : contexte objet
        -- WaitAnimation sur objet v15p01a2 : PARTIEL
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        -- object 265 (v15p01a2) : contexte objet
        FutureScene.ObjectSetAnim('v15p01a2', 3, 0, 3, Direction.Down, 1) -- objet 265, anim 3 (table REQUISE)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6930') end) -- TODO SE 6930 (SE_NUM_EVENT_MAIN10_HOUKOU)
        -- message_ImitationSound : PARTIEL
        pcall(function() SOUND:PlayBGM('Rising Fear.ogg', true) end) -- StrongBlastNoise
        -- screen2_WhiteOut [1, 2] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(2)
        -- screen2_FadeIn [1, 2] : couche décor (overlay scène, adaptation)
        -- camera2_SetPositionMark [2, 2, 58, 17] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 97, 17] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 19, 47] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 58, 47] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 97, 47] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 19, 77] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 58, 77] : PARTIEL
        GAME:WaitFrames(2)
        -- camera2_SetPositionMark [2, 2, 97, 77] : PARTIEL
        GAME:WaitFrames(2)
        -- screen2_WhiteOut [1, 15] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(60)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        SOUND:FadeOutBGM(60)
        GAME:FadeOut(false, 15)
        UI:ResetSpeaker()
        GAME:FadeOut(false, 0)
        GAME:FadeIn(0)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m19b1007] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m19b1007
