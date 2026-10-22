-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D38P12A/s21p0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER
    GROUND:EntTurn(hero, Direction.Up)
    -- SetAnimation(72) [anim idle native]
    -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:MoveToPosition(hero, 256, 220, false, 2) -- SlidePositionMark (glissement)
    -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
    -- SetAnimation(11) [anim idle native]
    -- GAP: se_Play(7939) — id SE NDS sans portage PMDO identifié
    -- SlideHeight(2, 12) [neutre/état moteur]
    GAME:WaitFrames(2)
    -- SlideHeight(2, 0) [neutre/état moteur]
    GROUND:EntTurn(hero, Direction.Right)
    -- SetAnimation(68) [anim idle native]
    GAME:WaitFrames(60)
    SkySceneKit.lock(6) -- Lock(6) NDS
    -- SetAnimation(63) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(7) -- Lock(7) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_ATTENDANT1
    GROUND:EntTurn(partner, Direction.Up)
    -- SetAnimation(72) [anim idle native]
    -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
    SkySceneKit.lock(8) -- Lock(8) NDS
    GROUND:MoveToPosition(partner, 224, 220, false, 2) -- SlidePositionMark (glissement)
    -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
    -- SetAnimation(11) [anim idle native]
    -- SlideHeight(2, 12) [neutre/état moteur]
    GAME:WaitFrames(2)
    -- SlideHeight(2, 0) [neutre/état moteur]
    GROUND:EntTurn(partner, Direction.Left)
    -- SetAnimation(68) [anim idle native]
    GAME:WaitFrames(45)
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(9) -- Lock(9) NDS
    -- SetAnimation(63) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(10) -- Lock(10) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 81) -- $SCENARIO_MAIN = scn[29,81] (ROM)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaaaah!", french=" Ouaaah!", german=" Uaaaaaah!", italian=" Waaaaaah!", spanish=" ¡Aaaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaaaah!", french=" Ouaaah!", german=" Uaaaaaah!", italian=" Aaaaaaah!", spanish=" ¡Aaaaaah!"})
  else
  SkySceneKit.say({english=" Waaaaaah!", french=" Ouaaah!", german=" Uaaaaaah!", italian=" Aaaaaaah!", spanish=" ¡Aaaaaah!"})
  end
  -- message_Close
  -- back_SetGround(LEVEL_D38P12A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:FadeIn(30)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(10)
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Owowow...", french=" Ouille ouille ouille...", german=" Oh, oh, oh...", italian=" Ahiahiahi...", spanish=" Ay, ay, ay..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Owowow...", french=" Ouille ouille ouille...", german=" Oh, oh, oh...", italian=" Ahiahiahi...", spanish=" Ay, ay, ay..."})
  else
  SkySceneKit.say({english=" Owowow...", french=" Ouille ouille ouille...", german=" Oh, oh, oh...", italian=" Ahiahiahi...", spanish=" Ay, ay, ay..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  GAME:WaitFrames(10)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] Are you OK, [hero]?", french="Argh...[K] Tu vas bien,\n[hero]?", german=" Uff...[K] Alles okay, [hero]?", italian=" Ugh...[K] Stai bene, [hero]?", spanish=" Uf...[K] ¿Estás bien, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] Are you OK, [hero]?", french="Argh...[K] Tu vas bien,\n[hero]?", german=" Uff...[K] Alles okay, [hero]?", italian=" Ugh...[K] Stai bene, [hero]?", spanish=" Uf...[K] ¿Estás bien, [hero]?"})
  else
  SkySceneKit.say({english=" Ugh...[K] Are you OK, [hero]?", french="Argh...[K] Tu vas bien,\n[hero]?", german=" Uff...[K] Alles okay, [hero]?", italian=" Ugh...[K] Stai bene, [hero]?", spanish=" Uf...[K] ¿Estás bien, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Chasm Cave.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It looks like we landed\nsomewhere else...", french="On dirait qu'on a atterri autre\npart...", german="Sieht so aus, als seien wir\nirgendwo anders gelandet...", italian="Sembra che ci troviamo\nin un luogo diverso...", spanish="Parece como si hubiéramos\nacabado en otro lugar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It looks like we landed\nsomewhere else...", french="On dirait qu'on a atterri autre\npart...", german="Sieht so aus, als seien wir\nirgendwo anders gelandet...", italian="Sembra che ci troviamo\nin un luogo diverso...", spanish="Parece como si hubiéramos\nacabado en otro lugar..."})
  else
  SkySceneKit.say({english="It looks like we landed\nsomewhere else...", french="On dirait qu'on a atterri autre\npart...", german="Sieht so aus, als seien wir\nirgendwo anders gelandet...", italian="Sembra che ci troviamo\nin un luogo diverso...", spanish="Parece como si hubiéramos\nacabado en otro lugar..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But this is all such a shock![K]\nWho knew things would turn out this way?", french="Ça pour une surprise![K]\nQui aurait pu dire que les choses prendraient\nune telle tournure?", german="Aber das war echt ein Schock![K]\nWer hätte gedacht, dass die Dinge sich so\nentwickeln würden?", italian="Ma è tutto così sconvolgente![K]\nChi avrebbe pensato che le cose si sarebbero\nmesse in questo modo?", spanish="¡Menuda sorpresa![K] ¿Quién nos\niba a decir que pasaría esto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But this is all such a shock![K]\nWho knew things would turn out this way?", french="Ça pour une surprise![K]\nQui aurait pu dire que les choses prendraient\nune telle tournure?", german="Aber das war echt ein Schock![K]\nWer hätte gedacht, dass die Dinge sich so\nentwickeln würden?", italian="Ma è tutto così sconvolgente![K]\nChi avrebbe pensato che le cose si sarebbero\nmesse in questo modo?", spanish="¡Menuda sorpresa![K] ¿Quién nos\niba a decir que pasaría esto?"})
  else
  SkySceneKit.say({english="But this is all such a shock![K]\nWho knew things would turn out this way?", french="Ça pour une surprise![K]\nQui aurait pu dire que les choses prendraient\nune telle tournure?", german="Aber das war echt ein Schock![K]\nWer hätte gedacht, dass die Dinge sich so\nentwickeln würden?", italian="Ma è tutto così sconvolgente![K]\nChi avrebbe pensato che le cose si sarebbero\nmesse in questo modo?", spanish="¡Menuda sorpresa![K] ¿Quién nos\niba a decir que pasaría esto?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't understand...[K] Why did\n[CS:N]Palkia[CR] suddenly attack us?", french="Ça me dépasse...[K] Pourquoi\n[CS:N]Palkia[CR] s'en est-il pris à nous, tout à coup?", german="Ich verstehe das nicht...[K] Warum\nhat [CS:N]Palkia[CR] uns plötzlich angegriffen?", italian="Non capisco...[K] Perché\n[CS:N]Palkia[CR] ha attaccato così all'improvviso?", spanish="No lo entiendo...[K] ¿Por qué nos\natacó [CS:N]Palkia[CR] de repente?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't understand...[K] Why did\n[CS:N]Palkia[CR] suddenly attack us?", french="Ça me dépasse...[K] Pourquoi\n[CS:N]Palkia[CR] s'en est-il pris à nous, tout à coup?", german="Ich verstehe das nicht...[K] Warum\nhat [CS:N]Palkia[CR] uns plötzlich angegriffen?", italian="Non capisco...[K] Perché\n[CS:N]Palkia[CR] ha attaccato così all'improvviso?", spanish="No lo entiendo...[K] ¿Por qué nos\natacó [CS:N]Palkia[CR] de repente?"})
  else
  SkySceneKit.say({english="I don't understand...[K] Why did\n[CS:N]Palkia[CR] suddenly attack us?", french="Ça me dépasse...[K] Pourquoi\n[CS:N]Palkia[CR] s'en est-il pris à nous, tout à coup?", german="Ich verstehe das nicht...[K] Warum\nhat [CS:N]Palkia[CR] uns plötzlich angegriffen?", italian="Non capisco...[K] Perché\n[CS:N]Palkia[CR] ha attaccato così all'improvviso?", spanish="No lo entiendo...[K] ¿Por qué nos\natacó [CS:N]Palkia[CR] de repente?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="He seemed to be bellowing about\nthe distortion of space...", french="Il me semble qu'il a mentionné\nla distorsion de l'espace dans ses hurlements...", german="Es hat uns wohl wegen der\nVerzerrung des Raumes angebrüllt.", italian="Stava dicendo qualcosa a\nproposito della distorsione dello spazio...", spanish="Estaba bramando acerca de la\ndeformación del espacio..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="He seemed to be bellowing about\nthe distortion of space...", french="Il me semble qu'il a mentionné\nla distorsion de l'espace dans ses hurlements...", german="Es hat uns wohl wegen der\nVerzerrung des Raumes angebrüllt.", italian="Stava dicendo qualcosa a\nproposito della distorsione dello spazio...", spanish="Estaba bramando acerca de la\ndeformación del espacio..."})
  else
  SkySceneKit.say({english="He seemed to be bellowing about\nthe distortion of space...", french="Il me semble qu'il a mentionné\nla distorsion de l'espace dans ses hurlements...", german="Es hat uns wohl wegen der\nVerzerrung des Raumes angebrüllt.", italian="Stava dicendo qualcosa a\nproposito della distorsione dello spazio...", spanish="Estaba bramando acerca de la\ndeformación del espacio..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...[CS:N]Palkia[CR]...)", french="(... [CS:N]Palkia[CR]...)", german="(...[CS:N]Palkia[CR]...)", italian="([CS:N]Palkia[CR]...)", spanish="([CS:N]Palkia[CR]...)"})
  else
  SkySceneKit.say({english="(...[CS:N]Palkia[CR]...)", french="(... [CS:N]Palkia[CR]...)", german="(...[CS:N]Palkia[CR]...)", italian="([CS:N]Palkia[CR]...)", spanish="([CS:N]Palkia[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Palkia[CR] seemed to know that we caused\nthe distortion of space.)", french="(On aurait dit que [CS:N]Palkia[CR] savait qu'on est\nresponsables de la distorsion de l'espace.)", german="([CS:N]Palkia[CR] schien zu wissen, dass wir für\ndie Verzerrung des Raumes verantwortlich\nsind.)", italian="([CS:N]Palkia[CR] sembrava conoscere la causa\ndella distorsione dello spazio.)", spanish="([CS:N]Palkia[CR] parecía saber que estamos causando\nla deformación del espacio.)"})
  else
  SkySceneKit.say({english="([CS:N]Palkia[CR] seemed to know that we caused\nthe distortion of space.)", french="(On aurait dit que [CS:N]Palkia[CR] savait qu'on est\nresponsables de la distorsion de l'espace.)", german="([CS:N]Palkia[CR] schien zu wissen, dass wir für\ndie Verzerrung des Raumes verantwortlich\nsind.)", italian="([CS:N]Palkia[CR] sembrava conoscere la causa\ndella distorsione dello spazio.)", spanish="([CS:N]Palkia[CR] parecía saber que estamos causando\nla deformación del espacio.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And then he attacked us...)", french="(Ensuite, il est passé à l'attaque...)", german="(Und dann griff es uns an.)", italian="(E poi ci ha attaccato.)", spanish="(Y luego nos atacó...)"})
  else
  SkySceneKit.say({english="(And then he attacked us...)", french="(Ensuite, il est passé à l'attaque...)", german="(Und dann griff es uns an.)", italian="(E poi ci ha attaccato.)", spanish="(Y luego nos atacó...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But I don't understand why...)", french="(Mais je ne comprends pas pourquoi...)", german="(Aber ich verstehe nicht, warum...)", italian="(Ma non capisco perché.)", spanish="(Aunque no logro entender por qué...)"})
  else
  SkySceneKit.say({english="(But I don't understand why...)", french="(Mais je ne comprends pas pourquoi...)", german="(Aber ich verstehe nicht, warum...)", italian="(Ma non capisco perché.)", spanish="(Aunque no logro entender por qué...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's no mistaking one thing.\n[CS:N]Palkia[CR] is trying to get rid of us.", french="Une chose est sûre: [CS:N]Palkia[CR]\ncherche à se débarrasser de nous.", german="Eins ist jedoch sicher.\n[CS:N]Palkia[CR] versucht, uns loszuwerden.", italian="Una cosa è certa. [CS:N]Palkia[CR] vuole\nsbarazzarsi di noi.", spanish="Una cosa es segura, [CS:N]Palkia[CR]\nnos quiere quitar de en medio."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's no mistaking one thing.\n[CS:N]Palkia[CR] is trying to get rid of us.", french="Une chose est sûre: [CS:N]Palkia[CR]\ncherche à se débarrasser de nous.", german="Eins ist jedoch sicher.\n[CS:N]Palkia[CR] versucht, uns loszuwerden.", italian="Una cosa è certa. [CS:N]Palkia[CR] vuole\nsbarazzarsi di noi.", spanish="Una cosa es segura, [CS:N]Palkia[CR]\nnos quiere quitar de en medio."})
  else
  SkySceneKit.say({english="There's no mistaking one thing.\n[CS:N]Palkia[CR] is trying to get rid of us.", french="Une chose est sûre: [CS:N]Palkia[CR]\ncherche à se débarrasser de nous.", german="Eins ist jedoch sicher.\n[CS:N]Palkia[CR] versucht, uns loszuwerden.", italian="Una cosa è certa. [CS:N]Palkia[CR] vuole\nsbarazzarsi di noi.", spanish="Una cosa es segura, [CS:N]Palkia[CR]\nnos quiere quitar de en medio."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="He might attempt another\nattack...[K] We should get out of here as soon as\nwe can.", french="Il risque de revenir à\nla charge...[K] On ferait mieux de sortir d'ici\nau plus vite.", german="Vielleicht plant es einen neuen\nAngriff...[K] Wir sollten so schnell wie möglich\nvon hier verschwinden.", italian="Potrebbe provare ad attaccare\ndi nuovo...[K] Dovremmo andarcene di qui il\nprima possibile.", spanish="Podría atacarnos de nuevo...[K]\nDeberíamos marcharnos de aquí cuanto\nantes..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="He might attempt another\nattack...[K] We should get out of here as soon as\nwe can.", french="Il risque de revenir à\nla charge...[K] On ferait mieux de sortir d'ici\nau plus vite.", german="Vielleicht plant es einen neuen\nAngriff...[K] Wir sollten so schnell wie möglich\nvon hier verschwinden.", italian="Potrebbe provare ad attaccare\ndi nuovo...[K] Dovremmo andarcene di qui il\nprima possibile.", spanish="Podría atacarnos de nuevo...[K]\nDeberíamos marcharnos de aquí cuanto\nantes..."})
  else
  SkySceneKit.say({english="He might attempt another\nattack...[K] We should get out of here as soon as\nwe can.", french="Il risque de revenir à\nla charge...[K] On ferait mieux de sortir d'ici\nau plus vite.", german="Vielleicht plant es einen neuen\nAngriff...[K] Wir sollten so schnell wie möglich\nvon hier verschwinden.", italian="Potrebbe provare ad attaccare\ndi nuovo...[K] Dovremmo andarcene di qui il\nprima possibile.", spanish="Podría atacarnos de nuevo...[K]\nDeberíamos marcharnos de aquí cuanto\nantes..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We need to roll as soon as we're\nready, [hero].", french="Partons dès que possible,\n[hero].", german="Wir müssen schnellstmöglich in\ndie Gänge kommen, [hero].", italian="Dobbiamo partire non appena\ntutto sarà pronto, [hero].", spanish="Nos iremos en cuanto me lo\nindiques, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go as soon as we're ready,\n[hero].", french="Partons dès que possible,\n[hero].", german="Lass uns so bald wie möglich\ngehen, [hero].", italian="Dobbiamo partire non appena\ntutto sarà pronto, [hero].", spanish="Nos iremos en cuanto me lo\nindiques, [hero]."})
  else
  SkySceneKit.say({english="Let's go as soon as we're ready,\n[hero].", french="Partons dès que possible,\n[hero].", german="Lass uns so bald wie möglich\ngehen, [hero].", italian="Dobbiamo partire non appena\ntutto sarà pronto, [hero].", spanish="Nos iremos en cuanto me lo\nindiques, [hero]."})
  end
  -- message_Close
  SkySceneKit.join_routines()
end
