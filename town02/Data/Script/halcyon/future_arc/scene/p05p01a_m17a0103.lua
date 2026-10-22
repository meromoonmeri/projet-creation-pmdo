--[[
    P05P01A_m17a0103.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P01A/m17a0103.ssb
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

local m17a0103 = {}

function m17a0103.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- back_SetGround(P05P01A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(1)
        -- object 134 (p05p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p01a1', 9, 0, 3, Direction.Down, 1) -- objet 134, anim 9 (table REQUISE)
        -- SetOutputAttribute [8] : PARTIEL
        GAME:FadeIn(30)
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Je suis désolé de vous avoir fait attendre, Maître Necrozma...') -- FUT_M17A0103_001 (FR)
        UI:WaitShowDialogue('Malgré des difficultés plus grandes que prévu...') -- FUT_M17A0103_002 (FR)
        UI:WaitShowDialogue('J\'ai finalement réussi... à les capturer, oui.') -- FUT_M17A0103_003 (FR)
        UI:ResetSpeaker()
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
        UI:WaitShowDialogue('... Je comprends parfaitement ce qu\'il faut faire.') -- FUT_M17A0103_004 (FR)
        UI:WaitShowDialogue('Ceux qui cherchent à modifier le cours de l\'histoire... doivent être effacés de l\'histoire.') -- FUT_M17A0103_005 (FR)
        UI:WaitShowDialogue('Je vais procéder à leur élimination sur-le-champ.') -- FUT_M17A0103_006 (FR)
        UI:ResetSpeaker()
        -- message_ImitationSound : PARTIEL
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('... J\'ai compris. À vos ordres.') -- FUT_M17A0103_007 (FR)
        UI:WaitShowDialogue('Je prends congé.') -- FUT_M17A0103_008 (FR)
        UI:ResetSpeaker()
        -- PARTIEL : se_FadeOut [7186, 120]
        -- object 134 (p05p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p01a1', 20, 0, 3, Direction.Down, 1) -- objet 134, anim 20 (table REQUISE)
        -- object 134 (p05p01a1) : contexte objet
        -- WaitAnimation sur objet p05p01a1 : PARTIEL
        -- object 134 (p05p01a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p01a1', 21, 0, 3, Direction.Down, 1) -- objet 134, anim 21 (table REQUISE)
        -- object 134 (p05p01a1) : contexte objet
        -- WaitAnimation sur objet p05p01a1 : PARTIEL
        -- PARTIEL : WaitSe [7186]
        GAME:WaitFrames(45)
        GAME:FadeOut(false, 90)
        GAME:WaitFrames(120)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m17a0103] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m17a0103
