-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m03a1304.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_STORM_INSIDE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(30)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero].", french=" Hé, [hero].", german=" Hey, [hero].", italian=" Ehi, [hero].", spanish=" Oye, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Listen, [hero].", french=" Hé, [hero].", german=" Hör mal, [hero].", italian=" Ascolta, [hero].", spanish=" Oye, [hero]."})
  else
  SkySceneKit.say({english=" Say, [hero].", french=" Hé, [hero].", german=" Sag mal, [hero].", italian=" Ascolta, [hero].", spanish=" Oye, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Are you still awake,\n[hero]?", french="Tu dors,\n[hero]?", german="Bist du noch wach,\n[hero]?", italian="Stai già dormendo,\n[hero]?", spanish="¿Aún no te has dormido,\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Are you still awake,\n[hero]?", french="Tu dors,\n[hero]?", german="Bist du noch wach,\n[hero]?", italian="Stai già dormendo,\n[hero]?", spanish="¿Aún no te has dormido,\n[hero]?"})
  else
  SkySceneKit.say({english="Are you still awake,\n[hero]?", french="Tu dors,\n[hero]?", german="Bist du noch wach,\n[hero]?", italian="Stai già dormendo,\n[hero]?", spanish="¿Aún no te has dormido,\n[hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I've been thinking about this\nsince it happened.", french="J'ai repensé à ce qui s'est\npassé.", german="Seit diese Sache passiert ist,\ndenke ich ständig darüber nach.", italian="È da tempo che penso a una cosa\nche è successa.", spanish="Llevo pensando en esto\ndesde que ocurrió."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I've been thinking it over since\nit happened.", french="J'ai repensé à ce qui s'est\npassé.", german="Seit diese Sache passiert ist,\ndenke ich immer wieder darüber nach.", italian="È da tempo che penso a una cosa\nche è successa.", spanish="Llevo pensando en esto\ndesde que ocurrió."})
  else
  SkySceneKit.say({english="I've been thinking about it since\nit happened.", french="J'ai repensé à ce qui s'est\npassé.", german="Seit diese Sache passiert ist,\ndenke ich ständig darüber nach.", italian="È da tempo che penso a una cosa\nche è successa.", spanish="Llevo pensando en esto\ndesde que ocurrió."})
  end
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That weird dream you had,\n[hero]...", french="Ce rêve étrange que tu as\nfait, [hero]...", german="Dieser seltsame Traum von dir,\n[hero]...", italian="Quello strano sogno che hai\nfatto, [hero]...", spanish="Ese sueño tan raro que tuviste,\n[hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That strange dream you had,\n[hero]...", french="Ce rêve étrange que tu as\nfait, [hero]...", german="Dieser seltsame Traum von dir,\n[hero]...", italian="Quello strano sogno che hai\nfatto, [hero]...", spanish="Ese sueño tan raro que tuviste,\n[hero]..."})
  else
  SkySceneKit.say({english="That strange dream you had,\n[hero]...", french="Ce rêve étrange que tu as\nfait, [hero]...", german="Dieser seltsame Traum von dir,\n[hero]...", italian="Quello strano sogno che hai\nfatto, [hero]...", spanish="Ese sueño tan raro que tuviste,\n[hero]..."})
  end
  -- back_SetBackEffect(1) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe it has to do with you\npersonally, [hero].", french="... c'est peut-être un don\nunique que tu as là, [hero].", german="Vielleicht hat er etwas mit\ndir persönlich zu tun, [hero].", italian="Forse ti riguarda\npersonalmente, [hero].", spanish="Tal vez es algo que tiene\nque ver contigo, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Maybe it has to do with you\npersonally, [hero].", french="... c'est peut-être un don\nunique que tu as là, [hero].", german="Vielleicht hat er etwas mit\ndir persönlich zu tun, [hero].", italian="Forse ha in qualche modo a\nche fare con te, [hero].", spanish="Tal vez es algo que tiene\nque ver contigo, [hero]."})
  else
  SkySceneKit.say({english="Maybe it has to do with you\npersonally, [hero].", french="... c'est peut-être un don\nunique que tu as là, [hero].", german="Vielleicht hat er etwas mit\ndir persönlich zu tun, [hero].", italian="Che abbia in qualche modo a\nche fare con te, [hero]?", spanish="Tal vez es algo que tiene\nque ver contigo, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Huh?)", french="(Hum?)", german="(Äh?)", italian="(Eh?)", spanish="(¿Qué?)"})
  else
  SkySceneKit.say({english="(Huh?)", french="(Hum?)", german="(Äh?)", italian="(Eh?)", spanish="(¿Qué?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(60)
  -- back_SetBackEffect(1) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's just the feeling that I get.", french=" C'est juste une impression.", german=" Ich habe nur so ein Gefühl.", italian=" È solo una sensazione.", spanish=" Esa es la sensación que tengo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's just the feeling I get.", french=" C'est juste une impression.", german=" Ich habe nur so ein Gefühl.", italian=" Non so, è una sensazione...", spanish=" Esa es la sensación que tengo."})
  else
  SkySceneKit.say({english=" I can't quite say why.", french=" C'est juste une impression.", german=" Ich weiß nicht, warum.", italian="Non so perché, ma è una\nsensazione.", spanish=" Eso es lo que yo creo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I sure don't know any other\n[c_kind:PLAYER] who dreams about the future.", french="En tout cas, je ne connais pas\nd'autres [c_kind:PLAYER] qui rêvent du futur.", german="Jedenfalls kenne ich kein\nanderes [c_kind:PLAYER], das von der Zukunft\nträumt.", italian="Non conosco altri\n[c_kind:PLAYER] che sognano avvenimenti futuri.", spanish="Desde luego, no conozco a ningún\notro [c_kind:PLAYER] que sueñe lo que va a pasar\nen el futuro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I sure don't know any other\n[c_kind:PLAYER] who dreams about the future.", french="En tout cas, je ne connais pas\nd'autres [c_kind:PLAYER] qui rêvent du futur.", german="Jedenfalls kenne ich kein\nanderes [c_kind:PLAYER], das von der Zukunft\nträumt.", italian="Non conosco altri\n[c_kind:PLAYER] che sognano avvenimenti futuri.", spanish="Desde luego, no conozco a ningún\notro [c_kind:PLAYER] que sueñe lo que va a pasar\nen el futuro."})
  else
  SkySceneKit.say({english="I sure don't know any other\n[c_kind:PLAYER] who dreams about the future.", french="En tout cas, je ne connais pas\nd'autres [c_kind:PLAYER] qui rêvent du futur.", german="Jedenfalls kenne ich kein\nanderes [c_kind:PLAYER], das von der Zukunft\nträumt.", italian="Non ho mai sentito parlare di\n[c_kind:PLAYER] che sognano il futuro.", spanish="Desde luego, no conozco a ningún\notro [c_kind:PLAYER] que sueñe lo que va a pasar\nen el futuro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And I've never heard of a human\nsuddenly turning into a Pokémon either.", french="Et je n'ai jamais entendu parler\nd'un humain qui se serait transformé en\nPokémon non plus.", german="Und von einem Menschen, der\nplötzlich zu einem Pokémon geworden ist, habe\nich auch noch nie gehört.", italian="Non ho neanche mai sentito di un\numano che si trasforma improvvisamente in un\nPokémon.", spanish="Ni tampoco había oído nunca que\nun humano se pudiera convertir en Pokémon."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And I've never heard of a human\nsuddenly turning into a Pokémon either.", french="Et je n'ai jamais entendu parler\nd'un humain qui se serait transformé en\nPokémon non plus.", german="Und von einem Menschen, der\nplötzlich zu einem Pokémon geworden ist, habe\nich auch noch nie gehört.", italian="Non ho neanche mai sentito di un\numano che si trasforma improvvisamente in un\nPokémon.", spanish="Ni tampoco había oído nunca que\nun humano se pudiera convertir en Pokémon."})
  else
  SkySceneKit.say({english="And I've never heard of a human\nsuddenly turning into a Pokémon either.", french="Et je n'ai jamais entendu parler\nd'un humain qui se serait transformé en\nPokémon non plus.", german="Und von einem Menschen, der\nplötzlich zu einem Pokémon geworden ist, habe\nich auch noch nie gehört.", italian="Per non parlare di un umano\nche si trasforma improvvisamente in un\nPokémon...", spanish="Ni tampoco había oído nunca que\nun humano se pudiera convertir en Pokémon."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's why I think those two\nevents are connected.", french="C'est pour ça que je pense que\nces deux événements sont liés.", german="Darum glaube ich, dass diese\nbeiden Ereignisse zusammenhängen.", italian="È per questo che penso che i due\neventi siano collegati.", spanish="Por eso, creo que esas dos cosas\ntienen que estar relacionadas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why I think those two\nevents are connected.", french="C'est pour ça que je pense que\nces deux événements sont liés.", german="Darum glaube ich, dass diese\nbeiden Ereignisse zusammenhängen.", italian="È per questo che penso che i due\neventi siano collegati.", spanish="Por eso, creo que esas dos cosas\ntienen que estar relacionadas."})
  else
  SkySceneKit.say({english="That's why I think those two\nevents are connected.", french="C'est pour ça que je pense que\nces deux événements sont liés.", german="Darum glaube ich, dass diese\nbeiden Ereignisse zusammenhängen.", italian="È per questo che penso che i due\neventi siano collegati.", spanish="Por eso, creo que esas dos cosas\ntienen que estar relacionadas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I just can't shake that feeling.", french=" J'y crois dur comme fer.", german="Ich kann dieses Gefühl einfach\nnicht abschütteln.", italian="Non riesco proprio a togliermelo\ndalla testa.", spanish="No puedo quitarme de encima esa\nsensación."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I can't help feeling that way.", french=" J'y crois dur comme fer.", german="Das sagt mir einfach mein\nGefühl.", italian=" Sono certo che è così.", spanish="No puedo quitarme de encima esa\nsensación."})
  else
  SkySceneKit.say({english=" That's the feeling I keep getting.", french=" J'y crois dur comme fer.", german="Ich habe einfach ständig dieses\nGefühl.", italian="È una sensazione, ma sono\nsicura che è così.", spanish="No puedo quitarme de encima esa\nsensación."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The key to unlocking my memory...)", french="(La clé pour retrouver la mémoire...)", german="(Der Schlüssel zu meiner Erinnerung...)", italian="(La chiave per sbloccare la mia memoria...)", spanish="(La clave para recuperar mi memoria...)"})
  else
  SkySceneKit.say({english="(The key to unlocking my memory...)", french="(La clé pour retrouver la mémoire...)", german="(Der Schlüssel zu meiner Erinnerung...)", italian="(La chiave per sbloccare la mia memoria...)", spanish="(La clave para recuperar mi memoria...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Was it in that dream?)", french="(Faut-il la chercher dans ce rêve?)", german="(Liegt er etwa in meinem Traum?)", italian="(Potrebbe essere in quel sogno.)", spanish="(¿Estaba en ese sueño?)"})
  else
  SkySceneKit.say({english="(Was it in that dream?)", french="(Faut-il la chercher dans ce rêve?)", german="(Liegt er etwa in meinem Traum?)", italian="(Potrebbe essere in quel sogno.)", spanish="(¿Estaba en ese sueño?)"})
  end
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But even if that were true...)", french="(Même si c'était vrai...)", german="(Aber selbst wenn das stimmt...)", italian="(Ma anche se fosse così...)", spanish="(Pero aunque fuera verdad...)"})
  else
  SkySceneKit.say({english="(But even if that were true...)", french="(Même si c'était vrai...)", german="(Aber selbst wenn das stimmt...)", italian="(Ma anche se fosse così...)", spanish="(Pero aunque fuera verdad...)"})
  end
  -- back_SetBackEffect(1) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(How does it relate to anything else?)", french="(Quel est le rapport avec tout ça?)", german="(Wie passt das alles zusammen?)", italian="(Cosa c'entra il sogno con tutto il resto?)", spanish="(¿Qué relación tiene con todo lo demás?)"})
  else
  SkySceneKit.say({english="(How does it relate to anything else?)", french="(Quel est le rapport avec tout ça?)", german="(Wie passt das alles zusammen?)", italian="(Cosa c'entra il sogno con tutto il resto?)", spanish="(¿Qué relación tiene con todo lo demás?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't know what you were like\nas a human, [hero]...", french="Je ne sais pas comment tu étais\nen tant qu'être humain, [hero]...", german="Ich weiß zwar nicht, wie du als\nMensch so warst, [hero]...", italian="Non ho idea di come fossi quando\nnon eri ancora un Pokémon, [hero]...", spanish="No te conocí como ser humano,\n[hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I have no way of knowing what\nyou were like as a human, [hero]...", french="Je ne sais pas comment tu étais\nen tant qu'être humain, [hero]...", german="Ich weiß zwar nicht, was für\nein Mensch du warst, [hero]...", italian="Non posso sapere come fossi\nprima di diventare un Pokémon, [hero]...", spanish="No te conocí como ser humano,\n[hero]..."})
  else
  SkySceneKit.say({english="I don't know what you were like\nas a human, [hero]...", french="Je ne sais pas comment tu étais\nen tant qu'être humain, [hero]...", german="Ich weiß zwar nicht, wie du als\nMensch so warst, [hero]...", italian="Non posso sapere come fossi\nprima di diventare un Pokémon, [hero]...", spanish="No te conocí como ser humano,\n[hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I'm sure you were a\ngood person.", french="... mais je suis sûr que tu\nétais quelqu'un de bien.", german="Aber ich bin mir sicher, dass du\nein guter Mensch warst.", italian="Ma di sicuro eri una persona\na posto.", spanish="Pero estoy seguro de que eras\nuna buena persona."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I think you must have been\na good person.", french="... mais je suis sûr que tu\nétais quelqu'un de bien.", german="Aber ich glaube, du musst ein\nguter Mensch gewesen sein.", italian="Ma di sicuro eri una persona\nonesta.", spanish="Pero estoy seguro de que eras\nuna buena persona."})
  else
  SkySceneKit.say({english="But I think you must have been\na good person.", french="... mais je suis sûre que tu\nétais quelqu'un de bien.", german="Aber ich glaube, du musst ein\nguter Mensch gewesen sein.", italian="Ma sono certa che eri una brava\npersona.", spanish="Pero estoy segura de que eras\nuna buena persona."})
  end
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I mean, it was because of your\ndream, [hero], that we were able to\ncatch that bad Pokémon.", french="Après tout, si nous avons pu\ncapturer ce méchant Pokémon, c'est grâce\nà ton rêve, [hero].", german="Ich meine, es war dank deinem\nTraum, [hero], dass wir dieses\nbösartige Pokémon fangen konnten.", italian="Voglio dire, è stato grazie al tuo\nsogno, [hero], che abbiamo catturato\nquel Pokémon cattivo.", spanish="Quiero decir que, gracias a\ntu sueño, [hero], pudimos capturar\na aquel Pokémon malvado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After all, [hero], it was\nyour dream that helped us catch that\nbad Pokémon.", french="Après tout, si nous avons pu\ncapturer ce méchant Pokémon, c'est grâce\nà ton rêve, [hero].", german="Ich meine, es war dank deinem\nTraum, [hero], dass wir dieses\nbösartige Pokémon fangen konnten.", italian="Voglio dire, è stato grazie al tuo\nsogno, [hero], che abbiamo catturato\nquel Pokémon cattivo.", spanish="Después de todo, [hero],\ngracias a tu sueño pudimos capturar a aquel\nPokémon malvado."})
  else
  SkySceneKit.say({english="After all, [hero], it was\nyour dream that helped us catch that\nbad Pokémon.", french="Après tout, si nous avons pu\ncapturer ce méchant Pokémon, c'est grâce\nà ton rêve, [hero].", german="Ich meine, es war dank deinem\nTraum, [hero], dass wir dieses\nbösartige Pokémon fangen konnten.", italian="Voglio dire, è stato grazie al tuo\nsogno, [hero], che abbiamo catturato\nquel Pokémon cattivo.", spanish="Después de todo, [hero],\npudimos capturar a aquel Pokémon malvado\ngracias a tu sueño."})
  end
  -- back_SetBackEffect(1) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Bad Pokémon, huh...)", french="(Un méchant Pokémon, hum...)", german="(Bösartige Pokémon, hmm...)", italian="(Pokémon cattivo, eh...)", spanish="(Aquel Pokémon malvado...)"})
  else
  SkySceneKit.say({english="(Bad Pokémon, huh...)", french="(Un méchant Pokémon, hum...)", german="(Bösartige Pokémon, hmm...)", italian="(Pokémon cattivo, eh...)", spanish="(Aquel Pokémon malvado...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Oh! That reminds me of what [CS:N]Chatot[CR] said.)", french="(Oh! Ça me fait penser à ce qu'a dit [CS:N]Pijako[CR].)", german="(Oh! Das erinnert mich daran, was [CS:N]Plaudagei[CR]\ngesagt hat.)", italian="(Oh! Mi fa venire in mente quello che ha\ndetto [CS:N]Chatot[CR].)", spanish="(¡Oh! Eso me recuerda lo que dijo [CS:N]Chatot[CR].)"})
  else
  SkySceneKit.say({english="(Oh! That reminds me of what [CS:N]Chatot[CR] said.)", french="(Oh! Ça me fait penser à ce qu'a dit [CS:N]Pijako[CR].)", german="(Oh! Das erinnert mich daran, was [CS:N]Plaudagei[CR]\ngesagt hat.)", italian="(Oh! Mi fa venire in mente quello che ha\ndetto [CS:N]Chatot[CR].)", spanish="(¡Oh! Eso me recuerda lo que dijo [CS:N]Chatot[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That the growing number of bad Pokémon has\nbeen caused by time going out of whack.)", french="(Le nombre de méchants Pokémon augmente\nà cause de la perturbation du temps.)", german="(Dass die wachsende Anzahl bösartiger\nPokémon daher kommt, dass die Zeit\ndurcheinandergeraten ist.)", italian="(Che l'aumento del numero di Pokémon\ncattivi è causato dal tempo che non è più\nsotto controllo.)", spanish="(Que por culpa de los problemas con el tiempo\nahora hay más Pokémon malvados.)"})
  else
  SkySceneKit.say({english="(That the growing number of bad Pokémon has\nbeen caused by time going out of whack.)", french="(Le nombre de méchants Pokémon augmente\nà cause de la perturbation du temps.)", german="(Dass die wachsende Anzahl bösartiger\nPokémon daher kommt, dass die Zeit\ndurcheinandergeraten ist.)", italian="(Che l'aumento del numero di Pokémon\ncattivi è causato dal tempo che non è più\nsotto controllo.)", spanish="(Que por culpa de los problemas con el tiempo\nahora hay más Pokémon malvados.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You know...", french=" Tu sais...", german=" Weißt du...", italian=" Sai...", spanish=" ¿Sabes?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You know...", french=" Tu sais...", german=" Weißt du...", italian=" Sai...", spanish=" ¿Sabes?"})
  else
  SkySceneKit.say({english=" You know...", french=" Tu sais...", german=" Weißt du...", italian=" Sai...", spanish=" ¿Sabes?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Time is getting messed up,\nbit by bit, all over the world.", french="Petit à petit, le temps se\ndétraque sur toute la planète.", german="Die Zeit gerät durcheinander,\nStück für Stück, und zwar auf der ganzen\nWelt.", italian="... la distorsione del tempo si sta\nspargendo a macchia d'olio in tutto il mondo.", spanish="Cada vez hay más problemas\ncon el tiempo en todo el mundo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Time is getting messed up,\nbit by bit, all over the world.", french="Petit à petit, le temps se\ndétraque sur toute la planète.", german="Die Zeit gerät durcheinander,\nStück für Stück, und zwar auf der ganzen\nWelt.", italian="... poco alla volta, la distorsione\ndel tempo si sta allargando a tutto il mondo.", spanish="Cada vez hay más problemas\ncon el tiempo en todo el mundo."})
  else
  SkySceneKit.say({english="Time is getting messed up,\nbit by bit, all over the world.", french="Petit à petit, le temps se\ndétraque sur toute la planète.", german="Die Zeit gerät durcheinander,\nStück für Stück, und zwar auf der ganzen\nWelt.", italian="... la distorsione del tempo si sta\ndiffondendo ovunque nel mondo.", spanish="Cada vez hay más problemas\ncon el tiempo en todo el mundo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No one seems to know why.", french=" Personne ne sait pourquoi.", german="Niemand scheint den Grund zu\nkennen.", italian=" Nessuno sembra sapere perché.", spanish=" Nadie sabe por qué."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No one seems to know why.", french=" Personne ne sait pourquoi.", german="Niemand scheint den Grund zu\nkennen.", italian=" Nessuno sembra sapere perché.", spanish=" Nadie sabe por qué."})
  else
  SkySceneKit.say({english=" No one seems to know why.", french=" Personne ne sait pourquoi.", german="Niemand scheint den Grund zu\nkennen.", italian=" Nessuno sembra sapere perché.", spanish=" Nadie sabe por qué."})
  end
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But everyone believes that the\nTime Gears are somehow involved.", french="Mais on pense que ça a\nun rapport avec les Rouages du Temps.", german="Aber alle glauben, dass es\nirgendetwas mit den Zahnrädern der Zeit zu\ntun hat.", italian="Ma tutti ritengono che abbia\nqualcosa a che fare con gli Ingranaggi\ndel Tempo.", spanish="Pero se cree que tiene algo\nque ver con los Engranajes del Tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But everyone believes that the\nTime Gears are somehow involved.", french="Mais on pense que ça a\nun rapport avec les Rouages du Temps.", german="Aber alle glauben, dass es\nirgendetwas mit den Zahnrädern der Zeit zu\ntun hat.", italian="Ma tutti ritengono che abbia\nqualcosa a che fare con gli Ingranaggi\ndel Tempo.", spanish="Pero se cree que tiene algo\nque ver con los Engranajes del Tiempo."})
  else
  SkySceneKit.say({english="But everyone believes that the\nTime Gears are somehow involved.", french="Mais on pense que ça a\nun rapport avec les Rouages du Temps.", german="Aber alle glauben, dass es\nirgendetwas mit den Zahnrädern der Zeit zu\ntun hat.", italian="Ma tutti ritengono che abbia\nqualcosa a che fare con gli Ingranaggi\ndel Tempo.", spanish="Pero se cree que tiene algo\nque ver con los Engranajes del Tiempo."})
  end
  -- back_SetBackEffect(1) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Huh?[K] Time Gears?)", french="(Hein?[K] Les Rouages du Temps?)", german="(Äh?[K] Zahnräder der Zeit?)", italian="(Eh?[K] Ingranaggi del Tempo?)", spanish="(¿Cómo?[K] ¿Los Engranajes del Tiempo?)"})
  else
  SkySceneKit.say({english="(Huh?[K] Time Gears?)", french="(Hein?[K] Les Rouages du Temps?)", german="(Äh?[K] Zahnräder der Zeit?)", italian="(Eh?[K] Ingranaggi del Tempo?)", spanish="(¿Cómo?[K] ¿Los Engranajes del Tiempo?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They say Time Gears are hidden\nin secret places around the world.", french="On raconte que les\nRouages du Temps sont cachés dans des lieux\nsecrets dans le monde entier.", german="Es heißt, dass an geheimen\nOrten auf der ganzen Welt Zahnräder der Zeit\nversteckt sind.", italian="Si dice che gli Ingranaggi del\nTempo siano nascosti in luoghi segreti\nsparsi per il mondo.", spanish="Dicen que los Engranajes del\nTiempo están escondidos en lugares secretos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They say Time Gears are hidden\nin secret places around the world.", french="On raconte que les\nRouages du Temps sont cachés dans des lieux\nsecrets dans le monde entier.", german="Es heißt, dass an geheimen\nOrten auf der ganzen Welt Zahnräder der Zeit\nversteckt sind.", italian="Si dice che gli Ingranaggi del\nTempo siano nascosti in luoghi segreti\nsparsi per il mondo.", spanish="Dicen que los Engranajes del\nTiempo están escondidos en lugares secretos."})
  else
  SkySceneKit.say({english="They say Time Gears are hidden\nin secret places around the world.", french="On raconte que les\nRouages du Temps sont cachés dans des lieux\nsecrets dans le monde entier.", german="Es heißt, dass an geheimen\nOrten auf der ganzen Welt Zahnräder der Zeit\nversteckt sind.", italian="Si dice che gli Ingranaggi del\nTempo siano nascosti in luoghi segreti\nsparsi per il mondo.", spanish="Dicen que los Engranajes del\nTiempo están escondidos en lugares secretos."})
  end
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 30)
end
