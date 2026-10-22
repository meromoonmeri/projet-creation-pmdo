--[[
    D55P21A_enter00.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P21A/enter00.ssb
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

        -- debug_Print (ignoré)
        -- SwitchSector : sélection du point d'entrée (structurel)
        -- Case (structurel)
        GAME:FadeOut(false, 0)
        -- debug_Print (ignoré)
        -- back_SetGround(D55P21A) : ground courant déjà posé
        -- debug_Print (ignoré)
        -- supervision_tationCommon layer [0] (structurel)
        -- Switch (structurel)
        -- Case (structurel)
        -- Jump (structurel)
        -- SwitchSector : sélection du point d'entrée (structurel)
        -- Case (structurel)
        -- debug_Print (ignoré)
        -- debug_Print (ignoré)
        -- NON CONVERTI : BranchBit [17, 7, 46]
        -- Jump (structurel)
        -- debug_Print (ignoré)
        -- flag_CalcBit(SCENARIO_MAIN_BIT_FLAG, 7, 0) : opérations bit (adaptation)
        -- supervision_tationCommon layer [62] (structurel)
        -- Jump (structurel)
        -- debug_Print (ignoré)
        -- supervision_tationCommon layer [61] (structurel)
        -- Jump (structurel)
        -- debug_Print (ignoré)
        -- bgm_PlayFadeIn [139, 0, 256] : BGM BoulderQuarry non mappé
        -- debug_Print (ignoré)
        -- debug_Print (ignoré)
        -- JumpCommon(COMMON_ENTER) : helper à implémenter (comme CallCommon)
        -- End : fin de scène
        -- NON CONVERTI : SetAnimation (acteur None)
        GAME:WaitFrames(1) -- attente de fondu d'écran
        GAME:WaitFrames(1) -- attente de fondu d'écran
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[enter00] scène interrompue : '..tostring(err)) end
end

return enter00
