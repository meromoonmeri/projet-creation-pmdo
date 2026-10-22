--[[
    P06P01A_m18a0401.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P06P01A/m18a0401.ssb
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

local m18a0401 = {}

function m18a0401.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        SV.Scenario.Main = 19 -- flag_SetScenario(SCENARIO_MAIN, scenario=19, level=2)
        -- back_SetGround(P06P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('Teammate1'), 152, 212, false, 2.0)
        GAME:WaitFrames(20)
        GROUND:MoveToPosition(CH('PLAYER'), 128, 236, false, 2.0)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Huff-huff...\n We\'ve climbed a\nlong ways up...') -- FUT_M18A0401_001 (FR optionnel)
        -- case 0: " Huff-huff...[K] We've climbed a\nlong ways up..."
        -- case 1: " Huff-huff...[K] We've been climbing\na long time now..."
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 228, false, 2.0)
        GROUND:MoveToPosition(CH('Teammate1'), 272, 212, false, 2.0)
        GAME:WaitFrames(10)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('PLAYER'), 256, 236, false, 2.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpRight, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Whoa!\n Look at that, \n[hero]!') -- FUT_M18A0401_002 (FR optionnel)
        -- case 3: ' Whoa![K] Look at that, \n[hero]!'
        -- case 4: ' Wow![K] Look at that,\n[hero]!'
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 176, false, 1.0)
        GROUND:MoveToPosition(CH('Teammate1'), 316, 148, false, 1.594)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 276, 172, false, 1.594)
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' It was true...\n The future really\nis a world of darkness...') -- FUT_M18A0401_003 (FR optionnel)
        -- case 6: ' It was true...[K] The future really\nis a world of darkness...'
        -- case 7: ' It was true...[K] The future really\nis a world of darkness...'
        UI:WaitShowDialogue(' ...\nThat cluster of lights...') -- FUT_M18A0401_004 (FR optionnel)
        -- case 9: ' ...[K]That cluster of lights...'
        -- case 10: ' ...[K]That cluster of lights...'
        UI:WaitShowDialogue(' It\'s beautiful, but...') -- FUT_M18A0401_005 (FR optionnel)
        -- case 12: " It's beautiful, but..."
        -- case 13: " It's beautiful, but..."
        UI:WaitShowDialogue(' Those lights...\n Isn\'t that...\n\nthe stockade?') -- FUT_M18A0401_006 (FR optionnel)
        -- case 15: " Those lights...[K] Isn't that...[K]\nthe stockade?"
        -- case 16: " Those lights...[K] Isn't that...[K]\nthe stockade?"
        UI:ResetSpeaker()
        GAME:WaitFrames(90)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Hey, [hero]...') -- FUT_M18A0401_007 (FR optionnel)
        UI:SetCenter(false)
        -- case 18: ' Hey, [hero]...'
        -- case 19: ' Hey, [hero]...'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' The great Dusknoir saved us\nmore than once.') -- FUT_M18A0401_008 (FR optionnel)
        -- case 21: ' The great [CS:N]Dusknoir[CR] saved us\nmore than once.'
        -- case 22: ' The great [CS:N]Dusknoir[CR] saved us\nmore than once.'
        UI:WaitShowDialogue(' He taught us many things too.') -- FUT_M18A0401_009 (FR optionnel)
        -- case 24: ' He taught us many things too.'
        -- case 25: ' He taught us many things too.'
        UI:WaitShowDialogue(' That\'s why I...\nI really looked up\nto Dusknoir.') -- FUT_M18A0401_010 (FR optionnel)
        -- case 27: " That's why I...[K]I really looked up\nto [CS:N]Dusknoir[CR]."
        -- case 28: " That's why I...[K]I came to really\nrespect [CS:N]Dusknoir[CR]."
        UI:WaitShowDialogue(' But was Dusknoir...\ndeceiving us?') -- FUT_M18A0401_011 (FR optionnel)
        -- case 30: ' But was [CS:N]Dusknoir[CR]...[K]deceiving us?'
        -- case 31: ' But was [CS:N]Dusknoir[CR]...[K]deceiving us?'
        UI:WaitShowDialogue(' Even after all this...\nI still can\'t\nbelieve it.') -- FUT_M18A0401_012 (FR optionnel)
        -- case 33: " Even after all this...[K]I still can't\nbelieve it."
        -- case 34: " Even after all this...[K]I still can't\nbelieve it."
        UI:WaitShowDialogue(' I don\'t know what to believe\nanymore...') -- FUT_M18A0401_013 (FR optionnel)
        -- case 36: " I don't know what to believe\nanymore..."
        -- case 37: " I don't know what to believe\nanymore..."
        UI:WaitShowDialogue(' My head feels all messed up...') -- FUT_M18A0401_014 (FR optionnel)
        -- case 39: ' My head feels all messed up...'
        -- case 40: " I'm feeling all jumbled up..."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('([partner]...)') -- FUT_M18A0401_015 (FR optionnel)
        -- case 42: '([partner]...)'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        GAME:WaitFrames(15)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBGM('Time Gear Remix.ogg', true) end) -- TimeGearRemix
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' What should we...\n What should\nwe do now?') -- FUT_M18A0401_016 (FR optionnel)
        -- case 44: ' What should we...[K] What should\nwe do now?'
        -- case 45: ' What should we...[K] What should\nwe do now?'
        UI:WaitShowDialogue(' When can we stop running?') -- FUT_M18A0401_017 (FR optionnel)
        -- case 47: ' When can we stop running?'
        -- case 48: ' How far do we have to run?'
        UI:WaitShowDialogue(' Can we return to our world?') -- FUT_M18A0401_018 (FR optionnel)
        -- case 50: ' Can we return to our world?'
        -- case 51: ' How do we go back to our\nown world?'
        UI:ResetSpeaker()
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' ..................') -- FUT_M18A0401_019 (FR optionnel)
        -- case 53: ' ..................'
        -- case 54: ' ..................'
        UI:WaitShowDialogue(' Everyone at the guild...\n I wonder\nhow they\'re doing?') -- FUT_M18A0401_020 (FR optionnel)
        -- case 56: " Everyone at the guild...[K] I wonder\nhow they're doing?"
        -- case 57: " Everyone at the guild...[K] I wonder\nhow they're doing?"
        UI:WaitShowDialogue(' Are they worried about us\nbeing gone?') -- FUT_M18A0401_021 (FR optionnel)
        -- case 59: ' Are they worried about us\nbeing gone?'
        -- case 60: ' Are they worried about us?'
        UI:WaitShowDialogue(' Wigglytuff, Chatot, Bidoof, and\neveryone else...\n I wonder if they\'re doing well?') -- FUT_M18A0401_022 (FR optionnel)
        -- case 62: " [CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], and\neveryone else...[K] I wonder if they're doing well?"
        -- case 63: " [CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], and\neveryone else...[K] I wonder if they're doing well?"
        UI:ResetSpeaker()
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -1*8, false, 2.0)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('TearyEyed')
        UI:WaitShowDialogue(' I m-m-miss the guild...\n I want\nto see everyone!') -- FUT_M18A0401_023 (FR optionnel)
        -- case 65: ' I m-m-miss the guild...[K] I want\nto see everyone!'
        -- case 66: ' I m-m-miss the guild...[K] I want\nto see everyone!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('([partner]\'s feeling pretty down.)') -- FUT_M18A0401_024 (FR optionnel)
        -- case 68: "([partner]'s feeling pretty down.)"
        UI:WaitShowDialogue('(It\'s only natural.)') -- FUT_M18A0401_025 (FR optionnel)
        -- case 70: "(It's only natural.)"
        UI:WaitShowDialogue('(What\'s happened so far...\n It\'s all so hard\nto believe.)') -- FUT_M18A0401_026 (FR optionnel)
        -- case 72: "(What's happened so far...[K] It's all so hard\nto believe.)"
        UI:WaitShowDialogue('(I\'m...\nscared too.)') -- FUT_M18A0401_027 (FR optionnel)
        -- case 74: "(I'm...[K]scared too.)"
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('(But...\nI can\'t give up now.)') -- FUT_M18A0401_028 (FR optionnel)
        -- case 76: "(But...[K]I can't give up now.)"
        UI:WaitShowDialogue('(If we don\'t keep going, those Sableye will\ncatch us.)') -- FUT_M18A0401_029 (FR optionnel)
        -- case 78: "(If we don't keep going, those [CS:N]Sableye[CR] will\ncatch us.)"
        UI:WaitShowDialogue('(I\'ve got to do something to cheer up\n[partner].)') -- FUT_M18A0401_030 (FR optionnel)
        -- case 80: "(I've got to do something to cheer up\n[partner].)"
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(But words of support will seem like false\ncomfort right now...)') -- FUT_M18A0401_031 (FR optionnel)
        -- case 82: '(But words of support will seem like false\ncomfort right now...)'
        UI:WaitShowDialogue('(If there were something I could say...\n\nSomething that offers a glimmer of hope...)') -- FUT_M18A0401_032 (FR optionnel)
        -- case 84: '(If there were something I could say...[K]\nSomething that offers a glimmer of hope...)'
        UI:WaitShowDialogue('(If only there were some hope, we could work\ntoward it...)') -- FUT_M18A0401_033 (FR optionnel)
        -- case 86: '(If only there were some hope, we could work\ntoward it...)'
        UI:WaitShowDialogue('(It could be anything.\n I just need to think\nof something!)') -- FUT_M18A0401_034 (FR optionnel)
        -- case 88: '(It could be anything.[K] I just need to think\nof something!)'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('PLAYER'), 276, 148, false, 1.0)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Right, 15)
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        -- SetEffect id 172 : NON CONVERTI (table effets REQUISE)
        -- WaitEffect (les appels GROUND sont bloquants)
        GAME:WaitFrames(10)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Huh?') -- FUT_M18A0401_035 (FR optionnel)
        -- case 90: ' Huh?'
        -- case 91: ' Hmm?'
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue(' What\'s up, [hero]?') -- FUT_M18A0401_036 (FR optionnel)
        -- case 93: " What's up, [hero]?"
        -- case 94: ' What is it, [hero]?'
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What?!\n You want to go after\nGrovyle?') -- FUT_M18A0401_037 (FR optionnel)
        -- case 98: ' What?![K] You want to go after\n[CS:N]Grovyle[CR]?'
        -- case 99: ' What?![K] You want to go after\n[CS:N]Grovyle[CR]?'
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue(' Wh-why?!') -- FUT_M18A0401_038 (FR optionnel)
        -- case 101: ' Wh-why?!'
        -- case 102: ' Wh-why?!'
        -- Jump (structurel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Huh?!\n Let\'s return to our world?') -- FUT_M18A0401_039 (FR optionnel)
        -- case 104: " Huh?![K] Let's return to our world?"
        -- case 105: " What?![K] Let's return to\nour world?"
        UI:WaitShowDialogue(' How are we supposed to return?') -- FUT_M18A0401_040 (FR optionnel)
        -- case 107: ' How are we supposed to return?'
        -- case 108: ' How are we supposed to return?'
        UI:WaitShowDialogue(' Well, sure, it would be great if\nwe could go back to our world...') -- FUT_M18A0401_041 (FR optionnel)
        -- case 110: ' Well, sure, it would be great if\nwe could go back to our world...'
        -- case 111: ' Well, sure, it would be great if\nwe could go back to our world...'
        UI:WaitShowDialogue(' But...how?') -- FUT_M18A0401_042 (FR optionnel)
        -- case 113: ' But...how?'
        -- case 114: ' But...how?'
        UI:ResetSpeaker()
        -- ExecuteCommon(EXPLANATION_FUNC_SERIES) : gestuelle parallèle à implémenter
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8962') end) -- TODO table SE id 8962
        GROUND:CharSetEmote(CH('Teammate1'), 'question', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Huh?\n We\'re going to first find\nGrovyle?') -- FUT_M18A0401_043 (FR optionnel)
        -- case 116: " Huh?[K] We're going to first find\n[CS:N]Grovyle[CR]?"
        -- case 117: " What?[K] We're going to first find\n[CS:N]Grovyle[CR]?"
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue(' So we find Grovyle...\n\nThen what?') -- FUT_M18A0401_044 (FR optionnel)
        -- case 119: ' So we find [CS:N]Grovyle[CR]...[K]\nThen what?'
        -- case 120: ' So if we do find [CS:N]Grovyle[CR]...[K]\nThen what?'
        -- Jump (structurel)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(' Ask him something?') -- FUT_M18A0401_045 (FR optionnel)
        -- case 124: ' Ask him something?'
        -- case 125: ' Ask him something?'
        UI:WaitShowDialogue(' Oh...\nright...') -- FUT_M18A0401_046 (FR optionnel)
        -- case 127: ' Oh...[K]right...'
        -- case 128: ' Oh...[K]I see...'
        -- Jump (structurel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(' You wanted to know something?') -- FUT_M18A0401_047 (FR optionnel)
        -- case 130: ' You wanted to know something?'
        -- case 131: ' You wanted to know something?'
        UI:WaitShowDialogue(' Oh...\nright...') -- FUT_M18A0401_048 (FR optionnel)
        -- case 133: ' Oh...[K]right...'
        -- case 134: ' Oh...[K]I see...'
        -- Jump (structurel)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Grovyle went to our world from\nhere the first time.') -- FUT_M18A0401_049 (FR optionnel)
        -- case 136: ' [CS:N]Grovyle[CR] went to our world from\nhere the first time.'
        -- case 137: ' [CS:N]Grovyle[CR] went to our world from\nhere the first time.'
        UI:WaitShowDialogue(' So Grovyle should know how\nto go to our world.') -- FUT_M18A0401_050 (FR optionnel)
        -- case 139: ' So [CS:N]Grovyle[CR] should know how\nto go to our world.'
        -- case 140: ' So [CS:N]Grovyle[CR] should know how\nto travel to our world.'
        UI:WaitShowDialogue(' But...\nisn\'t Grovyle a bad\nPokémon?') -- FUT_M18A0401_051 (FR optionnel)
        -- case 142: " But...[K]isn't [CS:N]Grovyle[CR] a bad\nPokémon?"
        -- case 143: " But...[K]isn't [CS:N]Grovyle[CR] a bad\nPokémon?"
        UI:WaitShowDialogue(' Didn\'t he...\ncome to our world to\nsteal the Time Gears?') -- FUT_M18A0401_052 (FR optionnel)
        -- case 145: " Didn't he...[K]come to our world to\nsteal the Time Gears?"
        -- case 146: " Didn't he...[K]come to our world to\nsteal the Time Gears?"
        UI:WaitShowDialogue(' How could I trust anything that\nhe\'d say?') -- FUT_M18A0401_053 (FR optionnel)
        -- case 148: " How could I trust anything that\nhe'd say?"
        -- case 149: ' How could I trust anything he\nwould say?'
        UI:WaitShowDialogue(' What about you, [hero]?') -- FUT_M18A0401_054 (FR optionnel)
        -- case 151: ' What about you, [hero]?'
        -- case 152: ' What about you, [hero]?'
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue(' Do you trust Grovyle,\n[hero]?') -- FUT_M18A0401_055 (FR optionnel)
        -- case 154: ' Do you trust [CS:N]Grovyle[CR],\n[hero]?'
        -- case 155: ' Do you trust [CS:N]Grovyle[CR],\n[hero]?'
        -- Jump (structurel)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' Well...\nI can\'t trust him!') -- FUT_M18A0401_056 (FR optionnel)
        -- case 159: " Well...[K]I can't trust him!"
        -- case 160: " Well...[K]I can't trust him!"
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(' A Pokémon like that? Never!') -- FUT_M18A0401_057 (FR optionnel)
        UI:SetCenter(false)
        -- case 162: ' A Pokémon like that? Never!'
        -- case 163: ' A Pokémon like that? Never!'
        UI:SetCenter(true)
        UI:WaitShowDialogue(' There\'s no way that I can\ntrust him!') -- FUT_M18A0401_058 (FR optionnel)
        UI:SetCenter(false)
        -- case 165: " There's no way that I can\ntrust him!"
        -- case 166: " There's no way that I can\ntrust him!"
        UI:SetCenter(true)
        UI:WaitShowDialogue(' There\'s just no way! But...') -- FUT_M18A0401_059 (FR optionnel)
        UI:SetCenter(false)
        -- case 168: " There's just no way! But..."
        -- case 169: " There's just no way! But..."
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' But...\nI understand, [hero].') -- FUT_M18A0401_060 (FR optionnel)
        -- case 171: ' But...[K]I understand, [hero].'
        -- case 172: ' But...[K]I understand, [hero].'
        UI:WaitShowDialogue(' I don\'t know why, but Dusknoir\nwants to get rid of us.') -- FUT_M18A0401_061 (FR optionnel)
        -- case 174: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        -- case 175: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        UI:WaitShowDialogue(' That means the only other\nPokémon we know here in the future...') -- FUT_M18A0401_062 (FR optionnel)
        -- case 177: ' That means the only other\nPokémon we know here in the future...'
        -- case 178: ' That means the only other\nPokémon we know here in the future...'
        UI:WaitShowDialogue(' That leaves only Grovyle...') -- FUT_M18A0401_063 (FR optionnel)
        -- case 180: ' That leaves only [CS:N]Grovyle[CR]...'
        -- case 181: ' That leaves only [CS:N]Grovyle[CR]...'
        UI:WaitShowDialogue(' We don\'t have any choice.\n\nWe must rely on Grovyle.') -- FUT_M18A0401_064 (FR optionnel)
        -- case 183: " We don't have any choice.[K]\nWe must rely on [CS:N]Grovyle[CR]."
        -- case 184: ' We have no choice.[K] We must pin\nour hopes on [CS:N]Grovyle[CR].'
        UI:ResetSpeaker()
        -- Jump (structurel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(' And you don\'t know either,\ndo you, [hero]?') -- FUT_M18A0401_065 (FR optionnel)
        -- case 186: " And you don't know either,\ndo you, [hero]?"
        -- case 187: " And you don't know either,\ndo you, [hero]?"
        UI:WaitShowDialogue(' But you still want to catch up to\nGrovyle and talk to him?') -- FUT_M18A0401_066 (FR optionnel)
        -- case 189: ' But you still want to catch up to\n[CS:N]Grovyle[CR] and talk to him?'
        -- case 190: ' But you still insist on catching\nup to [CS:N]Grovyle[CR] so you can talk to him?'
        UI:WaitShowDialogue(' And then trust what he says?') -- FUT_M18A0401_067 (FR optionnel)
        -- case 192: ' And then trust what he says?'
        -- case 193: ' And then trust what he says?'
        UI:ResetSpeaker()
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' Well...\nI hate this idea!') -- FUT_M18A0401_068 (FR optionnel)
        -- case 195: ' Well...[K]I hate this idea!'
        -- case 196: ' Well...[K]I hate this idea!'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Trust a Pokémon like that?\n\nNever!') -- FUT_M18A0401_069 (FR optionnel)
        UI:SetCenter(false)
        -- case 198: ' Trust a Pokémon like that?[K]\nNever!'
        -- case 199: ' Trust a Pokémon like that?[K]\nNever!'
        UI:SetCenter(true)
        UI:WaitShowDialogue(' That bad Pokémon!\n Trust that...') -- FUT_M18A0401_070 (FR optionnel)
        UI:SetCenter(false)
        -- case 201: ' That bad Pokémon![K] Trust that...'
        -- case 202: ' That bad Pokémon![K] Trust that...'
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' I don\'t want to...\n But...') -- FUT_M18A0401_071 (FR optionnel)
        -- case 204: " I don't want to...[K] But..."
        -- case 205: " I don't want to...[K] But..."
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' But...\nmaybe we don\'t have any\nother choice...') -- FUT_M18A0401_072 (FR optionnel)
        UI:SetCenter(false)
        -- case 207: " But...[K]maybe we don't have any\nother choice..."
        -- case 208: " But...[K]maybe we don't have any\nother choice..."
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I don\'t know why, but Dusknoir\nwants to get rid of us.') -- FUT_M18A0401_073 (FR optionnel)
        UI:SetCenter(false)
        -- case 210: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        -- case 211: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        UI:SetCenter(true)
        UI:WaitShowDialogue(' That means the only other\nPokémon we know here in the future...') -- FUT_M18A0401_074 (FR optionnel)
        UI:SetCenter(false)
        -- case 213: ' That means the only other\nPokémon we know here in the future...'
        -- case 214: ' That means the only other\nPokémon we know here in the future...'
        UI:SetCenter(true)
        UI:WaitShowDialogue(' That leaves only Grovyle...') -- FUT_M18A0401_075 (FR optionnel)
        UI:SetCenter(false)
        -- case 216: ' That leaves only [CS:N]Grovyle[CR]...'
        -- case 217: ' That leaves only [CS:N]Grovyle[CR]...'
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We don\'t have any choice.\n\nWe must rely on Grovyle.') -- FUT_M18A0401_076 (FR optionnel)
        UI:SetCenter(false)
        -- case 219: " We don't have any choice.[K]\nWe must rely on [CS:N]Grovyle[CR]."
        -- case 220: ' We have no choice.[K] We must pin\nour hopes on [CS:N]Grovyle[CR].'
        UI:ResetSpeaker()
        -- Jump (structurel)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        SOUND:FadeOutBGM(160)
        GAME:WaitFrames(180)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Well then...\nall right.') -- FUT_M18A0401_077 (FR optionnel)
        -- case 222: ' Well then...[K]all right.'
        -- case 223: ' Well then...[K]OK.'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        UI:SetCenter(true)
        UI:WaitShowDialogue(' All right, [hero].\n\nLet\'s chase after Grovyle!') -- FUT_M18A0401_078 (FR optionnel)
        UI:SetCenter(false)
        -- case 225: " All right, [hero].[K]\nLet's chase after [CS:N]Grovyle[CR]!"
        -- case 226: " OK, [hero].[K] Let's track\ndown [CS:N]Grovyle[CR]!"
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s meet with Grovyle and ask\nhim how to get back to our world!') -- FUT_M18A0401_079 (FR optionnel)
        UI:SetCenter(false)
        -- case 228: " Let's meet with [CS:N]Grovyle[CR] and ask\nhim how to get back to our world!"
        -- case 229: " Let's meet with [CS:N]Grovyle[CR] and ask\nhim how we can return to our world!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Inspired')
        UI:WaitShowDialogue('([partner]!)') -- FUT_M18A0401_080 (FR optionnel)
        -- case 231: '([partner]!)'
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Let\'s go, [hero]!') -- FUT_M18A0401_081 (FR optionnel)
        -- case 233: " Let's go, [hero]!"
        -- case 234: " Let's go, [hero]!"
        UI:WaitShowDialogue(' Let\'s go after Grovyle!') -- FUT_M18A0401_082 (FR optionnel)
        -- case 236: " Let's go after [CS:N]Grovyle[CR]!"
        -- case 237: " Let's go after [CS:N]Grovyle[CR]!"
        UI:ResetSpeaker()
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(45)
        GROUND:MoveToPosition(CH('PLAYER'), 376, 180, false, 1.594)
        GAME:WaitFrames(30)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 360, 176, false, 1.594)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownRight, 15)
        pcall(function() SOUND:PlayBGM('In the Hands of Fate.ogg', true) end) -- InTheHandsOfFate
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' [hero], thanks.') -- FUT_M18A0401_083 (FR optionnel)
        -- case 239: ' [hero], thanks.'
        -- case 240: ' [hero], thank you.'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' You were worried about me for\nbeing so down.') -- FUT_M18A0401_084 (FR optionnel)
        -- case 242: ' You were worried about me for\nbeing so down.'
        -- case 243: ' You tried to pick me up because\nI was feeling down.'
        UI:WaitShowDialogue(' Even though you should be just \nas scared as I am, [hero]...\n I\'m sorry.') -- FUT_M18A0401_085 (FR optionnel)
        -- case 245: " Even though you should be just \nas scared as I am, [hero]...[K] I'm sorry."
        -- case 246: " Even though you should be just \nas scared as I am, [hero]...[K] I'm sorry."
        UI:WaitShowDialogue(' Even though I have my closest\nand most precious friend with me...') -- FUT_M18A0401_086 (FR optionnel)
        -- case 248: ' Even though I have my closest\nand most precious friend with me...'
        -- case 249: ' Even though I have my closest\nand most precious friend with me...'
        UI:WaitShowDialogue(' I worried all alone...') -- FUT_M18A0401_087 (FR optionnel)
        -- case 251: ' I worried all alone...'
        -- case 252: ' I worried all alone...'
        UI:WaitShowDialogue(' And almost gave up alone.') -- FUT_M18A0401_088 (FR optionnel)
        -- case 254: ' And almost gave up alone.'
        -- case 255: ' And almost gave up alone.'
        UI:WaitShowDialogue(' When, in fact, I\'m not alone.') -- FUT_M18A0401_089 (FR optionnel)
        -- case 257: " When, in fact, I'm not alone."
        -- case 258: " When, in fact, I'm not alone."
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Teammate1'), 340, 180, false, 1.594)
        GAME:WaitFrames(15)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Left, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
            end,
        })
        GAME:WaitFrames(10)
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' I won\'t give up anymore.') -- FUT_M18A0401_090 (FR optionnel)
        -- case 260: " I won't give up anymore."
        -- case 261: " I won't give up anymore."
        UI:WaitShowDialogue(' Because you\'re by my side, I can\nbe brave, [hero].') -- FUT_M18A0401_091 (FR optionnel)
        -- case 263: " Because you're by my side, I can\nbe brave, [hero]."
        -- case 264: " Because you're by my side, I can\nbe brave, [hero]."
        UI:WaitShowDialogue(' I\'m going to be fine now.') -- FUT_M18A0401_092 (FR optionnel)
        -- case 266: " I'm going to be fine now."
        -- case 267: " I'm going to be fine now."
        UI:WaitShowDialogue(' So let\'s keep going,\n[hero].') -- FUT_M18A0401_093 (FR optionnel)
        -- case 269: " So let's keep going,\n[hero]."
        -- case 270: " So let's keep going,\n[hero]."
        UI:WaitShowDialogue(' Let\'s get back to our world...\n\ntogether!') -- FUT_M18A0401_094 (FR optionnel)
        -- case 272: " Let's get back to our world...[K]\ntogether!"
        -- case 273: " Let's get back to our world...[K]\ntogether!"
        UI:ResetSpeaker()
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(45)
        SOUND:FadeOutBGM(180)
        GROUND:MoveToPosition(CH('PLAYER'), 488, 204, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 24*8, false, 2.0)
        GROUND:MoveToPosition(CH('Teammate1'), 468, 204, false, 2.0)
        GAME:WaitFrames(30)
        GAME:FadeOut(false, 60)
        -- WaitBgm : PARTIEL
        GAME:WaitFrames(90)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m18a0401] scène interrompue : '..tostring(err)) end
end

return m18a0401
