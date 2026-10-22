--[[
    P08P01A_m19a0601.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/m19a0601.ssb
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

local m19a0601 = {}

function m19a0601.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- PARTIEL : back_SetDungeonBanner [32, 0] (bannière)
        GAME:FadeIn(16)
        GAME:WaitFrames(60)
        GAME:FadeOut(false, 16)
        GAME:WaitFrames(15)
        -- back_SetGround(P08P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Grovyle'), 276, 248, false, 2.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Teammate1'), 248, 268, false, 2.0)
            end,
            function()
                GROUND:MoveToPosition(CH('PLAYER'), 304, 268, false, 2.0)
            end,
        })
        GAME:WaitFrames(15)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Is this...\n Is this where Celebi\'s\nsupposed to be?') -- FUT_M19A0601_001 (FR optionnel)
        -- case 0: " Is this...[K] Is this where [CS:N]Celebi[CR]'s\nsupposed to be?"
        -- case 1: ' Is this...[K] Is this where [CS:N]Celebi[CR] is\nsupposed to be?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s right. It was around here\nthat I met her the last time.') -- FUT_M19A0601_002 (FR optionnel)
        UI:WaitShowDialogue(' But if Primal Necrozma knows of\nthis place...') -- FUT_M19A0601_003 (FR optionnel)
        UI:WaitShowDialogue(' Celebi will have fled from here.') -- FUT_M19A0601_004 (FR optionnel)
        UI:WaitShowDialogue(' If this place isn\'t known to our\npursuers, however...') -- FUT_M19A0601_005 (FR optionnel)
        UI:WaitShowDialogue(' Then Celebi should still be here.') -- FUT_M19A0601_006 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Hello? Celebi?') -- FUT_M19A0601_007 (FR optionnel)
        UI:WaitShowDialogue(' It\'s me! Grovyle!') -- FUT_M19A0601_008 (FR optionnel)
        UI:WaitShowDialogue(' Reveal yourself...if you\'re here!') -- FUT_M19A0601_009 (FR optionnel)
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8963') end) -- TODO table SE id 8963
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' She\'s...\nnot coming out...') -- FUT_M19A0601_010 (FR optionnel)
        -- case 11: " She's...[K]not coming out..."
        -- case 12: " She's...[K]not coming out..."
        UI:WaitShowDialogue(' Did Primal Necrozma chase her off?') -- FUT_M19A0601_011 (FR optionnel)
        -- case 14: ' Did Primal [CS:N]Dialga[CR] chase her off?'
        -- case 15: ' Did she get frightened off by\nPrimal [CS:N]Dialga[CR]?'
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What if...') -- FUT_M19A0601_012 (FR optionnel)
        -- case 17: ' What if...'
        -- case 18: ' What if...'
        UI:WaitShowDialogue(' What if she\'s...\nbeen captured by\nPrimal Necrozma?') -- FUT_M19A0601_013 (FR optionnel)
        -- case 20: " What if she's...[K]been captured by\nPrimal [CS:N]Dialga[CR]?"
        -- case 21: " What if she's...[K]been captured by\nPrimal [CS:N]Dialga[CR]?"
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Captured?') -- FUT_M19A0601_014 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end,
        })
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Whoa! Who said that?!') -- FUT_M19A0601_015 (FR optionnel)
        -- case 24: ' Whoa! Who said that?!'
        -- case 25: " Wah! Where'd that voice\ncome from?!"
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8963') end) -- TODO table SE id 8963
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(12)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(45)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
            end,
            function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
            end,
        })
        GAME:WaitFrames(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8962') end) -- TODO table SE id 8962
        GROUND:CharSetEmote(CH('Teammate1'), 'question', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(' But now...\nI don\'t hear anything.') -- FUT_M19A0601_016 (FR optionnel)
        -- case 27: " But now...[K]I don't hear anything."
        -- case 28: " But now...[K]I don't hear anything."
        UI:WaitShowDialogue(' That voice...\n Did I imagine it?') -- FUT_M19A0601_017 (FR optionnel)
        -- case 30: ' That voice...[K] Did I imagine it?'
        -- case 31: ' That voice...[K] Was I just\nhearing things?'
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Tee-hee! You didn\'t imagine it!') -- FUT_M19A0601_018 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Me? Captured?') -- FUT_M19A0601_019 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' How insulting!\n Captured?!') -- FUT_M19A0601_020 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Impossible, that\'s for sure! Tee-hee!') -- FUT_M19A0601_021 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
            end,
        })
        -- performer 3
        -- SetEffect [645, 3] : performer 3 non mappé (PARTIEL)
        -- performer 3
        -- WaitEffect [] : performer 3 non mappé (PARTIEL)
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7433') end) -- TODO table SE id 7433
        GAME:WaitFrames(134)
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBGM('Welcome to the World of Pokémon!.ogg', true) end) -- WelcomeToTheWorldOfPokemon
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' It\'s been too long, my dear Grovyle!') -- FUT_M19A0601_022 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Yes. It has been a while, Celebi.') -- FUT_M19A0601_023 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Huh?!\n This tiny thing is Celebi?') -- FUT_M19A0601_024 (FR optionnel)
        -- case 39: ' Huh?![K] This tiny thing is [CS:N]Celebi[CR]?'
        -- case 40: ' What?![K] This tiny thing is [CS:N]Celebi[CR]?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownLeft, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('Celebi'), 'angry', 3)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Now that is downright rude!') -- FUT_M19A0601_025 (FR optionnel)
        UI:WaitShowDialogue(' How inappropriate! To poke fun\nat my petite proportions...') -- FUT_M19A0601_026 (FR optionnel)
        UI:ResetSpeaker()
        -- SetEffect 0 (aucun) : pas d'effet
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Uh...\nI\'m sorry.') -- FUT_M19A0601_027 (FR optionnel)
        -- case 44: " Uh...[K]I'm sorry."
        -- case 45: " Uh...[K]I'm sorry."
        UI:WaitShowDialogue(' I heard you have the ability to\ncross time...') -- FUT_M19A0601_028 (FR optionnel)
        -- case 47: ' I heard you have the ability to\ncross time...'
        -- case 48: ' I heard you have the ability to\ncross time...'
        UI:WaitShowDialogue(' So I was expecting to see some\nkind of an awesome-looking Pokémon...') -- FUT_M19A0601_029 (FR optionnel)
        -- case 50: ' So I was expecting to see some\nkind of an awesome-looking Pokémon...'
        -- case 51: ' So I expected you to be some\nawe-inspiring Pokémon...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' How uncouth!\n Never judge\nsomeone by appearance!') -- FUT_M19A0601_030 (FR optionnel)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Happy')
        UI:WaitShowDialogue(' But...\nI forgive you.') -- FUT_M19A0601_031 (FR optionnel)
        UI:WaitShowDialogue(' After all...') -- FUT_M19A0601_032 (FR optionnel)
        UI:WaitShowDialogue(' You must find me cuter and\nmore special than you imagined!\n Tee-hee!') -- FUT_M19A0601_033 (FR optionnel)
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8961') end) -- TODO table SE id 8961
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'sweatdrop', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(' Uh, yeah...') -- FUT_M19A0601_034 (FR optionnel)
        -- case 57: ' Uh, yeah...'
        -- case 58: ' Um, yes.'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 0.5*8, CH('Grovyle').Position.Y + 0*8, false, 1.0)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Celebi.\n I need your help again.') -- FUT_M19A0601_035 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' I know.') -- FUT_M19A0601_036 (FR optionnel)
        UI:WaitShowDialogue(' Seeing you back here, my dear\nGrovyle, tells me everything I need to know.') -- FUT_M19A0601_037 (FR optionnel)
        UI:WaitShowDialogue(' You\'re back because you failed\nin your mission in the past, yes?') -- FUT_M19A0601_038 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Grovyle'), 'sweatdrop', 3)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Urk...\n Yes, it\'s true.') -- FUT_M19A0601_039 (FR optionnel)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' I hope you manage this time.\n\nI\'ve quite had enough of this.') -- FUT_M19A0601_040 (FR optionnel)
        UI:WaitShowDialogue(' Living in this dark and dreary\nworld is so depressing.') -- FUT_M19A0601_041 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Sorry, no time to chat...') -- FUT_M19A0601_042 (FR optionnel)
        UI:WaitShowDialogue(' The Sableye are tracking us.') -- FUT_M19A0601_043 (FR optionnel)
        UI:WaitShowDialogue(' If we don\'t leave soon, we\'ll\nhave brought trouble to you.') -- FUT_M19A0601_044 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Tee-hee!\n It\'s quite fine. There\nis no need to be worried.') -- FUT_M19A0601_045 (FR optionnel)
        UI:WaitShowDialogue(' Let those Sableye come. They\'re\nof no concern to me.') -- FUT_M19A0601_046 (FR optionnel)
        UI:WaitShowDialogue(' Besides, if you would be so kind\nas to prevent the planet\'s paralysis...') -- FUT_M19A0601_047 (FR optionnel)
        UI:WaitShowDialogue(' We\'ll finally be spared the agony\nof this world of darkness.') -- FUT_M19A0601_048 (FR optionnel)
        UI:WaitShowDialogue(' My dear Grovyle, I will devote\nmy whole life to achieve that end!') -- FUT_M19A0601_049 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' All right...\n Where is the Passage\nof Time?') -- FUT_M19A0601_050 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' It\'s ready.\n It is nearby.') -- FUT_M19A0601_051 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' The Passage of Time is on a\nplateau above this forest.') -- FUT_M19A0601_052 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s good.\n Can you guide us?') -- FUT_M19A0601_053 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Happy')
        UI:WaitShowDialogue(' Yes!') -- FUT_M19A0601_054 (FR optionnel)
        UI:WaitShowDialogue(' Are all three of you taking the\nPassage of Time?') -- FUT_M19A0601_055 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Yeah. That\'s right.') -- FUT_M19A0601_056 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownRight, 15)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('Celebi'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Oh?! What\'s...\nthis? Your friend!') -- FUT_M19A0601_057 (FR optionnel)
        SOUND:FadeOutBGM(180)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(What...?\n What...?)') -- FUT_M19A0601_058 (FR optionnel)
        -- case 83: '(What...?[K] What...?)'
        UI:ResetSpeaker()
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ........................') -- FUT_M19A0601_059 (FR optionnel)
        UI:WaitShowDialogue(' No...\n That can\'t be...') -- FUT_M19A0601_060 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        GAME:WaitFrames(45)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        GAME:WaitFrames(45)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Is something the matter, Celebi?') -- FUT_M19A0601_061 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Celebi'))
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' No...\n It\'s nothing.') -- FUT_M19A0601_062 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownLeft, 15)
        GAME:WaitFrames(60)
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownRight, 15)
        GAME:WaitFrames(60)
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Down, 15)
        GAME:WaitFrames(30)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Well then.\n Shall we? Off to the\nPassage of Time.') -- FUT_M19A0601_063 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Celebi'), CH('Celebi').Position.X + 1*8, CH('Celebi').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(15)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(30)
        GAME:FadeOut(false, 60)
        GAME:WaitFrames(80)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m19a0601] scène interrompue : '..tostring(err)) end
end

return m19a0601
