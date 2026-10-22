--[[
    D55P21A_enter07.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P21A/enter07.ssb
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

local enter07 = {}

function enter07.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- SetAnimation 2 (spécial : boucle anim courante)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_16130') end) -- TODO SE 16130 (None)
        -- flag_CalcBit(SCENARIO_MAIN_BIT_FLAG, 7, 1) : opérations bit (adaptation)
        -- HANYOU_SAVE_FUNC : point de sauvegarde obligatoire (à brancher)
        -- JumpCommon(END_TALK) : helper à implémenter (comme CallCommon)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[enter07] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return enter07
