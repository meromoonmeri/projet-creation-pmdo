-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D23P11A/m19b0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Deep Dusk Forest.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 224, 336, Direction.UpLeft, "NPC_JUPUTORU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 280, 312, Direction.Down, "NPC_SEREBII")
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you all ready to roll?", french=" Tu as fini tes préparatifs?", german=" Bist du bereit loszulegen?", italian=" Siete tutti pronti?", spanish=" ¿Podemos seguir ya?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you all ready?", french=" Tu as fini tes préparatifs?", german=" Bist du bereit?", italian=" Siete tutti pronti?", spanish=" ¿Podemos seguir ya?"})
  else
  SkySceneKit.say({english=" Are you all ready?", french=" Tu as fini tes préparatifs?", german=" Bist du bereit?", italian=" Siete tutti pronti?", spanish=" ¿Podemos seguir ya?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="Not yet", french="Pas encore", german="Noch nicht...", italian="Non ancora", spanish="Aún no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right.", french=" D'accord.", german=" Alles klar.", italian=" Va bene.", spanish=" De acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Ok.", spanish=" De acuerdo."})
  else
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Ok.", spanish=" De acuerdo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll go when you're ready.", french=" On part quand tu veux.", german=" Wir gehen, wenn du bereit bist.", italian=" Quando è tutto pronto partiamo.", spanish=" Nos iremos cuando quieras."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german="Lass uns gehen, wenn du bereit\nbist.", italian=" Quando è tutto pronto partiamo.", spanish=" Nos iremos cuando quieras."})
  else
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german="Lass uns gehen, wenn du bereit\nbist.", italian=" Quando è tutto pronto partiamo.", spanish=" Nos iremos cuando quieras."})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(48), 48, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_serebii, 292, 260, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 260, 260, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Good.[K] We're leaving.", french=" Très bien.[K] On y va.", german=" Gut.[K] Dann gehen wir jetzt.", italian=" Bene.[K] Partiamo.", spanish=" Muy bien.[K] Nos vamos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We must make our way to the\nPassage of Time.", french="Il faut nous mettre en route\npour le Couloir du Temps.", german="Wir müssen uns auf den Weg\nzum Zeittunnel machen.", italian="Dobbiamo farci strada verso il\nPortale del Tempo.", spanish="Tenemos que llegar hasta\nel Pasaje del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Let's go.", french=" C'est parti.", german=" Gehen wir.", italian=" Andiamo.", spanish=" Vamos allá."})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-80), false, 2) end
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-80), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-80), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_serebii.Position; GROUND:MoveToPosition(npc_npc_serebii, p.X+(0), p.Y+(-80), false, 2) end
  GAME:WaitFrames(10)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(33, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  SkySceneKit.cleanup_npcs()
end
