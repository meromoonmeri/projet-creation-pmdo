--[[
    P09P01A_m19b1001.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P09P01A/m19b1001.ssb
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

local m19b1001 = {}

function m19b1001.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Oh ! Je le vois maintenant !') -- FUT_M19B1001_001 (FR)
        UI:WaitShowDialogue('Le voilà !') -- FUT_M19B1001_002 (FR)
        UI:ResetSpeaker()
        GAME:FadeOut(false, 0)
        GAME:FadeIn(0)
        -- back_SetGround(P09P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- object 141 (p09p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p09p01a1', 1, 0, 3, Direction.Down, 1) -- objet 141, anim 1 (table REQUISE)
        -- performer 3
        -- SetEffect [640, 3] : performer 3 non mappé (PARTIEL)
        GAME:FadeIn(30)
        pcall(function() SOUND:PlayBGM('Time Gear Remix.ogg', true) end) -- TimeGearRemix
        GAME:WaitFrames(90)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 416, false, 2.0)
        GROUND:MoveToPosition(CH('Celebi'), 284, 404, false, 2.0)
        GAME:WaitFrames(20)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Grovyle'), 316, 404, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), 280, 428, false, 2.0)
            end),
        })
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 324, 428, false, 2.0)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est... le Passage du Temps ?') -- FUT_M19B1001_003 (FR)
        -- case 2: ' Is that...[K]the Passage of Time?'
        -- case 3: ' Is that...[K]the Passage of Time?'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        -- (parallèle) ATTENDANT1, NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Celebi'), CH('Teammate1'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
            end),
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est vrai. C\'est le Passage du Temps.') -- FUT_M19B1001_004 (FR)
        UI:WaitShowDialogue('Je l\'ai déjà emprunté.') -- FUT_M19B1001_005 (FR)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        UI:SetCenter(true)
        UI:WaitShowDialogue('Celebi, toi seule peux ouvrir le Passage du Temps.') -- FUT_M19B1001_006 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('À toi de jouer.') -- FUT_M19B1001_007 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Bien sûr.') -- FUT_M19B1001_008 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
        GROUND:MoveToPosition(CH('Celebi'), CH('Celebi').Position.X + 0.7969*8, CH('Celebi').Position.Y + 0*8, false, 1.594)
        SOUND:FadeOutBGM(30)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end),
        })
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('Halte ! Vous n\'irez pas plus loin !') -- FUT_M19B1001_009 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Quoi ? Cette voix !') -- FUT_M19B1001_010 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('C-ce n\'est pas possible...') -- FUT_M19B1001_011 (FR)
        -- case 12: " It... It can't be..."
        -- case 13: " It... It can't be..."
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('Bonjour à tous. Ça fait un moment.') -- FUT_M19B1001_012 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
            end),
        })
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(1)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 308, false, 3.0)
        pcall(function() SOUND:PlayBGM('The Power of Darkness.ogg', true) end) -- ThePowerOfDarkness
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('N-Necrozma !') -- FUT_M19B1001_013 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Necrozma...') -- FUT_M19B1001_014 (FR)
        -- case 17: ' [CS:N]Dusknoir[CR]...'
        -- case 18: ' [CS:N]Dusknoir[CR]...'
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 416, false, 1.0)
        GROUND:MoveToPosition(CH('Necrozma'), 300, 348, false, 1.0)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Votre fuite vous a menés loin...') -- FUT_M19B1001_015 (FR)
        UI:WaitShowDialogue('Mais j\'ai le regret de vous l\'annoncer... elle s\'achève ici.') -- FUT_M19B1001_016 (FR)
        UI:ResetSpeaker()
        GROUND:CharSetAnim(CH('Celebi'), 'Walk', true) -- param 5 = anim 0 (Walk)
        GROUND:AnimateToPosition(CH('Celebi'), CH('Celebi').Position.X + 1*8, CH('Celebi').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Grovyle'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:AnimateToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 0*8, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('PLAYER'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 0*8, false, 2.0)
            end),
        })
        GAME:WaitFrames(5)
        GROUND:CharSetAnim(CH('Teammate1'), 'Walk', true) -- param 5 = anim 0 (Walk)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 0*8, false, 2.0)
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        -- SetAnimation 2 (spécial : boucle anim courante)
        -- SetAnimation 2 (spécial : boucle anim courante)
        -- supervision_cting layer [2] (structurel)
        GAME:WaitFrames(1)
