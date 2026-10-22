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
        UI:WaitShowDialogue('Huff-huff... Nous avons beaucoup grimpé...') -- FUT_M18A0401_001 (FR)
        -- case 0: " Huff-huff...[K] We've climbed a\nlong ways up..."
        -- case 1: " Huff-huff...[K] We've been climbing\na long time now..."
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 228, false, 2.0)
        GROUND:MoveToPosition(CH('Teammate1'), 272, 212, false, 2.0)
        GAME:WaitFrames(10)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), 256, 236, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
            end),
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO SE 8974 (SE_NUM_EVENT_MOTION_JUNP_01)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpRight, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Ouah ! Regarde ça, [hero] !') -- FUT_M18A0401_002 (FR)
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
        UI:WaitShowDialogue('C\'était donc vrai... Le futur est vraiment un monde plongé dans les ténèbres...') -- FUT_M18A0401_003 (FR)
        -- case 6: ' It was true...[K] The future really\nis a world of darkness...'
        -- case 7: ' It was true...[K] The future really\nis a world of darkness...'
        UI:WaitShowDialogue('... Ce bouquet de lumières...') -- FUT_M18A0401_004 (FR)
        -- case 9: ' ...[K]That cluster of lights...'
        -- case 10: ' ...[K]That cluster of lights...'
        UI:WaitShowDialogue('C\'est magnifique, mais...') -- FUT_M18A0401_005 (FR)
        -- case 12: " It's beautiful, but..."
        -- case 13: " It's beautiful, but..."
        UI:WaitShowDialogue('Ces lumières... Ce ne serait pas...[br]la palissade ?') -- FUT_M18A0401_006 (FR)
        -- case 15: " Those lights...[K] Isn't that...[K]\nthe stockade?"
        -- case 16: " Those lights...[K] Isn't that...[K]\nthe stockade?"
        UI:ResetSpeaker()
        GAME:WaitFrames(90)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Hé, [hero]...') -- FUT_M18A0401_007 (FR)
        UI:SetCenter(false)
        -- case 18: ' Hey, [hero]...'
        -- case 19: ' Hey, [hero]...'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Le grand Noctunoir nous a sauvés plus d\'une fois.') -- FUT_M18A0401_008 (FR)
        -- case 21: ' The great [CS:N]Dusknoir[CR] saved us\nmore than once.'
        -- case 22: ' The great [CS:N]Dusknoir[CR] saved us\nmore than once.'
        UI:WaitShowDialogue('Il nous a enseigné beaucoup de choses aussi.') -- FUT_M18A0401_009 (FR)
        -- case 24: ' He taught us many things too.'
        -- case 25: ' He taught us many things too.'
        UI:WaitShowDialogue('C\'est pour cela que... j\'admirais vraiment Noctunoir.') -- FUT_M18A0401_010 (FR)
        -- case 27: " That's why I...[K]I really looked up\nto [CS:N]Dusknoir[CR]."
        -- case 28: " That's why I...[K]I came to really\nrespect [CS:N]Dusknoir[CR]."
        UI:WaitShowDialogue('Mais est-ce que Noctunoir nous trompait ?') -- FUT_M18A0401_011 (FR)
        -- case 30: ' But was [CS:N]Dusknoir[CR]...[K]deceiving us?'
        -- case 31: ' But was [CS:N]Dusknoir[CR]...[K]deceiving us?'
        UI:WaitShowDialogue('Même après tout ça... Je n\'y crois toujours pas.') -- FUT_M18A0401_012 (FR)
        -- case 33: " Even after all this...[K]I still can't\nbelieve it."
        -- case 34: " Even after all this...[K]I still can't\nbelieve it."
        UI:WaitShowDialogue('Je ne sais plus quoi croire...') -- FUT_M18A0401_013 (FR)
        -- case 36: " I don't know what to believe\nanymore..."
        -- case 37: " I don't know what to believe\nanymore..."
        UI:WaitShowDialogue('J\'ai la tête complètement embrouillée...') -- FUT_M18A0401_014 (FR)
        -- case 39: ' My head feels all messed up...'
        -- case 40: " I'm feeling all jumbled up..."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('([partner]...)') -- FUT_M18A0401_015 (FR)
        -- case 42: '([partner]...)'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        GAME:WaitFrames(15)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBGM('Time Gear Remix.ogg', true) end) -- TimeGearRemix
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Que devons-nous... Qu\'allons-nous faire maintenant ?') -- FUT_M18A0401_016 (FR)
        -- case 44: ' What should we...[K] What should\nwe do now?'
        -- case 45: ' What should we...[K] What should\nwe do now?'
        UI:WaitShowDialogue('Quand peut-on arrêter de courir ?') -- FUT_M18A0401_017 (FR)
        -- case 47: ' When can we stop running?'
        -- case 48: ' How far do we have to run?'
        UI:WaitShowDialogue('On peut retourner dans notre monde ?') -- FUT_M18A0401_018 (FR)
        -- case 50: ' Can we return to our world?'
        -- case 51: ' How do we go back to our\nown world?'
        UI:ResetSpeaker()
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('......') -- FUT_M18A0401_019 (FR)
        -- case 53: ' ..................'
        -- case 54: ' ..................'
        UI:WaitShowDialogue('Tous les membres de la guilde... Je me demande comment ils vont.') -- FUT_M18A0401_020 (FR)
        -- case 56: " Everyone at the guild...[K] I wonder\nhow they're doing?"
        -- case 57: " Everyone at the guild...[K] I wonder\nhow they're doing?"
        UI:WaitShowDialogue('Est-ce qu\'ils s\'inquiètent de notre absence ?') -- FUT_M18A0401_021 (FR)
        -- case 59: ' Are they worried about us\nbeing gone?'
        -- case 60: ' Are they worried about us?'
        UI:WaitShowDialogue('Grodoudou, Pijako, Keunotor, et tout le monde... Je me demande s\'ils vont bien ?') -- FUT_M18A0401_022 (FR)
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
        UI:WaitShowDialogue('L-la guilde me manque... Je veux revoir tout le monde !') -- FUT_M18A0401_023 (FR)
        -- case 65: ' I m-m-miss the guild...[K] I want\nto see everyone!'
        -- case 66: ' I m-m-miss the guild...[K] I want\nto see everyone!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('([partner] semble vraiment abattu...)') -- FUT_M18A0401_024 (FR)
        -- case 68: "([partner]'s feeling pretty down.)"
        UI:WaitShowDialogue('(C\'est bien naturel.)') -- FUT_M18A0401_025 (FR)
        -- case 70: "(It's only natural.)"
        UI:WaitShowDialogue('(Tout ce qui s\'est passé jusqu\'ici... C\'est si difficile à croire.)') -- FUT_M18A0401_026 (FR)
        -- case 72: "(What's happened so far...[K] It's all so hard\nto believe.)"
        UI:WaitShowDialogue('(Moi aussi... j\'ai peur.)') -- FUT_M18A0401_027 (FR)
        -- case 74: "(I'm...[K]scared too.)"
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('(Mais... je ne peux pas abandonner maintenant.)') -- FUT_M18A0401_028 (FR)
        -- case 76: "(But...[K]I can't give up now.)"
        UI:WaitShowDialogue('(Si nous ne continuons pas, ces Ténéfix nous attraperont.)') -- FUT_M18A0401_029 (FR)
        -- case 78: "(If we don't keep going, those [CS:N]Sableye[CR] will\ncatch us.)"
        UI:WaitShowDialogue('(Je dois faire quelque chose pour encourager [partner].)') -- FUT_M18A0401_030 (FR)
        -- case 80: "(I've got to do something to cheer up\n[partner].)"
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(Mais de simples paroles réconfortantes sembleraient creuses en ce moment...)') -- FUT_M18A0401_031 (FR)
        -- case 82: '(But words of support will seem like false\ncomfort right now...)'
        UI:WaitShowDialogue('(Si je pouvais dire quelque chose...[br]Quelque chose qui offre une lueur d\'espoir...)') -- FUT_M18A0401_032 (FR)
        -- case 84: '(If there were something I could say...[K]\nSomething that offers a glimmer of hope...)'
        UI:WaitShowDialogue('(Si seulement nous avions un espoir auquel nous raccrocher...)') -- FUT_M18A0401_033 (FR)
        -- case 86: '(If only there were some hope, we could work\ntoward it...)'
        UI:WaitShowDialogue('(N\'importe quoi ferait l\'affaire. Il faut juste que je trouve une idée !)') -- FUT_M18A0401_034 (FR)
        -- case 88: '(It could be anything.[K] I just need to think\nof something!)'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('PLAYER'), 276, 148, false, 1.0)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Right, 15)
        GAME:WaitFrames(20)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        -- SetEffect id 172 : NON CONVERTI (table effets REQUISE)
        -- WaitEffect (les appels GROUND sont bloquants)
        GAME:WaitFrames(10)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hein ?') -- FUT_M18A0401_035 (FR)
        -- case 90: ' Huh?'
        -- case 91: ' Hmm?'
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue('Qu\'y a-t-il, [hero] ?') -- FUT_M18A0401_036 (FR)
        -- case 93: " What's up, [hero]?"
        -- case 94: ' What is it, [hero]?'
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO SE 8974 (SE_NUM_EVENT_MOTION_JUNP_01)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi ? Tu veux qu\'on poursuive Massko ?') -- FUT_M18A0401_037 (FR)
        -- case 98: ' What?![K] You want to go after\n[CS:N]Grovyle[CR]?'
        -- case 99: ' What?![K] You want to go after\n[CS:N]Grovyle[CR]?'
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue('P-pourquoi ?!') -- FUT_M18A0401_038 (FR)
        -- case 101: ' Wh-why?!'
        -- case 102: ' Wh-why?!'
        -- Jump (structurel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO SE 8974 (SE_NUM_EVENT_MOTION_JUNP_01)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Hein ? Rentrer dans notre monde ?') -- FUT_M18A0401_039 (FR)
        -- case 104: " Huh?![K] Let's return to our world?"
        -- case 105: " What?![K] Let's return to\nour world?"
        UI:WaitShowDialogue('Comment sommes-nous censés revenir ?') -- FUT_M18A0401_040 (FR)
        -- case 107: ' How are we supposed to return?'
        -- case 108: ' How are we supposed to return?'
        UI:WaitShowDialogue('Bien sûr, ce serait super si on pouvait retourner dans notre monde...') -- FUT_M18A0401_041 (FR)
        -- case 110: ' Well, sure, it would be great if\nwe could go back to our world...'
        -- case 111: ' Well, sure, it would be great if\nwe could go back to our world...'
        UI:WaitShowDialogue('Mais... comment ?') -- FUT_M18A0401_042 (FR)
        -- case 113: ' But...how?'
        -- case 114: ' But...how?'
        UI:ResetSpeaker()
        -- ExecuteCommon(EXPLANATION_FUNC_SERIES) : gestuelle parallèle à implémenter
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8962 (SE_NUM_EVENT_SIGN_HATENA_02)
        GROUND:CharSetEmote(CH('Teammate1'), 'question', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hein ? On va d\'abord retrouver Massko ?') -- FUT_M18A0401_043 (FR)
        -- case 116: " Huh?[K] We're going to first find\n[CS:N]Grovyle[CR]?"
        -- case 117: " What?[K] We're going to first find\n[CS:N]Grovyle[CR]?"
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue('Alors on retrouve Massko...[br]Et ensuite ?') -- FUT_M18A0401_044 (FR)
        -- case 119: ' So we find [CS:N]Grovyle[CR]...[K]\nThen what?'
        -- case 120: ' So if we do find [CS:N]Grovyle[CR]...[K]\nThen what?'
        -- Jump (structurel)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('Lui demander quelque chose ?') -- FUT_M18A0401_045 (FR)
        -- case 124: ' Ask him something?'
        -- case 125: ' Ask him something?'
        UI:WaitShowDialogue('C\'est vrai...') -- FUT_M18A0401_046 (FR)
        -- case 127: ' Oh...[K]right...'
        -- case 128: ' Oh...[K]I see...'
        -- Jump (structurel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('Tu voulais savoir quelque chose ?') -- FUT_M18A0401_047 (FR)
        -- case 130: ' You wanted to know something?'
        -- case 131: ' You wanted to know something?'
        UI:WaitShowDialogue('C\'est vrai...') -- FUT_M18A0401_048 (FR)
        -- case 133: ' Oh...[K]right...'
        -- case 134: ' Oh...[K]I see...'
        -- Jump (structurel)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Massko a réussi à venir d\'ici jusque dans notre monde.') -- FUT_M18A0401_049 (FR)
        -- case 136: ' [CS:N]Grovyle[CR] went to our world from\nhere the first time.'
        -- case 137: ' [CS:N]Grovyle[CR] went to our world from\nhere the first time.'
        UI:WaitShowDialogue('Il doit donc savoir comment nous y ramener.') -- FUT_M18A0401_050 (FR)
        -- case 139: ' So [CS:N]Grovyle[CR] should know how\nto go to our world.'
        -- case 140: ' So [CS:N]Grovyle[CR] should know how\nto travel to our world.'
        UI:WaitShowDialogue('Mais... Massko n\'est-il pas un mauvais Pokémon ?') -- FUT_M18A0401_051 (FR)
        -- case 142: " But...[K]isn't [CS:N]Grovyle[CR] a bad\nPokémon?"
        -- case 143: " But...[K]isn't [CS:N]Grovyle[CR] a bad\nPokémon?"
        UI:WaitShowDialogue('N\'est-il pas venu dans notre monde pour voler les Rouages du Temps ?') -- FUT_M18A0401_052 (FR)
        -- case 145: " Didn't he...[K]come to our world to\nsteal the Time Gears?"
        -- case 146: " Didn't he...[K]come to our world to\nsteal the Time Gears?"
        UI:WaitShowDialogue('Comment pourrais-je croire un seul mot de ce qu\'il pourrait nous dire ?') -- FUT_M18A0401_053 (FR)
        -- case 148: " How could I trust anything that\nhe'd say?"
        -- case 149: ' How could I trust anything he\nwould say?'
        UI:WaitShowDialogue('Et toi, [hero] ?') -- FUT_M18A0401_054 (FR)
        -- case 151: ' What about you, [hero]?'
        -- case 152: ' What about you, [hero]?'
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue('Tu fais confiance à Massko, [hero] ?') -- FUT_M18A0401_055 (FR)
        -- case 154: ' Do you trust [CS:N]Grovyle[CR],\n[hero]?'
        -- case 155: ' Do you trust [CS:N]Grovyle[CR],\n[hero]?'
        -- Jump (structurel)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('Eh bien... Je ne peux pas lui faire confiance !') -- FUT_M18A0401_056 (FR)
        -- case 159: " Well...[K]I can't trust him!"
        -- case 160: " Well...[K]I can't trust him!"
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue('Un Pokémon comme ça ? Jamais !') -- FUT_M18A0401_057 (FR)
        UI:SetCenter(false)
        -- case 162: ' A Pokémon like that? Never!'
        -- case 163: ' A Pokémon like that? Never!'
        UI:SetCenter(true)
        UI:WaitShowDialogue('Je ne peux pas lui faire confiance !') -- FUT_M18A0401_058 (FR)
        UI:SetCenter(false)
        -- case 165: " There's no way that I can\ntrust him!"
        -- case 166: " There's no way that I can\ntrust him!"
        UI:SetCenter(true)
        UI:WaitShowDialogue('C\'est impossible ! Mais...') -- FUT_M18A0401_059 (FR)
        UI:SetCenter(false)
        -- case 168: " There's just no way! But..."
        -- case 169: " There's just no way! But..."
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Mais... je comprends, [hero].') -- FUT_M18A0401_060 (FR)
        -- case 171: ' But...[K]I understand, [hero].'
        -- case 172: ' But...[K]I understand, [hero].'
        UI:WaitShowDialogue('Je ne sais pas pourquoi, mais Noctunoir veut se débarrasser de nous.') -- FUT_M18A0401_061 (FR)
        -- case 174: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        -- case 175: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        UI:WaitShowDialogue('Cela signifie que le seul autre Pokémon que nous connaissons dans ce futur...') -- FUT_M18A0401_062 (FR)
        -- case 177: ' That means the only other\nPokémon we know here in the future...'
        -- case 178: ' That means the only other\nPokémon we know here in the future...'
        UI:WaitShowDialogue('C\'est Massko...') -- FUT_M18A0401_063 (FR)
        -- case 180: ' That leaves only [CS:N]Grovyle[CR]...'
        -- case 181: ' That leaves only [CS:N]Grovyle[CR]...'
        UI:WaitShowDialogue('On n\'a pas le choix.[br]Nous devons compter sur Massko.') -- FUT_M18A0401_064 (FR)
        -- case 183: " We don't have any choice.[K]\nWe must rely on [CS:N]Grovyle[CR]."
        -- case 184: ' We have no choice.[K] We must pin\nour hopes on [CS:N]Grovyle[CR].'
        UI:ResetSpeaker()
        -- Jump (structurel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('Et toi non plus, tu n\'en sais rien, n\'est-ce pas, [hero] ?') -- FUT_M18A0401_065 (FR)
        -- case 186: " And you don't know either,\ndo you, [hero]?"
        -- case 187: " And you don't know either,\ndo you, [hero]?"
        UI:WaitShowDialogue('Mais tu veux toujours rattraper Massko et lui parler ?') -- FUT_M18A0401_066 (FR)
        -- case 189: ' But you still want to catch up to\n[CS:N]Grovyle[CR] and talk to him?'
        -- case 190: ' But you still insist on catching\nup to [CS:N]Grovyle[CR] so you can talk to him?'
        UI:WaitShowDialogue('Et ensuite, croire ce qu\'il nous dira ?') -- FUT_M18A0401_067 (FR)
        -- case 192: ' And then trust what he says?'
        -- case 193: ' And then trust what he says?'
        UI:ResetSpeaker()
        GROUND:CharSetAnim(CH('PLAYER'), 'Nod', false) -- param 71 = anim 22 (Nod)
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation 2 (spécial : boucle anim courante)
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('Eh bien... Je déteste cette idée !') -- FUT_M18A0401_068 (FR)
        -- case 195: ' Well...[K]I hate this idea!'
        -- case 196: ' Well...[K]I hate this idea!'
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue('Faire confiance à un Pokémon pareil ?[br]Jamais !') -- FUT_M18A0401_069 (FR)
        UI:SetCenter(false)
        -- case 198: ' Trust a Pokémon like that?[K]\nNever!'
        -- case 199: ' Trust a Pokémon like that?[K]\nNever!'
        UI:SetCenter(true)
        UI:WaitShowDialogue('Faire confiance à ce mauvais Pokémon...') -- FUT_M18A0401_070 (FR)
        UI:SetCenter(false)
        -- case 201: ' That bad Pokémon![K] Trust that...'
        -- case 202: ' That bad Pokémon![K] Trust that...'
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Je ne veux pas... Mais...') -- FUT_M18A0401_071 (FR)
        -- case 204: " I don't want to...[K] But..."
        -- case 205: " I don't want to...[K] But..."
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Mais... peut-être qu\'on n\'a pas d\'autre choix...') -- FUT_M18A0401_072 (FR)
        UI:SetCenter(false)
        -- case 207: " But...[K]maybe we don't have any\nother choice..."
        -- case 208: " But...[K]maybe we don't have any\nother choice..."
        UI:SetCenter(true)
        UI:WaitShowDialogue('Je ne sais pas pourquoi, mais Noctunoir veut se débarrasser de nous.') -- FUT_M18A0401_073 (FR)
        UI:SetCenter(false)
        -- case 210: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        -- case 211: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        UI:SetCenter(true)
        UI:WaitShowDialogue('Cela signifie que le seul autre Pokémon que nous connaissons dans ce futur...') -- FUT_M18A0401_074 (FR)
        UI:SetCenter(false)
        -- case 213: ' That means the only other\nPokémon we know here in the future...'
        -- case 214: ' That means the only other\nPokémon we know here in the future...'
        UI:SetCenter(true)
        UI:WaitShowDialogue('C\'est Massko...') -- FUT_M18A0401_075 (FR)
        UI:SetCenter(false)
        -- case 216: ' That leaves only [CS:N]Grovyle[CR]...'
        -- case 217: ' That leaves only [CS:N]Grovyle[CR]...'
        UI:SetCenter(true)
        UI:WaitShowDialogue('On n\'a pas le choix.[br]Nous devons compter sur Massko.') -- FUT_M18A0401_076 (FR)
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
        UI:WaitShowDialogue('Alors... d\'accord.') -- FUT_M18A0401_077 (FR)
        -- case 222: ' Well then...[K]all right.'
        -- case 223: ' Well then...[K]OK.'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        UI:SetCenter(true)
        UI:WaitShowDialogue('D\'accord, [hero].[br]Rattrapons Massko !') -- FUT_M18A0401_078 (FR)
        UI:SetCenter(false)
        -- case 225: " All right, [hero].[K]\nLet's chase after [CS:N]Grovyle[CR]!"
        -- case 226: " OK, [hero].[K] Let's track\ndown [CS:N]Grovyle[CR]!"
        UI:SetCenter(true)
        UI:WaitShowDialogue('Retrouvons Massko et demandons-lui comment rentrer dans notre monde !') -- FUT_M18A0401_079 (FR)
        UI:SetCenter(false)
        -- case 228: " Let's meet with [CS:N]Grovyle[CR] and ask\nhim how to get back to our world!"
        -- case 229: " Let's meet with [CS:N]Grovyle[CR] and ask\nhim how we can return to our world!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Inspired')
        UI:WaitShowDialogue('([partner] !)') -- FUT_M18A0401_080 (FR)
        -- case 231: '([partner]!)'
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Allons-y, [hero] !') -- FUT_M18A0401_081 (FR)
        -- case 233: " Let's go, [hero]!"
        -- case 234: " Let's go, [hero]!"
        UI:WaitShowDialogue('Rattrapons Massko !') -- FUT_M18A0401_082 (FR)
        -- case 236: " Let's go after [CS:N]Grovyle[CR]!"
        -- case 237: " Let's go after [CS:N]Grovyle[CR]!"
        UI:ResetSpeaker()
        GROUND:CharSetAnim(CH('PLAYER'), 'Nod', false) -- param 71 = anim 22 (Nod)
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        GROUND:CharSetAnim(CH('PLAYER'), 'Nod', false) -- param 71 = anim 22 (Nod)
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation 2 (spécial : boucle anim courante)
        GAME:WaitFrames(45)
        GROUND:MoveToPosition(CH('PLAYER'), 376, 180, false, 1.594)
        GAME:WaitFrames(30)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 360, 176, false, 1.594)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownRight, 15)
        pcall(function() SOUND:PlayBGM('Sympathy.ogg', true) end) -- InTheHandsOfFate
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('[hero], merci.') -- FUT_M18A0401_083 (FR)
        -- case 239: ' [hero], thanks.'
        -- case 240: ' [hero], thank you.'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Tu t\'inquiétais parce que j\'avais le moral à zéro.') -- FUT_M18A0401_084 (FR)
        -- case 242: ' You were worried about me for\nbeing so down.'
        -- case 243: ' You tried to pick me up because\nI was feeling down.'
        UI:WaitShowDialogue('Alors que tu dois avoir aussi peur que moi, [hero]... Je suis désolé.') -- FUT_M18A0401_085 (FR)
        -- case 245: " Even though you should be just \nas scared as I am, [hero]...[K] I'm sorry."
        -- case 246: " Even though you should be just \nas scared as I am, [hero]...[K] I'm sorry."
        UI:WaitShowDialogue('Même avec à mes côtés mon ami le plus proche et le plus précieux...') -- FUT_M18A0401_086 (FR)
        -- case 248: ' Even though I have my closest\nand most precious friend with me...'
        -- case 249: ' Even though I have my closest\nand most precious friend with me...'
        UI:WaitShowDialogue('Je me tourmentais dans mon coin...') -- FUT_M18A0401_087 (FR)
        -- case 251: ' I worried all alone...'
        -- case 252: ' I worried all alone...'
        UI:WaitShowDialogue('Et j\'ai failli abandonner, comme si j\'étais livré à moi-même.') -- FUT_M18A0401_088 (FR)
        -- case 254: ' And almost gave up alone.'
        -- case 255: ' And almost gave up alone.'
        UI:WaitShowDialogue('Alors qu\'en réalité, je ne suis pas seul.') -- FUT_M18A0401_089 (FR)
        -- case 257: " When, in fact, I'm not alone."
        -- case 258: " When, in fact, I'm not alone."
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Teammate1'), 340, 180, false, 1.594)
        GAME:WaitFrames(15)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Left, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
            end),
        })
        GAME:WaitFrames(10)
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Je n\'abandonnerai plus.') -- FUT_M18A0401_090 (FR)
        -- case 260: " I won't give up anymore."
        -- case 261: " I won't give up anymore."
        UI:WaitShowDialogue('Avec toi à mes côtés, je peux trouver le courage, [hero].') -- FUT_M18A0401_091 (FR)
        -- case 263: " Because you're by my side, I can\nbe brave, [hero]."
        -- case 264: " Because you're by my side, I can\nbe brave, [hero]."
        UI:WaitShowDialogue('Ça va aller maintenant.') -- FUT_M18A0401_092 (FR)
        -- case 266: " I'm going to be fine now."
        -- case 267: " I'm going to be fine now."
        UI:WaitShowDialogue('Alors continuons, [hero].') -- FUT_M18A0401_093 (FR)
        -- case 269: " So let's keep going,\n[hero]."
        -- case 270: " So let's keep going,\n[hero]."
        UI:WaitShowDialogue('Rentrons dans notre monde...[br]ensemble !') -- FUT_M18A0401_094 (FR)
        -- case 272: " Let's get back to our world...[K]\ntogether!"
        -- case 273: " Let's get back to our world...[K]\ntogether!"
        UI:ResetSpeaker()
        GROUND:CharSetAnim(CH('PLAYER'), 'Nod', false) -- param 71 = anim 22 (Nod)
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        GROUND:CharSetAnim(CH('PLAYER'), 'Nod', false) -- param 71 = anim 22 (Nod)
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation 2 (spécial : boucle anim courante)
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
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m18a0401] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m18a0401
