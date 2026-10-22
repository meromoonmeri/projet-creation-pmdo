--[[
    D55P21A_enter05.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D55P21A/enter05.ssb
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

local enter05 = {}

function enter05.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- Switch (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- Case (structurel)
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 2, 54]
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' It seems like nobody\'s found the\ntreasure yet...') -- FUT_ENTER05_001 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Happy')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' When that\'s the situation, we\nget more excited. ♪') -- FUT_ENTER05_002 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s find more treasure. ♪') -- FUT_ENTER05_003 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' It seems like nobody\'s found the\ntreasure yet...') -- FUT_ENTER05_004 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Happy')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' When that\'s the situation, we\nget more excited. ♪') -- FUT_ENTER05_005 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Let\'s find more treasure. ♪') -- FUT_ENTER05_006 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 7, 148]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 4, 121]
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        GAME:WaitFrames(1)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Angry')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Hey! No way can I forgive them!') -- FUT_ENTER05_007 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I\'ll defeat them next time\nthey come into my sight!') -- FUT_ENTER05_008 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Lopunny and Gardevoir\nsay so, but...') -- FUT_ENTER05_009 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I...I am so nervous...') -- FUT_ENTER05_010 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Worried')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Why is this?\n Is it because I\'m\nmad at Team AWD?') -- FUT_ENTER05_011 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'ll get through next time!') -- FUT_ENTER05_012 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 7, 197]
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' After this, it\'s the real deal!') -- FUT_ENTER05_013 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Happy')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I love this type of tension!\n\nIt\'s so exciting! ♪') -- FUT_ENTER05_014 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'ll get those Aggron!') -- FUT_ENTER05_015 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We won\'t lose!') -- FUT_ENTER05_016 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'ll definitely get through!') -- FUT_ENTER05_017 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 13, 422]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 10, 403]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 9, 384]
        -- NON CONVERTI : BranchBit [14, 2, 353]
        -- NON CONVERTI : BranchBit [14, 0, 315]
        -- NON CONVERTI : BranchBit [14, 1, 334]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 8, 296]
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I think the one on the right\nis the correct path.') -- FUT_ENTER05_018 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' No!\n Maybe they just want you to\nthink that! Maybe it\'s really the one on\nthe left!') -- FUT_ENTER05_019 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Worried')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Hmm...\n Which one is it...\nreally...?\n Hmm...') -- FUT_ENTER05_020 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'ll get through this time!') -- FUT_ENTER05_021 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'ll get through this time!') -- FUT_ENTER05_022 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'ll get through this time!') -- FUT_ENTER05_023 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        GAME:WaitFrames(1)
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Angry')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'re almost there!\n Aargh!') -- FUT_ENTER05_024 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- NON CONVERTI : SetEffect (acteur NPC_CHAAREMU)
        -- NON CONVERTI : WaitEffect (acteur NPC_CHAAREMU)
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Come on, let\'s hurry!\n\nThrough the wall, between the two paths!') -- FUT_ENTER05_025 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'ll get through this time!') -- FUT_ENTER05_026 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' The next time we meet Team\nAWD, we\'re going to knock them out!') -- FUT_ENTER05_027 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We\'ll definitely win next time!') -- FUT_ENTER05_028 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 13, 503]
        -- NON CONVERTI : BranchScenarioNowAfter [4, 45, 12, 478]
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Speaking of... \nWhat is Team\nAWD up to now?') -- FUT_ENTER05_029 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I wonder where they are now...') -- FUT_ENTER05_030 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Never mind.\n Instead of worrying\nabout them, I should be worrying about us!') -- FUT_ENTER05_031 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Lopunny!\n Let\'s find some\ntreasure this time!') -- FUT_ENTER05_032 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Speaking of...\n What is Team\nAWD up to now?') -- FUT_ENTER05_033 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I wonder where they are now...') -- FUT_ENTER05_034 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Never mind.\n Instead of worrying\nabout them, I should be worrying about us!') -- FUT_ENTER05_035 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Lopunny!\n Let\'s find some\ntreasure this time!') -- FUT_ENTER05_036 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        -- ExecuteCommon(LIVES_REPLY_NORMAL) : gestuelle parallèle à implémenter
        UI:ResetSpeaker()
        GeneralFunctions.SetEmotion('Normal')
        UI:SetCenter(true)
        UI:WaitShowDialogue(' The next time we meet Team\nAWD, we\'re going to knock them out!') -- FUT_ENTER05_037 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Next time, we\'ll definitely win!') -- FUT_ENTER05_038 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- Jump (structurel)
        -- JumpCommon(END_TALK) : helper à implémenter (comme CallCommon)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[enter05] scène interrompue : '..tostring(err)) end
end

return enter05
