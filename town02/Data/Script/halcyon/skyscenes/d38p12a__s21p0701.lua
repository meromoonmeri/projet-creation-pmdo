-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D38P12A/s21p0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [hero]. Are you all\nready?", french="Eh, [hero]. On peut\ny aller?", german="Hey, [hero]. Bist du\nbereit?", italian=" Ehi, [hero]. Tutto pronto?", spanish=" Dime, [hero]. ¿Todo listo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french="Eh, [hero]. On peut\ny aller?", german=" Bist du bereit, [hero]?", italian=" Ehi, [hero]. Tutto pronto?", spanish=" Dime, [hero]. ¿Todo listo?"})
  else
  SkySceneKit.say({english=" Are you ready, [hero]?", french="Eh, [hero]. On peut\ny aller?", german=" Bist du bereit, [hero]?", italian=" Ehi, [hero]. Tutto pronto?", spanish=" Dime, [hero]. ¿Todo listo?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right.", french=" D'accord.", german=" Alles klar.", italian=" Va bene.", spanish=" Vale."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Ok.", spanish=" Vale."})
  else
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Ok.", spanish=" Vale."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll go when you're ready.", french=" On part quand tu veux.", german=" Wir gehen, wenn du bereit bist.", italian="Partiremo quando sarà\ntutto pronto.", spanish="Nos iremos en cuanto tengas\ntodo listo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german="Lass uns gehen, wenn du bereit\nbist.", italian="Partiremo quando sarà\ntutto pronto.", spanish="Nos iremos en cuanto tengas\ntodo listo."})
  else
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german="Lass uns gehen, wenn du bereit\nbist.", italian="Partiremo quando sarà\ntutto pronto.", spanish="Nos iremos en cuanto tengas\ntodo listo."})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Looks like you're all set.", french=" On dirait que tout est prêt.", german="Sieht so aus, als wärest du\nbereit.", italian=" Sembra tutto pronto.", spanish=" Vale, todo listo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, we're all set to go.", french=" On dirait que tout est prêt.", german=" Okay, wir sind marschbereit.", italian=" Sembra tutto pronto.", spanish=" Ya nos podemos ir."})
  else
  SkySceneKit.say({english=" OK, we're all set to go.", french=" On dirait que tout est prêt.", german=" Okay, wir sind marschbereit.", italian=" Sembra tutto pronto.", spanish=" Vale, todo listo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's roll on out!", french=" Parfait! C'est parti!", german=" Alles klar! Ziehen wir los!", italian=" Forza! Andiamo!", spanish=" ¡De acuerdo! ¡En marcha!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Let's go!", french=" Parfait! C'est parti!", german=" Okay! Los geht's!", italian=" Forza! Andiamo!", spanish=" ¡De acuerdo! ¡En marcha!"})
  else
  SkySceneKit.say({english=" OK! Let's go!", french=" Parfait! C'est parti!", german=" Okay! Los geht's!", italian=" Forza! Andiamo!", spanish=" ¡De acuerdo! ¡En marcha!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 240, 28, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(partner, 240, 28, false, 2)
  GAME:WaitFrames(20)
  -- main_EnterDungeon(64, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
end
