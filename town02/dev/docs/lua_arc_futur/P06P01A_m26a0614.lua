--[[
    P06P01A_m26a0614.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P06P01A/m26a0614.ssb
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

local m26a0614 = {}

function m26a0614.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('Memories Returned.ogg', true) end) -- MemoriesReturned
        -- PARTIEL : back2_SetMode [4]
        -- back2_SetGround(S04P01A) : couche décor (overlay scène, adaptation)
        -- back_SetGround(P06P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        GAME:WaitFrames(1)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- screen_FlushOut [1, 0, 8, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        -- screen2_FadeIn [0, 30] : couche décor (overlay scène, adaptation)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' [hero], thanks.') -- FUT_M26A0614_001 (FR optionnel)
        -- case 0: ' [hero], thanks.'
        -- case 1: ' [hero], thank you.'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' You were worried about me for\nbeing so down.') -- FUT_M26A0614_002 (FR optionnel)
        -- case 3: ' You were worried about me for\nbeing so down.'
        -- case 4: ' You tried to pick me up because\nI was feeling down.'
        UI:ResetSpeaker()
        -- screen2_FadeOut [0, 30] : couche décor (overlay scène, adaptation)
        GAME:FadeOut(true, 30)
        -- screen_FlushIn [1, 0, 1, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m26a0614] scène interrompue : '..tostring(err)) end
end

return m26a0614
