-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D09P11A/m10a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Steam Cave.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ready to head in, [hero]?", french=" On peut y aller, [hero]?", german=" Bist du so weit, [hero]?", italian=" Ci buttiamo, [hero]?", spanish=" ¿Entramos ya, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ready to go in, [hero]?", french=" On peut y aller, [hero]?", german=" Bist du so weit, [hero]?", italian=" Te la senti, [hero]?", spanish=" ¿Entramos ya, [hero]?"})
  else
  SkySceneKit.say({english=" Ready to go in, [hero]?", french=" On peut y aller, [hero]?", german=" Bist du so weit, [hero]?", italian=" Te la senti, [hero]?", spanish=" ¿Entramos ya, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="Not yet", french="Non", german="Nein", italian="Aspetta", spanish="Aún no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir unser Bestes,\n[hero]!", italian=" Diamoci dentro, [hero]!", spanish="¡Vamos a esforzarnos todo\nlo que podamos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's try our best, [hero]!", french="Faisons de notre mieux,\n[hero]!", german="Versuchen wir unser Bestes,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Vamos a esforzarnos todo\nlo que podamos, [hero]!"})
  else
  SkySceneKit.say({english="OK, let's give it our very best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Okay, geben wir unser\nAllerbestes, [hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Vamos a esforzarnos todo\nlo que podamos, [hero]!"})
  end
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  if (SkyProg.cmp(11, 1) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [11, 1]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M10_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- main_EnterDungeon(14, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  elseif __choice == 2 then
  -- @label_1 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right, then!", french=" D'accord!", german=" Schon okay!", italian=" Va bene!", spanish=" ¡De acuerdo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, then!", french=" D'accord!", german=" In Ordnung!", italian=" Va bene!", spanish=" ¡De acuerdo!"})
  else
  SkySceneKit.say({english=" OK, then!", french=" D'accord!", german=" In Ordnung!", italian=" Va bene!", spanish=" ¡De acuerdo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go as soon as you're ready!", french="Préviens-moi dès que tu auras\nfini tes préparatifs!", german=" Wir gehen, sobald du bereit bist!", italian=" Prepariamoci come si deve!", spanish=" Cuando quieras."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We'll go when you're ready.", french="Préviens-moi dès que tu auras\nfini tes préparatifs!", german=" Wir gehen, wenn du so weit bist.", italian=" Meglio prepararsi prima.", spanish=" Vamos cuando digas."})
  else
  SkySceneKit.say({english=" Let's go when you're ready.", french="Préviens-moi dès que tu auras\nfini tes préparatifs!", german="Lass uns gehen, wenn du so weit\nbist.", italian=" Meglio prepararsi prima.", spanish=" Vamos cuando quieras."})
  end
  -- message_Close
  else -- default/annulation
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
