-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D14P11A/m14a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(15, 1) -- $SCENARIO_MAIN = scn[15,1] (ROM)
  -- back_SetGround(LEVEL_D14P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 216, 228, false, 2)
  GROUND:MoveToPosition(hero, 248, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well, we're back!", french=" Bon, nous y voilà!", german=" Tja, wir sind wieder da!", italian=" Beh, eccoci qui!", spanish=" Aquí estamos otra vez."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well, we're back!", french=" Bon, nous y voilà!", german=" Tja, wir sind wieder da!", italian=" Eccoci di nuovo qui!", spanish=" Aquí estamos otra vez."})
  else
  SkySceneKit.say({english=" Well, we're back!", french=" Bon, nous y voilà!", german=" Tja, wir sind wieder da!", italian=" Eccoci di nuovo qui!", spanish=" Ya estamos aquí, otra vez."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But it still seems like there's\nnothing here.", french="Mais on dirait qu'il n'y a toujours\nrien ici.", german="Aber es scheint noch immer\nnichts hier zu sein.", italian="Io continuo a pensare che\nnon ci sia un bel niente qui...", spanish="Pero sigue sin haber nada por\naquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But it still seems like there's\nnothing here.", french="Mais on dirait qu'il n'y a toujours\nrien ici.", german="Aber es scheint noch immer\nnichts hier zu sein.", italian="Continuo a pensare che qui non\nci sia niente...", spanish=" Pero sigo sin ver nada por aquí."})
  else
  SkySceneKit.say({english="But it still seems like there's\nnothing here.", french="Mais on dirait qu'il n'y a toujours\nrien ici.", german="Aber es scheint noch immer\nnichts hier zu sein.", italian="Continuo a pensare che qui non\nci sia niente...", spanish=" Pero sigo sin ver nada por aquí."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Just this white sand stretching\nout in front of us.", french="Juste cette immense étendue\nde sable devant nous.", german="Vor uns ist weit und breit\nnur Sand.", italian="È solo un'immensa distesa di\nsabbia...", spanish="Lo único que veo son dunas ahí\ndelante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Just this white sand stretching\nout in front of us.", french="Juste cette immense étendue\nde sable devant nous.", german="Vor uns ist weit und breit\nnur Sand.", italian="È solo un'immensa distesa di\nsabbia...", spanish="Lo único que veo son dunas ahí\ndelante."})
  else
  SkySceneKit.say({english="Just this white sand stretching\nout in front of us.", french="Juste cette immense étendue\nde sable devant nous.", german="Vor uns ist weit und breit\nnur Sand.", italian="È solo un'immensa distesa di\nsabbia...", spanish="Lo único que veo son dunas ahí\ndelante."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And quicksand pits...[K]obviously!", french="Et évidemment...[K] ces puits\nde sables mouvants!", german="Und Treibsandstrudel...[K] Wie man\nsieht!", italian=" E ovviamente...[K] sabbie mobili!", spanish="Ah, y arenas movedizas...[K]\n¡Cómo no!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And quicksand pits...[K]obviously!", french="Et évidemment...[K] ces puits\nde sables mouvants!", german="Und Treibsandstrudel...[K] Wie man\nsieht!", italian=" E ovviamente...[K] sabbie mobili!", spanish="Ah, y los fosos de arenas\nmovedizas...[K] ¡Evidentemente!"})
  else
  SkySceneKit.say({english=" And quicksand pits...[K]obviously!", french="Et évidemment...[K] ces puits\nde sables mouvants!", german="Und Treibsandstrudel...[K] Wie man\nsieht!", italian=" E ovviamente...[K] sabbie mobili!", spanish="Ah, y los fosos de arenas\nmovedizas...[K] ¡Evidentemente!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is there something more here?", french=" Est-ce qu'il y a autre chose ici?", german=" Gibt es hier sonst noch etwas?", italian="C'è forse qualcosa che mi\nsfugge?", spanish=" ¿Hay algo más?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is there something more here?", french=" Est-ce qu'il y a autre chose ici?", german=" Gibt es hier sonst noch etwas?", italian="C'è forse qualcosa che mi\nsfugge?", spanish=" ¿Hay algo más?"})
  else
  SkySceneKit.say({english=" Is there something more here?", french=" Est-ce qu'il y a autre chose ici?", german=" Gibt es hier sonst noch etwas?", italian="C'è forse qualcosa che mi\nsfugge?", spanish=" ¿Hay algo más?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What kinds of secrets are\nhidden here?", french="Quel genre de secrets se cachent\nici?", german="Welche Geheimnisse sollen hier\nverborgen sein?", italian=" Cosa si nasconde qui?", spanish="¿Qué clase de misterios puede\nocultar este lugar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What kinds of secrets are\nhidden here?", french="Quel genre de secrets se cachent\nici?", german="Welche Geheimnisse sollen hier\nverborgen sein?", italian=" Cosa si nasconde qui?", spanish="¿Qué clase de misterios puede\nocultar este lugar?"})
  else
  SkySceneKit.say({english="What kinds of secrets are\nhidden here?", french="Quel genre de secrets se cachent\nici?", german="Welche Geheimnisse sollen hier\nverborgen sein?", italian=" Cosa si nasconde qui?", spanish="¿Qué clase de misterios puede\nocultar este lugar?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's very faint...)", french="(C'est très léger...)", german="(Es ist sehr schwach...)", italian="(È molto debole...)", spanish="(Es muy tenue...)"})
  else
  SkySceneKit.say({english="(It's very faint...)", french="(C'est très léger...)", german="(Es ist sehr schwach...)", italian="(È molto debole...)", spanish="(Es muy tenue...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But I can still feel it...)", french="(Mais je le sens quand même...)", german="(Aber ich fühle es trotzdem.)", italian="(Eppure quella sensazione è ancora qui...)", spanish="(Pero aún lo siento...)"})
  else
  SkySceneKit.say({english="(But I can still feel it...)", french="(Mais je le sens quand même...)", german="(Aber ich fühle es trotzdem.)", italian="(Eppure quella sensazione è ancora qui...)", spanish="(Pero aún lo siento...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This place...[K]I know it somehow...)", french="(Cet endroit...[K] je le connais...)", german="(Diesen Ort...[K] Ich kenne ihn irgendwoher...)", italian="(Questo posto...[K] in qualche modo, è come se\nlo conoscessi...)", spanish="(Sin duda...[K] conozco este lugar.)"})
  else
  SkySceneKit.say({english="(This place...[K]I know it somehow...)", french="(Cet endroit...[K] je le connais...)", german="(Diesen Ort...[K] Ich kenne ihn irgendwoher...)", italian="(Questo posto...[K] in qualche modo, è come se\nlo conoscessi...)", spanish="(Sin duda...[K] conozco este lugar.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(60)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(60)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But looking out over this...[K] I have to admit\n[partner] is right...)", french="(Mais ceci mis à part...[K] je dois admettre que\n[partner] a raison...)", german="(Aber so, wie es hier aussieht...[K]\nIch muss [partner] recht geben...)", italian="([partner] non ha tutti i torti...)", spanish="(Al ver esto...[K] tengo que admitir que\n[partner] tiene razón...)"})
  else
  SkySceneKit.say({english="(But looking out over this...[K] I have to admit\n[partner] is right...)", french="(Mais ceci mis à part...[K] je dois admettre que\n[partner] a raison...)", german="(Aber so, wie es hier aussieht...[K]\nIch muss [partner] recht geben...)", italian="([partner] non ha tutti i torti...)", spanish="(Al ver esto...[K] tengo que admitir que\n[partner] tiene razón...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There really is nothing here but the desert\nand the quicksand pits...)", french="(Il n'y a vraiment rien d'autre ici que\nle désert et les sables mouvants...)", german="(Hier gibt es wirklich nichts als Wüste\nund Treibsandstrudel.)", italian="(Qui non c'è niente! Solo deserto e sabbie\nmobili...)", spanish="(Aquí no hay nada más que dunas y arenas\nmovedizas.)"})
  else
  SkySceneKit.say({english="(There really is nothing here but the desert\nand the quicksand pits...)", french="(Il n'y a vraiment rien d'autre ici que\nle désert et les sables mouvants...)", german="(Hier gibt es wirklich nichts als Wüste\nund Treibsandstrudel.)", italian="(Qui non c'è niente! Solo deserto e sabbie\nmobili...)", spanish="(Aquí no hay nada más que dunas y arenas\nmovedizas.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And aside from those pits...[K]there's nothing...)", french="(Et à part ça...[K] il n'y a rien d'autre...)", german="(Abgesehen von den Strudeln[K] gibt es nichts...)", italian="(Solo...[K] le sabbie mobili...)", spanish="(Aparte de eso...[K] aquí no hay nada.)"})
  else
  SkySceneKit.say({english="(And aside from those pits...[K]there's nothing...)", french="(Et à part ça...[K] il n'y a rien d'autre...)", german="(Abgesehen von den Strudeln[K] gibt es nichts...)", italian="(Solo...[K] le sabbie mobili...)", spanish="(Aparte de eso...[K] aquí no hay nada.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wait![K] Wait a second...)", french="(Mais![K] Une seconde...)", german="(Warte![K] Eine Sekunde...)", italian="(Ehi![K] Un momento...)", spanish="(¡Un momento![K] Espera un segundo...)"})
  else
  SkySceneKit.say({english="(Wait![K] Wait a second...)", french="(Mais![K] Une seconde...)", german="(Warte![K] Eine Sekunde...)", italian="(Ehi![K] Un momento...)", spanish="(¡Un momento![K] Espera un segundo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If there's only quicksand...)", french="(S'il n'y a que des sables mouvants...)", german="(Wenn es nur Treibsand gibt...)", italian="(Le sabbie mobili...)", spanish="(Si lo único que hay son arenas movedizas...)"})
  else
  SkySceneKit.say({english="(If there's only quicksand...)", french="(S'il n'y a que des sables mouvants...)", german="(Wenn es nur Treibsand gibt...)", italian="(Le sabbie mobili...)", spanish="(Si lo único que hay son arenas movedizas...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's the key to this mystery!)", french="(La voilà la clé du mystère!)", german="(Dann muss das des Rätsels Lösung sein!)", italian="(... devono essere la chiave di tutto!)", spanish="(¡Esa tiene que ser la clave de este misterio!)"})
  else
  SkySceneKit.say({english="(That's the key to this mystery!)", french="(La voilà la clé du mystère!)", german="(Dann muss das des Rätsels Lösung sein!)", italian="(... devono essere la chiave di tutto!)", spanish="(¡Esa tiene que ser la clave de este misterio!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's no way forward...[K]or is there?)", french="(On dirait que c'est un cul-de-sac...[K] mais si\nce n'en était pas un en réalité?)", german="(Es geht hier nicht mehr weiter...[K] Oder?)", italian="(Non c'è modo di proseguire...[K] O forse sì...)", spanish="(No hay ninguna forma de avanzar...[K]\n¿O sí?)"})
  else
  SkySceneKit.say({english="(There's no way forward...[K]or is there?)", french="(On dirait que c'est un cul-de-sac...[K] mais si\nce n'en était pas un en réalité?)", german="(Es geht hier nicht mehr weiter...[K] Oder?)", italian="(Non c'è modo di proseguire...[K] O forse sì...)", spanish="(No hay ninguna forma de avanzar...[K]\n¿O sí?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What do you think? Where\nshould we look, [hero]?", french="Qu'est-ce que tu en penses,\n[hero]? On fait quoi?", german="Was denkst du? Wo sollen\nwir suchen, [hero]?", italian="Cosa ne pensi, [hero]?\nSecondo te dove dovremmo cercare?", spanish="¿Qué te parece?\n¿Dónde tendríamos que buscar, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What do you think? Where\nshould we look, [hero]?", french="Qu'est-ce que tu en penses,\n[hero]? On fait quoi?", german="Was denkst du? Wo sollen\nwir suchen, [hero]?", italian="Cosa ne pensi, [hero]?\nSecondo te dove dovremmo cercare?", spanish="¿Qué opinas?\n¿Dónde tendríamos que buscar, [hero]?"})
  else
  SkySceneKit.say({english="What do you think? Where\nshould we look, [hero]?", french="Qu'est-ce que tu en penses,\n[hero]? On fait quoi?", german="Was denkst du? Wo sollen\nwir suchen, [hero]?", italian="Cosa ne pensi, [hero]?\nSecondo te dove dovremmo cercare?", spanish="¿Qué te parece?\n¿Dónde tendríamos que buscar, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] What did you say?!", french=" Hein?[K] Qu'est-ce que tu dis?!", german=" Äh?[K] Was hast du gesagt?!?", italian=" Eh?[K] Cos'hai detto?!", spanish=" ¿Cómo?[K] ¡¿Qué has dicho?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?[K] What did you say?!", french=" Hein?[K] Qu'est-ce que tu dis?!", german=" Was?[K] Was hast du gesagt?!?", italian=" Cosa?[K] Come dici?", spanish=" ¿Qué?[K] ¡¿Qué has dicho?!"})
  else
  SkySceneKit.say({english=" Pardon?[K] What did you say?!", french=" Hein?[K] Qu'est-ce que tu dis?!", german=" Wie?[K] Was hast du gesagt?!?", italian=" Cosa?[K] Come dici?", spanish=" ¿Cómo?[K] ¡¿Qué has dicho?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You want to dive into the\nquicksand pits?", french="Tu veux qu'on plonge dans\nles sables mouvants?", german="Du willst in die Treibsandstrudel\nspringen?", italian="Ti vuoi buttare nelle sabbie\nmobili? Ma siamo impazziti?", spanish="¿Quieres que nos tiremos a las\narenas movedizas?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You want us to jump into the\nquicksand?!", french="Tu veux qu'on plonge dans\nles sables mouvants?", german="Wir sollen in den Treibsand\nspringen?!?", italian="Vuoi che saltiamo nelle sabbie\nmobili?!", spanish="¿Quieres que nos tiremos a las\narenas movedizas?"})
  else
  SkySceneKit.say({english="You want us to jump into the\nquicksand?!", french="Tu veux qu'on plonge dans\nles sables mouvants?", german="Wir sollen in den Treibsand\nspringen?!?", italian="Vuoi che saltiamo nelle sabbie\nmobili?!", spanish="¿Quieres que nos tiremos a las\narenas movedizas?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you serious, [hero]?!", french="Tu sais ce que tu fais,\n[hero]?!", german="Meinst du das ernst,\n[hero]?!?", italian="[hero]... Mi prendi in\ngiro?", spanish=" ¿Hablas en serio, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you serious, [hero]?!", french="Tu sais ce que tu fais,\n[hero]?!", german="Meinst du das ernst,\n[hero]?!?", italian="Stai parlando sul serio,\n[hero]?", spanish=" ¿Hablas en serio, [hero]?"})
  else
  SkySceneKit.say({english=" Are you serious, [hero]?!", french="Tu sais ce que tu fais,\n[hero]?!", german="Meinst du das ernst,\n[hero]?!?", italian="Stai parlando sul serio,\n[hero]?", spanish=" ¿Hablas en serio, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You really want us to jump in?!", french="Tu veux vraiment qu'on fasse\nle grand saut?!", german="Wir sollen wirklich da\nhineinspringen?!?", italian=" Vuoi davvero che ci buttiamo?", spanish="¿De verdad quieres que saltemos\nahí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Are you seriously suggesting that\nwe should jump in?!", french="Tu veux vraiment qu'on fasse\nle grand saut?!", german="Schlägst du tatsächlich vor,\ndass wir da hineinspringen?!?", italian=" Vuoi davvero che ci buttiamo?", spanish="¿De verdad quieres que saltemos\nahí?"})
  else
  SkySceneKit.say({english="Are you seriously saying that we\nshould jump in?!", french="Tu veux vraiment qu'on fasse\nle grand saut?!", german="Sagst du etwa tatsächlich, dass\nwir da hineinspringen sollen?!?", italian=" Vuoi davvero che ci buttiamo?", spanish="¿De verdad quieres que saltemos\nahí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK, I trust you, [hero].", french="D'accord, je te fais confiance,\n[hero].", german="Okay, ich vertraue dir,\n[hero].", italian=" Va bene, [hero].", spanish=" Vale, confío en ti, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, I trust you, [hero].", french="D'accord, je te fais confiance,\n[hero].", german="Okay, ich vertraue dir,\n[hero].", italian=" Va bene, [hero].", spanish=" Vale, confío en ti, [hero]."})
  else
  SkySceneKit.say({english=" OK, I trust you, [hero].", french="D'accord, je te fais confiance,\n[hero].", german="Okay, ich vertraue dir,\n[hero].", italian=" Va bene, [hero].", spanish=" Vale, confío en ti, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I have faith in you,\n[hero].", french=" J'ai foi en toi, [hero].", german="Ich glaube an dich,\n[hero].", italian=" Io credo in te, [hero].", spanish="[hero], tengo fe ciega en\nti."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I have faith in you,\n[hero].", french=" J'ai foi en toi, [hero].", german="Ich glaube an dich,\n[hero].", italian=" Io credo in te, [hero].", spanish="[hero], tengo fe ciega en\nti."})
  else
  SkySceneKit.say({english="I have faith in you,\n[hero].", french=" J'ai foi en toi, [hero].", german="Ich glaube an dich,\n[hero].", italian=" Io credo in te, [hero].", spanish="[hero], tengo fe ciega en\nti."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's all thanks to you that I've\ncome so far, [hero].", french="C'est uniquement grâce à toi que\nj'ai tenu bon jusqu'ici, [hero].", german="Ich habe es nur dank dir\nso weit geschafft, [hero].", italian="È solo grazie a te, [hero],\nche sono arrivato fino a qui.", spanish="He llegado hasta aquí gracias a\nti, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's all thanks to you that I've\ncome so far, [hero].", french="C'est uniquement grâce à toi que\nj'ai tenu bon jusqu'ici, [hero].", german="Ich habe es nur dank dir\nso weit geschafft, [hero].", italian="È solo grazie a te, [hero],\nche sono arrivato fino a qui.", spanish="He llegado hasta aquí gracias a\nti, [hero]."})
  else
  SkySceneKit.say({english="It's all thanks to you that I've\ncome so far, [hero].", french="C'est uniquement grâce à toi que\nj'ai tenu bon jusqu'ici, [hero].", german="Ich habe es nur dank dir\nso weit geschafft, [hero].", italian="È solo grazie a te, [hero],\nche sono arrivata fino a qui.", spanish="He llegado hasta aquí gracias a\nti, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" During our first exploration...", french="Pendant notre première\nexploration ensemble...", german="Als wir auf unserer ersten\nErkundungstour waren...", italian="Durante la nostra prima\nspedizione...", spanish="En nuestra primera\nexploración..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" During our first exploration...", french="Pendant notre première\nexploration ensemble...", german="Als wir auf unserer ersten\nErkundungstour waren...", italian="Durante la nostra prima\nspedizione...", spanish="En nuestra primera\nexploración..."})
  else
  SkySceneKit.say({english=" During our first exploration...", french="Pendant notre première\nexploration ensemble...", german="Als wir auf unserer ersten\nErkundungstour waren...", italian="Durante la nostra prima\nspedizione...", spanish="En nuestra primera\nexploración..."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 30)
end
