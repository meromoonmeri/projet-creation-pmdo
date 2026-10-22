--[[
    D55P11A_enter05.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P11A/enter05.ssb
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

local enter05 = {}

function enter05.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' It\'s a promise, Sentret.') -- FUT_ENTER05_001 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Well, if we run into Team AWD,\nwe\'ll make sure to give them what for!') -- FUT_ENTER05_002 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('TearyEyed')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Th-thank you very much!') -- FUT_ENTER05_003 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- JumpCommon(END_TALK) : helper à implémenter (comme CallCommon)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[enter05] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return enter05
