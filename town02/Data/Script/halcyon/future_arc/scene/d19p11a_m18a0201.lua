--[[
    D19P11A_m18a0201.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D19P11A/m18a0201.ssb
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

local m18a0201 = {}

function m18a0201.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
            end),
            TASK:BranchCoroutine(function()
                -- SetAnimation 2 (spécial : boucle anim courante)
                GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
            end),
        })
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Hé, [hero]. Tout est prêt ?') -- FUT_M18A0201_001 (FR)
        -- case 0: ' Hey, [hero]. Are you\nall ready?'
        -- case 1: ' Hey, [hero].\nAre you ready?'
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('D\'accord ! Allons-y !') -- FUT_M18A0201_002 (FR)
        UI:SetCenter(false)
        -- case 5: " All right![K] Let's roll on out!"
        -- case 6: " OK![K] Let's go!"
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 80*8, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 80*8, false, 2.0)
        GAME:WaitFrames(15)
        GAME:FadeOut(false, 30)
        -- main_EnterDungeon(28) : entrée donjon (mapping id REQUIS)
        -- NON CONVERTI : message_Menu [54]
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- End : fin de scène
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue('On y va quand tu seras prêt.') -- FUT_M18A0201_003 (FR)
        UI:SetCenter(false)
        -- case 8: " We'll go when you're ready."
        -- case 9: " Let's go when you're ready."
        UI:SetCenter(true)
        UI:WaitShowDialogue('Partons avant que les Ténéfix nous rattrapent.') -- FUT_M18A0201_004 (FR)
        UI:SetCenter(false)
        -- case 11: " Let's go before those [CS:N]Sableye[CR]\ncatch up."
        -- case 12: ' We need to go before those\n[CS:N]Sableye[CR] catch up.'
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m18a0201] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m18a0201
