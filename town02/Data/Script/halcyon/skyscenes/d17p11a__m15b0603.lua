-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P11A/m15b0603.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D17P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Crystal Crossing.ogg", true) end)
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(300, 268, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 316, 284, false, 2)
  GROUND:MoveToPosition(partner, 284, 284, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 300, 324, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 328, 324, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! What is this?!", french=" Waouh! Qu'est-ce que c'est?!", german=" Boah! Was ist das?!?", italian=" Wow! E questa cos'è?", spanish=" ¡Vaya! ¡¿Qué es esto?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow! What is this?!", french=" Waouh! Qu'est-ce que c'est?!", german=" Wow! Was ist das?!?", italian=" Wow! E questa cos'è?", spanish=" ¡Vaya! ¡¿Qué es esto?!"})
  else
  SkySceneKit.say({english=" Wow! What is this?!", french=" Waouh! Qu'est-ce que c'est?!", german=" Wow! Was ist das?!?", italian=" Wow! E questa cos'è?", spanish=" ¡Vaya! ¡¿Qué es esto?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's a big, jagged opening in\nthe middle!", french="Il y a une grande ouverture\nau milieu!", german="Da ist eine riesige zerklüftete\nÖffnung in der Mitte!", italian="C'è un'enorme apertura là in\nmezzo!", spanish="¡Se acaba de abrir un agujero\nenorme ahí en medio!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's a big, jagged opening in\nthe middle!", french="Il y a une grande ouverture\nau milieu!", german="Da ist eine riesige zerklüftete\nÖffnung in der Mitte!", italian="C'è un'enorme apertura là in\nmezzo!", spanish="¡Se acaba de abrir un agujero\nenorme ahí en medio!"})
  else
  SkySceneKit.say({english="There's a big, jagged opening in\nthe middle!", french="Il y a une grande ouverture\nau milieu!", german="Da ist eine riesige zerklüftete\nÖffnung in der Mitte!", italian="C'è un'enorme apertura là in\nmezzo!", spanish="¡Se acaba de abrir un agujero\nenorme ahí en medio!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Do you think that we should go\nthrough there?", french="Tu crois qu'on devrait entrer\npar là?", german=" Meinst du, wir sollten da durch?", italian="Pensi che possiamo entrare\npassando per di là?", spanish="¿Crees que podríamos meternos\npor ahí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Do you think that we should go\nthrough there?", french="Tu crois qu'on devrait entrer\npar là?", german=" Meinst du, wir sollten da durch?", italian="Pensi che possiamo entrare\npassando per di là?", spanish="¿Crees que podríamos meternos\npor ahí?"})
  else
  SkySceneKit.say({english="Do you think that we should go\nthrough there?", french="Tu crois qu'on devrait entrer\npar là?", german=" Meinst du, wir sollten da durch?", italian="Pensi che possiamo entrare\npassando per di là?", spanish="¿Crees que podríamos meternos\npor ahí?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe that leads to the lake\nwhere [CS:N]Azelf[CR] lives.", french="Peut-être que ça nous mènera\nau lac de [CS:N]Créfadet[CR].", german="Vielleicht kommen wir so zu dem\nSee, an dem [CS:N]Tobutz[CR] lebt.", italian="Forse quello è il passaggio per\nraggiungere il lago dove vive [CS:N]Azelf[CR].", spanish="Tal vez conduzca al sitio donde\nvive [CS:N]Azelf[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Maybe that leads to [CS:N]Azelf[CR]'s\nlake.", french="Peut-être que ça nous mènera\nau lac de [CS:N]Créfadet[CR].", german="Vielleicht kommen wir so zu dem\nSee, an dem [CS:N]Tobutz[CR] lebt.", italian="Forse quello è il passaggio per\nraggiungere il lago dove vive [CS:N]Azelf[CR].", spanish="Tal vez conduzca al sitio donde\nvive [CS:N]Azelf[CR]."})
  else
  SkySceneKit.say({english="Maybe that leads to the lake\nwhere [CS:N]Azelf[CR] lives.", french="Peut-être que ça nous mènera\nau lac de [CS:N]Créfadet[CR].", german="Vielleicht kommen wir so zu dem\nSee, an dem [CS:N]Tobutz[CR] lebt.", italian="Forse quello è il passaggio per\nraggiungere il lago dove vive [CS:N]Azelf[CR].", spanish="Tal vez conduzca al sitio donde\nvive [CS:N]Azelf[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Those three crystals were the\nkey, [hero]!", french="Ces trois cristaux étaient bel\net bien la clé du mystère, [hero]!", german="Diese drei Kristalle waren\nder Schlüssel, [hero]!", italian="La chiave era proprio nei\ncristalli, [hero]!", spanish="Esos tres cristales eran la\nclave, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Those three crystals were the\nkey, [hero]!", french="Ces trois cristaux étaient bel\net bien la clé du mystère, [hero]!", german="Diese drei Kristalle waren\nder Schlüssel, [hero]!", italian="La chiave era proprio nei\ncristalli, [hero]!", spanish="Esos tres cristales eran la\nclave, [hero]."})
  else
  SkySceneKit.say({english="Those three crystals were the\nkey, [hero]!", french="Ces trois cristaux étaient bel\net bien la clé du mystère, [hero]!", german="Diese drei Kristalle waren\nder Schlüssel, [hero]!", italian="La chiave era proprio nei\ncristalli, [hero]!", spanish="Esos tres cristales eran la\nclave, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They opened a path that may\nlead to a Time Gear!", french="Ils ont ouvert un passage qui\nmène peut-être au Rouage du Temps!", german="Sie haben einen Weg offenbart,\nder zu einem Zahnrad der Zeit führen könnte!", italian="Hanno aperto un passaggio che\npotrebbe condurci all'Ingranaggio del Tempo!", spanish="¡Han abierto una vía que puede\nllevarnos a un Engranaje del Tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They opened a path that may\nlead to a Time Gear!", french="Ils ont ouvert un passage qui\nmène peut-être au Rouage du Temps!", german="Sie haben einen Weg offenbart,\nder zu einem Zahnrad der Zeit führen könnte!", italian="Hanno aperto un passaggio che\npotrebbe condurci all'Ingranaggio del Tempo!", spanish="¡Han abierto una vía que puede\nllevarnos a un Engranaje del Tiempo!"})
  else
  SkySceneKit.say({english="They opened a path that may\nlead to a Time Gear!", french="Ils ont ouvert un passage qui\nmène peut-être au Rouage du Temps!", german="Sie haben einen Weg offenbart,\nder zu einem Zahnrad der Zeit führen könnte!", italian="Hanno aperto un passaggio che\npotrebbe condurci all'Ingranaggio del Tempo!", spanish="¡Han abierto una vía que puede\nllevarnos a un Engranaje del Tiempo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's roll, [hero]!", french=" On y va, [hero]!", german=" Nichts wie los, [hero]!", italian="Andiamo, [hero]!\nRock'n'roll!", spanish=" ¡Adelante, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero]!", french=" On y va, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Adelante, [hero]!"})
  else
  SkySceneKit.say({english=" Let's go, [hero]!", french=" On y va, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Adelante, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We're off to [CS:N]Azelf[CR]'s lake!", french="En route pour le lac\nde [CS:N]Créfadet[CR]!", german=" Auf zum See von [CS:N]Tobutz[CR]!", italian=" Destinazione: il lago di [CS:N]Azelf[CR]!", spanish=" ¡Vamos al lago de [CS:N]Azelf[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Onward to [CS:N]Azelf[CR]'s lake!", french="En route pour le lac\nde [CS:N]Créfadet[CR]!", german=" Auf zum See von [CS:N]Tobutz[CR]!", italian=" Destinazione: il lago di [CS:N]Azelf[CR]!", spanish=" ¡Vamos al lago de [CS:N]Azelf[CR]!"})
  else
  SkySceneKit.say({english=" We're off to [CS:N]Azelf[CR]'s lake!", french="En route pour le lac\nde [CS:N]Créfadet[CR]!", german=" Auf zum See von [CS:N]Tobutz[CR]!", italian=" Destinazione: il lago di [CS:N]Azelf[CR]!", spanish=" ¡Vamos al lago de [CS:N]Azelf[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(partner, 300, 212, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 300, 212, false, 2)
  GAME:WaitFrames(15)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 300, 212, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 300, 212, false, 2) end end
  GAME:WaitFrames(10)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[25] = 1 -- dungeon_mode(25) = DMODE_OPEN (ROM)
  -- main_EnterDungeon(25, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
