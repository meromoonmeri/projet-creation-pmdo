-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P11A/s01p0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Mystifying Forest.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You ready, [hero]?", french=" On y va, [hero]?", german=" Bereit, [hero]?", italian=" Possiamo andare, [hero]?", spanish=" ¿Todo listo, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On y va, [hero]?", german=" Bist du bereit, [hero]?", italian=" Possiamo andare, [hero]?", spanish=" ¿Todo listo, [hero]?"})
  else
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On y va, [hero]?", german=" Bist du bereit, [hero]?", italian=" Possiamo andare, [hero]?", spanish=" ¿Vamos, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right.", french=" D'accord.", german=" Alles klar.", italian=" Va bene.", spanish=" De acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Va bene.", spanish=" Vale."})
  else
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Va bene.", spanish=" Vale."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll go when you're ready.", french="On partira quand\ntu le voudras.", german=" Wir gehen, wenn du bereit bist.", italian="Andremo quando sarà\ntutto pronto.", spanish="Nos pondremos en marcha\nen cuanto tú digas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We'll leave when you're ready.", french="On partira quand\ntu le voudras.", german="Wir gehen los, wenn du bereit\nbist.", italian="Andremo quando sarà\ntutto pronto.", spanish=" Saldremos cuando tú quieras."})
  else
  SkySceneKit.say({english=" Let's go when you're ready.", french="On partira quand\ntu le voudras.", german=" Gehen wir, wenn du bereit bist.", italian="Andremo quando sarà\ntutto pronto.", spanish="Seguiremos cuando te parezca\nbien."})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup. Looks like we're all set!", french="Oui. Je pense aussi que tout\nest prêt!", german="Ja! Sieht so aus, als könnten\nwir durchstarten!", italian=" Sì. Tutto pronto!", spanish="¡Estupendo! Ya podemos\ncontinuar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes. We're all ready to go!", french="Oui. Je pense aussi que tout\nest prêt!", german=" Ja. Alle bereit zum Loslegen!", italian=" Sì. Tutto pronto!", spanish=" Sí, ¡adelante!"})
  else
  SkySceneKit.say({english=" Yep. We're set to go!", french="Oui. Je pense aussi que tout\nest prêt!", german=" Jep. Wir können!", italian=" Sì. Tutto pronto!", spanish=" Sí, ¡vamos allá!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's go!", french=" D'accord! Allons-y!", german=" Alles klar! Gehen wir!", italian=" Forza, andiamo!", spanish=" ¡Vale! ¡Vamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Let's go!", french=" D'accord! Allons-y!", german=" Okay! Gehen wir!", italian=" Forza, andiamo!", spanish=" ¡De acuerdo, vamos!"})
  else
  SkySceneKit.say({english=" OK! Let's go!", french=" D'accord! Allons-y!", german=" Okay! Gehen wir!", italian=" Forza, andiamo!", spanish=" ¡De acuerdo, vamos!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 300, 28, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 300, 28, false, 2)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(44, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
end
