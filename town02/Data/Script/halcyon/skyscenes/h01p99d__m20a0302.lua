-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99D/m20a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_H01P99D) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 280, 160, Direction.Right, "NPC_JUPUTORU")
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(16), false, 2) end
  GROUND:MoveToPosition(npc_npc_juputoru, 232, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 224, 164, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What's the matter? Can't sleep?", french="Qu'est-ce qui se passe?\nTu n'arrives pas à dormir?", german="Was ist los? Kannst du nicht\nschlafen?", italian=" Cos'hai? Non riesci a dormire?", spanish=" ¿Qué pasa? ¿No puedes dormir?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yeah. Just thinking.", french="Non, j'avais besoin de\nréfléchir.", german=" Ja. Ich grüble.", italian=" Già. Stavo pensando.", spanish=" Solo había salido a reflexionar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes. Just thinking.", french="Non, j'avais besoin de\nréfléchir.", german=" Ja. Ich grüble.", italian=" Sì. Stavo pensando.", spanish=" Solo había salido a reflexionar."})
  else
  SkySceneKit.say({english=" Yep. Just thinking.", french="Non, j'avais besoin de\nréfléchir.", german=" Jep. Ich grüble.", italian=" Già. Stavo pensando.", spanish=" Solo había salido a reflexionar."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Thinking about [CS:N]Dusknoir[CR]?", french=" A propos de [CS:N]Noctunoir[CR]?", german=" Denkst du an [CS:N]Zwirrfinst[CR]?", italian=" Pensavi a [CS:N]Dusknoir[CR]?", spanish=" ¿Estás pensando en [CS:N]Dusknoir[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No, not that.", french=" Non, ce n'est pas ça.", german=" Nein, das nicht.", italian=" No, non a quello.", spanish=" No, no se trata de eso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No, that's not it.", french=" Non, ce n'est pas ça.", german=" Nein, das ist es nicht.", italian=" No, non a lui.", spanish=" No, no se trata de eso."})
  else
  SkySceneKit.say({english=" No, that's not it.", french=" Non, ce n'est pas ça.", german=" Nein, das ist es nicht.", italian=" No, non a lui.", spanish=" No, no se trata de eso."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sure, finding out we were being\nduped really hurt.", french="C'est vrai, c'est dur de\nse rendre compte qu'il nous a tous dupés.", german="Sicher, es tut schon weh\nherauszufinden, dass man geleimt wurde.", italian="Certo, scoprire che siamo stati\ntraditi fa male.", spanish="Desde luego, descubrir que nos\nhabía engañado me dolió mucho."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sure, finding out we were being\ndeceived came as a real shock.", french="C'est vrai, c'est dur de\nse rendre compte qu'il nous a tous dupés.", german="Sicher, herauszufinden, an der\nNase herumgeführt worden zu sein, ist schon\nein Schock.", italian="Certo, scoprire che siamo stati\ningannati è un vero shock.", spanish="Desde luego, descubrir que nos\nhabía engañado me dolió mucho."})
  else
  SkySceneKit.say({english="Sure, finding out we were being\nfooled really hurt.", french="C'est vrai, c'est dur de\nse rendre compte qu'il nous a tous dupés.", german="Sicher, es tut schon weh\nherauszufinden, dass man zum Narren gehalten\nwurde.", italian="Certo, scoprire che siamo stati\npresi in giro fa male.", spanish="Desde luego, descubrir que nos\nhabía engañado me dolió mucho."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But hearing what you had to say\nearlier, [CS:N]Grovyle[CR]...", french="Mais quand j'ai entendu\nton histoire tout à l'heure, [CS:N]Massko[CR]...", german="Aber nachdem ich dir zuvor\nzugehört habe, [CS:N]Reptain[CR]...", italian="Ma sentendo quello che ci hai\ndetto prima, [CS:N]Grovyle[CR]...", spanish="Pero lo que me ha desvelado fue\nlo que nos contaste antes, [CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But hearing your story earlier,\n[CS:N]Grovyle[CR]...", french="Mais quand j'ai entendu\nton histoire tout à l'heure, [CS:N]Massko[CR]...", german="Aber nachdem ich deine\nGeschichte gehört habe, [CS:N]Reptain[CR]...", italian="Prima, sentendo la tua storia,\n[CS:N]Grovyle[CR]...", spanish="Pero lo que me ha desvelado fue\nlo que nos contaste antes, [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english="But hearing your story earlier,\n[CS:N]Grovyle[CR]...", french="Mais quand j'ai entendu\nton histoire tout à l'heure, [CS:N]Massko[CR]...", german="Aber nachdem ich deine\nGeschichte gehört habe, [CS:N]Reptain[CR]...", italian="Prima, sentendo la tua storia,\n[CS:N]Grovyle[CR]...", spanish="Pero lo que me ha desvelado fue\nlo que nos contaste antes, [CS:N]Grovyle[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It made me realize that what\n[CS:N]Dusknoir[CR] said in the future was really true.", french="... je me suis rendu compte que\n[CS:N]Noctunoir[CR] avait dit vrai.", german="Da habe ich erkannt, dass\n[CS:N]Zwirrfinst[CR] wirklich recht mit dem hatte, was\ner in der Zukunft sagte.", italian="Mi sono reso conto che quello\nche diceva [CS:N]Dusknoir[CR] nel futuro era la verità.", spanish="Me hizo darme cuenta de que lo\nque dijo [CS:N]Dusknoir[CR] en el futuro era realmente\ncierto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It really drove it home. What\n[CS:N]Dusknoir[CR] said in the future was really true.", french="... je me suis rendu compte que\n[CS:N]Noctunoir[CR] avait dit vrai.", german="Da wurde mir klar, dass\n[CS:N]Zwirrfinst[CR] mit dem, was er in der Zukunft\nsagte, wirklich recht hatte.", italian="Ho davvero capito. Quello che\ndiceva [CS:N]Dusknoir[CR] nel futuro era la verità.", spanish="Me hizo darme cuenta de que lo\nque dijo [CS:N]Dusknoir[CR] en el futuro era realmente\ncierto."})
  else
  SkySceneKit.say({english="It made me realize that what\n[CS:N]Dusknoir[CR] said in the future was really true.", french="... je me suis rendu compte que\n[CS:N]Noctunoir[CR] avait dit vrai.", german="Da habe ich erkannt, dass\n[CS:N]Zwirrfinst[CR] wirklich recht mit dem hatte, was\ner in der Zukunft sagte.", italian="Mi sono resa conto che quello\nche diceva [CS:N]Dusknoir[CR] nel futuro era la verità.", spanish="Me hizo darme cuenta de que lo\nque dijo [CS:N]Dusknoir[CR] en el futuro era realmente\ncierto."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And it made me understand that\n[hero] really did come from the future.", french="Et j'ai compris que [hero]\nvenait vraiment du futur.", german="Und es ließ mich verstehen,\ndass [hero] wirklich aus der Zukunft\nkommt.", italian="E mi ha fatto capire che\n[hero] veniva davvero dal futuro.", spanish="Comprendí que [hero]\nprocede del futuro en realidad."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And it made me realize that\n[hero] really did come from the future.", french="Et j'ai compris que [hero]\nvenait vraiment du futur.", german="Und es ließ mich verstehen,\ndass [hero] wirklich aus der Zukunft\nkommt.", italian="E mi ha fatto capire che\n[hero] veniva davvero dal futuro.", spanish="Comprendí que [hero]\nprocede del futuro en realidad."})
  else
  SkySceneKit.say({english="And it made me understand that\n[hero] really did come from the future.", french="Et j'ai compris que [hero]\nvenait vraiment du futur.", german="Und es ließ mich verstehen,\ndass [hero] wirklich aus der Zukunft\nkommt.", italian="E mi ha fatto capire che\n[hero] veniva davvero dal futuro.", spanish="Comprendí que [hero]\nprocede del futuro en realidad."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I was thinking about things\nlike that...", french=" C'est à ça que je réfléchissais...", german="Über solche Dinge habe ich\nnachgedacht...", italian=" Pensavo a queste cose...", spanish=" A eso le estaba dando vueltas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I was mulling over things\nlike that...", french=" C'est à ça que je réfléchissais...", german="Über solche Sachen habe ich\nnachgegrübelt...", italian=" Stavo riflettendo su tutto ciò...", spanish=" A eso le estaba dando vueltas..."})
  else
  SkySceneKit.say({english="I was going over things like that\nin my head...", french=" C'est à ça que je réfléchissais...", german="Solche Sachen sind mir durch\nden Kopf gegangen...", italian="Avevo queste cose che mi\nfrullavano in testa...", spanish=" A eso le estaba dando vueltas..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey![K] Look, [CS:N]Grovyle[CR]!", french=" Eh, [CS:N]Massko[CR]![K] Regarde!", german=" Hey![K] Sieh mal, [CS:N]Reptain[CR]!", italian=" Ehi![K] Guarda, [CS:N]Grovyle[CR]!", spanish=" ¡Mira![K] ¡Fíjate, [CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey![K] Look, [CS:N]Grovyle[CR]!", french=" Eh, [CS:N]Massko[CR]![K] Regarde!", german=" Hey![K] Sieh mal, [CS:N]Reptain[CR]!", italian=" Ehi![K] Guarda, [CS:N]Grovyle[CR]!", spanish=" ¡Oh![K] ¡Fíjate, [CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english=" Oh![K] Look, [CS:N]Grovyle[CR]!", french=" Eh, [CS:N]Massko[CR]![K] Regarde!", german=" Hey![K] Sieh mal, [CS:N]Reptain[CR]!", italian=" Ehi![K] Guarda, [CS:N]Grovyle[CR]!", spanish=" ¡Oh![K] ¡Fíjate, [CS:N]Grovyle[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Sunlight![K] It's sunrise!", french=" La lumière![K] Le soleil se lève!", german="Sonnenschein![K] Die Sonne geht\nauf!", italian=" Il sole![K] È la luce del sole!", spanish=" ¡La luz del sol![K] ¡Es el amanecer!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Sunlight![K] It's sunrise!", french=" La lumière![K] Le soleil se lève!", german="Sonnenschein![K] Die Sonne geht\nauf!", italian=" Il sole![K] È il sole che sorge!", spanish=" ¡La luz del sol![K] ¡Es el amanecer!"})
  else
  SkySceneKit.say({english=" Sunlight![K] It's sunrise!", french=" La lumière![K] Le soleil se lève!", german="Sonnenschein![K] Die Sonne geht\nauf!", italian=" Il sole![K] È l'alba!", spanish=" ¡La luz del sol![K] ¡Es el amanecer!"})
  end
  -- message_Close
  GROUND:EntTurn(npc_npc_juputoru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V21P02A) [décor sub chargé: Sub_v21p02a]
  -- camera2_SetPositionMark(Position<'m2', 20, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  SkySubScreen.Show("v21p02a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  -- Move2PositionMark<object OBJECT_V21P02A1_288> [prop décor NDS, géré par le rendu du ground]
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- back2_SetBackEffect(3) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- bgm_ChangeVolume(60,190) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  -- bgm2_PlayFadeIn(BGM_ON_THE_BEACH_AT_DUSK) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:WaitFrames(420)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's pretty, isn't it!", french=" C'est magnifique, pas vrai?", german=" Es ist schön, nicht wahr?", italian=" È bello, vero?", spanish=" Hermoso, ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's pretty, isn't it!", french=" C'est magnifique, pas vrai?", german=" Es ist schön, nicht wahr?", italian=" È bello, vero?", spanish=" Hermoso, ¿verdad?"})
  else
  SkySceneKit.say({english=" It's pretty, isn't it!", french=" C'est magnifique, pas vrai?", german=" Es ist schön, nicht wahr?", italian=" È meraviglioso, non credi?", spanish=" Precioso, ¿verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe it's because we were in\nthe future for so long...", french="C'est peut-être parce qu'on est\nrestés si longtemps dans le futur...", german="Vielleicht umso mehr, weil wir\nso lange in der Zukunft waren.", italian="Forse è perché siamo stati\ncosì tanto nel futuro...", spanish="Tal vez se deba al tiempo que\nhemos pasado en el futuro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Maybe it's because we were in\nthe future for so long...", french="C'est peut-être parce qu'on est\nrestés si longtemps dans le futur...", german="Vielleicht umso mehr, weil wir\nso lange in der Zukunft waren.", italian="Forse è perché siamo stati\ncosì tanto nel futuro...", spanish="Tal vez se deba al tiempo que\nhemos pasado en el futuro..."})
  else
  SkySceneKit.say({english="Maybe it's because we were in\nthe future for so long...", french="C'est peut-être à cause de\nnotre si long séjour dans le futur...", german="Vielleicht umso mehr, weil wir\nso lange in der Zukunft waren.", italian="Forse è perché siamo stati\ncosì tanto nel futuro...", spanish="Tal vez se deba al tiempo que\nhemos pasado en el futuro..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I didn't think that a sunrise\ncould ever feel so renewing!", french="Mais je n'aurais jamais pensé\nqu'un lever de soleil pouvait être aussi\nréconfortant!", german="Aber ich hätte nicht gedacht,\ndass ein Sonnenaufgang einem so die\nLebensgeister zurückbringen könnte!", italian="Non mi ricordavo che l'alba\npotesse essere così rigenerante!", spanish="Pero la verdad es que nunca\npensé que un amanecer pudiera tener\neste efecto en mí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I didn't think that a sunrise\ncould ever feel so renewing!", french="Mais je n'aurais jamais pensé\nqu'un lever de soleil pouvait être aussi\nréconfortant!", german="Aber ich hätte nicht gedacht,\ndass ein Sonnenaufgang einem so die\nLebensgeister zurückbringen könnte!", italian="Non mi ricordavo che l'alba\npotesse essere così rigenerante!", spanish="Pero la verdad es que nunca\npensé que un amanecer pudiera tener\neste efecto en mí."})
  else
  SkySceneKit.say({english="But I didn't think that a sunrise\ncould ever feel so renewing!", french="Mais je n'aurais jamais pensé\nqu'un lever de soleil pouvait être aussi\nréconfortant!", german="Aber ich hätte nicht gedacht,\ndass ein Sonnenaufgang einem so die\nLebensgeister zurückbringen könnte!", italian="Non mi ricordavo che l'alba\npotesse essere così rigenerante!", spanish="Pero la verdad es que nunca\npensé que un amanecer pudiera tener\neste efecto en mí."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The sun rises...[K] Then it sets...", french="Le soleil se lève...[K]\nse couche...", german="Die Sonne geht auf...[K] und wieder\nunter...", italian="Il sole si alza...[K] e poi\ntramonta...", spanish=" El sol sale...[K] Luego se oculta..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The sun rises...[K] Then it sets...", french="Le soleil se lève...[K]\nse couche...", german="Die Sonne geht auf...[K] und wieder\nunter...", italian="Il sole sorge...[K] e poi\ntramonta...", spanish=" El sol sale...[K] Luego se oculta..."})
  else
  SkySceneKit.say({english=" The sun rises...[K] Then it sets...", french="Le soleil se lève...[K]\nse couche...", german="Die Sonne geht auf...[K] und wieder\nunter...", italian="Il sole sorge...[K] e poi\ntramonta...", spanish=" El sol sale...[K] Luego se oculta..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We take that for granted, and\nthat's only natural.", french="Toutes ces choses, on considère\nqu'elles vont de soi, et c'est bien normal.", german="Das halten wir für\nselbstverständlich, und das ist nur natürlich.", italian="Lo diamo per scontato, è\nnaturale che sia così.", spanish="No le damos importancia a eso\nporque esperamos que ocurra todos los días."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We take that for granted, and\nthat's only natural.", french="Toutes ces choses, on considère\nqu'elles vont de soi, et c'est bien normal.", german="Das halten wir für\nselbstverständlich, und das ist nur natürlich.", italian="Lo diamo per scontato, è\nnaturale che sia così.", spanish="No le damos importancia a eso\nporque esperamos que ocurra todos los días."})
  else
  SkySceneKit.say({english="We take that for granted, and\nthat's only natural.", french="Toutes ces choses, on considère\nqu'elles vont de soi, et c'est bien normal.", german="Das halten wir für\nselbstverständlich, und das ist nur natürlich.", italian="Lo diamo per scontato, è\nnaturale che sia così.", spanish="No le damos importancia a eso\nporque esperamos que ocurra todos los días."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But things we take for granted...", french="Mais ces choses qu'on tient\npour acquises...", german=" Aber selbstverständliche Dinge...", italian="Ma le cose che diamo per\nscontate...", spanish="Pero son precisamente ese tipo\nde cosas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But things we take for granted...", french="Mais ces choses qu'on tient\npour acquises...", german=" Aber selbstverständliche Dinge...", italian="Ma le cose che diamo per\nscontate...", spanish="Pero son precisamente ese tipo\nde cosas..."})
  else
  SkySceneKit.say({english=" But things we take for granted...", french="Mais ces choses qu'on tient\npour acquises...", german=" Aber selbstverständliche Dinge...", italian="Ma le cose che diamo per\nscontate...", spanish="Pero son precisamente ese tipo\nde cosas..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They're really the most essential\nthings. And they're precious.", french="... ce sont vraiment les choses\nles plus essentielles, les plus précieuses.", german="Das sind wirklich die\nallerwichtigsten Dinge. Und sie sind so kostbar.", italian="Beh, sono davvero le cose più\nessenziali. E sono preziose.", spanish="Las que tienen más importancia\nen nuestra vida, las más preciosas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They're really the most essential\nthings. And they're precious.", french="... ce sont vraiment les choses\nles plus essentielles, les plus précieuses.", german="Das sind wirklich die\nallerwichtigsten Dinge. Und sie sind so kostbar.", italian="Beh, sono davvero le cose più\nessenziali. E sono preziose.", spanish="Las que tienen más importancia\nen nuestra vida, las más preciosas."})
  else
  SkySceneKit.say({english="They're really the most essential\nthings. And they're precious.", french="... ce sont vraiment les choses\nles plus essentielles, les plus précieuses.", german="Das sind wirklich die\nallerwichtigsten Dinge. Und sie sind so kostbar.", italian="Beh, sono davvero le cose più\nessenziali. E sono preziose.", spanish="Las que tienen más importancia\nen nuestra vida, las más valiosas."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="All I'd ever known is the\nfuture's world of darkness.", french="Jusqu'à présent, je n'avais connu\nque le futur et l'ombre qui l'a envahi.", german="Alles, was ich je gekannt hatte,\nwar die Welt der Dunkelheit in der Zukunft.", italian="Il mondo del futuro è avvolto\ndall'oscurità.", spanish="Yo solo había conocido el mundo\nsombrío del futuro."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Upon coming to this world...[K]\nAnd seeing the sun for the first time...", french="En arrivant dans ce monde...[K]\nquand j'ai vu le soleil pour la première fois...", german="Als ich in diese Welt kam...[K]\nUnd zum ersten Mal die Sonne sah...", italian="Venire in questo mondo,[K]\nvedere il sole per la prima volta...", spanish="Al llegar aquí...[K]\nY ver salir el sol por primera vez..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" It was staggering.", french=" ... j'ai été stupéfait.", german=" Es war überwältigend.", italian="È stata una sensazione\nincredibile.", spanish=" Fue asombroso."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Seeing it...[K] It strengthened my\nresolve to turn history away from a future\nof darkness.", french="Voir le soleil...[K] a renforcé\nma détermination à empêcher l'avènement\nde ce futur plongé dans l'ombre.", german="Sie zu sehen,[K] bestärkte mich\nin dem Entschluss, die Geschichte vor einer\nfinsteren Zukunft zu bewahren.", italian="Vedere tutto ciò...[K] ha\nrafforzato la mia decisione di cambiare la\nstoria, di evitare un futuro di oscurità.", spanish="Ver algo así...[K] me reafirmó\nen mis intenciones de cambiar la historia\ny evitar un futuro de oscuridad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="There is one thing that I wanted\nto ask of you, [partner].", french="Il y a une chose que je voulais\nte demander, [partner].", german="Ich möchte dich gerne etwas\nfragen, [partner].", italian="Ti volevo chiedere una cosa,\n[partner].", spanish="Hay una cosa que me gustaría\npreguntarte, [partner]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It's about that time in\nthe future...", french="C'est à propos de ce qui s'est\npassé dans le futur...", german="Es geht um diese Zeit in der\nZukunft...", italian="A proposito di quando eravamo\nnel futuro...", spanish="Es sobre lo que ocurrió en\nel futuro..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...when we were confronted by\n[CS:N]Dialga[CR]...", french=" ... quand on a affronté [CS:N]Dialga[CR]...", german="Als wir von [CS:N]Dialga[CR] gestellt\nwurden...", italian="Quando ci siamo trovati di\nfronte a [CS:N]Dialga[CR]...", spanish="Cuando nos enfrentamos a\n[CS:N]Dialga[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Frankly, we were in a no-win\nsituation. There was no hope.", french="Franchement, le combat était\nperdu d'avance. C'était sans espoir.", german="Offen gesagt, waren wir in einer\naussichtslosen Lage. Völlig ohne Hoffnung.", italian="Francamente, eravamo senza via\ndi scampo. Non avevamo speranze.", spanish="La verdad es que era imposible\nganar en aquella situación. No había esperanza."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(140) end) -- bgm_ChangeVolume vers 0 (silence)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
