-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D27P11A/m24a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Land.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 264, 344, Direction.DownRight, "NPC_JUPUTORU")
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [hero]. Are you all\nready?", french=" Eh, [hero]. On y va?", german="Hey, [hero]. Bist du\nbereit?", italian="Ehi, [hero]. È tutto\npronto?", spanish="Oye, [hero]...\n¿Estamos listos para seguir?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hi, [hero]. Are you\nready?", french=" Eh, [hero]. On y va?", german="Hey, [hero]. Bist du\nbereit?", italian="Ehi, [hero]. È tutto\npronto?", spanish="Oye, [hero]...\n¿Estamos listos para seguir?"})
  else
  SkySceneKit.say({english="Hi, [hero]. Are you\nready?", french=" Eh, [hero]. On y va?", german="Hey, [hero]. Bist du\nbereit?", italian="Ehi, [hero]. È tutto\npronto?", spanish="Oye, [hero]...\n¿Todo listo para seguir?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="Not yet", french="Pas encore", german="Noch nicht...", italian="Non ancora", spanish="Aún no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right.", french=" Entendu.", german=" Alles klar.", italian=" Va bene.", spanish=" De acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK.", french=" Entendu.", german=" Okay.", italian=" Ok.", spanish=" De acuerdo."})
  else
  SkySceneKit.say({english=" OK.", french=" Entendu.", german=" Okay.", italian=" Ok.", spanish=" De acuerdo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll go when you're ready.", french=" On part quand tu veux.", german=" Wir gehen, wenn du bereit bist.", italian=" Quando è tutto pronto, andiamo.", spanish=" Nos iremos cuando quieras."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german=" Wir gehen, wenn du bereit bist.", italian=" Quando è tutto pronto, partiamo.", spanish=" Nos iremos cuando quieras."})
  else
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german=" Wir gehen, wenn du bereit bist.", italian=" Quando è tutto pronto, partiamo.", spanish=" Nos iremos cuando quieras."})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup! Looks like we're all set.", french="D'accord! On dirait qu'on peut\npartir.", german="Jep! Sieht aus, als wären wir\nstartklar.", italian="Sì! Sembra che siamo pronti\na partire.", spanish=" ¡Sí! Parece que estamos listos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes. Looks like we're ready.", french="D'accord! On dirait qu'on peut\npartir.", german=" Jep. Wir sind wohl bereit.", italian=" Bene, sembra che siamo pronti.", spanish=" ¡Sí! Parece que estamos listos."})
  else
  SkySceneKit.say({english=" Yep! I guess we're ready to go.", french="D'accord! On dirait qu'on peut\npartir.", german="Jep! Ich denke, wir können\ngehen.", italian="Sì! Sembra che possiamo\npartire.", spanish=" ¡Sí! Parece que está todo listo."})
  end
  -- message_Close
  GROUND:TeleportTo(npc_npc_juputoru, 228, 300, Direction.Down)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GROUND:MoveToPosition(npc_npc_juputoru, 228, 216, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Parfait! On bouge!", german="Alles klar! Setzen wir uns in\nBewegung!", italian=" Va bene! Mettiamoci in marcia!", spanish=" ¡Vamos allá! ¡Adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Let's go!", french=" Parfait! On bouge!", german=" Okay! Gehen wir!", italian=" Ok! Si parte!", spanish=" ¡Vamos allá! ¡Adelante!"})
  else
  SkySceneKit.say({english=" OK! Let's go!", french=" Parfait! On bouge!", german=" Okay! Gehen wir!", italian=" Ok! Si parte!", spanish=" ¡Vamos allá! ¡Adelante!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 228, 68, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 228, 68, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_juputoru, 228, 68, false, 2)
  if (SkyProg.cmp(25, 2) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [25, 2]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(38, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(25, 2) -- $SCENARIO_MAIN = scn[25,2] (ROM)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
