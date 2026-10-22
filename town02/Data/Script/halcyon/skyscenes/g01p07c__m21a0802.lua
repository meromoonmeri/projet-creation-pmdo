-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m21a0802.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
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
  GAME:FadeIn(60)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sigh... Things aren't going as\nwell as we'd hoped.", french="Pff... les choses ne se passent\npas aussi bien que je l'avais espéré.", german="Seufz! Die Dinge laufen nicht so,\nwie wir gehofft hatten.", italian="Sigh... Le cose non stanno\nandando bene come speravamo.", spanish="Ay... Las cosas no van tan bien\ncomo esperábamos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sigh... We're not making as much\nprogress as we'd hoped.", french="Pff... les choses ne se passent\npas aussi bien que je l'avais espéré.", german="Seufz! Wir kommen nicht so\nvoran, wie wir gehofft hatten.", italian="Sigh... Non stiamo facendo tutti\ni progressi che speravamo di fare.", spanish="Ay... No estamos avanzando tanto\ncomo esperábamos."})
  else
  SkySceneKit.say({english="Sigh... Things aren't going as\nwell as we'd hoped.", french="Pff... les choses ne se passent\npas aussi bien que je l'avais espéré.", german="Seufz! Die Dinge laufen nicht so,\nwie wir gehofft hatten.", italian="Sigh... Le cose non stanno\nandando bene come speravamo.", spanish="Ay... Las cosas no van tan bien\ncomo esperábamos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When we talked with [CS:N]Torkoal[CR],\nI thought there was hope!", french="Quand on est allés voir [CS:N]Chartor[CR],\nje pensais qu'il y avait de l'espoir!", german="Als wir mit [CS:N]Qurtel[CR] sprachen,\ndachte ich, es gäbe noch Hoffnung!", italian="Mentre parlavamo con [CS:N]Torkoal[CR],\npensavo ci fossero delle speranze!", spanish="Cuando hablamos con [CS:N]Torkoal[CR],\n¡creía que había alguna esperanza!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When we talked with [CS:N]Torkoal[CR],\nI started thinking we had a hope!", french="Quand on est allés voir [CS:N]Chartor[CR],\nje pensais qu'il y avait de l'espoir!", german="Als wir mit [CS:N]Qurtel[CR] sprachen,\ndachte ich, es gäbe noch Hoffnung!", italian="Mentre parlavamo con [CS:N]Torkoal[CR],\nho cominciato a pensare che avessimo qualche\nsperanza!", spanish="Cuando hablamos con [CS:N]Torkoal[CR],\n¡creía que había alguna esperanza!"})
  else
  SkySceneKit.say({english="When we talked with [CS:N]Torkoal[CR],\nI thought we had a hope!", french="Quand on a rendu visite\nà [CS:N]Chartor[CR], je pensais qu'il y avait\nde l'espoir!", german="Als wir mit [CS:N]Qurtel[CR] sprachen,\ndachte ich, es gäbe noch Hoffnung!", italian="Mentre parlavamo con [CS:N]Torkoal[CR],\npensavo che avessimo qualche speranza!", spanish="Cuando hablamos con [CS:N]Torkoal[CR],\n¡creía que había alguna esperanza!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I wonder how [CS:N]Grovyle[CR] is doing?", french="Je me demande où en est\n[CS:N]Massko[CR].", german="Ich wüsste gerne, wie es\n[CS:N]Reptain[CR] ergeht!", italian="Mi chiedo come se la stia\ncavando [CS:N]Grovyle[CR]...", spanish="Me pregunto cómo le irá a\n[CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I wonder how [CS:N]Grovyle[CR] is doing?", french="Je me demande où en est\n[CS:N]Massko[CR].", german="Ich wüsste gerne, wie es\n[CS:N]Reptain[CR] ergeht!", italian="Mi chiedo come se la stia\ncavando [CS:N]Grovyle[CR]...", spanish="Me pregunto cómo le irá a\n[CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english=" I wonder how [CS:N]Grovyle[CR] is doing?", french="Je me demande où en est\n[CS:N]Massko[CR].", german="Ich wüsste gerne, wie es\n[CS:N]Reptain[CR] ergeht!", italian="Mi chiedo come se la stia\ncavando [CS:N]Grovyle[CR]...", spanish="Me pregunto cómo le irá a\n[CS:N]Grovyle[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Has he gathered the Time Gears?", french="Est-ce qu'il a réussi à réunir\ntous les Rouages du Temps?", german="Ob er die Zahnräder der Zeit\neingesammelt hat?", italian="Avrà trovato gli Ingranaggi del\nTempo?", spanish="¿Habrá recogido los Engranajes\ndel Tiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Has he gathered the Time Gears?", french="Est-ce qu'il a réussi à réunir\ntous les Rouages du Temps?", german="Ob er die Zahnräder der Zeit\neingesammelt hat?", italian="Avrà trovato gli Ingranaggi del\nTempo?", spanish="¿Habrá conseguido los\nEngranajes del Tiempo?"})
  else
  SkySceneKit.say({english=" Has he gathered the Time Gears?", french="Est-ce qu'il a réussi à réunir\ntous les Rouages du Temps?", german="Ob er die Zahnräder der Zeit\neingesammelt hat?", italian="Avrà trovato gli Ingranaggi del\nTempo?", spanish="¿Habrá reunido los Engranajes\ndel Tiempo?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We have to hurry too!", french=" On doit faire vite, nous aussi!", german=" Auch wir müssen uns beeilen!", italian=" Dobbiamo sbrigarci anche noi!", spanish="Nosotros también tenemos que\ndarnos prisa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We need to hurry too!", french=" On doit faire vite, nous aussi!", german=" Auch wir müssen uns beeilen!", italian=" Dobbiamo sbrigarci anche noi!", spanish="Nosotros también tenemos que\ndarnos prisa."})
  else
  SkySceneKit.say({english=" We have to hurry too!", french=" On doit faire vite, nous aussi!", german=" Auch wir müssen uns beeilen!", italian=" Dobbiamo sbrigarci anche noi!", spanish="Por nuestra parte, también\ntendremos que darnos prisa."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But there's no point in getting\nall flustered.", french="Mais c'est inutile de se mettre\ndans tous ses états.", german="Aber es gibt keinen Grund, uns\nnervös zu machen.", italian="Ma non dobbiamo farci prendere\ndall'agitazione.", spanish="Pero no tiene sentido perder\nla calma innecesariamente."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But there's no point in getting\nall flustered.", french="Mais c'est inutile de se mettre\ndans tous ses états.", german="Aber es gibt keinen Grund, uns\nnervös zu machen.", italian="Ma non dobbiamo farci prendere\ndall'agitazione.", spanish="Pero no tiene sentido perder\nla calma innecesariamente."})
  else
  SkySceneKit.say({english="But there's no point in getting\nall worked up.", french="Mais c'est inutile de se mettre\ndans tous ses états.", german="Aber es gibt keinen Grund, uns\nnervös zu machen.", italian="Ma non dobbiamo farci prendere\ndall'agitazione.", spanish="Pero no tiene sentido perder\nla calma innecesariamente."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Especially since everyone is\nhelping out.", french="Surtout que tout le monde met\nla main à la pâte.", german="Besonders, da jetzt alle\nmithelfen.", italian="Specialmente dal momento che\nci stanno aiutando tutti.", spanish="Sobre todo cuando todos están\ncolaborando tanto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Especially since everyone is\nhelping out.", french="Surtout que tout le monde met\nla main à la pâte.", german="Besonders, da jetzt alle\nmithelfen.", italian="Specialmente dal momento che\nci stanno aiutando tutti.", spanish="Sobre todo cuando todos están\ncolaborando tanto."})
  else
  SkySceneKit.say({english="Especially since everyone is\nhelping out.", french="Surtout que tout le monde met\nla main à la pâte.", german="Besonders, da jetzt alle\nmithelfen.", italian="Specialmente dal momento che\nci stanno aiutando tutti.", spanish="Sobre todo cuando todos están\ncolaborando tanto."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We should get some sleep...[K]\nthen start with fresh resolve tomorrow!", french="Dormons un peu...[K] et repartons\ndu bon pied demain matin!", german="Wir sollten ein bisschen\nschlafen...[K] Und morgen mit frischem Mut\nweitermachen!", italian="Dovremmo riposarci un po'...[K]\nDomani riprenderemo più freschi e decisi!", spanish="Ahora deberíamos dormir...[K]\n¡Y empezar mañana con la cabeza despejada!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should get some sleep...[K]\nthen start with fresh resolve tomorrow!", french="Dormons un peu...[K] et repartons\ndu bon pied demain matin!", german="Wir sollten ein bisschen\nschlafen...[K] Und morgen mit frischem Mut\nweitermachen!", italian="Dovremmo riposarci un po'...[K]\nDomani riprenderemo più freschi e decisi!", spanish="Ahora deberíamos dormir...[K]\n¡Y empezar mañana con la cabeza despejada!"})
  else
  SkySceneKit.say({english="We should get some sleep...[K]\nthen start a fresh effort tomorrow!", french="Dormons un peu...[K] et repartons\ndu bon pied demain matin!", german="Wir sollten ein bisschen\nschlafen...[K] Und morgen mit frischem Mut\nweitermachen!", italian="Dovremmo riposarci un po'...[K]\nDomani ci sentiremo di nuovo in forma per\ncontinuare!", spanish="Ahora deberíamos dormir...[K]\n¡Y empezar mañana con la cabeza despejada!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right, [hero].\nGood night.", french="Allez, [hero].\nBonne nuit.", german="Alles klar, [hero]. Gute\nNacht.", italian="Va bene, [hero].\nBuona notte.", spanish="Muy bien, [hero].\nBuenas noches."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, [hero]. Good night.", french="Allez, [hero].\nBonne nuit.", german=" Okay, [hero]. Gute Nacht.", italian=" Ok, [hero]. Buona notte.", spanish="Muy bien, [hero].\nBuenas noches."})
  else
  SkySceneKit.say({english=" OK, [hero]. Good night.", french="Allez, [hero].\nBonne nuit.", german=" Okay, [hero]. Gute Nacht.", italian=" Ok, [hero]. Buona notte.", spanish="Muy bien, [hero].\nBuenas noches."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkyProg.set(23, 0) -- $SCENARIO_MAIN = scn[23,0] (ROM)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
