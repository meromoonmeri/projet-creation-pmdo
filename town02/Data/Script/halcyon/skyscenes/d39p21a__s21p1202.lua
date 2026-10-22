-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P21A/s21p1202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D39P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sealed Ruin.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] This is so harsh...", french=" Argh...[K] Ce que c'est difficile...", german=" Uff...[K] Das ist heftig...", italian=" Uff...[K] È davvero dura...", spanish=" Uf...[K] Está siendo duro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] This is challenging...", french=" Argh...[K] Ce que c'est difficile...", german="Ugh...[K] Das ist eine ganz schöne\nHerausforderung...", italian=" Uff...[K] È davvero impegnativo...", spanish=" Uf...[K] Esto es todo un reto..."})
  else
  SkySceneKit.say({english=" Ugh...[K] This is so rough...", french=" Argh...[K] Ce que c'est difficile...", german=" Uff...[K] Das ist so grob...", italian=" Uff...[K] È davvero dura...", spanish=" Uf...[K] Esto es todo un reto..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This all led to a dead end too...", french=" C'est un cul-de-sac ici aussi...", german="Das alles hier hat auch in eine\nSackgasse geführt...", italian="Questo dungeon porta a\nun vicolo cieco...", spanish="Estamos en un callejón sin\nsalida..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This dungeon comes out at a\ndead end too...", french=" C'est un cul-de-sac ici aussi...", german="Dieser Dungeon erweist sich\nauch als Sackgasse...", italian="Questo dungeon porta a\nun vicolo cieco...", spanish="Estamos en un callejón sin\nsalida..."})
  else
  SkySceneKit.say({english="This dungeon led to a\ndead end too...", french=" C'est un cul-de-sac ici aussi...", german="Dieser Dungeon hat uns auch in\neine Sackgasse geführt...", italian="Questo dungeon porta a\nun vicolo cieco...", spanish="Estamos en un callejón sin\nsalida..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't think there's anywhere\nelse we can run to...", french="Je crois bien qu'on n'a nulle part\noù se réfugier...", german="Ich glaube, jetzt gibt es keinen\nAusweg mehr...", italian="Mi sembra che non si possa\nandare da nessun'altra parte...", spanish="No hay ningún sitio por donde\nescapar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I think we're out of places\nwhere we can escape...", french="Je crois bien qu'on n'a nulle part\noù se réfugier...", german="Ich glaube, uns sind die\nFluchtmöglichkeiten ausgegangen...", italian="Mi sembra che non si possa\nandare da nessun'altra parte...", spanish="No hay ningún sitio por donde\nescapar..."})
  else
  SkySceneKit.say({english="There's nowhere left we can\nrun to...", french="Je crois bien qu'on n'a nulle part\noù se réfugier...", german="Ich glaube, jetzt gibt es keinen\nAusweg mehr...", italian="Mi sembra che non si possa\nandare da nessun'altra parte...", spanish="No hay ningún sitio por donde\nescapar..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...[K]That means...)", french="(...[K] Ce qui veut dire...)", german="(...[K]Das bedeutet...)", italian="(...[K] Ciò significa...)", spanish="(Lo que...[K] Lo que significa que...)"})
  else
  SkySceneKit.say({english="(...[K]That means...)", french="(...[K] Ce qui veut dire...)", german="(...[K]Das bedeutet...)", italian="(...[K] Ciò significa...)", spanish="(Lo que...[K] Lo que significa que...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's only one possible solution left.)", french="(... qu'il ne nous reste qu'une seule solution.)", german="(Es ist nur noch eine mögliche Lösung übrig.)", italian="(Ci rimane un'unica soluzione.)", spanish="(Solo hay una solución posible.)"})
  else
  SkySceneKit.say({english="(There's only one possible solution left.)", french="(... qu'il ne nous reste qu'une seule solution.)", german="(Es ist nur noch eine mögliche Lösung übrig.)", italian="(Ci rimane un'unica soluzione.)", spanish="(Solo hay una solución posible.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We must ask [CS:N]Palkia[CR] how we can get out.)", french="(Il faut qu'on aille demander à [CS:N]Palkia[CR] comment\nsortir d'ici.)", german="(Wir müssen [CS:N]Palkia[CR] fragen, wie wir hier\nherauskommen.)", italian="(Dobbiamo chiedere a [CS:N]Palkia[CR] come uscire.)", spanish="(Hay que preguntarle a [CS:N]Palkia[CR] cómo se sale\nde aquí.)"})
  else
  SkySceneKit.say({english="(We must ask [CS:N]Palkia[CR] how we can get out.)", french="(Il faut qu'on aille demander à [CS:N]Palkia[CR] comment\nsortir d'ici.)", german="(Wir müssen [CS:N]Palkia[CR] fragen, wie wir hier\nherauskommen.)", italian="(Dobbiamo chiedere a [CS:N]Palkia[CR] come uscire.)", spanish="(Hay que preguntarle a [CS:N]Palkia[CR] cómo se sale\nde aquí.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But, to do so...)", french="(Mais pour ce faire...)", german="(Aber um das zu tun...)", italian="(Ma per farlo...)", spanish="(Pero para eso...)"})
  else
  SkySceneKit.say({english="(But, to do so...)", french="(Mais pour ce faire...)", german="(Aber um das zu tun...)", italian="(Ma per farlo...)", spanish="(Pero para eso...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We must defeat [CS:N]Palkia[CR]!)", french="(... on doit d'abord le vaincre!)", german="(Damit dies gelingt, müssen wir [CS:N]Palkia[CR]\nbesiegen!)", italian="(... dobbiamo sconfiggere [CS:N]Palkia[CR]!)", spanish="(¡Tendremos que derrotarlo primero!)"})
  else
  SkySceneKit.say({english="(We must defeat [CS:N]Palkia[CR]!)", french="(... on doit d'abord le vaincre!)", german="(Damit dies gelingt, müssen wir [CS:N]Palkia[CR]\nbesiegen!)", italian="(... dobbiamo sconfiggere [CS:N]Palkia[CR]!)", spanish="(¡Tendremos que derrotarlo primero!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...[hero], I bet that you've\ncome to the same conclusion I have.", french="... [hero], je parie que\ntu as abouti à la même conclusion que moi.", german="...[hero], ich wette,\ndu bist zum gleichen Entschluss gekommen\nwie ich.", italian="... [hero], scommetto che\nstiamo pensando la stessa cosa.", spanish="Esto... [hero], creo que\nhemos llegado a la misma conclusión."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...[hero], I bet that you've\ncome to the same conclusion I have.", french="... [hero], je parie que\ntu as abouti à la même conclusion que moi.", german="...[hero], ich wette,\ndu bist zum gleichen Entschluss gekommen\nwie ich.", italian="... [hero], scommetto che\nstiamo pensando la stessa cosa.", spanish="Esto... [hero], creo que\nhemos llegado a la misma conclusión."})
  else
  SkySceneKit.say({english="...[hero], I bet that you've\ncome to the same conclusion I have.", french="... [hero], je parie que\ntu as abouti à la même conclusion que moi.", german="...[hero], ich wette,\ndu bist zum gleichen Entschluss gekommen\nwie ich.", italian="... [hero], scommetto che\nstiamo pensando la stessa cosa.", spanish="Esto... [hero], creo que\nhemos llegado a la misma conclusión."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We need to confront [CS:N]Palkia[CR] and\nask him.", french="On doit affronter [CS:N]Palkia[CR]\npour l'interroger.", german="Wir müssen [CS:N]Palkia[CR]\ngegenübertreten und es fragen.", italian="Dobbiamo affrontare [CS:N]Palkia[CR] e\nchiedere a lui.", spanish="Tenemos que enfrentarnos a\n[CS:N]Palkia[CR] y preguntarle."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We need to confront [CS:N]Palkia[CR] and\nask him.", french="On doit affronter [CS:N]Palkia[CR]\npour l'interroger.", german="Wir müssen [CS:N]Palkia[CR]\ngegenübertreten und es fragen.", italian="Dobbiamo affrontare [CS:N]Palkia[CR] e\nchiedere a lui.", spanish="Tenemos que enfrentarnos a\n[CS:N]Palkia[CR] y preguntarle."})
  else
  SkySceneKit.say({english="We need to confront [CS:N]Palkia[CR] and\nask him.", french="On doit affronter [CS:N]Palkia[CR]\npour l'interroger.", german="Wir müssen [CS:N]Palkia[CR]\ngegenübertreten und es fragen.", italian="Dobbiamo affrontare [CS:N]Palkia[CR] e\nchiedere a lui.", spanish="Tenemos que enfrentarnos a\n[CS:N]Palkia[CR] y preguntarle."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We really have to find a way\nout of here!", french="Il faut absolument qu'on trouve\nun moyen de sortir d'ici!", german="Wir müssen unbedingt einen Weg\nhier heraus finden!", italian="Dobbiamo trovare un modo per\nuscire da qui!", spanish=" ¡Hay que encontrar una salida!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We really have to find a way\nout of here!", french="Il faut absolument qu'on trouve\nun moyen de sortir d'ici!", german="Wir müssen unbedingt einen Weg\nhier heraus finden!", italian="Dobbiamo trovare un modo per\nuscire da qui!", spanish=" ¡Hay que encontrar una salida!"})
  else
  SkySceneKit.say({english="We really have to find a way\nout of here!", french="Il faut absolument qu'on trouve\nun moyen de sortir d'ici!", german="Wir müssen unbedingt einen Weg\nhier heraus finden!", italian="Dobbiamo trovare un modo per\nuscire da qui!", spanish=" ¡Hay que encontrar una salida!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And we have to find out why\nhe keeps attacking us.", french="Et il faut aussi qu'on découvre\npourquoi il n'arrête pas de nous attaquer.", german="Und wir müssen herausfinden,\nwarum es uns angreift.", italian="E dobbiamo scoprire perché\ncontinua ad attaccarci.", spanish="Además, tenemos que averiguar\npor qué nos ataca."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And we have to find out why\nhe keeps attacking us.", french="Et il faut aussi qu'on découvre\npourquoi il n'arrête pas de nous attaquer.", german="Und wir müssen herausfinden,\nwarum es uns angreift.", italian="E dobbiamo scoprire perché\ncontinua ad attaccarci.", spanish="Además, tenemos que averiguar\npor qué nos ataca."})
  else
  SkySceneKit.say({english="And we have to find out why\nhe keeps attacking us.", french="Et il faut aussi qu'on découvre\npourquoi il n'arrête pas de nous attaquer.", german="Und wir müssen herausfinden,\nwarum es uns angreift.", italian="E dobbiamo scoprire perché\ncontinua ad attaccarci.", spanish="Además, tenemos que averiguar\npor qué nos ataca."})
  end
  -- message_Close
end
