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
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7193') end) -- TODO table SE id 7193
        GAME:WaitFrames(90)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Come on! This way!\n We need to\nkeep running until we hit the exit!') -- FUT_M17A0401_001 (FR optionnel)
        UI:ResetSpeaker()
        GAME:WaitFrames(90)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Come on! Faster! Pick it up!') -- FUT_M17A0401_002 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Shouting')
        UI:WaitShowDialogue(' This is the fastest I can go!') -- FUT_M17A0401_003 (FR optionnel)
        -- case 2: ' This is the fastest I can go!'
        -- case 3: ' This is the fastest I can go!'
        UI:WaitShowDialogue(' Quit ordering me around!') -- FUT_M17A0401_004 (FR optionnel)
        -- case 5: ' Quit ordering me around!'
        -- case 6: ' Quit ordering me around!'
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Anyway, Grovyle...!') -- FUT_M17A0401_005 (FR optionnel)
        -- case 8: ' Anyway, [CS:N]Grovyle[CR]...!'
        -- case 9: ' Anyway, [CS:N]Grovyle[CR]...!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What?') -- FUT_M17A0401_006 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Is this...\nthe future?') -- FUT_M17A0401_007 (FR optionnel)
        -- case 12: ' Is this...[K]the future?'
        -- case 13: ' Is this...[K]the future?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s right.\n You catch on fast.') -- FUT_M17A0401_008 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Urk! So it is, after all...') -- FUT_M17A0401_009 (FR optionnel)
        -- case 16: ' Urk! So it is, after all...'
        -- case 17: ' Urk! So it is, after all...'
        UI:WaitShowDialogue(' Are we...\n Are we going to be\nable to get back to our world?') -- FUT_M17A0401_010 (FR optionnel)
        -- case 19: ' Are we...[K] Are we going to be\nable to get back to our world?'
        -- case 20: ' Are we...[K] Are we going to be\nable to get back to our world?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Who knows?\n We just need to get\naway for now.') -- FUT_M17A0401_011 (FR optionnel)
        UI:WaitShowDialogue(' If we get caught, returning home\nwill be the least of your worries.\n Run faster!') -- FUT_M17A0401_012 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' I can\'t!\n I\'m exhausted...\n\nHuff-huff...') -- FUT_M17A0401_013 (FR optionnel)
        -- case 24: " I can't![K] I'm exhausted...[K]\nHuff-huff..."
        -- case 25: " I can't![K] I'm exhausted...[K]\nHuff-huff..."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' We\'re almost there!\n\nLook! The exit is right there!') -- FUT_M17A0401_014 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Huff-huff...\n Huff-huff...') -- FUT_M17A0401_015 (FR optionnel)
        -- case 28: ' Huff-huff...[K] Huff-huff...'
        -- case 29: ' Huff-huff...[K] Huff-huff...'
        UI:ResetSpeaker()
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' We did it!\n We\'re...\noutside!') -- FUT_M17A0401_016 (FR optionnel)
        -- case 31: " We did it![K] We're...[K]outside!"
        -- case 32: " We did it![K] We're...[K]outside!"
        UI:ResetSpeaker()
        -- PARTIEL : se_FadeOut [7193, 30]
        -- PARTIEL : WaitSe [7193]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO table SE id 7187
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
            function()
                GROUND:MoveToPosition(CH('Teammate1'), 200, 172, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('PLAYER'), 236, 188, false, 3.0)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Wah! What...\nwhat is this?!') -- FUT_M17A0401_017 (FR optionnel)
        -- case 34: ' Wah! What...[K]what is this?!'
        -- case 35: ' Wah! What...[K]what is this?!'
        UI:ResetSpeaker()
        GAME:FadeOut(false, 30)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0401] scène interrompue : '..tostring(err)) end
end

return m17a0401
