-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P11A/m05a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D04P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_RAIN2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(252, 224, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 268, 236, false, 2)
  GROUND:MoveToPosition(partner, 236, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So this is the waterfall that's\nsupposed to have a secret...", french="Voici donc la cascade censée\nreceler un secret...", german="Das ist also der Wasserfall, der\nein Geheimnis bergen soll.", italian="Quindi questa è la cascata\nche dovrebbe celare un segreto...", spanish="Así que dicen que esta cascada\noculta un secreto..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So this is the waterfall that\nsupposedly has a secret...", french="Voici donc la cascade censée\nreceler un secret...", german="Das ist also der Wasserfall, der\nein Geheimnis bergen soll.", italian="Quindi questa è la cascata\nche dovrebbe celare un segreto...", spanish="Así que dicen que esta cascada\noculta un secreto..."})
  else
  SkySceneKit.say({english="So this is the waterfall that's\nsupposed to have a secret...", french="Voici donc la cascade censée\nreceler un secret...", german="Das ist also der Wasserfall, der\nein Geheimnis bergen soll.", italian="Quindi questa è la cascata\nche dovrebbe celare un segreto...", spanish="Así que dicen que esta cascada\noculta un secreto..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 236, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  GROUND:MoveToPosition(partner, 236, 236, false, 2) -- SlidePositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GROUND:EntTurn(hero, Direction.Left)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa!", french=" Waouh!", german=" Boah!", italian=" Wow!", spanish=" ¡Vaya!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yow!", french=" Waouh!", german=" Wow!", italian=" Wow!", spanish=" ¡Fíjate!"})
  else
  SkySceneKit.say({english=" Waah!", french=" Waouh!", german=" Waah!", italian=" Wow!", spanish=" ¡Ay!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Right)
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That water's pounding down!", french="L'eau tombe avec une violence\ninouïe!", german="Das Wasser rast nur so\nherunter!", italian="L'acqua scorre\ndavvero impetuosa!", spanish="¡El agua cae con muchísima\nfuerza!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That water's coming down hard!", french="L'eau tombe avec une violence\ninouïe!", german="Das Wasser kommt mit einer\nganz schönen Wucht herunter!", italian="L'acqua scorre\ndavvero impetuosa!", spanish="¡El agua cae con muchísima\nfuerza!"})
  else
  SkySceneKit.say({english=" The water's pounding down!", french="L'eau tombe avec une violence\ninouïe!", german="Das Wasser rast nur so\nherunter!", italian="L'acqua scorre\ndavvero impetuosa!", spanish="¡El agua cae con muchísima\nfuerza!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Try getting close to the\nwaterfall, [hero].", french="Essaie de te rapprocher de la\ncascade, [hero].", german="Versuch du mal, näher\nheranzugehen, [hero].", italian="Avviciniamoci alla cascata il\npiù possibile, [hero].", spanish="Intenta acercarte a la cascada,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Try getting close to the\nwaterfall, [hero].", french="Essaie de te rapprocher de la\ncascade, [hero].", german="Versuch du mal, näher\nheranzugehen, [hero].", italian="Proviamo ad avvicinarci alla\ncascata, [hero].", spanish="Intenta acercarte a la cascada,\n[hero]."})
  else
  SkySceneKit.say({english="Try getting close to the\nwaterfall, [hero].", french="Essaie de te rapprocher de la\ncascade, [hero].", german="Versuch du mal, näher\nheranzugehen, [hero].", italian="Proviamo ad avvicinarci alla\ncascata, [hero].", spanish="Intenta acercarte a la cascada,\n[hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 268, 212, false, 2)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's true...[K] This is incredible...)", french="(C'est vrai...[K] Incroyable...)", german="(Stimmt...[K] Es ist unglaublich.)", italian="(È vero...[K] È incredibile...)", spanish="(Es cierto...[K] Es increíble.)"})
  else
  SkySceneKit.say({english="(It's true...[K] This is incredible...)", french="(C'est vrai...[K] Incroyable...)", german="(Stimmt...[K] Es ist unglaublich.)", italian="(È vero...[K] È incredibile...)", spanish="(Es cierto...[K] Es increíble.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I can barely stay standing near this deluge!)", french="(J'ai du mal à rester à côté de la cascade!)", german="(Ich kann neben diesen Wassermassen kaum\nstehen!)", italian="(Quant'acqua scende qui!)", spanish="(¡Apenas puedo tenerme en pie cerca de este\naluvión!)"})
  else
  SkySceneKit.say({english="(I can barely stay standing near this deluge!)", french="(J'ai du mal à rester à côté de la cascade!)", german="(Ich kann neben diesen Wassermassen kaum\nstehen!)", italian="(Quant'acqua scende qui!)", spanish="(¡Apenas puedo tenerme en pie cerca de este\naluvión!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  GROUND:MoveToPosition(hero, 268, 236, false, 2) -- SlidePositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GROUND:EntTurn(partner, Direction.Right)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Waaah!)", french="(Aaah!)", german="(Waaah!)", italian="(Waaah!)", spanish="(¡Ayyy!)"})
  else
  SkySceneKit.say({english="(Waaah!)", french="(Aaah!)", german="(Waaah!)", italian="(Waaah!)", spanish="(¡Ayyy!)"})
  end
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yeah, see? It's crazy.", french=" Tu as vu? Quelle intensité!", german=" Siehst du? Es ist Wahnsinn.", italian=" Hai visto che roba?", spanish=" ¿Lo ves? Es una locura."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" See? It's intense.", french=" Tu as vu? Quelle intensité!", german=" Siehst du? Es ist richtig heftig.", italian=" Vedi? È incredibile!", spanish=" ¿Lo ves? Es tremendo."})
  else
  SkySceneKit.say({english=" See? It's awesome.", french=" Tu as vu? Quelle intensité!", german=" Siehst du? Es ist atemberaubend.", italian=" Vedi? È incredibile!", spanish=" ¿Lo ves? Es asombroso."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If you fell under this waterfall,\nI bet you'd get all bruised up.", french="Si on tombe dans cette cascade,\non risque de se faire très mal.", german="Wenn man unter diesen\nWasserfall geraten würde, würde man\nbestimmt einige blaue Flecken abbekommen!", italian="Se qualcuno cadesse sotto questa\ncascata, scommetto che si farebbe molto male.", spanish="Seguro que si nos cayéramos\ndentro, nos haríamos mucho daño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If you were to fall under this\nwaterfall, you'd probably be battered.", french="Si on tombe dans cette cascade,\non risque de se faire très mal.", german="Wenn man unter diesen\nWasserfall geraten würde, bekäme man\nsicher einiges ab.", italian="Se qualcuno cadesse sotto questa\ncascata, scommetto che si farebbe molto male.", spanish="Seguro que nos haríamos\nmuchísimo daño si nos cayéramos dentro."})
  else
  SkySceneKit.say({english="If you fell under this waterfall,\nI think you'd get pretty battered up.", french="Si on tombe dans cette cascade,\non risque de se faire très mal.", german="Wenn man unter diesen\nWasserfall geraten würde, bekäme man\nsicher einiges ab.", italian="Se qualcuno cadesse sotto questa\ncascata, scommetto che si farebbe molto male.", spanish="Seguro que nos haríamos\nmuchísimo daño si nos cayéramos dentro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I didn't think it would be pouring\ndown this hard!", french="Je ne pensais pas que le courant\nserait si fort!", german="Ich hätte nicht gedacht, dass das\nWasser so hart herunterstürzt!", italian="Mai vista dell'acqua scendere\ncosì violentemente!", spanish="¡No pensaba que el agua\npudiera tener tanta fuerza!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I didn't think it would be pouring\ndown this powerfully!", french="Je ne pensais pas que le courant\nserait si fort!", german="Ich hätte nicht gedacht, dass das\nWasser mit so einer Wucht herunterstürzt!", italian="Mai vista dell'acqua scendere\ncosì violentemente!", spanish="¡No pensaba que el agua\npudiera bajar con tanta fuerza!"})
  else
  SkySceneKit.say({english="I didn't think it would be pouring\ndown this hard!", french="Je ne pensais pas que le courant\nserait si fort!", german="Ich hätte nicht gedacht, dass das\nWasser mit so einer Wucht herunterstürzt!", italian="Mai vista dell'acqua scendere\ncosì violentemente!", spanish="¡No pensaba que el agua\nfuera a precipitarse con tanta fuerza!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Where are we even supposed to\nbegin looking?", french="Je ne sais même pas où on doit\ncommencer à chercher!", german="Wo sollen wir überhaupt\nanfangen zu suchen?", italian=" Da dove iniziamo a cercare?", spanish="No sé ni por dónde podemos\nempezar a buscar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Where should we even start\nlooking?", french="Je ne sais même pas où on doit\ncommencer à chercher!", german="Wo sollen wir überhaupt\nanfangen zu suchen?", italian=" Da dove iniziamo a cercare?", spanish="No sé ni por dónde podemos\nempezar a buscar."})
  else
  SkySceneKit.say({english="Where should we even start\nlooking?", french="Je ne sais même pas où on doit\ncommencer à chercher!", german="Wo sollen wir überhaupt\nanfangen zu suchen?", italian=" Da dove iniziamo a cercare?", spanish="No sé ni por dónde podemos\nempezar a buscar."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Hmm...)", french="(Hum...)", german="(Hmm...)", italian="(Mmm...)", spanish="(Hum...)"})
  else
  SkySceneKit.say({english="(Hmm...)", french="(Hum...)", german="(Hmm...)", italian="(Mmm...)", spanish="(Hum...)"})
  end
  -- message_Close
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Something seems familiar.)", french="(J'ai une impression de déjà-vu.)", german="(Irgendetwas kommt mir bekannt vor.)", italian="(Qualcosa mi sembra familiare.)", spanish="(Algo me resulta familiar.)"})
  else
  SkySceneKit.say({english="(Something seems familiar.)", french="(J'ai une impression de déjà-vu.)", german="(Irgendetwas kommt mir bekannt vor.)", italian="(Qualcosa mi sembra familiare.)", spanish="(Algo me resulta familiar.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's that dizziness I felt before.)", french="(C'est cette même sensation de vertige que\nj'ai ressentie l'autre fois.)", german="(Es ist wieder dieses Schwindelgefühl.)", italian="(Un altro capogiro, come quello di prima.)", spanish="(Es ese mareo que sentí antes.)"})
  else
  SkySceneKit.say({english="(It's that dizziness I felt before.)", french="(C'est cette même sensation de vertige que\nj'ai ressentie l'autre fois.)", german="(Es ist wieder dieses Schwindelgefühl.)", italian="(Un altro capogiro, come quello di prima.)", spanish="(Es ese mareo que sentí antes.)"})
  end
  -- message_Close
  GAME:FadeOut(false, 5)
end
