--[[
    D22P11A_m19a0201.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D22P11A/m19a0201.ssb
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

local m19a0201 = {}

function m19a0201.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- back_SetGround(D22P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- NON CONVERTI : supervision_LoadStation [50, 0]
        -- NON CONVERTI : supervision_Station [1]
        -- supervision_cting layer [0] (structurel)
        -- NON CONVERTI : SetPositionInitial []
        -- SetAnimation 2 (spécial : boucle anim courante)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Grovyle'), 276, 228, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('Teammate1'), 260, 260, false, 2.0)
            end),
            TASK:BranchCoroutine(function()
                GROUND:MoveToPosition(CH('PLAYER'), 292, 260, false, 2.0)
            end),
        })
        GAME:WaitFrames(15)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(...!)') -- FUT_M19A0201_001 (FR)
        -- case 1: '(...!)'
        UI:WaitShowDialogue('(Qu-qu\'est-ce que... ?)') -- FUT_M19A0201_002 (FR)
        -- case 3: '(Wh-what...?)'
        UI:WaitShowDialogue('(Quelle était cette... étrange sensation ?)') -- FUT_M19A0201_003 (FR)
        -- case 5: '(What was that...[K]strange sensation?)'
        UI:WaitShowDialogue('(J\'ai déjà éprouvé cette étrange sensation...)') -- FUT_M19A0201_004 (FR)
        -- case 7: "(I've had that strange sensation before...)"
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Où... Où sommes-nous ?') -- FUT_M19A0201_005 (FR)
        -- case 9: ' Where...[K] Where are we?'
        -- case 10: ' Where...[K] Where are we?'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Voici la Forêt Crépuscule. Son nom vient du sombre brouillard qui la recouvre en permanence.') -- FUT_M19A0201_006 (FR)
        UI:WaitShowDialogue('Au fond de cette forêt...') -- FUT_M19A0201_007 (FR)
        UI:WaitShowDialogue('Nous devrions trouver Celebi.') -- FUT_M19A0201_008 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('Hé, Massko. Tu as déjà cité ce nom, mais...') -- FUT_M19A0201_009 (FR)
        -- case 15: ' Hey, [CS:N]Grovyle[CR].[K] You mentioned\nthe name before, but...'
        -- case 16: ' Hey, [CS:N]Grovyle[CR].[K] You mentioned\nthe name before, but...'
        UI:WaitShowDialogue('Qui est Celebi ?') -- FUT_M19A0201_010 (FR)
        -- case 18: ' Who is [CS:N]Celebi[CR]?'
        -- case 19: ' Who is [CS:N]Celebi[CR]?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Celebi est le légendaire Pokémon Temporel.') -- FUT_M19A0201_011 (FR)
        UI:WaitShowDialogue('Elle a la capacité de traverser le temps.') -- FUT_M19A0201_012 (FR)
        UI:WaitShowDialogue('Mais... elle est un peu étrange...') -- FUT_M19A0201_013 (FR)
        UI:WaitShowDialogue('Quoi qu\'il en soit... C\'est grâce au pouvoir de Celebi que j\'ai pu remonter dans le passé.') -- FUT_M19A0201_014 (FR)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Donc si nous trouvons Celebi...') -- FUT_M19A0201_015 (FR)
        -- case 25: ' So if we find [CS:N]Celebi[CR]...'
        -- case 26: ' So if we find [CS:N]Celebi[CR]...'
        UI:WaitShowDialogue('Ça veut dire qu\'on peut retourner dans notre monde ?') -- FUT_M19A0201_016 (FR)
        -- case 28: ' Does that mean we can get back\nto our world?'
        -- case 29: ' Can we return to our world?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('Oui, vous pourrez rentrer. Mais...') -- FUT_M19A0201_017 (FR)
        UI:WaitShowDialogue('C\'est Celebi qui m\'a envoyé dans le passé.') -- FUT_M19A0201_018 (FR)
        UI:WaitShowDialogue('Cela signifie que Celebi m\'a aidé à modifier le cours de l\'histoire.') -- FUT_M19A0201_019 (FR)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end),
            TASK:BranchCoroutine(function()
                GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end),
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue('Attends... Ça veut dire que Celebi a elle aussi des ennuis ?') -- FUT_M19A0201_020 (FR)
        -- case 34: " Wait a second...[K] Does that mean\n[CS:N]Celebi[CR]'s in trouble too?"
        -- case 35: " Wait...[K] Are you saying that\n[CS:N]Celebi[CR]'s in trouble too?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('C\'est vrai. Primal Necrozma vise également Celebi.') -- FUT_M19A0201_021 (FR)
        UI:WaitShowDialogue('Donc il n\'y a pas de temps à perdre.') -- FUT_M19A0201_022 (FR)
        UI:WaitShowDialogue('Préparez-vous sans tarder. Nous devons trouver Celebi.') -- FUT_M19A0201_023 (FR)
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then
    pcall(function() UI:SetCenter(false) end)
    pcall(function() GAME:FadeIn(1) end)
    pcall(function() GAME:CutsceneMode(false) end)
    PrintInfo('[m19a0201] scène interrompue : '..tostring(err))
  end
  return ok, err
end

return m19a0201
