-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D06P11A/m08a0603.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Craggy Coast.ogg", true) end)
  -- back_SetGround(LEVEL_D06P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 368, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 368, 196, false, 2)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 344, 240, Direction.Up, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 368, 220, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 344, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(4) [anim idle native]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner] is acting like a leader. I didn't\nnotice it before...)", french="([partner] dirige les opérations.\nJe n'avais jamais remarqué ça avant...)", german="([partner] verhält sich wie ein Anführer.\nDas ist mir vorher nie aufgefallen.)", italian="([partner] si comporta da leader. Non lo\navevo notato prima...)", spanish="([partner] se está comportando como líder.\nHasta ahora no se había comportado así.)"})
  else
  SkySceneKit.say({english="([partner] is acting like a leader. I didn't\nnotice it before...)", french="([partner] dirige les opérations.\nJe n'avais jamais remarqué ça avant...)", german="([partner] verhält sich wie ein Anführer.\nDas ist mir vorher nie aufgefallen.)", italian="([partner] si comporta da leader. Non lo\navevo notato prima...)", spanish="([partner] se está comportando como líder.\nHasta ahora no se había comportado así.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It must be the excitement from exploring\nthat's bringing it out...)", french="(C'est sûrement la joie de faire partie de\nl'expédition qui lui donne des ailes...)", german="(Das kommt sicher von der Aufregung über\ndie Expedition.)", italian="(Dev'essere l'entusiasmo che fa emergere\nquesto suo lato...)", spanish="(Debe de ser por la emoción que le produce\neste viaje.)"})
  else
  SkySceneKit.say({english="(It must be the excitement from exploring\nthat's bringing it out...)", french="(C'est sûrement la joie de faire partie de\nl'expédition qui lui donne des ailes...)", german="(Das kommt sicher von der Aufregung über\ndie Expedition.)", italian="(Dev'essere l'entusiasmo che fa emergere\nquesto suo lato...)", spanish="(Debe de ser por la emoción que le produce\neste viaje.)"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But [partner], who was so timid before,\nis trying so much harder...)", french="(Mais [partner], qui était si timide avant,\nfait tant d'efforts...)", german="(Aber [partner] war früher so\nzurückhaltend und gibt sich jetzt viel\nmehr Mühe.)", italian="([partner], che prima non aveva molto\ncoraggio, ce la sta mettendo tutta...)", spanish="(Se ve que [partner] se está esforzando\nmuchísimo y ya no tiene tanta inseguridad.)"})
  else
  SkySceneKit.say({english="(But [partner], who was so timid before,\nis trying so much harder...)", french="(Mais [partner], qui était si timide avant,\nfait tant d'efforts...)", german="(Aber [partner] war früher so\nzurückhaltend und gibt sich jetzt viel\nmehr Mühe.)", italian="([partner], che prima non aveva molto\ncoraggio, ce la sta mettendo tutta...)", spanish="(Se ve que [partner] se está esforzando\nmuchísimo y ya no tiene tanta inseguridad.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Yes, [partner] is getting stronger and\nmore confident bit by bit...)", french="(Oui, petit à petit, [partner] s'améliore\net prend confiance...)", german="(Ja, [partner] wird nach und nach immer\nselbstbewusster.)", italian="(Sì, [partner] sta diventando più forte\npoco a poco...)", spanish="(Exacto. [partner] confía cada vez\nmás en sus aptitudes y es más fuerte.)"})
  else
  SkySceneKit.say({english="(Yes, [partner] is getting stronger and\nmore confident bit by bit...)", french="(Oui, petit à petit, [partner] s'améliore\net prend confiance...)", german="(Ja, [partner] wird nach und nach immer\nselbstbewusster.)", italian="(Sì, [partner] sta diventando più forte\npoco a poco...)", spanish="(Exacto. [partner] confía cada vez\nmás en sus aptitudes y es más fuerte.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh... Huh?", french=" Oh... Quoi?", german=" Oh... Äh?", italian=" Oh... Eh?", spanish=" ¡Vaya faena!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh... Huh?", french=" Oh... Quoi?", german=" Oh... Äh?", italian=" Oh... Eh?", spanish=" Menudo plan."})
  else
  SkySceneKit.say({english=" Oh... Huh?", french=" Oh... Quoi?", german=" Oh... Äh?", italian=" Oh... Eh?", spanish=" Vaya."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Huh? Problem?", french=" Heiiin? Un problème?", german=" Ähem? Gibt es ein Problem?", italian=" Eh? C'è qualche problema?", spanish=" ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If you look closely here, there\nare two entrances.", french="Regarde bien, il y a deux\nentrées ici.", german="Wenn man genau hinsieht, gibt\nes zwei Eingänge.", italian="Se guardi bene, qui ci sono\ndue ingressi.", spanish=" Si os fijáis, hay dos caminos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If you look closely here, there\nare two entrances.", french="Regarde bien, il y a deux\nentrées ici.", german="Wenn man genau hinsieht, gibt\nes zwei Eingänge.", italian="Se guardi bene, qui ci sono\ndue ingressi.", spanish=" Si os fijáis, hay dos caminos."})
  else
  SkySceneKit.say({english="If you look closely here, there\nare two entrances.", french="Regarde bien, il y a deux\nentrées ici.", german="Wenn man genau hinsieht, gibt\nes zwei Eingänge.", italian="Se guardi bene, qui ci sono\ndue ingressi.", spanish=" Si os fijáis, hay dos caminos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Huh? Now, that is mighty vexing.", french="Heiiin? Mais c'est vachement\nembêtant, ça.", german=" Hmm... Das ist aber verwirrend.", italian=" Eh? Questa sì che è una bega.", spanish=" ¡Vaya! ¡Qué mala pata!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What'll we do, [hero]?", french="Qu'est-ce qu'on fait,\n[hero]?", german="Was machen wir jetzt,\n[hero]?", italian="Cosa dobbiamo fare,\n[hero]?", spanish=" ¿Qué hacemos, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What'll we do, [hero]?", french="Qu'est-ce qu'on fait,\n[hero]?", german="Was machen wir jetzt,\n[hero]?", italian="Cosa dobbiamo fare,\n[hero]?", spanish=" ¿Qué hacemos, [hero]?"})
  else
  SkySceneKit.say({english=" What'll we do, [hero]?", french="Qu'est-ce qu'on fait,\n[hero]?", german="Was machen wir jetzt,\n[hero]?", italian="Cosa dobbiamo fare,\n[hero]?", spanish=" ¿Qué hacemos, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte andiamo?", spanish=" ¿Por dónde vamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte andiamo?", spanish=" ¿Por dónde vamos?"})
  else
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte andiamo?", spanish=" ¿Por dónde vamos?"})
  end
  do local __choice = SkySceneKit.ask({{english="[CS:P]Craggy Coast[CR]", french="Par la [CS:P]Côte Escarpée[CR]", german="[CS:P]Schroffküste[CR]", italian="[CS:P]Dirupo Costiero[CR]", spanish="[CS:P]Costa Escarpada[CR]"}, {english="[CS:P]Side Path[CR]", french="Par le [CS:P]Chemin Lisière[CR]", german="[CS:P]Schleichpfad[CR]", italian="[CS:P]Sentiero Scosceso[CR]", spanish="[CS:P]Paso Flanco[CR]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[5] = 1 -- $SCENARIO_MAIN_BIT_FLAG[5] = 1 (ROM)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK. [CS:P]Side Path[CR] it is.", french="D'accord. Passons par le\n[CS:P]Chemin Lisière[CR].", german="In Ordnung. Wir nehmen den\n[CS:P]Schleichpfad[CR].", italian="Va bene. Andiamo verso il\n[CS:P]Sentiero Scosceso[CR].", spanish=" Muy bien. ¡Al [CS:P]Paso Flanco[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK. [CS:P]Side Path[CR] it is.", french="D'accord. Passons par le\n[CS:P]Chemin Lisière[CR].", german="In Ordnung. Wir nehmen den\n[CS:P]Schleichpfad[CR].", italian="Va bene. Andiamo verso il\n[CS:P]Sentiero Scosceso[CR].", spanish=" Muy bien. ¡Al [CS:P]Paso Flanco[CR]!"})
  else
  SkySceneKit.say({english=" OK. [CS:P]Side Path[CR] it is.", french="D'accord. Passons par le\n[CS:P]Chemin Lisière[CR].", german="In Ordnung. Wir nehmen den\n[CS:P]Schleichpfad[CR].", italian="Va bene. Andiamo verso il\n[CS:P]Sentiero Scosceso[CR].", spanish=" Muy bien. ¡Al [CS:P]Paso Flanco[CR]!"})
  end
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK. [CS:P]Craggy Coast[CR] it is.", french="D'accord. Passons par la\n[CS:P]Côte Escarpée[CR].", german="In Ordnung. Wir gehen über die\n[CS:P]Schroffküste[CR].", italian="D'accordo. Andiamo verso il\n[CS:P]Dirupo Costiero[CR].", spanish=" Muy bien. ¡A la [CS:P]Costa Escarpada[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK. [CS:P]Craggy Coast[CR] it is.", french="D'accord. Passons par la\n[CS:P]Côte Escarpée[CR].", german="In Ordnung. Wir gehen über die\n[CS:P]Schroffküste[CR].", italian="D'accordo. Andiamo verso il\n[CS:P]Dirupo Costiero[CR].", spanish=" Muy bien. ¡A la [CS:P]Costa Escarpada[CR]!"})
  else
  SkySceneKit.say({english=" OK. [CS:P]Craggy Coast[CR] it is.", french="D'accord. Passons par la\n[CS:P]Côte Escarpée[CR].", german="In Ordnung. Wir gehen über die\n[CS:P]Schroffküste[CR].", italian="D'accordo. Andiamo verso il\n[CS:P]Dirupo Costiero[CR].", spanish=" Muy bien. ¡A la [CS:P]Costa Escarpada[CR]!"})
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. Now...", french=" D'accord. Alors...", german="Abgemacht. Und jetzt ist es\nZeit...", italian=" Bene. Adesso...", spanish=" Muy bien. Ahora..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right. Now...", french=" D'accord. Alors...", german="Abgemacht. Und jetzt ist es\nZeit...", italian=" Bene. Adesso...", spanish=" Muy bien. Ahora..."})
  else
  SkySceneKit.say({english=" All right. Now...", french=" D'accord. Alors...", german="Abgemacht. Und jetzt ist es\nZeit...", italian=" Bene. Adesso...", spanish=" Muy bien. Ahora..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Let's all three work as one and\nget this done!", french="C'est parti! A trois, on va\ny arriver!", german="Zeit, dass wir alle drei als ein\nTeam zusammenarbeiten!", italian="Dobbiamo lavorare di squadra\ne farcela!", spanish="¡Venga, vamos los tres...\ny a por ello!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Up)
  SkyProg.set(9, 2) -- $SCENARIO_MAIN = scn[9,2] (ROM)
  if ((SV.SkyScenarioBitFlags or {})[5] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[5]
  -- debug_Print('ENTER_CHIISANAYOKOANA') [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(9, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- debug_Print('ENTER_ENGANNOIWABA') [neutre/état moteur]
  -- main_EnterDungeon(8, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
