-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m03a1302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_STORM_INSIDE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6424) — id SE NDS sans portage PMDO identifié
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(60)
  -- back_SetBackEffect(1) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! That lightning's intense!", french=" Waouh! Quel éclair!", german="Boah! Diese Blitze sind\nWahnsinn!", italian=" Wow! Hai visto che fulmine?", spanish=" ¡Vaya! ¡Menuda tormenta!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow, that lightning's intense!", french=" Waouh! Quel éclair!", german="Boah! Diese Blitze sind\nWahnsinn!", italian=" Wow! Hai visto che fulmine?", spanish=" ¡Vaya! ¡Menuda tormenta!"})
  else
  SkySceneKit.say({english=" Wow, that lightning's intense!", french=" Waouh! Quel éclair!", german="Boah! Diese Blitze sind\nWahnsinn!", italian="Wow! Mai visto un fulmine del\ngenere!", spanish=" ¡Vaya! ¡Menuda tormenta!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It looks like it's really\nstormy tonight...", french="On dirait qu'il va y avoir de\nl'orage cette nuit...", german="Sieht nach einem heftigen\nGewitter aus heute Nacht.", italian="Stanotte c'è\nproprio una bella tempesta...", spanish="¡Menuda tormenta que está\ncayendo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It looks like it's really\nstormy tonight...", french="On dirait qu'il va y avoir de\nl'orage cette nuit...", german="Sieht nach einem heftigen\nGewitter aus heute Nacht.", italian="Stanotte c'è proprio\nun bel temporale!", spanish="¡Vaya tormenta que hay esta\nnoche!"})
  else
  SkySceneKit.say({english="It looks like it's really\nstormy tonight...", french="On dirait qu'il va y avoir de\nl'orage cette nuit...", german="Sieht nach einem heftigen\nGewitter aus heute Nacht.", italian="Stanotte c'è proprio\nun bel temporale!", spanish=" ¡Menuda tormenta está cayendo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wait a second!", french=" Attends une minute!", german=" Moment mal!", italian=" Aspetta un attimo!", spanish=" ¡Espera!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hold on!", french=" Attends une minute!", german=" Warte mal!", italian=" Aspetta un attimo!", spanish=" ¡Un momento!"})
  else
  SkySceneKit.say({english=" That reminds me!", french=" Attends une minute!", german=" Das erinnert mich an etwas!", italian=" Aspetta un attimo!", spanish=" Ahora que lo pienso..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You know the night before we\nmet, [hero]?", french="Tu te souviens de la nuit avant\nnotre rencontre, [hero]?", german="Weißt du, was in der Nacht\nwar, bevor wir uns trafen, [hero]?", italian="Ti ricordi la notte prima del\nnostro incontro, [hero]?", spanish="¿Te acuerdas de la noche de\nantes de conocernos, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You know the night before we\nmet, [hero]?", french="Tu te souviens de la nuit avant\nnotre rencontre, [hero]?", german="Weißt du, was in der Nacht\nwar, bevor wir uns trafen, [hero]?", italian="Ti ricordi la notte prima del\nnostro incontro, [hero]?", spanish="¿Te acuerdas de la noche de\nantes de conocernos, [hero]?"})
  else
  SkySceneKit.say({english="You know the night before we\nmet, [hero]?", french="Tu te souviens de la nuit avant\nnotre rencontre, [hero]?", german="Weißt du, was in der Nacht\nwar, bevor wir uns trafen, [hero]?", italian="Ti ricordi la notte prima del\nnostro incontro, [hero]?", spanish="¿Te acuerdas de la noche de\nantes de que nos conociéramos, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It was storming that night.", french="Il y a eu un orage cette\nnuit-là aussi.", german="In jener Nacht gab es auch ein\nGewitter.", italian=" C'era una tempesta quella notte.", spanish=" Aquella noche hubo una tormenta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It was storming that night.", french="Il y a eu un orage cette\nnuit-là aussi.", german="In jener Nacht gab es auch ein\nGewitter.", italian=" C'era una tempesta quella notte.", spanish=" Aquella noche hubo una tormenta."})
  else
  SkySceneKit.say({english=" It was storming that night.", french="Il y a eu une tempête cette\nnuit-là.", german="In jener Nacht gab es auch ein\nGewitter.", italian=" C'era una tempesta quella notte.", spanish=" Aquella noche hubo una tormenta."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I found you out cold on the\nbeach the day after that stormy night,\n[hero].", french="Et le lendemain, tu gisais sans\nconnaissance sur la plage, [hero].", german="Am Morgen nach dieser\nstürmischen Nacht lagst du bewusstlos am\nStrand, [hero].", italian="Il giorno dopo giacevi\nincosciente sulla spiaggia, [hero].", spanish="Te encontré inconsciente\nen la playa al día siguiente, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I found you out cold on the\nbeach the day after that stormy night,\n[hero].", french="Et le lendemain, tu gisais sans\nconnaissance sur la plage, [hero].", german="Am Morgen nach dieser\nstürmischen Nacht lagst du bewusstlos am\nStrand, [hero].", italian="Il giorno dopo giacevi\nincosciente sulla spiaggia, [hero].", spanish="Te encontré inconsciente\nen la playa al día siguiente, [hero]."})
  else
  SkySceneKit.say({english="I found you out cold on the\nbeach the day after that stormy night,\n[hero].", french="Et le lendemain, tu gisais sans\nconnaissance sur la plage, [hero].", german="Am Morgen nach dieser\nstürmischen Nacht lagst du bewusstlos am\nStrand, [hero].", italian="Il giorno dopo giacevi\nincosciente sulla spiaggia, [hero].", spanish="Te encontré inconsciente\nen la playa al día siguiente, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Do you remember why you were\nout cold on the beach?[K] Can you remember\nanything at all?", french="Tu te rappelles pourquoi?[K]\nEst-ce que tu te souviens de quoi que\nce soit?", german="Weißt du wieder, warum du\nbewusstlos am Strand lagst?[K] Erinnerst du dich\nan irgendetwas?", italian="Come mai eri sulla spiaggia?[K]\nTi ricordi qualcosa?", spanish="¿Recuerdas por qué estabas\ninconsciente en la playa?[K] ¿Recuerdas algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well? Do you remember anything\nabout being out cold on the beach?[K] Can you\nremember anything at all?", french="Tu te rappelles pourquoi?[K]\nEst-ce que tu te souviens de quoi que\nce soit?", german="Und? Weißt du wieder, warum\ndu bewusstlos am Strand lagst?[K] Erinnerst du\ndich an irgendetwas?", italian="Come mai eri sulla spiaggia?[K]\nTi ricordi qualcosa?", spanish="¿Recuerdas por qué te habías\ndesmayado en la playa?[K] ¿Recuerdas algo?"})
  else
  SkySceneKit.say({english="So do you remember anything\nabout being out cold on the beach?[K] Can you\nremember anything at all?", french="Tu te rappelles pourquoi?[K]\nEst-ce que tu te souviens de quoi que\nce soit?", german="Weißt du wieder, warum du\nbewusstlos am Strand lagst?[K] Erinnerst du dich\nan irgendetwas?", italian="Come mai eri sulla spiaggia?[K]\nTi ricordi qualcosa?", spanish="¿Recuerdas por qué te habías\ndesmayado en la playa?[K] ¿Recuerdas algo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I wonder...[K] Hmm...)", french="(Je ne sais plus...[K] Hum...)", german="(Ich frage mich...[K] Hmm...)", italian="(Mi chiedo...[K] Mmm...)", spanish="(Me pregunto qué pasó...[K] Hum...)"})
  else
  SkySceneKit.say({english="(I wonder...[K] Hmm...)", french="(Je ne sais plus...[K] Hum...)", german="(Ich frage mich...[K] Hmm...)", italian="(Mi chiedo...[K] Mmm...)", spanish="(¿Qué me pasó?[K] Hum...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There was a storm... But how did I end up\nunconscious there?)", french="(C'était en plein orage... mais comment\nai-je échoué sur cette plage?)", german="(Es gab ein Gewitter, aber wieso lag ich\ndanach bewusstlos am Strand?)", italian="(C'era una tempesta... Ma come sono\narrivato lì privo di sensi?)", spanish="(Hubo una tormenta... ¿Pero cómo acabé\ndesmayado allí?)"})
  else
  SkySceneKit.say({english="(There was a storm... But how did I end up\nunconscious there?)", french="(C'était en plein orage... mais comment\nai-je échoué sur cette plage?)", german="(Es gab ein Gewitter, aber wieso lag ich\ndanach bewusstlos am Strand?)", italian="(C'era una tempesta... Ma come sono\narrivata lì priva di sensi?)", spanish="(Hubo una tormenta... ¿Pero cómo acabé\ndesmayada allí?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Nope. I can't remember a thing.)", french="(Non. Je ne me souviens de rien.)", german="(Nein. Ich erinnere mich an nichts.)", italian="(No. Non mi ricordo niente.)", spanish="(¡No puedo recordar nada!)"})
  else
  SkySceneKit.say({english="(Nope. I can't remember a thing.)", french="(Non. Je ne me souviens de rien.)", german="(Nein. Ich erinnere mich an nichts.)", italian="(No. Non mi ricordo niente.)", spanish="(¡No puedo recordar nada!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I guess it won't be that easy.", french="Je suppose que ça ne va pas\nte revenir aussi facilement.", german=" So einfach geht es wohl nicht.", italian="Immagino che non sarà\ncosì facile.", spanish="Supongo que no va a ser\ntan fácil."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I guess it won't be that easy.", french="Je suppose que ça ne va pas\nte revenir aussi facilement.", german=" So einfach geht es wohl nicht.", italian="Immagino che non sarà\ncosì facile.", spanish="Supongo que no va a ser\ntan fácil."})
  else
  SkySceneKit.say({english=" I guess it won't be that easy.", french="Je suppose que ça ne va pas\nte revenir aussi facilement.", german=" So einfach geht es wohl nicht.", italian="Immagino che non sarà\ncosì facile.", spanish="Supongo que no va a ser\ntan fácil."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But that's all right. Just try\nremembering a little at a time.", french="Ce n'est pas grave. Essaie\nde t'en souvenir petit à petit.", german="Aber das ist in Ordnung.\nVersuche einfach, dich Stück für Stück zu\nerinnern.", italian="Ma va bene così. Prova a\nricordare un po' alla volta.", spanish="Pero no importa. Intenta ir\nrecordando alguna cosa, poco a poco."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But that's all right. Just try\nremembering a little at a time.", french="Ce n'est pas grave. Essaie\nde t'en souvenir petit à petit.", german="Aber das ist in Ordnung.\nVersuche einfach, dich Stück für Stück zu\nerinnern.", italian="Non importa. Prova a\nricordare un po' alla volta.", spanish="Pero no importa. Intenta ir\nrecordando lo que puedas, poco a poco."})
  else
  SkySceneKit.say({english="But that's all right. Just try\nremembering a little at a time.", french="Ce n'est pas grave. Essaie\nde t'en souvenir petit à petit.", german="Aber das ist in Ordnung.\nVersuche einfach, dich Stück für Stück zu\nerinnern.", italian="Non importa se ora non ce la\nfai. Prova a ricordare un po' alla volta.", spanish="Pero no importa. Intenta ir\nrecordando lo que puedas, poco a poco."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(120)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to get up early again\ntomorrow. Let's get some sleep.", french="Demain, on doit se lever tôt.\nAllons nous coucher.", german="Wir müssen morgen wieder\nfrüh aufstehen. Legen wir uns schlafen.", italian="Domani dobbiamo alzarci di\nnuovo presto. Andiamo a dormire.", spanish="Mañana también tenemos que\nmadrugar. Habrá que dormir un poco."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to get up early again\ntomorrow. Let's get some sleep.", french="Demain, on doit se lever tôt.\nAllons nous coucher.", german="Wir müssen morgen wieder\nfrüh aufstehen. Legen wir uns schlafen.", italian="Domani dobbiamo alzarci di\nnuovo presto. Andiamo a dormire.", spanish="Mañana también tendremos\nque madrugar. Intenta dormir un poco."})
  else
  SkySceneKit.say({english="We have to get up early again\ntomorrow. Let's get some sleep.", french="Demain, on doit se lever tôt.\nAllons nous coucher.", german="Wir müssen morgen wieder\nfrüh aufstehen. Legen wir uns schlafen.", italian="Domani dobbiamo alzarci di\nnuovo presto. Andiamo a dormire.", spanish="Mañana también tenemos que\nmadrugar, así que vamos a dormir."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
end
