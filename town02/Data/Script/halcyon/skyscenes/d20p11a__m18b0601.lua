-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D20P11A/m18b0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Sealed Ruin.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you all ready, [hero]?", french=" On peut y aller, [hero]?", german=" Bist du bereit, [hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On peut y aller, [hero]?", german=" Bist du bereit, [hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  else
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On peut y aller, [hero]?", german=" Bist du bereit, [hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="All set!", french="C'est parti!", german="Alles klar!", italian="Tutto pronto!", spanish="¡Vamos allá!"}, {english="Not yet...", french="Pas encore...", german="Noch nicht...", italian="Non ancora...", spanish="Aún no..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll go when you're ready.", french=" On part quand tu veux.", german=" Wir gehen, wenn du so weit bist.", italian=" Appena siamo pronti partiamo.", spanish="Avísame cuando quieras que\nnos pongamos en marcha."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german=" Gehen wir, wenn du so weit bist.", italian=" Quando siamo pronti andiamo.", spanish="Avísame cuando quieras que\nnos pongamos en marcha."})
  else
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german=" Gehen wir, wenn du so weit bist.", italian=" Quando è tutto pronto andiamo.", spanish="Avísame cuando quieras que\nnos pongamos en marcha."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's hurry after [CS:N]Grovyle[CR]!", french="Dépêchons-nous de rejoindre\n[CS:N]Massko[CR]!", german=" Schnell, folgen wir [CS:N]Reptain[CR]!", italian=" Presto, raggiungiamo [CS:N]Grovyle[CR]!", spanish="¡Tenemos que alcanzar a\n[CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's hurry and catch up to\n[CS:N]Grovyle[CR]!", french="Dépêchons-nous de rejoindre\n[CS:N]Massko[CR]!", german=" Schnell, folgen wir [CS:N]Reptain[CR]!", italian="Facciamo presto e raggiungiamo\n[CS:N]Grovyle[CR]!", spanish="¡Tenemos que alcanzar a\n[CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english="Let's hurry and catch up to\n[CS:N]Grovyle[CR]!", french="Dépêchons-nous de rejoindre\n[CS:N]Massko[CR]!", german=" Schnell, folgen wir [CS:N]Reptain[CR]!", italian="Facciamo presto e raggiungiamo\n[CS:N]Grovyle[CR]!", spanish="¡Tenemos que alcanzar a\n[CS:N]Grovyle[CR]!"})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's roll out!", french=" D'accord, on y va!", german=" Okay! Nichts wie los!", italian=" Va bene! Si parte!", spanish=" ¡Muy bien! ¡Adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Let's go!", french=" D'accord, on y va!", german=" Okay! Gehen wir!", italian=" Ok! Andiamo!", spanish=" ¡Muy bien! ¡Adelante!"})
  else
  SkySceneKit.say({english=" OK! Let's go!", french=" D'accord, on y va!", german=" Okay! Gehen wir!", italian=" Ok! Andiamo!", spanish=" ¡Muy bien! ¡Adelante!"})
  end
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(29, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
end
