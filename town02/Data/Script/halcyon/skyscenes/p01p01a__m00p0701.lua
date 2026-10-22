-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/m00p0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [hero].[K] This is our\ngraduation exam, right?", french="Ecoute, [hero].[K] Comme\nc'est le jour de notre examen...", german="Hey, [hero].[K] Es ist doch\nunsere Abschlussprüfung, oder?", italian="Ehi, [hero].[K] Questo è il\nnostro esame di diploma, giusto?", spanish="Oye, [hero],[K] esta es\nnuestra gran prueba, ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Listen, [hero].[K] Since this\nis our graduation exam...", french="Ecoute, [hero].[K] Comme\nc'est le jour de notre examen...", german="Hör mal, [hero].[K] Es geht\ndoch um unsere Abschlussprüfung.", italian="Ascolta, [hero].[K] Visto\nche questo è il nostro esame di diploma...", spanish="Escucha, [hero]...[K] dado\nque esta es nuestra gran prueba..."})
  else
  SkySceneKit.say({english="Say, [hero].[K] Since this is\nour graduation exam...", french="Ecoute, [hero].[K] Comme\nc'est le jour de notre examen...", german="Hör mal, [hero].[K] Es geht\ndoch um unsere Abschlussprüfung.", italian="Ascolta, [hero].[K] Visto\nche questo è il nostro esame di diploma...", spanish="Escucha, [hero]...[K] dado\nque esta es nuestra gran prueba..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think that just we two should\ngo. You and me, [hero].", french="... je pense qu'on devrait y aller\nseulement à deux. Juste toi et moi,\n[hero].", german="Ich finde, dass nur wir beide\ngehen sollten. Du und ich, [hero].", italian="Penso che dovremmo andare\nsolo noi due. Io e te, [hero].", spanish="Así que creo que no debería\nacompañarnos nadie, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I was thinking that just the two\nof us should go, [hero].", french="... je pense qu'on devrait y aller\nseulement à deux. Juste toi et moi,\n[hero].", german="Ich habe mir überlegt, dass nur\nwir beide gehen sollten, [hero].", italian="Pensavo che dovremmo andare\nsolo noi due, [hero].", spanish="Estaba pensando que deberíamos\nir solamente tú y yo, [hero]."})
  else
  SkySceneKit.say({english="I started thinking that just the\ntwo of us should go, [hero].", french="... je pense qu'on devrait y aller\nseulement à deux. Juste toi et moi,\n[hero].", german="Ich dachte mir gerade, dass nur\nwir beide gehen sollten, [hero].", italian="Stavo pensando che dovremmo\nandare solo noi due, [hero].", spanish="He pensado que deberíamos\nir solamente tú y yo, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So how about leaving behind the\nother team members...[K]and just we two go?", french="Tu en penses quoi? On laisse\nles autres membres de l'équipe...[K] et on y va\nrien qu'à deux?", german="Wie wäre es, wenn wir die\nanderen Team-Mitglieder hierlassen...[K] und zu\nzweit gehen?", italian="Quindi cosa ne dici di lasciare\nqui gli altri membri della squadra...[K] e di\nandare noi due?", spanish="¿Qué te parece si dejamos atrás\na los demás?[K] Así podríamos ir solos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What do you think about leaving\nbehind the other team members?[K] So just we\ntwo can go.", french="Tu en penses quoi? On laisse\nles autres membres de l'équipe...[K] et on y va\nrien qu'à deux?", german="Was hältst du davon, die\nanderen Team-Mitglieder hierzulassen?[K]\nUnd wir zwei könnten alleine gehen.", italian="Quindi cosa ne dici di lasciare\nqui gli altri membri della squadra...[K] e di\nandare noi due?", spanish="¿Te parece bien dejar atrás a\nlos demás miembros del equipo?[K]\nAsí solo iríamos los dos."})
  else
  SkySceneKit.say({english="So how about leaving behind the\nother team members...[K] That way, we can go\nas a pair.", french="Tu en penses quoi? On laisse\nles autres membres de l'équipe...[K] et on y va\nrien qu'à deux?", german="Wie wäre es, wenn wir die\nanderen Team-Mitglieder hierlassen?[K] Dann\nkönnen wir zu zweit gehen.", italian="Quindi cosa ne dici di lasciare\nqui gli altri membri della squadra...[K] e di\nandare noi due?", spanish="¿Qué te parece si dejamos atrás\na los demás miembros del equipo?[K]\nAsí podríamos ir en pareja."})
  end
  do local __choice = SkySceneKit.ask({{english="Go as a pair", french="Y aller juste à deux", german="Zu zweit gehen", italian="Accetta", spanish="Ir en pareja"}, {english="Don't go to [CS:P]Mystifying Forest[CR]", french="Ne pas aller à la [CS:P]Forêt Trompeuse[CR]", german="Nicht zum [CS:P]Verwirrwald[CR] gehen", italian="Non andare alla [CS:P]Foresta Inganno[CR]", spanish="No ir al [CS:P]Bosque Misterio[CR]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="OK![K] Let's get moving to\n[CS:P]Mystifying Forest[CR]!", french="D'accord![K] Alors, en route pour\nla [CS:P]Forêt Trompeuse[CR]!", german=" Okay![K] Auf zum [CS:P]Verwirrwald[CR]!", italian="Ok![K] Andiamo alla [CS:P]Foresta[CR]\n[CS:P]Inganno[CR]!", spanish="¡Vale![K] ¡Vámonos\nahora mismo al [CS:P]Bosque Misterio[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's that![K] Let's get moving to\n[CS:P]Mystifying Forest[CR]!", french="D'accord![K] Alors, en route pour\nla [CS:P]Forêt Trompeuse[CR]!", german="Abgemacht![K] Dann auf zum\n[CS:P]Verwirrwald[CR]!", italian="Allora è deciso![K] Andiamo alla\n[CS:P]Foresta Inganno[CR]!", spanish="¡De acuerdo![K] ¡Partamos ya\nal [CS:P]Bosque Misterio[CR]!"})
  else
  SkySceneKit.say({english="OK![K] Let's go to [CS:P]Mystifying\nForest[CR]!", french="D'accord![K] Alors, en route pour\nla [CS:P]Forêt Trompeuse[CR]!", german=" Okay![K] Auf zum [CS:P]Verwirrwald[CR]!", italian="Allora è deciso![K] Andiamo alla\n[CS:P]Foresta Inganno[CR]!", spanish="¡De acuerdo![K] ¡Vayamos al\n[CS:P]Bosque Misterio[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's give it our best,\n[hero]!", french="C'est le moment de donner\nle meilleur de nous-mêmes, [hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Vamos a hacerlo lo mejor\nposible, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="C'est le moment de donner\nle meilleur de nous-mêmes, [hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish="¡Tenemos que hacerlo\nlo mejor posible, [hero]!"})
  else
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="C'est le moment de donner\nle meilleur de nous-mêmes, [hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Tenemos que esforzarnos\nmucho, [hero]!"})
  end
  -- message_Close
  end
  end
end
