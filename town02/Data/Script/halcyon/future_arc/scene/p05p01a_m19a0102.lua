--[[
    P05P01A_m19a0102.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P01A/m19a0102.ssb
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
require 'halcyon.future_arc.FutureScene'

local m19a0102 = {}

function m19a0102.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- PlanetsParalysis
        -- back_SetGround(P05P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(1)
        -- object 134 (p05p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p01a1', 9, 0, 3, Direction.Down, 1) -- objet 134, anim 9 (table REQUISE)
        -- SetOutputAttribute [8] : PARTIEL
        GAME:FadeIn(30)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7186') end) -- TODO SE 7186 (SE_NUM_EVENT_MAIN17_KESSYOU_L)
        -- object 134 (p05p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p01a1', 17, 0, 3, Direction.Down, 1) -- objet 134, anim 17 (table REQUISE)
        -- object 134 (p05p01a1) : contexte objet
        -- WaitAnimation sur objet p05p01a1 : PARTIEL
        -- object 134 (p05p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p01a1', 18, 0, 3, Direction.Down, 1) -- objet 134, anim 18 (table REQUISE)
        -- object 134 (p05p01a1) : contexte objet
        -- WaitAnimation sur objet p05p01a1 : PARTIEL
        -- object 134 (p05p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p01a1', 3, 0, 3, Direction.Down, 1) -- objet 134, anim 3 (table REQUISE)
        -- message_ImitationSound : PARTIEL
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Maître Necrozma.') -- FUT_M19A0102_001 (FR)
        UI:WaitShowDialogue('Tout est prêt pour capturer les traîtres.') -- FUT_M19A0102_002 (FR)
        UI:WaitShowDialogue('Le moment venu...') -- FUT_M19A0102_003 (FR)
        UI:WaitShowDialogue('Nous devrons peut-être solliciter votre aide, Maître Necrozma...') -- FUT_M19A0102_004 (FR)
        UI:ResetSpeaker()
        -- message_ImitationSound : PARTIEL
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('... À vos ordres.') -- FUT_M19A0102_005 (FR)
        UI:WaitShowDialogue('Avec votre permission, nous allons agir.') -- FUT_M19A0102_006 (FR)
        UI:ResetSpeaker()
        -- PARTIEL : se_FadeOut [7186, 60]
        -- object 134 (p05p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p01a1', 20, 0, 3, Direction.Down, 1) -- objet 134, anim 20 (table REQUISE)
        -- object 134 (p05p01a1) : contexte objet
        -- WaitAnimation sur objet p05p01a1 : PARTIEL
        -- object 134 (p05p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p01a1', 21, 0, 3, Direction.Down, 1) -- objet 134, anim 21 (table REQUISE)
        -- object 134 (p05p01a1) : contexte objet
        -- WaitAnimation sur objet p05p01a1 : PARTIEL
        -- PARTIEL : WaitSe [7186]
        SOUND:FadeOutBGM(180)
        GAME:WaitFrames(45)
        GAME:FadeOut(false, 60)
        GAME:WaitFrames(90)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m19a0102] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m19a0102
