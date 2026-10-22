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
        local obj_134 = OBJ('p05p01a1') -- objet 134
        GROUND:ObjectSetAnim(obj_134, 9, 0, 3, Direction.Down, 1) -- anim 9 (table REQUISE)
        -- SetOutputAttribute [8] : PARTIEL
        GAME:FadeIn(30)
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' I am sorry to have kept you\nwaiting, Master Necrozma...') -- FUT_M17A0103_001 (FR optionnel)
        UI:WaitShowDialogue(' While I encountered more\ndifficulty than anticipated...') -- FUT_M17A0103_002 (FR optionnel)
        UI:WaitShowDialogue(' I finally succeeded...\n In the\ncapture, yes.') -- FUT_M17A0103_003 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7186') end) -- TODO table SE id 7186
        -- object 134 (p05p01a1) : contexte objet
        local obj_134 = OBJ('p05p01a1') -- objet 134
        GROUND:ObjectSetAnim(obj_134, 17, 0, 3, Direction.Down, 1) -- anim 17 (table REQUISE)
        -- object 134 (p05p01a1) : contexte objet
        -- WaitAnimation sur objet p05p01a1 : PARTIEL
        -- object 134 (p05p01a1) : contexte objet
        local obj_134 = OBJ('p05p01a1') -- objet 134
        GROUND:ObjectSetAnim(obj_134, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        -- object 134 (p05p01a1) : contexte objet
        -- WaitAnimation sur objet p05p01a1 : PARTIEL
        -- object 134 (p05p01a1) : contexte objet
        local obj_134 = OBJ('p05p01a1') -- objet 134
        GROUND:ObjectSetAnim(obj_134, 3, 0, 3, Direction.Down, 1) -- anim 3 (table REQUISE)
        -- message_ImitationSound : PARTIEL
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...\nI fully understand what must\nbe done.') -- FUT_M17A0103_004 (FR optionnel)
        UI:WaitShowDialogue(' Those who seek to alter the\ncourse of history...\nmust be removed from\nhistory.') -- FUT_M17A0103_005 (FR optionnel)
        UI:WaitShowDialogue(' I will see to the elimination\nimmediately.') -- FUT_M17A0103_006 (FR optionnel)
        UI:ResetSpeaker()
        -- message_ImitationSound : PARTIEL
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...I understand.\n As you wish.') -- FUT_M17A0103_007 (FR optionnel)
        UI:WaitShowDialogue(' I take my leave.') -- FUT_M17A0103_008 (FR optionnel)
        UI:ResetSpeaker()
        -- PARTIEL : se_FadeOut [7186, 120]
        -- object 134 (p05p01a1) : contexte objet
        local obj_134 = OBJ('p05p01a1') -- objet 134
        GROUND:ObjectSetAnim(obj_134, 20, 0, 3, Direction.Down, 1) -- anim 20 (table REQUISE)
        -- object 134 (p05p01a1) : contexte objet
        -- WaitAnimation sur objet p05p01a1 : PARTIEL
        -- object 134 (p05p01a1) : contexte objet
        local obj_134 = OBJ('p05p01a1') -- objet 134
        GROUND:ObjectSetAnim(obj_134, 21, 0, 3, Direction.Down, 1) -- anim 21 (table REQUISE)
        -- object 134 (p05p01a1) : contexte objet
        -- WaitAnimation sur objet p05p01a1 : PARTIEL
        -- PARTIEL : WaitSe [7186]
        GAME:WaitFrames(45)
        GAME:FadeOut(false, 90)
        GAME:WaitFrames(120)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0103] scène interrompue : '..tostring(err)) end
end

return m17a0103
