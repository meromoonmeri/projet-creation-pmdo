-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D06P11A/m08a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Craggy Coast.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 392, 256, Direction.Left, "NPC_BIPPA")
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" C'est bon, [hero]?", german=" Bist du bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" C'est bon, [hero]?", german=" Bist du bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  else
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" C'est bon, [hero]?", german=" Bist du bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="All set!", french="C'est bon!", german="Alles klar!", italian="Tutto pronto!", spanish="¡Claro!"}, {english="Not yet...", french="Pas encore...", german="Noch nicht...", italian="Non ancora...", spanish="Espera un poco"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right. We'll go when\nyou're ready.", french="On part dès que tout le monde\nest prêt.", german="In Ordnung. Wir gehen, wenn du\nbereit bist.", italian="Va bene. Partiremo quando sarà\ntutto pronto.", spanish="Vale. Seguiremos\ncuando quieras."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="All right. We'll go when\nyou're ready.", french="On part dès que tout le monde\nest prêt.", german="In Ordnung. Wir gehen, wenn du\nbereit bist.", italian="Va bene. Partiremo quando sarà\ntutto pronto.", spanish="Muy bien. Seguiremos\ncuando quieras."})
  else
  SkySceneKit.say({english="All right. We'll go when\nyou're ready.", french="On part dès que tout le monde\nest prêt.", german="In Ordnung. Wir gehen, wenn du\nbereit bist.", italian="Va bene. Partiremo quando sarà\ntutto pronto.", spanish="Muy bien. Seguiremos\ncuando quieras."})
  end
  -- message_Close
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte dobbiamo andare?", spanish=" ¿Por dónde vamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte dobbiamo andare?", spanish=" ¿Por dónde vamos?"})
  else
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte dobbiamo andare?", spanish=" ¿Por dónde vamos?"})
  end
  do local __choice = SkySceneKit.ask({{english="[CS:P]Craggy Coast[CR]", french="Par la [CS:P]Côte Escarpée[CR]", german="[CS:P]Schroffküste[CR]", italian="[CS:P]Dirupo Costiero[CR]", spanish="[CS:P]Costa Escarpada[CR]"}, {english="[CS:P]Side Path[CR]", french="Par le [CS:P]Chemin Lisière[CR]", german="[CS:P]Schleichpfad[CR]", italian="[CS:P]Sentiero Scosceso[CR]", spanish="[CS:P]Paso Flanco[CR]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. [CS:P]Side Path[CR] it is.", french="D'accord. Passons par le\n[CS:P]Chemin Lisière[CR].", german="Okay. Wir nehmen den\n[CS:P]Schleichpfad[CR].", italian="Va bene. Andiamo verso il\n[CS:P]Sentiero Scosceso[CR].", spanish=" Muy bien. ¡Al [CS:P]Paso Flanco[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK. [CS:P]Side Path[CR] it is.", french="D'accord. Passons par le\n[CS:P]Chemin Lisière[CR].", german="Okay. Wir nehmen den\n[CS:P]Schleichpfad[CR].", italian="Va bene. Andiamo verso il\n[CS:P]Sentiero Scosceso[CR].", spanish=" Muy bien. ¡Al [CS:P]Paso Flanco[CR]!"})
  else
  SkySceneKit.say({english=" OK. [CS:P]Side Path[CR] it is.", french="D'accord. Passons par le\n[CS:P]Chemin Lisière[CR].", german="Okay. Wir nehmen den\n[CS:P]Schleichpfad[CR].", italian="Va bene. Andiamo verso il\n[CS:P]Sentiero Scosceso[CR].", spanish=" Muy bien. ¡Al [CS:P]Paso Flanco[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  GROUND:MoveToPosition(partner, 344, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 376, 224, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allez! En avant!", german=" Abgemacht! Gehen wir es an!", italian=" Forza! Muoviamoci!", spanish=" ¡Muy bien! ¡Adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allez! En avant!", german=" Abgemacht! Gehen wir es an!", italian=" Forza! Muoviamoci!", spanish=" ¡Muy bien! ¡Adelante!"})
  else
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allez! En avant!", german=" Abgemacht! Gehen wir es an!", italian=" Forza! Muoviamoci!", spanish=" ¡Muy bien! ¡Adelante!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 364, 172, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 364, 172, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_bippa, 364, 172, false, 2)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(9, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. [CS:P]Craggy Coast[CR] it is.", french="D'accord. Passons par la\n[CS:P]Côte Escarpée[CR].", german="Okay. Wir gehen über die\n[CS:P]Schroffküste[CR].", italian="D'accordo. Andiamo verso il\n[CS:P]Dirupo Costiero[CR].", spanish=" Muy bien. ¡A la [CS:P]Costa Escarpada[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK. [CS:P]Craggy Coast[CR] it is.", french="D'accord. Passons par la\n[CS:P]Côte Escarpée[CR].", german="Okay. Wir gehen über die\n[CS:P]Schroffküste[CR].", italian="D'accordo. Andiamo verso il\n[CS:P]Dirupo Costiero[CR].", spanish=" Muy bien. ¡A la [CS:P]Costa Escarpada[CR]!"})
  else
  SkySceneKit.say({english=" OK. [CS:P]Craggy Coast[CR] it is.", french="D'accord. Passons par la\n[CS:P]Côte Escarpée[CR].", german="Okay. Wir gehen über die\n[CS:P]Schroffküste[CR].", italian="D'accordo. Andiamo verso il\n[CS:P]Dirupo Costiero[CR].", spanish=" Muy bien. ¡A la [CS:P]Costa Escarpada[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  GROUND:MoveToPosition(partner, 344, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 376, 224, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allez! En avant!", german=" Abgemacht! Gehen wir es an!", italian=" Forza! Muoviamoci!", spanish=" ¡Muy bien! ¡Adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allez! En avant!", german=" Abgemacht! Gehen wir es an!", italian=" Forza! Muoviamoci!", spanish=" ¡Muy bien! ¡Adelante!"})
  else
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allez! En avant!", german=" Abgemacht! Gehen wir es an!", italian=" Forza! Muoviamoci!", spanish=" ¡Muy bien! ¡Adelante!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 364, 172, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 364, 172, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_bippa, 364, 172, false, 2)
  -- main_EnterDungeon(8, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
