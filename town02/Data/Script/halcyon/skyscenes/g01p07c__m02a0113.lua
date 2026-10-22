-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m02a0113.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if ((SV.SkyScenarioBitFlags or {})[8] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[8]
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 0 -- $SCENARIO_MAIN_BIT_FLAG[8] = 0 (ROM)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/Note") end) -- me_Play(7) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Exploration Team\n[CN]Quick Tip[W:30]", french="[CN]Petit conseil à l'attention\n[CN]des équipes d'exploration[W:30]", german="[CN]Tipp für\n[CN]Erkundungsteams[W:30]", italian="[CN]Consiglio rapido\n[CN]per le squadre d'esplorazione.[W:30]", spanish="[CN]Consejo para\n[CN]equipos de exploración:[W:30]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]You can save a record of your progress\n[CN]by climbing onto your bed from now on.", french="[CN]A présent, vous pouvez sauvegarder votre\n[CN]progression en allant sur votre lit.", german="[CN]Du kannst deinen Spielstand ab jetzt speichern,\n[CN]indem du dich zu deinem Bett begibst.", italian="[CN]D'ora in poi puoi salvare i tuoi progressi\n[CN]salendo sul letto.", spanish="[CN]Desde ahora puedes guardar la partida\n[CN]metiéndote en la cama."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]So whenever you want to save your\n[CN]progress, just climb onto your bed.", french="[CN]Donc quand vous voulez sauvegarder votre\n[CN]partie, il vous suffit d'aller sur votre lit.", german="[CN]Willst du also deinen Spielstand speichern,\n[CN]gehe einfach zu deinem Bett.", italian="[CN]Quindi, quando vuoi salvare i tuoi progressi,\n[CN]sali sul letto.", spanish="[CN]Por tanto, cuando quieras guardar tu avance\n[CN]solo tienes que dirigirte a la cama."})
  -- message_Close
  GAME:WaitFrames(60)
  else
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  else
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ......", french=" ......", german=" ......", italian=" ...", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ......", french=" ......", german=" ......", italian=" ...", spanish=" ..."})
  else
  SkySceneKit.say({english=" ......", french=" ......", german=" ......", italian=" ...", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, are you still awake,\n[hero]?", french=" Dis, tu dors, [hero]?", german="Hey, bist du noch wach,\n[hero]?", italian="Ehi, stai già dormendo,\n[hero]?", spanish="Todavía no te has dormido,\n¿verdad, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, are you still awake,\n[hero]?", french=" Dis, tu dors, [hero]?", german="Oh, bist du noch wach,\n[hero]?", italian="Oh, non dormi ancora,\n[hero]?", spanish="Todavía no te has dormido,\n¿verdad, [hero]?"})
  else
  SkySceneKit.say({english="Say, are you still awake,\n[hero]?", french=" Dis, tu dors, [hero]?", german="Sag, [hero], bist du noch\nwach?", italian="Ehi, non dormi ancora,\n[hero]?", spanish="Yo aún sigo despierta.\nY tú también, ¿verdad, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="My heart's been pounding over\nevery little thing today...", french="Mon cœur a battu la chamade\ntoute la journée...", german="Ich hatte heute die ganze Zeit\nHerzrasen...", italian="Oggi ci sono stati tanti momenti\nemozionanti per me...", spanish="Llevo todo el día con el corazón\nlatiéndome a cien por hora con todo esto..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="My heart's been racing all\nday today over every little thing...", french="Mon cœur a battu la chamade\ntoute la journée...", german="Ich hatte heute die ganze Zeit\nHerzrasen...", italian="Oggi ci sono stati tanti momenti\nemozionanti per me...", spanish="Hoy ha sido un día lleno de\nemociones, la verdad..."})
  else
  SkySceneKit.say({english=" My heart's been racing all day...", french="Mon cœur a battu la chamade\ntoute la journée...", german="Ich hatte den ganzen Tag\nHerzrasen...", italian="Oggi ci sono stati tanti momenti\nemozionanti per me...", spanish="La verdad es que ha sido un día\nincreíble. Aún me palpita el corazón..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I'm glad I finally worked up\nthe courage to come here.", french="Je suis heureux d'avoir enfin\npris mon courage à deux mains pour venir ici.", german="Aber ich bin froh, dass ich\nendlich den Mut hatte, hierherzukommen.", italian="Ma sono contento di aver\nfinalmente trovato il coraggio di venire qui.", spanish="Pero me alegro de haber reunido\nel valor para venir aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I'm glad I finally made\nmyself come here.", french="Je suis heureux d'avoir enfin\npris mon courage à deux mains pour venir ici.", german="Aber ich bin froh, dass ich\nmich endlich hergetraut habe.", italian="Ma sono contento di aver\nfinalmente trovato il coraggio di venire qui.", spanish="Pero me alegro de haberme\natrevido a venir aquí."})
  else
  SkySceneKit.say({english="But I'm glad I finally forced\nmyself to come here.", french="Je suis heureuse d'avoir enfin\npris mon courage à deux mains pour venir ici.", german="Aber ich bin froh, dass ich mich\nendlich überwunden habe, herzukommen.", italian="Ma sono contenta di aver\nfinalmente trovato il coraggio di venire qui.", spanish="Pero estoy contenta por haberme\natrevido a venir."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I thought [CS:N]Wigglytuff[CR] would be\na lot scarier, but he seems pretty nice.", french="Je pensais que [CS:N]Grodoudou[CR] serait\nplus effrayant, mais il a l'air plutôt gentil.", german="Ich habe mir [CS:N]Knuddeluff[CR] viel\ngruseliger vorgestellt. Er scheint ganz nett zu\nsein.", italian="Pensavo che [CS:N]Wigglytuff[CR] fosse\npiù spaventoso, ma in realtà sembra molto\ngentile.", spanish="Creía que [CS:N]Wigglytuff[CR] impondría\nmucho más respeto, pero parece muy\nsimpático."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I thought [CS:N]Wigglytuff[CR] would be\nscary, but he seems pretty friendly.", french="Je pensais que [CS:N]Grodoudou[CR] serait\nplus effrayant, mais il a l'air plutôt gentil.", german="Ich habe mir [CS:N]Knuddeluff[CR] voll\ngruselig vorgestellt, aber er scheint sehr\nfreundlich zu sein.", italian="Pensavo che [CS:N]Wigglytuff[CR] fosse\npiù spaventoso, ma in realtà sembra molto\ngentile.", spanish="Esperaba que [CS:N]Wigglytuff[CR] me\nasustase, pero la verdad es que parece\nmuy simpático."})
  else
  SkySceneKit.say({english="I thought [CS:N]Wigglytuff[CR] would be\nkind of scary, but he was pretty nice.", french="Je pensais que [CS:N]Grodoudou[CR] serait\nplus effrayant, mais il a l'air plutôt gentil.", german="Ich habe mir [CS:N]Knuddeluff[CR]\nirgendwie gruselig vorgestellt, aber er war\nrichtig nett.", italian="Pensavo che [CS:N]Wigglytuff[CR] fosse\npiù spaventoso, ma in realtà sembra molto\ngentile.", spanish="Tenía miedo de [CS:N]Wigglytuff[CR], pero\nal final ha resultado ser la mar de simpático."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Even though tomorrow has all\nsorts of new stuff in store for us, I'm not\nscared at all!", french="Même si la journée de demain\nnous réserve plein de surprises, je n'ai pas\ntrop peur!", german="Morgen erwartet uns zwar eine\nMenge Neues, aber ich habe überhaupt keine\nAngst!", italian="Anche se domani dovremo\nconfrontarci con delle nuove sfide, non ho per\nniente paura!", spanish="Aunque mañana será un día\nrepleto de cosas nuevas, ¡ya no tengo miedo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're going to experience all\nsorts of things starting tomorrow, but I'm not\nvery scared.", french="Même si la journée de demain\nnous réserve plein de surprises, je n'ai pas\ntrop peur!", german="Ab morgen kommt so einiges auf\nuns zu, aber ich habe kaum Angst.", italian="Anche se domani dovremo\naffrontare delle nuove sfide, non ho affatto\npaura!", spanish="Mañana será un día repleto\nde novedades, pero ya no estoy tan asustado."})
  else
  SkySceneKit.say({english="We'll experience all sorts of\nnew stuff starting tomorrow, but I'm not\nvery frightened.", french="Même si la journée de demain\nnous réserve plein de surprises, je n'ai pas\ntrop peur!", german="Morgen erwartet uns zwar eine\nMenge Neues, aber ich habe keine große Angst.", italian="Anche se domani dovremo\naffrontare delle nuove sfide, non sono affatto\nspaventata!", spanish="Mañana será un día lleno\nde sorpresas, pero ya no estoy asustada."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Actually, I'm excited about the\nnew adventures we'll face!", french="Au contraire, je suis carrément\nimpatient de commencer à vivre toutes ces\naventures!", german="Eigentlich bin ich sogar gespannt\nauf unsere neuen Abenteuer!", italian="A dire il vero, non vedo l'ora di\nscoprire quali nuove avventure ci attendono!", spanish="En realidad, ¡me muero\nde ganas por saber lo que nos espera!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="In fact, it's the other way\naround. I'm super excited about the adventures\nwe'll face!", french="Au contraire, je suis carrément\nimpatient de commencer à vivre toutes ces\naventures!", german="Im Gegenteil! Ich bin total\ngespannt auf neue Abenteuer!", italian="A dire il vero, non vedo l'ora di\nscoprire quali nuove avventure ci attendono!", spanish="¡La verdad es que estoy\nansioso por ver qué aventuras nos esperan!"})
  else
  SkySceneKit.say({english="Actually, I can't wait to find\nout what new adventures are in store for us!", french="Au contraire, je suis carrément\nimpatiente de commencer à vivre toutes ces\naventures!", german="Eigentlich kann ich es kaum\nerwarten, neue Abenteuer zu erleben!", italian="A dire il vero, non vedo l'ora di\nscoprire quali nuove avventure ci attendono!", spanish="¡Lo cierto es que tengo muchas\nganas de ver qué aventuras nos esperan!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yawn... I'm getting sleepy...", french="Mouaaaaaaaaah... Je commence\nà avoir sommeil...", german=" Gähn... Ich bin ganz schläfrig...", italian=" Yawn... Che sonno...", spanish=" ¡Uaaa! ¡Qué sueño!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm feeling a little sleepy...", french="Mouaaaaaaaaah... Je commence\nà avoir sommeil...", german=" Langsam werde ich müde...", italian=" Yawn... Che sonno...", spanish=" Ya tengo un poco de sueño..."})
  else
  SkySceneKit.say({english=" I'm getting a little sleepy...", french="Mouaaaaaaaaah... Je commence\nà avoir sommeil...", german=" So langsam bin ich müde...", italian=" Yawn... Che sonno...", spanish="Me parece que me está entrando\nsueño..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's do our best tomorrow.", french=" Faisons de notre mieux, demain!", german=" Geben wir morgen unser Bestes.", italian="Facciamo del nostro meglio\ndomani.", spanish="Mañana tenemos que\nesforzarnos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's give it our all tomorrow.", french=" Faisons de notre mieux, demain!", german="Geben wir morgen unser\nAllerbestes.", italian="Facciamo del nostro meglio\ndomani.", spanish=" Mañana debemos esforzarnos."})
  else
  SkySceneKit.say({english=" Let's give it our all tomorrow.", french=" Faisons de notre mieux, demain!", german="Geben wir morgen unser\nAllerbestes.", italian="Facciamo del nostro meglio\ndomani.", spanish="¡Mañana debemos hacerlo\nlo mejor que podamos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right then. Good night,\n[hero]...", french=" Bonne nuit, [hero]...", german="In Ordnung. Gute Nacht,\n[hero].", italian="Va bene. Buona notte,\n[hero]...", spanish="Bueno, [hero]...\nBuenas noches."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, [hero]. Good night.", french=" Bonne nuit, [hero]...", german=" Okay, [hero]. Gute Nacht.", italian="Va bene. Buona notte,\n[hero]...", spanish="Bueno, [hero].\nHasta mañana."})
  else
  SkySceneKit.say({english=" OK, [hero]. Sleep tight.", french=" Bonne nuit, [hero]...", german=" Okay, [hero]. Schlaf gut.", italian="Va bene. Buona notte,\n[hero]...", spanish="Bueno, [hero]...\nQue duermas bien."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(90)
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:ResetSpeaker() end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Um...)", french="(Hum...)", german="(Ähm...)", italian="(Uhm...)", spanish="(Hum...)"})
  else
  SkySceneKit.say({english="(Um...)", french="(Hum...)", german="(Ähm...)", italian="(Uhm...)", spanish="(Hum...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Now I'm suddenly apprenticing at the guild...)", french="(Me voici devenu apprenti de la Guilde...)", german="(Auf einmal bin ich Lehrling in der Gilde...)", italian="(Adesso che sono all'improvviso diventato un\napprendista alla Gilda...)", spanish="(Parece que he acabado de aprendiz en este\n[CS:N]Pokégremio[CR]...)"})
  else
  SkySceneKit.say({english="(Now I'm suddenly apprenticing at the guild...)", french="(Me voici devenue apprentie de la Guilde...)", german="(Auf einmal bin ich Lehrling in der Gilde...)", italian="(Adesso che sono all'improvviso diventata\nun'apprendista alla Gilda...)", spanish="(No sé cómo, pero he acabado como aprendiz\nen este [CS:N]Pokégremio[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I gotta admit, it's pretty exciting to be in an\nexploration team.)", french="(Je dois bien admettre que c'est assez\npassionnant de faire partie d'une équipe\nd'exploration.)", german="(Ich muss zugeben, dass es ziemlich aufregend\nist, in einem Erkundungsteam zu sein.)", italian="(... devo ammettere che è molto emozionante\nfare parte di una squadra d'esplorazione.)", spanish="(Aunque he de admitir que la idea de estar\nen un equipo explorador es emocionante.)"})
  else
  SkySceneKit.say({english="(I gotta admit, it's pretty exciting to be in an\nexploration team.)", french="(Je dois bien admettre que c'est assez\npassionnant de faire partie d'une équipe\nd'exploration.)", german="(Ich muss zugeben, dass es ziemlich aufregend\nist, in einem Erkundungsteam zu sein.)", italian="(... devo ammettere che è molto emozionante\nfare parte di una squadra d'esplorazione.)", spanish="(Aunque he de admitir que la idea de estar\nen un equipo explorador es emocionante.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And it's fun to be friends with\n[partner]...)", french="(Et puis, c'est amusant d'être l'ami de\n[partner]...)", german="(Und ich habe viel Spaß mit [partner].)", italian="(Ed è bello essere amico di [partner]...)", spanish="(Y es divertido ser amigo de [partner]...)"})
  else
  SkySceneKit.say({english="(And it's fun to be friends with\n[partner]...)", french="(Et puis, c'est amusant d'être l'amie de\n[partner]...)", german="(Und ich habe viel Spaß mit [partner].)", italian="(Ed è bello essere amica di [partner]...)", spanish="(Y es divertido ser amiga de [partner]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But first things first...)", french="(Mais commençons par le commencement...)", german="(Aber noch wichtiger ist...)", italian="(Ma devo ancora trovare una risposta alle mie\ndomande...)", spanish="(Pero lo primero es lo primero...)"})
  else
  SkySceneKit.say({english="(But first things first...)", french="(Mais commençons par le commencement...)", german="(Aber noch wichtiger ist...)", italian="(Ma devo ancora trovare una risposta alle mie\ndomande...)", spanish="(Pero lo primero es lo primero...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Who am I?)", french="(Qui suis-je?)", german="(Wer bin ich?)", italian="(Chi sono?)", spanish="(¿Quién soy?)"})
  else
  SkySceneKit.say({english="(Who am I?)", french="(Qui suis-je?)", german="(Wer bin ich?)", italian="(Chi sono?)", spanish="(¿Quién soy?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(How did I turn into a Pokémon?)", french="(Comment me suis-je transformé en\nPokémon?)", german="(Wie bin ich zu einem Pokémon geworden?)", italian="(Come ho fatto a trasformarmi in un\nPokémon?)", spanish="(¿Cómo he acabado convertido en un\nPokémon?)"})
  else
  SkySceneKit.say({english="(How did I turn into a Pokémon?)", french="(Comment me suis-je transformée en\nPokémon?)", german="(Wie bin ich zu einem Pokémon geworden?)", italian="(Come ho fatto a trasformarmi in un\nPokémon?)", spanish="(¿Cómo he acabado convertida en un\nPokémon?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(How did I end up unconscious on that beach?)", french="(Comment ai-je atterri sur cette plage?\nPourquoi étais-je inconscient?)", german="(Wieso lag ich bewusstlos am Strand?)", italian="(Come ho fatto a finire svenuto su\nquella spiaggia?)", spanish="(¿Por qué estaba inconsciente en aquella\nplaya?)"})
  else
  SkySceneKit.say({english="(How did I end up unconscious on that beach?)", french="(Comment ai-je atterri sur cette plage?\nPourquoi étais-je inconsciente?)", german="(Wieso lag ich bewusstlos am Strand?)", italian="(Come ho fatto a finire svenuta su\nquella spiaggia?)", spanish="(¿Por qué estaba inconsciente en aquella\nplaya?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I'm feeling sleepy too...)", french="(Moi aussi je suis fatigué...)", german="(Ich bin auch müde.)", italian="(Anch'io ho sonno...)", spanish="(Me está entrando sueño a mí también...)"})
  else
  SkySceneKit.say({english="(I'm feeling sleepy too...)", french="(Moi aussi je suis fatiguée...)", german="(Ich bin auch müde.)", italian="(Anch'io ho sonno...)", spanish="(Me está entrando sueño a mí también...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Well, thinking about it won't help right now.\nI'd better focus on the guild's work for now...)", french="(Mais cela ne sert à rien de réfléchir à tout\nça pour le moment. Je ferais mieux de\nme concentrer sur le travail à la Guilde...)", german="(Tja, es bringt jetzt nichts, darüber\nnachzudenken. Ich konzentriere mich fürs\nErste besser auf die Arbeit in der Gilde.)", italian="(Beh, pensarci non serve a niente ora.\nFarò meglio a concentrarmi sui miei compiti\nqui alla Gilda, per il momento...)", spanish="(Pensar en ello no me servirá de nada ahora.\nSerá mejor que me centre en el [CS:N]Pokégremio[CR].)"})
  else
  SkySceneKit.say({english="(Well, thinking about it won't help right now.\nI'd better focus on the guild's work for now...)", french="(Mais cela ne sert à rien de réfléchir à tout\nça pour le moment. Je ferais mieux de\nme concentrer sur le travail à la Guilde...)", german="(Tja, es bringt jetzt nichts, darüber\nnachzudenken. Ich konzentriere mich fürs\nErste besser auf die Arbeit in der Gilde.)", italian="(Beh, pensarci non serve a niente ora.\nFarò meglio a concentrarmi sui miei compiti\nqui alla Gilda, per il momento...)", spanish="(Pensar en ello no me servirá de nada ahora.\nSerá mejor que me centre en el [CS:N]Pokégremio[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If I do that, well, everything should become\nclear eventually...)", french="(Peut-être que de cette façon, les choses\nvont se clarifier...)", german="(Wenn ich das tue, sollte sich alles\nirgendwann aufklären.)", italian="(In questo modo, forse prima o poi le cose\nsi chiariranno...)", spanish="(Creo que si lo hago, todo acabará por\naclararse tarde o temprano...)"})
  else
  SkySceneKit.say({english="(If I do that, well, everything should become\nclear eventually...)", french="(Peut-être que de cette façon, les choses\nvont se clarifier...)", german="(Wenn ich das tue, sollte sich alles\nirgendwann aufklären.)", italian="(In questo modo, forse prima o poi le cose\nsi chiariranno...)", spanish="(Creo que si lo hago, todo acabará por\naclararse tarde o temprano...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I'll surely get to the bottom of this in time.)", french="(Je découvrirai sûrement le fin mot de\nl'histoire en temps voulu.)", german="(Mit der Zeit komme ich den Dingen sicher auf\nden Grund.)", italian="(Andrò al fondo della questione quando sarà\nil momento.)", spanish="(Sin duda acabaré llegando al fondo de todo\nesto.)"})
  else
  SkySceneKit.say({english="(I'll surely get to the bottom of this in time.)", french="(Je découvrirai sûrement le fin mot de\nl'histoire en temps voulu.)", german="(Mit der Zeit komme ich den Dingen sicher auf\nden Grund.)", italian="(Andrò al fondo della questione quando sarà\nil momento.)", spanish="(Sé que acabaré descubriendo lo que pasa...)"})
  end
  -- message_Close
  GAME:WaitFrames(30)
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(120)
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(60)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 1 -- $COMPULSORY_SAVE_POINT = 1 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
