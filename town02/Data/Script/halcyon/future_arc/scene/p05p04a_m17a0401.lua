--[[
    P05P04A_m17a0401.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P04A/m17a0401.ssb
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

local m17a0401 = {}

function m17a0401.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7193') end) -- TODO SE 7193 (SE_NUM_EVENT_MAIN17_ASHIOTO)
        GAME:WaitFrames(90)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Allez ! Par ici ! Continuons à courir jusqu\'à la sortie !') -- FUT_M17A0401_001 (FR)
        UI:ResetSpeaker()
        GAME:WaitFrames(90)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Allez ! Plus vite ! Accélère !') -- FUT_M17A0401_002 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Shouting')
        UI:WaitShowDialogue('Je vais aussi vite que possible !') -- FUT_M17A0401_003 (FR)
        -- case 2: ' This is the fastest I can go!'
        -- case 3: ' This is the fastest I can go!'
        UI:WaitShowDialogue('Arrête de me commander !') -- FUT_M17A0401_004 (FR)
        -- case 5: ' Quit ordering me around!'
        -- case 6: ' Quit ordering me around!'
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Dis, Massko... !') -- FUT_M17A0401_005 (FR)
        -- case 8: ' Anyway, [CS:N]Grovyle[CR]...!'
        -- case 9: ' Anyway, [CS:N]Grovyle[CR]...!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Quoi ?') -- FUT_M17A0401_006 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('C\'est... l\'avenir ?') -- FUT_M17A0401_007 (FR)
        -- case 12: ' Is this...[K]the future?'
        -- case 13: ' Is this...[K]the future?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Exact. Tu comprends vite.') -- FUT_M17A0401_008 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('Argh ! C\'est donc bien ça...') -- FUT_M17A0401_009 (FR)
        -- case 16: ' Urk! So it is, after all...'
        -- case 17: ' Urk! So it is, after all...'
        UI:WaitShowDialogue('Est-ce qu\'on pourra rentrer dans notre monde ?') -- FUT_M17A0401_010 (FR)
        -- case 19: ' Are we...[K] Are we going to be\nable to get back to our world?'
        -- case 20: ' Are we...[K] Are we going to be\nable to get back to our world?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Qui sait ? Pour l\'instant, nous devons nous échapper.') -- FUT_M17A0401_011 (FR)
        UI:WaitShowDialogue('Si nous nous faisons prendre, rentrer chez toi sera le cadet de tes soucis. Cours plus vite !') -- FUT_M17A0401_012 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Je n\'en peux plus...[br]Huff-huff...') -- FUT_M17A0401_013 (FR)
        -- case 24: " I can't![K] I'm exhausted...[K]\nHuff-huff..."
        -- case 25: " I can't![K] I'm exhausted...[K]\nHuff-huff..."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('On y est presque ![br]Regarde ! La sortie est juste là !') -- FUT_M17A0401_014 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Huff-huff... Huff-huff...') -- FUT_M17A0401_015 (FR)
        -- case 28: ' Huff-huff...[K] Huff-huff...'
        -- case 29: ' Huff-huff...[K] Huff-huff...'
        UI:ResetSpeaker()
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('On a réussi ! On est... dehors !') -- FUT_M17A0401_016 (FR)
        -- case 31: " We did it![K] We're...[K]outside!"
        -- case 32: " We did it![K] We're...[K]outside!"
        UI:ResetSpeaker()
        -- PARTIEL : se_FadeOut [7193, 30]
        -- PARTIEL : WaitSe [7193]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO SE 7187 (SE_NUM_EVENT_MAIN17_DOOR)
        GAME:WaitFrames(60)
        -- back_SetGround(P05P04A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(1)
        GROUND:MoveToPosition(CH('Grovyle'), 272, 172, false, 3.0)
        GAME:WaitFrames(15)
        -- supervision_cting layer [2] (structurel)
        GAME:WaitFrames(1)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1.5*8, CH('PLAYER').Position.Y + 32*8, false, 3.0)
        GAME:WaitFrames(20)
        -- supervision_cting layer [3] (structurel)
        GAME:WaitFrames(1)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), 200, 172, false, 3.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), 236, 188, false, 3.0)
            end),
        })
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Wah ! Qu\'est-ce que c\'est ?') -- FUT_M17A0401_017 (FR)
        -- case 34: ' Wah! What...[K]what is this?!'
        -- case 35: ' Wah! What...[K]what is this?!'
        UI:ResetSpeaker()
        GAME:FadeOut(false, 30)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m17a0401] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m17a0401
