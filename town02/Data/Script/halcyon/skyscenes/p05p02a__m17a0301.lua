-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P05P02A/m17a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeOut(false, 30)
  -- back_SetGround(LEVEL_P05P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  else
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" How did we end up this way?", french="Comment a-t-on pu en arriver\nlà?", german=" Wie sind wir hier gelandet?", italian=" Ma come siamo finiti qua?", spanish=" ¿Cómo hemos acabado aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" How did we end up this way?", french="Comment a-t-on pu en arriver\nlà?", german=" Wie sind wir hier gelandet?", italian=" Ma come siamo finiti qua?", spanish=" ¿Cómo hemos acabado aquí?"})
  else
  SkySceneKit.say({english=" How did we end up this way?", french="Comment a-t-on pu en arriver\nlà?", german=" Wie sind wir hier gelandet?", italian="Ma come abbiamo fatto a finire\nqui?", spanish=" ¿Cómo hemos acabado aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think what happened was...[K]\n[CS:N]Dusknoir[CR] grabbed us...", french="Si mes souvenirs sont bons...[K]\n[CS:N]Noctunoir[CR] s'est saisi de nous...", german="Ich glaube, es war so...[K]\n[CS:N]Zwirrfinst[CR] hat uns gepackt...", italian="Mi sembra di ricordare...[K]\n[CS:N]Dusknoir[CR] ci ha afferrato...", spanish="Creo recordar que...[K] [CS:N]Dusknoir[CR]\nnos agarró..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I think what happened was...[K]\n[CS:N]Dusknoir[CR] grabbed us...", french="Si mes souvenirs sont bons...[K]\n[CS:N]Noctunoir[CR] s'est saisi de nous...", german="Ich glaube, es war so...[K]\n[CS:N]Zwirrfinst[CR] hat uns gepackt...", italian="Mi sembra di ricordare...[K]\n[CS:N]Dusknoir[CR] ci ha afferrato...", spanish="Creo recordar que...[K] [CS:N]Dusknoir[CR]\nnos agarró..."})
  else
  SkySceneKit.say({english="I think what happened was...[K]\n[CS:N]Dusknoir[CR] grabbed us...", french="Si mes souvenirs sont bons...[K]\n[CS:N]Noctunoir[CR] s'est saisi de nous...", german="Ich glaube, es war so...[K]\n[CS:N]Zwirrfinst[CR] hat uns gepackt...", italian="Mi sembra di ricordare...[K]\n[CS:N]Dusknoir[CR] ci ha afferrato...", spanish="Creo recordar que...[K] [CS:N]Dusknoir[CR]\nnos agarró..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Then he dragged us into the\ndimensional hole...", french="... avant de nous entraîner avec\nlui dans le gouffre dimensionnel...", german="Dann hat er uns in das\ndimensionale Loch gezogen.", italian="Poi ci ha trascinato nel tunnel\ndimensionale...", spanish="Luego nos arrastró al agujero\ndimensional..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Then he dragged us into the\ndimensional hole...", french="... avant de nous entraîner avec\nlui dans le gouffre dimensionnel...", german="Dann hat er uns in das\ndimensionale Loch gezogen.", italian="Poi ci ha trascinato nel tunnel\ndimensionale...", spanish="Luego nos arrastró al agujero\ndimensional..."})
  else
  SkySceneKit.say({english="Then he dragged us into the\ndimensional hole...", french="... avant de nous entraîner avec\nlui dans le gouffre dimensionnel...", german="Dann hat er uns in das\ndimensionale Loch gezogen.", italian="Poi ci ha trascinato nel tunnel\ndimensionale...", spanish="Luego nos arrastró al agujero\ndimensional..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] Wait, so is this maybe...", french=" Quoi?![K] Mais alors, ce doit être...", german="Ähem?!?[K] Warte mal, ist das\nhier also vielleicht...", italian="Ehi! Un momento![K] Allora,\nforse...", spanish="¡¿Qué?![K] ¡Un momento!\nEntonces ahora estamos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] Wait, so is this maybe...", french=" Quoi?![K] Mais alors, ce doit être...", german="Was?!?[K] Warte mal, ist das hier\nalso vielleicht...", italian="Ehi! Un momento![K] Allora,\nforse...", spanish="¡¿Qué?![K] ¡Un momento!\nEntonces ahora estamos..."})
  else
  SkySceneKit.say({english=" What?![K] Wait, so is this maybe...", french=" Quoi?![K] Mais alors, ce doit être...", german="Was?!?[K] Warte mal, ist das hier\nalso vielleicht...", italian="Ehi! Un momento![K] Allora,\nforse...", spanish="¡¿Qué?![K] ¡Un momento!\nEntonces ahora estamos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is this...[K]the future?!", french=" Ce doit être...[K] le futur?!", german=" Ist das...[K] die Zukunft?!?", italian=" Questo è...[K] il futuro?!", spanish=" Estamos en...[K] ¡¿el futuro?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is this...[K]the future?!", french=" Ce doit être...[K] le futur?!", german=" Ist das...[K] die Zukunft?!?", italian=" Questo è...[K] il futuro?!", spanish=" Estamos en...[K] ¡¿el futuro?!"})
  else
  SkySceneKit.say({english=" Is this...[K]the future?!", french=" Ce doit être...[K] le futur?!", german=" Ist das...[K] die Zukunft?!?", italian=" Questo è...[K] il futuro?!", spanish=" Estamos en...[K] ¡¿el futuro?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But that's...![K] I don't\nbelieve this!", french="Alors ça...![K] Je n'arrive pas\nà y croire!", german="Aber das ist...[K] Ich glaube das\nnicht!", italian="Non è poss...![K] No! Non riesco\na crederci!", spanish="¡Pero eso es...![K]\n¡No me lo puedo creer!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But that's...![K] I can't\nbelieve this!", french="Alors ça...![K] Je n'arrive pas\nà y croire!", german="Aber das ist...[K] Ich kann das\nnicht glauben!", italian="Non è poss...![K] No! Non riesco\na crederci!", spanish="¡Pero eso es...![K]\n¡No me lo puedo creer!"})
  else
  SkySceneKit.say({english="But that's...![K] I can't\nbelieve this!", french="Alors ça...![K] Je n'arrive pas\nà y croire!", german="Aber das ist...[K] Ich kann das\nnicht glauben!", italian="Non è poss...![K] No! Non riesco\na crederci!", spanish="¡Pero eso es...![K]\n¡No me lo puedo creer!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I mean, this is the future?!", french=" C'est vraiment le futur?!", german="Ich meine, das hier soll die\nZukunft sein?!?", italian=" Questo è veramente il futuro?", spanish="¡¿En serio estamos en\nel futuro?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I mean, this is the future?!", french=" C'est vraiment le futur?!", german="Ich meine, das hier soll die\nZukunft sein?!?", italian=" Questo è veramente il futuro?", spanish="¡¿En serio estamos en\nel futuro?!"})
  else
  SkySceneKit.say({english=" I mean, this is the future?!", french=" C'est vraiment le futur?!", german="Ich meine, das hier soll die\nZukunft sein?!?", italian=" Questo è veramente il futuro?", spanish="¡¿En serio estamos en\nel futuro?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Why are we even here?", french="Mais qu'est-ce qu'on fait ici,\nd'abord?", german=" Warum sind wir überhaupt hier?", italian=" Ma che ci facciamo qui?", spanish=" ¿Qué hacemos aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Why are we even here?", french="Mais qu'est-ce qu'on fait ici,\nd'abord?", german=" Warum sind wir überhaupt hier?", italian=" Perché siamo qui?", spanish=" ¿Qué hacemos aquí?"})
  else
  SkySceneKit.say({english=" Why are we even here?", french="Mais qu'est-ce qu'on fait ici,\nd'abord?", german=" Warum sind wir überhaupt hier?", italian=" Perché siamo qui?", spanish=" ¿Qué hacemos aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...but...", french=" Argh... et cette...", german=" Ugh... aber...", italian=" Mmm... In effetti...", spanish=" Ay... Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...but...", french=" Argh... et cette...", german=" Ugh... aber...", italian=" Mmm... In effetti...", spanish=" Ay... Pero..."})
  else
  SkySceneKit.say({english=" Ugh...but...", french=" Argh... et cette...", german=" Ugh... aber...", italian=" Mmm... In effetti...", spanish=" Ay... Pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This whole room is built in a\nway unlike anything I've ever seen!", french="... cette salle... la construction\nne ressemble à rien de ce que j'ai pu voir\njusqu'à maintenant!", german="Ich habe noch nie einen Raum\ngesehen, der so wie dieser gebaut war!", italian="Non ho mai visto una stanza\ncome questa!", spanish="Esta sala está construida de\nuna forma que nunca había visto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This whole room is constructed\nin a way unlike anything I've ever seen!", french="... cette salle... la construction\nne ressemble à rien de ce que j'ai pu voir\njusqu'à maintenant!", german="Ich habe noch nie einen Raum\ngesehen, der so wie dieser gebaut war!", italian="Non ho mai visto una stanza\ncome questa!", spanish="Esta sala está construida de\nuna forma que nunca había visto."})
  else
  SkySceneKit.say({english="This whole room is built in a\nway unlike anything I've ever seen!", french="... cette salle... la construction\nne ressemble à rien de ce que j'ai pu voir\njusqu'à maintenant!", german="Ich habe noch nie einen Raum\ngesehen, der so wie dieser gebaut war!", italian="Non ho mai visto una stanza\ncome questa!", spanish="Esta sala está construida de\nuna forma que nunca había visto."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Now that I've had time to\nthink...[K] Maybe this actually is...", french="Réflexion faite...[K] peut-être\nqu'on est bel et bien dans...", german="Jetzt, wo ich darüber\nnachdenke...[K] Vielleicht ist das wirklich...", italian="Dev'essere davvero...[K] Sì, è\ncosì...", spanish="Viendo este lugar y ahora que\nme paro a pensarlo...[K] Puede que esto sí sea..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Now that I've had time to\ndigest this...[K] Maybe this actually is...", french="Réflexion faite...[K] peut-être\nqu'on est bel et bien dans...", german="Jetzt, wo ich darüber\nnachdenke...[K] Vielleicht ist das wirklich...", italian="Dev'essere davvero...[K] Sì, è\ncosì...", spanish="Viendo este lugar y ahora que\nme paro a pensarlo...[K] Puede que esto sí sea..."})
  else
  SkySceneKit.say({english="Now that I've had time to\nthink...[K] Maybe this actually is...", french="Réflexion faite...[K] peut-être\nqu'on est bel et bien dans...", german="Jetzt, wo ich darüber\nnachdenke...[K] Vielleicht ist das wirklich...", italian="Dev'essere davvero...[K] Sì, è\ncosì...", spanish="Viendo este lugar y ahora que\nme paro a pensarlo...[K] Puede que esto sí sea..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The future!", french=" ... le futur!", german=" Die Zukunft!", italian=" Siamo nel futuro!", spanish=" El futuro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The future!", french=" ... le futur!", german=" Die Zukunft!", italian=" Siamo nel futuro!", spanish=" El futuro..."})
  else
  SkySceneKit.say({english=" The future!", french=" ... le futur!", german=" Die Zukunft!", italian=" Siamo nel futuro!", spanish=" El futuro..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah! [hero]!", french=" Ouaaah! [hero]!", german=" Waah! [hero]!", italian=" Aaah! [hero]!", spanish=" ¡Aaah! ¡[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! [hero]!", french=" Ouaaah! [hero]!", german=" Waah! [hero]!", italian=" Aaah! [hero]!", spanish=" ¡Aaah! ¡[hero]!"})
  else
  SkySceneKit.say({english=" Waah! [hero]!", french=" Ouaaah! [hero]!", german=" Waah! [hero]!", italian=" Aaah! [hero]!", spanish=" ¡Aaah! ¡[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Did we really end up in the\nfuture?!", french="On se retrouve vraiment\ndans le futur?!", german="Sind wir wirklich in der Zukunft\ngelandet?!?", italian=" Siamo finiti nel futuro!", spanish="¡¿De verdad hemos acabado\nen el futuro?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Did we really end up in the\nfuture?!", french="On se retrouve vraiment\ndans le futur?!", german="Sind wir wirklich in der Zukunft\ngelandet?!?", italian=" Siamo finiti nel futuro!", spanish="¡¿De verdad hemos acabado\nen el futuro?!"})
  else
  SkySceneKit.say({english=" Are we really in the future?!", french="On se retrouve vraiment\ndans le futur?!", german="Sind wir wirklich in der\nZukunft?!?", italian=" Che ci facciamo qui nel futuro?", spanish="¡¿De verdad hemos acabado\nen el futuro?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ugh, now what are we supposed\nto do?", french="Argh! Et maintenant, qu'est-ce\nqu'on fait?", german=" Ugh, was sollen wir jetzt tun?", italian=" Sob... E adesso?", spanish=" ¿Y ahora qué vamos a hacer?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh, now what should we do?", french="Argh! Et maintenant, qu'est-ce\nqu'on fait?", german=" Ugh, was sollen wir jetzt tun?", italian=" Sob... E adesso che facciamo?", spanish=" ¿Y ahora qué vamos a hacer?"})
  else
  SkySceneKit.say({english="Ugh, now what are we supposed\nto do?", french="Argh! Et maintenant, qu'est-ce\nqu'on fait?", german=" Ugh, was sollen wir jetzt tun?", italian=" Sob... E adesso?", spanish=" ¿Y ahora qué vamos a hacer?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So, if...", french=" Alors, si...", german=" Also, wenn...", italian=" Se questo...", spanish=" Si realmente..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So, if...", french=" Alors, si...", german=" Also, wenn...", italian=" Se questo...", spanish=" Si realmente..."})
  else
  SkySceneKit.say({english=" So, if...", french=" Alors, si...", german=" Also, wenn...", italian=" Se questo...", spanish=" Si realmente..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If this place is the future...", french="... si c'est vraiment le futur,\nici...", german=" Wenn das hier die Zukunft ist...", italian="Se questo è veramente il\nfuturo...", spanish=" Si este lugar es el futuro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If this place is the future...", french="... si c'est vraiment le futur,\nici...", german=" Wenn das hier die Zukunft ist...", italian="Se questo è veramente il\nfuturo...", spanish=" Si este lugar es el futuro..."})
  else
  SkySceneKit.say({english=" If this place is the future...", french="... si c'est vraiment le futur,\nici...", german=" Wenn das hier die Zukunft ist...", italian="Se questo è veramente il\nfuturo...", spanish=" Si este lugar es el futuro..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="How are we supposed to get\nback to our world?", french="... comment on fait pour rentrer\nchez nous?", german="Wie sollen wir dann wieder in\nunsere Welt kommen?", italian="... come faremo a tornare nel\npresente?", spanish="¿Cómo vamos a volver a\nnuestro mundo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="How are we supposed to get\nback to our world?", french="... comment on fait pour rentrer\nchez nous?", german="Wie sollen wir dann wieder in\nunsere Welt kommen?", italian="... come faremo a tornare nel\npresente?", spanish="¿Cómo vamos a volver a\nnuestro mundo?"})
  else
  SkySceneKit.say({english="How are we supposed to get\nback to our world?", french="... comment on fait pour rentrer\nchez nous?", german="Wie sollen wir dann wieder in\nunsere Welt kommen?", italian="... come faremo a tornare nel\npresente?", spanish="¿Cómo vamos a volver a\nnuestro mundo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(7187) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(20)
  -- back_ChangeGround(LEVEL_P05P02A2) [décor déjà chargé par EnterZone PMDO]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(50)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 256, 152, Direction.Down, "NPC_YAMIRAMI")
  GROUND:MoveToPosition(npc_npc_yamirami, 252, 200, false, 2)
  GAME:WaitFrames(10)
  pcall(function() GAME:MoveCamera(252, 220, 60, false) end) -- performer/caméra
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 236, 228, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 268, 228, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(5)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 256, 152, Direction.Down, "NPC_YAMIRAMI2")
  GROUND:MoveToPosition(npc_npc_yamirami2, 252, 184, false, 2)
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 256, 152, Direction.Down, "NPC_YAMIRAMI3")
  GROUND:MoveToPosition(npc_npc_yamirami3, 228, 184, false, 2)
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  -- supervision_Acting(4) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 256, 152, Direction.Down, "NPC_YAMIRAMI4")
  GROUND:MoveToPosition(npc_npc_yamirami4, 276, 184, false, 2)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: se_Play(7188) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" They're awake.[K] How convenient.", french=" Vous êtes debout.[K] Parfait.", german="Sie sind wach.[K] Das kommt\ngerade recht.", italian=" Sono già in piedi.[K] Molto bene.", spanish=" Se han despertado.[K] Qué oportuno."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yamirami, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" All right.[K] We'll do this quick.", french=" Finissons-en.[K] On va faire vite.", german="In Ordnung.[K] Lasst es uns schnell\nerledigen.", italian="Allora...[K] Cercheremo di fare\ntutto alla svelta, va bene?", spanish=" Estupendo.[K] No tardaremos mucho."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Do this quick? Do what?!", french=" Faire vite? Mais faire quoi?!", german=" Schnell erledigen? Was denn?!?", italian=" Fare... cosa?!", spanish=" ¿No tardaréis? ¡¿En hacer qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Do this quick? Do what?!", french=" Faire vite? Mais faire quoi?!", german=" Schnell erledigen? Was denn?!?", italian=" Fare... cosa?!", spanish=" ¿No tardaréis? ¡¿En hacer qué?!"})
  else
  SkySceneKit.say({english=" Do this quick? Do what?!", french=" Faire vite? Mais faire quoi?!", german=" Schnell erledigen? Was denn?!?", italian=" Fare... cosa?!", spanish=" ¿No tardaréis? ¡¿En hacer qué?!"})
  end
  -- message_Close
  GROUND:MoveToPosition(npc_npc_yamirami, 252, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami2, 252, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami3, 220, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami4, 284, 220, false, 2)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_yamirami, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.DownLeft)
  -- GAP: se_Play(7189) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wh-what?!)", french="(Que... quoi?!)", german="(W-was?!?)", italian="(C-Che succede?!)", spanish="(¡¿Qué?!)"})
  else
  SkySceneKit.say({english="(Wh-what?!)", french="(Que... quoi?!)", german="(W-was?!?)", italian="(C-Che succede?!)", spanish="(¡¿Qué?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Waah! They have me\nblindfolded![K] I can't see!", french="Ouaaah! Ils m'ont bandé\nles yeux![K] Je n'y vois plus rien!", german="Waah! Sie haben mir die Augen\nverbunden![K] Ich sehe nichts!", italian="Aaah! Mi hanno bendato![K] Non ci\nvedo più!", spanish="¡Aaah![K] ¡Me han vendado los\nojos! ¡No veo nada!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Waah! They blindfolded me![K]\nI can't see a thing!", french="Ouaaah! Ils m'ont bandé\nles yeux![K] Je n'y vois plus rien!", german="Waah! Sie haben mir die Augen\nverbunden![K] Ich kann nichts sehen!", italian="Aaah! Mi hanno bendato![K] Non ci\nvedo più!", spanish="¡Aaah![K] ¡Me han vendado los\nojos! ¡No veo nada!"})
  else
  SkySceneKit.say({english="Waah! They blindfolded me![K]\nI can't see a thing!", french="Ouaaah! Ils m'ont bandé\nles yeux![K] Je n'y vois plus rien!", german="Waah! Sie haben mir die Augen\nverbunden![K] Ich kann nichts sehen!", italian="Aaah! Mi hanno bendata![K] Non ci\nvedo più!", spanish="¡Aaah![K] ¡Me han vendado los\nojos! ¡No veo nada!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Come with us.", french=" Suivez-nous.", german=" Mitkommen.", italian=" Di qua.", spanish=" Venid con nosotros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ow! Quit shoving!", french=" Aïe! Arrêtez de me pousser!", german=" Aua! Nicht schubsen!", italian=" Ehi! Basta spingere!", spanish=" ¡Ay! ¡No empujéis!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ow! Don't shove me!", french=" Aïe! Arrêtez de me pousser!", german=" Aua! Schubst mich nicht so!", italian=" Ohi! Non spingete!", spanish=" ¡Ay! ¡No empujéis!"})
  else
  SkySceneKit.say({english=" Ow! Don't push!", french=" Aïe! Arrêtez de me pousser!", german=" Aua! Schubst nicht so!", italian=" Ohi! Non spingete!", spanish=" ¡Ay! ¡No empujéis!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(7187) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ugh...[K] This blindfold makes it\nimpossible to tell where I'm going...", french="Argh...[K] Ce bandeau m'empêche\nde voir où je vais...", german="Ugh...[K] Mit verbundenen Augen\nweiß ich nicht, wohin wir gehen...", italian="Argh...[K] Con questa benda non\nriesco a capire dove stiamo andando...", spanish="Ay...[K] Con esta venda es imposible\nsaber adónde nos llevan..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ugh...[K] This blindfold makes it\nimpossible to tell where I'm going...", french="Argh...[K] Ce bandeau m'empêche\nde voir où je vais...", german="Ugh...[K] Mit verbundenen Augen\nweiß ich nicht, wohin wir gehen...", italian="Argh...[K] Con questa benda non\nriesco a capire dove stiamo andando...", spanish="Ay...[K] Con esta venda es imposible\nsaber adónde nos llevan..."})
  else
  SkySceneKit.say({english="Ugh...[K] This blindfold makes it\nimpossible to tell where I'm going...", french="Argh...[K] Ce bandeau m'empêche\nde voir où je vais...", german="Ugh...[K] Mit verbundenen Augen\nweiß ich nicht, wohin wir gehen...", italian="Argh...[K] Con questa benda non\nriesco a capire dove stiamo andando...", spanish="Ay...[K] Con esta venda es imposible\nsaber adónde nos llevan..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Where are they taking us?", french="Mais où est-ce qu'ils nous\nemmènent?", german=" Wo bringen sie uns hin?", italian=" Dove ci stanno portando?", spanish=" ¿Adónde vamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But where are they taking us?", french="Mais où est-ce qu'ils nous\nemmènent?", german=" Wo bringen sie uns bloß hin?", italian=" Dove ci stanno portando?", spanish=" ¿Adónde vamos?"})
  else
  SkySceneKit.say({english=" But where are they taking us?", french="Mais où est-ce qu'ils nous\nemmènent?", german=" Wo bringen sie uns bloß hin?", italian=" Dove ci stanno portando?", spanish=" ¿Adónde vamos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  -- GAP: se_Play(7187) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" We're here.", french=" Nous y voilà.", german=" Wir sind da.", italian=" Siamo arrivati.", spanish=" Aquí estamos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  -- GAP: se_Play(7189) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(2) -- join WaitSe
  SkySceneKit.cleanup_npcs()
end
