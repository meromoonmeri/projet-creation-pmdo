-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/s23p0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkyProg.set(29, 94) -- $SCENARIO_MAIN = scn[29,94] (ROM)
  -- back_SetGround(LEVEL_H01P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 472, 192, Direction.Left, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end) -- message_SetActor(ACTOR_NPC_PERAPPU)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hey! You two!", french=" Eh! Vous deux!", german=" Hey! Ihr beiden!", italian=" Ehi! Voi due!", spanish=" ¡Vaya! ¡Aquí estáis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_perappu, 336, 188, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Huff...puff...", french=" Pfff... pfff...", german=" Keuch, keuch...", italian=" Uff... puff...", spanish=" Uf... uf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What's up, [CS:N]Chatot[CR]?[K] What's the\nbig hurry?", french="Qu'est-ce qu'il y a, [CS:N]Pijako[CR]?[K]\nTu es tout essoufflé!", german="Was gibt es, [CS:N]Plaudagei[CR]?[K] Warum\ndie große Eile?", italian="Cosa succede, [CS:N]Chatot[CR]?[K] Perché\ntanta fretta?", spanish="¿Qué pasa, [CS:N]Chatot[CR]?[K] ¿A qué tanta\nprisa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What's the matter, [CS:N]Chatot[CR]?[K]\nWhat's the hurry?", french="Qu'est-ce qu'il y a, [CS:N]Pijako[CR]?[K]\nTu es tout essoufflé!", german="Was gibt es, [CS:N]Plaudagei[CR]?[K] Warum\nhast du es so eilig?", italian="Cosa succede, [CS:N]Chatot[CR]?[K] Perché\ntanta fretta?", spanish="¿Qué pasa, [CS:N]Chatot[CR]?[K] ¿A qué tanta\nprisa?"})
  else
  SkySceneKit.say({english="What's wrong, [CS:N]Chatot[CR]?[K]\nWhat's the big hurry?", french="Qu'est-ce qu'il y a, [CS:N]Pijako[CR]?[K]\nTu es tout essoufflé!", german="Was gibt es, [CS:N]Plaudagei[CR]?[K] Warum\nbeeilst du dich so?", italian="Cosa succede, [CS:N]Chatot[CR]?[K] Perché\ntanta fretta?", spanish="¿Qué pasa, [CS:N]Chatot[CR]?[K] ¿A qué tanta\nprisa?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Huff-huff...[K] The beach...[K]\nAt the beach...", french="Pfff pfff...[K] La plage...[K]\nSur la plage...", german="Keuch, hechel...[K] Der Strand...[K]\nAm Strand...", italian="Uff-uff...[K] La spiaggia...[K]\nAlla spiaggia...", spanish=" Uf...[K] La playa...[K] En la playa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is there something down at\nthe beach?", french=" Il y a un problème à la plage?", german="Ist da unten am Strand\nirgendetwas?", italian="Sta succedendo qualcosa\nalla spiaggia?", spanish=" ¿Hay algo en la playa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What's the matter with\nthe beach?", french=" Il y a un problème à la plage?", german=" Was ist mit dem Strand?", italian="Sta succedendo qualcosa\nalla spiaggia?", spanish=" ¿Qué pasa con la playa?"})
  else
  SkySceneKit.say({english="Is there something wrong with\nthe beach?", french=" Il y a un problème à la plage?", german="Stimmt etwas mit dem Strand\nnicht?", italian="Sta succedendo qualcosa\nalla spiaggia?", spanish=" ¿Hay algo en la playa?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]![K] [CS:N]Manaphy[CR] came back!", french=" [CS:N]Manaphy[CR]![K] [CS:N]Manaphy[CR] est revenu!", german=" [CS:N]Manaphy[CR]![K] [CS:N]Manaphy[CR] ist zurück!", italian=" [CS:N]Manaphy[CR]![K] [CS:N]Manaphy[CR] è tornato!", spanish=" ¡[CS:N]Manaphy[CR]![K] ¡[CS:N]Manaphy[CR] ha vuelto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] [CS:N]Manaphy[CR]...?", french=" Hein?![K] [CS:N]Manaphy[CR]...?", german=" Wie bitte?!?[K] [CS:N]Manaphy[CR]?", italian=" Eh?![K] [CS:N]Manaphy[CR]?", spanish=" ¡¿Qué?! [K]¿[CS:N]Manaphy[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] [CS:N]Manaphy[CR]...?", french=" Hein?![K] [CS:N]Manaphy[CR]...?", german=" Was?!?[K] [CS:N]Manaphy[CR]?", italian=" Cosa?![K] [CS:N]Manaphy[CR]?", spanish=" ¡¿Qué?! [K]¿[CS:N]Manaphy[CR]?"})
  else
  SkySceneKit.say({english=" What?![K] [CS:N]Manaphy[CR]...?", french=" Hein?![K] [CS:N]Manaphy[CR]...?", german=" Was?!?[K] [CS:N]Manaphy[CR]?", italian=" Cosa?![K] [CS:N]Manaphy[CR]?", spanish=" ¡¿Qué?! [K]¿[CS:N]Manaphy[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You mean the [CS:N]Manaphy[CR] we\nlooked after?!", french="Tu parles du [CS:N]Manaphy[CR] dont\non a pris soin?!", german="Du meinst das [CS:N]Manaphy[CR], auf das\nwir aufgepasst haben?!?", italian=" Intendi il nostro [CS:N]Manaphy[CR]?!", spanish="¿[CS:N]Manaphy[CR], el Pokémon que\nestuvimos cuidando?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You mean the [CS:N]Manaphy[CR] we\nlooked after?!", french="Tu parles du [CS:N]Manaphy[CR] dont\non a pris soin?!", german="Du meinst das [CS:N]Manaphy[CR], auf das\nwir aufgepasst haben?!?", italian=" Intendi il nostro [CS:N]Manaphy[CR]?!", spanish="¿[CS:N]Manaphy[CR], el Pokémon que\nestuvimos cuidando?"})
  else
  SkySceneKit.say({english="You mean the [CS:N]Manaphy[CR] we\nlooked after?!", french="Tu parles du [CS:N]Manaphy[CR] dont\non a pris soin?!", german="Du meinst das [CS:N]Manaphy[CR], auf das\nwir aufgepasst haben?!?", italian=" Intendi il nostro [CS:N]Manaphy[CR]?!", spanish="¿[CS:N]Manaphy[CR], el Pokémon que\nestuvimos cuidando?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That's him![K] That's the one!", french=" Oui, c'est ça![K] Lui-même!", german=" Genau dieses![K] Das ist es!", italian=" Sì![K] Proprio lui!", spanish=" ¡Es él![K] ¡El mismo!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hurry! To the beach!", french=" Vite, à la plage!", german=" Schnell! Ab zum Strand!", italian=" Forza! Alla spiaggia!", spanish=" ¡Deprisa! ¡A la playa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yeah!", french=" Oui! Dépêchons-nous!", german=" Jaaa!", italian=" Sì!", spanish=" ¡Sí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes!", french=" Oui! Dépêchons-nous!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  else
  SkySceneKit.say({english=" Yes!", french=" Oui! Dépêchons-nous!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  end
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(200), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(200), p.Y+(0), false, 2) end
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(200), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
