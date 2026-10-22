--[[
    D22P11A_m19a0501.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D22P11A/m19a0501.ssb
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

local m19a0501 = {}

function m19a0501.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- Transition neutralisée : FutureArc possède le routage. Source : GAME:EnterGroundMap('s04p01a', 'Main_Entrance_Marker') -- transition S04P01A
        GAME:FadeIn(0)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Argh... Cette tentative a échoué.') -- FUT_M19A0501_001 (FR)
        -- case 1: ' Ugh...[K] We blew that attempt.'
        -- case 2: " Ugh...[K] That wasn't good."
        -- message_KeyWait (le dialogue bloque déjà)
        GAME:FadeOut(false, 60)
        UI:ResetSpeaker()
        -- CallCommon(FADE_OUT_ALL_AFTER) : helper à implémenter
        -- back_SetGround(D22P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- NON CONVERTI : supervision_LoadStation [50, 0]
        -- NON CONVERTI : supervision_Station [2]
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        -- bgm_PlayFadeIn [43, 0, 256] : BGM DuskForest non mappé
        GAME:WaitFrames(30)
        -- NON CONVERTI : WaitLockLives [5, 0]
        -- NON CONVERTI : Unlock [5]
        GAME:WaitFrames(15)
        -- NON CONVERTI : Unlock [7]
        GAME:WaitFrames(15)
        -- NON CONVERTI : Unlock [9]
        -- NON CONVERTI : Lock [3]
        GAME:WaitFrames(15)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
            end),
        })
        GAME:WaitFrames(15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Argh... Cette traversée est vraiment difficile...') -- FUT_M19A0501_002 (FR)
        -- case 4: ' Urk... This is pretty tough\ngoing...'
        -- case 5: " Urk... This isn't easy at all..."
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
            end),
        })
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Nous devons nous frayer un chemin.') -- FUT_M19A0501_003 (FR)
        UI:WaitShowDialogue('Ces Ténéfix nous rattraperont si nous ne nous dépêchons pas.') -- FUT_M19A0501_004 (FR)
        UI:WaitShowDialogue('On partira dès que tu seras prêt.') -- FUT_M19A0501_005 (FR)
        UI:ResetSpeaker()
        GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) -- param 4 = anim 7 (Idle)
        -- End : fin de scène
        -- NON CONVERTI : SetPositionInitial []
        -- NON CONVERTI : Lock [5]
        CH('Grovyle').Direction = Direction.Right
        GROUND:CharSetAnim(CH('Grovyle'), 'Laying', true) -- param 76 = anim 27 (Laying)
        -- CallCommon(WAKEUP_FUNC) : helper à implémenter
        -- CallCommon(LOOK_AROUND_DOWN_FUNC) : helper à implémenter
        -- NON CONVERTI : Lock [6]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : SetPositionInitial []
        -- NON CONVERTI : Lock [7]
        CH('Grovyle').Direction = Direction.Left
        GROUND:CharSetAnim(CH('Grovyle'), 'Laying', true) -- param 76 = anim 27 (Laying)
        -- CallCommon(WAKEUP_FUNC) : helper à implémenter
        -- CallCommon(LOOK_AROUND_FUNC) : helper à implémenter
        -- NON CONVERTI : Unlock [3]
        -- NON CONVERTI : Lock [8]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- NON CONVERTI : SetPositionInitial []
        -- NON CONVERTI : Lock [9]
        GROUND:CharSetAnim(CH('Grovyle'), 'Float', false) -- param 29 = anim 20 (Float)
        GAME:WaitFrames(30)
        -- SetAnimation 31 : NON CONVERTI (param absent de la table officielle)
        pcall(function() GROUND:CharWaitAnim(CH('Grovyle')) end)
        -- SetAnimation 2 (spécial : boucle anim courante)
        GAME:WaitFrames(15)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.UpLeft, 15)
        -- CallCommon(LOOK_AROUND_FUNC) : helper à implémenter
        -- NON CONVERTI : Lock [10]
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m19a0501] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m19a0501