UI:SetSpeaker(CH('Sableye_1'))
        UI:WaitShowDialogue('Hi-hi-hi !') -- FUT_M19B1001_017 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII, NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_1'), 216, 364, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), 384, 364, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), 204, 396, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), 396, 396, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), 208, 428, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_6'), 392, 428, false, 3.0)
            end),
        })
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(12)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(7)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(5)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Les Ténéfix aussi...') -- FUT_M19B1001_018 (FR)
        -- case 23: ' The [CS:N]Sableye[CR] too...'
        -- case 24: ' The [CS:N]Sableye[CR] too...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Bien joué, Necrozma.') -- FUT_M19B1001_019 (FR)
        UI:WaitShowDialogue('Tu as fait semblant de nous laisser fuir... tout en nous gardant à l\'œil.') -- FUT_M19B1001_020 (FR)
        UI:WaitShowDialogue('Afin de capturer Celebi avec nous.') -- FUT_M19B1001_021 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8973 (SE_NUM_EVENT_SIGN_SHOCK_03)
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi ?!') -- FUT_M19B1001_022 (FR)
        -- case 29: ' What?![K] So you mean we were...'
        -- case 30: ' What?![K] So you mean we were...'
        UI:WaitShowDialogue('Alors nous avons été suivis depuis le début ?!') -- FUT_M19B1001_023 (FR)
        -- case 32: ' followed the whole time?!'
        -- case 33: ' followed the whole time?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hmpf. Je ne l\'avais pas prévu.') -- FUT_M19B1001_024 (FR)
        UI:WaitShowDialogue('C\'est de ma faute, Celebi.') -- FUT_M19B1001_025 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Oh ? Les excuses ne te ressemblent pas, mon cher Massko !') -- FUT_M19B1001_026 (FR)
        UI:WaitShowDialogue('Et tu crois vraiment pouvoir me capturer ? Hi-hi !') -- FUT_M19B1001_027 (FR)
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
        -- (parallèle) NPC_JUPUTORU, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + -8*8, false, 1.0)
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Left, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Right, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Grovyle'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:AnimateToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 0.5*8, CH('Grovyle').Position.Y + -8*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Celebi'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:AnimateToPosition(CH('Celebi'), CH('Celebi').Position.X + 0.5*8, CH('Celebi').Position.Y + 8*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('PLAYER'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 0.5*8, CH('PLAYER').Position.Y + -8*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        GROUND:CharSetAnim(CH('Teammate1'), 'Walk', true) -- param 5 = anim 0 (Walk)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 0.5*8, CH('Teammate1').Position.Y + 8*8, false, 1.0)
        -- SetAnimation 2 (spécial : boucle anim courante)
        -- (parallèle) NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        -- SetAnimation 2 (spécial : boucle anim courante)
        GAME:WaitFrames(10)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Tout le monde ! Prêts à vous battre ?') -- FUT_M19B1001_028 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Et comment !') -- FUT_M19B1001_029 (FR)
        -- case 40: ' Huh?![K] You bet I am!'
        -- case 41: ' What?![K] Of course!'
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Nous allons nous frayer un passage !') -- FUT_M19B1001_030 (FR)
        UI:WaitShowDialogue('Nous allons les repousser...[br]puis plonger dans le Passage du Temps !') -- FUT_M19B1001_031 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('C-compris !') -- FUT_M19B1001_032 (FR)
        -- case 45: ' G-got it!'
        -- case 46: ' G-got it!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Right, 15)
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Vous comptez résister ?') -- FUT_M19B1001_033 (FR)
        UI:WaitShowDialogue('Épargnez-vous cette peine.[br]Vous n\'avez aucune chance de réussir.') -- FUT_M19B1001_034 (FR)
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
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('On n\'en saura rien avant d\'essayer !') -- FUT_M19B1001_035 (FR)
        UI:WaitShowDialogue('Necrozma ! Toi contre moi ! Maintenant !') -- FUT_M19B1001_036 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Massko. Me pensais-tu assez fou pour venir seul ?') -- FUT_M19B1001_037 (FR)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Qu-quoi ?!') -- FUT_M19B1001_038 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        GAME:WaitFrames(5)
        -- (parallèle) ATTENDANT1, NPC_SEREBII, NPC_YONOWAARU
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Necrozma'), Direction.Up, 15)
            end),
        })
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Maintenant, Maître Necrozma !') -- FUT_M19B1001_039 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7434') end) -- TODO SE 7434 (SE_NUM_EVENT_MAIN19_DARK)
        GAME:FadeOut(false, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Il fait tout noir !') -- FUT_M19B1001_040 (FR)
        -- case 55: ' Whoa![K] It turned pitch black!'
        -- case 56: ' Waah![K] It turned pitch black!'
        UI:ResetSpeaker()
        -- PARTIEL : WaitSe [7434]
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 5143 (SE_NUM_EVENT_EFF_FLASH_HEAVY)
        GAME:FadeIn(5)
        GAME:WaitFrames(2)
        GAME:FadeOut(false, 5)
        GAME:WaitFrames(10)
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 5143 (SE_NUM_EVENT_EFF_FLASH_HEAVY)
        GAME:FadeIn(5)
        GAME:WaitFrames(2)
        GAME:FadeOut(false, 5)
        GAME:WaitFrames(30)
        -- PARTIEL : WaitSe [5143]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6930') end) -- TODO SE 6930 (SE_NUM_EVENT_MAIN10_HOUKOU)
        -- message_ImitationSound : PARTIEL
        -- PARTIEL : WaitSe [6930]
        UI:ResetSpeaker()
        -- PARTIEL : back2_SetMode [4]
        -- back2_SetGround(V12P01A) : couche décor (overlay scène, adaptation)
        -- PARTIEL : back2_SetEffect [7, 0]
        -- camera2_SetPositionMark [2, 2, 19, 15] : PARTIEL
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7431') end) -- TODO SE 7431 (SE_NUM_EVENT_MAIN19_LIGHT_01)
        -- screen2_FadeIn [1, 30] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(15)
        -- camera2_SetPositionMark [2, 2, 58, 15] : PARTIEL
        GAME:WaitFrames(4)
        -- camera2_SetPositionMark [2, 2, 97, 15] : PARTIEL
        GAME:WaitFrames(90)
        -- PARTIEL : WaitSe [7431]
        -- screen2_FadeOut [1, 30] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(30)
        -- back2_SetGround(V13P01A) : couche décor (overlay scène, adaptation)
        -- camera2_SetPositionMark [2, 2, 19, 17] : PARTIEL
        -- supervision_cting layer [3] (structurel)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- PlanetsParalysis
        -- screen2_FadeIn [1, 30] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(30)
        GAME:WaitFrames(60)
        -- object 265 (v15p01a2) : contexte objet
        FutureScene.ObjectSetAnim('v15p01a2', 18, 0, 3, Direction.Down, 1) -- objet 265, anim 18 (table REQUISE)
        -- object 265 (v15p01a2) : contexte objet
        -- WaitAnimation sur objet v15p01a2 : PARTIEL
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        -- object 265 (v15p01a2) : contexte objet
        FutureScene.ObjectSetAnim('v15p01a2', 3, 0, 3, Direction.Down, 1) -- objet 265, anim 3 (table REQUISE)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6930') end) -- TODO SE 6930 (SE_NUM_EVENT_MAIN10_HOUKOU)
        -- message_ImitationSound : PARTIEL
        GAME:WaitFrames(90)
        -- screen2_FadeOut [1, 60] : couche décor (overlay scène, adaptation)
        UI:ResetSpeaker()
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        GAME:WaitFrames(30)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Waaah !') -- FUT_M19B1001_041 (FR)
        -- case 60: ' Waaah!'
        -- case 61: ' Waaah!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ça... C\'est...') -- FUT_M19B1001_042 (FR)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Massko ! Qu\'est-ce que c\'est ?! Qu\'est-ce que c\'est que cette chose ?!') -- FUT_M19B1001_043 (FR)
        -- case 64: ' [CS:N]Grovyle[CR]![K] What is it?! What is\nthat thing?!'
        -- case 65: ' [CS:N]Grovyle[CR]![K] What is it?! What is\nthat?!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Necrozma'), Direction.Down, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est... Primal... Necrozma...') -- FUT_M19B1001_044 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8973 (SE_NUM_EVENT_SIGN_SHOCK_03)
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi ?! C\'est ça ?!') -- FUT_M19B1001_045 (FR)
        -- case 68: ' What!?![K] That is?!'
        -- case 69: ' What!?![K] That is?!'
        UI:WaitShowDialogue('C\'est... Primal Necrozma ?!') -- FUT_M19B1001_046 (FR)
        -- case 71: " That's Primal [CS:N]Dialga[CR]?!"
        -- case 72: " That's Primal [CS:N]Dialga[CR]?!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Qu\'y a-t-il, Massko ?[br]Où est passé ton cran ?') -- FUT_M19B1001_047 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Gah...') -- FUT_M19B1001_048 (FR)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Mon cher Massko...') -- FUT_M19B1001_049 (FR)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
            end),
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('C\'est fini pour nous...') -- FUT_M19B1001_050 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO SE 8974 (SE_NUM_EVENT_MOTION_JUNP_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Hein ? Pourquoi ?') -- FUT_M19B1001_051 (FR)
        -- case 78: ' Huh?! Why?!'
        -- case 79: ' What?! Why?!'
        UI:WaitShowDialogue('On ne va pas se battre ?') -- FUT_M19B1001_052 (FR)
        -- case 81: " Aren't we going to fight?!"
        -- case 82: " Aren't we going to fight?!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('C\'est sans espoir... Necrozma est trop puissant...') -- FUT_M19B1001_053 (FR)
        UI:WaitShowDialogue('Nous ne faisons pas le poids face à lui.') -- FUT_M19B1001_054 (FR)
        UI:WaitShowDialogue('Vous deux, vous avez si bien tenu le coup...') -- FUT_M19B1001_055 (FR)
        UI:WaitShowDialogue('Je suis désolé de vous décevoir.[br]Tout s\'arrête ici.') -- FUT_M19B1001_056 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Mais...') -- FUT_M19B1001_057 (FR)
        -- case 88: ' But...'
        -- case 89: ' But...'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        GAME:WaitFrames(30)
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 0.5*8, CH('Grovyle').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.UpRight, 15)
            end),
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Je me rends, Necrozma.') -- FUT_M19B1001_058 (FR)
        UI:WaitShowDialogue('Fais de moi... ce que tu voudras.') -- FUT_M19B1001_059 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('M-mon cher Massko !') -- FUT_M19B1001_060 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Qu\'y a-t-il, Massko ?') -- FUT_M19B1001_061 (FR)
        UI:WaitShowDialogue('Ce n\'est pas ton genre d\'abandonner...') -- FUT_M19B1001_062 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Oui. J\'abandonne.') -- FUT_M19B1001_063 (FR)
        UI:WaitShowDialogue('Mais... l\'espoir est toujours vivant.') -- FUT_M19B1001_064 (FR)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        UI:SetCenter(true)
        UI:WaitShowDialogue('Celebi, tu te souviens...') -- FUT_M19B1001_065 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Necrozma'))
        UI:SetCenter(true)
        UI:WaitShowDialogue('La dernière fois... lorsque je suis remonté dans le temps pour empêcher la Paralysie de la Planète...') -- FUT_M19B1001_066 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Je n\'étais pas seul. Quelqu\'un m\'accompagnait.') -- FUT_M19B1001_067 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi ? Massko, tu n\'es donc pas venu seul dans notre monde ?!') -- FUT_M19B1001_068 (FR)
        -- case 101: " What?![K] [CS:N]Grovyle[CR], you didn't come\nto our world by yourself?!"
        -- case 102: " What?![K] [CS:N]Grovyle[CR], you didn't come\nto our world alone?!"
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est vrai. J\'avais un partenaire.') -- FUT_M19B1001_069 (FR)
        UI:WaitShowDialogue('Nous sommes partis ensemble vers le passé.') -- FUT_M19B1001_070 (FR)
        UI:WaitShowDialogue('Mais pendant notre traversée du temps, nous avons eu des ennuis...') -- FUT_M19B1001_071 (FR)
        UI:WaitShowDialogue('Nous avons été séparés.') -- FUT_M19B1001_072 (FR)
        UI:WaitShowDialogue('Mon partenaire doit encore se trouver dans le monde du passé.') -- FUT_M19B1001_073 (FR)
        UI:WaitShowDialogue('Même si je suis éliminé...') -- FUT_M19B1001_074 (FR)
        UI:WaitShowDialogue('Mon partenaire mènera notre mission à son terme.') -- FUT_M19B1001_075 (FR)
        UI:WaitShowDialogue('Mon partenaire empêchera la Paralysie de la Planète.') -- FUT_M19B1001_076 (FR)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(180)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('............') -- FUT_M19B1001_077 (FR)
        -- message_KeyWait (le dialogue bloque déjà)
        UI:WaitShowDialogue('Ha! Ha-ha-ha ! Hoo-hoo-ha !') -- FUT_M19B1001_078 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Necrozma'))
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Necrozma'))
            end),
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Qu\'est-ce qui te fait rire ?') -- FUT_M19B1001_079 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Alors tu prétends que quelqu\'un t\'accompagnait dans le passé...') -- FUT_M19B1001_080 (FR)
        UI:WaitShowDialogue('Au fait, comment s\'appelle ton partenaire ?') -- FUT_M19B1001_081 (FR)
        UI:WaitShowDialogue('Vas-y. Dis-nous son nom.') -- FUT_M19B1001_082 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Pourquoi demander une telle chose ?') -- FUT_M19B1001_083 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Tu ne peux pas me le dire ?') -- FUT_M19B1001_084 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Non, ce n\'est pas vrai. Mon partenaire s\'appelle [hero].') -- FUT_M19B1001_085 (FR)
        UI:WaitShowDialogue('Mon meilleur ami...') -- FUT_M19B1001_086 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(Quoi?!)') -- FUT_M19B1001_087 (FR)
        -- case 122: '(What?!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Euh... q-quoi ?!') -- FUT_M19B1001_088 (FR)
        -- case 124: ' Uh...what?!'
        -- case 125: ' Wh-what?!'
        UI:WaitShowDialogue('Massko ! Tu as bien dit [hero] ?!') -- FUT_M19B1001_089 (FR)
        -- case 127: ' [CS:N]Grovyle[CR]![K] You said\n[hero]?!'
        -- case 128: ' [CS:N]Grovyle[CR]![K] Did you say\n[hero]?!'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue('Mais [hero] est juste ici !') -- FUT_M19B1001_090 (FR)
        UI:SetCenter(false)
        -- case 130: ' Well, this is [hero]\nright here!'
        -- case 131: ' Well, this is [hero]\nright here!'
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end),
        })
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('Celebi'), CH('PLAYER'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Quoi ?') -- FUT_M19B1001_091 (FR)
        UI:WaitShowDialogue('Tu es... [hero] ?') -- FUT_M19B1001_092 (FR)
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Non... impossible...') -- FUT_M19B1001_093 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Mais... [hero] n\'est pas un Pokémon.') -- FUT_M19B1001_094 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        UI:SetCenter(true)
        UI:WaitShowDialogue('[hero]... est un humain.') -- FUT_M19B1001_095 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi ?') -- FUT_M19B1001_096 (FR)
        -- case 138: ' What?!'
        -- case 139: ' What?!'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('Hidden Highland.ogg', true) end) -- HiddenHighland
        GROUND:CharSetAnim(CH('Necrozma'), 'Float', true) -- param 49 = anim 20 (Float)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hoo-hoo-ha ! Précisément !') -- FUT_M19B1001_097 (FR)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Necrozma'))
            end),
        })
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Grovyle'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Celebi'), CH('Necrozma'))
            end),
        })
        -- SetAnimation 2 (spécial : boucle anim courante)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Mon ami ! Massko, c\'est bien ton ami [hero] !') -- FUT_M19B1001_098 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Quoi ?') -- FUT_M19B1001_099 (FR)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ce Pokémon que vous voyez était autrefois humain !') -- FUT_M19B1001_100 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8973 (SE_NUM_EVENT_SIGN_SHOCK_03)
        GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Necrozma'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Qu-quoi ?!') -- FUT_M19B1001_101 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Maître Necrozma m\'avait donné une mission...') -- FUT_M19B1001_102 (FR)
        UI:WaitShowDialogue('Je devais vous éliminer, Massko et [hero], parce que vous aviez fui dans le passé.') -- FUT_M19B1001_103 (FR)
        UI:WaitShowDialogue('Je vous ai poursuivis à travers le temps.') -- FUT_M19B1001_104 (FR)
        UI:WaitShowDialogue('Dans le passé, j\'ai recueilli des renseignements susceptibles de m\'aider à vous retrouver.') -- FUT_M19B1001_105 (FR)
        UI:ResetSpeaker()
        GAME:FadeOut(true, 30)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m19b1001] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m19b1001
