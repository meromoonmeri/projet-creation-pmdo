--[[
    P08P01A_enter00.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/enter00.ssb
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

local enter00 = {}

function enter00.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- SwitchSector : sélection du point d'entrée (structurel)
        -- Case (structurel)
        GAME:FadeOut(false, 0)
        -- back_SetGround(P08P01A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- SwitchSector : sélection du point d'entrée (structurel)
        -- Case (structurel)
        -- Switch (structurel)
        -- Jump (structurel)
        -- debug_Print (ignoré)
        -- JumpCommon(COMMON_ENTER) : helper à implémenter (comme CallCommon)
        -- End : fin de scène
        -- NON CONVERTI : SetAnimation (acteur None)
        GAME:WaitFrames(1) -- attente de fondu d'écran
        GAME:WaitFrames(1) -- attente de fondu d'écran
        -- End : fin de scène
        -- NON CONVERTI : SetAnimation (acteur None)
        GAME:WaitFrames(1) -- attente de fondu d'écran
        GAME:WaitFrames(1) -- attente de fondu d'écran
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[enter00] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return enter00
