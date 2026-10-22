--[[
    D18P11A_m17a0501.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D18P11A/m17a0501.ssb
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

local m17a0501 = {}

function m17a0501.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('...Huff-huff. Huff-huff...') -- FUT_M17A0501_001 (FR)
        -- case 0: ' ...Huff-huff.[K] Huff-huff...'
        -- case 1: ' ...Huff-huff.[K] Huff-huff...'
        UI:WaitShowDialogue('Hé, Massko. Je n\'en peux plus.') -- FUT_M17A0501_002 (FR)
        -- case 3: " Hey, [CS:N]Grovyle[CR]. I'm beat."
        -- case 4: " Listen, [CS:N]Grovyle[CR]. I'm exhausted."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Il n\'y a pas le temps de se reposer !') -- FUT_M17A0501_003 (FR)
        UI:WaitShowDialogue('S\'ils nous attrapent, nous sommes fichus ![br]Tiens bon et cours !') -- FUT_M17A0501_004 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('C\'est facile à dire pour toi... Huff-huff...') -- FUT_M17A0501_005 (FR)
        -- case 8: " That's easy for you to say...\nHuff-huff..."
        -- case 9: " That's easy for you to say...\nHuff-huff..."
        UI:WaitShowDialogue('Je ne peux pas. Je dois me reposer.') -- FUT_M17A0501_006 (FR)
        -- case 11: " I can't.[K] I have to rest."
        -- case 12: " I can't.[K] I have to rest."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('D\'accord.') -- FUT_M17A0501_007 (FR)
        UI:ResetSpeaker()
        -- back_SetGround(D18P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        GAME:WaitFrames(1)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Grovyle'), 312, 196, false, 2.398)
                GROUND:MoveToPosition(CH('Grovyle'), 336, 176, false, 3.0)
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), 280, 212, false, 2.398)
                GROUND:MoveToPosition(CH('PLAYER'), 312, 156, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), 264, 196, false, 2.398)
                GROUND:MoveToPosition(CH('Teammate1'), 280, 180, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
            end),
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Huff-huff... Huff-huff...') -- FUT_M17A0501_008 (FR)
        -- case 15: ' Huff-huff...[K] Huff-huff...'
        -- case 16: ' Huff-huff...[K] Huff-huff...'
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Cela forme une alcôve naturelle.') -- FUT_M17A0501_009 (FR)
        UI:WaitShowDialogue('Cette alcôve devrait nous dissimuler.') -- FUT_M17A0501_010 (FR)
        UI:WaitShowDialogue('Après une courte pause, nous devrons repartir.') -- FUT_M17A0501_011 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('A-attends une minute.') -- FUT_M17A0501_012 (FR)
        -- case 21: ' W-wait a minute.'
        -- case 22: ' W-wait a minute.'
        UI:WaitShowDialogue('Quand nous nous sommes échappés de la palissade, nous avons coopéré avec toi parce que nous n\'avions pas le choix...') -- FUT_M17A0501_013 (FR)
        -- case 24: ' When we escaped from the\nstockade, we cooperated with you because we\nhad to...'
        -- case 25: ' When we escaped from the\nstockade, we cooperated with you because we\nhad no other choice...'
        UI:WaitShowDialogue('Mais nous n\'avons jamais promis de continuer avec toi ensuite !') -- FUT_M17A0501_014 (FR)
        -- case 27: " But we never promised we'd go\nwith you afterward!"
        -- case 28: " But we didn't promise we'd go\nwith you afterward!"
        UI:WaitShowDialogue('Un mauvais Pokémon comme toi...[br]Pas question de te faire confiance.') -- FUT_M17A0501_015 (FR)
        -- case 30: " A bad Pokémon like you...[K]\nI'm not about to trust you with anything."
        -- case 31: " A bad Pokémon like you...[K]\nYou're not worth trusting."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('([partner]...)') -- FUT_M17A0501_016 (FR)
        -- case 33: '([partner]...)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Humph !') -- FUT_M17A0501_017 (FR)
        UI:WaitShowDialogue('Alors je suis le méchant... et ce Noctunoir, le gentil ?') -- FUT_M17A0501_018 (FR)
        UI:WaitShowDialogue('Dans ce cas, comment expliques-tu les agissements de Noctunoir tout à l\'heure ?') -- FUT_M17A0501_019 (FR)
        UI:WaitShowDialogue('Je n\'étais pas le seul visé... Ils voulaient aussi vous éliminer !') -- FUT_M17A0501_020 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Urk...') -- FUT_M17A0501_021 (FR)
        -- case 39: ' Urk...'
        -- case 40: ' Urk...'
        UI:WaitShowDialogue('Mais... Ça ne veut pas dire que je devrais te faire confiance, Massko...') -- FUT_M17A0501_022 (FR)
        -- case 42: " But...[K] That doesn't mean I should\nbe trusting you, [CS:N]Grovyle[CR]..."
        -- case 43: " But...[K] That doesn't mean I should\nput my faith in you, [CS:N]Grovyle[CR]..."
        UI:ResetSpeaker()
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Gagner ta confiance n\'est pas chose facile, à ce que je vois.') -- FUT_M17A0501_023 (FR)
        UI:WaitShowDialogue('Je pensais qu\'avoir des alliés nous aiderait, mais...') -- FUT_M17A0501_024 (FR)
        UI:WaitShowDialogue('Il n\'y a aucune raison de continuer ensemble sans confiance.') -- FUT_M17A0501_025 (FR)
        UI:WaitShowDialogue('On va se séparer.') -- FUT_M17A0501_026 (FR)
        UI:WaitShowDialogue('Je poursuis ma route.[br]Vous devriez repartir au plus vite, vous aussi.') -- FUT_M17A0501_027 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Right, 15)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Bonne chance.') -- FUT_M17A0501_028 (FR)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 368, 176, false, 1.0)
        GAME:WaitFrames(15)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Attends une seconde !') -- FUT_M17A0501_029 (FR)
        -- case 51: ' Wait a second!'
        -- case 52: ' Wait a second!'
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Tu nous dis de repartir au plus vite, mais...') -- FUT_M17A0501_030 (FR)
        UI:SetCenter(false)
        -- case 54: ' You say to leave soon, but...'
        -- case 55: ' You tell us to leave soon, but...'
        UI:SetCenter(true)
        UI:WaitShowDialogue('Il fait nuit. Nous voyons à peine où nous allons.') -- FUT_M17A0501_031 (FR)
        UI:SetCenter(false)
        -- case 57: " It's dark out now. It's tough to\nsee where we're going."
        -- case 58: " It's dark out now. It's hard to\nsee where we're going."
        UI:SetCenter(true)
        UI:WaitShowDialogue('Plutôt que de repartir tout de suite, pourquoi ne pas attendre le matin ?') -- FUT_M17A0501_032 (FR)
        UI:SetCenter(false)
        -- case 60: ' Instead of staying on the move\nright now, why not wait for morning?'
        -- case 61: " Instead of setting off again\nright away, shouldn't we wait for morning?"
        UI:SetCenter(true)
        UI:WaitShowDialogue('Ne pouvons-nous pas attendre qu\'il fasse jour ?') -- FUT_M17A0501_033 (FR)
        UI:SetCenter(false)
        -- case 63: " Can't we wait to leave until it\ngets light out?"
        -- case 64: " Wouldn't it be better to leave\nwhen it gets light out?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ce n\'est pas possible.') -- FUT_M17A0501_034 (FR)
        UI:WaitShowDialogue('Je suis désolé de vous l\'apprendre, mais... le matin ne vient jamais.') -- FUT_M17A0501_035 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hein ?') -- FUT_M17A0501_036 (FR)
        -- case 68: ' Huh?!'
        -- case 69: ' What?!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ce monde... votre avenir... est plongé dans des ténèbres perpétuelles.') -- FUT_M17A0501_037 (FR)
        UI:WaitShowDialogue('Le soleil ne se lève jamais. Le matin ne vient jamais.') -- FUT_M17A0501_038 (FR)
        UI:WaitShowDialogue('Les ténèbres persistent à jamais.') -- FUT_M17A0501_039 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('P-pourquoi ?') -- FUT_M17A0501_040 (FR)
        -- case 74: ' Wh-why?'
        -- case 75: ' Wh-why?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Parce que... la planète est paralysée.') -- FUT_M17A0501_041 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8962 (SE_NUM_EVENT_SIGN_HATENA_02)
        GROUND:CharSetEmote(CH('Teammate1'), 'question', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('La planète est... paralysée ?') -- FUT_M17A0501_042 (FR)
        -- case 78: ' The planet is...[K]paralyzed?'
        -- case 79: ' The planet is...[K]paralyzed?'
        UI:WaitShowDialogue('La Paralysie de la Planète...') -- FUT_M17A0501_043 (FR)
        -- case 81: " The planet's paralysis..."
        -- case 82: " The planet's paralysis..."
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('... La Paralysie de la Planète ![br]Mais oui ! Je me souviens maintenant !') -- FUT_M17A0501_044 (FR)
        -- case 84: " ...The planet's paralysis![K]\nThat's right! I remember now!"
        -- case 85: " ...The planet's paralysis![K]\nThat's right! I remember now!"
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue('Noctunoir nous avait déjà parlé de la Paralysie de la Planète...') -- FUT_M17A0501_045 (FR)
        UI:SetCenter(false)
        -- case 87: " [CS:N]Dusknoir[CR] described the\nplanet's paralysis before..."
        -- case 88: " [CS:N]Dusknoir[CR] described the\nplanet's paralysis before..."
        UI:ResetSpeaker()
        GAME:FadeOut(false, 30)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m17a0501] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m17a0501
