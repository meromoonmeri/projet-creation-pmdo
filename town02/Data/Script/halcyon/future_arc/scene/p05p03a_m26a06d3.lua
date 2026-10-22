--[[
    P05P03A_m26a06d3.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P03A/m26a06d3.ssb
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

local m26a06d3 = {}

function m26a06d3.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('Time Restored.ogg', true) end) -- MemoriesReturned
        -- back_SetGround(P05P03A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [3] (structurel)
        -- supervision_cting layer [4] (structurel)
        GAME:WaitFrames(1)
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
        -- performer 0
        GROUND:TeleportTo(CH('PLAYER'), 228, 676)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, NPC_YONOWAARU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                CH('PLAYER').Direction = Direction.Left
            end),
            TASK:BranchCoroutine(function()
                CH('Teammate1').Direction = Direction.Right
            end),
            TASK:BranchCoroutine(function()
                CH('Grovyle').Direction = Direction.Left
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_1'), CH('Sableye_1').Position.X + 8*8, CH('Sableye_1').Position.Y + -32*8)
                CH('Sableye_1').Direction = Direction.UpRight
                GROUND:CharSetAnim(CH('Sableye_1'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_2'), CH('Sableye_2').Position.X + -8*8, CH('Sableye_2').Position.Y + -32*8)
                CH('Sableye_2').Direction = Direction.UpLeft
                GROUND:CharSetAnim(CH('Sableye_2'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_3'), CH('Sableye_3').Position.X + 0*8, CH('Sableye_3').Position.Y + -32*8)
                CH('Sableye_3').Direction = Direction.Up
                GROUND:CharSetAnim(CH('Sableye_3'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_4'), CH('Sableye_4').Position.X + 0*8, CH('Sableye_4').Position.Y + -32*8)
                CH('Sableye_4').Direction = Direction.Up
                GROUND:CharSetAnim(CH('Sableye_4'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_5'), CH('Sableye_5').Position.X + 0*8, CH('Sableye_5').Position.Y + -32*8)
                CH('Sableye_5').Direction = Direction.Up
                GROUND:CharSetAnim(CH('Sableye_5'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_6'), CH('Sableye_6').Position.X + 0*8, CH('Sableye_6').Position.Y + -32*8)
                CH('Sableye_6').Direction = Direction.Up
                GROUND:CharSetAnim(CH('Sableye_6'), 'Tumble', true) -- param 45 = anim 16 (Tumble)
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Necrozma'), 228, 768)
                GROUND:TeleportTo(CH('Necrozma'), CH('Necrozma').Position.X + 0*8, CH('Necrozma').Position.Y + 16*8)
                CH('Necrozma').Direction = Direction.Up
            end),
        })
        -- supervision_cting layer [8] (structurel)
        -- object 138 (p05p03a2) : contexte objet
        FutureScene.ObjectSetAnim('p05p03a2', 1, 0, 3, Direction.Down, 1) -- objet 138, anim 1 (table REQUISE)
        -- screen_FlushOut [1, 0, 8, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        -- screen2_FadeIn [0, 30] : couche décor (overlay scène, adaptation)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
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
        UI:WaitShowDialogue(' Hey!') -- FUT_M26A06D3_001 (FR optionnel)
        -- case 0: ' Hey!'
        -- case 1: ' Hey!'
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
        UI:WaitShowDialogue('(There\'s a break in the rope!)') -- FUT_M26A06D3_002 (FR optionnel)
        -- case 3: "(There's a break in the rope!)"
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
        UI:WaitShowDialogue(' Now!\n Attack!') -- FUT_M26A06D3_003 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(' Go!') -- FUT_M26A06D3_004 (FR optionnel)
        -- case 6: ' Go!'
        -- case 7: ' Go!'
        UI:ResetSpeaker()
        -- PARTIEL : se_FadeOut [7196, 30]
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
        UI:WaitShowDialogue(' Gwah!') -- FUT_M26A06D3_005 (FR optionnel)
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
        -- screen2_FadeOut [0, 30] : couche décor (overlay scène, adaptation)
        GAME:FadeOut(true, 30)
        -- screen_FlushIn [1, 0, 1, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m26a06d3] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m26a06d3
