-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/m00p0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTN) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero].", french=" Dis, [hero].", german=" Hey, [hero].", italian=" Ehi, [hero].", spanish=" Una cosa, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Listen, [hero].", french=" Dis, [hero].", german=" Hör mal, [hero].", italian=" Ascolta, [hero].", spanish=" Escucha, [hero]."})
  else
  SkySceneKit.say({english=" Say, [hero].", french=" Dis, [hero].", german=" Sag mal, [hero].", italian=" Ehilà, [hero].", spanish=" Por cierto, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When we go to [CS:P]Mt. Travail[CR], you\nought to lead, [hero].", french="Quand on sera au [CS:P]Mt Labeur[CR],\nc'est toi qui devras être le meneur,\n[hero].", german="Wenn wir zum [CS:P]Mühsalberg[CR]\ngehen, musst du uns anführen, [hero].", italian="Quando andremo al [CS:P]Monte[CR]\n[CS:P]Odissea[CR], dovrai essere tu il leader,\n[hero].", spanish="Cuando vayamos al\n[CS:P]Monte Tribulaciones[CR], tú tendrás que\nliderar el grupo, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When we go to [CS:P]Mt. Travail[CR], you\nshould be the leader, [hero].", french="Quand on sera au [CS:P]Mt Labeur[CR],\nc'est toi qui devras être le meneur,\n[hero].", german="Wenn wir zum [CS:P]Mühsalberg[CR]\ngehen, solltest du Anführer sein, [hero].", italian="Quando andremo al [CS:P]Monte[CR]\n[CS:P]Odissea[CR], dovrai essere tu il leader,\n[hero].", spanish="Cuando vayamos al\n[CS:P]Monte Tribulaciones[CR], será mejor\nque tú lideres el grupo, [hero]."})
  else
  SkySceneKit.say({english="When we go to [CS:P]Mt. Travail[CR], you\nshould go as the leader, [hero].", french="Quand on sera au [CS:P]Mt Labeur[CR],\nc'est toi qui devras être le meneur,\n[hero].", german="Wenn wir zum [CS:P]Mühsalberg[CR]\ngehen, solltest du Anführer sein, [hero].", italian="Quando andremo al [CS:P]Monte[CR]\n[CS:P]Odissea[CR], dovrai essere tu il leader,\n[hero].", spanish="Cuando vayamos al\n[CS:P]Monte Tribulaciones[CR], tú deberías\nliderar el grupo, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="After all, that's the way we've\nalways done it for important missions.", french="Après tout, c'est toujours\ncomme ça qu'on a fait pour les missions\nimportantes.", german="So haben wir es bei wichtigen\nMissionen schließlich immer gemacht.", italian="Dopotutto, abbiamo fatto sempre\ncosì per le missioni importanti.", spanish="Después de todo, así es como\nlo hemos hecho siempre en las misiones\nimportantes."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After all, that's the way we've\nalways handled things on important missions.", french="Après tout, c'est toujours\ncomme ça qu'on a fait pour les missions\nimportantes.", german="Das haben wir bei wichtigen\nMissionen schließlich immer so gemacht.", italian="Dopotutto, abbiamo fatto sempre\ncosì per le missioni importanti.", spanish="Después de todo, así ha sido\nsiempre en las misiones importantes."})
  else
  SkySceneKit.say({english="After all, we've always gone on\nour important missions that way.", french="Après tout, c'est toujours\ncomme ça qu'on a fait pour les missions\nimportantes.", german="So war es schließlich immer,\nwenn wir auf wichtige Missionen gegangen\nsind.", italian="Dopotutto, abbiamo fatto sempre\ncosì per le missioni importanti.", spanish="Después de todo, siempre\nhemos ido así en las misiones importantes."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So I was thinking that you ought\nto be the leader again, [hero]...[K]\nWhat do you say?", french="Je me disais donc que tu devrais\nreprendre ton rôle de meneur...[K]\nQu'en penses-tu, [hero]?", german="Also, ich finde, dass du wieder\nder Anführer sein solltest, [hero]...[K]\nWas sagst du?", italian="Quindi stavo pensando che\nsarebbe meglio che facessi tu il leader,\n[hero]...[K] Cosa ne dici?", spanish="Por eso tengo clarísimo que\ndeberías liderar el grupo otra vez,\n[hero]...[K] ¿Qué me dices?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why I think you should\nbe the leader again, [hero]...[K]\nWhat do you say?", french="Je me disais donc que tu devrais\nreprendre ton rôle de meneur...[K]\nQu'en penses-tu, [hero]?", german="Darum solltest du wieder der\nAnführer sein, [hero]...[K]\nWas sagst du?", italian="Quindi stavo pensando che\nsarebbe meglio che facessi tu il leader,\n[hero]...[K] Cosa ne dici?", spanish="Por eso creo que deberías\nliderar el grupo otra vez, [hero]...[K]\n¿Qué me dices?"})
  else
  SkySceneKit.say({english="That's why I think you should\nbe the leader again, [hero]...[K]\nWhat do you say?", french="Je me disais donc que tu devrais\nreprendre ton rôle de meneur...[K]\nQu'en penses-tu, [hero]?", german="Darum solltest du wieder der\nAnführer sein, [hero]...[K]\nWas sagst du?", italian="Quindi stavo pensando che\nsarebbe meglio che facessi tu il leader,\n[hero]...[K] Cosa ne dici?", spanish="Por eso sería bueno que\nvolvieras a liderar el grupo,\n[hero]...[K] ¿No te parece?"})
  end
  do local __choice = SkySceneKit.ask({{english="Accept leadership", french="Accepter d'être le meneur", german="Wieder Anführer werden", italian="Accetta", spanish="Aceptar el liderazgo"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa![K] Hang on, we're going\nwith me as leader?", french="Quoi?[K] Attends, tu veux que\nce soit moi le meneur?", german="Boah![K] Moment mal, wir gehen\nmit mir als Anführer?", italian="Wow![K] Aspetta un momento,\nsarò io il leader?", spanish="¡Alto ahí![K] Espera un momento,\n¿vamos a ir conmigo de líder?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?[K] Wait, so I'm going as\nthe leader?", french="Quoi?[K] Attends, tu veux que\nce soit moi le meneur?", german="Was?[K] Warte mal, ich bin also\nder Anführer?", italian=" Cosa?[K] Quindi sarò io il leader?", spanish="¡Un segundo![K] Oye,\n¿vamos a ir conmigo de líder?"})
  else
  SkySceneKit.say({english="What?[K] So I'm going to go as\nthe leader?", french="Quoi?[K] Attends, tu veux que\nce soit moi le meneur?", german="Was?[K] Warte mal, ich soll also\nder Anführer sein?", italian="Cosa?[K] Quindi devo fare io da\nleader della squadra?", spanish="Pero...[K] ¿Es que\nme vas a hacer ir de líder?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmm...[K] I don't feel confident\nabout doing that...", french="Hum...[K] Je ne suis pas assez sûr\nde moi pour faire ça...", german="Hmm...[K] Ich fühle mich dabei\nnicht wirklich wohl...", italian="Mmm...[K] Non me la sento\ndi farlo...", spanish="Hum...[K] No sé si valgo\npara ocupar ese puesto..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmm...[K] I don't have the\nconfidence to do that...", french="Hum...[K] Je ne suis pas assez sûr\nde moi pour faire ça...", german="Hmm...[K] Ich traue mir das nicht\nso richtig zu...", italian="Mmm...[K] Non me la sento\ndi farlo...", spanish="Hum...[K] No tengo suficiente\nconfianza para hacer eso..."})
  else
  SkySceneKit.say({english="Hmm...[K] I don't feel confident\nenough to be the leader...", french="Hum...[K] Je ne suis pas assez sûre\nde moi pour jouer ce rôle à ta place...", german="Hmm...[K] Ich traue mir nicht zu,\ndas Team anzuführen...", italian="Mmm...[K] Non me la sento\ndi farlo...", spanish="Uf...[K] No me siento segura\npara ocupar el puesto de líder..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we're going to [CS:P]Mt. Travail[CR],\nyou should be the leader, [hero]...", french="Si on va au [CS:P]Mt Labeur[CR],\nc'est vraiment toi qui devrais être le meneur,\n[hero]...", german="Wenn wir zum [CS:P]Mühsalberg[CR]\ngehen, dann mit dir als Anführer,\n[hero].", italian="Se andiamo al [CS:P]Monte Odissea[CR],\ndevi fare tu da leader, [hero]...", spanish="Si pretendes que vayamos al\n[CS:P]Monte Tribulaciones[CR], tú tendrás\nque liderar el grupo, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we're going to [CS:P]Mt. Travail[CR],\nyou should be the leader, [hero]...", french="Si on va au [CS:P]Mt Labeur[CR],\nc'est vraiment toi qui devrais être le meneur,\n[hero]...", german="Wenn wir zum [CS:P]Mühsalberg[CR]\ngehen, dann mit dir als Anführer,\n[hero].", italian="Se andiamo al [CS:P]Monte Odissea[CR],\ndevi fare tu da leader, [hero]...", spanish="Si vamos a ir al\n[CS:P]Monte Tribulaciones[CR], tendrías que\nliderar el grupo tú, [hero]."})
  else
  SkySceneKit.say({english="If we're still going to go to\n[CS:P]Mt. Travail[CR], you should lead, [hero]...", french="Si on va au [CS:P]Mt Labeur[CR],\nc'est vraiment toi qui devrais être le meneur,\n[hero]...", german="Wenn wir nun zum [CS:P]Mühsalberg[CR]\ngehen, dann mit dir als Anführer,\n[hero].", italian="Se andiamo al [CS:P]Monte Odissea[CR],\ndevi fare tu da leader, [hero]...", spanish="Si realmente vamos a ir al\n[CS:P]Monte Tribulaciones[CR] yo preferiría\nseguirte a ti, [hero]."})
  end
  -- message_Close
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Cool![K] That's it, then! You're the\nleader, [hero].", french="Super![K] C'est entendu.\nC'est toi le meneur, [hero].", german="Cool![K] Also abgemacht!\nDu bist der Anführer, [hero].", italian="Bene![K] È deciso! Farai tu da\nleader, [hero].", spanish="¡Genial![K] ¡Entonces ya está\ndecidido! [hero], tú liderarás el grupo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK![K] That's settled. You're the\nleader, [hero].", french="Super![K] C'est entendu.\nC'est toi le meneur, [hero].", german="Okay![K] Das hätten wir. Du bist\nder Anführer, [hero].", italian="Ok![K] La decisione è presa.\nFarai tu da leader, [hero].", spanish="¡De acuerdo![K] ¡Entonces ya está\ndecidido! [hero], tú liderarás el grupo."})
  else
  SkySceneKit.say({english="OK![K] You're the team leader,\n[hero]!", french="Super![K] C'est entendu.\nC'est toi le meneur, [hero].", german="Okay![K] Du bist unser\nTeam-Anführer, [hero]!", italian="Ok![K] Farai tu da leader,\n[hero]!", spanish="¡Estupendo![K] ¡[hero], tú\nliderarás el grupo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's get rolling to [CS:P]Mt. Travail[CR]!", french="C'est parti, rendons-nous\nau [CS:P]Mt Labeur[CR]!", german="Starten wir in Richtung\n[CS:P]Mühsalberg[CR]!", italian=" Partiamo per il [CS:P]Monte Odissea[CR]!", spanish="¡Vámonos ya al\n[CS:P]Monte Tribulaciones[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's set out for [CS:P]Mt. Travail[CR]!", french="C'est parti, rendons-nous\nau [CS:P]Mt Labeur[CR]!", german="Machen wir uns auf den Weg\nzum [CS:P]Mühsalberg[CR]!", italian=" Partiamo per il [CS:P]Monte Odissea[CR]!", spanish="¡Partamos ya hacia el\n[CS:P]Monte Tribulaciones[CR]!"})
  else
  SkySceneKit.say({english="We should get moving to\n[CS:P]Mt. Travail[CR]!", french="C'est parti, rendons-nous\nau [CS:P]Mt Labeur[CR]!", german="Wir sollten uns zum\n[CS:P]Mühsalberg[CR] aufmachen!", italian="Dovremmo partire per il\n[CS:P]Monte Odissea[CR]!", spanish="¡Tenemos que partir hacia el\n[CS:P]Monte Tribulaciones[CR]!"})
  end
  -- message_Close
  end
  end
  elseif true then -- default
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [hero].[K] How about if\nwe just go as a pair, you and I?", french="Hé, [hero]![K] Et si on\nn'y allait que tous les deux, toi et moi?", german="Hey, [hero].[K] Wie wäre\nes, wenn wir zu zweit gehen, du und ich?", italian="Ehi, [hero].[K] Cosa ne dici\ndi andare solo in due, io e te?", spanish="Oye, [hero]...[K] ¿por qué\nno vamos solos tú y yo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Listen, [hero].[K] What\nwould you say if I suggested that just you and\nI go?", french="Hé, [hero]![K] Et si on\nn'y allait que tous les deux, toi et moi?", german="Hör zu, [hero].[K] Was\nwürdest du sagen, wenn ich vorschlagen\nwürde, dass nur du und ich gehen?", italian="Ascolta, [hero].[K] Cosa ne\ndiresti di andare solo noi due?", spanish="Escucha, [hero]...[K] ¿qué\nte parece si vamos solos tú y yo?"})
  else
  SkySceneKit.say({english="Say, [hero].[K] Do you think\nmaybe we should just go as a pair, us two?", french="Hé, [hero]![K] Et si on\nn'y allait qu'à deux, juste toi et moi?", german="Sag mal, [hero]...[K]\nDenkst du, wir sollten vielleicht zu zweit\ngehen? Nur wir beide?", italian="Ehi, [hero].[K] Non pensi\nche dovremmo andare solo noi due?", spanish="Escucha, [hero]...[K]\n¿no crees que tal vez deberíamos ir en pareja,\ntú y yo solamente?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If a whole bunch of us went,\nit'd probably upset [CS:N]Drowzee[CR] beyond the point\nof persuasion...", french="Si on y va tous, on risque\nde vexer [CS:N]Soporifik[CR]. Après on ne pourra plus\nlui faire entendre raison.", german="Wenn zu viele gehen, regt sich\n[CS:N]Traumato[CR] wahrscheinlich dermaßen auf,\ndass er sich gar nicht mehr überzeugen lässt...", italian="Se andassimo in tanti,\nprobabilmente [CS:N]Drowzee[CR] si innervosirebbe\ne non riusciremmo a convincerlo...", spanish="No creo que a [CS:N]Drowzee[CR] le haga\ngracia que vaya todo el grupo. Y claro,\nluego a ver quién le convence."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If a whole group went, [CS:N]Drowzee[CR]\nwould probably get upset. You can forget about\npersuading him then.", french="Si on y va tous, on risque\nde vexer [CS:N]Soporifik[CR]. Après on ne pourra plus\nlui faire entendre raison.", german="Wenn eine ganze Gruppe geht,\nregt sich [CS:N]Traumato[CR] wahrscheinlich auf.\nDann ist er nicht mehr zu überzeugen.", italian="Se andassimo in gruppo, [CS:N]Drowzee[CR]\nprobabilmente si innervosirebbe. E non sarebbe\npiù possibile convincerlo.", spanish="No creo que a [CS:N]Drowzee[CR] le\nparezca bien que vaya todo el grupo.\nNo creo que podamos convencerle así..."})
  else
  SkySceneKit.say({english="If a whole lot of us go, [CS:N]Drowzee[CR]\nwill probably get upset with us. He would be\nimpossible to persuade like that.", french="Si tout le monde y va, on risque\nde vexer [CS:N]Soporifik[CR]. Après on ne pourra plus\nlui faire entendre raison.", german="Wenn eine ganze Gruppe geht,\nregt sich [CS:N]Traumato[CR] wahrscheinlich auf.\nDann wäre es unmöglich, ihn zu überzeugen.", italian="Se andassimo in gruppo, [CS:N]Drowzee[CR]\nprobabilmente si innervosirebbe. E non sarebbe\npiù possibile convincerlo.", spanish="Si va todo el grupo, a [CS:N]Drowzee[CR]\nno le va a parecer bien. Si queremos\nconvencerle, será mejor que no lo hagamos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But going alone won't do it,\neither. One Pokémon won't be convincing\nenough.", french="Mais un Pokémon tout seul ne\nsera pas assez convaincant. Donc y aller\nseul n'est pas une bonne idée non plus.", german="Aber allein gehen bringt auch\nnichts. Ein einziges Pokémon ist nicht\nüberzeugend genug.", italian="Ma se andassi solo tu non\nandrebbe bene. Un solo Pokémon non\nsarebbe abbastanza convincente.", spanish="Pero un solo Pokémon\ntampoco va a conseguir nada. No\nresultaría muy convincente."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But going alone won't be enough.\nI don't think it would be persuasive enough to\nget the point across.", french="Mais un Pokémon tout seul ne\nsera pas assez convaincant. Donc y aller\nseul n'est pas une bonne idée non plus.", german="Aber ein Pokémon ist zu wenig.\nIch glaube nicht, dass es überzeugend genug\nwäre.", italian="Ma se andassi solo tu non\nandrebbe bene. Un solo Pokémon non\nsarebbe abbastanza convincente.", spanish="Pero ir uno solo tampoco\nbastaría. Sería difícil convencerle."})
  else
  SkySceneKit.say({english="But I think one Pokémon alone\nwon't be persuasive enough.", french="Mais un Pokémon tout seul ne\nsera pas assez convaincant. Donc y aller\nseul n'est pas une bonne idée non plus.", german="Aber ich glaube, ein Pokémon\nallein wäre nicht überzeugend genug.", italian="Ma un solo Pokémon non sarebbe\nabbastanza convincente.", spanish="Pero un solo Pokémon\nno sería lo bastante convincente."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So how about just we two go?", french="C'est pour ça que je proposais\nqu'on y aille juste à deux. Qu'en dis-tu?", german="Warum gehen wir also nicht\nzu zweit?", italian="Quindi cosa ne dici di andare\nin due?", spanish="Así que, ¿por qué no vamos\ntú y yo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why I suggested the two\nof us go.", french="C'est pour ça que je proposais\nqu'on y aille juste à deux. Qu'en dis-tu?", german="Darum habe ich vorgeschlagen,\ndass wir beide gehen.", italian="È per questo che forse sarebbe\nmeglio andare in due.", spanish="Por eso sugiero que vayamos\nlos dos."})
  else
  SkySceneKit.say({english="So what do you think? Should\njust the two of us go?", french="C'est pour ça que je proposais\nqu'on y aille juste à deux. Qu'en dis-tu?", german="Also, was denkst du? Sollten\nnicht wir beide gehen?", italian="Quindi cosa ne dici? Andiamo\nsolo noi due?", spanish="Entonces, ¿no te parece\nque deberíamos ir tú y yo?"})
  end
  do local __choice = SkySceneKit.ask({{english="Go as a pair", french="Y aller juste à deux", german="Zu zweit gehen", italian="Accetta", spanish="Ir en pareja"}, {english="Don't go", french="Ne pas y aller", german="Nicht gehen", italian="Non andare", spanish="No ir"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="OK![K] Let's get going to\n[CS:P]Mt. Travail[CR]!", french="C'est d'accord![K] En route pour\nle [CS:P]Mt Labeur[CR]!", german=" Okay![K] Auf zum [CS:P]Mühsalberg[CR]!", italian=" Ok![K] Andiamo al [CS:P]Monte Odissea[CR]!", spanish="¡Decidido![K] ¡Vamos al\n[CS:P]Monte Tribulaciones[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's settled![K] Let's get going to\n[CS:P]Mt. Travail[CR]!", french="C'est d'accord![K] En route pour\nle [CS:P]Mt Labeur[CR]!", german="Abgemacht![K] Dann auf zum\n[CS:P]Mühsalberg[CR]!", italian="È deciso![K] Andiamo al [CS:P]Monte[CR]\n[CS:P]Odissea[CR]!", spanish="¡De acuerdo![K] ¡Vámonos al\n[CS:P]Monte Tribulaciones[CR]!"})
  else
  SkySceneKit.say({english=" OK![K] Let's go to [CS:P]Mt. Travail[CR]!", french="C'est d'accord![K] En route pour\nle [CS:P]Mt Labeur[CR]!", german=" Okay![K] Auf zum [CS:P]Mühsalberg[CR]!", italian=" Ok![K] Andiamo al [CS:P]Monte Odissea[CR]!", spanish="¡De acuerdo![K] ¡Vamos al\n[CS:P]Monte Tribulaciones[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish="¡Hay que esforzarse\nal máximo, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish="¡Vamos a esforzarnos,\n[hero]!"})
  else
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish="Hagamos lo que podamos,\n[hero]."})
  end
  -- message_Close
  end
  end
  end
  end
end
