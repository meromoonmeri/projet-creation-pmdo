-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m05a0802.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
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
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Today was exhausting.)", french="(Quelle journée épuisante!)", german="(Heute war ein anstrengender Tag.)", italian="(Oggi è stata una giornata molto faticosa.)", spanish="(El día de hoy ha sido agotador.)"})
  else
  SkySceneKit.say({english="(Today was exhausting.)", french="(Quelle journée épuisante!)", german="(Heute war ein anstrengender Tag.)", italian="(Oggi è stata una giornata molto faticosa.)", spanish="(El día de hoy ha sido agotador.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I should get to sleep early.)", french="(Je ferais mieux d'aller me coucher de bonne\nheure.)", german="(Ich sollte früh ins Bett gehen.)", italian="(Dovrei andare a letto presto.)", spanish="(Debería acostarme temprano.)"})
  else
  SkySceneKit.say({english="(I should get to sleep early.)", french="(Je ferais mieux d'aller me coucher de bonne\nheure.)", german="(Ich sollte früh ins Bett gehen.)", italian="(Dovrei andare a letto presto.)", spanish="(Debería acostarme temprano.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sigh...[K] We went through a lot\ntoday, didn't we?", french="Pfff...[K] Nous en avons vu\ndes vertes et des pas mûres aujourd'hui,\npas vrai?", german="Seufz...[K] Wir haben heute einiges\nerlebt, was?", italian="Sigh...[K] Oggi ce ne sono\nsuccesse un sacco, vero?", spanish="Uf...[K] Hay que ver por lo que\nhemos pasado hoy, ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sigh...[K] We went through a lot\ntoday.", french="Pfff...[K] Nous en avons vu\ndes vertes et des pas mûres aujourd'hui,\npas vrai?", german="Seufz...[K] Wir haben heute einiges\nerlebt, was?", italian="Sigh...[K] Oggi ne sono successe di\ncose, vero?", spanish="Uf...[K] Hay que ver por lo que\nhemos pasado hoy, ¿no?"})
  else
  SkySceneKit.say({english="Sigh...[K] We went through a lot\ntoday, didn't we?", french="Pfff...[K] Nous en avons vu\ndes vertes et des pas mûres aujourd'hui,\npas vrai?", german="Seufz...[K] Wir haben heute einiges\nerlebt, was?", italian="Sigh...[K] È stata una giornata\ndavvero intensa oggi, vero?", spanish="Uf...[K] Hay que ver por lo que\nhemos pasado hoy, ¿a que sí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But you know what? It was\nincredibly fun for me!", french="Mais tu sais quoi? Je me suis\nbeaucoup amusé!", german="Aber weißt du was? Es hat mir\nrichtig Spaß gemacht!", italian="Ma sai una cosa? È stato\ndivertentissimo!", spanish="Pero ¿sabes una cosa?\n¡Me lo he pasado genial!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But you know what? It was\nincredibly fun for me!", french="Mais tu sais quoi? Je me suis\nbeaucoup amusé!", german="Aber weißt du was? Es hat mir\nrichtig Spaß gemacht!", italian="Ma sai una cosa? È stato\ndivertentissimo!", spanish="Pero ¿sabes una cosa?\n¡Creo que ha sido realmente divertido!"})
  else
  SkySceneKit.say({english="But you know what? It was\nincredibly fun for me!", french="Mais tu sais quoi? Je me suis\nbeaucoup amusée!", german="Aber weißt du was? Es hat mir\nrichtig Spaß gemacht!", italian="Ma sai una cosa? È stato\ndivertentissimo!", spanish="Pero, ¿sabes una cosa?\n¡Creo que ha sido realmente divertido!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sure, there was that huge\nletdown...", french="Bon, je dois avouer que je suis\nun peu déçu...", german="Klar, da war diese eine große\nEnttäuschung...", italian="Certo, c'è stata quella enorme\ndelusione...", spanish="Es cierto que al final nos\nhemos llevado un gran chasco..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sure, there was that huge\nletdown...", french="Bon, je dois avouer que je suis\nun peu déçu...", german="Klar, da war diese eine große\nEnttäuschung...", italian="Certo, c'è stata quella enorme\ndelusione...", spanish="Es cierto que al final nos\nhemos llevado un gran desengaño..."})
  else
  SkySceneKit.say({english="Sure, there was that huge\nletdown...", french="Bon, je dois avouer que je suis\nun peu déçue...", german="Klar, da war diese eine große\nEnttäuschung...", italian="Certo, c'è stata quella enorme\ndelusione...", spanish="Es cierto que al final nos\nhemos llevado una gran decepción..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But it was our first exploration!\nI thought I was going to explode from\nexcitement and anticipation the whole time.", french="Mais c'était notre première\nexploration! Je crois que je n'avais jamais\nété aussi impatient et euphorique!", german="Aber es war unsere erste\nErkundungstour! Ich dachte die ganze Zeit,\nich platze gleich vor Spannung und Vorfreude!", italian="Ma è stata la nostra prima\nesplorazione! Pensavo di esplodere\ndall'emozione!", spanish="Pero era nuestra primera\nexploración. ¡Y qué emocionante ha sido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But it was our first exploration!\nI thought I was going to explode from\nexcitement and anticipation the whole time.", french="Mais c'était notre première\nexploration! Je crois que je n'avais jamais\nété aussi impatient et euphorique!", german="Aber es war unsere erste\nErkundungstour! Ich dachte die ganze Zeit,\nich platze gleich vor Spannung und Vorfreude!", italian="Ma è stata la nostra prima\nesplorazione! Pensavo di esplodere\ndall'emozione!", spanish="Pero era nuestra primera\nexploración. ¡Y ha sido de lo más emocionante!"})
  else
  SkySceneKit.say({english="But it was our first exploration!\nI was ready to burst with excitement and\nanticipation the whole time.", french="Mais c'était notre première\nexploration! Je crois que je n'avais jamais\nété aussi impatiente et euphorique!", german="Aber es war unsere erste\nErkundungstour! Ich dachte die ganze Zeit,\nich platze gleich vor Spannung und Vorfreude!", italian="Ma è stata la nostra prima\nesplorazione! Pensavo di esplodere\ndall'emozione!", spanish="Pero era nuestra primera\nexploración. ¡Y ha sido increíblemente\nemocionante!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It made me feel glad I became\nan exploration team member.", french="J'ai compris que j'ai pris\nla bonne décision en devenant membre\nd'une équipe d'exploration.", german="Da war ich froh, dass ich\nMitglied eines Erkundungsteams geworden bin.", italian="Mi ha fatto sentire felice di\nessere diventato membro di una squadra\nd'esplorazione.", spanish="La verdad es que me alegro de\nhaberme convertido en explorador."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It made me realize I made the\nright decision in joining an exploration team.", french="J'ai compris que j'ai pris\nla bonne décision en devenant membre\nd'une équipe d'exploration.", german="Da wurde mir klar, dass es\nrichtig war, Mitglied in einem Erkundungsteam\nzu werden.", italian="Mi ha fatto sentire felice di\nessere diventato membro di una squadra\nd'esplorazione.", spanish="Esto me ha hecho darme cuenta\nde lo mucho que me gusta ser explorador."})
  else
  SkySceneKit.say({english="I realized I did the right thing in\nbecoming an exploration team member.", french="J'ai compris que j'ai pris\nla bonne décision en devenant membre\nd'une équipe d'exploration.", german="Mir wurde klar, dass es richtig\nwar, Mitglied in einem Erkundungsteam zu\nwerden.", italian="Mi ha fatta sentire felice di\nessere diventata membro di una squadra\nd'esplorazione.", spanish="Me he dado cuenta de que ha\nsido muy buena idea hacerme exploradora."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetOutputAttribute(4) [neutre/état moteur]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="One day I'm sure I'll solve the\nsecret of my Relic Fragment.", french="Et je suis sûr qu'un jour, je\ndécouvrirai le secret de mon Fragment de\nRelique.", german="Ich bin mir sicher, dass ich\neines Tages das Geheimnis meines\nReliktfragments lösen werde.", italian="Sono sicuro che un giorno\nrisolverò il mistero del Frammento Antico.", spanish="Seguro que un día de estos\nresolveré el misterio de mi Reliquia de\nPiedra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="One day I'm sure I'll solve the\nsecret of my Relic Fragment.", french="Et je suis sûr qu'un jour, je\ndécouvrirai le secret de mon Fragment de\nRelique.", german="Ich bin mir sicher, dass ich\neines Tages das Geheimnis meines\nReliktfragments lösen werde.", italian="Sono sicuro che un giorno\nrisolverò il mistero del Frammento Antico.", spanish="Seguro que un día de estos\nresolveré el misterio de mi Reliquia de\nPiedra."})
  else
  SkySceneKit.say({english="One day I'm sure I'll solve the\nsecret of my Relic Fragment.", french="Et je suis sûre qu'un jour, je\ndécouvrirai le secret de mon Fragment de\nRelique.", german="Ich bin mir sicher, dass ich\neines Tages das Geheimnis meines\nReliktfragments lösen werde.", italian="Sono sicura che un giorno\nrisolverò il mistero del Frammento Antico.", spanish="Seguro que un día de estos\nresolveré el misterio de mi Reliquia de\nPiedra."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's my dream.", french=" C'est mon plus grand rêve.", german=" Davon träume ich.", italian=" È il mio sogno.", spanish=" Ese es mi sueño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's the dream I have.", french=" C'est mon plus grand rêve.", german=" Das ist mein großer Traum.", italian=" È il mio sogno.", spanish=" Ese es mi mayor deseo."})
  else
  SkySceneKit.say({english=" That's my dream.", french=" C'est mon plus grand rêve.", german=" Das ist mein Traum.", italian=" È il mio sogno.", spanish=" Ese es mi sueño."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If it ever came true, I'd surely\nfaint from happiness!", french="S'il devenait réalité, je pense\nque j'en tomberais à la renverse tellement\nje serais heureux!", german="Wenn dieser Traum jemals\nwahr wird, falle ich vor Glück bestimmt in\nOhnmacht!", italian="Se riuscissi a realizzarlo, sono\nsicuro che sverrei dalla gioia!", spanish="Si consiguiera resolver el\nmisterio, ¡creo que me desmayaría de\nla felicidad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If it ever came true, I'd surely\nfaint from sheer happiness!", french="S'il devenait réalité, je pense\nque j'en tomberais à la renverse tellement\nje serais heureux!", german="Wenn er jemals wahr wird,\nfalle ich vor lauter Freude bestimmt in\nOhnmacht!", italian="Se riuscissi a realizzarlo, sono\nsicuro che sverrei dalla gioia!", spanish="Si consiguiera resolver el\nmisterio, ¡creo que me desmayaría de\nla felicidad!"})
  else
  SkySceneKit.say({english="If it ever came true, I'd surely\nfaint from sheer happiness!", french="S'il devenait réalité, je pense\nque j'en tomberais à la renverse tellement\nje serais heureuse!", german="Wenn er jemals wahr wird,\nfalle ich vor lauter Freude bestimmt in\nOhnmacht!", italian="Se riuscissi a realizzarlo, sono\nsicura che sverrei dalla gioia!", spanish="Si consiguiera resolver el\nmisterio, ¡creo que me desmayaría de\nla felicidad!"})
  end
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ha ha ha ha!", french=" Ha ha ha ha!", german=" Hahahaha!", italian=" Ah ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ha ha ha ha!", french=" Ha ha ha ha!", german=" Hahahaha!", italian=" Ah ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  else
  SkySceneKit.say({english=" Ha ha ha ha!", french=" Ha ha ha ha!", german=" Hahahaha!", italian=" Ah ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(90)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.DownRight)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But seriously, thanks...", french=" Du fond du cœur, merci...", german=" Aber im Ernst, danke!", italian=" Ma, sul serio, grazie...", spanish=" Pero, ahora en serio, gracias."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But seriously, thanks...", french=" Du fond du cœur, merci...", german=" Aber im Ernst, danke!", italian=" Ma, sul serio, grazie...", spanish=" Pero, ahora en serio, gracias."})
  else
  SkySceneKit.say({english=" But seriously, thanks...", french=" Du fond du cœur, merci...", german=" Aber im Ernst, danke!", italian=" Ma, sul serio, grazie...", spanish=" Pero, ahora en serio, gracias."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...!)", french="(...!)", german="(Wow!)", italian="(...!)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...!)", french="(...!)", german="(Wow!)", italian="(...!)", spanish="(...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I can explore because of you,\n[hero].", french="Si je fais aujourd'hui partie\nd'une équipe d'exploration, c'est grâce à toi,\n[hero].", german="Dass ich auf Erkundungen gehen\nkann, verdanke ich dir, [hero].", italian="È grazie a te che posso\nesplorare, [hero].", spanish="[hero], gracias a ti puedo\nexplorar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I can explore because of you,\n[hero].", french="Si je fais aujourd'hui partie\nd'une équipe d'exploration, c'est grâce à toi,\n[hero].", german="Dass ich auf Erkundungen gehen\nkann, verdanke ich dir, [hero].", italian="È grazie a te che posso\nesplorare, [hero].", spanish="[hero], gracias a ti puedo\nexplorar."})
  else
  SkySceneKit.say({english="I can explore because of you,\n[hero].", french="Si je fais aujourd'hui partie\nd'une équipe d'exploration, c'est grâce à toi,\n[hero].", german="Dass ich auf Erkundungen gehen\nkann, verdanke ich dir, [hero].", italian="È grazie a te che posso\nesplorare, [hero].", spanish="[hero], gracias a ti puedo\nexplorar."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup...", french=" Oui...", german=" Jawohl...", italian=" Già...", spanish=" Vaya."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes...", french=" Oui...", german=" Ja...", italian=" Già...", spanish=" Así es."})
  else
  SkySceneKit.say({english=" Yep...", french=" Oui...", german=" Ja...", italian=" Già...", spanish=" Claro."})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
