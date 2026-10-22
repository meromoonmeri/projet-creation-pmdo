--[[
    P07P01A_m26a06e6.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P07P01A/m26a06e6.ssb
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

local m26a06e6 = {}

function m26a06e6.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('Memories Returned.ogg', true) end) -- MemoriesReturned
        -- PARTIEL : back2_SetMode [4]
        -- back2_SetGround(V09P04A) : couche décor (overlay scène, adaptation)
        -- back_SetGround(P07P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        GAME:WaitFrames(1)
        -- camera2_SetPositionMark [0, 2, 21, 21] : PARTIEL
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- performer 0
        GROUND:TeleportTo(CH('PLAYER'), 180, 380)
        pcall(function() GROUND:RemoveCharacter(CH('Grovyle')) end)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:TeleportTo(CH('PLAYER'), 208, 396)
                CH('PLAYER').Direction = Direction.Left
            end,
            function()
                CH('Teammate1').Direction = Direction.Right
                GROUND:TeleportTo(CH('Teammate1'), 120, 396)
                GROUND:TeleportTo(CH('Teammate1'), CH('Teammate1').Position.X + 28*8, CH('Teammate1').Position.Y + 0*8)
            end,
        })
        -- screen_FlushOut [1, 0, 8, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        -- screen2_FadeIn [0, 30] : couche décor (overlay scène, adaptation)
        GAME:FadeIn(30)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 0.7969*8, CH('PLAYER').Position.Y + 24*8, false, 1.594)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' [hero].') -- FUT_M26A06E6_001 (FR optionnel)
        -- case 0: ' [hero].'
        -- case 1: ' [hero].'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' We have to...\n We have to\nget back!') -- FUT_M26A06E6_002 (FR optionnel)
        -- case 3: ' We have to...[K] We have to\nget back!'
        -- case 4: ' We have to...[K] We have to\nget back!'
        UI:WaitShowDialogue(' Back to our own world!') -- FUT_M26A06E6_003 (FR optionnel)
        -- case 6: ' Back to our own world!'
        -- case 7: ' Back to our own world!'
        UI:ResetSpeaker()
        -- screen2_WhiteOut [0, 30] : couche décor (overlay scène, adaptation)
        GAME:FadeOut(true, 30)
        -- screen_FlushIn [1, 0, 1, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m26a06e6] scène interrompue : '..tostring(err)) end
end

return m26a06e6
