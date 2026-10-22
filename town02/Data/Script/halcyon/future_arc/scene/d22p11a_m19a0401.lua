--[[
    D22P11A_m19a0401.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D22P11A/m19a0401.ssb
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

local m19a0401 = {}

function m19a0401.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        GAME:FadeOut(false, 30)
        -- back_SetGround(D22P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(30)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Vous semblez enfin prêts.') -- FUT_M19A0401_001 (FR)
        UI:WaitShowDialogue('Allons-y. Nous trouverons Celebi et nous retournerons dans le passé.') -- FUT_M19A0401_002 (FR)
        UI:WaitShowDialogue('Allons-y.') -- FUT_M19A0401_003 (FR)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 276, 84, false, 2.0)
        GAME:WaitFrames(20)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
            end),
        })
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        SOUND:FadeOutBGM(160)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Attends ! Une seconde !') -- FUT_M19A0401_004 (FR)
        -- case 3: ' Wait a sec! Hold on!'
        -- case 4: " Oh, wait! Don't go!"
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Qu\'y a-t-il ?') -- FUT_M19A0401_005 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Si nous parvenons tous les trois à rentrer dans notre monde...') -- FUT_M19A0401_006 (FR)
        -- case 7: ' If the three of us could get back\nto our world...'
        -- case 8: ' If the three of us do return to\nour world...'
        UI:WaitShowDialogue('Massko, vas-tu... continuer à voler les Rouages du Temps comme auparavant ?') -- FUT_M19A0401_007 (FR)
        -- case 10: ' [CS:N]Grovyle[CR], will you...[K]keep stealing\nTime Gears like you did before?'
        -- case 11: ' [CS:N]Grovyle[CR], will you...[K]steal the Time\nGears like you did before?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Eh bien... oui.') -- FUT_M19A0401_008 (FR)
        UI:WaitShowDialogue('Sinon, la Paralysie de la Planète ne pourra pas être arrêtée.') -- FUT_M19A0401_009 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Mais je...') -- FUT_M19A0401_010 (FR)
        -- case 15: ' But I...'
        -- case 16: ' But I...'
        UI:WaitShowDialogue('Massko, je ne suis pas encore convaincu.') -- FUT_M19A0401_011 (FR)
        -- case 18: " [CS:N]Grovyle[CR], I'm not convinced yet."
        -- case 19: " [CS:N]Grovyle[CR], I'm not convinced yet."
        UI:WaitShowDialogue('Ne crois pas que je te fais entièrement confiance.') -- FUT_M19A0401_012 (FR)
        -- case 21: " Don't assume that you have my\ncomplete trust."
        -- case 22: " I don't completely trust you yet."
        UI:WaitShowDialogue('Je voyage avec toi parce que je veux retourner dans notre monde.') -- FUT_M19A0401_013 (FR)
        -- case 24: " I'm only traveling with you\nbecause I want to get back to our world."
        -- case 25: " I'm only cooperating with you\nbecause I want to return to our world."
        UI:WaitShowDialogue('Si nous revenons, Massko...') -- FUT_M19A0401_014 (FR)
        -- case 27: ' If we do get back, [CS:N]Grovyle[CR]...'
        -- case 28: ' If we do return, [CS:N]Grovyle[CR]...'
        UI:WaitShowDialogue('Je découvrirai alors si tu volais vraiment ces Rouages du Temps pour empêcher la Paralysie de la Planète.') -- FUT_M19A0401_015 (FR)
        -- case 30: " I'll find out if you really were\nstealing those Time Gears to prevent the\nplanet's paralysis."
        -- case 31: " I'll investigate if you really\nwere stealing those Time Gears to prevent the\nplanet's paralysis."
        UI:WaitShowDialogue('Massko, si je finis par estimer que tu as tort de voler les Rouages du Temps...') -- FUT_M19A0401_016 (FR)
        -- case 33: " [CS:N]Grovyle[CR], if I end up thinking\nyou're wrong for stealing the Time Gears..."
        -- case 34: " [CS:N]Grovyle[CR], if I decide that you're\nwrong for stealing the Time Gears..."
        UI:WaitShowDialogue('Je vais t\'arrêter, Massko !') -- FUT_M19A0401_017 (FR)
        -- case 36: " I'm going to stop you, [CS:N]Grovyle[CR]!"
        -- case 37: " I'm going to stop you, [CS:N]Grovyle[CR]!"
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Humph ! Fais comme tu veux. Mais garde ça en tête...') -- FUT_M19A0401_018 (FR)
        UI:WaitShowDialogue('Pour l\'instant, l\'essentiel est que nous rentrions tous sains et saufs dans votre monde.') -- FUT_M19A0401_019 (FR)
        UI:WaitShowDialogue('Alors, pour le moment... concentrez-vous sur votre retour.') -- FUT_M19A0401_020 (FR)
        UI:WaitShowDialogue('Allons-y.') -- FUT_M19A0401_021 (FR)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 276, 4, false, 2.0)
        GAME:WaitFrames(20)
        GROUND:MoveToPosition(CH('Teammate1'), 252, 60, false, 1.0)
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('PLAYER'), 300, 92, false, 1.0)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(............)') -- FUT_M19A0401_022 (FR)
        -- case 43: '(............)'
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        UI:WaitShowDialogue('(Je le sens...)') -- FUT_M19A0401_023 (FR)
        -- case 45: '(I feel it...)'
        UI:WaitShowDialogue('(Je sens quelque chose d\'étrange...)') -- FUT_M19A0401_024 (FR)
        -- case 47: '(I am sensing something strange...)'
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8962 (SE_NUM_EVENT_SIGN_HATENA_02)
        GROUND:CharSetEmote(CH('Teammate1'), 'question', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('Hm ? Qu\'y a-t-il, [hero] ?') -- FUT_M19A0401_025 (FR)
        -- case 49: " Hm?[K] What's up, [hero]?"
        -- case 50: " Hm?[K] What's the matter,\n[hero]?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(J\'en suis certain !)') -- FUT_M19A0401_026 (FR)
        -- case 52: '(I just know it!)'
        UI:WaitShowDialogue('(J\'ai déjà éprouvé quelque chose de semblable...)') -- FUT_M19A0401_027 (FR)
        -- case 54: "(I've felt something like this before...)"
        UI:WaitShowDialogue('(C\'était...)') -- FUT_M19A0401_028 (FR)
        -- case 56: '(It was...)'
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8978 (SE_NUM_EVENT_SIGN_NOTICE_05)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        -- PARTIEL : WaitSe [8978]
        -- bgm_PlayFadeIn [79, 0, 256] : BGM ISawSomethingAgain non mappé
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(Mais oui ! C\'était lorsque...)') -- FUT_M19A0401_029 (FR)
        -- case 58: "(That's it![K] It was when...)"
        UI:ResetSpeaker()
        GAME:FadeOut(false, 30)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m19a0401] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m19a0401
