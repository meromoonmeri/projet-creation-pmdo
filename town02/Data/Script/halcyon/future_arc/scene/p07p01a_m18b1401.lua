--[[
    P07P01A_m18b1401.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P07P01A/m18b1401.ssb
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

local m18b1401 = {}

function m18b1401.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- PARTIEL : back_SetBanner2 [367, 0, 256, 152, 15, 0] (bannière)
        GAME:FadeIn(45)
        GAME:WaitFrames(160)
        GAME:FadeOut(false, 45)
        GAME:WaitFrames(15)
        -- PARTIEL : back2_SetMode [4]
        -- back2_SetGround(V09P04A) : couche décor (overlay scène, adaptation)
        -- back_SetGround(P07P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- camera2_SetPositionMark [0, 2, 21, 21] : PARTIEL
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- screen2_FadeIn [0, 30] : couche décor (overlay scène, adaptation)
        GAME:FadeIn(30)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        GAME:WaitFrames(80)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 180, 316, false, 2.0)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 180, 380, false, 2.0)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        GAME:WaitFrames(45)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 24*8, false, 2.0)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Bien. Ici, ça devrait aller.') -- FUT_M18B1401_001 (FR)
        UI:WaitShowDialogue('Ces Ténéfix ne pourront pas nous repérer facilement ici.') -- FUT_M18B1401_002 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Dis-nous, Massko.') -- FUT_M18B1401_003 (FR)
        -- case 3: ' Tell us, [CS:N]Grovyle[CR].'
        -- case 4: ' Tell us, [CS:N]Grovyle[CR].'
        UI:WaitShowDialogue('Dans le futur... Pourquoi la planète est-elle devenue paralysée ?') -- FUT_M18B1401_004 (FR)
        -- case 6: ' In the future...[K] Why did the\nplanet become paralyzed?'
        -- case 7: " In the future...[K] Why did the\nplanet's paralysis take place?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('La cause de la Paralysie de la Planète...') -- FUT_M18B1401_005 (FR)
        UI:WaitShowDialogue('Tout remonte à votre époque, dans le monde du passé.') -- FUT_M18B1401_006 (FR)
        UI:WaitShowDialogue('La Paralysie de la Planète a commencé lorsque la Tour du Temps, sous la garde de Necrozma, s\'est effondrée.') -- FUT_M18B1401_007 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('N-Necrozma ? Qui est-ce ?') -- FUT_M18B1401_008 (FR)
        -- case 12: ' [CS:N]D-Dialga[CR]?[K] Who is that?'
        -- case 13: ' [CS:N]D-Dialga[CR]?[K] Who is that?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est le Pokémon légendaire qui contrôle le temps.') -- FUT_M18B1401_009 (FR)
        UI:WaitShowDialogue('Necrozma assurait le bon écoulement du temps depuis la Tour du Temps.') -- FUT_M18B1401_010 (FR)
        UI:WaitShowDialogue('Mais lorsque la Tour du Temps s\'est effondrée...') -- FUT_M18B1401_011 (FR)
        UI:WaitShowDialogue('Le temps a progressivement échappé à son contrôle...') -- FUT_M18B1401_012 (FR)
        UI:WaitShowDialogue('Et la planète a fini par sombrer dans la paralysie.') -- FUT_M18B1401_013 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('Qu\'est-il arrivé à Necrozma ?') -- FUT_M18B1401_014 (FR)
        -- case 20: ' What...[K]what happened to [CS:N]Dialga[CR]?'
        -- case 21: ' What...[K]what happened to [CS:N]Dialga[CR]?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Lorsque le temps s\'est déréglé, Necrozma a lui aussi perdu le contrôle.') -- FUT_M18B1401_015 (FR)
        UI:WaitShowDialogue('À présent, dans votre avenir, la planète entière est paralysée.') -- FUT_M18B1401_016 (FR)
        UI:WaitShowDialogue('Necrozma a ainsi perdu presque toute sa raison... et les ténèbres le gouvernent.') -- FUT_M18B1401_017 (FR)
        UI:WaitShowDialogue('Necrozma est désormais méconnaissable.') -- FUT_M18B1401_018 (FR)
        UI:WaitShowDialogue('Il est devenu une entité totalement différente... Oui...') -- FUT_M18B1401_019 (FR)
        UI:WaitShowDialogue('Il est devenu Primal Necrozma, une présence primordiale.') -- FUT_M18B1401_020 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('D\'accord... Argh...') -- FUT_M18B1401_021 (FR)
        -- case 29: ' OK... Urf...'
        -- case 30: ' OK... Urf...'
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Primal Necrozma est dépourvu de toute émotion.') -- FUT_M18B1401_022 (FR)
        UI:WaitShowDialogue('Il ne cherche qu\'à se préserver et empêche donc l\'histoire de changer.') -- FUT_M18B1401_023 (FR)
        UI:WaitShowDialogue('C\'est pourquoi Necrozma veut m\'éliminer.') -- FUT_M18B1401_024 (FR)
        UI:WaitShowDialogue('Parce que j\'ai tenté de changer l\'histoire.') -- FUT_M18B1401_025 (FR)
        UI:WaitShowDialogue('Parce que j\'ai essayé d\'arrêter la Paralysie de la Planète.') -- FUT_M18B1401_026 (FR)
        UI:WaitShowDialogue('Parce que j\'ai voyagé dans le temps jusqu\'à votre monde depuis cette époque... votre avenir.') -- FUT_M18B1401_027 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi ?') -- FUT_M18B1401_028 (FR)
        -- case 38: ' What?!'
        -- case 39: ' What?!'
        UI:WaitShowDialogue('Massko, tu dis que tu es venu dans notre monde...') -- FUT_M18B1401_029 (FR)
        -- case 41: " [CS:N]Grovyle[CR], you're saying that you\ncame back to our world..."
        -- case 42: " [CS:N]Grovyle[CR], you're saying that you\ncame back to our world..."
        UI:WaitShowDialogue('Pour empêcher la Paralysie de la Planète ?!') -- FUT_M18B1401_030 (FR)
        -- case 44: " So you could prevent the planet's\nparalysis?!"
        -- case 45: " So you could prevent the planet's\nparalysis?!"
        UI:WaitShowDialogue('Mais c\'est... tout le contraire de ce qu\'on nous a raconté !') -- FUT_M18B1401_031 (FR)
        -- case 47: " But that's...[K]completely the\nopposite of what we were told!"
        -- case 48: " But that's...[K]completely the\nopposite of what we were told!"
        UI:WaitShowDialogue('Massko, tu es revenu dans notre monde pour provoquer la Paralysie de la Planète... n\'est-ce pas ?!') -- FUT_M18B1401_032 (FR)
        -- case 50: " [CS:N]Grovyle[CR], you came back to our\nworld to paralyze the planet...didn't you?!"
        -- case 51: " [CS:N]Grovyle[CR], you came back to our\nworld to paralyze the planet...didn't you?!"
        UI:WaitShowDialogue('Et, Massko... n\'est-ce pas toi qui as volé les Rouages du Temps ?!') -- FUT_M18B1401_033 (FR)
        -- case 53: " And, [CS:N]Grovyle[CR]...[K]weren't you the\none stealing the Time Gears?!"
        -- case 54: " And, [CS:N]Grovyle[CR]...[K]weren't you the\none stealing the Time Gears?!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Tu plaisantes !') -- FUT_M18B1401_034 (FR)
        UI:WaitShowDialogue('Je rassemblais les Rouages du Temps...') -- FUT_M18B1401_035 (FR)
        UI:WaitShowDialogue('Parce qu\'ils étaient indispensables pour empêcher la Paralysie de la Planète.') -- FUT_M18B1401_036 (FR)
        UI:WaitShowDialogue('Je devais les apporter à la Tour du Temps et les remettre en place.') -- FUT_M18B1401_037 (FR)
        UI:WaitShowDialogue('Cela aurait inversé l\'effondrement de la Tour du Temps, déjà en cours à votre époque.') -- FUT_M18B1401_038 (FR)
        UI:WaitShowDialogue('Certes, retirer un Rouage du Temps de son emplacement arrête le temps dans les environs...') -- FUT_M18B1401_039 (FR)
        UI:WaitShowDialogue('Mais ce n\'est que temporaire. Une fois les Rouages du Temps placés dans la Tour du Temps...') -- FUT_M18B1401_040 (FR)
        UI:WaitShowDialogue('Le temps serait alors revenu partout à la normale.') -- FUT_M18B1401_041 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Et tout ce que Noctunoir vous a raconté ?') -- FUT_M18B1401_042 (FR)
        -- case 64: ' Urf...[K] But then, what about all\nthe things [CS:N]Dusknoir[CR] said about you?'
        -- case 65: ' Urf...[K] But then, what about all\nthe things [CS:N]Dusknoir[CR] said about you?'
        UI:WaitShowDialogue('Il a dit que tu étais un hors-la-loi recherché dans le futur.') -- FUT_M18B1401_043 (FR)
        -- case 67: ' Like how he said you were a\nwanted outlaw in the future.'
        -- case 68: ' Like how he said you were a\nwanted outlaw in the future.'
        UI:WaitShowDialogue('Que tu t\'étais échappé du futur...') -- FUT_M18B1401_044 (FR)
        -- case 70: ' And how you escaped from\nthe future...'
        -- case 71: ' And how you escaped from\nthe future...'
        UI:WaitShowDialogue('puis enfui dans notre monde, dans le passé.') -- FUT_M18B1401_045 (FR)
        -- case 73: ' then fled to our world in\nthe past.'
        -- case 74: ' then fled to our world in\nthe past.'
        UI:WaitShowDialogue('Alors tu dis que tout cela n\'était qu\'un tissu de mensonges ?') -- FUT_M18B1401_046 (FR)
        -- case 76: " So you're saying all that was\njust a bunch of lies?"
        -- case 77: " So you're claiming all that was\njust a bunch of lies?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Qu\'est-ce que ça pourrait être d\'autre ?') -- FUT_M18B1401_047 (FR)
        UI:WaitShowDialogue('Parce qu\'en réalité, Noctunoir est...') -- FUT_M18B1401_048 (FR)
        UI:WaitShowDialogue('un agent envoyé par Primal Necrozma depuis ce futur... pour m\'éliminer.') -- FUT_M18B1401_049 (FR)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi ? Noctunoir était... un agent envoyé pour t\'éliminer ?!') -- FUT_M18B1401_050 (FR)
        -- case 82: ' What?![K] [CS:N]Dusknoir[CR] was...[K]an agent\nsent to get rid of you?!'
        -- case 83: ' What?![K] [CS:N]Dusknoir[CR] was...[K]an agent\nsent to get rid of you?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est vrai.') -- FUT_M18B1401_051 (FR)
        UI:WaitShowDialogue('Je vous l\'ai dit : Primal Necrozma...') -- FUT_M18B1401_052 (FR)
        UI:WaitShowDialogue('cherche à contrecarrer toute tentative de modifier le cours de l\'histoire.') -- FUT_M18B1401_053 (FR)
        UI:WaitShowDialogue('C\'est pourquoi, lorsqu\'il a appris que j\'avais voyagé dans le temps...') -- FUT_M18B1401_054 (FR)
        UI:WaitShowDialogue('il a lancé Noctunoir à mes trousses.') -- FUT_M18B1401_055 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Le grand... Noctunoir... ?[br]C\'est impossible !') -- FUT_M18B1401_056 (FR)
        -- case 90: " The great...[K][CS:N]Dusknoir[CR]...?[K]\nIt can't be!"
        -- case 91: " The great...[K][CS:N]Dusknoir[CR]...?[K]\nIt can't be!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est difficile à croire, je le sais...') -- FUT_M18B1401_057 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Je n\'y crois pas du tout !') -- FUT_M18B1401_058 (FR)
        -- case 94: " I can't believe it at all!"
        -- case 95: " I can't believe it at all!"
        UI:WaitShowDialogue('Tu dis tout ça sur le grand Noctunoir ?!') -- FUT_M18B1401_059 (FR)
        -- case 97: " You're saying all this about\nthe great [CS:N]Dusknoir[CR]?!"
        -- case 98: " You're saying all this about\nthe great [CS:N]Dusknoir[CR]?!"
        UI:WaitShowDialogue('Je ne comprends pas pourquoi Noctunoir ferait une chose pareille, mais...') -- FUT_M18B1401_060 (FR)
        -- case 100: " I don't understand why [CS:N]Dusknoir[CR]\nis acting this way here, but..."
        -- case 101: " I don't understand why [CS:N]Dusknoir[CR]\nis acting this way here, but..."
        UI:WaitShowDialogue('Mais j\'admirais... Noctunoir...') -- FUT_M18B1401_061 (FR)
        -- case 103: ' But I admired...[K][CS:N]Dusknoir[CR]...'
        -- case 104: ' But I respected...[K][CS:N]Dusknoir[CR]...'
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('TearyEyed')
        UI:WaitShowDialogue('Je ne peux pas... Je ne peux pas te croire...') -- FUT_M18B1401_062 (FR)
        -- case 106: " I can't...[K] I can't believe you..."
        -- case 107: " I can't...[K] I can't believe you..."
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('Time Gear Remix.ogg', true) end) -- TimeGear
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('(C\'est difficile à accepter, mais...)') -- FUT_M18B1401_063 (FR)
        -- case 109: '(It is hard to accept, but...)'
        UI:WaitShowDialogue('(Repense à tout ce que nous avons vécu dans ce monde futur...)') -- FUT_M18B1401_064 (FR)
        -- case 111: "(Looking back over what we've been through in\nthis future world...)"
        UI:WaitShowDialogue('(Tout ce que Massko a dit se tient. Tout concorde.)') -- FUT_M18B1401_065 (FR)
        -- case 113: '(What [CS:N]Grovyle[CR] said is reasonable.[K] It makes\nperfect sense.)'
        UI:WaitShowDialogue('(Et [partner] le sait.)') -- FUT_M18B1401_066 (FR)
        -- case 115: '(And [partner] knows it.)'
        UI:WaitShowDialogue('(Au fond, [partner] sait que Massko dit la vérité.)') -- FUT_M18B1401_067 (FR)
        -- case 117: '([partner] knows deep down that what\n[CS:N]Grovyle[CR] says is true.)'
        UI:WaitShowDialogue('(Mais le savoir rend la vérité encore plus difficile à accepter...)') -- FUT_M18B1401_068 (FR)
        -- case 119: '(But knowing that makes it that much harder\nto accept...)'
        UI:WaitShowDialogue('(Mais...)') -- FUT_M18B1401_069 (FR)
        -- case 121: '(But...)'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Teammate1'), 120, 396, false, 2.0)
        GAME:WaitFrames(30)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
            end),
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hé ! Où vas-tu ?') -- FUT_M18B1401_070 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Je vais voir Noctunoir.') -- FUT_M18B1401_071 (FR)
        -- case 124: " I'm going to see [CS:N]Dusknoir[CR]."
        -- case 125: " I'm going to see [CS:N]Dusknoir[CR]."
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end),
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Quoi ?') -- FUT_M18B1401_072 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Je veux voir Noctunoir.[br]Je découvrirai ainsi si tu as dit vrai.') -- FUT_M18B1401_073 (FR)
        -- case 128: " I want to see [CS:N]Dusknoir[CR].[K]\nI'm going to find out if what you said is true\nor not."
        -- case 129: " I want to see [CS:N]Dusknoir[CR].[K]\nI'm going to find out if what you said is true\nor not."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('À quoi bon ?!') -- FUT_M18B1401_074 (FR)
        UI:WaitShowDialogue('Tu ne ferais que leur faciliter la tâche !') -- FUT_M18B1401_075 (FR)
        UI:WaitShowDialogue('Tu n\'as aucune chance contre eux !') -- FUT_M18B1401_076 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Alors... qu\'est-ce que je dois faire ?!') -- FUT_M18B1401_077 (FR)
        -- case 134: ' Then...[K]what am I supposed\nto do?!'
        -- case 135: ' Then...[K]what am I supposed\nto do?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ce que tu es censé faire ?!') -- FUT_M18B1401_078 (FR)
        UI:WaitShowDialogue('Tu ne t\'es pas demandé ça plus tôt ?') -- FUT_M18B1401_079 (FR)
        UI:WaitShowDialogue('Et tu as décidé... de choisir par toi-même !') -- FUT_M18B1401_080 (FR)
        UI:WaitShowDialogue('Tu l\'as affirmé parce que tu ne savais pas qui croire...') -- FUT_M18B1401_081 (FR)
        UI:WaitShowDialogue('Tu as refusé de croire aveuglément ce qu\'on te disait... et décidé de réfléchir par toi-même !') -- FUT_M18B1401_082 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Urk...') -- FUT_M18B1401_083 (FR)
        -- case 142: ' Urk...'
        -- case 143: ' Urk...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est précisément quand tout va mal qu\'il faut rester fort.') -- FUT_M18B1401_084 (FR)
        UI:WaitShowDialogue('Réfléchis par toi-même, puis agis comme tu le juges bon.') -- FUT_M18B1401_085 (FR)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 208, 396, false, 1.594)
        GAME:WaitFrames(20)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 0.7969*8, CH('Teammate1').Position.Y + 28*8, false, 1.594)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Massko... Que vas-tu faire maintenant ?') -- FUT_M18B1401_086 (FR)
        -- case 147: ' [CS:N]Grovyle[CR]...[K] What are you going\nto do now?'
        -- case 148: ' [CS:N]Grovyle[CR]...[K] What are you going\nto do now?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Je retourne au passé pour arrêter la Paralysie de la Planète.') -- FUT_M18B1401_087 (FR)
        UI:WaitShowDialogue('Pour faire ça...') -- FUT_M18B1401_088 (FR)
        UI:WaitShowDialogue('Je dois trouver Celebi.') -- FUT_M18B1401_089 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Celebi ?') -- FUT_M18B1401_090 (FR)
        -- case 153: ' [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?'
        -- case 154: ' [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est vrai.') -- FUT_M18B1401_091 (FR)
        UI:WaitShowDialogue('Tu peux venir avec moi ou non. C\'est ton choix.') -- FUT_M18B1401_092 (FR)
        UI:WaitShowDialogue('À vous deux de décider de la voie que vous suivrez.') -- FUT_M18B1401_093 (FR)
        UI:WaitShowDialogue('J\'y vais.') -- FUT_M18B1401_094 (FR)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 160*8, false, 2.0)
        GAME:WaitFrames(20)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 15)
        GAME:WaitFrames(60)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Argh...') -- FUT_M18B1401_095 (FR)
        -- case 160: ' Urk...'
        -- case 161: ' Urk...'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('(...............)') -- FUT_M18B1401_096 (FR)
        -- case 163: '(...............)'
        UI:WaitShowDialogue('(Moi non plus, je ne sais pas ce que je dois croire.)') -- FUT_M18B1401_097 (FR)
        -- case 165: "(I don't know what I should believe either.)"
        UI:WaitShowDialogue('(Mais... il y a une chose que je peux dire avec certitude.)') -- FUT_M18B1401_098 (FR)
        -- case 167: '(But...[K]there is one thing I can say with\ncertainty.)'
        UI:WaitShowDialogue('(Dans ce sombre monde futur...)') -- FUT_M18B1401_099 (FR)
        -- case 169: '(In this future world of darkness...)'
        UI:WaitShowDialogue('(La planète est paralysée.)') -- FUT_M18B1401_100 (FR)
        -- case 171: '(The planet is paralyzed.)'
        UI:WaitShowDialogue('(Et cette Paralysie de la Planète... Elle a commencé dans notre monde.)') -- FUT_M18B1401_101 (FR)
        -- case 173: '(And the paralysis of the planet...[K] It happened\nback in our world.)'
        UI:WaitShowDialogue('(Alors, pour l\'empêcher de se produire...)') -- FUT_M18B1401_102 (FR)
        -- case 175: "(That's why, to stop that from happening...)"
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('(Nous devons retourner dans le passé !)') -- FUT_M18B1401_103 (FR)
        -- case 177: '(We have to get back to the past!)'
        UI:WaitShowDialogue('(Nous devons rentrer ! Dans notre monde !)') -- FUT_M18B1401_104 (FR)
        -- case 179: '(We have to get back![K] Back to our world!)'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('PLAYER'), 208, 396, false, 2.0)
        GAME:WaitFrames(45)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Right, 15)
            end),
        })
        GAME:WaitFrames(80)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Left, 15)
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('[hero]...') -- FUT_M18B1401_105 (FR)
        -- case 181: ' [hero]...'
        -- case 182: ' [hero]...'
        UI:WaitShowDialogue('Je sais...') -- FUT_M18B1401_106 (FR)
        -- case 184: ' Yup...[K] I know...'
        -- case 185: ' Yes...[K] I know...'
        UI:WaitShowDialogue('Ce que Massko a dit... Il a raison...') -- FUT_M18B1401_107 (FR)
        -- case 187: ' What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is\nright...'
        -- case 188: ' What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is\nright...'
        UI:WaitShowDialogue('Tout va très mal en ce moment...[br]C\'est précisément pour cela qu\'il faut rester forts.') -- FUT_M18B1401_108 (FR)
        -- case 190: " Things are very tough now...[K]\nThat's why we have to be strong."
        -- case 191: " Things are very tough now...[K]\nThat's why we have to be strong."
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ça va mieux maintenant... Allons-y.') -- FUT_M18B1401_109 (FR)
        -- case 193: " I'm all right now...[K] Let's go."
        -- case 194: " I'm all right now...[K] Let's go."
        UI:WaitShowDialogue('Rattrapons Massko.') -- FUT_M18B1401_110 (FR)
        -- case 196: " Let's catch up to [CS:N]Grovyle[CR]."
        -- case 197: " Let's catch up to [CS:N]Grovyle[CR]."
        UI:ResetSpeaker()
        GROUND:CharSetAnim(CH('PLAYER'), 'Nod', false) -- param 71 = anim 22 (Nod)
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation 2 (spécial : boucle anim courante)
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 0.7969*8, CH('PLAYER').Position.Y + 24*8, false, 1.594)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('[hero].') -- FUT_M18B1401_111 (FR)
        -- case 199: ' [hero].'
        -- case 200: ' [hero].'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('Nous devons... Nous devons rentrer !') -- FUT_M18B1401_112 (FR)
        -- case 202: ' We have to...[K] We have to\nget back!'
        -- case 203: ' We have to...[K] We have to\nget back!'
        UI:WaitShowDialogue('Dans notre monde !') -- FUT_M18B1401_113 (FR)
        -- case 205: ' Back to our own world!'
        -- case 206: ' Back to our own world!'
        UI:ResetSpeaker()
        GROUND:CharSetAnim(CH('PLAYER'), 'Nod', false) -- param 71 = anim 22 (Nod)
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        GROUND:CharSetAnim(CH('PLAYER'), 'Nod', false) -- param 71 = anim 22 (Nod)
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation 2 (spécial : boucle anim courante)
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 160*8, false, 2.0)
        GAME:WaitFrames(45)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 160*8, false, 2.0)
        GAME:WaitFrames(30)
        SOUND:FadeOutBGM(180)
        -- screen2_FadeOut [0, 60] : couche décor (overlay scène, adaptation)
        GAME:FadeOut(false, 60)
        -- PARTIEL : back2_SetMode [0]
        -- WaitBgm : PARTIEL
        GAME:WaitFrames(30)
        SV.Scenario.Main = 20 -- flag_SetScenario(SCENARIO_MAIN, scenario=20, level=0)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m18b1401] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m18b1401
