--[[
    D21P41A_m18b1101.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D21P41A/m18b1101.ssb
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

local m18b1101 = {}

function m18b1101.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- PARTIEL : back_SetDungeonBanner [31, 0] (bannière)
        GAME:FadeIn(16)
        GAME:WaitFrames(60)
        GAME:FadeOut(false, 16)
        GAME:WaitFrames(15)
        SV.Scenario.Main = 19 -- flag_SetScenario(SCENARIO_MAIN, scenario=19, level=4)
        -- back_SetGround(D21P41A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GROUND:CharSetAnim(CH('Grovyle'), 'Float', false) -- param 29 = anim 20 (Float)
        -- SetOutputAttribute [2] : PARTIEL
        -- object 61 (d21p41a1) : contexte objet
        FutureScene.ObjectSetAnim('d21p41a1', 1, 0, 3, Direction.Down, 1) -- objet 61, anim 1 (table REQUISE)
        -- bgm_PlayFadeIn [112, 0, 256] : BGM StaticNoise non mappé
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), 296, 220, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), 272, 244, false, 3.0)
            end),
        })
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Hé ! Massko est là !') -- FUT_M18B1101_001 (FR)
        -- case 0: " Hey![K] There's [CS:N]Grovyle[CR]!"
        -- case 1: " Hey![K] There's [CS:N]Grovyle[CR]!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Urggh... Vous deux...') -- FUT_M18B1101_002 (FR)
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('M-Massko ! Ça va ?!') -- FUT_M18B1101_003 (FR)
        -- case 4: ' [CS:N]G-Grovyle[CR]! Are you all right?!'
        -- case 5: ' [CS:N]G-Grovyle[CR]! Are you all right?!'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 28*8, false, 2.0)
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 24*8, false, 2.0)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('R-restez en arrière !') -- FUT_M18B1101_004 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Hein ? P-pourquoi ?!') -- FUT_M18B1101_005 (FR)
        -- case 8: ' Huh?[K] Wh-why?!'
        -- case 9: ' What?[K] Wh-why?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Attention ! Un ennemi rôde tout près !') -- FUT_M18B1101_006 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO SE 8974 (SE_NUM_EVENT_MOTION_JUNP_01)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(12)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi ?! O-où ça ?') -- FUT_M18B1101_007 (FR)
        -- case 12: ' What?![K] Wh-where?'
        -- case 13: ' What?![K] Wh-where?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Il est juste... à côté de toi !') -- FUT_M18B1101_008 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('À côté de moi... ?') -- FUT_M18B1101_009 (FR)
        -- case 16: ' Next to me...?'
        -- case 17: ' Next to me...?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        GAME:WaitFrames(5)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpRight, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Ce ne serait pas...') -- FUT_M18B1101_010 (FR)
        UI:SetCenter(false)
        -- case 19: " It can't be this..."
        -- case 20: " It can't be this..."
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7426') end) -- TODO SE 7426 (None)
        -- object 64 (d21p41a2) : contexte objet
        FutureScene.ObjectSetAnim('d21p41a2', 18, 0, 3, Direction.Down, 1) -- objet 64, anim 18 (table REQUISE)
        -- object 64 (d21p41a2) : contexte objet
        -- WaitAnimation sur objet d21p41a2 : PARTIEL
        -- object 64 (d21p41a2) : contexte objet
        FutureScene.ObjectSetAnim('d21p41a2', 9, 0, 3, Direction.Down, 1) -- objet 64, anim 9 (table REQUISE)
        GAME:WaitFrames(15)
        -- PARTIEL : WaitSe [7426]
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end),
        })
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 2.5*8, CH('PLAYER').Position.Y + 0*8, false, 5.0)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('PLAYER'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 2.5*8, CH('PLAYER').Position.Y + 0*8, false, 5.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Teammate1'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 2.5*8, CH('Teammate1').Position.Y + 0*8, false, 5.0)
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Shouting')
        UI:WaitShowDialogue('Waaah !') -- FUT_M18B1101_011 (FR)
        -- case 22: ' Waaah!'
        -- case 23: ' Waaah!'
        -- SetAnimation 2 (spécial : boucle anim courante)
        -- SetAnimation 2 (spécial : boucle anim courante)
        UI:ResetSpeaker()
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- PlanetsParalysis
UI:SetSpeaker(CH('Spiritomb'))
        UI:WaitShowDialogue('HÉ-hé... HÉ-hé...') -- FUT_M18B1101_012 (FR)
        UI:WaitShowDialogue('Tous ceux qui PÉNÈTRENT sur cette terre...') -- FUT_M18B1101_013 (FR)
        UI:WaitShowDialogue('Nul ne sera PARDONNÉ ! Nul !') -- FUT_M18B1101_014 (FR)
        UI:WaitShowDialogue('Et surtout pas... TOI !') -- FUT_M18B1101_015 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Qui est là ? Qui êtes-vous ?!') -- FUT_M18B1101_016 (FR)
        -- case 29: ' Who is that?![K] Who are you?!'
        -- case 30: ' Who is that?![K] Who are you?!'
        UI:ResetSpeaker()
UI:SetSpeaker(CH('Spiritomb'))
        UI:WaitShowDialogue('Tu OSES nous le demander ?') -- FUT_M18B1101_017 (FR)
        UI:WaitShowDialogue('Notre nom est... SPIRITOMB.') -- FUT_M18B1101_018 (FR)
        UI:WaitShowDialogue('Nous sommes la manifestation d\'une FUSION d\'esprits...') -- FUT_M18B1101_019 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7427') end) -- TODO SE 7427 (None)
        -- object 64 (d21p41a2) : contexte objet
        pcall(function() GROUND:Hide(CH('Teammate1').EntName) end)
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(1)
        GROUND:CharSetAnim(CH('Spiritomb'), 'Wake', false) -- param 23 = anim 14 (Wake)
        pcall(function() GROUND:CharWaitAnim(CH('Spiritomb')) end)
        -- PARTIEL : WaitSe [7427]
        UI:SetSpeaker(CH('Spiritomb'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Cent HUIT esprits !') -- FUT_M18B1101_020 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Attention, vous deux ![br]Ce Pokémon est puissant !') -- FUT_M18B1101_021 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Spiritomb'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('HÉ-hé... HÉ-hé... PRÉPARE-TOI à subir ton châtiment !') -- FUT_M18B1101_022 (FR)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(30)
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 5143 (SE_NUM_EVENT_EFF_FLASH_HEAVY)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        GAME:WaitFrames(10)
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 5143 (SE_NUM_EVENT_EFF_FLASH_HEAVY)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        -- PARTIEL : WaitSe [5143]
        -- CallCommon(BOSS_WIPE_FUNC) : helper à implémenter
        -- main_EnterDungeon(31) : entrée donjon (mapping id REQUIS)
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m18b1101] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m18b1101
