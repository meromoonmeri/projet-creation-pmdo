-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/n01a3102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And so...", french="[CN]Et c'est comme ça...", german="[CN]Und so...", italian="[CN]E così...", spanish="[CN]Y así..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And so my exploration of [CS:P]Star Cave[CR]\n[CN]came to an end, yup yup.", french="[CN]C'est comme ça que mon exploration d'la\n[CN][CS:P]Caverne Etoile[CR] s'est terminée, pardi.", german="[CN]So kam meine Erkundung der\n[CN][CS:P]Sternenhöhle[CR] zu einem Ende, jawollja.", italian="[CN]E così la mia esplorazione della\n[CN][CS:P]Caverna Stellata[CR] è giunta alla\n[CN]fine, già, già.", spanish="[CN]Así fue como finalizó mi exploración\n[CN]de la [CS:P]Cueva Estrella[CR], sí, señor."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And now...", french="[CN]Et un beau jour...", german="[CN]Und nun...", italian="[CN]E ora...", spanish="[CN]Y ahora..."})
  -- message_Close
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_A_WISH_FOR_PEACE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? [c_name:NPC_HERO_FIRST].", french=" Hein? [c_name:NPC_HERO_FIRST].", german=" Huch! [c_name:NPC_HERO_FIRST].", italian=" Uh? [c_name:NPC_HERO_FIRST].", spanish=" ¿Eh? [c_name:NPC_HERO_FIRST]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? [c_name:NPC_HERO_FIRST].", french=" Hein? [c_name:NPC_HERO_FIRST].", german=" Huch! [c_name:NPC_HERO_FIRST].", italian=" Uh? [c_name:NPC_HERO_FIRST].", spanish=" ¿Eh? [c_name:NPC_HERO_FIRST]."})
  else
  SkySceneKit.say({english=" Huh? [c_name:NPC_HERO_FIRST].", french=" Hein? [c_name:NPC_HERO_FIRST].", german=" Huch! [c_name:NPC_HERO_FIRST].", italian=" Uh? [c_name:NPC_HERO_FIRST].", spanish=" ¿Eh? [c_name:NPC_HERO_FIRST]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Your eyes look a bit puffy,\n[c_name:NPC_HERO_FIRST]... What's wrong?[K] Couldn't sleep?", french="Tu as les yeux tout cernés,\n[c_name:NPC_HERO_FIRST]... Qu'est-ce qui se passe?[K]\nTu n'as pas dormi?", german="Deine Augen sind geschwollen,\n[c_name:NPC_HERO_FIRST]... Was ist los?[K]\nKonntest du nicht schlafen?", italian="Hai gli occhi un po' gonfi...\nChe succede?[K] Hai dormito male?", spanish="[c_name:NPC_HERO_FIRST], tienes los ojos un\npoco hinchados... ¿Qué pasa?[K] ¿No has dormido?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Your eyes look a bit puffy,\n[c_name:NPC_HERO_FIRST]... What's wrong?[K] Couldn't sleep?", french="Tu as les yeux tout cernés,\n[c_name:NPC_HERO_FIRST]... Qu'est-ce qui se passe?[K]\nTu n'as pas dormi?", german="Deine Augen sind geschwollen,\n[c_name:NPC_HERO_FIRST]... Was ist los?[K]\nKonntest du nicht schlafen?", italian="Hai gli occhi un po' gonfi...\nChe succede?[K] Hai dormito male?", spanish="[c_name:NPC_HERO_FIRST], tienes los ojos un\npoco hinchados... ¿Qué pasa?[K] ¿No has dormido?"})
  else
  SkySceneKit.say({english="Your eyes look a bit puffy,\n[c_name:NPC_HERO_FIRST]... What's wrong?[K] Couldn't sleep?", french="Tu as les yeux tout cernés,\n[c_name:NPC_HERO_FIRST]... Qu'est-ce qui se passe?[K]\nTu n'as pas dormi?", german="Deine Augen sind geschwollen,\n[c_name:NPC_HERO_FIRST]... Was ist los?[K]\nKonntest du nicht schlafen?", italian="Hai gli occhi un po' gonfi...\nChe succede?[K] Hai dormito male?", spanish="[c_name:NPC_HERO_FIRST], tienes los ojos un\npoco hinchados... ¿Qué pasa?[K] ¿No has dormido?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...Huh?[K] My eyes too?", french=" ... Hein?[K] Des cernes, moi aussi?", german=" ...Wie?[K] Meine Augen auch?", italian=" ... Eh?[K] Anche i miei occhi?", spanish=" ¿Eh...?[K] ¿Que yo también?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...Huh?[K] My eyes too?", french=" ... Hein?[K] Des cernes, moi aussi?", german=" ...Wie?[K] Meine Augen auch?", italian=" ... Eh?[K] Anche i miei occhi?", spanish=" ¿Cómo...?[K] ¿Que yo también?"})
  else
  SkySceneKit.say({english=" ...Huh?[K] My eyes too?", french=" ... Hein?[K] Des cernes, moi aussi?", german=" ...Wie?[K] Meine Augen auch?", italian=" ... Eh?[K] Anche i miei occhi?", spanish=" ¿Qué...?[K] ¿Que yo también?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I see.[K] We're pretty busy every\nday with assignments, aren't we?", french="Je vois.[K] Toutes ces tâches pour\nla Guilde, ça nous occupe comme il faut\ntous les jours, pas vrai?", german="Verstehe.[K] Wir haben jeden Tag\nrecht gut mit unseren Aufgaben zu tun, oder?", italian="Capisco.[K] D'altronde ogni giorno\nabbiamo parecchio lavoro da fare, no?", spanish="Pues vaya.[K] Es que siempre\nvamos hasta arriba de tareas, ¿eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I see.[K] We're pretty busy every\nday with assignments, aren't we?", french="Je vois.[K] Toutes ces tâches pour\nla Guilde, ça nous occupe comme il faut tous\nles jours, pas vrai?", german="Verstehe.[K] Wir haben jeden Tag\nrecht gut mit unseren Aufgaben zu tun, oder?", italian="Capisco.[K] D'altronde ogni giorno\nabbiamo parecchio lavoro da fare, no?", spanish="Ya...[K] Es que estamos muy\nliados con las tareas, ¿eh?"})
  else
  SkySceneKit.say({english="I see.[K] We're pretty busy every\nday with assignments, aren't we?", french="Je vois.[K] Toutes ces tâches pour\nla Guilde, ça nous occupe comme il faut tous\nles jours, pas vrai?", german="Verstehe.[K] Wir haben jeden Tag\nrecht gut mit unseren Aufgaben zu tun, oder?", italian="Capisco.[K] D'altronde ogni giorno\nabbiamo parecchio lavoro da fare, no?", spanish="Ya...[K] Es que estamos muy\nocupados con las tareas, ¿verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We've just entered the guild,\nand there's still so much we don't know, but...", french="On vient juste d'entrer dans la\nGuilde et on a encore tant de choses\nà apprendre...", german="Wir sind gerade erst Mitglieder\nder Gilde geworden und es gibt noch so viel,\ndas wir nicht wissen, aber...", italian="È da poco che siamo alla Gilda\ne ci sono ancora tante cose che non\nconosciamo, ma...", spanish="Acabamos de ingresar en el\n[CS:N]Pokégremio[CR] y aún nos queda mucho\npor aprender, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We've just entered the guild,\nand there's still so much we don't know, but...", french="On vient juste d'entrer dans la\nGuilde et on a encore tant de choses\nà apprendre...", german="Wir sind gerade erst Mitglieder\nder Gilde geworden und es gibt noch so viel,\ndas wir nicht wissen, aber...", italian="È da poco che siamo alla Gilda\ne ci sono ancora tante cose che non\nconosciamo, ma...", spanish="Acabamos de ingresar en el\n[CS:N]Pokégremio[CR] y aún nos falta mucho\npor aprender, pero..."})
  else
  SkySceneKit.say({english="We've just entered the guild,\nand there's still so much we don't know, but...", french="On vient juste d'entrer dans la\nGuilde et on a encore tant de choses\nà apprendre...", german="Wir sind gerade erst Mitglieder\nder Gilde geworden und es gibt noch so viel,\ndas wir nicht wissen, aber...", italian="È da poco che siamo alla Gilda\ne ci sono ancora tante cose che non\nconosciamo, ma...", spanish="Acabamos de ingresar en el\n[CS:N]Pokégremio[CR] y aún hay muchas cosas que\nno sabemos, pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's keep at it!", french=" Poursuivons sur cette voie!", german=" Lass uns dranbleiben!", italian=" ... mettiamocela tutta!", spanish=" ¡Hay que seguir adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's keep at it!", french=" Poursuivons sur cette voie!", german=" Lass uns dranbleiben!", italian=" ... mettiamocela tutta!", spanish=" ¡No podemos bajar el ritmo!"})
  else
  SkySceneKit.say({english=" Let's keep at it!", french=" Poursuivons sur cette voie!", german=" Lass uns dranbleiben!", italian=" ... mettiamocela tutta!", spanish=" ¡Hay que continuar!"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-96), g.ViewCenter.Y+(0), 96, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GAME:MoveCamera(388, 252, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Really...", french="[CN]Vraiment...", german="[CN]Es stimmt...", italian="[CN]Sì...", spanish="[CN]Por fin..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]There really is a new\n[CN]apprentice!", french="[CN]Y'a une nouvelle recrue!", german="[CN]Es gibt wirklich einen\n[CN]neuen Lehrling!", italian="[CN]C'è davvero un nuovo\n[CN]apprendista!", spanish="[CN]¡Hay alguien nuevo!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]And not only that...[K]\n[CN]There are two of them![K] Sniff...", french="[CN]C'est pas tout...[K]\n[CN]Y'en a même deux![K] Snif...", german="[CN]Und nicht nur einen...[K]\n[CN]Es sind sogar zwei![K] Schnüff...", italian="[CN]No, un momento...[K]\n[CN]Ce ne sono due![K] Sniff...", spanish="[CN]Y además...[K]\n[CN]¡Son dos![K] Qué emoción..."})
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][CS:N]Jirachi[CR]!\n[CN]Thank you so much! Yup yup!", french="[CN][CS:N]Jirachi[CR]!\n[CN]Merci pour tout! Ouaip ouaip!", german="[CN][CS:N]Jirachi[CR]!\n[CN]Ich danke dir so sehr! Jawollja!", italian="[CN][CS:N]Jirachi[CR]!\n[CN]Ti ringrazio di cuore! Già, già!", spanish="[CN]¡Muchas gracias, [CS:N]Jirachi[CR]!\n[CN]¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]As your older buddy, [c_name:NPC_HERO_FIRST]\n[CN]and [c_name:NPC_PARTNER_FIRST], I won't let you down!", french="[CN]Maintenant, c'est à vous d'faire vos preuves,\n[CN][c_name:NPC_HERO_FIRST] et [c_name:NPC_PARTNER_FIRST]!", german="[CN]Ich werde euch nicht enttäuschen,\n[CN][c_name:NPC_HERO_FIRST] und [c_name:NPC_PARTNER_FIRST]!", italian="[CN][c_name:NPC_HERO_FIRST] e [c_name:NPC_PARTNER_FIRST], non vi deluderò!\n[CN]Fidatevi della mia esperienza come esploratore!", spanish="[CN]¡[c_name:NPC_HERO_FIRST], [c_name:NPC_PARTNER_FIRST],\n[CN]podréis confiar en mí!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]I'm going to work hard at my guild\n[CN]training each and every day!", french="[CN]Je vais m'donner à fond à la Guilde\n[CN]et m'entraîner tous les jours, ouaip!", german="[CN]Ich werde mich anstrengen und aus\n[CN]jedem Tag das Beste rausholen!", italian="[CN]Lavorerò sodo qui alla Gilda\n[CN]allenandomi ogni giorno!", spanish="[CN]Pienso trabajar muy duro en mis tareas\n[CN]del [CS:N]Pokégremio[CR], día a día."})
  -- message_Close
  GAME:WaitFrames(60)
end
