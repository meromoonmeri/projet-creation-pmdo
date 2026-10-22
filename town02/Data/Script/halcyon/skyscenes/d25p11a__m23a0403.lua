-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D25P11A/m23a0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Brine Cave.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ready, [hero]?", french=" On y va, [hero]?", german=" Bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On y va, [hero]?", german=" Bist du bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  else
  SkySceneKit.say({english=" Ready, [hero]?", french=" On y va, [hero]?", german=" Bist du bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="Not yet", french="Non", german="Nein", italian="No", spanish="Aún no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh. All right.", french=" Entendu.", german=" Oh. Alles klar.", italian=" Questa volta ce la faremo!", spanish=" Vale, de acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh. OK.", french=" Entendu.", german=" Oh. Okay.", italian=" Ah. Va bene.", spanish=" Vale, de acuerdo."})
  else
  SkySceneKit.say({english=" Oh. OK.", french=" Entendu.", german=" Oh. Okay.", italian=" Ah. Ok.", spanish=" Vale, de acuerdo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll be on our way when\nyou're ready.", french=" On repart quand tu voudras.", german="Wir brechen auf, wenn du\nbereit bist.", italian="Forza! Appena è tutto pronto,\nci mettiamo in marcia.", spanish="Continuaremos en cuanto\nte parezca bien."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go as soon as you're ready.", french=" On repart quand tu voudras.", german="Lass uns gehen, sobald du bereit\nbist.", italian="Quando è tutto pronto, ci\nmettiamo in marcia.", spanish="Continuaremos en cuanto\nte parezca bien."})
  else
  SkySceneKit.say({english=" Let's leave when you're ready.", french=" On repart quand tu voudras.", german=" Gehen wir, wenn du bereit bist.", italian="Appena è tutto pronto, ci\nmettiamo in marcia.", spanish="Continuaremos en cuanto\nte parezca bien."})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Time to roll!", french=" Allez! On bouge!", german=" Alles klar! Legen wir los!", italian="Va bene! È ora di aprire le\ndanze!", spanish=" ¡Muy bien! ¡Vamos allá!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Let's move out!", french=" Allez! On bouge!", german=" Okay! Rücken wir aus!", italian=" Ok! Muoviamoci!", spanish=" ¡Muy bien! ¡Adelante!"})
  else
  SkySceneKit.say({english=" OK! Let's go!", french=" Allez! On bouge!", german=" Okay! Los geht es!", italian=" Ok! Andiamo!", spanish=" ¡Muy bien! ¡Vamos!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 252, 148, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 252, 148, false, 2)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(35, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
end
