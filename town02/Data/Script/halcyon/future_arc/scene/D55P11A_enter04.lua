--[[
    D55P11A_enter04.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P11A/enter04.ssb
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

local enter04 = {}

function enter04.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- Switch (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 2, 48]
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' On the other side of this jungle\nis Boulder Quarry.') -- FUT_ENTER04_001 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s hurry up and get ready so\nwe can go.') -- FUT_ENTER04_002 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' On the other side of this jungle\nis Boulder Quarry.') -- FUT_ENTER04_003 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Get ready so we can go.') -- FUT_ENTER04_004 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 7, 121]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 4, 100]
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Team AWD is already on its\nway there.') -- FUT_ENTER04_005 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We should hurry up and get\nready so we can catch up.') -- FUT_ENTER04_006 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s take our time and not rush\nthrough things.') -- FUT_ENTER04_007 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s get ready, Lopunny.') -- FUT_ENTER04_008 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We can\'t take our time.\nWe\'ve got things to do.') -- FUT_ENTER04_009 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I\'m curious how far ahead of us\nTeam AWD is...') -- FUT_ENTER04_010 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 7, 194]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 6, 173]
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s proceed with caution,\nLopunny.') -- FUT_ENTER04_011 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We might run into Team AWD\nsomewhere out here.') -- FUT_ENTER04_012 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s proceed with caution,\nLopunny.') -- FUT_ENTER04_013 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We might run into Team AWD\nsomewhere out here.') -- FUT_ENTER04_014 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' It\'s too bad that we\'ll have to \npass through Aggron\'s territory again, but...') -- FUT_ENTER04_015 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' In order to get ahead...\n We just\nhave to get over there.') -- FUT_ENTER04_016 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 13, 384]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 10, 365]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 9, 344]
        -- NON CONVERTI : BranchBit [14, 2, 323]
        -- NON CONVERTI : BranchBit [14, 0, 285]
        -- NON CONVERTI : BranchBit [14, 1, 304]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 8, 266]
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I guess we\'ll have to pick\nan entrance and see.') -- FUT_ENTER04_017 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s try again.') -- FUT_ENTER04_018 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s try the one on the left\nthis time.') -- FUT_ENTER04_019 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s try the one on the right\nthis time.') -- FUT_ENTER04_020 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' No more telling jokes to\nMedicham.') -- FUT_ENTER04_021 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s really do it this time.') -- FUT_ENTER04_022 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' It couldn\'t be that the wall\nbetween the two entrances is...') -- FUT_ENTER04_023 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Maybe it\'s a hidden doorway!') -- FUT_ENTER04_024 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s try again!\n\nInto that wall!') -- FUT_ENTER04_025 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' It looks like we can get to the\ncavern by going through the wall between the\ntwo entrances.') -- FUT_ENTER04_026 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Once you\'re ready, let\'s get\ngoing.') -- FUT_ENTER04_027 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 13, 429]
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We should be more cautious\nfrom here on, Lopunny.') -- FUT_ENTER04_028 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s try and head deeper again.') -- FUT_ENTER04_029 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We need to locate where the\ntreasure is.') -- FUT_ENTER04_030 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- JumpCommon(END_TALK) : helper à implémenter (comme CallCommon)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[enter04] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return enter04
