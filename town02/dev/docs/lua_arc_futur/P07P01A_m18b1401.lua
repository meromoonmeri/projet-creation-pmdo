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
        UI:WaitShowDialogue(' Good.\n This will do.') -- FUT_M18B1401_001 (FR optionnel)
        UI:WaitShowDialogue(' Those Sableye won\'t be able to\nspot us easily here.') -- FUT_M18B1401_002 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Tell us, Grovyle.') -- FUT_M18B1401_003 (FR optionnel)
        -- case 3: ' Tell us, [CS:N]Grovyle[CR].'
        -- case 4: ' Tell us, [CS:N]Grovyle[CR].'
        UI:WaitShowDialogue(' In the future...\n Why did the\nplanet become paralyzed?') -- FUT_M18B1401_004 (FR optionnel)
        -- case 6: ' In the future...[K] Why did the\nplanet become paralyzed?'
        -- case 7: " In the future...[K] Why did the\nplanet's paralysis take place?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' The cause of the planet\'s\nparalysis...') -- FUT_M18B1401_005 (FR optionnel)
        UI:WaitShowDialogue(' That dates back to your time.\nIn the world of the past.') -- FUT_M18B1401_006 (FR optionnel)
        UI:WaitShowDialogue(' The planet\'s paralysis started\nwith the collapse of Temporal Tower, which\nwas governed by Necrozma.') -- FUT_M18B1401_007 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(' D-Necrozma?\n Who is that?') -- FUT_M18B1401_008 (FR optionnel)
        -- case 12: ' [CS:N]D-Dialga[CR]?[K] Who is that?'
        -- case 13: ' [CS:N]D-Dialga[CR]?[K] Who is that?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' He is the legendary Pokémon\nthat controls time.') -- FUT_M18B1401_009 (FR optionnel)
        UI:WaitShowDialogue(' Necrozma ensured the proper flow\nof time from Temporal Tower.') -- FUT_M18B1401_010 (FR optionnel)
        UI:WaitShowDialogue(' But when Temporal Tower\ncollapsed...') -- FUT_M18B1401_011 (FR optionnel)
        UI:WaitShowDialogue(' Time gradually got out of\ncontrol...') -- FUT_M18B1401_012 (FR optionnel)
        UI:WaitShowDialogue(' And eventually, the planet fell\ninto paralysis.') -- FUT_M18B1401_013 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(' What...\nwhat happened to Necrozma?') -- FUT_M18B1401_014 (FR optionnel)
        -- case 20: ' What...[K]what happened to [CS:N]Dialga[CR]?'
        -- case 21: ' What...[K]what happened to [CS:N]Dialga[CR]?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' When time went out of whack,\nNecrozma also lost control.') -- FUT_M18B1401_015 (FR optionnel)
        UI:WaitShowDialogue(' Now, here in your future, the\nplanet has become fully paralyzed.') -- FUT_M18B1401_016 (FR optionnel)
        UI:WaitShowDialogue(' And thus Necrozma has lost almost\nall his reason...\nand is governed by darkness.') -- FUT_M18B1401_017 (FR optionnel)
        UI:WaitShowDialogue(' Necrozma is now beyond recognition.') -- FUT_M18B1401_018 (FR optionnel)
        UI:WaitShowDialogue(' He has become an entirely\ndifferent entity...\n Yes...') -- FUT_M18B1401_019 (FR optionnel)
        UI:WaitShowDialogue(' He has been transformed into\nPrimal Necrozma, a primordial presence.') -- FUT_M18B1401_020 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' OK... Urf...') -- FUT_M18B1401_021 (FR optionnel)
        -- case 29: ' OK... Urf...'
        -- case 30: ' OK... Urf...'
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Primal Necrozma feels no emotion.') -- FUT_M18B1401_022 (FR optionnel)
        UI:WaitShowDialogue(' He seeks only self-preservation,\nso he prevents history from changing.') -- FUT_M18B1401_023 (FR optionnel)
        UI:WaitShowDialogue(' That\'s why Necrozma wants\nme gone.') -- FUT_M18B1401_024 (FR optionnel)
        UI:WaitShowDialogue(' Because I tried to change\nhistory.') -- FUT_M18B1401_025 (FR optionnel)
        UI:WaitShowDialogue(' Because I tried to stop the\nplanet\'s paralysis.') -- FUT_M18B1401_026 (FR optionnel)
        UI:WaitShowDialogue(' Because I traveled back in time\nto your world from this place...your future.') -- FUT_M18B1401_027 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What?!') -- FUT_M18B1401_028 (FR optionnel)
        -- case 38: ' What?!'
        -- case 39: ' What?!'
        UI:WaitShowDialogue(' Grovyle, you\'re saying that you\ncame back to our world...') -- FUT_M18B1401_029 (FR optionnel)
        -- case 41: " [CS:N]Grovyle[CR], you're saying that you\ncame back to our world..."
        -- case 42: " [CS:N]Grovyle[CR], you're saying that you\ncame back to our world..."
        UI:WaitShowDialogue(' So you could prevent the planet\'s\nparalysis?!') -- FUT_M18B1401_030 (FR optionnel)
        -- case 44: " So you could prevent the planet's\nparalysis?!"
        -- case 45: " So you could prevent the planet's\nparalysis?!"
        UI:WaitShowDialogue(' But that\'s...\ncompletely the\nopposite of what we were told!') -- FUT_M18B1401_031 (FR optionnel)
        -- case 47: " But that's...[K]completely the\nopposite of what we were told!"
        -- case 48: " But that's...[K]completely the\nopposite of what we were told!"
        UI:WaitShowDialogue(' Grovyle, you came back to our\nworld to paralyze the planet...didn\'t you?!') -- FUT_M18B1401_032 (FR optionnel)
        -- case 50: " [CS:N]Grovyle[CR], you came back to our\nworld to paralyze the planet...didn't you?!"
        -- case 51: " [CS:N]Grovyle[CR], you came back to our\nworld to paralyze the planet...didn't you?!"
        UI:WaitShowDialogue(' And, Grovyle...\nweren\'t you the\none stealing the Time Gears?!') -- FUT_M18B1401_033 (FR optionnel)
        -- case 53: " And, [CS:N]Grovyle[CR]...[K]weren't you the\none stealing the Time Gears?!"
        -- case 54: " And, [CS:N]Grovyle[CR]...[K]weren't you the\none stealing the Time Gears?!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' You\'ve got to be joking!') -- FUT_M18B1401_034 (FR optionnel)
        UI:WaitShowDialogue(' I was collecting Time Gears...') -- FUT_M18B1401_035 (FR optionnel)
        UI:WaitShowDialogue(' Because they were needed for\npreventing the planet\'s paralysis.') -- FUT_M18B1401_036 (FR optionnel)
        UI:WaitShowDialogue(' I needed to take them to\nTemporal Tower and put them in place.') -- FUT_M18B1401_037 (FR optionnel)
        UI:WaitShowDialogue(' That would have reversed the\ncollapse of Temporal Tower, which was\nfully under way in your time.') -- FUT_M18B1401_038 (FR optionnel)
        UI:WaitShowDialogue(' While it is true that removing a\nTime Gear from a specific place causes time\nto stop in that area...') -- FUT_M18B1401_039 (FR optionnel)
        UI:WaitShowDialogue(' That\'s only temporary. After the\nTime Gears are put into Temporal Tower...') -- FUT_M18B1401_040 (FR optionnel)
        UI:WaitShowDialogue(' Time would have been fully\nrestored to normal everywhere.') -- FUT_M18B1401_041 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Urf...\n But then, what about all\nthe things Dusknoir said about you?') -- FUT_M18B1401_042 (FR optionnel)
        -- case 64: ' Urf...[K] But then, what about all\nthe things [CS:N]Dusknoir[CR] said about you?'
        -- case 65: ' Urf...[K] But then, what about all\nthe things [CS:N]Dusknoir[CR] said about you?'
        UI:WaitShowDialogue(' Like how he said you were a\nwanted outlaw in the future.') -- FUT_M18B1401_043 (FR optionnel)
        -- case 67: ' Like how he said you were a\nwanted outlaw in the future.'
        -- case 68: ' Like how he said you were a\nwanted outlaw in the future.'
        UI:WaitShowDialogue(' And how you escaped from\nthe future...') -- FUT_M18B1401_044 (FR optionnel)
        -- case 70: ' And how you escaped from\nthe future...'
        -- case 71: ' And how you escaped from\nthe future...'
        UI:WaitShowDialogue(' then fled to our world in\nthe past.') -- FUT_M18B1401_045 (FR optionnel)
        -- case 73: ' then fled to our world in\nthe past.'
        -- case 74: ' then fled to our world in\nthe past.'
        UI:WaitShowDialogue(' So you\'re saying all that was\njust a bunch of lies?') -- FUT_M18B1401_046 (FR optionnel)
        -- case 76: " So you're saying all that was\njust a bunch of lies?"
        -- case 77: " So you're claiming all that was\njust a bunch of lies?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What else could it be?') -- FUT_M18B1401_047 (FR optionnel)
        UI:WaitShowDialogue(' Because Dusknoir really is...') -- FUT_M18B1401_048 (FR optionnel)
        UI:WaitShowDialogue(' an agent sent from this future\nby Primal Necrozma...\nto get rid of me.') -- FUT_M18B1401_049 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What?!\n Dusknoir was...\nan agent\nsent to get rid of you?!') -- FUT_M18B1401_050 (FR optionnel)
        -- case 82: ' What?![K] [CS:N]Dusknoir[CR] was...[K]an agent\nsent to get rid of you?!'
        -- case 83: ' What?![K] [CS:N]Dusknoir[CR] was...[K]an agent\nsent to get rid of you?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s right.') -- FUT_M18B1401_051 (FR optionnel)
        UI:WaitShowDialogue(' I have said that Primal Necrozma...') -- FUT_M18B1401_052 (FR optionnel)
        UI:WaitShowDialogue(' will try to thwart any attempt\nto alter the course of history.') -- FUT_M18B1401_053 (FR optionnel)
        UI:WaitShowDialogue(' That\'s why, when he learned that\nI traveled through time...') -- FUT_M18B1401_054 (FR optionnel)
        UI:WaitShowDialogue(' He sent Dusknoir after me.') -- FUT_M18B1401_055 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' The great...\nDusknoir...?\n\nIt can\'t be!') -- FUT_M18B1401_056 (FR optionnel)
        -- case 90: " The great...[K][CS:N]Dusknoir[CR]...?[K]\nIt can't be!"
        -- case 91: " The great...[K][CS:N]Dusknoir[CR]...?[K]\nIt can't be!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' It\'s hard for you to believe,\nI know...') -- FUT_M18B1401_057 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' I can\'t believe it at all!') -- FUT_M18B1401_058 (FR optionnel)
        -- case 94: " I can't believe it at all!"
        -- case 95: " I can't believe it at all!"
        UI:WaitShowDialogue(' You\'re saying all this about\nthe great Dusknoir?!') -- FUT_M18B1401_059 (FR optionnel)
        -- case 97: " You're saying all this about\nthe great [CS:N]Dusknoir[CR]?!"
        -- case 98: " You're saying all this about\nthe great [CS:N]Dusknoir[CR]?!"
        UI:WaitShowDialogue(' I don\'t understand why Dusknoir\nis acting this way here, but...') -- FUT_M18B1401_060 (FR optionnel)
        -- case 100: " I don't understand why [CS:N]Dusknoir[CR]\nis acting this way here, but..."
        -- case 101: " I don't understand why [CS:N]Dusknoir[CR]\nis acting this way here, but..."
        UI:WaitShowDialogue(' But I admired...\nDusknoir...') -- FUT_M18B1401_061 (FR optionnel)
        -- case 103: ' But I admired...[K][CS:N]Dusknoir[CR]...'
        -- case 104: ' But I respected...[K][CS:N]Dusknoir[CR]...'
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('TearyEyed')
        UI:WaitShowDialogue(' I can\'t...\n I can\'t believe you...') -- FUT_M18B1401_062 (FR optionnel)
        -- case 106: " I can't...[K] I can't believe you..."
        -- case 107: " I can't...[K] I can't believe you..."
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('Time Gear.ogg', true) end) -- TimeGear
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('(It is hard to accept, but...)') -- FUT_M18B1401_063 (FR optionnel)
        -- case 109: '(It is hard to accept, but...)'
        UI:WaitShowDialogue('(Looking back over what we\'ve been through in\nthis future world...)') -- FUT_M18B1401_064 (FR optionnel)
        -- case 111: "(Looking back over what we've been through in\nthis future world...)"
        UI:WaitShowDialogue('(What Grovyle said is reasonable.\n It makes\nperfect sense.)') -- FUT_M18B1401_065 (FR optionnel)
        -- case 113: '(What [CS:N]Grovyle[CR] said is reasonable.[K] It makes\nperfect sense.)'
        UI:WaitShowDialogue('(And [partner] knows it.)') -- FUT_M18B1401_066 (FR optionnel)
        -- case 115: '(And [partner] knows it.)'
        UI:WaitShowDialogue('([partner] knows deep down that what\nGrovyle says is true.)') -- FUT_M18B1401_067 (FR optionnel)
        -- case 117: '([partner] knows deep down that what\n[CS:N]Grovyle[CR] says is true.)'
        UI:WaitShowDialogue('(But knowing that makes it that much harder\nto accept...)') -- FUT_M18B1401_068 (FR optionnel)
        -- case 119: '(But knowing that makes it that much harder\nto accept...)'
        UI:WaitShowDialogue('(But...)') -- FUT_M18B1401_069 (FR optionnel)
        -- case 121: '(But...)'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Teammate1'), 120, 396, false, 2.0)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Hey! Where are you going?') -- FUT_M18B1401_070 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' I\'m going to see Dusknoir.') -- FUT_M18B1401_071 (FR optionnel)
        -- case 124: " I'm going to see [CS:N]Dusknoir[CR]."
        -- case 125: " I'm going to see [CS:N]Dusknoir[CR]."
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What?!') -- FUT_M18B1401_072 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' I want to see Dusknoir.\n\nI\'m going to find out if what you said is true\nor not.') -- FUT_M18B1401_073 (FR optionnel)
        -- case 128: " I want to see [CS:N]Dusknoir[CR].[K]\nI'm going to find out if what you said is true\nor not."
        -- case 129: " I want to see [CS:N]Dusknoir[CR].[K]\nI'm going to find out if what you said is true\nor not."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What\'s the point of that?!') -- FUT_M18B1401_074 (FR optionnel)
        UI:WaitShowDialogue(' You\'ll only be making it easy for\nthem to get rid of you!') -- FUT_M18B1401_075 (FR optionnel)
        UI:WaitShowDialogue(' You don\'t stand a chance\nagainst them!') -- FUT_M18B1401_076 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Then...\nwhat am I supposed\nto do?!') -- FUT_M18B1401_077 (FR optionnel)
        -- case 134: ' Then...[K]what am I supposed\nto do?!'
        -- case 135: ' Then...[K]what am I supposed\nto do?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What are you supposed to do?!') -- FUT_M18B1401_078 (FR optionnel)
        UI:WaitShowDialogue(' Didn\'t you wonder this earlier?!') -- FUT_M18B1401_079 (FR optionnel)
        UI:WaitShowDialogue(' And you decided...that you would\ndecide for yourself!') -- FUT_M18B1401_080 (FR optionnel)
        UI:WaitShowDialogue(' You insisted that, because you\ndon\'t know what to believe...') -- FUT_M18B1401_081 (FR optionnel)
        UI:WaitShowDialogue(' you wouldn\'t accept words for\ntheir face value...\nand you\'d think for yourself!') -- FUT_M18B1401_082 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Urk...') -- FUT_M18B1401_083 (FR optionnel)
        -- case 142: ' Urk...'
        -- case 143: ' Urk...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' It\'s times like this, when things\nare tough, that you have to be strong.') -- FUT_M18B1401_084 (FR optionnel)
        UI:WaitShowDialogue(' Think for yourself, then act as\nyou deem right.') -- FUT_M18B1401_085 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 208, 396, false, 1.594)
        GAME:WaitFrames(20)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 0.7969*8, CH('Teammate1').Position.Y + 28*8, false, 1.594)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Grovyle...\n What are you going\nto do now?') -- FUT_M18B1401_086 (FR optionnel)
        -- case 147: ' [CS:N]Grovyle[CR]...[K] What are you going\nto do now?'
        -- case 148: ' [CS:N]Grovyle[CR]...[K] What are you going\nto do now?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' I\'m going back to the past again\nto stop the planet\'s paralysis.') -- FUT_M18B1401_087 (FR optionnel)
        UI:WaitShowDialogue(' To do that...') -- FUT_M18B1401_088 (FR optionnel)
        UI:WaitShowDialogue(' I need to find Celebi.') -- FUT_M18B1401_089 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Cel...\nCelebi?') -- FUT_M18B1401_090 (FR optionnel)
        -- case 153: ' [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?'
        -- case 154: ' [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s right.') -- FUT_M18B1401_091 (FR optionnel)
        UI:WaitShowDialogue(' You can come with me or not.\nIt\'s your choice.') -- FUT_M18B1401_092 (FR optionnel)
        UI:WaitShowDialogue(' You two decide on your own\ncourse of action.') -- FUT_M18B1401_093 (FR optionnel)
        UI:WaitShowDialogue(' I\'m off.') -- FUT_M18B1401_094 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 160*8, false, 2.0)
        GAME:WaitFrames(20)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 15)
        GAME:WaitFrames(60)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Urk...') -- FUT_M18B1401_095 (FR optionnel)
        -- case 160: ' Urk...'
        -- case 161: ' Urk...'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('(...............)') -- FUT_M18B1401_096 (FR optionnel)
        -- case 163: '(...............)'
        UI:WaitShowDialogue('(I don\'t know what I should believe either.)') -- FUT_M18B1401_097 (FR optionnel)
        -- case 165: "(I don't know what I should believe either.)"
        UI:WaitShowDialogue('(But...\nthere is one thing I can say with\ncertainty.)') -- FUT_M18B1401_098 (FR optionnel)
        -- case 167: '(But...[K]there is one thing I can say with\ncertainty.)'
        UI:WaitShowDialogue('(In this future world of darkness...)') -- FUT_M18B1401_099 (FR optionnel)
        -- case 169: '(In this future world of darkness...)'
        UI:WaitShowDialogue('(The planet is paralyzed.)') -- FUT_M18B1401_100 (FR optionnel)
        -- case 171: '(The planet is paralyzed.)'
        UI:WaitShowDialogue('(And the paralysis of the planet...\n It happened\nback in our world.)') -- FUT_M18B1401_101 (FR optionnel)
        -- case 173: '(And the paralysis of the planet...[K] It happened\nback in our world.)'
        UI:WaitShowDialogue('(That\'s why, to stop that from happening...)') -- FUT_M18B1401_102 (FR optionnel)
        -- case 175: "(That's why, to stop that from happening...)"
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('(We have to get back to the past!)') -- FUT_M18B1401_103 (FR optionnel)
        -- case 177: '(We have to get back to the past!)'
        UI:WaitShowDialogue('(We have to get back!\n Back to our world!)') -- FUT_M18B1401_104 (FR optionnel)
        -- case 179: '(We have to get back![K] Back to our world!)'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('PLAYER'), 208, 396, false, 2.0)
        GAME:WaitFrames(45)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Right, 15)
            end,
        })
        GAME:WaitFrames(80)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Left, 15)
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' [hero]...') -- FUT_M18B1401_105 (FR optionnel)
        -- case 181: ' [hero]...'
        -- case 182: ' [hero]...'
        UI:WaitShowDialogue(' Yup...\n I know...') -- FUT_M18B1401_106 (FR optionnel)
        -- case 184: ' Yup...[K] I know...'
        -- case 185: ' Yes...[K] I know...'
        UI:WaitShowDialogue(' What Grovyle said...\n Grovyle is\nright...') -- FUT_M18B1401_107 (FR optionnel)
        -- case 187: ' What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is\nright...'
        -- case 188: ' What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is\nright...'
        UI:WaitShowDialogue(' Things are very tough now...\n\nThat\'s why we have to be strong.') -- FUT_M18B1401_108 (FR optionnel)
        -- case 190: " Things are very tough now...[K]\nThat's why we have to be strong."
        -- case 191: " Things are very tough now...[K]\nThat's why we have to be strong."
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' I\'m all right now...\n Let\'s go.') -- FUT_M18B1401_109 (FR optionnel)
        -- case 193: " I'm all right now...[K] Let's go."
        -- case 194: " I'm all right now...[K] Let's go."
        UI:WaitShowDialogue(' Let\'s catch up to Grovyle.') -- FUT_M18B1401_110 (FR optionnel)
        -- case 196: " Let's catch up to [CS:N]Grovyle[CR]."
        -- case 197: " Let's catch up to [CS:N]Grovyle[CR]."
        UI:ResetSpeaker()
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 0.7969*8, CH('PLAYER').Position.Y + 24*8, false, 1.594)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' [hero].') -- FUT_M18B1401_111 (FR optionnel)
        -- case 199: ' [hero].'
        -- case 200: ' [hero].'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' We have to...\n We have to\nget back!') -- FUT_M18B1401_112 (FR optionnel)
        -- case 202: ' We have to...[K] We have to\nget back!'
        -- case 203: ' We have to...[K] We have to\nget back!'
        UI:WaitShowDialogue(' Back to our own world!') -- FUT_M18B1401_113 (FR optionnel)
        -- case 205: ' Back to our own world!'
        -- case 206: ' Back to our own world!'
        UI:ResetSpeaker()
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
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
  if not ok then PrintInfo('[m18b1401] scène interrompue : '..tostring(err)) end
end

return m18b1401
