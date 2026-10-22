--[[
    D22P11A_m19a0403.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D22P11A/m19a0403.ssb
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

local m19a0403 = {}

function m19a0403.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- bgm_PlayFadeIn [79, 0, 256] : BGM ISawSomethingAgain non mappé
        -- back_SetGround(D22P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(Je le savais ! Cette sensation ressemble à celle que j\'avais éprouvée alors...)') -- FUT_M19A0403_001 (FR)
        -- case 0: '(I thought so![K] This is similar to the\nsensation I had back then...)'
        UI:ResetSpeaker()
UI:SetSpeaker(CH('Grovyle'))
        UI:WaitShowDialogue('Hé ! Qu\'est-ce que tu fais ?') -- FUT_M19A0403_002 (FR)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8978 (SE_NUM_EVENT_SIGN_NOTICE_05)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
            end),
        })
        GAME:WaitFrames(15)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Vite !') -- FUT_M19A0403_003 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Dépêche-toi, [hero].') -- FUT_M19A0403_004 (FR)
        -- case 4: " Let's hurry, [hero]."
        -- case 5: ' We have to hurry, [hero].'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Teammate1'), 276, 4, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 276, 4, false, 2.0)
        GAME:WaitFrames(90)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 180, 236, false, 2.0)
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hi-hi-hi !') -- FUT_M19A0403_005 (FR)
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 1.5*8, CH('Sableye_1').Position.Y + 64*8, false, 3.0)
        GROUND:MoveToPosition(CH('Sableye_1'), 276, 4, false, 2.398)
        GAME:WaitFrames(20)
        -- main_EnterDungeon(32) : entrée donjon (mapping id REQUIS)
        -- NON CONVERTI : message_Menu [54]
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m19a0403] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m19a0403
