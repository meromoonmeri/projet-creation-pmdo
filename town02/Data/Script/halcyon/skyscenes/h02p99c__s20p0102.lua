-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/s20p0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It sounds like a storm is coming.", french=" On dirait qu'un orage se prépare.", german="Hört sich an, als ob sich ein\nSturm zusammenbraut.", italian="Dal rumore si direbbe che sta\nper arrivare una tempesta.", spanish=" Parece que va a haber tormenta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It sounds like a storm is coming.", french=" On dirait qu'un orage se prépare.", german="Klingt, als würde sich da ein\nSturm zusammenbrauen.", italian="Dal rumore si direbbe che sta\nper arrivare una tempesta.", spanish=" Parece que va a haber tormenta."})
  else
  SkySceneKit.say({english=" It sounds like a storm is coming.", french=" On dirait qu'un orage se prépare.", german="Klingt, als würde sich da ein\nSturm zusammenbrauen.", italian="Dal rumore si direbbe che sta\nper arrivare una tempesta.", spanish=" Parece que va a haber tormenta."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There hasn't been a storm in a\nlong time.", french="Ça fait longtemps qu'il n'y en a\npas eu.", german="Es hat lange keinen Sturm mehr\ngegeben.", italian=" È da tanto che non ce n'è una.", spanish="Ha pasado mucho tiempo desde\nla última tormenta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's been a long time since the\nlast storm.", french="Ça fait longtemps qu'il n'y en a\npas eu.", german=" Der letzte Sturm ist lange her.", italian=" È da tanto che non ce n'è una.", spanish="Ha pasado mucho tiempo desde\nla última tormenta."})
  else
  SkySceneKit.say({english="There hasn't been a storm in a\nlong time.", french="Ça fait longtemps qu'il n'y en a\npas eu.", german="Es hat lange keinen Sturm mehr\ngegeben.", italian=" È da tanto che non ce n'è una.", spanish="Ha pasado mucho tiempo desde\nla última tormenta."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's been quiet for a good\nwhile now.", french="Tout est plutôt calme depuis\nquelque temps.", german="Es ist bereits seit einer ganzen\nWeile ruhig.", italian=" C'è bel tempo da un bel po'.", spanish="Últimamente todo ha estado\nmuy tranquilo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's been quiet for a good\nwhile now.", french="Tout est plutôt calme depuis\nquelque temps.", german="Es ist bereits seit einer ganzen\nWeile ruhig.", italian=" C'è bel tempo da un bel po'.", spanish="Últimamente todo ha estado\nmuy tranquilo."})
  else
  SkySceneKit.say({english="It's been quiet for a good\nwhile now.", french="Tout est plutôt calme depuis\nquelque temps.", german="Es ist bereits seit einer ganzen\nWeile ruhig.", italian=" C'è bel tempo da un bel po'.", spanish="Últimamente todo ha estado\nmuy tranquilo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, in a way, a storm would be\nrefreshing.", french="En un sens, cet orage va nous\nfaire du bien.", german="Deswegen wäre es ganz\nerfrischend, einen Sturm zu sehen.", italian="Quindi, tanto per cambiare,\nun temporale mi farebbe piacere.", spanish="Ver una tormenta será\nrefrescante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So, in a way, a storm would be\nrefreshing.", french="En un sens, cet orage va nous\nfaire du bien.", german="Deswegen wäre es ganz\nerfrischend, einen Sturm zu sehen.", italian="Quindi, tanto per cambiare,\nun temporale mi farebbe piacere.", spanish="Ver una tormenta será\nrefrescante."})
  else
  SkySceneKit.say({english="So, in a way, a storm would be\nrefreshing.", french="En un sens, cet orage va nous\nfaire du bien.", german="Deswegen wäre es ganz\nerfrischend, einen Sturm zu sehen.", italian="Quindi, tanto per cambiare,\nun temporale mi farebbe piacere.", spanish="Ver una tormenta será\nrefrescante."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You know, our big adventure...\nwhen we stopped the destruction of time...", french="Tu te souviens de notre grande\naventure? Tu sais, quand nous avons arrêté\nla destruction du temps...", german="Weißt du noch, unser großes\nAbenteuer, als wir die Zerstörung der Zeit\naufgehalten haben?", italian="Ti ricordi, durante la nostra\ngrande avventura, quando abbiamo fermato la\ndistruzione del tempo?", spanish="¿Te acuerdas de nuestra gran\naventura... cuando detuvimos la destrucción\ndel tiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You know, our big adventure...\nwhen we stopped the destruction of time...", french="Tu te souviens de notre grande\naventure? Tu sais, quand nous avons arrêté\nla destruction du temps...", german="Weißt du noch, unser großes\nAbenteuer, als wir die Zerstörung der Zeit\naufgehalten haben?", italian="Ti ricordi, durante la nostra\ngrande avventura, quando abbiamo fermato la\ndistruzione del tempo?", spanish="¿Te acuerdas de nuestra gran\naventura... cuando detuvimos la destrucción\ndel tiempo?"})
  else
  SkySceneKit.say({english="You know, our big adventure...\nwhen we stopped the destruction of time...", french="Tu te souviens de notre grande\naventure? Tu sais, quand nous avons arrêté\nla destruction du temps...", german="Weißt du noch, unser großes\nAbenteuer, als wir die Zerstörung der Zeit\naufgehalten haben?", italian="Ti ricordi, durante la nostra\ngrande avventura, quando abbiamo fermato la\ndistruzione del tempo?", spanish="¿Te acuerdas de nuestra gran\naventura... cuando detuvimos la destrucción\ndel tiempo?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It seems like it happened\nlong ago.", french="... j'ai l'impression que c'était\nil y a une éternité.", german="Es scheint so lange\nzurückzuliegen.", italian="Sembra che sia successo\ntanto tempo fa!", spanish=" Parece ya tan lejano..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It already feels like it happened\na long time ago.", french="... j'ai l'impression que c'était\nil y a une éternité.", german="Es scheint so weit in der\nVergangenheit zu liegen.", italian="Sembra che sia successo\ntanto tempo fa!", spanish=" Parece ya tan lejano..."})
  else
  SkySceneKit.say({english="It already feels like it happened\nlong ago.", french="... j'ai l'impression que c'était\nil y a une éternité.", german="Es scheint so weit in der\nVergangenheit zu liegen.", italian="Sembra che sia successo\ntanto tempo fa!", spanish=" Parece ya tan lejano..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Yes, it does feel that way.)", french="(Oui, j'ai la même impression.)", german="(Ja, so fühlt es sich an.)", italian="(Sì, sembra davvero che sia\npassato un secolo.)", spanish="(Es cierto.)"})
  else
  SkySceneKit.say({english="(Yes, it does feel that way.)", french="(Oui, j'ai la même impression.)", german="(Ja, so fühlt es sich an.)", italian="(Sì, sembra davvero che sia\npassato un secolo.)", spanish="(Es cierto.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Going to the future with [partner]...)", french="(Le voyage dans le futur avec [partner]...)", german="(Mit [partner] in die Zukunft zu reisen...)", italian="(Quando io e [partner] abbiamo\nvisitato il futuro...)", spanish="(El viaje al futuro con [partner]...)"})
  else
  SkySceneKit.say({english="(Going to the future with [partner]...)", french="(Le voyage dans le futur avec [partner]...)", german="(Mit [partner] in die Zukunft zu reisen...)", italian="(Quando io e [partner] abbiamo\nvisitato il futuro...)", spanish="(El viaje al futuro con [partner]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Fighting [CS:N]Dialga[CR] at [CS:P]Temporal Tower[CR]...)", french="(Le combat contre [CS:N]Dialga[CR] à la\n[CS:P]Tour du Temps[CR]...)", german="([CS:N]Dialga[CR] beim [CS:P]Zeitturm[CR] zu bekämpfen...)", italian="(Quando abbiamo affrontato [CS:N]Dialga[CR] alla\n[CS:P]Torre del Tempo[CR]...)", spanish="(El enfrentamiento con [CS:N]Dialga[CR] en\nla [CS:P]Torre del Tiempo[CR]...)"})
  else
  SkySceneKit.say({english="(Fighting [CS:N]Dialga[CR] at [CS:P]Temporal Tower[CR]...)", french="(Le combat contre [CS:N]Dialga[CR] à la\n[CS:P]Tour du Temps[CR]...)", german="([CS:N]Dialga[CR] beim [CS:P]Zeitturm[CR] zu bekämpfen...)", italian="(Quando abbiamo affrontato [CS:N]Dialga[CR] alla\n[CS:P]Torre del Tempo[CR]...)", spanish="(El enfrentamiento con [CS:N]Dialga[CR] en\nla [CS:P]Torre del Tiempo[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Now that I think about it, it does feel like all\nthose things were a long time ago.)", french="(Quand j'y pense, j'ai vraiment l'impression que\nc'était il y a longtemps.)", german="(Wenn ich jetzt darüber nachdenke, fühlt es\nsich an, als läge das alles schon weit zurück.)", italian="(Adesso che ci penso, sembra davvero che\nsia avvenuto molto tempo fa.)", spanish="(Ahora que lo pienso, parece como si todo eso\nhubiera sucedido hace muchísimo tiempo.)"})
  else
  SkySceneKit.say({english="(Now that I think about it, it does feel like all\nthose things were a long time ago.)", french="(Quand j'y pense, j'ai vraiment l'impression que\nc'était il y a longtemps.)", german="(Wenn ich jetzt darüber nachdenke, fühlt es\nsich an, als läge das alles schon weit zurück.)", italian="(Adesso che ci penso, sembra davvero che\nsia avvenuto molto tempo fa.)", spanish="(Ahora que lo pienso, parece como si todo eso\nhubiera sucedido hace muchísimo tiempo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Now that time has returned to normal...[K]\nand peace has come to the world...)", french="(Maintenant que le temps a repris son cours\nnormal...[K] et que le monde a retrouvé la paix...)", german="(Jetzt, da die Zeit wieder normal fließt...[K]\nUnd wieder Frieden in diese Welt eingekehrt\nist...)", italian="(Adesso che il tempo è tornato alla\nnormalità...[K] e la pace regna di\nnuovo sul mondo...)", spanish="(Todo ha vuelto a la normalidad...[K]\nY la paz reina en este mundo...)"})
  else
  SkySceneKit.say({english="(Now that time has returned to normal...[K]\nand peace has come to the world...)", french="(Maintenant que le temps a repris son cours\nnormal...[K] et que le monde a retrouvé la paix...)", german="(Jetzt, da die Zeit wieder normal fließt...[K]\nUnd wieder Frieden in diese Welt eingekehrt\nist...)", italian="(Adesso che il tempo è tornato alla\nnormalità...[K] e la pace regna di\nnuovo sul mondo...)", spanish="(Todo ha vuelto a la normalidad...[K]\nY la paz reina en este mundo...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It reminds me that...[K]because time returned to\nnormal...)", french="(Mais j'y pense...[K] puisque le temps\na repris son cours...)", german="(Hmm...[K] Das erinnert mich an etwas...)", italian="(Tutto ciò mi ricorda che...[K] poiché il tempo\nscorre normalmente...)", spanish="(Lo que me recuerda que...[K] una vez restaurado\nel tiempo...)"})
  else
  SkySceneKit.say({english="(It reminds me that...[K]because time returned to\nnormal...)", french="(Mais j'y pense...[K] puisque le temps\na repris son cours...)", german="(Hmm...[K] Das erinnert mich an etwas...)", italian="(Tutto ciò mi ricorda che...[K] poiché il tempo\nscorre normalmente...)", spanish="(Lo que me recuerda que...[K] una vez restaurado\nel tiempo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It became possible for everyone to evolve at\n[CS:P]Luminous Spring[CR] again...)", french="(Tout le monde a maintenant la possibilité\nd'évoluer à nouveau à la [CS:P]Source Lumineuse[CR]...)", german="(Da die Zeit wieder normal geht, kann sich\nwieder jeder in der [CS:P]Glitzerquelle[CR] entwickeln...)", italian="(... tutti possono di nuovo evolversi alla\n[CS:P]Sorgente Luccichio[CR].)", spanish="(Todo el mundo pudo evolucionar de nuevo en\nel [CS:P]Manantial Luminoso[CR]...)"})
  else
  SkySceneKit.say({english="(It became possible for everyone to evolve at\n[CS:P]Luminous Spring[CR] again...)", french="(Tout le monde a maintenant la possibilité\nd'évoluer à nouveau à la [CS:P]Source Lumineuse[CR]...)", german="(Da die Zeit wieder normal geht, kann sich\nwieder jeder in der [CS:P]Glitzerquelle[CR] entwickeln...)", italian="(... tutti possono di nuovo evolversi alla\n[CS:P]Sorgente Luccichio[CR].)", spanish="(Todo el mundo pudo evolucionar de nuevo en\nel [CS:P]Manantial Luminoso[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Everyone but us, that is. We were told that\nwe can't evolve at [CS:P]Luminous Spring[CR]...)", french="(Tout le monde sauf nous. C'est ce que nous a\nrévélé la [CS:P]Source Lumineuse[CR]...)", german="(Jeder außer uns natürlich. Uns wurde bei\nder [CS:P]Glitzerquelle[CR] gesagt,\ndass wir uns nicht entwickeln können...)", italian="(Tutti tranne noi. Ci è stato detto che\nnoi non possiamo evolverci alla [CS:P]Sorgente\nLuccichio[CR]...)", spanish="(Todos menos nosotros. Nos dijeron que no\npodríamos evolucionar allí...)"})
  else
  SkySceneKit.say({english="(Everyone but us, that is. We were told that\nwe can't evolve at [CS:P]Luminous Spring[CR]...)", french="(Tout le monde sauf nous. C'est ce que nous a\nrévélé la [CS:P]Source Lumineuse[CR]...)", german="(Jeder außer uns natürlich. Uns wurde bei\nder [CS:P]Glitzerquelle[CR] gesagt,\ndass wir uns nicht entwickeln können...)", italian="(Tutti tranne noi. Ci è stato detto che\nnoi non possiamo evolverci alla [CS:P]Sorgente\nLuccichio[CR]...)", spanish="(Todos menos [partner] y yo. Nos dijeron\nque no podríamos evolucionar allí...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I remember it clearly...)", french="(Je m'en souviens très bien...)", german="(Ich erinnere mich noch genau.)", italian="(Mi ricordo bene...)", spanish="(Lo recuerdo perfectamente...)"})
  else
  SkySceneKit.say({english="(I remember it clearly...)", french="(Je m'en souviens très bien...)", german="(Ich erinnere mich noch genau.)", italian="(Mi ricordo bene...)", spanish="(Lo recuerdo perfectamente...)"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 30)
end
