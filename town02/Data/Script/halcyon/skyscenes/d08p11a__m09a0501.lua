-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D08P11A/m09a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On peut y aller, [hero]?", german=" Bist du so weit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On peut y aller, [hero]?", german=" Bist du so weit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  else
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On peut y aller, [hero]?", german=" Bist du so weit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="Not yet", french="Pas encore", german="Noch nicht", italian="Aspetta", spanish="Aún no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right. We'll get moving when\nyou're ready.", french=" On partira quand tout sera prêt.", german="In Ordnung. Wir gehen, wenn du\nso weit bist.", italian="Va bene. Partiremo quando sarà\ntutto pronto.", spanish="Muy bien. Seguiremos\ncuando quieras."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="All right. We'll get moving when\nyou're ready.", french=" On partira quand tout sera prêt.", german="In Ordnung. Wir gehen, wenn du\nso weit bist.", italian="Va bene. Partiremo quando sarà\ntutto pronto.", spanish="Muy bien. Seguiremos\ncuando quieras."})
  else
  SkySceneKit.say({english="All right. We'll get moving when\nyou're ready.", french=" On partira quand tout sera prêt.", german="In Ordnung. Wir gehen, wenn du\nso weit bist.", italian="Va bene. Partiremo quando sarà\ntutto pronto.", spanish="Muy bien. Seguiremos\ncuando quieras."})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte andiamo?", spanish=" ¿Por dónde vamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte andiamo?", spanish=" ¿Por dónde vamos?"})
  else
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte andiamo?", spanish=" ¿Por dónde vamos?"})
  end
  do local __choice = SkySceneKit.ask({{english="[CS:P]Foggy Forest[CR]", french="Par la [CS:P]Forêt Brumeuse[CR]", german="[CS:P]Nebelwald[CR]", italian="[CS:P]Foresta Bruma[CR]", spanish="[CS:P]Bosque Niebla[CR]"}, {english="[CS:P]Forest Path[CR]", french="Par le [CS:P]Chemin Sylvestre[CR]", german="[CS:P]Waldpfad[CR]", italian="[CS:P]Pista Silvestre[CR]", spanish="[CS:P]Paso Boscoso[CR]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK, [CS:P]Forest Path[CR] it is.", french="D'accord, allons vers le [CS:P]Chemin\nSylvestre[CR].", german=" Gut. Wir nehmen den [CS:P]Waldpfad[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Pista Silvestre[CR].", spanish=" De acuerdo. ¡Al [CS:P]Paso Boscoso[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, [CS:P]Forest Path[CR] it is.", french="D'accord, allons vers le [CS:P]Chemin\nSylvestre[CR].", german=" Gut. Wir nehmen den [CS:P]Waldpfad[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Pista Silvestre[CR].", spanish=" De acuerdo. ¡Al [CS:P]Paso Boscoso[CR]!"})
  else
  SkySceneKit.say({english=" OK, [CS:P]Forest Path[CR] it is.", french="D'accord, allons vers le [CS:P]Chemin\nSylvestre[CR].", german=" Gut. Wir nehmen den [CS:P]Waldpfad[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Pista Silvestre[CR].", spanish=" De acuerdo. ¡Al [CS:P]Paso Boscoso[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK! Let's go!", french=" Allons-y! En route!", german=" Okay! Gehen wir!", italian=" Ok! Andiamo!", spanish=" Está bien. ¡Adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Let's go!", french=" Allons-y! En route!", german=" Okay! Gehen wir!", italian=" Ok! Andiamo!", spanish=" Está bien. ¡Adelante!"})
  else
  SkySceneKit.say({english=" OK! Let's go!", french=" Allons-y! En route!", german=" Okay! Gehen wir!", italian=" Ok! Andiamo!", spanish=" Está bien. ¡Adelante!"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GROUND:MoveToPosition(hero, 300, 84, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 300, 84, false, 2)
  GAME:WaitFrames(20)
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- main_EnterDungeon(13, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. [CS:P]Foggy Forest[CR] it is.", french="D'accord. Allons dans la [CS:P]Forêt\nBrumeuse[CR].", german="Gut. Wir gehen durch den\n[CS:P]Nebelwald[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Foresta Bruma[CR].", spanish=" De acuerdo. ¡Al [CS:P]Bosque Niebla[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right. [CS:P]Foggy Forest[CR] it is.", french="D'accord. Allons dans la [CS:P]Forêt\nBrumeuse[CR].", german="Gut. Wir gehen durch den\n[CS:P]Nebelwald[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Foresta Bruma[CR].", spanish=" De acuerdo. ¡Al [CS:P]Bosque Niebla[CR]!"})
  else
  SkySceneKit.say({english=" All right. [CS:P]Foggy Forest[CR] it is.", french="D'accord. Allons dans la [CS:P]Forêt\nBrumeuse[CR].", german="Gut. Wir gehen durch den\n[CS:P]Nebelwald[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Foresta Bruma[CR].", spanish=" De acuerdo. ¡Al [CS:P]Bosque Niebla[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's go!", french=" O.K.! Allons-y!", german=" Okay! Nichts wie los!", italian=" Forza, andiamo!", spanish=" Está bien. ¡Adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right! Let's go!", french=" O.K.! Allons-y!", german=" Okay! Nichts wie los!", italian=" Forza, andiamo!", spanish=" Está bien. ¡Adelante!"})
  else
  SkySceneKit.say({english=" All right! Let's go!", french=" O.K.! Allons-y!", german=" Okay! Nichts wie los!", italian=" Forza, andiamo!", spanish=" Está bien. ¡Adelante!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 300, 84, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 300, 84, false, 2)
  GAME:WaitFrames(20)
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- main_EnterDungeon(12, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  end
end
