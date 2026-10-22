-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P05P02A/m17a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey...[K][hero]...", french=" Eh...[K] [hero]...", german=" Hey...[K] [hero]...", italian=" Ehi...[K] [hero]...", spanish=" Oye...[K] [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey...[K][hero]...", french=" Eh...[K] [hero]...", german=" Hey...[K] [hero]...", italian=" Ehi...[K] [hero]...", spanish=" Oye...[K] [hero]..."})
  else
  SkySceneKit.say({english=" Hey...[K][hero]...", french=" Eh...[K] [hero]...", german=" Hey...[K] [hero]...", italian=" Ehi...[K] [hero]...", spanish=" Oye...[K] [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wake up, [hero]!", french=" Réveille-toi, [hero]!", german=" Wach auf, [hero]!", italian=" Svegliati, [hero]!", spanish=" ¡Despierta, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wake up, [hero]!", french=" Réveille-toi, [hero]!", german=" Wach auf, [hero]!", italian=" Svegliati, [hero]!", spanish=" ¡Despierta, [hero]!"})
  else
  SkySceneKit.say({english=" Wake up, [hero]!", french=" Réveille-toi, [hero]!", german=" Wach auf, [hero]!", italian=" Svegliati, [hero]!", spanish=" ¡Despierta, [hero]!"})
  end
  -- message_Close
  -- back_SetGround(LEVEL_P05P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(76) [anim idle native]
  GAME:FadeIn(60)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Ugh...)", french="(Argh...)", german="(Argh...)", italian="(Oooh...)", spanish="(Ay...)"})
  else
  SkySceneKit.say({english="(Ugh...)", french="(Argh...)", german="(Argh...)", italian="(Oooh...)", spanish="(Ay...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wh-where...?)", french="(Où suis-je...?)", german="(W-wo?)", italian="(D-Dove...?)", spanish="(¿Dónde...?)"})
  else
  SkySceneKit.say({english="(Wh-where...?)", french="(Où suis-je...?)", german="(W-wo?)", italian="(D-Dove...?)", spanish="(¿Dónde...?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You're awake!", french="Ça y est, tu as repris\nconscience!", german=" Du bist wach!", italian=" Stai bene?", spanish=" ¡Te has despertado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You're awake!", french="Ça y est, tu as repris\nconscience!", german=" Du bist wach!", italian=" Stai bene?", spanish=" ¡Te has despertado!"})
  else
  SkySceneKit.say({english=" You're awake!", french="Ça y est, tu as repris\nconscience!", german=" Du bist wach!", italian=" Stai bene?", spanish=" ¡Te has despertado!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-16), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This place... I think it's a jail.", french="Cet endroit... je crois bien que\nc'est une prison.", german="Dieser Ort... Ich glaube, das ist\nein Gefängnis.", italian="Questo posto... sembra una\nspecie di prigione.", spanish="Creo que estamos... en una\nprisión."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This place... I think it's a jail.", french="Cet endroit... je crois bien que\nc'est une prison.", german="Dieser Ort... Ich glaube, das ist\nein Gefängnis.", italian="Questo posto... penso che sia una\nprigione.", spanish="Creo que estamos... en una\nprisión."})
  else
  SkySceneKit.say({english=" This place... I think it's a jail.", french="Cet endroit... je crois bien que\nc'est une prison.", german="Dieser Ort... Ich glaube, das ist\nein Gefängnis.", italian="Questo posto... penso che sia una\nprigione.", spanish="Creo que estamos... en una\nprisión."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(J-jail?!)", french="(Une... une prison?!)", german="(G-gefängnis?!?)", italian="(P-Prigione?!)", spanish="(¡¿Una prisión?!)"})
  else
  SkySceneKit.say({english="(J-jail?!)", french="(Une... une prison?!)", german="(G-gefängnis?!?)", italian="(P-Prigione?!)", spanish="(¡¿Una prisión?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I just woke up a while ago, so\nI'm not sure what's going on.", french="Je viens à peine de reprendre\nconnaissance, alors je ne sais pas encore trop\nce qui se passe.", german="Ich bin noch nicht lange wach,\nalso weiß ich nicht sicher, was los ist.", italian="Anch'io mi sono svegliato un\nminuto fa e non so cosa stia succedendo.", spanish="Me he despertado hace poco, así\nque no estoy muy seguro de lo que pasa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I just woke up a while ago, so\nI'm not sure what's going on.", french="Je viens à peine de reprendre\nconnaissance, alors je ne sais pas encore trop\nce qui se passe.", german="Ich bin noch nicht lange wach,\nalso weiß ich nicht sicher, was los ist.", italian="Anch'io mi sono svegliato un\nminuto fa e non so cosa stia succedendo.", spanish="Me he despertado hace poco, así\nque no estoy muy seguro de lo que pasa."})
  else
  SkySceneKit.say({english="I just woke up a while ago, so\nI'm not sure what's going on.", french="Je viens à peine de reprendre\nconnaissance, alors je ne sais pas encore trop\nce qui se passe.", german="Ich bin noch nicht lange wach,\nalso weiß ich nicht sicher, was los ist.", italian="Anch'io mi sono svegliata un\nminuto fa e non so cosa stia succedendo.", spanish="Me he despertado hace poco, así\nque no estoy muy segura de lo que pasa."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I tried opening the doors, but\nthey're locked.", french="J'ai essayé d'ouvrir la porte,\nmais elle est fermée à clé.", german="Ich habe versucht, die Türen\nzu öffnen, aber sie sind abgeschlossen.", italian="Ho provato ad aprire la porta,\nma è bloccata.", spanish="He intentado abrir la reja, pero\nestá cerrada con llave."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I tried the doors, but they're\nlocked.", french="J'ai essayé d'ouvrir la porte,\nmais elle est fermée à clé.", german="Ich habe versucht, die Türen\nzu öffnen, aber sie sind abgeschlossen.", italian="Ho provato ad aprire la porta,\nma è bloccata.", spanish="He intentado abrir la reja, pero\nestá cerrada con llave."})
  else
  SkySceneKit.say({english="I tried opening the doors, but\nthey're locked.", french="J'ai essayé d'ouvrir la porte,\nmais elle est fermée à clé.", german="Ich habe versucht, die Türen\nzu öffnen, aber sie sind abgeschlossen.", italian="Ho provato ad aprire la porta,\nma è bloccata.", spanish="He intentado abrir la reja, pero\nestá cerrada con llave."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There doesn't seem to be any\nother way out.", french="Et il n'y a aucun autre moyen\nde sortir.", german="Es scheint sonst keinen Weg\nnach draußen zu geben.", italian="Non sembra esserci un'altra via\nd'uscita.", spanish="No parece haber ninguna otra\nsalida."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There seems to be no other\nway out.", french="Et il n'y a aucun autre moyen\nde sortir.", german="Es scheint sonst keinen Weg\nnach draußen zu geben.", italian="Non sembra esserci un'altra via\nd'uscita.", spanish="No parece haber ninguna otra\nsalida."})
  else
  SkySceneKit.say({english="There seems to be no other\nway out.", french="Et il n'y a aucun autre moyen\nde sortir.", german="Es scheint sonst keinen Weg\nnach draußen zu geben.", italian="Non sembra esserci un'altra via\nd'uscita.", spanish="No parece haber ninguna otra\nsalida."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think that we've been locked\nup...[K] Ugh...", french="J'ai bien l'impression qu'on nous\na enfermés ici...[K] Argh...", german="Ich glaube, wir sind\neingesperrt...[K] Ugh...", italian="Mi sa che ci hanno rinchiuso per\nbene...[K] Argh...", spanish="Creo que nos han encerrado...[K]\nAy..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I think that we've been locked\nup...[K] Ugh...", french="J'ai bien l'impression qu'on nous\na enfermés ici...[K] Argh...", german="Ich glaube, wir sind\neingesperrt...[K] Ugh...", italian="Temo che ci abbiano rinchiuso\nper bene...[K] Mmm...", spanish="Creo que nos han encerrado...[K]\nAy..."})
  else
  SkySceneKit.say({english="I think that we've been locked\nup...[K] Ugh...", french="J'ai bien l'impression qu'on nous\nséquestre ici...[K] Argh...", german="Ich glaube, wir sind\neingesperrt...[K] Ugh...", italian="Temo che ci abbiano rinchiuso\nper bene...[K] Mmm...", spanish="Creo que nos han encerrado...[K]\nAy..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wh-what's going on?)", french="(Mais... qu'est-ce qui se passe?)", german="(W-was ist hier los?)", italian="(Ma... cosa sta succedendo?)", spanish="(¿Qué está pasando aquí?)"})
  else
  SkySceneKit.say({english="(Wh-what's going on?)", french="(Mais... qu'est-ce qui se passe?)", german="(W-was ist hier los?)", italian="(Ma... cosa sta succedendo?)", spanish="(¿Qué está pasando aquí?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We're locked up?)", french="(On nous séquestre?)", german="(Wir sind eingesperrt?)", italian="(Ci hanno riunchiuso?)", spanish="(¿Nos han encerrado?)"})
  else
  SkySceneKit.say({english="(We're locked up?)", french="(On nous séquestre?)", german="(Wir sind eingesperrt?)", italian="(Ci hanno riunchiuso?)", spanish="(¿Nos han encerrado?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I don't know what's going on either, but I may\nas well investigate...)", french="(Moi non plus, je n'y comprends rien, mais\nautant inspecter les lieux...)", german="(Ich weiß auch nicht, was los ist, aber ich\nkann versuchen, es herauszufinden.)", italian="(Anch'io non capisco cosa succede, ma tanto\nvale dare un'occhiata in giro...)", spanish="(Yo tampoco entiendo lo que pasa, pero\ndeberíamos investigar...)"})
  else
  SkySceneKit.say({english="(I don't know what's going on either, but I may\nas well investigate...)", french="(Moi non plus, je n'y comprends rien, mais\nautant inspecter les lieux...)", german="(Ich weiß auch nicht, was los ist, aber ich\nkann versuchen, es herauszufinden.)", italian="(Anch'io non capisco cosa succede, ma tanto\nvale dare un'occhiata in giro...)", spanish="(Yo tampoco entiendo lo que pasa, pero\ndeberíamos investigar...)"})
  end
  -- message_Close
end
