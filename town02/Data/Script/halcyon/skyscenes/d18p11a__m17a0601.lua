-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D18P11A/m17a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Chasm Cave.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you all ready, [hero]?", french=" C'est bon, [hero]?", german=" Bist du fertig, [hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Todo listo, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" C'est bon, [hero]?", german=" Bist du fertig, [hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Todo listo, [hero]?"})
  else
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" C'est bon, [hero]?", german=" Bist du fertig, [hero]?", italian=" È tutto pronto, [hero]?", spanish=" ¿Todo listo, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="All set!", french="On y va!", german="Alles klar!", italian="Tutto pronto!", spanish="¡Ya estoy!"}, {english="Not yet...", french="Pas encore...", german="Noch nicht...", italian="Non ancora...", spanish="Aún no..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll go when you're ready.", french="Préviens-moi quand on peut\ny aller.", german=" Wir gehen, wenn du fertig bist.", italian=" Quando siamo pronti partiamo.", spanish=" Nos iremos cuando tú digas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go when you're ready.", french="Préviens-moi quand on peut\ny aller.", german=" Gehen wir, wenn du fertig bist.", italian=" Quando siamo pronti andiamo.", spanish=" Nos iremos cuando tú digas."})
  else
  SkySceneKit.say({english=" Let's go when you're ready.", french="Préviens-moi quand on peut\ny aller.", german=" Gehen wir, wenn du fertig bist.", italian=" Quando è tutto pronto andiamo.", spanish=" Nos iremos cuando tú digas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get moving before those\n[CS:N]Sableye[CR] come.", french="Partons d'ici avant que\nles [CS:N]Ténéfix[CR] n'arrivent.", german="Hauen wir ab, bevor diese\n[CS:N]Zobiris[CR] kommen.", italian="Muoviamoci prima che arrivino\ni [CS:N]Sableye[CR].", spanish="Vámonos antes de que lleguen\nesos [CS:N]Sableye[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go before those [CS:N]Sableye[CR]\nget here.", french="Partons d'ici avant que\nles [CS:N]Ténéfix[CR] n'arrivent.", german="Verschwinden wir, bevor diese\n[CS:N]Zobiris[CR] da sind.", italian="Andiamo prima che i [CS:N]Sableye[CR]\nci raggiungano.", spanish="Vámonos antes de que lleguen\nesos [CS:N]Sableye[CR]."})
  else
  SkySceneKit.say({english="We should get going before\nthose [CS:N]Sableye[CR] come.", french="Partons d'ici avant que\nles [CS:N]Ténéfix[CR] n'arrivent.", german="Wir sollten verschwinden, bevor\ndiese [CS:N]Zobiris[CR] kommen.", italian="Dobbiamo andarcene prima che\narrivino quei [CS:N]Sableye[CR].", spanish="Vámonos antes de que lleguen\nesos [CS:N]Sableye[CR]."})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's roll!", french=" Allez, c'est parti!", german=" Okay! Nichts wie weg!", italian=" Va bene! Andiamo!", spanish=" ¡Estupendo! ¡Adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Let's go, quick!", french=" Allez, c'est parti!", german=" Okay! Gehen wir, schnell!", italian=" Ok! Andiamo, presto!", spanish=" ¡Estupendo! ¡Adelante!"})
  else
  SkySceneKit.say({english=" Yep! Let's get going!", french=" Allez, c'est parti!", german=" Okay! Machen wir uns davon!", italian=" Bene! Si parte!", spanish=" ¡Estupendo! ¡Adelante!"})
  end
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  -- main_EnterDungeon(27, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
end
