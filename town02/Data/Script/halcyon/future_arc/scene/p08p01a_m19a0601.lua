--[[
    P08P01A_m19a0601.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/m19a0601.ssb
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

local m19a0601 = {}

function m19a0601.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- PARTIEL : back_SetDungeonBanner [32, 0] (bannière)
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
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Grovyle'), 276, 248, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), 248, 268, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), 304, 268, false, 2.0)
            end),
        })
        GAME:WaitFrames(15)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est... C\'est là que Celebi est censée se trouver ?') -- FUT_M19A0601_001 (FR)
        -- case 0: " Is this...[K] Is this where [CS:N]Celebi[CR]'s\nsupposed to be?"
        -- case 1: ' Is this...[K] Is this where [CS:N]Celebi[CR] is\nsupposed to be?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est exact. C\'est par ici que je l\'ai rencontrée la dernière fois.') -- FUT_M19A0601_002 (FR)
        UI:WaitShowDialogue('Mais si Primal Necrozma connaît cet endroit...') -- FUT_M19A0601_003 (FR)
        UI:WaitShowDialogue('Celebi aura déjà fui.') -- FUT_M19A0601_004 (FR)
        UI:WaitShowDialogue('Mais si nos poursuivants ignorent cet endroit...') -- FUT_M19A0601_005 (FR)
        UI:WaitShowDialogue('Alors Celebi devrait toujours être là.') -- FUT_M19A0601_006 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Celebi ? Tu m\'entends ?') -- FUT_M19A0601_007 (FR)
        UI:WaitShowDialogue('C\'est moi ! Massko !') -- FUT_M19A0601_008 (FR)
        UI:WaitShowDialogue('Montre-toi si tu es là !') -- FUT_M19A0601_009 (FR)
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8963') end) -- TODO SE 8963 (SE_NUM_EVENT_SIGN_HATENA_03)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Elle ne sort pas...') -- FUT_M19A0601_010 (FR)
        -- case 11: " She's...[K]not coming out..."
        -- case 12: " She's...[K]not coming out..."
        UI:WaitShowDialogue('Primal Necrozma l\'aurait-il chassée d\'ici ?') -- FUT_M19A0601_011 (FR)
        -- case 14: ' Did Primal [CS:N]Dialga[CR] chase her off?'
        -- case 15: ' Did she get frightened off by\nPrimal [CS:N]Dialga[CR]?'
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8973 (SE_NUM_EVENT_SIGN_SHOCK_03)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Et si...') -- FUT_M19A0601_012 (FR)
        -- case 17: ' What if...'
        -- case 18: ' What if...'
        UI:WaitShowDialogue('Et si elle a été capturée par Primal Necrozma ?') -- FUT_M19A0601_013 (FR)
        -- case 20: " What if she's...[K]been captured by\nPrimal [CS:N]Dialga[CR]?"
        -- case 21: " What if she's...[K]been captured by\nPrimal [CS:N]Dialga[CR]?"
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('Capturée ?') -- FUT_M19A0601_014 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end),
        })
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Ouah ! Qui a dit ça ?!') -- FUT_M19A0601_015 (FR)
        -- case 24: ' Whoa! Who said that?!'
        -- case 25: " Wah! Where'd that voice\ncome from?!"
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8963') end) -- TODO SE 8963 (SE_NUM_EVENT_SIGN_HATENA_03)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(12)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(45)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
            end),
        })
        GAME:WaitFrames(10)
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8962 (SE_NUM_EVENT_SIGN_HATENA_02)
        GROUND:CharSetEmote(CH('Teammate1'), 'question', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('Mais maintenant... Je n\'entends rien.') -- FUT_M19A0601_016 (FR)
        -- case 27: " But now...[K]I don't hear anything."
        -- case 28: " But now...[K]I don't hear anything."
        UI:WaitShowDialogue('Cette voix... Est-ce que je l\'ai imaginée ?') -- FUT_M19A0601_017 (FR)
        -- case 30: ' That voice...[K] Did I imagine it?'
        -- case 31: ' That voice...[K] Was I just\nhearing things?'
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('Hi-hi ! Tu ne l\'as pas imaginée !') -- FUT_M19A0601_018 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO SE 8974 (SE_NUM_EVENT_MOTION_JUNP_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue('Moi ? Capturée ?') -- FUT_M19A0601_019 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Quelle insulte ! Moi, capturée ?!') -- FUT_M19A0601_020 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Impossible, voyons ! Hi-hi !') -- FUT_M19A0601_021 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
            end),
        })
        -- performer 3
        -- SetEffect [645, 3] : performer 3 non mappé (PARTIEL)
        -- performer 3
        -- WaitEffect [] : performer 3 non mappé (PARTIEL)
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7433') end) -- TODO SE 7433 (SE_NUM_EVENT_MAIN19_LIGHT_03)
        GAME:WaitFrames(134)
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBGM('Welcome to the World of Pokémon!.ogg', true) end) -- WelcomeToTheWorldOfPokemon
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Cela faisait si longtemps, mon cher Massko !') -- FUT_M19A0601_022 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Oui. Ça fait un moment, Celebi.') -- FUT_M19A0601_023 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO SE 8974 (SE_NUM_EVENT_MOTION_JUNP_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Hein ?! Ce minuscule Pokémon, c\'est Celebi ?') -- FUT_M19A0601_024 (FR)
        -- case 39: ' Huh?![K] This tiny thing is [CS:N]Celebi[CR]?'
        -- case 40: ' What?![K] This tiny thing is [CS:N]Celebi[CR]?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownLeft, 15)
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('Celebi'), 'angry', 3)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est malpoli !') -- FUT_M19A0601_025 (FR)
        UI:WaitShowDialogue('Tu n\'as pas à te moquer de ma petite taille !') -- FUT_M19A0601_026 (FR)
        UI:ResetSpeaker()
        -- SetEffect 0 (aucun) : pas d'effet
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Je suis désolé.') -- FUT_M19A0601_027 (FR)
        -- case 44: " Uh...[K]I'm sorry."
        -- case 45: " Uh...[K]I'm sorry."
        UI:WaitShowDialogue('J\'ai entendu dire que tu pouvais voyager dans le temps...') -- FUT_M19A0601_028 (FR)
        -- case 47: ' I heard you have the ability to\ncross time...'
        -- case 48: ' I heard you have the ability to\ncross time...'
        UI:WaitShowDialogue('Je m\'attendais à un Pokémon plus imposant.') -- FUT_M19A0601_029 (FR)
        -- case 50: ' So I was expecting to see some\nkind of an awesome-looking Pokémon...'
        -- case 51: ' So I expected you to be some\nawe-inspiring Pokémon...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Quel malotru ! Il ne faut jamais juger un Pokémon sur son apparence !') -- FUT_M19A0601_030 (FR)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Happy')
        UI:WaitShowDialogue('Mais... je te pardonne.') -- FUT_M19A0601_031 (FR)
        UI:WaitShowDialogue('Après tout...') -- FUT_M19A0601_032 (FR)
        UI:WaitShowDialogue('Tu dois me trouver bien plus mignonne que tu ne l\'imaginais !') -- FUT_M19A0601_033 (FR)
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8961') end) -- TODO SE 8961 (SE_NUM_EVENT_SIGN_ASE_01)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'sweatdrop', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('Euh, ouais...') -- FUT_M19A0601_034 (FR)
        -- case 57: ' Uh, yeah...'
        -- case 58: ' Um, yes.'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 0.5*8, CH('Grovyle').Position.Y + 0*8, false, 1.0)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Celebi. J\'ai encore besoin de ton aide.') -- FUT_M19A0601_035 (FR)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Je sais.') -- FUT_M19A0601_036 (FR)
        UI:WaitShowDialogue('Te voir ici, mon cher Massko, me révèle tout ce que j\'ai besoin de savoir.') -- FUT_M19A0601_037 (FR)
        UI:WaitShowDialogue('Tu es revenu parce que ta mission dans le passé a échoué, n\'est-ce pas ?') -- FUT_M19A0601_038 (FR)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Grovyle'), 'sweatdrop', 3)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Argh... Oui, c\'est vrai.') -- FUT_M19A0601_039 (FR)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('J\'espère que tu réussiras cette fois.[br]J\'en ai vraiment assez.') -- FUT_M19A0601_040 (FR)
        UI:WaitShowDialogue('Vivre dans ce monde sombre et lugubre est tellement déprimant.') -- FUT_M19A0601_041 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Désolé, pas le temps de discuter...') -- FUT_M19A0601_042 (FR)
        UI:WaitShowDialogue('Les Ténéfix sont à nos trousses.') -- FUT_M19A0601_043 (FR)
        UI:WaitShowDialogue('Si nous ne partons pas vite, nous allons t\'attirer des ennuis.') -- FUT_M19A0601_044 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hi-hi ! Tout va bien, inutile de t\'inquiéter.') -- FUT_M19A0601_045 (FR)
        UI:WaitShowDialogue('Que les Ténéfix viennent ! Ils ne m\'inquiètent pas.') -- FUT_M19A0601_046 (FR)
        UI:WaitShowDialogue('Si vous avez la bonté d\'empêcher la Paralysie de la Planète...') -- FUT_M19A0601_047 (FR)
        UI:WaitShowDialogue('nous serons enfin délivrés du supplice de ce monde de ténèbres.') -- FUT_M19A0601_048 (FR)
        UI:WaitShowDialogue('Mon cher Massko, j\'y consacrerai ma vie entière !') -- FUT_M19A0601_049 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('D\'accord... Où est le Passage du Temps ?') -- FUT_M19A0601_050 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Tout est prêt. Le Passage du Temps est tout près.') -- FUT_M19A0601_051 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Le Passage du Temps est sur un plateau au-dessus de cette forêt.') -- FUT_M19A0601_052 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Bien. Peux-tu nous y conduire ?') -- FUT_M19A0601_053 (FR)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Happy')
        UI:WaitShowDialogue('Oui !') -- FUT_M19A0601_054 (FR)
        UI:WaitShowDialogue('Vous allez tous les trois emprunter le Passage du Temps ?') -- FUT_M19A0601_055 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Oui. C\'est ça.') -- FUT_M19A0601_056 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownRight, 15)
        GAME:WaitFrames(30)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        GROUND:CharSetEmote(CH('Celebi'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Oh ! Tiens donc ? Un de tes amis ?') -- FUT_M19A0601_057 (FR)
        SOUND:FadeOutBGM(180)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(Quoi...? Quoi...?)') -- FUT_M19A0601_058 (FR)
        -- case 83: '(What...?[K] What...?)'
        UI:ResetSpeaker()
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('...............') -- FUT_M19A0601_059 (FR)
        UI:WaitShowDialogue('Non... Ça ne peut pas être...') -- FUT_M19A0601_060 (FR)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        GAME:WaitFrames(45)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        GAME:WaitFrames(45)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Quelque chose ne va pas, Celebi ?') -- FUT_M19A0601_061 (FR)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Celebi'))
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Non... Ce n\'est rien.') -- FUT_M19A0601_062 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownLeft, 15)
        GAME:WaitFrames(60)
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownRight, 15)
        GAME:WaitFrames(60)
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Down, 15)
        GAME:WaitFrames(30)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Alors, en route pour le Passage du Temps !') -- FUT_M19A0601_063 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Celebi'), CH('Celebi').Position.X + 1*8, CH('Celebi').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(15)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(30)
        GAME:FadeOut(false, 60)
        GAME:WaitFrames(80)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m19a0601] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m19a0601
