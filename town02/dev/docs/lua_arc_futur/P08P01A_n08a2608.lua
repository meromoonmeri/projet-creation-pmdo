--[[
    P08P01A_n08a2608.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/n08a2608.ssb
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

local n08a2608 = {}

function n08a2608.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- back_SetGround(P08P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        -- SetAnimation id 12 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('Dusknoir')) end)
        GAME:WaitFrames(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5121') end) -- TODO table SE id 5121
        GAME:FadeOut(true, 2)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 2.5*8, CH('PLAYER').Position.Y + 0*8, false, 5.0)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_4'), 'shock', 3)
                -- SetAnimation id 29 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
                CH('Sableye_4').Direction = Direction.UpRight
                GROUND:AnimateToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 2.5*8, CH('Sableye_4').Position.Y + -24*8, false, 5.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
                -- SetAnimation id 29 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
                CH('Sableye_5').Direction = Direction.UpRight
                GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 2.5*8, CH('Sableye_5').Position.Y + 0*8, false, 5.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_6'), 'shock', 3)
                -- SetAnimation id 29 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                CH('Sableye_6').Direction = Direction.UpRight
                GROUND:AnimateToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 2.5*8, CH('Sableye_6').Position.Y + 24*8, false, 5.0)
            end,
        })
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(' Gwah!') -- FUT_N08A2608_001 (FR optionnel)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_1'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_2'), 'shock', 3)
            end,
        })
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Sableye_3'), 'shock', 3)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        UI:ResetSpeaker()
        CH('Sableye_4').Direction = Direction.Up
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_4')) end)
        GAME:WaitFrames(7)
        CH('Sableye_6').Direction = Direction.Up
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
        GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.UpRight, 15)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
        GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.UpLeft, 15)
        GROUND:MoveToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 0.5*8, CH('Dusknoir').Position.Y + 0*8, false, 1.0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Sableye_2'), 'sweatdrop', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Sableye_4'), 'sweatdrop', 3)
        GAME:WaitFrames(4)
        GROUND:CharSetEmote(CH('Sableye_6'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(' Wheh-heh-heh...\n\nEeee...\neeeeeeeek!') -- FUT_N08A2608_002 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7430') end) -- TODO table SE id 7430
        GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 2.5*8, CH('Sableye_2').Position.Y + 0*8, false, 5.0)
        GAME:WaitFrames(2)
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 2.5*8, CH('Sableye_1').Position.Y + -80*8, false, 5.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 2.5*8, CH('Sableye_3').Position.Y + 80*8, false, 5.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 2.5*8, CH('Sableye_4').Position.Y + 16*8, false, 5.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 2.5*8, CH('Sableye_6').Position.Y + -16*8, false, 5.0)
            end,
            function()
                CH('Sableye_5').Direction = Direction.Up
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_5')) end)
            end,
        })
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(15)
        -- ExecuteCommon(LOOK_AROUND_FAST_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Sableye_5'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Down, 15)
        -- (parallèle) NPC_YAMIRAMI5, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Down, 15)
            end,
        })
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Wait!') -- FUT_N08A2608_003 (FR optionnel)
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 0*8, false, 2.0)
        GROUND:MoveToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 2*8, CH('Dusknoir').Position.Y + 0*8, false, 4.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.7969*8, CH('Sableye_5').Position.Y + 0*8, false, 1.594)
        -- SetAnimation id 28 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('Dusknoir')) end)
        GAME:WaitFrames(15)
        -- SetAnimation id 11 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7943') end) -- TODO table SE id 7943
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(' Ooogh...') -- FUT_N08A2608_004 (FR optionnel)
        UI:WaitShowDialogue(' Ugh...\n You\'re squishing me...') -- FUT_N08A2608_005 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        GROUND:MoveToPosition(CH('HeroFuture'), 316, 392, false, 2.0)
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Left, 15)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Tell us!') -- FUT_N08A2608_006 (FR optionnel)
        UI:WaitShowDialogue(' What happened to Celebi?!') -- FUT_N08A2608_007 (FR optionnel)
        UI:WaitShowDialogue(' Where\'s Necrozma?!') -- FUT_N08A2608_008 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(' Ugh...\n M...\nMaster Necrozma...\n\nRan off in pursuit of Celebi...') -- FUT_N08A2608_009 (FR optionnel)
        UI:WaitShowDialogue(' T-to...\nFrozen Island...') -- FUT_N08A2608_010 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Frozen Island?') -- FUT_N08A2608_011 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That solitary island to the\nsouth of here!?') -- FUT_N08A2608_012 (FR optionnel)
        UI:WaitShowDialogue(' Is that right?!') -- FUT_N08A2608_013 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(' Y...\nyeah!\n That\'s right...') -- FUT_N08A2608_014 (FR optionnel)
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI5, NPC_YONOWAARU_N8
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 40 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 4*8, CH('Sableye_5').Position.Y + 0*8, false, 8.0)
            end,
        })
        GAME:WaitFrames(15)
        GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 4*8, CH('Sableye_5').Position.Y + 0*8, false, 8.0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5121') end) -- TODO table SE id 5121
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        -- (parallèle) NPC_YAMIRAMI5, NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 27 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
                CH('Sableye_5').Direction = Direction.DownRight
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.DownLeft, 15)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(' Gwah!') -- FUT_N08A2608_015 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 1*8, CH('Sableye_5').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(3)
        GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 1*8, CH('Sableye_5').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(3)
        GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 1*8, CH('Sableye_5').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(3)
        GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 1*8, CH('Sableye_5').Position.Y + 1*8, false, 2.0)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(' Ooogh...\n Ahem...') -- FUT_N08A2608_016 (FR optionnel)
        UI:ResetSpeaker()
        CH('Sableye_5').Direction = Direction.Down
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_5')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(15)
        GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
        GAME:WaitFrames(15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Sableye_5'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Beat it!') -- FUT_N08A2608_017 (FR optionnel)
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(' Eeee...\neeeeeek!') -- FUT_N08A2608_018 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(120)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_4')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_6')) end)
        GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 2.5*8, CH('Sableye_5').Position.Y + 0*8, false, 5.0)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_5')) end)
        GAME:WaitFrames(150)
        GROUND:CharTurnToChar(CH('HeroFuture'), CH('Dusknoir'))
        GROUND:CharTurnToChar(CH('Dusknoir'), CH('HeroFuture'))
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Frozen Island...\n\nIs it a different land?') -- FUT_N08A2608_019 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s right.\n We\'ll have to\nmove across space.') -- FUT_N08A2608_020 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' How do we do that?') -- FUT_N08A2608_021 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Don\'t worry.') -- FUT_N08A2608_022 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' If we follow the cliff\nsouth from here...') -- FUT_N08A2608_023 (FR optionnel)
        UI:WaitShowDialogue(' The Porygon there will send\nus across space.') -- FUT_N08A2608_024 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Let\'s go.') -- FUT_N08A2608_025 (FR optionnel)
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 0.5*8, CH('PLAYER').Position.Y + 0*8, false, 1.0)
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 0.7969*8, CH('Dusknoir').Position.Y + 0*8, false, 1.594)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.DownLeft, 15)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8978') end) -- TODO table SE id 8978
        -- SetEffect id 172 : NON CONVERTI (table effets REQUISE)
        -- WaitEffect (les appels GROUND sont bloquants)
        -- SetAnimation id 41 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('Dusknoir')) end)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        -- SetEffect id 172 : NON CONVERTI (table effets REQUISE)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' What is it?') -- FUT_N08A2608_026 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('On the Ceiling.ogg', true) end) -- OnTheCeiling
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Oh, it\'s nothing...') -- FUT_N08A2608_027 (FR optionnel)
        UI:WaitShowDialogue(' It\'s just...\nmy arms...') -- FUT_N08A2608_028 (FR optionnel)
        UI:WaitShowDialogue(' I feel like I\'ve regained the\nstrength in my arms.') -- FUT_N08A2608_029 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('HeroFuture'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' ...! (Now that you mention it...)') -- FUT_N08A2608_030 (FR optionnel)
        UI:WaitShowDialogue(' (Earlier, when he was pushing\naround the Sableye, that incredible power...)') -- FUT_N08A2608_031 (FR optionnel)
        UI:WaitShowDialogue(' (There\'s no mistaking it...)') -- FUT_N08A2608_032 (FR optionnel)
        UI:WaitShowDialogue(' (Dusknoir\'s power is growing\nstronger than ever before...)') -- FUT_N08A2608_033 (FR optionnel)
        UI:WaitShowDialogue(' (I wonder if his wounds have\nsignificantly healed...)') -- FUT_N08A2608_034 (FR optionnel)
        UI:ResetSpeaker()
        -- MoveHeight [1, 2] : LocHeight (table alt. REQUISE)
        GAME:WaitFrames(1)
        -- MoveHeight [1, 0] : LocHeight (table alt. REQUISE)
        GAME:WaitFrames(7)
        -- MoveHeight [1, 2] : LocHeight (table alt. REQUISE)
        GAME:WaitFrames(1)
        -- MoveHeight [1, 0] : LocHeight (table alt. REQUISE)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Heh-heh-heh... My strength...\n\nMy strength is returning...') -- FUT_N08A2608_035 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' .........') -- FUT_N08A2608_036 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(120)
        GAME:FadeOut(false, 90)
        GAME:WaitFrames(60)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[n08a2608] scène interrompue : '..tostring(err)) end
end

return n08a2608
