-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D35P41A/s03p1501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(53, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(29, 51) -- $SCENARIO_MAIN = scn[29,51] (ROM)
  -- back_SetGround(LEVEL_D35P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_fione1 = SkySceneKit.spawn_npc("phione", 352, 320, Direction.Up, "NPC_FIONE1")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione1, "happy", 1) end)
  local npc_npc_fione4 = SkySceneKit.spawn_npc("phione", 328, 296, Direction.Right, "NPC_FIONE4")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione4, "happy", 1) end)
  local npc_npc_fione7 = SkySceneKit.spawn_npc("phione", 352, 272, Direction.Down, "NPC_FIONE7")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione7, "happy", 1) end)
  local npc_npc_fione8 = SkySceneKit.spawn_npc("phione", 392, 280, Direction.DownLeft, "NPC_FIONE8")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione8, "happy", 1) end)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mystifying Forest.ogg", true) end)
  GROUND:MoveToPosition(hero, 348, 420, false, 2)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 372, 440, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 324, 436, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 348, 452, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(348, 324, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_fione1) end)
  SkySceneKit.say({english=" Hee-dee-dee! ♪", french=" Nya ha ha! ♪", german=" Hei-ti-tei! ♪", italian=" Eeh-dee-dee! ♪", spanish=" ¡Ji, ji, ji! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_fione1) end)
  SkySceneKit.say({english=" Tee-hee-dee! ♪", french=" Nyé hé hé! ♪", german=" Tei-tei-ti! ♪", italian=" Eeh-eeh-dee! ♪", spanish=" ¡Ji, ji, ji! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_fione1) end)
  SkySceneKit.say({english=" Glee! ♪", french=" Ti ti ti li ti! ♪", german=" Fro-ho! ♪", italian=" Glee! ♪", spanish=" ¡La, la, la! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_fione1) end)
  SkySceneKit.say({english=" Whee! ♪", french=" La la la! ♪", german=" Jo-ho! ♪", italian=" Whee! ♪", spanish=" ¡Laralá, laralá! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 348, 356, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 372, 376, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 324, 372, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 348, 388, false, 2) end end
  GAME:WaitFrames(30)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  SkySceneKit.say({english=" GRRAAAAAH!", french=" GRRAAAAAH!", german=" GRRAAAAAH!", italian=" GRRAAAAAH!", spanish=" ¡AAAAAH!"}) -- message_ImitationSound (onomatopée)
  pcall(function() GROUND:CharSetEmote(npc_npc_fione1, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_fione4, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_fione7, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_fione8, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_fione1, "exclaim", 1) end)
  local npc_npc_fione2 = SkySceneKit.spawn_npc("phione", 320, 312, Direction.Right, "NPC_FIONE2")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione2, "shock", 1) end)
  local npc_npc_fione3 = SkySceneKit.spawn_npc("phione", 384, 312, Direction.UpLeft, "NPC_FIONE3")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione3, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_fione4, "shock", 1) end)
  local npc_npc_fione5 = SkySceneKit.spawn_npc("phione", 376, 296, Direction.Left, "NPC_FIONE5")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione5, "exclaim", 1) end)
  local npc_npc_fione6 = SkySceneKit.spawn_npc("phione", 312, 280, Direction.DownRight, "NPC_FIONE6")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione6, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_fione7, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_fione8, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GROUND:EntTurn(npc_npc_fione1, Direction.Right)
  GROUND:EntTurn(npc_npc_fione2, Direction.Right)
  GROUND:EntTurn(npc_npc_fione3, Direction.Right)
  GROUND:EntTurn(npc_npc_fione4, Direction.Right)
  GROUND:EntTurn(npc_npc_fione5, Direction.Right)
  GROUND:EntTurn(npc_npc_fione6, Direction.Right)
  GROUND:EntTurn(npc_npc_fione7, Direction.Right)
  GROUND:EntTurn(npc_npc_fione8, Direction.Right)
  GROUND:EntTurn(hero, Direction.UpRight)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  local npc_npc_gyaradosu = SkySceneKit.spawn_npc("gyarados", 592, 320, Direction.Left, "NPC_GYARADOSU")
  GROUND:MoveToPosition(npc_npc_gyaradosu, 348, 316, false, 2)
  GAME:WaitFrames(60)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  do local p=npc_npc_fione1.Position; GROUND:MoveToPosition(npc_npc_fione1, p.X+(0), p.Y+(-64), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione2.Position; GROUND:MoveToPosition(npc_npc_fione2, p.X+(-64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione3.Position; GROUND:MoveToPosition(npc_npc_fione3, p.X+(64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione4.Position; GROUND:MoveToPosition(npc_npc_fione4, p.X+(-64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione5.Position; GROUND:MoveToPosition(npc_npc_fione5, p.X+(64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione6.Position; GROUND:MoveToPosition(npc_npc_fione6, p.X+(-64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione7.Position; GROUND:MoveToPosition(npc_npc_fione7, p.X+(0), p.Y+(-64), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione8.Position; GROUND:MoveToPosition(npc_npc_fione8, p.X+(64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  GROUND:EntTurn(hero, Direction.Up)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  pcall(function() UI:SetSpeaker(npc_npc_fione1) end)
  SkySceneKit.say({english=" Eeeeek!", french=" Hiiiii!", german=" Ieeek!", italian=" Eeeeek!", spanish=" ¡Huy, huy!"})
  GROUND:EntTurn(npc_npc_fione1, Direction.Down)
  GROUND:EntTurn(npc_npc_fione2, Direction.DownRight)
  GROUND:EntTurn(npc_npc_fione3, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_fione4, Direction.DownRight)
  GROUND:EntTurn(npc_npc_fione5, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_fione6, Direction.DownRight)
  GROUND:EntTurn(npc_npc_fione7, Direction.Down)
  GROUND:EntTurn(npc_npc_fione8, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_gyaradosu, Direction.Up)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_gyaradosu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english="GRRAH-HA-HA! I FOUND YOU\nAT LAST!", french="GRRAH HA HA! JE VOUS AI\nENFIN TROUVES!", german="GRRAH-HA-HA! ICH HABE EUCH\nENDLICH GEFUNDEN!", italian="GRRAH-HA-HA! FINALMENTE VI\nHO TROVATO!", spanish="¡JA, JA, JA!\n¡OS HE ENCONTRADO!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_gyaradosu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english="YOU'RE THE [CS:N]PHIONE[CR], RIGHT?\nYOU MAKE THE CURE-ALL? PHIONE DEW?", french="VOUS ETES LES [CS:N]PHIONE[CR],\nN'EST-CE PAS? C'EST VOUS QUI FABRIQUEZ\nCE REMEDE? LA ROSEE PHIONE?", german="IHR SEID DIE [CS:N]PHIONE[CR], RICHTIG?\nSTELLT IHR DAS ALLHEILMITTEL HER?\nPHIONE-TAU?", italian="SIETE I POKÉMON CHIAMATI\n[CS:N]PHIONE[CR], GIUSTO? PRODUCETE LA BRINA\nPHIONE CHE CURA QUALSIASI MALATTIA?", spanish="SOIS LAS HADAS [CS:N]PHIONE[CR],\n¿VERDAD? ¿VOSOTRAS HACÉIS ESE\nCURALOTODO? ¿EL ROCÍO PHIONE?"})
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english="WELL, REJOICE![K] FROM NOW ON,\nYOU ALL ANSWER TO ME!", french="REJOUISSEZ-VOUS![K] DESORMAIS,\nVOUS ETES SOUS MES ORDRES!", german="GRUND ZUM JUBELN![K] AB JETZT\nGEHORCHT IHR NUR MIR!", italian="BEH, GIOITE![K] D'ORA IN POI,\nIO SONO IL VOSTRO CAPO!", spanish="¡REGOCIJAOS![K] A PARTIR DE\nAHORA, ¡ME RENDIRÉIS CUENTAS A MÍ!"})
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english="ALL PHIONE DEW BELONGS TO\nME FROM NOW ON! GRRAH-HA-HA!", french="TOUTE LA ROSEE PHIONE\nM'APPARTIENT MAINTENANT! LE MONDE SERA\nA MOI, ET A MOI TOUT SEUL! GRRAH HA HA!", german="ALL DER PHIONE-TAU GEHÖRT\nAB JETZT MIR! GRRAH-HA-HA!", italian="DA ADESSO IN AVANTI, TUTTA\nLA BRINA PHIONE APPARTIENE A ME!\nGRRAH-HA-HA!", spanish="¡EL ROCÍO PHIONE SERÁ TODO\nMÍO! ¡JA, JA, JA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(5)
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(-8), false, 2) end
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(5)
  do local p=SkySceneKit.team_member(3).Position; GROUND:MoveToPosition(SkySceneKit.team_member(3), p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_gyaradosu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(24), 24, false) end) -- MovePositionOffset performer/caméra
  GROUND:EntTurn(npc_npc_gyaradosu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english=" OH?[K] NOW WHO MIGHT YOU BE?", french=" OH?[K] ET VOUS, QUI ETES-VOUS?", german=" WAS?[K] WER SEID IHR DENN?", italian=" OH?[K] E VOI CHI SARESTE?", spanish="¿EH?[K]\n¿QUIÉN OSA MOLESTARME?"})
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english="OH?[K] YOU LOOK LIKE YOU HAVE A\nBONE TO PICK WITH ME...", french="OH?[K] J'AI LA NETTE IMPRESSION\nQUE VOUS AVEZ UNE DENT CONTRE MOI...", german="NANU?[K] IHR SEHT AUS, ALS\nHÄTTET IHR MIT MIR EIN HÜHNCHEN ZU\nRUPFEN...", italian="OH?[K] AVETE QUALCOSA IN\nCONTRARIO?", spanish=" ¿EH?[K] ¿CONQUE UN RETO?"})
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english="GRAH-HA-HA! YOU'RE ABOUT A\nMILLION YEARS TOO EARLY TO PICK A\nFIGHT WITH ME!", french="GRAH HA HA! VOUS ETES DIX\nMILLE ANS TROP JEUNES POUR ME CAUSER\nLA MOINDRE EGRATIGNURE!", german="GRAH-HA-HA! IHR SEID\nUNGEFÄHR EINE MILLION JAHRE ZU FRÜH, UM\nDEN KAMPF MIT MIR ZU SUCHEN!", italian="GRAH-HA-HA! SIETE IN\nANTICIPO DI CIRCA UN MILIONE DI ANNI\nPER PRENDERVELA CON ME!", spanish="¡JA, JA, JA! ¡ESTOY A AÑOS\nLUZ DE CUALQUIERA!"})
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english="YOU'LL REGRET NOT RUNNING\nAWAY WHILE YOU COULD!", french="VOUS ALLEZ REGRETTER\nDE NE PAS AVOIR FILE QUAND VOUS EN\nAVIEZ ENCORE L'OCCASION!", german="IHR WERDET BALD BEREUEN,\nNICHT WEGGELAUFEN ZU SEIN, ALS IHR ES\nNOCH KONNTET.", italian="VI PENTIRETE DI NON ESSERVELA\nDATA A GAMBE FINCHÉ POTEVATE!", spanish="¡TODO AQUEL QUE SE ENFRENTA\nA MÍ ACABA ARREPINTIÉNDOSE DE NO HABER\nHUIDO CUANDO TUVO LA OPORTUNIDAD!"})
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english=" NO MERCY FOR MEDDLERS!", french="VOUS AURIEZ DU PASSER VOTRE\nCHEMIN! PAS DE PITIE POUR LES PASSANTS!", german="DAS EINMISCHEN WIRD\nUNBARMHERZIG BESTRAFT!", italian="NESSUNA PIETÀ PER CHI SI\nINTROMETTE!", spanish="¡NO TENGO PIEDAD CON\nLOS ENTROMETIDOS!"})
  -- message_KeyWait
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(18) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english=" GRRAAAAHH!", french=" GRRAAAAHH!", german=" GRRAAAAHH!", italian=" GRRAAAAHH!", spanish=" ¡AAAH!"})
  do local p=npc_npc_fione1.Position; GROUND:MoveToPosition(npc_npc_fione1, p.X+(0), p.Y+(-64), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione2.Position; GROUND:MoveToPosition(npc_npc_fione2, p.X+(-64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione3.Position; GROUND:MoveToPosition(npc_npc_fione3, p.X+(64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione4.Position; GROUND:MoveToPosition(npc_npc_fione4, p.X+(-64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione5.Position; GROUND:MoveToPosition(npc_npc_fione5, p.X+(64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione6.Position; GROUND:MoveToPosition(npc_npc_fione6, p.X+(-64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione7.Position; GROUND:MoveToPosition(npc_npc_fione7, p.X+(0), p.Y+(-64), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione8.Position; GROUND:MoveToPosition(npc_npc_fione8, p.X+(64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
