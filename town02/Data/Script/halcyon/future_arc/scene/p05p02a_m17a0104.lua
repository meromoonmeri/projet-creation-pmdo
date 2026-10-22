--[[
    P05P02A_m17a0104.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P02A/m17a0104.ssb
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

local m17a0104 = {}

function m17a0104.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Hé, [hero]...') -- FUT_M17A0104_001 (FR)
        -- case 0: ' Hey...[K][hero]...'
        -- case 1: ' Hey...[K][hero]...'
        UI:WaitShowDialogue('Réveille-toi, [hero] !') -- FUT_M17A0104_002 (FR)
        -- case 3: ' Wake up, [hero]!'
        -- case 4: ' Wake up, [hero]!'
        UI:ResetSpeaker()
        -- back_SetGround(P05P02A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GROUND:CharSetAnim(CH('PLAYER'), 'Laying', true) -- param 76 = anim 27 (Laying)
        GAME:FadeIn(60)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        GAME:WaitFrames(30)
        GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + -1*8, false, 2.0)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('(Argh...)') -- FUT_M17A0104_003 (FR)
        -- case 6: '(Ugh...)'
        UI:ResetSpeaker()
        GROUND:CharSetAnim(CH('PLAYER'), 'Wake', false) -- param 63 = anim 14 (Wake)
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8978 (SE_NUM_EVENT_SIGN_NOTICE_05)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        -- ExecuteCommon(HEAD_SHAKE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(Où suis-je... ?)') -- FUT_M17A0104_004 (FR)
        -- case 8: '(Wh-where...?)'
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Enfin ! Tu as repris connaissance !') -- FUT_M17A0104_005 (FR)
        -- case 10: " You're awake!"
        -- case 11: " You're awake!"
        UI:ResetSpeaker()
        GROUND:CharSetAnim(CH('Teammate1'), 'Walk', true) -- param 5 = anim 0 (Walk)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -16*8, false, 2.0)
        GAME:WaitFrames(5)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- SetAnimation 2 (spécial : boucle anim courante)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Cet endroit... Je crois que c\'est une prison.') -- FUT_M17A0104_006 (FR)
        -- case 13: " This place... I think it's a jail."
        -- case 14: " This place... I think it's a jail."
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(U-une prison ?!)') -- FUT_M17A0104_007 (FR)
        -- case 16: '(J-jail?!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Je n\'ai repris connaissance qu\'il y a un instant, alors je ne sais pas vraiment ce qui se passe.') -- FUT_M17A0104_008 (FR)
        -- case 18: " I just woke up a while ago, so\nI'm not sure what's going on."
        -- case 19: " I just woke up a while ago, so\nI'm not sure what's going on."
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('J\'ai essayé d\'ouvrir les portes, mais elles sont verrouillées.') -- FUT_M17A0104_009 (FR)
        -- case 21: " I tried opening the doors, but\nthey're locked."
        -- case 22: " I tried the doors, but they're\nlocked."
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Aucune autre issue en vue.') -- FUT_M17A0104_010 (FR)
        -- case 24: " There doesn't seem to be any\nother way out."
        -- case 25: ' There seems to be no other\nway out.'
        UI:WaitShowDialogue('On dirait qu\'on nous a enfermés... Argh...') -- FUT_M17A0104_011 (FR)
        -- case 27: " I think that we've been locked\nup...[K] Ugh..."
        -- case 28: " I think that we've been locked\nup...[K] Ugh..."
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
        GAME:WaitFrames(30)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(Qu\'est-ce qui se passe ?)') -- FUT_M17A0104_012 (FR)
        -- case 30: "(Wh-what's going on?)"
        UI:WaitShowDialogue('(On est enfermés ?)') -- FUT_M17A0104_013 (FR)
        -- case 32: "(We're locked up?)"
        UI:WaitShowDialogue('(Je ne sais pas non plus ce qui se passe, mais je peux regarder autour de moi...)') -- FUT_M17A0104_014 (FR)
        -- case 34: "(I don't know what's going on either, but I may\nas well investigate...)"
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m17a0104] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m17a0104
