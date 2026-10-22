--[[
    P05P03A_m17a0302.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P03A/m17a0302.ssb
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

local m17a0302 = {}

function m17a0302.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- back_SetGround(P05P03A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GROUND:CharSetAnim(CH('Teammate1'), 'Head', true) -- param 78 = anim 29 (Head)
        GAME:FadeIn(120)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('O-où sommes-nous ?!') -- FUT_M17A0302_001 (FR)
        -- case 0: ' Wh-where is this?!'
        -- case 1: ' Wh-where is this?!'
        UI:ResetSpeaker()
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -1*8, false, 2.0)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Ils m\'ont ligoté. Je ne peux plus bouger...') -- FUT_M17A0302_002 (FR)
        -- case 3: " They have me trussed up.\nI can't move..."
        -- case 4: " They have me trussed up.\nI can't move..."
        UI:WaitShowDialogue('P-pourquoi est-ce que ça nous arrive ?') -- FUT_M17A0302_003 (FR)
        -- case 6: ' Wh-why is this happening?'
        -- case 7: ' Wh-why is this happening?'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8711') end) -- TODO SE 8711 (SE_NUM_EVENT_MOTION_DOOR)
        -- supervision_emoveActing layer [0] (structurel)
        -- supervision_cting layer [1] (structurel)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('PLAYER'), 'Head', true) -- param 78 = anim 29 (Head)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Teammate1'), 'Head', true) -- param 78 = anim 29 (Head)
            end),
        })
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Hé !') -- FUT_M17A0302_004 (FR)
        -- case 9: ' Hey!'
        -- case 10: ' Hey!'
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('([partner] !)') -- FUT_M17A0302_005 (FR)
        -- case 12: '([partner]!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quel soulagement de te voir ![br]Tu n\'as rien ?') -- FUT_M17A0302_006 (FR)
        -- case 14: " Am I glad to see you![K]\nYou're OK, right?"
        -- case 15: " Am I glad to see you![K]\nYou're OK, right?"
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('Hmpf !') -- FUT_M17A0302_007 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Vous ignorez totalement ce qui vous attend...') -- FUT_M17A0302_008 (FR)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue('Voilà pourquoi vous pouvez encore prendre ça à la légère.') -- FUT_M17A0302_009 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Hein ?') -- FUT_M17A0302_010 (FR)
        -- case 20: ' Huh?!'
        -- case 21: ' Huh?!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(Cette voix venait de là-bas...)') -- FUT_M17A0302_011 (FR)
        -- case 23: '(That voice came from over there...)'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8711') end) -- TODO SE 8711 (SE_NUM_EVENT_MOTION_DOOR)
        -- supervision_emoveActing layer [1] (structurel)
        -- supervision_cting layer [2] (structurel)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('PLAYER'), 'Head', true) -- param 78 = anim 29 (Head)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Teammate1'), 'Head', true) -- param 78 = anim 29 (Head)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Grovyle'), 'Sink', false) -- param 34 = anim 25 (Sink)
            end),
        })
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(30)
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Massko !') -- FUT_M17A0302_012 (FR)
        -- case 25: ' [CS:N]Grovyle[CR]!'
        -- case 26: ' [CS:N]Grovyle[CR]!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Vous rendez-vous compte de l\'endroit où vous êtes ?') -- FUT_M17A0302_013 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('N-non...') -- FUT_M17A0302_014 (FR)
        -- case 29: ' N-no...'
        -- case 30: ' N-no...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est une palissade... Ils se préparent à nous éliminer pour de bon.') -- FUT_M17A0302_015 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi ?! N-nous éliminer ?!') -- FUT_M17A0302_016 (FR)
        -- case 33: ' What?![K] G-get rid of us?!'
        -- case 34: ' What?![K] G-get rid of us?!'
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Attends un peu.') -- FUT_M17A0302_017 (FR)
        -- case 36: ' Wait a second.'
        -- case 37: ' Wait a second.'
        UI:WaitShowDialogue('Je comprends pourquoi ils veulent se débarrasser de toi, Massko.') -- FUT_M17A0302_018 (FR)
        -- case 39: ' I can understand why they want\nto get rid of you, [CS:N]Grovyle[CR].'
        -- case 40: " It's easy to understand why\nthey'd want to get rid of you, [CS:N]Grovyle[CR]."
        UI:WaitShowDialogue('Mais pourquoi nous ?') -- FUT_M17A0302_019 (FR)
        -- case 42: ' But why us?!'
        -- case 43: ' But why us?!'
        UI:WaitShowDialogue('On n\'a rien fait de mal !') -- FUT_M17A0302_020 (FR)
        -- case 45: " We haven't done anything wrong!"
        -- case 46: " We haven't done anything wrong!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hmpf ! Ça m\'est bien égal.') -- FUT_M17A0302_021 (FR)
        UI:WaitShowDialogue('Vous avez sûrement fait quelque chose qu\'ils ne peuvent pas tolérer.') -- FUT_M17A0302_022 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        GROUND:CharSetEmote(CH('Teammate1'), 'angry', 3)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Angry')
        UI:WaitShowDialogue('Quoi ?') -- FUT_M17A0302_023 (FR)
        -- case 50: ' What?!'
        -- case 51: ' What?!'
        UI:WaitShowDialogue('On n\'a rien fait de mal !') -- FUT_M17A0302_024 (FR)
        -- case 53: " We haven't done anything bad!"
        -- case 54: " We haven't done anything bad!"
        UI:WaitShowDialogue('Ne nous mets pas dans le même sac que toi !') -- FUT_M17A0302_025 (FR)
        -- case 56: " Don't think that we're like you!"
        -- case 57: " Don't think that we're like you!"
        UI:ResetSpeaker()
        -- SetEffect 0 (aucun) : pas d'effet
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ça m\'est égal.') -- FUT_M17A0302_026 (FR)
        UI:WaitShowDialogue('Tu perds ton temps à t\'énerver. Pendant ce temps... regarde.') -- FUT_M17A0302_027 (FR)
        UI:WaitShowDialogue('Les voilà.') -- FUT_M17A0302_028 (FR)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO SE 7187 (SE_NUM_EVENT_MAIN17_DOOR)
        GAME:WaitFrames(30)
        -- supervision_emoveActing layer [2] (structurel)
        -- supervision_cting layer [3] (structurel)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('PLAYER'), 'Head', true) -- param 78 = anim 29 (Head)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Teammate1'), 'Head', true) -- param 78 = anim 29 (Head)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Grovyle'), 'Sink', false) -- param 34 = anim 25 (Sink)
            end),
        })
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(60)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 772, false, 2.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_1'), 208, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_1'), 164, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), 244, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_2'), 292, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), 208, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_3'), 188, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), 244, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_4'), 268, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), 208, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_5'), 212, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
            end),
        })
        GAME:WaitFrames(45)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Down, 15)
            end),
        })
        GAME:WaitFrames(45)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7188') end) -- TODO SE 7188 (SE_NUM_EVENT_MAIN17_YAMIRAMI_01)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        GAME:WaitFrames(45)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
            end),
        })
        GAME:WaitFrames(10)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 3.0)
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Waah ! Qui sont-ils ?!') -- FUT_M17A0302_029 (FR)
        -- case 62: ' Waah! Who are they?!'
        -- case 63: ' Waah! Who are they?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ce sont les geôliers qui font tout le sale boulot ici.') -- FUT_M17A0302_030 (FR)
        UI:WaitShowDialogue('Ce sont aussi les sbires de Necrozma.') -- FUT_M17A0302_031 (FR)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
            end),
        })
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8973 (SE_NUM_EVENT_SIGN_SHOCK_03)
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi ?! Les sbires du grand Necrozma ?!') -- FUT_M17A0302_032 (FR)
        -- case 67: " What?![K] The great [CS:N]Dusknoir[CR]'s?!"
        -- case 68: " What?![K] The great [CS:N]Dusknoir[CR]'s?!"
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 772, false, 2.0)
        -- supervision_cting layer [4] (structurel)
        GAME:WaitFrames(1)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, NPC_YONOWAARU
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Necrozma'), 228, 788, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Sableye_1'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Sableye_2'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Sableye_3'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Sableye_4'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Sableye_5'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharTurnToChar(CH('Sableye_6'), CH('Necrozma'))
            end),
        })
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
            end),
        })
        SOUND:FadeOutBGM(160)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Hé ! C\'est Necrozma !') -- FUT_M17A0302_033 (FR)
        -- case 70: " Hey! It's [CS:N]Dusknoir[CR]!"
        -- case 71: " Hey! It's [CS:N]Dusknoir[CR]!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Maître Necrozma. Les trois prisonniers ont été attachés aux poteaux.') -- FUT_M17A0302_034 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Bien.') -- FUT_M17A0302_035 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Maître Necrozma ![br]C\'est moi, [partner] !') -- FUT_M17A0302_036 (FR)
        -- case 75: " [CS:N]Dusknoir[CR], sir![K]\nIt's me, [partner]!"
        -- case 76: " [CS:N]Dusknoir[CR], sir![K]\nIt's me, [partner]!"
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Necrozma'), 228, 768, false, 1.0)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Très bien... Ténéfix.') -- FUT_M17A0302_037 (FR)
        UI:WaitShowDialogue('Ces trois-là... débarrassez-nous-en.') -- FUT_M17A0302_038 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('Growing Anxiety.ogg', true) end) -- OhNo
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi ?!') -- FUT_M17A0302_039 (FR)
        -- case 80: ' What?!'
        -- case 81: ' What?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ne faites pas attention à eux. Préparez-vous.') -- FUT_M17A0302_040 (FR)
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Ténéfix : Hi-hi-hi !') -- FUT_M17A0302_041 (FR)
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7188') end) -- TODO SE 7188 (SE_NUM_EVENT_MAIN17_YAMIRAMI_01)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        GAME:WaitFrames(45)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 676, false, 3.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_1'), 156, 696, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
                GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), 300, 696, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
                GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), 180, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
                GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), 276, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
                GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), 212, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
                GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
                GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
        })
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('A-attendez, Maître Necrozma !') -- FUT_M17A0302_042 (FR)
        -- case 85: ' W-wait a minute! [CS:N]Dusknoir[CR], sir!'
        -- case 86: ' W-wait a minute! [CS:N]Dusknoir[CR], sir!'
        UI:WaitShowDialogue('Mais qu\'est-ce qui vous prend ?!') -- FUT_M17A0302_043 (FR)
        -- case 88: " What's wrong with you?!"
        -- case 89: " What's wrong with you?!"
        UI:WaitShowDialogue('Pourquoi nous faites-vous ça ?!') -- FUT_M17A0302_044 (FR)
        -- case 91: ' Why are you doing this to us?!'
        -- case 92: ' Why are you doing this to us?!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Ne gaspillez pas votre salive...[br]Écoutez plutôt... Chut...') -- FUT_M17A0302_045 (FR)
        UI:WaitShowDialogue('... Baissez la voix, qu\'ils ne puissent pas vous entendre...') -- FUT_M17A0302_046 (FR)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Argh... ! Baisser la voix ?') -- FUT_M17A0302_047 (FR)
        -- case 96: ' Urk...! Keep...my voice down?'
        -- case 97: ' Urk...! Keep...my voice down?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Vous deux... Si vous voulez vous échapper...') -- FUT_M17A0302_048 (FR)
        UI:WaitShowDialogue('... coopérez pleinement avec moi.') -- FUT_M17A0302_049 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Quoi... ? T\'aider, Massko... ?') -- FUT_M17A0302_050 (FR)
        -- case 101: ' What...?[K] Help you, [CS:N]Grovyle[CR]...?'
        -- case 102: ' What...?[K] Help you, [CS:N]Grovyle[CR]...?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Pas le temps de réfléchir...[br]Ou préférez-vous attendre qu\'ils en finissent avec vous ?') -- FUT_M17A0302_051 (FR)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('Psst... Hé, toi...') -- FUT_M17A0302_052 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8978 (SE_NUM_EVENT_SIGN_NOTICE_05)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(...!)') -- FUT_M17A0302_053 (FR)
        -- case 106: '(...!)'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('... Dis-moi...') -- FUT_M17A0302_054 (FR)
        UI:WaitShowDialogue('... Que peux-tu faire, tout de suite ?') -- FUT_M17A0302_055 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(Quoi ? Que puis-je faire ?)') -- FUT_M17A0302_056 (FR)
        -- case 110: '(What?[K] What can I do?)'
        UI:WaitShowDialogue('(Il me demande ça sans prévenir... ! Euh...)') -- FUT_M17A0302_057 (FR)
        -- case 112: '(You ask me that out of nowhere...![K] Umm...)'
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(Qu\'est-ce que je peux faire... ?)') -- FUT_M17A0302_058 (FR)
        -- case 114: '(Wh-what to do...?)'
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('... Non. Un objet ne servira à rien...') -- FUT_M17A0302_059 (FR)
        UI:WaitShowDialogue('... Nous sommes ligotés... et incapables de bouger...') -- FUT_M17A0302_060 (FR)
        UI:WaitShowDialogue('... Il faut quelque chose que tu puisses faire instantanément...') -- FUT_M17A0302_061 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(Argh... ! C\'est facile à dire... Euh...)') -- FUT_M17A0302_062 (FR)
        -- case 122: "(Urk...! That's easy for you to say...[K] Ummm...)"
        -- Jump (structurel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Une capacité... ? Ça pourrait marcher, mais...') -- FUT_M17A0302_063 (FR)
        UI:WaitShowDialogue('... Non ! Ça ne va pas...') -- FUT_M17A0302_064 (FR)
        UI:WaitShowDialogue('... Nous sommes ligotés... nous ne pouvons pas bouger...') -- FUT_M17A0302_065 (FR)
        UI:WaitShowDialogue('... Il faut quelque chose que tu puisses faire instantanément...') -- FUT_M17A0302_066 (FR)
        UI:WaitShowDialogue('... Ça n\'a pas besoin d\'être tape-à-l’œil... Tu ne peux rien faire de plus basique ?') -- FUT_M17A0302_067 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(Argh... ! Ça ne m\'aide pas... Euh...)') -- FUT_M17A0302_068 (FR)
        -- case 129: "(Urk...! You're not helping...[K] Ummm...)"
        -- Jump (structurel)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8965 (SE_NUM_EVENT_SIGN_NOTICE_02)
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('... ! Voilà ! Ça fera l\'affaire...') -- FUT_M17A0302_069 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('... Si c\'est une attaque ordinaire, je pourrai aider, moi aussi...') -- FUT_M17A0302_070 (FR)
        -- case 132: " ...If it's just a regular attack,\nI can help too..."
        -- case 133: " ...If it's just a regular attack,\nI can help too..."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('... Bien.') -- FUT_M17A0302_071 (FR)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
            end),
        })
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 772, false, 3.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharTurnToChar(CH('Sableye_1'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharTurnToChar(CH('Sableye_2'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharTurnToChar(CH('Sableye_3'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharTurnToChar(CH('Sableye_4'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharTurnToChar(CH('Sableye_5'), CH('Necrozma'))
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharTurnToChar(CH('Sableye_6'), CH('Necrozma'))
            end),
        })
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Alors, commençons !') -- FUT_M17A0302_072 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7196') end) -- TODO SE 7196 (SE_NUM_EVENT_MAIN17_YAMIRAMI_02_L)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Wake', false) -- param 23 = anim 14 (Wake)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Wake', false) -- param 23 = anim 14 (Wake)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Wake', false) -- param 23 = anim 14 (Wake)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Wake', false) -- param 23 = anim 14 (Wake)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Wake', false) -- param 23 = anim 14 (Wake)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Wake', false) -- param 23 = anim 14 (Wake)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        -- PARTIEL : se_Stop [7196]
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Très bien.') -- FUT_M17A0302_073 (FR)
        UI:WaitShowDialogue('Mais restez vigilants jusqu\'au bout. Ne les quittez pas des yeux.') -- FUT_M17A0302_074 (FR)
        UI:WaitShowDialogue('Surtout Massko.') -- FUT_M17A0302_075 (FR)
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Ténéfix : Hi-hi-hi !') -- FUT_M17A0302_076 (FR)
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7188') end) -- TODO SE 7188 (SE_NUM_EVENT_MAIN17_YAMIRAMI_01)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'EventSleep', false) -- param 22 = anim 13 (EventSleep)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        GAME:WaitFrames(45)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
            end),
        })
        GROUND:MoveToPosition(CH('Necrozma'), CH('Necrozma').Position.X + 0.5*8, CH('Necrozma').Position.Y + 0*8, false, 1.0)
        GROUND:CharAnimateTurnTo(CH('Necrozma'), Direction.Up, 15)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Commencez... maintenant !') -- FUT_M17A0302_077 (FR)
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 676, false, 3.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Ténéfix : Hi-hi-hi !') -- FUT_M17A0302_078 (FR)
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
        })
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 0*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end),
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('...! Ils arrivent...') -- FUT_M17A0302_079 (FR)
        -- case 143: " ...! They're coming..."
        -- case 144: " ...! They're coming..."
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('... Écoutez-moi bien...') -- FUT_M17A0302_080 (FR)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
            end),
        })
        UI:SetCenter(true)
        UI:WaitShowDialogue('Les Ténéfix attaquent avec leurs griffes...') -- FUT_M17A0302_081 (FR)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('... ! Ça fait peur...') -- FUT_M17A0302_082 (FR)
        -- case 148: ' ...! Yikes...that sounds scary!'
        -- case 149: ' ...! Yikes...that sounds scary!'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 0*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end),
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('... Et cela pourrait justement nous offrir une échappatoire...') -- FUT_M17A0302_083 (FR)
        UI:WaitShowDialogue('Les Ténéfix vont se déchaîner avec Combo-Griffe... Ce sera notre chance.') -- FUT_M17A0302_084 (FR)
        UI:WaitShowDialogue('Si une seule de leurs attaques touchait les cordes qui nous retiennent...') -- FUT_M17A0302_085 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8978 (SE_NUM_EVENT_SIGN_NOTICE_05)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Ah, oui... Les cordes pourraient céder !') -- FUT_M17A0302_086 (FR)
        -- case 154: ' ...Oh, right...![K] The ropes might\ncome loose!'
        -- case 155: ' ...Oh, right...![K] The ropes might\ncome loose!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Exactement... Si cela arrive, lancez une attaque, puis fuyez !') -- FUT_M17A0302_087 (FR)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + -8*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue('... M-mais...') -- FUT_M17A0302_088 (FR)
        -- case 158: ' ...B-b-but...'
        -- case 159: ' ...B-b-but...'
        UI:WaitShowDialogue('Et si leurs Combo-Griffe ne tranchent pas les cordes ?') -- FUT_M17A0302_089 (FR)
        -- case 161: " ...What if their [CS:M]Fury Swipes[CR]\ndon't slash the ropes...?"
        -- case 162: " ...What if their [CS:M]Fury Swipes[CR]\ndon't slash the ropes...?"
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 0*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end),
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end),
        })
        UI:SetCenter(true)
        UI:WaitShowDialogue('Et si... Et si les Ténéfix n\'utilisent pas Combo-Griffe ?') -- FUT_M17A0302_090 (FR)
        UI:SetCenter(false)
        -- case 164: " ...And what if...[K] What if the\n[CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?"
        -- case 165: " ...And what if...[K] What if the\n[CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?"
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7194') end) -- TODO SE 7194 (SE_NUM_EVENT_MAIN15_KAMAE_02)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Eat', false) -- param 24 = anim 15 (Eat)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Eat', false) -- param 24 = anim 15 (Eat)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Eat', false) -- param 24 = anim 15 (Eat)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Eat', false) -- param 24 = anim 15 (Eat)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Eat', false) -- param 24 = anim 15 (Eat)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Eat', false) -- param 24 = anim 15 (Eat)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Ténéfix : Hi-hi-hi !') -- FUT_M17A0302_091 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Si ça arrive... autant ne pas y penser.') -- FUT_M17A0302_092 (FR)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7196') end) -- TODO SE 7196 (SE_NUM_EVENT_MAIN17_YAMIRAMI_02_L)
        -- supervision_cting layer [8] (structurel)
        -- object 138 (p05p03a2) : contexte objet
        FutureScene.ObjectSetAnim('p05p03a2', 1, 0, 3, Direction.Down, 1) -- objet 138, anim 1 (table REQUISE)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Left, 15)
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Shouting')
        UI:WaitShowDialogue('WAAAAH !') -- FUT_M17A0302_093 (FR)
        -- case 169: ' WAAAAAAH!'
        -- case 170: ' WAAAAAAH!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('(Argh !)') -- FUT_M17A0302_094 (FR)
        -- case 172: '(Urggh!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('T-tenez bon ! Attendez le bon moment !') -- FUT_M17A0302_095 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Mais s\'ils continuent...') -- FUT_M17A0302_096 (FR)
        -- case 175: ' But if they keep going...'
        -- case 176: ' But if they keep going...'
        UI:WaitShowDialogue('Nous serons K.-O. avant d\'en avoir l\'occasion !') -- FUT_M17A0302_097 (FR)
        -- case 178: " We'll be down before our\nchance comes!"
        -- case 179: " We'll be finished before our\nchance comes!"
        UI:ResetSpeaker()
        -- object 136 (p05p03a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p03a1', 18, 0, 3, Direction.Down, 1) -- objet 136, anim 18 (table REQUISE)
        GROUND:TeleportTo(CH('PLAYER'), CH('PLAYER').Position.X + 0*8, CH('PLAYER').Position.Y + 2*8)
        -- object 136 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Hé !') -- FUT_M17A0302_098 (FR)
        -- case 181: ' Hey!'
        -- case 182: ' Hey!'
        UI:ResetSpeaker()
        -- object 135 (p05p03a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p03a1', 18, 0, 3, Direction.Down, 1) -- objet 135, anim 18 (table REQUISE)
        GROUND:TeleportTo(CH('Teammate1'), CH('Teammate1').Position.X + 0*8, CH('Teammate1').Position.Y + 2*8)
        -- object 135 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('(Une corde est entaillée !)') -- FUT_M17A0302_099 (FR)
        -- case 184: "(There's a break in the rope!)"
        UI:ResetSpeaker()
        -- object 137 (p05p03a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p03a1', 18, 0, 3, Direction.Down, 1) -- objet 137, anim 18 (table REQUISE)
        GROUND:TeleportTo(CH('Grovyle'), CH('Grovyle').Position.X + 0*8, CH('Grovyle').Position.Y + 2*8)
        -- object 137 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Maintenant ! Attaque !') -- FUT_M17A0302_100 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue('Allez !') -- FUT_M17A0302_101 (FR)
        -- case 187: ' Go!'
        -- case 188: ' Go!'
        UI:ResetSpeaker()
        -- PARTIEL : se_FadeOut [7196, 10]
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        -- object 138 (p05p03a2) : contexte objet
        pcall(function() GROUND:Hide(CH('Sableye_6').EntName) end)
        -- object 136 (p05p03a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p03a1', 19, 0, 3, Direction.Down, 1) -- objet 136, anim 19 (table REQUISE)
        -- object 137 (p05p03a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p03a1', 19, 0, 3, Direction.Down, 1) -- objet 137, anim 19 (table REQUISE)
        -- object 135 (p05p03a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p03a1', 19, 0, 3, Direction.Down, 1) -- objet 135, anim 19 (table REQUISE)
        -- object 135 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:MoveToPosition(CH('PLAYER'), 228, 668, false, 5.0)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:MoveToPosition(CH('Teammate1'), 276, 668, false, 5.0)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:MoveToPosition(CH('Grovyle'), 180, 668, false, 5.0)
            end),
        })
        -- object 135 (p05p03a1) : contexte objet
        FutureScene.ObjectSetAnim('p05p03a1', 12, 0, 3, Direction.Down, 1) -- objet 135, anim 12 (table REQUISE)
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 5126 (SE_NUM_EVENT_EFF_FLASH_HEAVY_02)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('PLAYER'), 'Attack', false) -- param 13 = anim 1 (Attack)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Teammate1'), 'Attack', false) -- param 13 = anim 1 (Attack)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Grovyle'), 'Attack', false) -- param 12 = anim 2 (Attack)
            end),
        })
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Gwah !') -- FUT_M17A0302_102 (FR)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 6.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_1'), 'shock', 3)
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hurt', true) -- param 14 = anim 6 (Hurt)
                GROUND:AnimateToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 3*8, CH('Sableye_1').Position.Y + -8*8, false, 6.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_2'), 'shock', 3)
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hurt', true) -- param 14 = anim 6 (Hurt)
                GROUND:AnimateToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 3*8, CH('Sableye_2').Position.Y + 8*8, false, 6.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_3'), 'shock', 3)
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hurt', true) -- param 14 = anim 6 (Hurt)
                GROUND:AnimateToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 3*8, CH('Sableye_3').Position.Y + 0*8, false, 6.0)
            end),
        })
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_4'), 'shock', 3)
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hurt', true) -- param 14 = anim 6 (Hurt)
                GROUND:AnimateToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 3*8, CH('Sableye_4').Position.Y + 0*8, false, 6.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hurt', true) -- param 14 = anim 6 (Hurt)
                GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 3*8, CH('Sableye_5').Position.Y + 0*8, false, 6.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_6'), 'shock', 3)
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hurt', true) -- param 14 = anim 6 (Hurt)
                GROUND:AnimateToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 3*8, CH('Sableye_6').Position.Y + 0*8, false, 6.0)
            end),
        })
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 776, false, 4.0)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('Necrozma'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Qu-qu\'est-ce que c\'est ?!') -- FUT_M17A0302_103 (FR)
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 4.0)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Par là !') -- FUT_M17A0302_104 (FR)
        UI:ResetSpeaker()
        SOUND:StopBGM()
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 7191 (SE_NUM_EVENT_MAIN17_HIKARIDAMA)
        GROUND:CharSetAnim(CH('Grovyle'), 'Pull', false) -- param 27 = anim 18 (Pull)
        pcall(function() GROUND:CharWaitAnim(CH('Grovyle')) end)
        GAME:FadeOut(true, 5)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Gaaaah !') -- FUT_M17A0302_105 (FR)
        UI:WaitShowDialogue('On n\'y voit rien !') -- FUT_M17A0302_106 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Reprenez-vous ! Ce n\'est qu\'un Lumiorbe !') -- FUT_M17A0302_107 (FR)
        UI:WaitShowDialogue('Son effet se dissipe vite !') -- FUT_M17A0302_108 (FR)
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
        })
        pcall(function() GROUND:Hide(CH('PLAYER').EntName) end)
        pcall(function() GROUND:Hide(CH('Teammate1').EntName) end)
        pcall(function() GROUND:Hide(CH('Grovyle').EntName) end)
        GAME:FadeIn(60)
        GAME:WaitFrames(15)
        -- PARTIEL : WaitSe [7191]
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_1'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_2'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_3'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_4'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Sableye_6'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end),
        })
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(7)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(2)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(3)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(5)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(4)
        -- ExecuteCommon(LOOK_AROUND_DOWN_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 776, false, 3.0)
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8973 (SE_NUM_EVENT_SIGN_SHOCK_03)
        GROUND:CharSetEmote(CH('Necrozma'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Necrozma'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('M-malédiction !') -- FUT_M17A0302_109 (FR)
        UI:WaitShowDialogue('Ce Massko ! Il s\'est enfui en profitant de l\'éclat du Lumiorbe !') -- FUT_M17A0302_110 (FR)
        UI:WaitShowDialogue('Ils ne s\'en tireront pas comme ça ! Venez !') -- FUT_M17A0302_111 (FR)
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue('Ténéfix : Hi-hi-hi !') -- FUT_M17A0302_112 (FR)
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
        })
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Necrozma'), 228, 932, false, 3.0)
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 916, false, 4.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:MoveToPosition(CH('Sableye_5'), 212, 916, false, 4.0)
            end),
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:MoveToPosition(CH('Sableye_4'), 244, 916, false, 4.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:MoveToPosition(CH('Sableye_3'), 212, 916, false, 4.0)
            end),
        })
        GAME:WaitFrames(8)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:MoveToPosition(CH('Sableye_2'), 244, 916, false, 4.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:MoveToPosition(CH('Sableye_1'), 212, 916, false, 4.0)
            end),
        })
        pcall(function() GROUND:Hide(CH('Necrozma').EntName) end)
        pcall(function() GROUND:Hide(CH('Sableye_6').EntName) end)
        pcall(function() GROUND:Hide(CH('Sableye_5').EntName) end)
        pcall(function() GROUND:Hide(CH('Sableye_4').EntName) end)
        pcall(function() GROUND:Hide(CH('Sableye_3').EntName) end)
        pcall(function() GROUND:Hide(CH('Sableye_2').EntName) end)
        pcall(function() GROUND:Hide(CH('Sableye_1').EntName) end)
        GAME:WaitFrames(60)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 2.0)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7192') end) -- TODO SE 7192 (SE_NUM_EVENT_MAIN17_APPEAR)
        -- supervision_cting layer [5] (structurel)
        -- performer 4
        -- SetEffect [54, 3] : performer 4 non mappé (PARTIEL)
        GROUND:CharSetAnim(CH('Grovyle'), 'Pain', false) -- param 28 = anim 19 (Pain)
        pcall(function() GROUND:CharWaitAnim(CH('Grovyle')) end)
        -- SetAnimation 2 (spécial : boucle anim courante)
        -- performer 4
        -- SetEffect [0, 3] : performer 4 non mappé (PARTIEL)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7192') end) -- TODO SE 7192 (SE_NUM_EVENT_MAIN17_APPEAR)
        -- supervision_cting layer [6] (structurel)
        -- performer 5
        -- SetEffect [54, 3] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- WaitEffect [] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- SetEffect [0, 3] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- SetEffect [100, 3] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- WaitEffect [] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- SetEffect [0, 3] : performer 5 non mappé (PARTIEL)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7192') end) -- TODO SE 7192 (SE_NUM_EVENT_MAIN17_APPEAR)
        -- supervision_cting layer [7] (structurel)
        -- performer 6
        -- SetEffect [54, 3] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- WaitEffect [] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- SetEffect [0, 3] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- SetEffect [100, 3] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- WaitEffect [] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- SetEffect [0, 3] : performer 6 non mappé (PARTIEL)
        GAME:WaitFrames(60)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue('Beurk ! J\'ai de la terre dans la bouche...') -- FUT_M17A0302_113 (FR)
        -- case 201: ' Blecch! I got dirt in my mouth...'
        -- case 202: ' Blecch! I got dirt in my mouth...'
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBGM('In the Depths of the Pit.ogg', true) end) -- InTheDepthsOfThePit
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('(On est... On est en sécurité...)') -- FUT_M17A0302_114 (FR)
        -- case 204: "(We're...[K] We're safe...)"
        UI:WaitShowDialogue('(Alors Massko peut utiliser Tunnel ?)') -- FUT_M17A0302_115 (FR)
        -- case 206: '(So [CS:N]Grovyle[CR] can use [CS:M]Dig[CR]?)'
        UI:WaitShowDialogue('(Il connaît vraiment beaucoup de capacités.)') -- FUT_M17A0302_116 (FR)
        -- case 208: '(He sure knows many moves.)'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.UpRight, 15)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
            end),
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('On s\'est tirés de ce mauvais pas...[br]Mais nous ne sommes pas encore sauvés.') -- FUT_M17A0302_117 (FR)
        UI:WaitShowDialogue('Sortons d\'ici, et vite.') -- FUT_M17A0302_118 (FR)
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 832, false, 2.0)
        GROUND:MoveToPosition(CH('Grovyle'), 192, 796, false, 2.0)
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('Teammate1'), 264, 796, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 264, 772, false, 2.0)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownRight, 15)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
        GAME:WaitFrames(20)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
        GAME:WaitFrames(30)
        SOUND:FadeOutBGM(180)
        GROUND:MoveToPosition(CH('Grovyle'), 228, 932, false, 2.398)
        GAME:WaitFrames(20)
        GROUND:MoveToPosition(CH('Teammate1'), 228, 932, false, 2.398)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 228, 932, false, 2.398)
        GAME:WaitFrames(30)
        GAME:FadeOut(false, 60)
        GAME:WaitFrames(80)
        -- flag_CalcBit(SCENARIO_MAIN_BIT_FLAG, 8, 1) : opérations bit (adaptation)
        SV.Scenario.CompulsorySavePoint = 14 -- flag_Set(COMPULSORY_SAVE_POINT)
        -- HANYOU_SAVE_FUNC : point de sauvegarde obligatoire (à brancher)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m17a0302] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m17a0302
