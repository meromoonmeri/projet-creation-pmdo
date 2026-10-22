--[[
    P08P01A_t02a0303.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/t02a0303.ssb
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

local t02a0303 = {}

function t02a0303.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- back_SetGround(P08P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_1'), 224, 292)
                CH('Sableye_1').Direction = Direction.DownRight
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_2'), 276, 268)
                CH('Sableye_2').Direction = Direction.Down
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_3'), 332, 292)
                CH('Sableye_3').Direction = Direction.DownLeft
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_4'), 224, 348)
                CH('Sableye_4').Direction = Direction.UpRight
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_5'), 276, 372)
                CH('Sableye_5').Direction = Direction.Up
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Sableye_6'), 332, 348)
                CH('Sableye_6').Direction = Direction.UpLeft
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('HeroFuture'), 296, 308)
                CH('HeroFuture').Direction = Direction.Up
            end),
            TASK:BranchCoroutine(function()
                GROUND:TeleportTo(CH('Dusknoir'), 252, 340)
                CH('Dusknoir').Direction = Direction.Down
            end),
        })
        GAME:FadeIn(30)
        GROUND:CharSetAnim(CH('HeroFuture'), 'Walk', true) -- param 5 = anim 0 (Walk)
        GROUND:AnimateToPosition(CH('HeroFuture'), 276, 308, false, 2.0)
        GAME:WaitFrames(5)
        GROUND:CharSetAnim(CH('Dusknoir'), 'Walk', true) -- param 5 = anim 0 (Walk)
        GROUND:AnimateToPosition(CH('Dusknoir'), 276, 340, false, 2.0)
        -- SetAnimation 2 (spécial : boucle anim courante)
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Up, 15)
        -- SetAnimation 2 (spécial : boucle anim courante)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        GAME:WaitFrames(20)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Hop', false) -- param 17 = anim 10 (Hop)
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end),
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_1'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Hop', false) -- param 17 = anim 10 (Hop)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Hop', false) -- param 17 = anim 10 (Hop)
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
                GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) -- param 4 = anim 7 (Idle)
            end),
        })
        UI:ResetSpeaker()
        GROUND:CharSetAnim(CH('Sableye_1'), 'Attack', false) -- param 12 = anim 2 (Attack)
        GAME:WaitFrames(2)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_2'), 'Attack', false) -- param 12 = anim 2 (Attack)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_3'), 'Attack', false) -- param 12 = anim 2 (Attack)
            end),
        })
        GAME:WaitFrames(2)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_4'), 'Attack', false) -- param 12 = anim 2 (Attack)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetAnim(CH('Sableye_5'), 'Attack', false) -- param 12 = anim 2 (Attack)
            end),
        })
        GAME:WaitFrames(2)
        GROUND:CharSetAnim(CH('Sableye_6'), 'Attack', false) -- param 12 = anim 2 (Attack)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        GAME:WaitFrames(10)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        GAME:WaitFrames(10)
        GAME:FadeOut(false, 15)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[t02a0303] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return t02a0303
