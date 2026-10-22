--[[
    D20P11A_m18b0701.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D20P11A/m18b0701.ssb
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

local m18b0701 = {}

function m18b0701.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- Transition neutralisée : FutureArc possède le routage. Source : GAME:EnterGroundMap('s04p01a', 'Main_Entrance_Marker') -- transition S04P01A
        GAME:FadeIn(0)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Argh... Nous avons échoué...') -- FUT_M18B0701_001 (FR)
        -- case 0: ' Ugh...[K] We blew it...'
        -- case 1: ' Ugh...[K] We failed...'
        -- message_KeyWait (le dialogue bloque déjà)
        GAME:FadeOut(false, 60)
        UI:ResetSpeaker()
        -- CallCommon(FADE_OUT_ALL_AFTER) : helper à implémenter
        -- back_SetGround(D20P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        -- bgm_PlayFadeIn [41, 0, 256] : BGM SealedRuin non mappé
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
        UI:WaitShowDialogue('Argh... C\'est difficile, mais...') -- FUT_M18B0701_002 (FR)
        -- case 3: " Ugh... It's tough going, but..."
        -- case 4: " Ugh... It's not easy, but..."
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Mais pas question d\'abandonner ![br]Continuons, [hero] !') -- FUT_M18B0701_003 (FR)
        -- case 6: " But there's no giving up![K]\nLet's keep at it, [hero]!"
        -- case 7: " But we can't give up![K] Let's keep\nat it, [hero]!"
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
    PrintInfo('[m18b0701] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m18b0701
