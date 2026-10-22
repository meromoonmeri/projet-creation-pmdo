-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D15P41A/m14a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D15P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  local npc_npc_emuritto = SkySceneKit.spawn_npc("mesprit", 304, 224, Direction.Down, "NPC_EMURITTO")
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" Urgh...[K]urgh...", french=" Argh...[K] argh...", german=" Urgh...[K] Urgh...", italian=" Argh...[K] Ooh...", spanish=" Aaah...[K] Sois fuertes..."})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="But I can't let you take...[K]\nthe Time Gear...", french="Mais je ne peux pas vous\nlaisser...[K] prendre le Rouage du Temps...", german="Aber[K] ich kann euch das Zahnrad\nder Zeit nicht überlassen...", italian="Ma non posso permettere...[K]\nche venga rubato l'Ingranaggio del Tempo...", spanish="Pero no os permitiré salir de\naquí con...[K] el Engranaje del Tiempo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Listen!", french="Tu veux bien m'écouter deux\nsecondes?", german=" Hör zu!", italian=" Ascoltaci una buona volta!", spanish=" ¡Escúchanos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Will you please listen?!", french="Tu veux bien m'écouter deux\nsecondes?", german=" Hör uns doch zu!", italian=" Ti prego, ascoltaci!", spanish=" ¡¿Quieres escucharnos?!"})
  else
  SkySceneKit.say({english=" Please, listen!", french="Tu veux bien m'écouter deux\nsecondes?", german=" Hör uns bitte zu!", italian=" Ti prego, ascoltaci!", spanish=" ¡Escúchanos, por favor!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We keep telling you! We didn't\ncome here to steal your Time Gear!", french="On n'arrête pas de te répéter\nqu'on n'a pas l'intention de te le voler,\nton Rouage du Temps!", german="Wie oft denn noch?!? Wir sind\nnicht hier, um dein Zahnrad der Zeit zu\nstehlen!", italian="Come te lo dobbiamo dire che\nnon siamo venuti per rubare l'Ingranaggio\ndel Tempo!", spanish="¡Ya te lo he dicho! ¡No hemos\nvenido a robar el Engranaje del Tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We didn't come here to steal\nyour Time Gear! Really!", french="On n'arrête pas de te répéter\nqu'on n'a pas l'intention de te le voler,\nton Rouage du Temps!", german="Wir sind nicht hier, um dein\nZahnrad der Zeit zu stehlen! Wirklich!", italian="Devi crederci! Non siamo qui per\nrubare l'Ingranaggio del Tempo!", spanish="¡No hemos venido a robar\nel Engranaje del Tiempo! ¡En serio!"})
  else
  SkySceneKit.say({english="We didn't come to steal your\nTime Gear! Really!", french="On n'arrête pas de te répéter\nqu'on n'a pas l'intention de te le voler,\nton Rouage du Temps!", german="Wir sind nicht hier, um dein\nZahnrad der Zeit zu stehlen! Wirklich!", italian="Devi crederci! Non siamo qui per\nrubare l'Ingranaggio del Tempo!", spanish="¡No hemos venido a robar\nel Engranaje del Tiempo! ¡En serio!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" Don't lie to me!", french=" Epargnez-moi vos mensonges!", german=" Lügt mich nicht an!", italian=" Non mentitemi!", spanish=" ¡Basta de mentiras!"})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[CS:N]Uxie[CR] used his telepathy to tell\nme what happened!", french="Je sais tout! [CS:N]Créhelf[CR] m'a\navertie par télépathie!", german="[CS:N]Selfe[CR] hat mir per Telepathie\nerzählt, was geschehen ist!", italian="[CS:N]Uxie[CR] si è messo in contatto\ntelepatico con me e mi ha raccontato tutto!", spanish="[CS:N]Uxie[CR] me ha contado\ntelepáticamente lo que ocurrió."})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="I know that the Time Gear from\n[CS:P]Fogbound Lake[CR] was stolen!", french="Je sais que le Rouage du Temps\ndu [CS:P]Lac des Brumes[CR] a disparu!", german="Ich weiß, dass das Zahnrad der\nZeit vom [CS:P]Nebelsee[CR] gestohlen wurde!", italian="So benissimo che l'Ingranaggio\ndel Tempo del [CS:P]Lago Foschia[CR] è stato rubato!", spanish="Sé que robasteis el Engranaje\ndel Tiempo del [CS:P]Lago Velado[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What? You heard it from [CS:N]Uxie[CR]?", french="Quoi? C'est [CS:N]Créhelf[CR] qui\nt'a avertie?", german=" Was? [CS:N]Selfe[CR] hat es dir gesagt?", italian=" Cosa? Te l'ha detto [CS:N]Uxie[CR]?", spanish=" ¿Qué? ¿[CS:N]Uxie[CR] te ha dicho eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? You heard it from [CS:N]Uxie[CR]?", french="Quoi? C'est [CS:N]Créhelf[CR] qui\nt'a avertie?", german=" Was? [CS:N]Selfe[CR] hat es dir gesagt?", italian=" Cosa? Te l'ha detto [CS:N]Uxie[CR]?", spanish=" ¿Qué? ¿[CS:N]Uxie[CR] te ha dicho eso?"})
  else
  SkySceneKit.say({english="Pardon? You heard about it\nfrom [CS:N]Uxie[CR]?", french="Quoi? C'est [CS:N]Créhelf[CR] qui\nt'a avertie?", german=" Was? [CS:N]Selfe[CR] hat es dir gesagt?", italian=" Cosa? Te l'ha detto [CS:N]Uxie[CR]?", spanish=" ¿Qué? ¿[CS:N]Uxie[CR] te ha dicho eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" That was your doing, wasn't it?!", french=" C'était vous, n'est-ce pas?!", german=" Das wart ihr, nicht wahr?!?", italian=" È stata opera vostra, vero?", spanish="¡No pongáis cara de no haber\nroto nunca un plato!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No! It wasn't us!", french=" Non, ce n'est pas nous!", german=" Nein! Wir waren es nicht!", italian=" No! Non è colpa nostra!", spanish="¡Te equivocas! ¡No hemos\nsido nosotros!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No! We didn't do it!", french=" Non, ce n'est pas nous!", german=" Nein! Wir waren es nicht!", italian=" No! Non è colpa nostra!", spanish="¡Te equivocas! ¡No hemos\nsido nosotros!"})
  else
  SkySceneKit.say({english=" No! It wasn't us!", french=" Non, ce n'est pas nous!", german=" Nein! Wir waren es nicht!", italian=" No! Non è colpa nostra!", spanish="¡Te equivocas! ¡No ha sido\ncosa nuestra!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" Then who's responsible?!", french=" Alors qui?!", german=" Wer ist dann verantwortlich?!?", italian="Ah no? E chi sarebbe stato,\nallora?!", spanish="Entonces, ¿quién es el\nresponsable?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(45) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" That would probably be...[K]me.", french="J'imagine que c'est...[K] de moi\nque vous parlez.", german=" Das wäre dann wohl...[K] ich.", italian=" Penso stiate parlando...[K] di me.", spanish="Creo que estáis hablando...[K]\nde un servidor."})
  -- message_Close
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_emuritto, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 304, 384, Direction.Up, "NPC_JUPUTORU")
  GROUND:MoveToPosition(npc_npc_juputoru, 300, 308, false, 2)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.DownRight) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.DownLeft) end end
  pcall(function() GAME:MoveCamera(300, 292, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_emuritto, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" Who are you?!", french=" Qui va là?!", german=" Wer bist du?!?", italian=" E tu chi sei?", spanish=" ¡¿Quién eres?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]G-Grovyle[CR]!", french=" [CS:N]M-Massko[CR]!", german=" [CS:N]R-Reptain[CR]!", italian=" [CS:N]G-Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]G-Grovyle[CR]!", french=" [CS:N]M-Massko[CR]!", german=" [CS:N]R-Reptain[CR]!", italian=" [CS:N]G-Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]G-Grovyle[CR]!", french=" [CS:N]M-Massko[CR]!", german=" [CS:N]R-Reptain[CR]!", italian=" [CS:N]G-Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Th-that's [CS:N]Grovyle[CR]!)", french="(C'est [CS:N]Massko[CR]!)", german="(D-das ist [CS:N]Reptain[CR]!)", italian="(Quello è [CS:N]Grovyle[CR]!)", spanish="(¡Ese es [CS:N]Grovyle[CR]!)"})
  else
  SkySceneKit.say({english="(Th-that's [CS:N]Grovyle[CR]!)", french="(C'est [CS:N]Massko[CR]!)", german="(D-das ist [CS:N]Reptain[CR]!)", italian="(Quello è [CS:N]Grovyle[CR]!)", spanish="(¡Ese es [CS:N]Grovyle[CR]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I must apologize...[K]but I will be\ntaking that Time Gear.", french="Vous m'en voyez navré mais...[K]\nje vais m'emparer de ce Rouage du Temps.", german="Entschuldigt...[K] Aber ich werde\ndieses Zahnrad der Zeit mitnehmen.", italian="Vi chiedo scusa...[K] ma sarò io a\nprendere l'Ingranaggio del Tempo.", spanish="Tendréis que perdonarme, pero...[K]\nme voy a llevar el Engranaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 236, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_juputoru, 300, 264, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  -- GAP: se_Play(7172) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(12) [anim idle native]
  GROUND:MoveToPosition(npc_npc_juputoru, 300, 244, false, 2)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 248, 228, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 352, 228, false, 2) -- SlidePositionMark (glissement)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Eeeh!?", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Eeeh!?", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Eeeh!?", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Stand aside.", french=" Ecarte-toi.", german=" Lass mich durch.", italian=" Fatevi da parte.", spanish=" Apártate de mi camino."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" I...I won't!", french=" Jamais!", german=" Ich... Ich lasse dich nicht durch!", italian=" N... No!", spanish=" ¡No... no pienso hacerlo!"})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="I won't let you take the\nTime Gear!", french="Je ne te laisserai pas t'emparer\ndu Rouage du Temps!", german="Ich lasse nicht zu, dass du das\nZahnrad der Zeit nimmst!", italian=" Non te lo permetterò!", spanish="¡No dejaré que te lleves\nel Engranaje del Tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I have no choice then...", french="Alors tu ne me laisses pas\nle choix...", german=" Dann habe ich keine Wahl...", italian="Non mi lasci altra scelta,\nallora...", spanish=" Entonces no tengo elección..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(8)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_emuritto, "shock", 1) end)
  GROUND:MoveToPosition(npc_npc_emuritto, 316, 224, false, 2) -- SlidePositionMark (glissement)
  -- SetAnimation(24) [anim idle native]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" Urgh!", french=" Argh!", german=" Urgh!", italian=" Urgh!", spanish=" ¡Aaaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Mesprit[CR]!", french=" [CS:N]Créfollet[CR]!", german=" [CS:N]Vesprit[CR]!", italian=" [CS:N]Mesprit[CR]!", spanish=" ¡[CS:N]Mesprit[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Mesprit[CR]!", french=" [CS:N]Créfollet[CR]!", german=" [CS:N]Vesprit[CR]!", italian=" [CS:N]Mesprit[CR]!", spanish=" ¡[CS:N]Mesprit[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Mesprit[CR]!", french=" [CS:N]Créfollet[CR]!", german=" [CS:N]Vesprit[CR]!", italian=" [CS:N]Mesprit[CR]!", spanish=" ¡[CS:N]Mesprit[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You lost that fight.", french=" Tu es vaincue.", german=" Du hast diesen Kampf verloren.", italian="Bisogna saper riconoscere la\nsconfitta.", spanish=" Acabas de perder una pelea."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You sustained serious damage.", french=" Et tu as subi de sérieux dégâts.", german="Du hast ernsthaften Schaden\ndavongetragen.", italian=" Ti conviene arrenderti.", spanish="No estás en condiciones de\nenfrentarte a mí."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" So don't push it.", french=" Alors, un conseil: n'insiste pas.", german="Sei also vernünftig und\nübertreibe es nicht.", italian=" Lo dico per te.", spanish=" Así que mejor ni lo intentes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_juputoru, 300, 216, false, 1)
  GAME:WaitFrames(45)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You're not getting by us!", french="Il faudra nous passer\nsur le corps!", german=" An uns kommst du nicht vorbei!", italian=" Non ti lasceremo passare!", spanish=" ¡No vas a pasar por aquí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You're not getting by us!", french="Il faudra nous passer\nsur le corps!", german=" An uns kommst du nicht vorbei!", italian=" Non ti lasceremo passare!", spanish=" ¡No vas a pasar por aquí!"})
  else
  SkySceneKit.say({english=" You're not getting by us!", french="Il faudra nous passer\nsur le corps!", german=" An uns kommst du nicht vorbei!", italian=" Non ti lasceremo passare!", spanish=" ¡No vas a pasar por aquí!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 316, 196, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 284, 196, false, 2)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We won't let you take the\nTime Gear!", french=" On ne te laissera pas faire!", german="Wir lassen nicht zu, dass du\ndas Zahnrad der Zeit nimmst!", italian="Non ti permetteremo di prendere\nl'Ingranaggio del Tempo!", spanish="¡No permitiremos que te lleves\nel Engranaje del Tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We won't let you take the\nTime Gear!", french=" On ne te laissera pas faire!", german="Wir lassen nicht zu, dass du\ndas Zahnrad der Zeit nimmst!", italian="Non ti permetteremo di prendere\nl'Ingranaggio del Tempo!", spanish="¡No permitiremos que te lleves\nel Engranaje del Tiempo!"})
  else
  SkySceneKit.say({english="We won't let you take the\nTime Gear!", french=" On ne te laissera pas faire!", german="Wir lassen nicht zu, dass du\ndas Zahnrad der Zeit nimmst!", italian="Non ti permetteremo di prendere\nl'Ingranaggio del Tempo!", spanish="¡No permitiremos que te lleves\nel Engranaje del Tiempo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" All right...", french=" Entendu...", german=" In Ordnung...", italian=" Capisco...", spanish=" Si así lo queréis..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Sorry for this.", french=" Désolé.", german=" Es tut mir leid.", italian=" Chiedo scusa.", spanish="No me queda otro remedio.\nSiento tener que hacer esto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(3)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 244, 196, false, 2) -- SlidePositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 348, 196, false, 2) -- SlidePositionMark (glissement)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh! He's so...[K]fast!", french=" Argh! Il est bien trop...[K] rapide!", german=" Ugh! Er ist so...[K] schnell!", italian=" Argh![K] È troppo veloce!", spanish=" ¡Ay! Es muy...[K] rápido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! He's so...[K]fast!", french=" Argh! Il est bien trop...[K] rapide!", german=" Ugh! Er ist so...[K] schnell!", italian=" Argh! È...[K] velocissimo!", spanish=" ¡Ay! Es muy...[K] rápido."})
  else
  SkySceneKit.say({english=" Ugh! He's so...[K]fast!", french=" Argh! Il est bien trop...[K] rapide!", german=" Ugh! Er ist so...[K] schnell!", italian=" Argh! È...[K] velocissimo!", spanish=" ¡Ay! Es muy...[K] rápido."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "sweating", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "sweating", 1) end) end end
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Forgive me. I have no quarrel\nwith any of you.", french="Excusez-moi. Ça n'a rien\nde personnel.", german="Vergebt mir. Ich wollte euch\nkeinen Schaden zufügen.", italian="Perdonatemi. Non ho nulla contro\ndi voi...", spanish="Perdonadme. No tengo nada\nen contra vuestra."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" But I'm taking that Time Gear!", french="Mais j'emporte le Rouage\ndu Temps avec moi!", german="Aber ich nehme dieses Zahnrad\nder Zeit mit!", italian="Però l'Ingranaggio del Tempo\nviene con me!", spanish="Pero me voy a llevar ese\nEngranaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 300, 168, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(24) [anim idle native]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(7173) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ugh...the Time Gear...[K] That thief\nis taking it...", french="Argh... le Rouage du Temps...[K]\nCe voleur est en train de s'en emparer...", german="Ugh... Das Zahnrad der Zeit...[K]\nDer Dieb hat es.", italian="Ugh... L'Ingranaggio del\nTempo...[K] Quel ladro lo sta portando via...", spanish="¡Ay! El Engranaje del Tiempo...[K]\n¡Ese ladrón va a llevárselo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ugh...the Time Gear...[K] That thief\nis taking it...", french="Argh... le Rouage du Temps...[K]\nCe voleur est en train de s'en emparer...", german="Ugh... Das Zahnrad der Zeit...[K]\nDer Dieb hat es.", italian="Ugh... L'Ingranaggio del\nTempo...[K] Quel ladro lo sta portando via...", spanish="¡Ay! El Engranaje del Tiempo...[K]\n¡Ese ladrón va a llevárselo!"})
  else
  SkySceneKit.say({english="Ugh...the Time Gear...[K] That thief\nis taking it...", french="Argh... le Rouage du Temps...[K]\nCe voleur est en train de s'en emparer...", german="Ugh... Das Zahnrad der Zeit...[K]\nDer Dieb hat es.", italian="Ugh... L'Ingranaggio del\nTempo...[K] Quel ladro lo sta portando via...", spanish="¡Ay! El Engranaje del Tiempo...[K]\n¡Ese ladrón va a llevárselo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" I...I'm sorry...", french=" Je... je suis désolée...", german=" Es... tut mir leid...", italian=" P-Perdonatemi...", spanish=" Lo... lo siento..."})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[CS:N]Uxie[CR] must not have been talking\nabout you...", french="Ce ne doit pas être de vous\nque [CS:N]Créhelf[CR] parlait...", german="[CS:N]Selfe[CR] hat wohl nicht euch\ngemeint.", italian="Ora so che [CS:N]Uxie[CR] non si riferiva\na voi...", spanish="[CS:N]Uxie[CR] no debía de referirse\na vuestro equipo..."})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" It was that Pokémon...", french=" Mais de lui...", german=" Es meinte dieses Pokémon.", italian=" È stato quel Pokémon...", spanish=" Sino a ese Pokémon..."})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" I'm sorry for doubting you.", french="Excusez-moi d'avoir douté\nde vous.", german="Es tut mir leid, dass ich euch\nmisstraut habe.", italian=" Non avrei dovuto dubitare di voi.", spanish="Siento haber dudado de vuestra\npalabra."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(45)
  -- GAP: se_Play(5125) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(80)
  GAME:FadeIn(5)
  GAME:WaitFrames(15)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  -- SetOutputAttribute(256) [neutre/état moteur]
  GROUND:EntTurn(npc_npc_emuritto, Direction.Up)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_emuritto, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" Oh! This is bad!", french=" Oh non! C'est une catastrophe!", german=" Oh! Wie schrecklich!", italian=" Oh, no! È terribile!", spanish=" Vaya, esto no tiene buena pinta."})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" We have to get out of here!", french=" Sortons d'ici au plus vite!", german=" Wir müssen verschwinden!", italian="Dobbiamo andarcene subito da\nqui!", spanish=" ¡Tenemos que salir de aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-why?", french=" Mais... pourquoi ça?", german=" W-warum?", italian=" P-Perché?", spanish=" ¿Por qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-why?", french=" Mais... pourquoi ça?", german=" W-warum?", italian=" P-Perché?", spanish=" ¿Por qué?"})
  else
  SkySceneKit.say({english=" Wh-why?", french=" Mais... pourquoi ça?", german=" W-warum?", italian=" P-Perché?", spanish=" ¿Por qué?"})
  end
  -- message_Close
  GAME:FadeOut(false, 15)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- camera_SetEffect(0): arrêt d'effet caméra
  SkySceneKit.cleanup_npcs()
end
