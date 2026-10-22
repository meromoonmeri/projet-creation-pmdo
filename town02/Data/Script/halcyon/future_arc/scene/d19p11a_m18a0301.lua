--[[
    D19P11A_m18a0301.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D19P11A/m18a0301.ssb
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

local m18a0301 = {}

function m18a0301.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- Transition neutralisée : FutureArc possède le routage. Source : GAME:EnterGroundMap('s04p01a', 'Main_Entrance_Marker') -- transition S04P01A
        GAME:FadeIn(0)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Aïe... Nous n\'avons pas réussi à passer...') -- FUT_M18A0301_001 (FR)
        -- case 0: " Ugh...[K] We couldn't get\nthrough..."
        -- case 1: " Ouch...[K] We couldn't break\nthrough..."
        -- message_KeyWait (le dialogue bloque déjà)
        GAME:FadeOut(false, 60)
        UI:ResetSpeaker()
        -- CallCommon(FADE_OUT_ALL_AFTER) : helper à implémenter
        -- back_SetGround(D19P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        -- bgm_PlayFadeIn [40, 0, 256] : BGM DarkHill non mappé
        GAME:WaitFrames(30)
        -- NON CONVERTI : WaitLockLives [5, 0]
        -- NON CONVERTI : Unlock [5]
        GAME:WaitFrames(15)
        -- NON CONVERTI : Unlock [7]
        -- NON CONVERTI : Lock [3]
        GAME:WaitFrames(15)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
            end),
        })
        GAME:WaitFrames(15)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Hmmm... Nous avons peut-être manqué de prudence.') -- FUT_M18A0301_002 (FR)
        -- case 3: ' Hmmm... We got a little too\ncareless, maybe.'
        -- case 4: ' Hmmm... I think we got a little\ntoo careless.'
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ils nous ont presque rattrapés... Dépêchons-nous !') -- FUT_M18A0301_003 (FR)
        -- case 6: ' We have to hurry and go.'
        -- case 7: ' We need to get away\nfrom them.'
        UI:WaitShowDialogue('On y va quand tu seras prêt.') -- FUT_M18A0301_004 (FR)
        -- case 9: " We'll go when you're ready."
        -- case 10: " Let's go when you're ready."
        UI:ResetSpeaker()
        -- End : fin de scène
        -- NON CONVERTI : Lock [5]
        CH('Teammate1').Direction = Direction.Right
        GROUND:CharSetAnim(CH('Teammate1'), 'Laying', true) -- param 76 = anim 27 (Laying)
        -- CallCommon(WAKEUP_FUNC) : helper à implémenter
        -- CallCommon(LOOK_AROUND_DOWN_FUNC) : helper à implémenter
        -- NON CONVERTI : Lock [6]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : Lock [7]
        CH('Teammate1').Direction = Direction.Left
        GROUND:CharSetAnim(CH('Teammate1'), 'Laying', true) -- param 76 = anim 27 (Laying)
        -- CallCommon(WAKEUP_FUNC) : helper à implémenter
        -- CallCommon(LOOK_AROUND_FUNC) : helper à implémenter
        -- NON CONVERTI : Unlock [3]
        -- NON CONVERTI : Lock [8]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m18a0301] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m18a0301
