-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m11a0704.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I must be reading too much into this...)", french="(Peut-être que j'attache trop d'importance à ce\nqui s'est passé...)", german="(Ich denke mir wahrscheinlich zu viel dabei...)", italian="(Forse sto esagerando...)", spanish="(Debo de estar dándole demasiadas vueltas.)"})
  else
  SkySceneKit.say({english="(I must be reading too much into this...)", french="(Peut-être que j'attache trop d'importance à ce\nqui s'est passé...)", german="(Ich denke mir wahrscheinlich zu viel dabei...)", italian="(Forse sto esagerando...)", spanish="(Debo de estar dándole demasiadas vueltas.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(My pulse raced when I saw the Time Gear...)", french="(Mon pouls s'est accéléré quand j'ai vu\nle Rouage du Temps...)", german="(Mein Puls fing an zu rasen, als ich das\nZahnrad der Zeit sah.)", italian="(Non c'è alcun collegamento tra la mia\nsensazione nel vedere l'Ingranaggio del\nTempo...)", spanish="(Se me aceleró el pulso al ver el Engranaje\ndel Tiempo...)"})
  else
  SkySceneKit.say({english="(My pulse raced when I saw the Time Gear...)", french="(Mon pouls s'est accéléré quand j'ai vu\nle Rouage du Temps...)", german="(Mein Puls fing an zu rasen, als ich das\nZahnrad der Zeit sah.)", italian="(Non c'è alcun collegamento tra la mia\nsensazione nel vedere l'Ingranaggio del\nTempo...)", spanish="(Se me aceleró el pulso al ver el Engranaje\ndel Tiempo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And the Time Gears being stolen...[K] No, there's\nno connection at all.)", french="(Et la disparition des Rouages du Temps...[K] Non,\nça n'a rien à voir.)", german="(Und dass die Zahnräder der Zeit gestohlen\nwerden...[K] Nein, es gibt keinen Zusammenhang.)", italian="(... e il fatto che gli Ingranaggi del Tempo\nsiano stati rubati.[K] No, non c'è alcun\ncollegamento.)", spanish="(Y ahora los Engranajes del Tiempo están\ndesapareciendo...[K] No, no creo que haya\nninguna relación.)"})
  else
  SkySceneKit.say({english="(And the Time Gears being stolen...[K] No, there's\nno connection at all.)", french="(Et la disparition des Rouages du Temps...[K] Non,\nça n'a rien à voir.)", german="(Und dass die Zahnräder der Zeit gestohlen\nwerden...[K] Nein, es gibt keinen Zusammenhang.)", italian="(... e il fatto che gli Ingranaggi del Tempo\nsiano stati rubati.[K] No, non c'è alcun\ncollegamento.)", spanish="(Y ahora los Engranajes del Tiempo están\ndesapareciendo...[K] No, no creo que haya\nninguna relación.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey! When I think about it,\n[hero]...", french="Eh, [hero], quand j'y\nrepense...", german="Hey! Wenn ich so darüber\nnachdenke, [hero]...", italian="Ehi! Ma lo sai, [hero], che\nquando ci penso...", spanish="¡Oye, [hero]!\nHe estado pensando que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You know, when I think about it,\n[hero]...", french="Eh, [hero], quand j'y\nrepense...", german="Weißt du, wenn ich so darüber\nnachdenke, [hero]...", italian="Sai, [hero], quando ci\npenso...", spanish="[hero], cada vez que me\nparo a pensarlo..."})
  else
  SkySceneKit.say({english="You know, when I think about it,\n[hero]...", french="Eh, [hero], quand j'y\nrepense...", german="Weißt du, wenn ich so darüber\nnachdenke, [hero]...", italian="Sai, [hero], quando ci\npenso...", spanish="[hero], cada vez que me\nparo a pensarlo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It feels as if the [CS:P]Fogbound Lake[CR]\nexpedition happened a long time ago.", french="J'ai l'impression que ça fait\nune éternité qu'on est tous partis en\nexpédition au [CS:P]Lac des Brumes[CR].", german="Es kommt mir so vor, als wäre\ndie Expedition zum [CS:P]Nebelsee[CR] schon sehr lange\nher.", italian="È come se la spedizione al\n[CS:P]Lago Foschia[CR] fosse avvenuta molto tempo fa.", spanish="Parece como si hubiera pasado\nmuchísimo tiempo desde la expedición al\n[CS:P]Lago Velado[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I get this feeling that our\nexpedition to [CS:P]Fogbound Lake[CR] took place a long\ntime ago.", french="J'ai l'impression que ça fait\nune éternité qu'on est tous partis en\nexpédition au [CS:P]Lac des Brumes[CR].", german="Es kommt mir so vor, als wäre\ndie Expedition zum [CS:P]Nebelsee[CR] schon sehr lange\nher.", italian="È come se la spedizione al\n[CS:P]Lago Foschia[CR] fosse avvenuta molto tempo fa.", spanish="Es como si hubiera pasado mucho\ntiempo desde la expedición al [CS:P]Lago Velado[CR]."})
  else
  SkySceneKit.say({english="I get this feeling that our\nexpedition to [CS:P]Fogbound Lake[CR] took place a long\ntime ago.", french="J'ai l'impression que ça fait\nune éternité qu'on est tous partis en\nexpédition au [CS:P]Lac des Brumes[CR].", german="Es kommt mir so vor, als wäre\ndie Expedition zum [CS:P]Nebelsee[CR] schon sehr lange\nher.", italian="È come se la spedizione al\n[CS:P]Lago Foschia[CR] fosse avvenuta molto tempo fa.", spanish="Es como si hubiera pasado mucho\ntiempo desde la expedición al [CS:P]Lago Velado[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wasn't the view fantastic?[K]\nLike a dream, even!", french="Et cette vue magnifique![K]\nOn aurait dit un rêve!", german="War dieser Ausblick nicht\nfantastisch?[K] Geradezu traumhaft!", italian="Ti ricordi la vista da lassù?[K]\nEra come stare in un sogno, no?", spanish="¿No era una vista fantástica?[K]\n¡Casi como un sueño!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wasn't the view fantastic?[K]\nIt was like being in a dream!", french="Et cette vue magnifique![K]\nOn aurait dit un rêve!", german="War dieser Ausblick nicht\nfantastisch?[K] Es war wie in einem Traum!", italian="Ti ricordi la vista da lassù?[K]\nEra come stare in un sogno!", spanish="¿No era una vista fantástica?[K]\n¡Casi como un sueño!"})
  else
  SkySceneKit.say({english="Wasn't the view fantastic?[K]\nIt was like being in a dream!", french="Et cette vue magnifique![K]\nOn aurait dit un rêve!", german="War dieser Ausblick nicht\nfantastisch?[K] Es war wie in einem Traum!", italian="Ti ricordi la vista da lassù?[K]\nEra come stare in un sogno!", spanish="¿No era una vista fantástica?[K]\n¡Casi como un sueño!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I wonder how [CS:N]Uxie[CR] is doing?", french="Je me demande comment\n[CS:N]Créhelf[CR] s'en sort.", german=" Wie es [CS:N]Selfe[CR] wohl geht?", italian="Chissà come se la sta passando\nil buon vecchio [CS:N]Uxie[CR]...", spanish=" Me pregunto cómo le irá a [CS:N]Uxie[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I wonder how [CS:N]Uxie[CR] is doing?", french="Je me demande comment\n[CS:N]Créhelf[CR] s'en sort.", german=" Wie es [CS:N]Selfe[CR] wohl geht?", italian=" Chissà come sta [CS:N]Uxie[CR]...", spanish=" Me pregunto cómo le irá a [CS:N]Uxie[CR]."})
  else
  SkySceneKit.say({english=" I wonder how [CS:N]Uxie[CR] is doing?", french="Je me demande comment\n[CS:N]Créhelf[CR] s'en sort.", german=" Wie es [CS:N]Selfe[CR] wohl geht?", italian=" Chissà come sta [CS:N]Uxie[CR]...", spanish=" Me pregunto cómo le irá a [CS:N]Uxie[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I wonder if he's doing OK?", french=" Tu crois qu'il va bien?", german=" Ob es ihm gut geht?", italian=" Speriamo che se la passi bene.", spanish=" ¿Estará bien?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I wonder if he's well?", french=" Tu crois qu'il va bien?", german=" Ob es ihm wohl gut geht?", italian=" Spero che stia bene.", spanish=" ¿Estará bien?"})
  else
  SkySceneKit.say({english=" I wonder if he's well?", french=" Tu crois qu'il va bien?", german=" Ob es ihm wohl gut geht?", italian=" Spero che stia bene.", spanish=" ¿Estará bien?"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:FadeOut(false, 60)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_YUKUSHII) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" I knew it...", french=" Je le savais...", german=" Ich wusste es...", italian=" Lo sapevo...", spanish=" Lo sabía."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="I knew I shouldn't have\ntrusted them.", french="Je savais bien que je n'aurais\npas dû leur faire confiance.", german="Ich wusste, ich hätte ihnen nicht\ntrauen sollen.", italian="Sapevo che non avrei dovuto\nfidarmi di loro.", spanish="Sabía que no tenía que haberme\nfiado de ellos."})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(0)
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(5)
  GAME:FadeOut(false, 0)
  GAME:WaitFrames(2) -- join WaitSe
end
