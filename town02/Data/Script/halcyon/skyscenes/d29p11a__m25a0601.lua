-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D29P11A/m25a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Temporal Tower.ogg", true) end)
  if (SkyProg.cmp(26, 3) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [26, 3]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You ready, [hero]?", french=" On y va, [hero]?", german=" Bereit, [hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Continuamos, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On y va, [hero]?", german=" Bist du bereit, [hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Continuamos, [hero]?"})
  else
  SkySceneKit.say({english=" Ready, [hero]?", french=" On y va, [hero]?", german=" Bereit, [hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Continuamos, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, all right.", french=" D'accord.", german=" Oh, alles klar.", italian=" Ah, va bene.", spanish=" Bueno, vale."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, OK.", french=" D'accord.", german=" Oh, okay.", italian=" Ah, ok.", spanish=" Bueno, vale."})
  else
  SkySceneKit.say({english=" Oh, OK.", french=" D'accord.", german=" Oh, okay.", italian=" Oh, ok.", spanish=" Bueno, vale."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll go when you're ready.", french="On partira quand tu auras fini\nde te préparer.", german=" Wir gehen, wenn du bereit bist.", italian=" Quando è tutto pronto, andiamo.", spanish=" Seguiremos cuando quieras."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We'll go when you're ready.", french="On partira quand tu auras fini\nde te préparer.", german=" Wir gehen, wenn du bereit bist.", italian=" Quando è tutto pronto, andiamo.", spanish=" Seguiremos cuando quieras."})
  else
  SkySceneKit.say({english=" We'll go when you're ready.", french="On partira quand tu auras fini\nde te préparer.", german=" Wir gehen, wenn du bereit bist.", italian=" Quando è tutto pronto, andiamo.", spanish=" Seguiremos cuando quieras."})
  end
  -- message_Close
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup. We're all geared up!", french=" Ça y est, on est prêt!", german=" Jep. Wir sind startklar!", italian=" Bene. Allora è tutto pronto!", spanish=" De acuerdo. ¡Listos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! We're all set to go!", french=" Ça y est, on est prêt!", german="Okay! Wir sind bereit\nloszulegen!", italian=" È tutto pronto, allora!", spanish=" De acuerdo. ¡Listos!"})
  else
  SkySceneKit.say({english=" OK. I guess we're ready!", french="Ça y est, on a fini\nnos préparatifs!", german=" Okay. Ich denke, wir sind bereit!", italian=" Ok. Penso sia tutto pronto!", spanish=" De acuerdo. ¡Podemos continuar!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's roll!", french=" C'est bon, on y va!", german=" Alles klar! Packen wir es an!", italian=" Ok! Si va!", spanish=" Muy bien. ¡Vamos allá!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Off we go!", french=" C'est bon, on y va!", german=" Okay! Und los!", italian=" Ok! Andiamo!", spanish=" Muy bien. ¡Vamos allá!"})
  else
  SkySceneKit.say({english=" OK! Let's go!", french=" C'est bon, on y va!", german=" Okay! Gehen wir!", italian=" Va bene! Andiamo!", spanish=" Muy bien. ¡Vamos allá!"})
  end
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(41, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  else
  SkyProg.set(26, 3) -- $SCENARIO_MAIN = scn[26,3] (ROM)
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
