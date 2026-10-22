-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/s21p0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urk![K] When we were back at\nthe guild...", french="Argh![K] Tout à l'heure,\nà la Guilde...", german="Uff![K] Als wir in der\nGilde waren...", italian="Uh![K] Quando eravamo alla\nGilda...", spanish="¡Uf![K] Cuando regresamos al\n[CS:N]Pokégremio[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urk![K] When we were back at\nthe guild...", french="Argh![K] Tout à l'heure,\nà la Guilde...", german="Uff![K] Als wir in der\nGilde waren...", italian="Uh![K] Quando eravamo alla\nGilda...", spanish="¡Uf![K] Cuando regresamos al\n[CS:N]Pokégremio[CR]..."})
  else
  SkySceneKit.say({english="Urk![K] When we were back at\nthe guild...", french="Argh![K] Tout à l'heure,\nà la Guilde...", german="Uff![K] Als wir in der\nGilde waren...", italian="Uh![K] Quando eravamo alla\nGilda...", spanish="¡Uf![K] Cuando regresamos al\n[CS:N]Pokégremio[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Drowzee[CR] asked us if we knew\nhow the distortion of space could be stopped...", french="... quand [CS:N]Soporifik[CR] nous\na demandé si nous savions comment enrayer\nla distorsion de l'espace...", german="Als [CS:N]Traumato[CR] uns fragte, ob wir\nwüssten, wie die Verzerrung des Raumes\naufzuhalten sei...", italian="... [CS:N]Drowzee[CR] ci ha chiesto se\nsapevamo come fermare la distorsione dello\nspazio...", spanish="[CS:N]Drowzee[CR] nos preguntó si\nsabíamos cómo detener la deformación\ndel espacio..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Drowzee[CR] asked us if we knew\nhow the distortion of space could be stopped...", french="... quand [CS:N]Soporifik[CR] nous\na demandé si nous savions comment enrayer\nla distorsion de l'espace...", german="Als [CS:N]Traumato[CR] uns fragte, ob wir\nwüssten, wie die Verzerrung des Raumes\naufzuhalten sei...", italian="... [CS:N]Drowzee[CR] ci ha chiesto se\nsapevamo come fermare la distorsione dello\nspazio...", spanish="[CS:N]Drowzee[CR] nos preguntó si\nsabíamos cómo detener la deformación\ndel espacio..."})
  else
  SkySceneKit.say({english="[CS:N]Drowzee[CR] asked us if we knew\nhow the distortion of space could be stopped...", french="... quand [CS:N]Soporifik[CR] nous\na demandé si nous savions comment enrayer\nla distorsion de l'espace...", german="Als [CS:N]Traumato[CR] uns fragte, ob wir\nwüssten, wie die Verzerrung des Raumes\naufzuhalten sei...", italian="... [CS:N]Drowzee[CR] ci ha chiesto se\nsapevamo come fermare la distorsione dello\nspazio...", spanish="[CS:N]Drowzee[CR] nos preguntó si\nsabíamos cómo detener la deformación\ndel espacio..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I lied! I didn't even think twice\nabout it!", french="... j'ai menti! Sans même\nréfléchir!", german="Ich habe gelogen! Ohne mit der\nWimper zu zucken!", italian="Io ho mentito! Non ci ho\npensato due volte!", spanish=" ¡Le mentí! ¡Ni siquiera dudé!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I lied! I didn't even think twice\nabout it!", french="... j'ai menti! Sans même\nréfléchir!", german="Ich habe gelogen! Ohne mit der\nWimper zu zucken!", italian="Io ho mentito! Non ci ho\npensato due volte!", spanish=" ¡Le mentí! ¡Ni siquiera dudé!"})
  else
  SkySceneKit.say({english="I lied! I didn't even think twice\nabout it!", french="... j'ai menti! Sans même\nréfléchir!", german="Ich habe gelogen! Ohne mit der\nWimper zu zucken!", italian="Io ho mentito! Non ci ho\npensato due volte!", spanish=" ¡Le mentí! ¡Ni siquiera dudé!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="As we know, there is a way to\nstop the distortion!", french="On le sait, il n'y a qu'un seul\nmoyen d'annuler la distorsion!", german="Wie wir wissen, gibt es einen\nWeg, die Verzerrung zu stoppen!", italian="Come ben sappiamo, un modo c'è\nper fermare la distorsione!", spanish="Por lo que sabemos, sí hay un\nmodo de detener la deformación..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="As we know, there is a way to\nstop the distortion!", french="On le sait, il n'y a qu'un seul\nmoyen d'annuler la distorsion!", german="Wie wir wissen, gibt es einen\nWeg, die Verzerrung zu stoppen!", italian="Come ben sappiamo, un modo c'è\nper fermare la distorsione!", spanish="Por lo que sabemos, sí hay un\nmodo de detener la deformación..."})
  else
  SkySceneKit.say({english="As we know, there is a way to\nstop the distortion!", french="On le sait, il n'y a qu'un seul\nmoyen d'annuler la distorsion!", german="Wie wir wissen, gibt es einen\nWeg, die Verzerrung zu stoppen!", italian="Come ben sappiamo, un modo c'è\nper fermare la distorsione!", spanish="Por lo que sabemos, sí hay un\nmodo de detener la deformación..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And that way is for us to\ndisappear from this world.", french="Et pour ça, il faut que nous\ndisparaissions de ce monde.", german="Dazu müssten wir einfach aus\ndieser Welt verschwinden.", italian="Per farlo, dobbiamo sparire da\nquesto mondo.", spanish=" Y es desaparecer de este mundo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The only solution is for us to\ndisappear from this world.", french="Et pour ça, il faut que nous\ndisparaissions de ce monde.", german="Die einzige Lösung wäre, dass\nwir von dieser Welt verschwänden.", italian="Per farlo, dobbiamo sparire da\nquesto mondo.", spanish=" Y es desaparecer de este mundo."})
  else
  SkySceneKit.say({english="We have to disappear from the\nworld to do it.", french="Et pour ça, il faut que nous\ndisparaissions de ce monde.", german="Dazu müssten wir einfach aus\ndieser Welt verschwinden.", italian="Per farlo, dobbiamo sparire da\nquesto mondo.", spanish=" Y es desaparecer de este mundo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="How am I supposed to say\nsomething like that?", french="Je n'ai pas pu leur annoncer\nune chose pareille!", german="Wie hätte ich so etwas nur\nsagen sollen?", italian="Come faccio a dire una cosa\ndel genere?", spanish=" ¿Cómo iba a decir algo así?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I just couldn't bring myself to\nsay it.", french="Je n'ai pas pu leur annoncer\nune chose pareille!", german="Ich konnte mich nicht\nüberwinden, das zu sagen.", italian="Come faccio a dire una cosa\ndel genere?", spanish=" He sido incapaz de decirlo."})
  else
  SkySceneKit.say({english=" How could I say that about us?", french="Je n'ai pas pu leur annoncer\nune chose pareille!", german="Wie hätte ich das über uns\nsagen sollen?", italian="Come faccio a dire una cosa\ndel genere?", spanish=" ¿Cómo iba a decir algo así?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]But...", french=" ...[K] Mais...", german=" ...[K]Aber...", italian=" ...[K] Ma...", spanish=" Pero...[K] Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]But...", french=" ...[K] Mais...", german=" ...[K]Aber...", italian=" ...[K] Ma...", spanish=" Pero...[K] Pero..."})
  else
  SkySceneKit.say({english=" ...[K]But...", french=" ...[K] Mais...", german=" ...[K]Aber...", italian=" ...[K] Ma...", spanish=" Pero...[K] Pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is this a secret that I won't be\nable to hide from everyone?", french="Est-ce que j'aurais vraiment dû\nen parler à tout le monde?", german="Werde ich so ein Geheimnis\ngeheim halten können?", italian=" Finirò col dirlo a tutti?", spanish="A lo mejor debería habérselo\ncontado a todos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is this something I really must\ntell everyone about?", french="Est-ce que j'aurais vraiment dû\nen parler à tout le monde?", german="Ist das etwas, das ich jedem auf\ndie Nase binden muss?", italian="È una cosa che devo\ndavvero rivelare a tutti?", spanish="A lo mejor debería habérselo\ncontado a todos..."})
  else
  SkySceneKit.say({english="Should I have told everyone?\nIs that the right thing to do?", french="Est-ce que j'aurais vraiment dû\nen parler à tout le monde?", german="Hätte ich es allen erzählen\nsollen? Wäre das richtig gewesen?", italian="Dovrei dirlo a tutti?\nÈ la cosa giusta da fare?", spanish="A lo mejor debería habérselo\ncontado a todos..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]Hey, [hero]...", french=" ...[K] Dis, [hero]...", german=" ...[K]Hey, [hero]...", italian=" ...[K] Ehi, [hero].", spanish=" Eh...[K] Oye, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]Hey, [hero]...", french=" ...[K] Dis, [hero]...", german=" ...[K]Hey, [hero]...", italian=" ...[K] Ehi, [hero].", spanish=" Eh...[K] Oye, [hero]..."})
  else
  SkySceneKit.say({english=" ...[K]Hey, [hero]...", french=" ...[K] Dis, [hero]...", german=" ...[K]Hey, [hero]...", italian=" ...[K] Ehi, [hero].", spanish=" Eh...[K] Oye, [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What are we supposed to\ndo now?", french="Qu'est-ce qu'on fait\nmaintenant?", german=" Was sollen wir jetzt bloß tun?", italian=" Cosa facciamo adesso?", spanish=" Y ahora, ¿qué hacemos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What should we do now?", french="Qu'est-ce qu'on fait\nmaintenant?", german="Was sollen wir denn jetzt\nmachen?", italian=" Cosa facciamo adesso?", spanish=" ¿Qué vamos a hacer ahora?"})
  else
  SkySceneKit.say({english="What are we supposed to\ndo now?", french="Qu'est-ce qu'on fait\nmaintenant?", german=" Was sollen wir jetzt bloß tun?", italian=" Cosa facciamo adesso?", spanish=" ¿Qué vamos a hacer ahora?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If we were to disappear...", french=" Si on devait disparaître...", german=" Wenn wir verschwänden...", italian=" Se sparissimo...", spanish=" Si desaparecemos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If we were to disappear...", french=" Si on devait disparaître...", german=" Wenn wir verschwänden...", italian=" Se sparissimo...", spanish=" Si desaparecemos..."})
  else
  SkySceneKit.say({english=" If we were to disappear...", french=" Si on devait disparaître...", german=" Wenn wir verschwänden...", italian=" Se sparissimo...", spanish=" Si desaparecemos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Would the world be saved?", french=" ... le monde serait sauvé?", german=" Ob die Welt dann gerettet wäre?", italian="... pensi che il mondo si\nsalverebbe?", spanish=" ¿Se salvará el mundo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Would the world be saved?", french=" ... le monde serait sauvé?", german=" Ob die Welt dann gerettet wäre?", italian="... pensi che il mondo si\nsalverebbe?", spanish=" ¿Se salvará el mundo?"})
  else
  SkySceneKit.say({english=" Would the world be saved?", french=" ... le monde serait sauvé?", german=" Ob die Welt dann gerettet wäre?", italian="... pensi che il mondo si\nsalverebbe?", spanish=" ¿Se salvará el mundo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...[K]In that case...[K]maybe that's\nthe best thing to do...", french="...[K] Dans ce cas...[K] c'est peut-être\nla meilleure chose à faire...", german="...[K]In diesem Fall...[K] wäre es\nvielleicht das Beste, was wir tun könnten...", italian="...[K] In tal caso...[K] forse sarebbe\nla cosa migliore da fare...", spanish="Si...[K] Si fuera así...[K] Tal vez\nno nos quede otra opción..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...[K]In that case...[K]maybe that's\nthe best thing to do...", french="...[K] Dans ce cas...[K] c'est peut-être\nla meilleure chose à faire...", german="...[K]In diesem Fall...[K] wäre es\nvielleicht das Beste, was wir tun könnten...", italian="...[K] In tal caso...[K] forse sarebbe\nla cosa migliore da fare...", spanish="Entonces...[K] De ser así...[K] quizás\nsea la mejor opción..."})
  else
  SkySceneKit.say({english="...[K]In that case...[K]maybe that's\nthe best thing to do...", french="...[K] Dans ce cas...[K] c'est peut-être\nla meilleure chose à faire...", german="...[K]In diesem Fall...[K] wäre es\nvielleicht das Beste, was wir tun könnten...", italian="...[K] In tal caso...[K] forse sarebbe\nla cosa migliore da fare...", spanish="Entonces...[K] De ser así...[K] quizás\nsea la mejor opción..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Oh, [partner]!)", french="(Oh, [partner]!)", german="(Oh, [partner]!)", italian="(Oh, [partner]!)", spanish="(¡Lo siento, [partner]!)"})
  else
  SkySceneKit.say({english="(Oh, [partner]!)", french="(Oh, [partner]!)", german="(Oh, [partner]!)", italian="(Oh, [partner]!)", spanish="(¡Lo siento, [partner]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Arrgh! I can't take this!", french=" Argh! C'est insupportable!", german=" Arrgh! Ich halte das nicht aus!", italian=" Arrgh! È troppo per me!", spanish="¡Qué impotencia! ¡No lo\nsoporto!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Arrgh! I can't take this!", french=" Argh! C'est insupportable!", german=" Arrgh! Ich halte das nicht aus!", italian=" Arrgh! È troppo per me!", spanish="¡Qué impotencia! ¡No lo\nsoporto!"})
  else
  SkySceneKit.say({english=" Arrgh! I've had enough!", french=" Argh! C'est insupportable!", german=" Arrgh! Ich halte das nicht aus!", italian=" Arrgh! È troppo per me!", spanish="¡Qué impotencia! ¡No lo\nsoporto!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm tired from all this\nworrying...", french="Tous ces soucis m'ont\ncomplètement épuisé...", german=" Ich habe diese Probleme satt...", italian="Non ce la faccio più,\ntutte queste preoccupazioni...", spanish="Me he cansado de tantos\nproblemas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="All this worrying's made me\ntired...", french="Tous ces soucis m'ont\ncomplètement épuisé...", german="All diese Sorgen machen mich\nmüde...", italian="Non ce la faccio più,\ntutte queste preoccupazioni...", spanish="Me he cansado de tantos\nproblemas..."})
  else
  SkySceneKit.say({english="I feel drained from all this\nworrying...", french="Tous ces soucis m'ont\ncomplètement épuisée...", german="Ich fühle mich ausgelaugt von\nden ganzen Sorgen...", italian="Non ce la faccio più,\ntutte queste preoccupazioni...", spanish="Me he cansado de tantos\nproblemas..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get some sleep,\n[hero].", french=" Reposons-nous, [hero].", german="Legen wir uns schlafen,\n[hero].", italian="È meglio andare a dormire,\n[hero].", spanish="Durmamos un rato,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's get some sleep,\n[hero].", french=" Reposons-nous, [hero].", german="Legen wir uns schlafen,\n[hero].", italian="È meglio andare a dormire,\n[hero].", spanish="Durmamos un rato,\n[hero]."})
  else
  SkySceneKit.say({english="Let's get some sleep,\n[hero].", french=" Reposons-nous, [hero].", german="Legen wir uns schlafen,\n[hero].", italian="È meglio andare a dormire,\n[hero].", spanish="Durmamos un rato,\n[hero]."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
