-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D24P11A/m20a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treeshroud Forest.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 264, 368, Direction.Up, "NPC_JUPUTORU")
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, hero, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you all ready, [hero]?", french=" On y va, [hero]?", german="Bist du wirklich bereit,\n[hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Entramos ya, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On y va, [hero]?", german=" Bist du bereit, [hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Entramos ya, [hero]?"})
  else
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On y va, [hero]?", german=" Bist du bereit, [hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Entramos ya, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
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
  SkySceneKit.say({english="We'll be on our way when\nyou're ready.", french=" On part quand tu veux.", german="Wir machen uns auf den Weg,\nwenn du bereit bist.", italian="Quando siamo pronti, possiamo\navviarci.", spanish="Nos pondremos en marcha en\ncuanto quieras."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go as soon as you're ready.", french=" On part quand tu veux.", german="Lass uns gehen, wenn du bereit\nbist.", italian=" Appena è tutto pronto, andiamo.", spanish="Nos pondremos en marcha en\ncuanto quieras."})
  else
  SkySceneKit.say({english=" Let's leave when you're ready.", french=" On part quand tu veux.", german=" Gehen wir, wenn du bereit bist.", italian=" Appena è tutto pronto, partiamo.", spanish="Nos pondremos en marcha en\ncuanto quieras."})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. We're good to go!", french=" C'est bon, on peut y aller!", german=" Alles klar. Wir sind so weit!", italian="Va bene. Allora siamo pronti a\npartire!", spanish=" Muy bien. ¡Ya estamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK. We're good to go!", french=" C'est bon, on peut y aller!", german=" Okay. Wir sind so weit!", italian="Va bene. Allora siamo pronti a\npartire!", spanish=" Muy bien. ¡Ya estamos!"})
  else
  SkySceneKit.say({english=" OK. We're all set to go!", french=" C'est bon, on peut y aller!", german=" Okay. Wir sind bereit!", italian="Va bene. Allora è tutto pronto\nper la partenza!", spanish=" Muy bien. ¡Ya estamos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's get moving!", french=" En route!", german=" Legen wir los!", italian=" Andiamo!", spanish=" ¡En marcha!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's set off!", french=" En route!", german=" Ziehen wir los!", italian=" Mettiamoci in cammino!", spanish=" ¡En marcha!"})
  else
  SkySceneKit.say({english=" Let's get moving!", french=" En route!", german=" Legen wir los!", italian=" Muoviamoci!", spanish=" ¡En marcha!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 256, 76, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(partner, 256, 76, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_juputoru, 256, 76, false, 2)
  SkyProg.set(21, 2) -- $SCENARIO_MAIN = scn[21,2] (ROM)
  -- main_EnterDungeon(34, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  SkySceneKit.cleanup_npcs()
end
