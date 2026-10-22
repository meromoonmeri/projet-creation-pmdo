--[[
    D19P11A_m18a0101.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D19P11A/m18a0101.ssb
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

local m18a0101 = {}

function m18a0101.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        SV.Scenario.Main = 19 -- flag_SetScenario(SCENARIO_MAIN, scenario=19, level=1)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hé ! [hero] !') -- FUT_M18A0101_001 (FR)
        -- case 0: ' Hey! [hero]!'
        -- case 1: ' Look! [hero]!'
        UI:WaitShowDialogue('C\'est la sortie, là-bas ?') -- FUT_M18A0101_002 (FR)
        -- case 3: ' Is that the exit over there?'
        -- case 4: ' Could that be the exit over\nthere?'
        UI:WaitShowDialogue('Allons voir !') -- FUT_M18A0101_003 (FR)
        -- case 6: " Let's check it out!"
        -- case 7: " Let's go over there!"
        UI:ResetSpeaker()
        -- back_SetGround(D19P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        GAME:FadeIn(30)
        GAME:WaitFrames(60)
        GROUND:MoveToPosition(CH('Teammate1'), 160, 172, false, 2.398)
        GAME:WaitFrames(20)
        GROUND:MoveToPosition(CH('PLAYER'), 136, 196, false, 2.398)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Huff-huff... Huff-huff...') -- FUT_M18A0101_004 (FR)
        -- case 9: ' Huff-huff...[K] Huff-huff...'
        -- case 10: ' Huff-huff...[K] Huff-huff...'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 15)
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Avons-nous réussi à distancer les Ténéfix ? Huff-huff...') -- FUT_M18A0101_005 (FR)
        -- case 12: ' Did we manage to stretch our\nlead over those [CS:N]Sableye[CR]? Huff-huff...'
        -- case 13: ' Did we put some distance\nbetween us and those [CS:N]Sableye[CR]? Huff-huff...'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('On devrait se reposer un peu.') -- FUT_M18A0101_006 (FR)
        -- case 15: ' We should rest a bit here.'
        -- case 16: " Let's rest a little now."
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_DOWN_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
        GAME:WaitFrames(15)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8978 (SE_NUM_EVENT_SIGN_NOTICE_05)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hé ! Il y a de l\'eau !') -- FUT_M18A0101_007 (FR)
        -- case 18: " Hey! There's water there!"
        -- case 19: " Oh! There's water there!"
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 316, 188, false, 2.0)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), 296, 196, false, 2.0)
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), 336, 172, false, 2.0)
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
            end),
        })
        GAME:WaitFrames(15)
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8962 (SE_NUM_EVENT_SIGN_HATENA_02)
        GROUND:CharSetEmote(CH('Teammate1'), 'question', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('Hein ?') -- FUT_M18A0101_008 (FR)
        -- case 21: ' Huh...?'
        -- case 22: ' What...?'
        UI:WaitShowDialogue('Cette cascade... L\'eau ne coule pas...') -- FUT_M18A0101_009 (FR)
        -- case 24: " This waterfall...[K] The water's not\nflowing..."
        -- case 25: " This waterfall...[K] This water isn't\nflowing at all."
        UI:WaitShowDialogue('Cette eau tumultueuse reste complètement suspendue dans les airs !') -- FUT_M18A0101_010 (FR)
        -- case 27: ' The gushing water is totally\nsuspended in space!'
        -- case 28: ' The gushing water is totally\nsuspended in space!'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Massko avait-il donc raison ?') -- FUT_M18A0101_011 (FR)
        -- case 30: ' Is [CS:N]Grovyle[CR] right after all?'
        -- case 31: ' Is [CS:N]Grovyle[CR] right after all?'
        UI:WaitShowDialogue('Le temps s\'est vraiment arrêté à l\'avenir ?') -- FUT_M18A0101_012 (FR)
        -- case 33: ' Has time really stopped in\nthe future?'
        -- case 34: ' Has time really stopped in\nthe future?'
        UI:WaitShowDialogue('Pourquoi Noctunoir nous a amenés ici ?') -- FUT_M18A0101_013 (FR)
        -- case 36: ' Why did [CS:N]Dusknoir[CR] bring us here?'
        -- case 37: ' Why did [CS:N]Dusknoir[CR] bring us here?'
        UI:WaitShowDialogue('Le grand Noctunoir, qui s\'était montré si bienveillant envers nous...') -- FUT_M18A0101_014 (FR)
        -- case 39: ' The great [CS:N]Dusknoir[CR], who was so\nkind to us...'
        -- case 40: ' The great [CS:N]Dusknoir[CR], who was so\nkind to us...'
        UI:WaitShowDialogue('Je ne sais plus quoi croire...') -- FUT_M18A0101_015 (FR)
        -- case 42: " I don't know what to believe\nanymore..."
        -- case 43: " I don't know what to believe\nanymore..."
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Si seulement il y avait une façon de trouver la vérité...') -- FUT_M18A0101_016 (FR)
        -- case 45: ' If only there were some way of\nfinding the truth...'
        -- case 46: ' If only there were some way of\nfinding the truth...'
        UI:ResetSpeaker()
        GAME:WaitFrames(30)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8965 (SE_NUM_EVENT_SIGN_NOTICE_02)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Oh ! Je sais !') -- FUT_M18A0101_017 (FR)
        -- case 48: ' Oh! I know!'
        -- case 49: ' Oh! I know!'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Il existe un moyen de découvrir la vérité, [hero] !') -- FUT_M18A0101_018 (FR)
        -- case 51: ' There is a way of getting at the\ntruth, [hero]!'
        -- case 52: ' There is a way of getting at the\ntruth, [hero]!'
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        -- SetEffect id 174 : NON CONVERTI (table effets REQUISE)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(Hein ?)') -- FUT_M18A0101_019 (FR)
        -- case 54: '(Huh?)'
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ton Cri Dimensionnel !') -- FUT_M18A0101_020 (FR)
        -- case 56: ' Your Dimensional Scream!'
        -- case 57: ' Your Dimensional Scream!'
        UI:WaitShowDialogue('Utilise ton Cri Dimensionnel, [hero] !') -- FUT_M18A0101_021 (FR)
        -- case 59: ' Use your Dimensional Scream,\n[hero]!'
        -- case 60: ' Use your Dimensional Scream,\n[hero]!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Touche cette eau gelée !') -- FUT_M18A0101_022 (FR)
        UI:SetCenter(false)
        -- case 62: ' Touch this frozen water!'
        -- case 63: ' Touch this frozen water!'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        UI:SetCenter(true)
        UI:WaitShowDialogue('Qui sait ? Tu verras peut-être quelque chose !') -- FUT_M18A0101_023 (FR)
        UI:SetCenter(false)
        -- case 65: ' Who knows? You may see\nsomething!'
        -- case 66: ' Who knows? You may see\nsomething!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(Oh, je comprends...)') -- FUT_M18A0101_024 (FR)
        -- case 68: '(Oh, I understand...)'
        UI:WaitShowDialogue('(C\'est vrai... Ça vaut le coup...)') -- FUT_M18A0101_025 (FR)
        -- case 70: "(That's true...[K] It's worth a try...)"
        UI:WaitShowDialogue('(En touchant cette eau gelée...)') -- FUT_M18A0101_026 (FR)
        -- case 72: '(Touching that frozen water...)'
        UI:WaitShowDialogue('(Cela pourrait nous fournir des indices sur ce qui nous arrive.)') -- FUT_M18A0101_027 (FR)
        -- case 74: "(It might give us clues about what's happening\nto us.)"
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('On ne devrait pas perdre du temps. Ces Ténéfix nous rattraperont.') -- FUT_M18A0101_028 (FR)
        -- case 76: " We shouldn't waste any time.\nThose [CS:N]Sableye[CR] will catch up to us."
        -- case 77: " We can't dawdle. Those [CS:N]Sableye[CR]\nwill catch up to us."
        UI:WaitShowDialogue('Faisons ça vite !') -- FUT_M18A0101_029 (FR)
        -- case 79: " Let's do this quickly!"
        -- case 80: " Let's do this quickly!"
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(180)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 0.7969*8, CH('Teammate1').Position.Y + 24*8, false, 1.594)
        GAME:WaitFrames(10)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), 316, 172, false, 1.594)
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpLeft, 15)
            end),
        })
        GAME:WaitFrames(30)
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8962 (SE_NUM_EVENT_SIGN_HATENA_02)
        GROUND:CharSetEmote(CH('Teammate1'), 'question', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('... Alors, [hero] ?') -- FUT_M18A0101_030 (FR)
        -- case 83: " ...[K]How's it going, [hero]?"
        -- case 84: ' ...[K]Well, [hero]?'
        UI:WaitShowDialogue('Tu vois quelque chose ?') -- FUT_M18A0101_031 (FR)
        -- case 86: ' Can you see anything?'
        -- case 87: ' Can you see anything?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(..................)') -- FUT_M18A0101_032 (FR)
        -- case 89: '(..................)'
        UI:WaitShowDialogue('(.................................)') -- FUT_M18A0101_033 (FR)
        -- case 91: '(..............................)'
        UI:WaitShowDialogue('(...................................................)') -- FUT_M18A0101_034 (FR)
        -- case 93: '(..........................................)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('(... Non. Je ne sens rien.)') -- FUT_M18A0101_035 (FR)
        -- case 95: "(...No.[K] I'm not sensing anything.)"
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        GAME:WaitFrames(30)
        -- ExecuteCommon(HEAD_SHAKE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Tu ne vois rien ?') -- FUT_M18A0101_036 (FR)
        -- case 97: ' No, huh?'
        -- case 98: ' No, huh?'
        UI:WaitShowDialogue('Argh... Dommage. J\'aurais été plus tranquille si nous avions commencé à comprendre ce qui se passe...') -- FUT_M18A0101_037 (FR)
        -- case 100: " Urf... That's too bad.[K] It would've\nmade me less worried if we could begin to\nunderstand what's happening..."
        -- case 101: " Urf... That's disappointing.[K]\nIt would've been reassuring if we could begin\nto understand what's happening..."
        UI:WaitShowDialogue('On n\'a rien appris du tout...') -- FUT_M18A0101_038 (FR)
        -- case 103: " We didn't learn anything at all..."
        -- case 104: " We didn't learn anything at all..."
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 15)
        GAME:WaitFrames(60)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('On a passé beaucoup de temps ici.') -- FUT_M18A0101_039 (FR)
        -- case 106: " We've spent a lot of time here."
        -- case 107: " We've spent a lot of time here."
        UI:WaitShowDialogue('Si on ne se dépêche pas, ces Ténéfix nous rattraperont.') -- FUT_M18A0101_040 (FR)
        -- case 109: " If we don't hurry, those [CS:N]Sableye[CR]\nwill catch up to us."
        -- case 110: " If we don't hurry, those [CS:N]Sableye[CR]\nwill get to us."
        UI:WaitShowDialogue('Préparons-nous et partons, [hero].') -- FUT_M18A0101_041 (FR)
        -- case 112: " Let's get ready and go,\n[hero]."
        -- case 113: " Let's get ready and go,\n[hero]."
        UI:ResetSpeaker()
        -- performer 0
        -- NON CONVERTI : MovePositionLives [1, 0]
        -- bgm_PlayFadeIn [40, 0, 256] : BGM DarkHill non mappé
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m18a0101] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m18a0101
