--[[
    D21P41A_m18b0902.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D21P41A/m18b0902.ssb
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

local m18b0902 = {}

function m18b0902.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

UI:SetSpeaker(CH('Grovyle'))
        UI:WaitShowDialogue('Je suis déjà descendu très loin. Le bout n\'est plus très loin.') -- FUT_M18B0902_001 (FR)
        UI:ResetSpeaker()
        -- back_SetGround(D21P41A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('Grovyle'), 288, 236, false, 2.0)
        GAME:WaitFrames(15)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Si je passe par ici...') -- FUT_M18B0902_002 (FR)
        UI:WaitShowDialogue('Je devrais alors atteindre la forêt.') -- FUT_M18B0902_003 (FR)
        UI:WaitShowDialogue('Les Ténéfix arrivent.[br]Pas une seconde à perdre.') -- FUT_M18B0902_004 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Cela me fait penser... Je me demande comment vont ces deux-là.') -- FUT_M18B0902_005 (FR)
        UI:WaitShowDialogue('Ont-ils semé les Ténéfix ?') -- FUT_M18B0902_006 (FR)
        UI:ResetSpeaker()
        -- ExecuteCommon(HEAD_SHAKE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue('Oh, oublions ça. Ce n\'est pas le moment !') -- FUT_M18B0902_007 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Je dois donner la priorité à ma mission, quoi qu\'il arrive !') -- FUT_M18B0902_008 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('J\'ai juré de l\'accomplir, même si cela exige des sacrifices !') -- FUT_M18B0902_009 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Il est temps d\'y aller.') -- FUT_M18B0902_010 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 324, 236, false, 2.0)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('Toi, là ! ARRÊTE !') -- FUT_M18B0902_011 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hmm?') -- FUT_M18B0902_012 (FR)
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_DOWN_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue('Qui est là ?') -- FUT_M18B0902_013 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- message_KeyWait (le dialogue bloque déjà)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- PlanetsParalysis
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('Tu AS ENVAHI ce lieu sans prévenir !') -- FUT_M18B0902_014 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Puis tu as TROUBLÉ notre sommeil !') -- FUT_M18B0902_015 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Et tu tentes de partir sans même T\'EXCUSER ?') -- FUT_M18B0902_016 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Qui est là ? Qui êtes-vous ?!') -- FUT_M18B0902_017 (FR)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('Tu OSES provoquer notre colère !') -- FUT_M18B0902_018 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Tu vas PAYER pour ces affronts !') -- FUT_M18B0902_019 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Où êtes-vous ? Cessez de vous cacher et montrez-vous !') -- FUT_M18B0902_020 (FR)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('Tu nous ACCUSES de nous cacher ?') -- FUT_M18B0902_021 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Nous ne nous cachons PAS.') -- FUT_M18B0902_022 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Nous sommes... Nous sommes ICI !') -- FUT_M18B0902_023 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6925') end) -- TODO SE 6925 (None)
        GAME:FadeOut(false, 15)
        -- PARTIEL : WaitSe [6925]
        UI:SetCenter(true)
        UI:WaitShowDialogue('Nous sommes SPIRITOMB !') -- FUT_M18B0902_024 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Spiritomb'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Aucune PITIÉ pour ceux qui nous offensent !') -- FUT_M18B0902_025 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7425') end) -- TODO SE 7425 (None)
        SOUND:FadeOutBGM(160)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Gaaaah !') -- FUT_M18B0902_026 (FR)
        GAME:WaitFrames(15)
        GAME:FadeOut(false, 90)
        UI:ResetSpeaker()
        -- CallCommon(FADE_OUT_ALL_AFTER) : helper à implémenter
        -- WaitBgm : PARTIEL
        -- main_EnterDungeon(30) : entrée donjon (mapping id REQUIS)
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m18b0902] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m18b0902
