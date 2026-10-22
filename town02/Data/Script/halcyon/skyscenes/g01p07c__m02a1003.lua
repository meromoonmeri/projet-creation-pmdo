-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m02a1003.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- switch(ProcessSpecial(53, -1, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_SetWaitMode(300, 300) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Thanks for playing!\n[CN]We hope you enjoyed\n[CN]the demo!", french="[CN]Merci d'avoir joué!\n[CN]Nous espérons que vous avez\n[CN]aimé cette démo!", german="[CN]Vielen Dank fürs Spielen!\n[CN]Wir hoffen, dass dir die Demo-Version\n[CN]Spaß gemacht hat!", italian="[CN]Grazie per aver giocato!\n[CN]Ci auguriamo che la versione demo\n[CN]ti sia piaciuta!", spanish="[CN]¡Gracias por jugar!\n[CN]Para descubrir aún más aventuras,\n[CN]¡no te pierdas la versión completa!"})
  -- message_KeyWait
  -- switch(ProcessSpecial(PROCESS_SPECIAL_JUMP_TO_TITLE_SCREEN, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
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
  SkySceneKit.say({english=" Hey, [hero]...", french=" Dis, [hero]...", german=" Hey, [hero]...", italian=" Ehi, [hero]...", spanish=" Una cosa, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Listen, [hero]...", french=" Dis, [hero]...", german=" Hör mal, [hero]...", italian=" Ehi, [hero]...", spanish=" Escucha, [hero]..."})
  else
  SkySceneKit.say({english=" Say, [hero]...", french=" Dis, [hero]...", german=" Sag mal, [hero]...", italian=" Ehi, [hero]...", spanish=" Oye, [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Today was pretty hectic, wasn't\nit! So much happened!", french="Cette journée a été très\nmouvementée! Il s'est passé tant de\nchoses!", german="Heute war ein hektischer Tag,\nwas? Es ist so viel passiert!", italian="Oggi è stata una giornata\nintensa, vero? Sono successe così\ntante cose!", spanish="Hoy ha sido un día muy movidito,\n¿verdad? ¡Han pasado muchas cosas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wasn't today hectic? So much\nhappened!", french="Cette journée a été très\nmouvementée! Il s'est passé tant de\nchoses!", german="War heute nicht ein hektischer\nTag? Es ist so viel passiert!", italian="Oggi è stata una giornata\nintensa, vero? Sono successe così\ntante cose!", spanish="Hoy ha sido un día muy agitado,\n¿verdad? ¡Han pasado tantas cosas!"})
  else
  SkySceneKit.say({english="Today was pretty hectic with\neverything we went through, wasn't it?", french="Cette journée a été très\nmouvementée! Il s'est passé tant de\nchoses!", german="Heute war ein ziemlich\nereignisreicher und hektischer Tag, oder?", italian="Oggi è stata una giornata\nintensa, vero? Quante cose sono\nsuccesse!", spanish="¡Hay que ver las cosas que han\npasado hoy! Ha sido un día muy agitado, ¿no?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I'm glad we managed to pull\noff our first job.", french="Je suis content que notre\npremière mission ait été un succès.", german="Aber ich bin froh, dass wir\nunseren ersten Job erledigt haben.", italian="Ma sono felice di aver concluso\nla nostra prima missione.", spanish="Pero es un alivio\nhaber cumplido nuestra primera misión."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I'm relieved that our first\njob was a success.", french="Je suis content que notre\npremière mission ait été un succès.", german="Aber ich bin erleichtert, dass\nunser erster Job ein Erfolg war.", italian="Ma sono felice di aver portato\na termine la nostra prima missione.", spanish="Pero me alegro de haber podido\ncumplir nuestra primera misión."})
  else
  SkySceneKit.say({english="But I'm glad our first job turned\nout so well.", french="Je suis contente que notre\npremière mission ait été un succès.", german="Aber ich bin froh, dass unser\nerster Job so gut lief.", italian="Ma sono felice che ce l'abbiamo\nfatta a portare a termine la nostra prima\nmissione!", spanish="Pero me alegro de que nuestra\nprimera misión haya ido tan bien."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I was really steamed about how\n[CS:N]Wigglytuff[CR]'s Guild took most of the money...", french="Par contre, j'étais vraiment\ndéçu que la Guilde de [CS:N]Grodoudou[CR] nous prenne\nautant d'argent...", german="Ich war stinksauer, dass wir so\nviel Geld an die [CS:N]Knuddeluff-Gilde[CR] abgeben\nmussten.", italian="Il modo in cui la Gilda di\n[CS:N]Wigglytuff[CR] si è presa gran parte dei soldi\nnon mi è andato giù...", spanish="No me ha gustado nada que el\n[CS:N]Pokégremio[CR] se quedase casi todo el dinero."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It was really upsetting how\n[CS:N]Wigglytuff[CR]'s Guild took most of the money...", french="Par contre, j'étais vraiment\ndéçu que la Guilde de [CS:N]Grodoudou[CR] nous prenne\nautant d'argent...", german="Dass die [CS:N]Knuddeluff-Gilde[CR] so\nviel von dem Geld genommen hat, hat mich\nwirklich aufgeregt.", italian="Il modo in cui la Gilda di\n[CS:N]Wigglytuff[CR] si è presa gran parte dei soldi\nnon mi è piaciuto affatto...", spanish="No me ha gustado nada que el\n[CS:N]Pokégremio[CR] se quedase casi todo el dinero."})
  else
  SkySceneKit.say({english="I was really mad about how\n[CS:N]Wigglytuff[CR]'s Guild took most of the money...", french="Par contre, j'étais vraiment\ndéçue que la Guilde de [CS:N]Grodoudou[CR] nous prenne\nautant d'argent...", german="Ich war stinksauer, dass wir so\nviel Geld an die [CS:N]Knuddeluff-Gilde[CR] abgeben\nmussten.", italian="Mi ha proprio indispettito il\nmodo in cui la Gilda di [CS:N]Wigglytuff[CR] si è presa\ngran parte dei soldi...", spanish="No me ha gustado nada que el\n[CS:N]Pokégremio[CR] se quedase casi todo el dinero."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's just the cost of training,\nI guess. We can't do anything about it.", french="C'est sûrement ce que coûte\nnotre entraînement. On ne peut rien y faire.", german="Das sind wohl einfach die Kosten\nfür das Training. Da können wir nichts machen.", italian="Ma è il prezzo dell'addestra-\nmento. Non possiamo farci niente.", spanish="Supongo que así costeamos\nel entrenamiento. No se puede hacer nada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's just the cost of training,\nI guess. We can't do anything about it.", french="C'est sûrement ce que coûte\nnotre entraînement. On ne peut rien y faire.", german="Das sind wohl einfach die Kosten\nfür das Training. Da können wir nichts machen.", italian="Ma è il prezzo dell'addestra-\nmento. Non possiamo farci niente.", spanish="Supongo que así pagamos\nnuestro entrenamiento. No se puede hacer nada."})
  else
  SkySceneKit.say({english="That's just the cost of training,\nI guess. We can't do anything about it.", french="C'est sûrement ce que coûte\nnotre entraînement. On ne peut rien y faire.", german="Das sind wohl einfach die Kosten\nfür das Training. Da können wir nichts machen.", italian="Ma è il prezzo dell'addestra-\nmento. Non possiamo farci niente.", spanish="Supongo que es el precio de\nnuestro entrenamiento. No se puede hacer nada."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What meant the most to me\ntoday, though, was getting thanked by [CS:N]Spoink[CR]!", french="En fait, ce qui m'a fait le plus\nplaisir aujourd'hui, ce sont les remerciements\nde [CS:N]Spoink[CR]!", german="Das Beste heute war für mich,\nals [CS:N]Spoink[CR] sich bei uns bedankt hat!", italian="La cosa più significativa per me\nè stata la gratitudine di [CS:N]Spoink[CR]!", spanish="¡Lo mejor del día ha sido ver\nlo contento que se puso [CS:N]Spoink[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But what made me really happy\ntoday, though, was getting thanked by [CS:N]Spoink[CR]!", french="En fait, ce qui m'a fait le plus\nplaisir aujourd'hui, ce sont les remerciements\nde [CS:N]Spoink[CR]!", german="Aber ich war heute richtig\nglücklich, als [CS:N]Spoink[CR] sich bei uns bedankt hat!", italian="La cosa più importante per me\nè stata la gratitudine di [CS:N]Spoink[CR]!", spanish="¡Lo que más me ha alegrado hoy\nha sido ver lo contento que se puso [CS:N]Spoink[CR]!"})
  else
  SkySceneKit.say({english="But what made me really happy\ntoday, though, was getting thanked by [CS:N]Spoink[CR]!", french="En fait, ce qui m'a fait le plus\nplaisir aujourd'hui, ce sont les remerciements\nde [CS:N]Spoink[CR]!", german="Aber ich war heute richtig\nglücklich, als [CS:N]Spoink[CR] sich bei uns bedankt hat!", italian="La cosa più bella per me\nè stata la gratitudine di [CS:N]Spoink[CR]!", spanish="¡Lo mejor del día ha sido ver\nlo contento que se puso [CS:N]Spoink[CR]!"})
  end
  -- message_Close
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yawn... I'm getting sleepy.", french="Mouaaah... Je commence\nà avoir sommeil.", german=" Gähn... Bin ich müde.", italian=" Yawn... Che sonno.", spanish=" ¡Uaaa!... Tengo sueño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yawn... I'm getting sleepy.", french="Mouaaah... Je commence\nà avoir sommeil.", german=" Gähn... Bin ich müde.", italian=" Yawn... Che sonno.", spanish=" ¡Uaaa!... Tengo sueño."})
  else
  SkySceneKit.say({english=" Yawn... I'm getting sleepy.", french="Mouaaah... Je commence\nà avoir sommeil.", german=" Gähn... Bin ich müde.", italian=" Yawn... Che sonno.", spanish=" ¡Uaaa!... Estoy cansada."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm going to sleep.[K] Let's do a\ngood job again tomorrow.", french="Je me couche.[K] Faisons encore\ndu bon travail demain.", german="Ich schlafe jetzt.[K] Geben wir\nmorgen wieder unser Bestes.", italian="Meglio dormire.[K] Cerchiamo di\nfare un buon lavoro anche domani.", spanish="Me voy a dormir.[K] Mañana\ntenemos que volver a hacer un buen trabajo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm going to sleep.[K] Let's try our\nbest again tomorrow.", french="Je me couche.[K] Faisons encore\ndu bon travail demain.", german="Ich schlafe jetzt.[K] Geben wir\nmorgen wieder unser Bestes.", italian="Meglio dormire.[K] Cerchiamo di\nfare un buon lavoro anche domani.", spanish="Me voy a dormir.[K] Mañana\ndebemos volver a esforzarnos así."})
  else
  SkySceneKit.say({english="I'm going to sleep.[K] Let's try our\nbest again tomorrow.", french="Je me couche.[K] Faisons encore\ndu bon travail demain.", german="Ich schlafe jetzt.[K] Geben wir\nmorgen wieder unser Bestes.", italian="Meglio dormire.[K] Cerchiamo di\nfare un buon lavoro anche domani.", spanish="Me voy a dormir.[K] Mañana hay\nque esforzarse otra vez todo lo que podamos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good night, [hero]...", french=" Bonne nuit, [hero]...", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero]...", spanish=" Buenas noches, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good night, [hero]...", french=" Bonne nuit, [hero]...", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero]...", spanish=" Buenas noches, [hero]."})
  else
  SkySceneKit.say({english=" Sleep tight, [hero]...", french=" Bonne nuit, [hero]...", german=" Schlaf gut, [hero].", italian=" Sogni d'oro, [hero]...", spanish=" Que duermas bien, [hero]."})
  end
  -- message_Close
  GAME:WaitFrames(30)
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(80)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SkyProg.set(4, 0) -- $SCENARIO_MAIN = scn[4,0] (ROM)
  end
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
