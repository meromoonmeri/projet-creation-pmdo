-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/m15a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(24, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(16, 2) -- $SCENARIO_MAIN = scn[16,2] (ROM)
  -- back_SetGround(LEVEL_D16P31A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 284, 372, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 316, 372, false, 2)
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 292, 412, false, 2) end end
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 320, 412, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is this...[K]the deepest part of the\ncaverns?", french="Est-ce que c'est...[K] le fond\nde la caverne?", german="Ist das[K] der tiefste Punkt der\nHöhle?", italian=" Siamo...[K] arrivati in fondo?", spanish="¿Esto es...?[K] ¿Hemos llegado ya\na la parte más profunda de la cueva?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is this...[K]the deepest part of\nthe caverns?", french="Est-ce que c'est...[K] le fond\nde la caverne?", german="Ist das[K] der tiefste Punkt der\nHöhle?", italian=" Siamo...[K] arrivati in fondo?", spanish="¿Esto es...?[K] ¿Hemos llegado ya\na la parte más profunda de la cueva?"})
  else
  SkySceneKit.say({english="Is this...[K]the deepest part of\nthe caverns?", french="Est-ce que c'est...[K] le fond\nde la caverne?", german="Ist das[K] der tiefste Punkt der\nHöhle?", italian="Da qui...[K] non si può più\nproseguire?", spanish="¿Esto es...?[K] ¿Hemos llegado ya\na la parte más profunda de la cueva?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero]! Over there!", french=" Regarde, [hero]! Là-bas!", german=" Hey, [hero]! Da!", italian=" Ehi, [hero]! Guarda!", spanish=" ¡Mira allí, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [hero]! Over there!", french=" Regarde, [hero]! Là-bas!", german=" Hey, [hero]! Da!", italian=" Ehi, [hero]! Guarda!", spanish=" ¡Mira allí, [hero]!"})
  else
  SkySceneKit.say({english=" Oh, [hero]! Over there!", french=" Regarde, [hero]! Là-bas!", german=" Hey, [hero]! Da!", italian=" Ehi, [hero]! Guarda!", spanish=" ¡Mira allí, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 284, 228, false, 2)
  pcall(function() GAME:MoveCamera(300, 228, 60, false) end) -- performer/caméra
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 316, 228, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 292, 292, false, 2) end end
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 324, 292, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Check out these three giant\ncrystals!", french="Regarde un peu ces trois\ncristaux! Ils sont énormes!", german="Sieh dir die drei riesigen\nKristalle an!", italian=" Questi cristalli sono giganteschi!", spanish=" Fíjate en esos cristales gigantes."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Look at these three crystals!\nThey're huge!", french="Regarde un peu ces trois\ncristaux! Ils sont énormes!", german="Sieh dir die drei Kristalle an!\nDie sind ja riesig!", italian=" Questi cristalli sono giganteschi!", spanish="Mira esos cristales gigantes.\n¡Son enormes!"})
  else
  SkySceneKit.say({english="Look at these three giant\ncrystals!", french="Regarde un peu ces trois\ncristaux! Ils sont énormes!", german="Sieh dir die drei riesigen\nKristalle an!", italian=" Questi cristalli sono giganteschi!", spanish=" Mira esos cristales gigantes."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" They're in different colors too.", french="Et ils sont de couleurs\ndifférentes.", german="Sie haben unterschiedliche\nFarben.", italian=" E ognuno è di un diverso colore.", spanish=" Cada uno es de un color."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" They're in different colors too.", french="Et ils sont de couleurs\ndifférentes.", german="Sie haben unterschiedliche\nFarben.", italian=" E ognuno è di un diverso colore.", spanish=" Cada uno es de un color."})
  else
  SkySceneKit.say({english=" They're in different colors too.", french="Et ils sont de couleurs\ndifférentes.", german="Sie haben unterschiedliche\nFarben.", italian=" E ognuno è di un diverso colore.", spanish=" Cada uno es de un color."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They obviously stand out from\nthe other crystals.", french="Aucun doute, ils se distinguent\ndes autres cristaux.", german="Das sind offensichtlich\nbesondere Kristalle.", italian="Sono davvero differenti da tutti\ngli altri cristalli.", spanish="Destacan claramente entre\nlos demás cristales."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Clearly, they stand out from\nthe other crystals.", french="Aucun doute, ils se distinguent\ndes autres cristaux.", german="Das sind eindeutig besondere\nKristalle.", italian="Sono davvero differenti da tutti\ngli altri cristalli.", spanish="Destacan claramente entre\nlos demás cristales."})
  else
  SkySceneKit.say({english="It's obvious that they're not\nlike any of the other crystals.", french="Aucun doute, ils se distinguent\ndes autres cristaux.", german="Das sind offenbar ganz\nbesondere Kristalle.", italian="Sono davvero differenti da tutti\ngli altri cristalli.", spanish="Destacan claramente entre\nlos demás cristales."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="On the way here, we didn't see\nanything out of the ordinary...", french="En venant ici, on n'a rien vu qui\nsortait de l'ordinaire...", german="Auf dem Weg hierher haben wir\nnichts Außergewöhnliches gesehen.", italian="Lungo la strada che abbiamo\npercorso per arrivare fino a qui, non\nabbiamo visto niente di strano...", spanish="En todo el trayecto no hemos\nvisto nada fuera de lo normal."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="On the way here, we didn't see\nanything out of the ordinary...", french="En venant ici, on n'a rien vu qui\nsortait de l'ordinaire...", german="Auf dem Weg hierher haben wir\nnichts Außergewöhnliches gesehen.", italian="Lungo la strada che abbiamo\npercorso per arrivare fino a qui, non\nabbiamo visto niente di strano...", spanish="En todo el trayecto no hemos\nvisto nada fuera de lo normal."})
  else
  SkySceneKit.say({english="On the way here, we didn't see\nanything out of the ordinary...", french="En venant ici, on n'a rien vu qui\nsortait de l'ordinaire...", german="Auf dem Weg hierher haben wir\nnichts Außergewöhnliches gesehen.", italian="Lungo la strada che abbiamo\npercorso per arrivare fino a qui, non\nabbiamo visto niente di strano...", spanish="En todo el trayecto no hemos\nvisto nada fuera de lo normal."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So I think these three crystals\nare the key, [hero]!", french="J'ai bien l'impression que la clé\ndu mystère réside dans ces trois cristaux,\n[hero]!", german="Also müssten diese drei\nKristalle der Schlüssel sein, [hero]!", italian="La soluzione del mistero\ndev'essere in questi tre cristalli, [hero]!", spanish="Así que creo que estos tres\ncristales han de ser la clave, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So I think these three crystals\nare clues, [hero]!", french="J'ai bien l'impression que la clé\ndu mystère réside dans ces trois cristaux,\n[hero]!", german="Also sind diese drei Kristalle\nbestimmt ein Hinweis, [hero]!", italian="La soluzione del mistero\ndev'essere in questi tre cristalli, [hero]!", spanish="Así que creo que estos tres\ncristales han de ser la clave, [hero]."})
  else
  SkySceneKit.say({english="So these three crystals must be\nclues, [hero]!", french="J'ai bien l'impression que la clé\ndu mystère réside dans ces trois cristaux,\n[hero]!", german="Also sind diese drei Kristalle\nsicher ein Hinweis, [hero]!", italian="La soluzione del mistero\ndev'essere in questi tre cristalli, [hero]!", spanish="Así que creo que estos tres\ncristales han de ser la clave, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I bet they hold the secret!", french=" Ils doivent cacher un secret!", german="Wetten, dass sie irgendein\nGeheimnis bergen?", italian="Sono sicuro che il segreto è\nproprio qui!", spanish=" ¡Sé que ocultan algún secreto!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" They must be keeping a secret!", french=" Ils doivent cacher un secret!", german="Sie bergen sicher irgendein\nGeheimnis!", italian="Sono sicuro che il segreto è\nproprio qui!", spanish=" ¡Sé que ocultan algún secreto!"})
  else
  SkySceneKit.say({english=" They must be keeping a secret!", french=" Ils doivent cacher un secret!", german="Sie bergen sicher irgendein\nGeheimnis!", italian="Sono sicura che il segreto è\nproprio qui!", spanish=" ¡Sé que ocultan algún secreto!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It makes sense!)", french="(Ça expliquerait tout!)", german="(Das klingt logisch!)", italian="(Forse ha ragione!)", spanish="(¡Tiene sentido!)"})
  else
  SkySceneKit.say({english="(It makes sense!)", french="(Ça expliquerait tout!)", german="(Das klingt logisch!)", italian="(Forse ha ragione!)", spanish="(¡Tiene sentido!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I feel the same way!)", french="(J'ai la même impression!)", german="(Ich habe dasselbe Gefühl!)", italian="(Anch'io la penso così!)", spanish="(Yo tengo la misma impresión.)"})
  else
  SkySceneKit.say({english="(I feel the same way!)", french="(J'ai la même impression!)", german="(Ich habe dasselbe Gefühl!)", italian="(Anch'io la penso così!)", spanish="(Yo tengo la misma impresión.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(On the journey to [CS:P]Fogbound Lake[CR], where we\nmet [CS:N]Uxie[CR]...)", french="(Pendant l'expédition au [CS:P]Lac des Brumes[CR],\noù on a rencontré [CS:N]Créhelf[CR]...)", german="(Auf der Reise zum [CS:P]Nebelsee[CR], wo wir [CS:N]Selfe[CR]\ntrafen...)", italian="(Nella nostra avventura al [CS:P]Lago Foschia[CR], dove\nabbiamo incontrato [CS:N]Uxie[CR]...)", spanish="(Cuando fuimos al [CS:P]Lago Velado[CR], antes de\nllegar hasta [CS:N]Uxie[CR]...)"})
  else
  SkySceneKit.say({english="(On the journey to [CS:P]Fogbound Lake[CR], where we\nmet [CS:N]Uxie[CR]...)", french="(Pendant l'expédition au [CS:P]Lac des Brumes[CR],\noù on a rencontré [CS:N]Créhelf[CR]...)", german="(Auf der Reise zum [CS:P]Nebelsee[CR], wo wir [CS:N]Selfe[CR]\ntrafen...)", italian="(Nella nostra avventura al [CS:P]Lago Foschia[CR], dove\nabbiamo incontrato [CS:N]Uxie[CR]...)", spanish="(Cuando fuimos al [CS:P]Lago Velado[CR], antes de\nllegar hasta [CS:N]Uxie[CR]...)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
end
