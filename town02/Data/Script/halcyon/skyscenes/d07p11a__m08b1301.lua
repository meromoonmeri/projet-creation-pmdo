-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D07P11A/m08b1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Mt. Horn.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 328, 160, Direction.Down, "NPC_BIPPA")
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, hero, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" C'est bon, [hero]?", german=" Bist du bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" C'est bon, [hero]?", german=" Bist du bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  else
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" C'est bon, [hero]?", german=" Bist du bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="All set!", french="C'est bon!", german="Alles klar!", italian="Tutto pronto!", spanish="¡Ahora mismo!"}, {english="Not yet...", french="Pas encore...", german="Noch nicht...", italian="Non ancora...", spanish="Espera un poco"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right. We'll get moving when\nyou're ready.", french="On part quand tout le monde est\nprêt.", german="In Ordnung. Wir gehen los, wenn\ndu so weit bist.", italian="Va bene. Partiremo quando sarà\ntutto pronto.", spanish=" Vale. Seguiremos cuando quieras."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK. Let's get moving when\nyou're ready.", french="On part quand tout le monde est\nprêt.", german="In Ordnung. Wir gehen los, wenn\ndu so weit bist.", italian="Va bene. Partiremo quando sarà\ntutto pronto.", spanish=" Vale. Seguiremos cuando quieras."})
  else
  SkySceneKit.say({english="OK. Let's get moving when\nyou're ready.", french="On part quand tout le monde est\nprêt.", german="In Ordnung. Wir gehen los, wenn\ndu so weit bist.", italian="Va bene. Partiremo quando sarà\ntutto pronto.", spanish=" Vale. Seguiremos cuando quieras."})
  end
  -- message_Close
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
  do local __choice = SkySceneKit.ask({{english="[CS:P]Mt. Horn[CR]", french="Par le [CS:P]Mt Corne[CR]", german="[CS:P]Hornberg[CR]", italian="[CS:P]Monte Aguzzo[CR]", spanish="[CS:P]Monte Cuerno[CR]"}, {english="[CS:P]Rock Path[CR]", french="Par le [CS:P]Chemin Rocheux[CR]", german="[CS:P]Felspfad[CR]", italian="[CS:P]Pista Rocciosa[CR]", spanish="[CS:P]Paso Rocoso[CR]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. [CS:P]Rock Path[CR] it is.", french="D'accord. Passons par le [CS:P]Chemin\nRocheux[CR].", german=" Gut. Wir nehmen den [CS:P]Felspfad[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Pista Rocciosa[CR].", spanish=" Muy bien. ¡Al [CS:P]Paso Rocoso[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right. [CS:P]Rock Path[CR] it is.", french="D'accord. Passons par le [CS:P]Chemin\nRocheux[CR].", german=" Gut. Wir nehmen den [CS:P]Felspfad[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Pista Rocciosa[CR].", spanish=" Muy bien. ¡Al [CS:P]Paso Rocoso[CR]!"})
  else
  SkySceneKit.say({english=" OK. [CS:P]Rock Path[CR] it is.", french="D'accord. Passons par le [CS:P]Chemin\nRocheux[CR].", german=" Okay. Wir nehmen den [CS:P]Felspfad[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Pista Rocciosa[CR].", spanish=" Muy bien. ¡Al [CS:P]Paso Rocoso[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-48), 48, false) end) -- MovePositionOffset performer/caméra
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:MoveToPosition(partner, 360, 156, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 336, 152, false, 2)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Auf geht's!", italian=" Forza! Andiamo!", spanish=" Muy bien, ¡adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Auf geht's!", italian=" Forza! Andiamo!", spanish=" Muy bien, ¡adelante!"})
  else
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Auf geht's!", italian=" Forza! Andiamo!", spanish=" Muy bien, ¡adelante!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 364, 100, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 364, 100, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_bippa, 364, 100, false, 2)
  if (SkyProg.cmp(9, 5) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [9, 5]
  -- @label_5 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(11, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(9, 5) -- $SCENARIO_MAIN = scn[9,5] (ROM)
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. [CS:P]Mt. Horn[CR] it is.", french="D'accord. Passons par\nle [CS:P]Mt Corne[CR].", german="Gut. Wir gehen über den\n[CS:P]Hornberg[CR].", italian="D'accordo. Andiamo verso il\n[CS:P]Monte Aguzzo[CR].", spanish=" Muy bien. ¡Al [CS:P]Monte Cuerno[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right. [CS:P]Mt. Horn[CR] it is.", french="D'accord. Passons par\nle [CS:P]Mt Corne[CR].", german="Gut. Wir gehen über den\n[CS:P]Hornberg[CR].", italian="D'accordo. Andiamo verso il\n[CS:P]Monte Aguzzo[CR].", spanish=" Muy bien. ¡Al [CS:P]Monte Cuerno[CR]!"})
  else
  SkySceneKit.say({english=" OK. [CS:P]Mt. Horn[CR] it is.", french="D'accord. Passons par\nle [CS:P]Mt Corne[CR].", german="Okay. Wir gehen über den\n[CS:P]Hornberg[CR].", italian="D'accordo. Andiamo verso il\n[CS:P]Monte Aguzzo[CR].", spanish=" Muy bien. ¡Al [CS:P]Monte Cuerno[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-48), 48, false) end) -- MovePositionOffset performer/caméra
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:MoveToPosition(partner, 360, 156, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 336, 152, false, 2)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Auf geht's!", italian=" Forza! Andiamo!", spanish=" Muy bien, ¡adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Auf geht's!", italian=" Forza! Andiamo!", spanish=" Muy bien, ¡adelante!"})
  else
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Auf geht's!", italian=" Forza! Andiamo!", spanish=" Muy bien, ¡adelante!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 364, 100, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 364, 100, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_bippa, 364, 100, false, 2)
  if (SkyProg.cmp(9, 5) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [9, 5]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(10, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(9, 5) -- $SCENARIO_MAIN = scn[9,5] (ROM)
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
