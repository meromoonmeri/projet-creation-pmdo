--[[
    P05P01A_n08a2008.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P01A/n08a2008.ssb
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

local n08a2008 = {}

function n08a2008.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' All right!\n Made it through\nthe dungeon!') -- FUT_N08A2008_001 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What you see over there is\nthe pinnacle, Grovyle.') -- FUT_N08A2008_002 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Got it!\n Let\'s go!') -- FUT_N08A2008_003 (FR optionnel)
        UI:ResetSpeaker()
        -- back_SetGround(P05P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(1)
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                -- SetOutputAttribute [8] : PARTIEL
            end,
            function()
                -- SetOutputAttribute [8] : PARTIEL
            end,
        })
        -- NON CONVERTI : bgm2_PlayFadeIn (un seul canal BGM dans PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('HeroFuture'), 180, 308, false, 2.0)
        GAME:WaitFrames(55)
        GROUND:MoveToPosition(CH('Dusknoir'), 220, 332, false, 2.0)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(50)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        GAME:WaitFrames(25)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 204, 248, false, 0.5)
        GROUND:MoveToPosition(CH('HeroFuture'), 180, 252, false, 2.0)
        GAME:WaitFrames(20)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.DownRight, 15)
        GAME:WaitFrames(50)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.DownLeft, 15)
        GAME:WaitFrames(10)
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.UpRight, 15)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        GAME:WaitFrames(10)
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 0.5*8, CH('Dusknoir').Position.Y + 0*8, false, 1.0)
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.UpLeft, 15)
            end,
        })
        GAME:WaitFrames(40)
        GROUND:MoveToPosition(CH('Dusknoir'), 220, 252, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.DownLeft, 15)
        GAME:WaitFrames(50)
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Left, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Right, 15)
            end,
        })
        GAME:WaitFrames(40)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...\nNobody\'s...\nhere, huh...') -- FUT_N08A2008_004 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 0.5*8, CH('Dusknoir').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.UpRight, 15)
        GAME:WaitFrames(40)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.DownRight, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s very strange...') -- FUT_N08A2008_005 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Right, 15)
        GAME:WaitFrames(6)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.UpRight, 15)
        GAME:WaitFrames(6)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Up, 15)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Master Necrozma is always\nover there.') -- FUT_N08A2008_006 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Right, 15)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Why isn\'t Necrozma\nthere now?') -- FUT_N08A2008_007 (FR optionnel)
        UI:WaitShowDialogue(' Sableye said that Necrozma would\nsend a final agent.') -- FUT_N08A2008_008 (FR optionnel)
        UI:WaitShowDialogue(' But to send another agent back\nto the past...') -- FUT_N08A2008_009 (FR optionnel)
        UI:WaitShowDialogue(' I expect it would take an\nenormous amount of power.') -- FUT_N08A2008_010 (FR optionnel)
        UI:WaitShowDialogue(' To generate that kind of power...\n\nNecrozma would have to hold still for some time...') -- FUT_N08A2008_011 (FR optionnel)
        UI:WaitShowDialogue(' I thought he was in\nTemporal Tower...') -- FUT_N08A2008_012 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Your guess is correct.\n\nI thought so too...') -- FUT_N08A2008_013 (FR optionnel)
        UI:WaitShowDialogue(' I thought so...\n\nThat should be right...') -- FUT_N08A2008_014 (FR optionnel)
        UI:WaitShowDialogue(' ...\nHowever...') -- FUT_N08A2008_015 (FR optionnel)
        UI:WaitShowDialogue(' If he\'s going to send an agent\nback to the past...\nthere\'s another method.') -- FUT_N08A2008_016 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8978') end) -- TODO table SE id 8978
        GROUND:CharSetEmote(CH('HeroFuture'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Back to the past...\n\nAnother method?') -- FUT_N08A2008_017 (FR optionnel)
        -- NON CONVERTI : bgm2_FadeOut (un seul canal BGM dans PMDO)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Left, 15)
        pcall(function() SOUND:PlayBGM('Time Gear Remix.ogg', true) end) -- TimeGearRemix
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s right...\n If he needs to\nsend the agent through time...') -- FUT_N08A2008_018 (FR optionnel)
        UI:WaitShowDialogue(' Grovyle...\nyou should know what\nmethod I\'m talking about.') -- FUT_N08A2008_019 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' I-I...\nshould know what method?') -- FUT_N08A2008_020 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('HeroFuture'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' N-no...\n It can\'t be!') -- FUT_N08A2008_021 (FR optionnel)
        UI:WaitShowDialogue(' The Passage of Time!?') -- FUT_N08A2008_022 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Yes.\n The Passage of Time.') -- FUT_N08A2008_023 (FR optionnel)
        UI:WaitShowDialogue(' Rather than waiting for Master\nNecrozma to regenerate...') -- FUT_N08A2008_024 (FR optionnel)
        UI:WaitShowDialogue(' They will most likely look for\nCelebi and use the Passage of Time\nto send the agent back to the past.') -- FUT_N08A2008_025 (FR optionnel)
        UI:WaitShowDialogue(' I\'m sure of it.') -- FUT_N08A2008_026 (FR optionnel)
        UI:WaitShowDialogue(' Master Necrozma...\nprobably left\nhere to catch Celebi.') -- FUT_N08A2008_027 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('HeroFuture'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' D-Necrozma...left to catch\nCelebi!?') -- FUT_N08A2008_028 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Down, 15)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' B-but...\n I don\'t think it will be\nthat easy to catch Celebi...') -- FUT_N08A2008_029 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' If it were just the Sableye,\nyou\'d be right...') -- FUT_N08A2008_030 (FR optionnel)
        UI:WaitShowDialogue(' However, it is a different story\nif Master Necrozma himself went to catch her.') -- FUT_N08A2008_031 (FR optionnel)
        -- message_KeyWait (le dialogue bloque déjà)
        SOUND:FadeOutBGM(120)
        UI:WaitShowDialogue(' And that new henchman...\n\nI\'m worried about their ability...') -- FUT_N08A2008_032 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Right, 15)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Dusk Forest!') -- FUT_N08A2008_033 (FR optionnel)
        UI:WaitShowDialogue(' I always met Celebi in\nDusk Forest!') -- FUT_N08A2008_034 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('HeroFuture'), CH('HeroFuture').Position.X + 1.5*8, CH('HeroFuture').Position.Y + 0*8, false, 3.0)
        GAME:WaitFrames(8)
        GROUND:MoveToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 1.5*8, CH('Dusknoir').Position.Y + 0*8, false, 3.0)
        GAME:WaitFrames(30)
        GAME:FadeOut(false, 30)
        GAME:WaitFrames(30)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[n08a2008] scène interrompue : '..tostring(err)) end
end

return n08a2008
