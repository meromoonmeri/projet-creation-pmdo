-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/m20a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 488, 196, false, 2)
  GROUND:MoveToPosition(hero, 536, 196, false, 2)
  GROUND:MoveToPosition(hero, 512, 172, false, 2)
  GROUND:MoveToPosition(partner, 464, 172, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, we just happen to be here\nat the beach, so...", french="Justement, on est au bord de\nla mer, alors...", german="Nun, wir sind zufällig gerade am\nStrand, also...", italian=" Beh, già che siamo in spiaggia...", spanish="Resulta que ya estamos en\nla playa, así que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, we just happen to be here\nat the beach, so...", french="Justement, on est au bord de\nla mer, alors...", german="Nun, wir sind zufällig gerade am\nStrand, also...", italian=" Beh, già che siamo in spiaggia...", spanish="Resulta que ya estamos en\nla playa, así que..."})
  else
  SkySceneKit.say({english="Well, we just happen to be here\nat the beach, so...", french="Justement, on est au bord de\nla mer, alors...", german="Nun, wir sind zufällig gerade am\nStrand, also...", italian=" Beh, già che siamo in spiaggia...", spanish="Resulta que ya estamos en\nla playa, así que..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmm... I'm clueless.", french=" Hmm... Rien ne me vient.", german=" Hmm... Ich habe keine Ahnung.", italian=" Mmm... Non ho nessuna idea.", spanish=" Hum... No tengo ni idea."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmm... This is hopeless.", french=" Hmm... Rien ne me vient.", german=" Hmm... Das ist aussichtslos.", italian=" Mmm... Non abbiamo speranza.", spanish=" Hum... No se me ocurre nada."})
  else
  SkySceneKit.say({english=" Hmm... This isn't working.", french=" Hmm... Rien ne me vient.", german=" Hmm... Das klappt nicht.", italian=" Mmm... Così non può funzionare.", spanish=" Hum... Esto no marcha."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="A way of crossing the sea...\nI'm not coming up with anything.", french="Un moyen de traverser la mer...\nAucune idée.", german="Ein Weg über den Ozean...\nMir kommt nichts in den Sinn.", italian="Un modo per attraversare il\nmare... Non mi viene in mente nulla.", spanish="¿Una forma de cruzar el mar?\nNo se me ocurre ninguna."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="A way of crossing the sea...\nI'm not coming up with anything.", french="Un moyen de traverser la mer...\nAucune idée.", german="Ein Weg über den Ozean...\nMir kommt nichts in den Sinn.", italian="Un modo per attraversare il\nmare... Non mi viene in mente nulla.", spanish="¿Una forma de cruzar el mar?\nNo se me ocurre ninguna."})
  else
  SkySceneKit.say({english="A way of crossing the sea...\nI'm not coming up with anything.", french="Un moyen de traverser la mer...\nAucune idée.", german="Ein Weg über den Ozean...\nMir kommt nichts in den Sinn.", italian="Un modo per attraversare il\nmare... Non mi viene in mente nulla.", spanish="¿Una forma de cruzar el mar?\nNo se me ocurre ninguna."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I said we'd search for the\n[CS:P]Hidden Land[CR], but...", french="J'ai promis qu'on chercherait les\n[CS:P]Terres Illusoires[CR], mais...", german="Ich sagte, wir würden nach dem\n[CS:P]Verborgenen Land[CR] suchen, aber...", italian="Dovremmo cercare la\n[CS:P]Terra Nascosta[CR]...", spanish="Dije que buscaríamos\nla [CS:P]Tierra Oculta[CR], pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I agreed to search for the\n[CS:P]Hidden Land[CR], but...", french="J'ai promis qu'on chercherait les\n[CS:P]Terres Illusoires[CR], mais...", german="Ich habe zugestimmt, nach dem\n[CS:P]Verborgenen Land[CR] zu suchen, aber...", italian="Dovremmo cercare la\n[CS:P]Terra Nascosta[CR]...", spanish="Dije que buscaríamos\nla [CS:P]Tierra Oculta[CR], pero..."})
  else
  SkySceneKit.say({english="I said we'd search for the\n[CS:P]Hidden Land[CR], but...", french="J'ai promis qu'on chercherait les\n[CS:P]Terres Illusoires[CR], mais...", german="Ich sagte, wir würden nach dem\n[CS:P]Verborgenen Land[CR] suchen, aber...", italian="Dovremmo cercare la\n[CS:P]Terra Nascosta[CR]...", spanish="Dije que buscaríamos\nla [CS:P]Tierra Oculta[CR], pero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Where are we supposed to even\nbegin looking?", french="On ne sait même pas où entamer\nles recherches!", german="Wo sollen wir überhaupt mit\nder Suche beginnen?", italian="E io non so neppure da dove\ncominciare!", spanish=" Pero, ¿cómo lo hacemos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Where do you suppose we should\nstart looking?", french="On ne sait même pas où entamer\nles recherches!", german="Wo sollen wir deiner Meinung\nnach mit der Suche beginnen?", italian="E io non so neppure da dove\ncominciare!", spanish=" Pero, ¿cómo lo hacemos?"})
  else
  SkySceneKit.say({english="Where would we even begin\nlooking?", french="On ne sait même pas où entamer\nles recherches!", german="Wo sollen wir denn mit der\nSuche beginnen?", italian="E io non so neppure da dove\ncominciare!", spanish=" Pero, ¿cómo lo hacemos?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We have to hurry too. Ugh!", french="Et en plus, il n'y a pas de temps\nà perdre! Argh!", german="Wir müssen uns auch noch\nbeeilen. Uff!", italian=" Dobbiamo fare in fretta. Oh!", spanish="Y, encima, tenemos que darnos\nprisa. ¡Ay!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And there's no time! Ugh!", french="Et en plus, il n'y a pas de temps\nà perdre! Argh!", german="Und Zeit haben wir auch keine!\nUmpf!", italian=" E non abbiamo più tempo! Oh!", spanish=" ¡Y no hay tiempo! ¡Ay!"})
  else
  SkySceneKit.say({english=" We have to hurry too. Ugh!", french="Et en plus, il n'y a pas de temps\nà perdre! Argh!", german="Wir müssen uns auch noch\nbeeilen. Uff!", italian="Dobbiamo anche fare in fretta.\nOh!", spanish="Y, encima, tenemos que darnos\nprisa. ¡Ay!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's true. We've got too little information\nto go on.)", french="(C'est juste. On n'a pas assez d'informations\npour continuer.)", german="(Es stimmt. Wir haben kaum Informationen,\ndie uns weiterhelfen könnten.)", italian="(È vero. Abbiamo troppe poche informazioni\nper continuare la ricerca.)", spanish="(Es cierto. No tenemos información para\ncontinuar.)"})
  else
  SkySceneKit.say({english="(It's true. We've got too little information\nto go on.)", french="(C'est juste. On n'a pas assez d'informations\npour continuer.)", german="(Es stimmt. Wir haben kaum Informationen,\ndie uns weiterhelfen könnten.)", italian="(È vero. Abbiamo troppe poche informazioni\nper continuare la ricerca.)", spanish="(Es cierto. No tenemos información para\ncontinuar.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And we have no time to waste.)", french="(Et pas de temps à perdre non plus.)", german="(Und wir haben keine Zeit zu verlieren.)", italian="(Non abbiamo tempo da perdere.)", spanish="(Y no hay tiempo que perder.)"})
  else
  SkySceneKit.say({english="(And we have no time to waste.)", french="(Et pas de temps à perdre non plus.)", german="(Und wir haben keine Zeit zu verlieren.)", italian="(Non abbiamo tempo da perdere.)", spanish="(Y no hay tiempo que perder.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We have to locate the [CS:P]Hidden Land[CR] as soon as\npossible.)", french="(On doit localiser les [CS:P]Terres Illusoires[CR] au plus\nvite.)", german="(Wir müssen das [CS:P]Verborgene Land[CR] so schnell\nwie möglich ausfindig machen.)", italian="(Dobbiamo trovare la [CS:P]Terra Nascosta[CR] il più\nin fretta possibile.)", spanish="(Debemos localizar la [CS:P]Tierra Oculta[CR] lo antes\nposible.)"})
  else
  SkySceneKit.say({english="(We have to locate the [CS:P]Hidden Land[CR] as soon as\npossible.)", french="(On doit localiser les [CS:P]Terres Illusoires[CR] au plus\nvite.)", german="(Wir müssen das [CS:P]Verborgene Land[CR] so schnell\nwie möglich ausfindig machen.)", italian="(Dobbiamo trovare la [CS:P]Terra Nascosta[CR] il più\nin fretta possibile.)", spanish="(Debemos localizar la [CS:P]Tierra Oculta[CR] lo antes\nposible.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We have to find [CS:P]Temporal Tower[CR], then put\nthe Time Gears inside it...)", french="(Il faut trouver la [CS:P]Tour du Temps[CR], et remettre\nles Rouages du Temps à leur place...)", german="(Und wir müssen den [CS:P]Zeitturm[CR] finden und\ndann die Zahnräder der Zeit einsetzen.)", italian="(Dobbiamo trovare la [CS:P]Torre del Tempo[CR], e poi\nposizionare gli Ingranaggi del Tempo al suo\ninterno...)", spanish="(Hay que encontrar la [CS:P]Torre del Tiempo[CR] y\ncolocar en ella los Engranajes del Tiempo.)"})
  else
  SkySceneKit.say({english="(We have to find [CS:P]Temporal Tower[CR], then put\nthe Time Gears inside it...)", french="(Il faut trouver la [CS:P]Tour du Temps[CR], et remettre\nles Rouages du Temps à leur place...)", german="(Und wir müssen den [CS:P]Zeitturm[CR] finden und\ndann die Zahnräder der Zeit einsetzen.)", italian="(Dobbiamo trovare la [CS:P]Torre del Tempo[CR], e poi\nposizionare gli Ingranaggi del Tempo al suo\ninterno...)", spanish="(Hay que encontrar la [CS:P]Torre del Tiempo[CR] y\ncolocar en ella los Engranajes del Tiempo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If we fail to do that, our planet will become\nparalyzed.)", french="(Si on échoue, notre planète sera paralysée.)", german="(Wenn uns das nicht gelingt, wird unser Planet\ngelähmt sein.)", italian="(Se falliamo, il nostro pianeta rimarrà\nparalizzato.)", spanish="(Si no lo hacemos, el planeta se paralizará.)"})
  else
  SkySceneKit.say({english="(If we fail to do that, our planet will become\nparalyzed.)", french="(Si on échoue, notre planète sera paralysée.)", german="(Wenn uns das nicht gelingt, wird unser Planet\ngelähmt sein.)", italian="(Se falliamo, il nostro pianeta rimarrà\nparalizzato.)", spanish="(Si no lo hacemos, el planeta se paralizará.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We have to stop that, whatever it takes.)", french="(Il faut qu'on empêche ça, coûte que coûte.)", german="(Wir müssen das um jeden Preis verhindern.)", italian="(Dobbiamo impedirlo, a qualunque costo.)", spanish="(Hay que evitarlo, cueste lo que cueste.)"})
  else
  SkySceneKit.say({english="(We have to stop that, whatever it takes.)", french="(Il faut qu'on empêche ça, coûte que coûte.)", german="(Wir müssen das um jeden Preis verhindern.)", italian="(Dobbiamo impedirlo, a qualunque costo.)", spanish="(Hay que evitarlo, cueste lo que cueste.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And to do that, well...[K]we have no choice!)", french="(Et pour y arriver, ben...[K] on n'a pas le choix!)", german="(Und um das zu tun, nun ja...[K] Wir haben keine\nWahl!)", italian="(E per farlo, beh...[K] non abbiamo altra scelta!)", spanish="(Y para hacerlo...[K] ¡creo que no tenemos\nelección!)"})
  else
  SkySceneKit.say({english="(And to do that, well...[K]we have no choice!)", french="(Et pour y arriver, ben...[K] on n'a pas le choix!)", german="(Und um das zu tun, nun ja...[K] Wir haben keine\nWahl!)", italian="(E per farlo, beh...[K] non abbiamo altra scelta!)", spanish="(Y para hacerlo...[K] ¡creo que no tenemos\nelección!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We need everyone's help.)", french="(On a besoin de toute l'aide qu'on peut\ntrouver.)", german="(Wir brauchen die Hilfe der anderen.)", italian="(Abbiamo bisogno dell'aiuto di tutti.)", spanish="(Necesitamos la ayuda de todos.)"})
  else
  SkySceneKit.say({english="(We need everyone's help.)", french="(On a besoin de toute l'aide qu'on peut\ntrouver.)", german="(Wir brauchen die Hilfe der anderen.)", italian="(Abbiamo bisogno dell'aiuto di tutti.)", spanish="(Necesitamos la ayuda de todos.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's it.[K] I'll tell [partner].)", french="(C'est décidé.[K] Je vais le dire à [partner].)", german="(Das ist es.[K] Ich erzähle es [partner].)", italian="(Certo.[K] Devo dirlo a [partner].)", spanish="(¡Eso es![K] Se lo diré a [partner].)"})
  else
  SkySceneKit.say({english="(That's it.[K] I'll tell [partner].)", french="(C'est décidé.[K] Je vais le dire à [partner].)", german="(Das ist es.[K] Ich erzähle es [partner].)", italian="(Certo.[K] Devo dirlo a [partner].)", spanish="(¡Eso es![K] Se lo diré a [partner].)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hm? What's up, [hero]?", french="Hum? Qu'est-ce qui se passe,\n[hero]?", german=" Hm? Was gibt es, [hero]?", italian=" Eh? Che c'è, [hero]?", spanish=" ¿Sí? ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hm? What is it, [hero]?", french="Hum? Qu'est-ce qui se passe,\n[hero]?", german=" Hm? Was ist los, [hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Sí? ¿Qué pasa, [hero]?"})
  else
  SkySceneKit.say({english=" Hm? What is it, [hero]?", french="Hum? Qu'est-ce qui se passe,\n[hero]?", german=" Hm? Was ist los, [hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Sí? ¿Qué pasa, [hero]?"})
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __choice = SkySceneKit.ask({{english="Let's go to Treasure Town!", french="Allons à Bourg-Trésor!", german="Gehen wir nach Schatzstadt!", italian="Andiamo in città!", spanish="¡Vamos a Aldea Tesoro!"}, {english="Let's go to [CS:N]Wigglytuff[CR]'s Guild!", french="Allons à la Guilde de [CS:N]Grodoudou[CR]!", german="Auf zur [CS:N]Knuddeluff-Gilde[CR]!", italian="Andiamo alla Gilda!", spanish="¡Vamos al [CS:N]Pokégremio[CR]!"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh?! You want to go to\nTreasure Town?!", french="Hein?! Tu veux qu'on aille\nà Bourg-Trésor?!", german="Wie bitte? Du willst nach\nSchatzstadt gehen?", italian="Eh?! Vuoi andare a Borgo\nTesoro?!", spanish="¡¿Qué?!\n¡¿Quieres ir a Aldea Tesoro?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?! You want to go to\nTreasure Town?!", french="Hein?! Tu veux qu'on aille\nà Bourg-Trésor?!", german="Was? Du willst nach Schatzstadt\ngehen?", italian="Cosa?! Vuoi andare a Borgo\nTesoro?!", spanish="¡¿Qué?!\n¡¿Quieres ir a Aldea Tesoro?!"})
  else
  SkySceneKit.say({english="Pardon?! You want to go to\nTreasure Town?!", french="Hein?! Tu veux qu'on aille\nà Bourg-Trésor?!", german="Wie bitte? Du willst nach\nSchatzstadt gehen?", italian="Scusa?! Vuoi andare a Borgo\nTesoro?!", spanish="¡¿Qué?!\n¡¿Quieres ir a Aldea Tesoro?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-why?!", french=" Mais pourquoi?!", german=" W-warum?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-why?!", french=" Mais pourquoi?!", german=" W-warum?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  else
  SkySceneKit.say({english=" Wh-why?!", french=" Mais pourquoi?!", german=" W-warum?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We vanished in front of\neveryone, remember?", french="On a disparu devant tout le\nmonde, tu te souviens?", german="Wir sind vor jedermanns Augen\nverschwunden, erinnerst du dich?", italian="Siamo svaniti davanti agli occhi\ndi tutti, ti ricordi?", spanish="¿No recuerdas que nos\nesfumamos delante de todos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We disappeared in front of\neveryone, remember?", french="On a disparu devant tout le\nmonde, tu te souviens?", german="Wir sind vor jedermanns Augen\nverschwunden, erinnerst du dich?", italian="Siamo scomparsi davanti agli\nocchi di tutti, ti ricordi?", spanish="¿No recuerdas que nos\nesfumamos delante de todos?"})
  else
  SkySceneKit.say({english="We vanished in front of\neveryone, remember?", french="On a disparu devant tout le\nmonde, tu te souviens?", german="Wir sind vor jedermanns Augen\nverschwunden, erinnerst du dich?", italian="Tutti ci hanno visto scomparire,\nti ricordi?", spanish="¿No recuerdas que nos\nesfumamos delante de todos?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think if we suddenly showed\nup, everyone'd be shocked!", french="Si on se montrait d'un seul coup,\nils seraient tous sous le choc!", german="Wenn wir plötzlich auftauchen,\nwerden sich alle furchtbar erschrecken!", italian="Penso che se ricomparissimo\ncosì all'improvviso, rimarrebbero tutti\nscioccati!", spanish="Si reaparecemos de pronto,\n¡nadie va a entenderlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I think if we suddenly showed\nup, everyone would be shocked!", french="Si on se montrait d'un seul coup,\nils seraient tous sous le choc!", german="Wenn wir plötzlich auftauchen,\nwerden sich alle furchtbar erschrecken!", italian="Penso che se ricomparissimo\ncosì all'improvviso, rimarrebbero tutti\nscioccati!", spanish="Si reaparecemos de pronto,\n¡nadie va a entenderlo!"})
  else
  SkySceneKit.say({english="I think if we suddenly showed\nup, everyone would be shocked!", french="Si on se montrait d'un seul coup,\nils seraient tous sous le choc!", german="Wenn wir plötzlich auftauchen,\nwerden sich alle furchtbar erschrecken!", italian="Penso che se ricomparissimo\ncosì all'improvviso, rimarrebbero tutti\nscioccati!", spanish="Si reaparecemos de pronto,\n¡nadie va a entenderlo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But why Treasure Town?[K]\nWhat are we going to do there?", french="Mais pourquoi Bourg-Trésor?[K]\nQu'est-ce qu'on va y faire?", german="Aber warum Schatzstadt?[K]\nWas haben wir da zu schaffen?", italian="Ma perché a Borgo Tesoro?[K]\nCosa ci andiamo a fare?", spanish="Y, ¿por qué Aldea Tesoro?[K]\n¿Qué vamos a hacer allí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But why do you want to go to\nTreasure Town?[K] What are we going to\ndo there?", french="Mais pourquoi Bourg-Trésor?[K]\nQu'est-ce qu'on va y faire?", german="Aber warum willst du nach\nSchatzstadt gehen?[K] Was sollen wir da tun?", italian="Ma perché vuoi andare a Borgo\nTesoro?[K] Cosa ci andiamo a fare?", spanish="Y, ¿por qué Aldea Tesoro?[K]\n¿Qué vamos a hacer allí?"})
  else
  SkySceneKit.say({english="But why Treasure Town?[K]\nWhat are we going to do there?", french="Mais pourquoi Bourg-Trésor?[K]\nQu'est-ce qu'on va y faire?", german="Aber warum Schatzstadt?[K]\nWas haben wir da zu schaffen?", italian="Ma perché a Borgo Tesoro?[K]\nCosa ci andiamo a fare?", spanish="Y, ¿por qué Aldea Tesoro?[K]\n¿Qué vamos a hacer allí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Th-that's true.)", french="(C'est... c'est vrai.)", german="(D-das stimmt.)", italian="(È-È vero.)", spanish="(Es cierto.)"})
  else
  SkySceneKit.say({english="(Th-that's true.)", french="(C'est... c'est vrai.)", german="(D-das stimmt.)", italian="(È-È vero.)", spanish="(Es cierto.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Come to think of it, there isn't much point in\ngoing to Treasure Town.)", french="(Réflexion faite, il n'y a pas de raison qu'on\naille à Bourg-Trésor.)", german="(Nach längerem Nachdenken ergibt es wirklich\nkeinen Sinn, nach Schatzstadt zu gehen.)", italian="(Se ci penso, non ha molto senso andare a\nBorgo Tesoro.)", spanish="(Ahora que lo pienso, no tiene mucho sentido\nir a Aldea Tesoro.)"})
  else
  SkySceneKit.say({english="(Come to think of it, there isn't much point in\ngoing to Treasure Town.)", french="(Réflexion faite, il n'y a pas de raison qu'on\naille à Bourg-Trésor.)", german="(Nach längerem Nachdenken ergibt es wirklich\nkeinen Sinn, nach Schatzstadt zu gehen.)", italian="(Se ci penso, non ha molto senso andare a\nBorgo Tesoro.)", spanish="(Ahora que lo pienso, no tiene mucho sentido\nir a Aldea Tesoro.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What would we possibly do there?)", french="(Qu'est-ce qu'on pourrait bien y faire?)", german="(Was sollten wir dort tun?)", italian="(Cosa potremmo fare là?)", spanish="(¿Qué íbamos a conseguir allí?)"})
  else
  SkySceneKit.say({english="(What would we possibly do there?)", french="(Qu'est-ce qu'on pourrait bien y faire?)", german="(Was sollten wir dort tun?)", italian="(Cosa potremmo fare là?)", spanish="(¿Qué íbamos a conseguir allí?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I flubbed it.[K] I guess that's not what I meant.)", french="(Je dis n'importe quoi.[K] J'imagine que ce n'était\npas ce que je voulais dire.)", german="(Ich habe es verpatzt.[K] Das war wohl nicht,\nwas ich meinte.)", italian="(Sorgerebbero dei problemi.[K] Non sarebbe\nun'idea saggia.)", spanish="(He metido la pata.[K] Creo que eso no era lo\nque quería decir.)"})
  else
  SkySceneKit.say({english="(I flubbed it.[K] I guess that's not what I meant.)", french="(Je dis n'importe quoi.[K] J'imagine que ce n'était\npas ce que je voulais dire.)", german="(Ich habe es verpatzt.[K] Das war wohl nicht,\nwas ich meinte.)", italian="(Sorgerebbero dei problemi.[K] Non sarebbe\nun'idea saggia.)", spanish="(He metido la pata.[K] Creo que eso no era lo\nque quería decir.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? That was a mistake?", french=" Hein? C'était une erreur?", german=" Wie? Das war ein Fehler?", italian=" Eh? È stato un errore?", spanish=" ¿Qué? ¿Que te equivocaste?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? That was a mistake?", french=" Hein? C'était une erreur?", german=" Was? Das war ein Fehler?", italian=" Cosa? È stato un errore?", spanish=" ¿Qué? ¿Que te equivocaste?"})
  else
  SkySceneKit.say({english=" Pardon? That was a mistake?", french=" Hein? C'était une erreur?", german=" Bitte? Das war ein Fehler?", italian=" Scusa? È stato un errore?", spanish=" ¿Qué? ¿Que te equivocaste?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right. Then where were you\ngoing to suggest?", french="D'accord. Alors qu'est-ce que\ntu allais dire?", german="Aha... Was wolltest du denn\ngerade vorschlagen?", italian="Va bene. Allora dove suggerisci\ndi andare?", spanish=" Entonces, ¿qué ibas a sugerir?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK. Then where were you going\nto suggest?", french="D'accord. Alors qu'est-ce que\ntu allais dire?", german="Okay. Was wolltest du denn dann\nvorschlagen?", italian="Ok. Allora dove suggerisci\ndi andare?", spanish="Ah. Entonces, ¿qué ibas a\nsugerir?"})
  else
  SkySceneKit.say({english="OK. Then where were you going\nto suggest?", french="D'accord. Alors qu'est-ce que\ntu allais dire?", german="Okay. Was wolltest du denn dann\nvorschlagen?", italian="Ok. Allora dove suggerisci\ndi andare?", spanish="Bueno, entonces, ¿qué ibas a\nsugerir?"})
  end
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  end
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh?! You want to go to\n[CS:N]Wigglytuff[CR]'s Guild?!", french="Hein?! Tu veux qu'on aille\nà la Guilde de [CS:N]Grodoudou[CR]?!", german="Wie bitte?!? Du willst zur\n[CS:N]Knuddeluff-Gilde[CR] gehen?!?", italian="Eh?! Vuoi andare alla Gilda di\n[CS:N]Wigglytuff[CR]?!", spanish="¡¿Eh?! ¿Quieres que vayamos\nal [CS:N]Pokégremio de Exploradores[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?! You want to go to\n[CS:N]Wigglytuff[CR]'s Guild?!", french="Hein?! Tu veux qu'on aille\nà la Guilde de [CS:N]Grodoudou[CR]?!", german="Wie bitte?!? Du willst zur\n[CS:N]Knuddeluff-Gilde[CR] gehen?!?", italian="Cosa?! Vuoi andare alla Gilda di\n[CS:N]Wigglytuff[CR]?!", spanish="¡¿Eh?! ¿Quieres que vayamos\nal [CS:N]Pokégremio de Exploradores[CR]?"})
  else
  SkySceneKit.say({english="Pardon?! You want to go to\n[CS:N]Wigglytuff[CR]'s Guild?!", french="Hein?! Tu veux qu'on aille\nà la Guilde de [CS:N]Grodoudou[CR]?!", german="Wie bitte?!? Du willst zur\n[CS:N]Knuddeluff-Gilde[CR] gehen?!?", italian="Scusa?! Vuoi andare alla Gilda di\n[CS:N]Wigglytuff[CR]?!", spanish="¡¿Eh?! ¿Quieres que vayamos\nal [CS:N]Pokégremio de Exploradores[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-why?!", french=" Mais pourquoi?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-why?!", french=" Mais pourquoi?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  else
  SkySceneKit.say({english=" Wh-why?!", french=" Mais pourquoi?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We vanished in front of\neveryone, remember?", french="On a disparu devant tout le\nmonde, tu te souviens?", german="Wir sind vor jedermanns Augen\nverschwunden, erinnerst du dich?", italian="Siamo svaniti davanti a tutti,\nricordi?", spanish="Nos esfumamos delante de todos,\n¿o es que no lo recuerdas?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We disappeared in front of\neveryone, remember?", french="On a disparu devant tout le\nmonde, tu te souviens?", german="Wir sind vor jedermanns Augen\nverschwunden, erinnerst du dich?", italian="Siamo scomparsi davanti a tutti,\nricordi?", spanish="Nos esfumamos delante de todos,\n¿o es que no lo recuerdas?"})
  else
  SkySceneKit.say({english="We vanished in front of\neveryone, remember?", french="On a disparu devant tout le\nmonde, tu te souviens?", german="Wir sind vor jedermanns Augen\nverschwunden, erinnerst du dich?", italian="Tutti ci hanno visto scomparire,\nti ricordi?", spanish="Nos esfumamos delante de todos,\n¿o es que no lo recuerdas?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, sure, I bet everyone's\nreally worried about us...", french="Bien sûr, je parie qu'ils sont\ntous très inquiets pour nous...", german="Na gut, ich wette, alle machen\nsich wirklich Sorgen um uns...", italian="Beh, certo, scommetto che sono\ntutti molto preoccupati per noi...", spanish="Aunque, seguramente, todos\nestarán preocupados por nosotros."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, yes, I think everyone\nwould be really worried about us...", french="Bien sûr, je parie qu'ils sont\ntous très inquiets pour nous...", german="Na gut, ich wette, die machen\nsich alle schon ernste Sorgen um uns...", italian="Beh, sì, penso che siano\ntutti molto preoccupati per noi...", spanish="Aunque, seguramente, todos\ndeben de estar preocupados por nosotros."})
  else
  SkySceneKit.say({english="Well, sure, I think everyone\nwould be really worried about us...", french="Bien sûr, je parie qu'ils sont\ntous très inquiets pour nous...", german="Na gut, ich wette, alle machen\nsich wirklich Sorgen um uns...", italian="Beh, certo, penso che siano\ntutti molto preoccupati per noi...", spanish="Aunque, seguramente, todos\ndeben de estar preocupados por nosotros."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And I miss seeing everyone\ntoo...", french="Et ils me manquent beaucoup,\nà moi aussi...", german="Und ich vermisse es auch,\nalle zu sehen...", italian=" Anche a me mancano molto...", spanish=" Y les echo de menos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And I miss everyone too...", french="Et ils me manquent beaucoup,\nà moi aussi...", german="Und ich vermisse alle dort\nauch...", italian=" Anche a me mancano molto...", spanish=" Y les echo de menos..."})
  else
  SkySceneKit.say({english=" And I miss everyone too...", french="Et ils me manquent beaucoup,\nà moi aussi...", german="Und ich vermisse alle dort\nauch...", italian=" Anche a me mancano molto...", spanish=" Y les echo de menos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But everything we saw in\nthe future...", french="Mais tout ce qu'on a appris\ndans le futur...", german="Aber alles, was wir in der\nZukunft gesehen haben...", italian="Tutto quello che abbiamo\nvisto nel futuro...", spanish="Pero todo lo que hemos visto\nen el futuro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But everything we saw in\nthe future...", french="Mais tout ce qu'on a appris\ndans le futur...", german="Aber alles, was wir in der\nZukunft gesehen haben...", italian="Tutto quello che abbiamo\nvisto nel futuro...", spanish="Pero todo lo que hemos visto\nen el futuro..."})
  else
  SkySceneKit.say({english="But everything we saw in\nthe future...", french="Mais tout ce qu'on a appris\ndans le futur...", german="Aber alles, was wir in der\nZukunft gesehen haben...", italian="Tutto quello che abbiamo\nvisto nel futuro...", spanish="Pero todo lo que hemos visto\nen el futuro..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="everything about [CS:N]Grovyle[CR]...[K]\nand about [CS:N]Dusknoir[CR]...", french="... à propos de [CS:N]Massko[CR]...[K]\net de [CS:N]Noctunoir[CR]...", german="Alles über [CS:N]Reptain[CR]...[K]\nund über [CS:N]Zwirrfinst[CR]...", italian=" [CS:N]Grovyle[CR]...[K] [CS:N]Dusknoir[CR]...", spanish="La verdad sobre [CS:N]Grovyle[CR]...[K]\ny sobre [CS:N]Dusknoir[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="everything about [CS:N]Grovyle[CR]...[K]\nand about [CS:N]Dusknoir[CR]...", french="... à propos de [CS:N]Massko[CR]...[K]\net de [CS:N]Noctunoir[CR]...", german="Alles über [CS:N]Reptain[CR]...[K]\nund über [CS:N]Zwirrfinst[CR]...", italian=" [CS:N]Grovyle[CR]...[K] [CS:N]Dusknoir[CR]...", spanish="La verdad sobre [CS:N]Grovyle[CR]...[K]\ny sobre [CS:N]Dusknoir[CR]..."})
  else
  SkySceneKit.say({english="everything about [CS:N]Grovyle[CR]...[K]\nand about [CS:N]Dusknoir[CR]...", french="... à propos de [CS:N]Massko[CR]...[K]\net de [CS:N]Noctunoir[CR]...", german="Alles über [CS:N]Reptain[CR]...[K]\nund über [CS:N]Zwirrfinst[CR]...", italian=" [CS:N]Grovyle[CR]...[K] [CS:N]Dusknoir[CR]...", spanish="La verdad sobre [CS:N]Grovyle[CR]...[K]\ny sobre [CS:N]Dusknoir[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="and even about your past,\n[hero]... If we tell it all to the guild...", french="... et même à propos de ton\npassé, [hero]... Si on leur raconte tout,\nà la Guilde...", german="Und sogar über deine\nVergangenheit, [hero]... Wenn wir das\nalles der Gilde erzählen...", italian="Ciò che abbiamo scoperto\nriguardo al tuo passato, [hero]...\nSe raccontiamo tutto alla Gilda...", spanish="E incluso sobre tu origen,\n[hero]... Si les contamos todo eso..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="and even about your past,\n[hero]... If we tell it all to the guild...", french="... et même à propos de ton\npassé, [hero]... Si on leur raconte tout,\nà la Guilde...", german="Und sogar über deine\nVergangenheit, [hero]... Wenn wir das\nalles der Gilde erzählen...", italian="Ciò che abbiamo scoperto\nriguardo al tuo passato, [hero]...\nSe raccontiamo tutto alla Gilda...", spanish="E incluso sobre tu origen,\n[hero]... Si les contamos todo eso..."})
  else
  SkySceneKit.say({english="and even about your past,\n[hero]... If we tell it all to the guild...", french="... et même à propos de ton\npassé, [hero]... Si on leur raconte tout,\nà la Guilde...", german="Und sogar über deine\nVergangenheit, [hero]... Wenn wir das\nalles der Gilde erzählen...", italian="Ciò che abbiamo scoperto\nriguardo al tuo passato, [hero]...\nSe raccontiamo tutto alla Gilda...", spanish="E incluso sobre tu origen,\n[hero]... Si les contamos todo eso..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" How can they believe us?!", french=" Ils ne nous croiront jamais!", german=" Wie sollen sie uns glauben?", italian=" Non penso che ci crederebbero!", spanish=" ¡¿Cómo van a creernos?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" How can they believe us?!", french=" Ils ne nous croiront jamais!", german=" Wie sollen sie uns glauben?", italian=" Non penso che ci crederebbero!", spanish=" ¡¿Cómo van a creernos?!"})
  else
  SkySceneKit.say({english=" How can they believe us?!", french=" Ils ne nous croiront jamais!", german=" Wie sollen sie uns glauben?", italian=" Non penso che ci crederebbero!", spanish=" ¡¿Cómo van a creernos?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What do you think,\n[hero]?", french="Qu'est-ce que tu en penses,\n[hero]?", german=" Was meinst du, [hero]?", italian="Cosa ne pensi,\n[hero]?", spanish=" ¿Tú qué opinas, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What do you think,\n[hero]?", french="Qu'est-ce que tu en penses,\n[hero]?", german=" Was meinst du, [hero]?", italian="Cosa ne pensi,\n[hero]?", spanish=" ¿Tú qué opinas, [hero]?"})
  else
  SkySceneKit.say({english="What do you think,\n[hero]?", french="Qu'est-ce que tu en penses,\n[hero]?", german=" Was meinst du, [hero]?", italian="Cosa ne pensi,\n[hero]?", spanish=" ¿Tú qué opinas, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Do you think everyone at the\nguild will believe us?", french=" Ils nous croiront, à ton avis?", german="Glaubst du, dass uns alle in der\nGilde glauben werden?", italian="Pensi che alla Gilda si fideranno\ndi noi?", spanish="¿Crees que nuestros amigos del\n[CS:N]Pokégremio[CR] nos creerán?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Do you think everyone at the\nguild will believe us?", french=" Ils nous croiront, à ton avis?", german="Glaubst du, dass uns alle in der\nGilde glauben werden?", italian="Pensi che alla Gilda si fideranno\ndi noi?", spanish="¿Crees que nuestros amigos del\n[CS:N]Pokégremio[CR] nos creerán?"})
  else
  SkySceneKit.say({english="Do you think everyone at the\nguild will believe us?", french=" Ils nous croiront, à ton avis?", german="Glaubst du, dass uns alle in der\nGilde glauben werden?", italian="Pensi che alla Gilda si fideranno\ndi noi?", spanish="¿Crees que nuestros amigos del\n[CS:N]Pokégremio[CR] nos creerán?"})
  end
  do local __choice = SkySceneKit.ask({{english="They'll believe!", french="Oui, ils nous croiront!", german="Sie werden uns glauben!", italian="Si fideranno!", spanish="¡Seguro que sí!"}, {english="I don't know...", french="Pas sûr...", german="Ich weiß es nicht...", italian="Non lo so...", spanish="No lo sé..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...You're right.[K] We can tell\neveryone about what we went through.", french="... Tu as raison.[K] On peut leur\nraconter les épreuves qu'on a traversées.", german="Du hast recht.[K] Wir können allen\nerzählen, was wir durchgemacht haben.", italian="Forse hai ragione.[K] Possiamo\nraccontare a tutti quello che abbiamo vissuto.", spanish="Tienes razón.[K] Podemos contarles\na todos por lo que hemos pasado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...You're right.[K] We can tell\neveryone about what we experienced.", french="... Tu as raison.[K] On peut leur\nraconter les épreuves qu'on a traversées.", german="Du hast recht.[K] Wir können allen\nerzählen, was wir erlebt haben.", italian="Forse hai ragione.[K] Possiamo\nraccontare a tutti quello che abbiamo vissuto.", spanish="Tienes razón.[K] Podemos contarles\na todos por lo que hemos pasado."})
  else
  SkySceneKit.say({english="...You're right.[K] We can tell\neveryone about what we went through.", french="... Tu as raison.[K] On peut leur\nraconter les épreuves qu'on a traversées.", german="Du hast recht.[K] Wir können allen\nerzählen, was wir durchgemacht haben.", italian="Forse hai ragione.[K] Possiamo\nraccontare a tutti quello che abbiamo vissuto.", spanish="Tienes razón.[K] Podemos contarles\na todos por lo que hemos pasado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But there's no telling if they'd\nbelieve us or not.", french="Mais impossible de dire\ns'ils nous croiront ou pas.", german="Aber es ist wirklich nicht zu\nsagen, ob sie uns glauben werden oder nicht.", italian="Ma è impossibile sapere se ci\ncrederanno o no.", spanish="Aunque no hay forma de saber\nsi nos van a creer o no."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But there's no telling if they\nwould believe us or not.", french="Mais impossible de dire\ns'ils nous croiront ou pas.", german="Aber es ist wirklich nicht zu\nsagen, ob sie uns glauben werden oder nicht.", italian="Ma è impossibile sapere se ci\ncrederanno o no.", spanish="Aunque no hay forma de saber\nsi nos van a creer o no."})
  else
  SkySceneKit.say({english="But there's no telling if they\nwould believe us or not.", french="Mais impossible de dire\ns'ils nous croiront ou pas.", german="Aber es ist wirklich nicht zu\nsagen, ob sie uns glauben werden oder nicht.", italian="Ma è impossibile sapere se ci\ncrederanno o no.", spanish="Aunque no hay forma de saber\nsi nos van a creer o no."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I mean, everyone in this world\nis convinced that [CS:N]Grovyle[CR] is the villain.", french="Après tout, tout le monde ici\nest convaincu que c'est [CS:N]Massko[CR] le méchant.", german="Ich meine, jeder in dieser Welt\nist davon überzeugt, dass [CS:N]Reptain[CR] der Böse ist.", italian="Voglio dire, sono tutti convinti\nche il cattivo sia [CS:N]Grovyle[CR].", spanish="Ya que todos están convencidos\nde que [CS:N]Grovyle[CR] es un delincuente."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After all, everyone in this world\nis convinced that [CS:N]Grovyle[CR] is the villain.", french="Après tout, tout le monde ici\nest convaincu que c'est [CS:N]Massko[CR] le méchant.", german="Immerhin sind alle in dieser\nWelt davon überzeugt, dass [CS:N]Reptain[CR] der Böse\nist.", italian="Del resto, sono tutti convinti\nche il cattivo sia [CS:N]Grovyle[CR].", spanish="Ya que todos están convencidos\nde que [CS:N]Grovyle[CR] es un delincuente."})
  else
  SkySceneKit.say({english="I mean, everyone in this world\nis convinced that [CS:N]Grovyle[CR] is the villain.", french="Après tout, tout le monde ici\nest convaincu que c'est [CS:N]Massko[CR] le méchant.", german="Ich meine, jeder in dieser Welt\nist davon überzeugt, dass [CS:N]Reptain[CR] der Böse ist.", italian="Voglio dire, sono tutti convinti\nche il cattivo sia [CS:N]Grovyle[CR].", spanish="Ya que todos están convencidos\nde que [CS:N]Grovyle[CR] es un delincuente."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And they think [CS:N]Dusknoir[CR] is a\nreally good Pokémon.", french="Et ils pensent tous que [CS:N]Noctunoir[CR]\nest de leur côté.", german="Und sie glauben, [CS:N]Zwirrfinst[CR] sei\nein richtig gutes Pokémon.", italian="E pensano che [CS:N]Dusknoir[CR] sia un\nPokémon buono, no?", spanish="Y también creen que [CS:N]Dusknoir[CR]\nes un Pokémon admirable, ¿no es verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And they think [CS:N]Dusknoir[CR] is a\nreally good Pokémon.", french="Et ils pensent tous que [CS:N]Noctunoir[CR]\nest de leur côté.", german="Und sie denken, [CS:N]Zwirrfinst[CR] sei\nein richtig gutes Pokémon.", italian="E pensano che [CS:N]Dusknoir[CR] sia un\nPokémon buono, no?", spanish="Y también creen que [CS:N]Dusknoir[CR]\nes un Pokémon admirable, ¿no es verdad?"})
  else
  SkySceneKit.say({english="And they think [CS:N]Dusknoir[CR] is a\nreally good Pokémon.", french="Et ils pensent tous que [CS:N]Noctunoir[CR]\nest de leur côté.", german="Und sie glauben, [CS:N]Zwirrfinst[CR] sei\nein richtig gutes Pokémon.", italian="E pensano che [CS:N]Dusknoir[CR] sia un\nPokémon buono, no?", spanish="Y también creen que [CS:N]Dusknoir[CR]\nes un Pokémon admirable, ¿no es verdad?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Everyone especially thinks highly\nof [CS:N]Dusknoir[CR].", french="Ils se font tous une haute\nopinion de [CS:N]Noctunoir[CR].", german="Jeder hat eine besonders hohe\nMeinung von [CS:N]Zwirrfinst[CR].", italian="Pensano tutti grandi cose di\n[CS:N]Dusknoir[CR].", spanish="Todos tienen un gran concepto\nde [CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Everyone especially thinks highly\nof [CS:N]Dusknoir[CR].", french="Ils se font tous une haute\nopinion de [CS:N]Noctunoir[CR].", german="Jeder hat eine besonders hohe\nMeinung von [CS:N]Zwirrfinst[CR].", italian="Pensano tutti grandi cose di\n[CS:N]Dusknoir[CR].", spanish="Todos tienen un gran concepto\nde [CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english="Everyone especially respects\n[CS:N]Dusknoir[CR].", french="Ils se font tous une haute\nopinion de [CS:N]Noctunoir[CR].", german="Jeder hat besonderen Respekt\nvor [CS:N]Zwirrfinst[CR].", italian="Pensano tutti grandi cose di\n[CS:N]Dusknoir[CR].", spanish="Todo el mundo respeta a\n[CS:N]Dusknoir[CR] muchísimo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I saw the future...[K] But I still\ndidn't want to believe the truth about [CS:N]Dusknoir[CR].", french="J'ai vu le futur de mes propres\nyeux...[K] Et pourtant, j'ai encore du mal\nà accepter la vérité au sujet de [CS:N]Noctunoir[CR].", german="Ich habe die Zukunft gesehen...[K]\nAber ich wollte die Wahrheit über [CS:N]Zwirrfinst[CR]\nimmer noch nicht glauben.", italian="Io ho visto il futuro,[K] ma stento\nancora a credere che quella fosse la vera\nnatura di [CS:N]Dusknoir[CR].", spanish="Yo vi el futuro con mis propios\nojos...[K] Y me costó aceptar la verdad sobre\n[CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I saw the future...[K] But I still\ndidn't want to believe the truth about [CS:N]Dusknoir[CR].", french="J'ai vu le futur de mes propres\nyeux...[K] Et pourtant, j'ai encore du mal\nà accepter la vérité au sujet de [CS:N]Noctunoir[CR].", german="Ich habe die Zukunft gesehen...[K]\nAber ich wollte die Wahrheit über [CS:N]Zwirrfinst[CR]\nimmer noch nicht glauben.", italian="Io ho visto il futuro,[K] ma stento\nancora a credere che quella fosse la vera\nnatura di [CS:N]Dusknoir[CR].", spanish="Yo vi el futuro con mis propios\nojos...[K] Y me costó aceptar la verdad sobre\n[CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english="I saw the future...[K] But I still\ndidn't want to believe the truth about [CS:N]Dusknoir[CR].", french="J'ai vu le futur de mes propres\nyeux...[K] Et pourtant, j'ai encore du mal\nà accepter la vérité au sujet de [CS:N]Noctunoir[CR].", german="Ich habe die Zukunft gesehen...[K]\nAber ich wollte die Wahrheit über [CS:N]Zwirrfinst[CR]\nimmer noch nicht glauben.", italian="Io ho visto il futuro,[K] ma stento\nancora a credere che quella fosse la vera\nnatura di [CS:N]Dusknoir[CR].", spanish="Yo vi el futuro con mis propios\nojos...[K] Y me costó aceptar la verdad sobre\n[CS:N]Dusknoir[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we tell everyone the truth,\nI wonder if they'd be able to accept it.", french="Même si on leur dit la vérité,\nje ne sais pas s'ils seront capables\nde l'accepter.", german="Ich frage mich, ob sie sie\nakzeptieren könnten, wenn wir allen die\nWahrheit sagen würden.", italian="Se decidiamo di dire a tutti la\nverità, saranno in grado di accettarla?", spanish="Aunque les contemos la verdad,\ndudo que puedan aceptarla."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Even if we were to tell\neveryone the truth, I wonder if they would be\nable to accept it.", french="Même si on leur dit la vérité,\nje ne sais pas s'ils seront capables\nde l'accepter.", german="Ob sie sie akzeptieren könnten,\nwenn wir allen die Wahrheit sagen würden?", italian="Se decidiamo di dire a tutti la\nverità, saranno in grado di accettarla?", spanish="Aunque les contemos la verdad,\ndudo que puedan aceptarla."})
  else
  SkySceneKit.say({english="If we tell everyone the truth,\nI wonder if they would be able to accept it.", french="Même si on leur dit la vérité,\nje ne sais pas s'ils seront capables\nde l'accepter.", german="Ich frage mich, ob sie sie\nakzeptieren könnten, wenn wir allen die\nWahrheit sagen würden.", italian="Se decidiamo di dire a tutti la\nverità, saranno in grado di accettarla?", spanish="Aunque les contemos la verdad,\ndudo que puedan aceptarla."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So you think they'll believe us!", french="Donc tu penses qu'ils nous\ncroiront!", german="Du denkst, sie werden uns\nglauben!", italian=" Lo credi davvero, allora!", spanish=" ¿Piensas que nos creerán?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You think they'll believe us!", french="Donc tu penses qu'ils nous\ncroiront!", german="Du denkst, sie werden uns\nglauben!", italian=" Pensi che si fideranno!", spanish=" ¿Piensas que nos creerán?"})
  else
  SkySceneKit.say({english=" You think they'll believe us!", french="Donc tu penses qu'ils nous\ncroiront!", german="Du denkst, sie werden uns\nglauben!", italian=" Pensi che si fideranno!", spanish=" ¿Piensas que nos creerán?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well...[K] You say that,\n[hero], but...", french="Ben...[K] je veux bien,\n[hero], mais...", german="Nun...[K] Das sagst du so,\n[hero], aber...", italian="Beh...[K] Tu dici così,\n[hero], ma...", spanish="Bueno...[K] A ti puede parecértelo,\n[hero], pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well...[K] You say that,\n[hero], but...", french="Ben...[K] je veux bien,\n[hero], mais...", german="Nun...[K] Das sagst du so,\n[hero], aber...", italian="Beh...[K] Tu dici così,\n[hero], ma...", spanish="Bueno...[K] A ti puede parecértelo,\n[hero], pero..."})
  else
  SkySceneKit.say({english="Well...[K] You say that,\n[hero], but...", french="Ben...[K] je veux bien,\n[hero], mais...", german="Nun...[K] Das sagst du so,\n[hero], aber...", italian="Beh...[K] Tu dici così,\n[hero], ma...", spanish="Bueno...[K] A ti puede parecértelo,\n[hero], pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is there a chance they'll\nbelieve us?", french="Est-ce qu'il y a une chance\nqu'ils croient à notre histoire?", german="Gibt es eine Chance, dass sie\nuns glauben?", italian="C'è davvero qualche possibilità\nche ci credano?", spanish=" ¿Cómo van a creernos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is there a chance they'll\nbelieve us?", french="Est-ce qu'il y a une chance\nqu'ils croient à notre histoire?", german="Gibt es eine Chance, dass sie\nuns glauben?", italian="C'è davvero qualche possibilità\nche ci credano?", spanish=" ¿Cómo van a creernos?"})
  else
  SkySceneKit.say({english="Is there a chance they'll\nbelieve us?", french="Est-ce qu'il y a une chance\nqu'ils croient à notre histoire?", german="Gibt es eine Chance, dass sie\nuns glauben?", italian="C'è davvero qualche possibilità\nche ci credano?", spanish=" ¿Cómo van a creernos?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I mean, everyone in this world\nis convinced that [CS:N]Grovyle[CR] is the villain.", french="Après tout, tout le monde ici\nest convaincu que c'est [CS:N]Massko[CR] le méchant.", german="Ich meine, jeder in dieser Welt\nist davon überzeugt, dass [CS:N]Reptain[CR] der Böse ist.", italian="Voglio dire, sono tutti convinti\nche il cattivo sia [CS:N]Grovyle[CR].", spanish="Todos están convencidos de que\n[CS:N]Grovyle[CR] es un delincuente."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After all, everyone in this world\nis convinced that [CS:N]Grovyle[CR] is the villain.", french="Après tout, tout le monde ici\nest convaincu que c'est [CS:N]Massko[CR] le méchant.", german="Immerhin sind alle in dieser\nWelt davon überzeugt, dass [CS:N]Reptain[CR] der Böse\nist.", italian="Del resto, sono tutti convinti\nche il cattivo sia [CS:N]Grovyle[CR].", spanish="Todos están convencidos de que\n[CS:N]Grovyle[CR] es un delincuente."})
  else
  SkySceneKit.say({english="I mean, everyone in this world\nis convinced that [CS:N]Grovyle[CR] is the villain.", french="Après tout, tout le monde ici\nest convaincu que c'est [CS:N]Massko[CR] le méchant.", german="Ich meine, jeder in dieser Welt\nist davon überzeugt, dass [CS:N]Reptain[CR] der Böse ist.", italian="Voglio dire, sono tutti convinti\nche il cattivo sia [CS:N]Grovyle[CR].", spanish="Todos están convencidos de que\n[CS:N]Grovyle[CR] es un delincuente."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And they think [CS:N]Dusknoir[CR] is a\nreally good Pokémon, right?", french="Et ils pensent tous que [CS:N]Noctunoir[CR]\nest de leur côté, pas vrai?", german="Und sie glauben, [CS:N]Zwirrfinst[CR] sei\nein richtig gutes Pokémon, nicht wahr?", italian="E pensano che [CS:N]Dusknoir[CR] sia un\nPokémon buono, no?", spanish="Y también creen que [CS:N]Dusknoir[CR]\nes un Pokémon admirable, ¿no es verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And they think [CS:N]Dusknoir[CR] is a\nreally good Pokémon, don't they?", french="Et ils pensent tous que [CS:N]Noctunoir[CR]\nest de leur côté, pas vrai?", german="Und sie glauben, [CS:N]Zwirrfinst[CR] sei\nein richtig gutes Pokémon, nicht wahr?", italian="E pensano che [CS:N]Dusknoir[CR] sia un\nPokémon buono, no?", spanish="Y también creen que [CS:N]Dusknoir[CR]\nes un Pokémon admirable, ¿no es verdad?"})
  else
  SkySceneKit.say({english="And they think [CS:N]Dusknoir[CR] is a\nreally good Pokémon, right?", french="Et ils pensent tous que [CS:N]Noctunoir[CR]\nest de leur côté, pas vrai?", german="Und sie glauben, [CS:N]Zwirrfinst[CR] sei\nein richtig gutes Pokémon, nicht wahr?", italian="E pensano che [CS:N]Dusknoir[CR] sia un\nPokémon buono, no?", spanish="Y también creen que [CS:N]Dusknoir[CR]\nes un Pokémon admirable, ¿no es verdad?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Everyone especially thinks highly\nof [CS:N]Dusknoir[CR].", french="Ils se font tous une haute\nopinion de [CS:N]Noctunoir[CR].", german="Jeder hat eine besonders hohe\nMeinung von [CS:N]Zwirrfinst[CR].", italian="Pensano tutti grandi cose di\n[CS:N]Dusknoir[CR].", spanish="Todos tienen un gran concepto\nde [CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Everyone especially thinks highly\nof [CS:N]Dusknoir[CR].", french="Ils se font tous une haute\nopinion de [CS:N]Noctunoir[CR].", german="Jeder hat eine besonders hohe\nMeinung von [CS:N]Zwirrfinst[CR].", italian="Pensano tutti grandi cose di\n[CS:N]Dusknoir[CR].", spanish="Todos tienen un gran concepto\nde [CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english="Everyone especially respects\n[CS:N]Dusknoir[CR].", french="Ils se font tous une haute\nopinion de [CS:N]Noctunoir[CR].", german="Jeder hat besonderen Respekt\nvor [CS:N]Zwirrfinst[CR].", italian="Pensano tutti grandi cose di\n[CS:N]Dusknoir[CR].", spanish="Todo el mundo respeta a\n[CS:N]Dusknoir[CR] muchísimo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I saw the future...[K] But I still\ndidn't want to believe the truth about [CS:N]Dusknoir[CR].", french="J'ai vu le futur de mes propres\nyeux...[K] Et pourtant, j'ai encore du mal\nà accepter la vérité au sujet de [CS:N]Noctunoir[CR].", german="Ich habe die Zukunft gesehen...[K]\nAber ich wollte die Wahrheit über [CS:N]Zwirrfinst[CR]\nimmer noch nicht glauben.", italian="Io ho visto il futuro,[K] ma stento\nancora a credere che quella fosse la vera\nnatura di [CS:N]Dusknoir[CR].", spanish="Yo vi el futuro con mis propios\nojos...[K] Y me costó aceptar la verdad sobre\n[CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I saw the future...[K] But I still\ndidn't want to believe the truth about [CS:N]Dusknoir[CR].", french="J'ai vu le futur de mes propres\nyeux...[K] Et pourtant, j'ai encore du mal\nà accepter la vérité au sujet de [CS:N]Noctunoir[CR].", german="Ich habe die Zukunft gesehen...[K]\nAber ich wollte die Wahrheit über [CS:N]Zwirrfinst[CR]\nimmer noch nicht glauben.", italian="Io ho visto il futuro,[K] ma stento\nancora a credere che quella fosse la vera\nnatura di [CS:N]Dusknoir[CR].", spanish="Yo vi el futuro con mis propios\nojos...[K] Y me costó aceptar la verdad sobre\n[CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english="I saw the future...[K] But I still\ndidn't want to believe the truth about [CS:N]Dusknoir[CR].", french="J'ai vu le futur de mes propres\nyeux...[K] Et pourtant, j'ai encore du mal\nà accepter la vérité au sujet de [CS:N]Noctunoir[CR].", german="Ich habe die Zukunft gesehen...[K]\nAber ich wollte die Wahrheit über [CS:N]Zwirrfinst[CR]\nimmer noch nicht glauben.", italian="Io ho visto il futuro,[K] ma stento\nancora a credere che quella fosse la vera\nnatura di [CS:N]Dusknoir[CR].", spanish="Yo vi el futuro con mis propios\nojos...[K] Y me costó aceptar la verdad sobre\n[CS:N]Dusknoir[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we tell everyone the truth,\nI wonder if they'd be able to accept it.", french="Même si on leur dit la vérité,\nje ne sais pas s'ils seront capables\nde l'accepter.", german="Ich frage mich, ob sie sie\nakzeptieren könnten, wenn wir allen die\nWahrheit sagen würden.", italian="Se decidiamo di dire a tutti la\nverità, saranno in grado di accettarla?", spanish="Aunque les contemos la verdad,\ndudo que puedan aceptarla."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Even if we were to tell\neveryone the truth, I wonder if they would be\nable to accept it.", french="Même si on leur dit la vérité,\nje ne sais pas s'ils seront capables\nde l'accepter.", german="Ob sie sie akzeptieren könnten,\nwenn wir allen die Wahrheit sagen würden?", italian="Se decidiamo di dire a tutti la\nverità, saranno in grado di accettarla?", spanish="Aunque les contemos la verdad,\ndudo que puedan aceptarla."})
  else
  SkySceneKit.say({english="If we tell everyone the truth,\nI wonder if they would be able to accept it.", french="Même si on leur dit la vérité,\nje ne sais pas s'ils seront capables\nde l'accepter.", german="Ich frage mich, ob sie sie\nakzeptieren könnten, wenn wir allen die\nWahrheit sagen würden.", italian="Se decidiamo di dire a tutti la\nverità, saranno in grado di accettarla?", spanish="Aunque les contemos la verdad,\ndudo que puedan aceptarla."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_5 [étiquette de flux ExplorerScript]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's true.)", french="(C'est juste.)", german="(Es stimmt.)", italian="(È vero.)", spanish="(Es verdad.)"})
  else
  SkySceneKit.say({english="(It's true.)", french="(C'est juste.)", german="(Es stimmt.)", italian="(È vero.)", spanish="(Es verdad.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What [partner] is saying is true.)", french="([partner] a raison.)", german="(Was [partner] sagt, stimmt.)", italian="([partner] ha perfettamente ragione.)", spanish="(Lo que dice [partner] es verdad.)"})
  else
  SkySceneKit.say({english="(What [partner] is saying is true.)", french="([partner] a raison.)", german="(Was [partner] sagt, stimmt.)", italian="([partner] ha perfettamente ragione.)", spanish="(Lo que dice [partner] es verdad.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe no one will believe us if we tell them\nthe truth.)", french="(Peut-être que personne ne nous croira,\nsi on dit la vérité.)", german="(Vielleicht glaubt uns niemand, wenn wir\nihnen die Wahrheit sagen.)", italian="(Forse se raccontiamo la verità non ci crederà\nnessuno.)", spanish="(Puede que nadie nos crea.)"})
  else
  SkySceneKit.say({english="(Maybe no one will believe us if we tell them\nthe truth.)", french="(Peut-être que personne ne nous croira,\nsi on dit la vérité.)", german="(Vielleicht glaubt uns niemand, wenn wir\nihnen die Wahrheit sagen.)", italian="(Forse se raccontiamo la verità non ci crederà\nnessuno.)", spanish="(Puede que nadie nos crea.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But...!)", french="(Pourtant...!)", german="(Aber!)", italian="(Ma...!)", spanish="(Sí, pero...)"})
  else
  SkySceneKit.say({english="(But...!)", french="(Pourtant...!)", german="(Aber!)", italian="(Ma...!)", spanish="(Sí, pero...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...Huh?! But we should tell them\nanyway?", french="... Hein?! On devrait tout leur\nraconter quand même?", german="...Hmm? Wir sollten es ihnen\ntrotzdem erzählen?", italian="Eh?! Dici che dovremmo\ndirglielo lo stesso?", spanish="¡¿Qué?! ¿Que deberíamos\ndecírselo de todos modos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...What?! We should tell them\nanyway?", french="... Hein?! On devrait tout leur\nraconter quand même?", german="...Was?!? Wir sollten es ihnen\ntrotzdem erzählen?", italian="Eh?! Dici che dovremmo\ndirglielo lo stesso?", spanish="¡¿Qué?! ¿Que deberíamos\ndecírselo de todos modos?"})
  else
  SkySceneKit.say({english="...Pardon?! We should tell them\nanyway?", french="... Hein?! On devrait tout leur\nraconter quand même?", german="...Wie bitte?!? Wir sollten es\nihnen trotzdem erzählen?", italian="Eh?! Dici che dovremmo\ndirglielo lo stesso?", spanish="¡¿Qué?! ¿Que deberíamos\ndecírselo de todos modos?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-why?!", french=" Pourquoi ça?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-why?!", french=" Pourquoi ça?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  else
  SkySceneKit.say({english=" Wh-why?!", french=" Pourquoi ça?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They might not believe us,\nright?", french="Ils ne nous croiront peut-être\npas, tu sais?", german="Sie würden uns vielleicht nicht\nglauben, richtig?", italian=" Potrebbero non crederci, giusto?", spanish="Es muy probable que no nos\ncrean."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They might not believe us,\nright?", french="Ils ne nous croiront peut-être\npas, tu sais?", german="Sie würden uns vielleicht nicht\nglauben, richtig?", italian=" Potrebbero non crederci, giusto?", spanish="¿No te parece que hay muchas\nprobabilidades de que no nos crean?"})
  else
  SkySceneKit.say({english="They might not believe us,\nright?", french="Ils ne nous croiront peut-être\npas, tu sais?", german="Sie würden uns vielleicht nicht\nglauben, richtig?", italian=" Potrebbero non crederci, giusto?", spanish="¿Eres consciente de que podrían\nno creernos?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But we should tell them anyway?", french="Pourtant, tu penses qu'on devrait\nquand même tout leur dire?", german="Aber wir sollten es ihnen\ntrotzdem erzählen?", italian="Ma dovremmo dirglielo\ncomunque?", spanish="¿Aun así quieres contárselo\ntodo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But we should tell them anyway?", french="Pourtant, tu penses qu'on devrait\nquand même tout leur dire?", german="Aber wir sollten es ihnen\ntrotzdem erzählen?", italian="Ma dovremmo dirglielo\ncomunque?", spanish="¿Quieres contárselo de todos\nmodos?"})
  else
  SkySceneKit.say({english=" But we should tell them anyway?", french="Pourtant, tu penses qu'on devrait\nquand même tout leur dire?", german="Aber wir sollten es ihnen\ntrotzdem erzählen?", italian="Ma dovremmo dirglielo\ncomunque?", spanish="¿Quieres contárselo de todos\nmodos?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes! Tell them!", french="Oui! Racontons-leur!", german="Ja! Erzählen wir es ihnen!", italian="Sì! Dobbiamo dirglielo!", spanish="¡Sí! ¡Hay que decirles la verdad!"}}) -- message_SwitchMenu(0, 1) ROM
  if true then -- default
  end
  end
  -- @label_6 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-why?!", french=" Pourquoi ça?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-why?!", french=" Pourquoi ça?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  else
  SkySceneKit.say({english=" Wh-why?!", french=" Pourquoi ça?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" Pero, ¿por qué?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What makes you think that way,\n[hero]?", french="Qu'est-ce qui te fait penser ça,\n[hero]?", german="Warum denkst du so,\n[hero]?", italian="Cosa ti fa pensare che sia la\ncosa giusta da fare, [hero]?", spanish="¿Qué te hace pensar así,\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Why do you think so,\n[hero]?", french="Qu'est-ce qui te fait penser ça,\n[hero]?", german="Wie kommst du darauf,\n[hero]?", italian="Cosa ti fa pensare che sia la\ncosa giusta da fare, [hero]?", spanish="¿Qué te hace pensar así,\n[hero]?"})
  else
  SkySceneKit.say({english="Why do you think so,\n[hero]?", french="Qu'est-ce qui te fait penser ça,\n[hero]?", german="Wie kommst du darauf,\n[hero]?", italian="Cosa ti fa pensare che sia la\ncosa giusta da fare, [hero]?", spanish="¿Qué te hace pensar así,\n[hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="We need everyone's help!", french="On a besoin de leur aide!", german="Wir brauchen jedermanns Hilfe!", italian="Ci serve l'aiuto di tutti!", spanish="¡Necesitamos la ayuda de todos!"}}) -- message_SwitchMenu(0, 1) ROM
  if true then -- default
  end
  end
  -- @label_7 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_ON_THE_BEACH_AT_DUSK non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Everyone's help...", french=" On a besoin de leur aide...", german=" Jedermanns Hilfe...", italian=" L'aiuto di tutti...", spanish=" La ayuda de todos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Everyone's help...", french=" On a besoin de leur aide...", german=" Jedermanns Hilfe...", italian=" L'aiuto di tutti...", spanish=" La ayuda de todos..."})
  else
  SkySceneKit.say({english=" Everyone's help...", french=" On a besoin de leur aide...", german=" Jedermanns Hilfe...", italian=" L'aiuto di tutti...", spanish=" La ayuda de todos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...[K]I get it.[K] We can't find the\n[CS:P]Hidden Land[CR] on our own.", french="...[K] Je comprends.[K] On n'a aucune\nchance de trouver les [CS:P]Terres Illusoires[CR]\nsans aide.", german="...[K]Ich habe es kapiert.[K] Wir\nkönnen das [CS:P]Verborgene Land[CR] nicht allein\nfinden.", italian="...[K] Ora ci sono.[K] Non possiamo\ntrovare la [CS:P]Terra Nascosta[CR] solo con le nostre\nforze.", spanish="Sí...[K] Ahora lo entiendo.[K]\nNo podemos encontrar solos la [CS:P]Tierra Oculta[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...[K]I understand.[K] We can't find the\n[CS:P]Hidden Land[CR] on our own.", french="...[K] Je comprends.[K] On n'a aucune\nchance de trouver les [CS:P]Terres Illusoires[CR]\nsans aide.", german="...[K]Ich verstehe.[K] Wir\nkönnen das [CS:P]Verborgene Land[CR] nicht allein\nfinden.", italian="...[K] Ho capito.[K] Non possiamo\ntrovare la [CS:P]Terra Nascosta[CR] solo con le nostre\nforze.", spanish="Sí...[K] Ahora lo entiendo.[K]\nNo podemos encontrar solos la [CS:P]Tierra Oculta[CR]."})
  else
  SkySceneKit.say({english="...[K]I get it.[K] There's no way we\ncan find the [CS:P]Hidden Land[CR] on our own.", french="...[K] Je comprends.[K] On n'a aucune\nchance de trouver les [CS:P]Terres Illusoires[CR]\nsans aide.", german="...[K]Ich habe es kapiert.[K] Wir\nkönnen das [CS:P]Verborgene Land[CR] unmöglich allein\nfinden.", italian="...[K] Ora ci sono.[K] Non possiamo\ntrovare la [CS:P]Terra Nascosta[CR] solo con le nostre\nforze.", spanish="Sí...[K] Ahora lo entiendo.[K]\nNo podemos encontrar la [CS:P]Tierra Oculta[CR] solo\ncon nuestros propios medios."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We do need everyone's help.", french="On a en effet besoin de l'aide\nde tout le monde.", german="Wir brauchen wirklich\njedermanns Hilfe.", italian="Sì, abbiamo bisogno dell'aiuto di\ntutti.", spanish=" Necesitamos la ayuda de todos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We do need everyone's help.", french="On a en effet besoin de l'aide\nde tout le monde.", german="Wir brauchen wirklich\njedermanns Hilfe.", italian="Sì, abbiamo bisogno dell'aiuto di\ntutti.", spanish=" Necesitamos la ayuda de todos."})
  else
  SkySceneKit.say({english=" We do need everyone's help.", french="On a en effet besoin de l'aide\nde tout le monde.", german="Wir brauchen wirklich\njedermanns Hilfe.", italian="Sì, abbiamo bisogno dell'aiuto di\ntutti.", spanish=" Necesitamos la ayuda de todos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we don't get their help...[K]\nWe'll never be able to prevent the planet's\nparalysis.", french="Sans ça...[K] on n'arrivera\njamais à empêcher la Paralysie de la Planète.", german="Wenn wir ihre Hilfe nicht\nbekommen,[K] werden wir die Lähmung des\nPlaneten niemals verhindern können.", italian="Senza il loro aiuto,[K] non\nriusciremo mai a prevenire la paralisi del\npianeta.", spanish="Si no conseguimos su ayuda...[K]\nNo podremos evitar la parálisis del planeta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we don't get their help...[K]\nWe'll run out of time to prevent the planet's\nparalysis.", french="Sans ça...[K] on n'arrivera\njamais à empêcher la Paralysie de la Planète.", german="Wenn wir ihre Hilfe nicht\nbekommen,[K] fehlt uns die Zeit, um die Lähmung\ndes Planeten verhindern zu können.", italian="Senza il loro aiuto,[K] non\nriusciremo mai a prevenire la paralisi del\npianeta.", spanish="Si no conseguimos su ayuda...[K]\nNo podremos evitar la parálisis del planeta."})
  else
  SkySceneKit.say({english="If we don't get their help...[K]\nWe'll run out of time to prevent the planet's\nparalysis.", french="Sans ça...[K] on n'arrivera\njamais à empêcher la Paralysie de la Planète.", german="Wenn wir ihre Hilfe nicht\nbekommen,[K] fehlt uns die Zeit, um die Lähmung\ndes Planeten verhindern zu können.", italian="Senza il loro aiuto,[K] non\nriusciremo mai a prevenire la paralisi del\npianeta.", spanish="Si no conseguimos su ayuda...[K]\nNo podremos evitar la parálisis del planeta."})
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
  GAME:WaitFrames(60)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [hero]...", french=" [hero]...", german=" [hero]...", italian=" [hero]...", spanish=" [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero]...", french=" [hero]...", german=" [hero]...", italian=" [hero]...", spanish=" [hero]..."})
  else
  SkySceneKit.say({english=" [hero]...", french=" [hero]...", german=" [hero]...", italian=" [hero]...", spanish=" [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right![K] Let's go home to\n[CS:N]Wigglytuff[CR]'s Guild!", french="Alors c'est d'accord![K] On retourne\nà la Guilde de [CS:N]Grodoudou[CR]!", german="Alles klar![K] Lass uns nach Hause\nzur [CS:N]Knuddeluff-Gilde[CR] gehen!", italian="Va bene![K] Torniamo a casa, alla\nGilda di [CS:N]Wigglytuff[CR]!", spanish="¡De acuerdo![K] ¡Regresemos al\n[CS:N]Pokégremio de Exploradores[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK, you're right![K] Let's go home\nto [CS:N]Wigglytuff[CR]'s Guild!", french="Alors c'est d'accord![K] On retourne\nà la Guilde de [CS:N]Grodoudou[CR]!", german="Okay, du hast recht![K] Lass uns\nzur [CS:N]Knuddeluff-Gilde[CR] gehen!", italian="Ok, hai ragione![K] Torniamo a\ncasa, alla Gilda di [CS:N]Wigglytuff[CR]!", spanish="¡De acuerdo![K] ¡Regresemos al\n[CS:N]Pokégremio de Exploradores[CR]!"})
  else
  SkySceneKit.say({english="OK, you're right![K] Let's go home\nto [CS:N]Wigglytuff[CR]'s Guild!", french="Alors c'est d'accord![K] On retourne\nà la Guilde de [CS:N]Grodoudou[CR]!", german="Okay, du hast recht![K] Lass uns\nzur [CS:N]Knuddeluff-Gilde[CR] gehen!", italian="Ok, hai ragione![K] Torniamo a\ncasa, alla Gilda di [CS:N]Wigglytuff[CR]!", spanish="¡De acuerdo![K] ¡Regresemos al\n[CS:N]Pokégremio de Exploradores[CR]!"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]!)", french="([partner]!)", german="([partner]!)", italian="([partner]!)", spanish="(¡[partner]!)"})
  else
  SkySceneKit.say({english="([partner]!)", french="([partner]!)", german="([partner]!)", italian="([partner]!)", spanish="(¡[partner]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll go back to the guild and\ntell everyone the truth!", french="Retournons à la Guilde pour\nleur raconter la vérité!", german="Wir gehen zur Gilde zurück und\nerzählen allen die Wahrheit!", italian="Torniamo alla Gilda e\nraccontiamo a tutti la verità!", spanish="¡Volveremos al [CS:N]Pokégremio[CR] y\nles contaremos a todos la verdad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go back to the guild and\ntell everyone the truth!", french="Retournons à la Guilde pour\nleur raconter la vérité!", german="Gehen wir zur Gilde zurück und\nerzählen allen die Wahrheit!", italian="Torniamo alla Gilda e\nraccontiamo a tutti la verità!", spanish="¡Volveremos al [CS:N]Pokégremio[CR] y\nles contaremos a todos la verdad!"})
  else
  SkySceneKit.say({english="Let's go back to the guild and\ntell everyone the truth!", french="Retournons à la Guilde pour\nleur raconter la vérité!", german="Gehen wir zur Gilde zurück und\nerzählen allen die Wahrheit!", italian="Torniamo alla Gilda e\nraccontiamo a tutti la verità!", spanish="¡Volveremos al [CS:N]Pokégremio[CR] y\nles contaremos a todos la verdad!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm pretty certain everyone will\nbe shocked.", french="Je parie que ça va être\nun sacré choc pour eux.", german="Ich bin ziemlich sicher, dass\nalle schockiert sein werden.", italian="Sono pressoché certo che\nrimarranno tutti scioccati.", spanish="Estoy seguro de que se van a\nquedar estupefactos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm sure that everyone will be\nshocked.", french="Je parie que ça va être\nun sacré choc pour eux.", german="Ich bin sicher, dass\nalle schockiert sein werden.", italian="Sono sicuro che rimarranno tutti\nscioccati.", spanish="Estoy seguro de que se van a\nquedar estupefactos."})
  else
  SkySceneKit.say({english="I can imagine that everyone will\nbe shocked.", french="Je parie que ça va être\nun sacré choc pour eux.", german="Ich kann mir vorstellen, dass\nalle schockiert sein werden.", italian="Posso immaginare che\nrimarranno tutti senza parole.", spanish="Estoy segura de que se van a\nquedar estupefactos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But...[K] I'm also sure they'll\nunderstand!", french="Mais...[K] je parie aussi\nqu'ils comprendront!", german="Aber...[K] Sie werden es sicherlich\nauch verstehen!", italian="Ma...[K] sono anche certo che\ncapiranno!", spanish="Pero...[K] ¡Creo que acabarán\nentendiéndolo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But...[K] I'm certain they'll\nunderstand!", french="Mais...[K] je parie aussi\nqu'ils comprendront!", german="Aber...[K] Sie werden es bestimmt\nauch verstehen!", italian="Ma...[K] sono anche certo che\ncapiranno!", spanish="Pero...[K] ¡Creo que acabarán\nentendiéndolo!"})
  else
  SkySceneKit.say({english="But...[K] I'm sure they will\nunderstand!", french="Mais...[K] je parie aussi\nqu'ils comprendront!", german="Aber...[K] Sie werden es ganz\nbestimmt verstehen!", italian="Ma...[K] sono sicura che\ncapiranno!", spanish="Pero...[K] ¡Creo que acabarán\nentendiéndolo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go home, [hero]!", french="On rentre chez nous,\n[hero]!", german="Gehen wir nach Hause,\n[hero]!", italian=" Torniamo a casa, [hero]!", spanish=" ¡Volvamos a casa, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go home, [hero]!", french="On rentre chez nous,\n[hero]!", german="Gehen wir nach Hause,\n[hero]!", italian=" Torniamo a casa, [hero]!", spanish=" ¡Volvamos a casa, [hero]!"})
  else
  SkySceneKit.say({english=" Let's go home, [hero]!", french="On rentre chez nous,\n[hero]!", german="Gehen wir nach Hause,\n[hero]!", italian=" Torniamo a casa, [hero]!", spanish=" ¡Volvamos a casa, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Back to [CS:N]Wigglytuff[CR]'s Guild!", french="En route pour la Guilde de\n[CS:N]Grodoudou[CR]!", german=" Zurück zur [CS:N]Knuddeluff-Gilde[CR]!", italian="Andiamo alla Gilda di\n[CS:N]Wigglytuff[CR]!", spanish=" ¡Volvamos al [CS:N]Pokégremio[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Back to [CS:N]Wigglytuff[CR]'s Guild!", french="En route pour la Guilde de\n[CS:N]Grodoudou[CR]!", german=" Zurück zur [CS:N]Knuddeluff-Gilde[CR]!", italian="Andiamo alla Gilda di\n[CS:N]Wigglytuff[CR]!", spanish=" ¡Volvamos al [CS:N]Pokégremio[CR]!"})
  else
  SkySceneKit.say({english=" Back to [CS:N]Wigglytuff[CR]'s Guild!", french="En route pour la Guilde de\n[CS:N]Grodoudou[CR]!", german=" Zurück zur [CS:N]Knuddeluff-Gilde[CR]!", italian="Andiamo alla Gilda di\n[CS:N]Wigglytuff[CR]!", spanish=" ¡Volvamos al [CS:N]Pokégremio[CR]!"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  GROUND:MoveToPosition(hero, 536, 196, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(40), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(160), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(partner, 536, 196, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(160), p.Y+(0), false, 2) end
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  SkyProg.set(22, 0) -- $SCENARIO_MAIN = scn[22,0] (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  end
  end
end
