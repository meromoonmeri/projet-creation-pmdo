-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0404.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_3 [étiquette de flux ExplorerScript]
  if ((SV.SkyTalkBitFlags or {})[139] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[139]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_yarukimono = SkySceneKit.spawn_npc("vigoroth", 352, 224, Direction.Up, "NPC_YARUKIMONO")
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Ha ha...[K] The truth is, [CS:N]Marowak[CR]\nasked me to, as a sort of part-time job.", french="Ha ha...[K] En fait, c'est [CS:N]Ossatueur[CR]\nqui me l'a demandé, c'est un job à mi-temps.", german="Ha ha...[K] In Wahrheit hat [CS:N]Knogga[CR]\nmich darum gebeten, als eine Art Teilzeit-Job.", italian="Ah ah ah...[K] A dirla tutta me\nl'ha chiesto [CS:N]Marowak[CR]... È una specie\ndi lavoro part-time.", spanish="Ja, ja...[K] Pues es que [CS:N]Marowak[CR]\nme lo pidió, como un trabajillo temporal."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Well, I say that, but the pay is\nreally minuscule...", french="Bon, je dis ça, mais il me\npaye pas grand-chose...", german="Nun, ich sag das so leicht, aber\ndie Bezahlung ist wirklich erbärmlich...", italian="Anche se la paga è davvero\nmisera...", spanish="Aunque a decir verdad el sueldo\nno es ninguna maravilla..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="I guess you could say I'm\nactually a volunteer! Ha ha ha!", french="En fait, on peut même dire\nque je fais ça bénévolement! Ha ha ha!", german="Man kann das wohl eher als\nEhrenamt bezeichnen! Ha ha ha!", italian="Direi che il mio lavoro\nassomiglia di più a quello di un volontario!\nAh ah ah!", spanish="Prácticamente se podría decir\nque soy un voluntario. ¡Ja, ja, ja!"})
  -- message_Close
  -- @label_2 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[139] = 1 -- $SCENARIO_TALK_BIT_FLAG[139] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! [CS:Y]Sunflora[CR]![K]\nNice day out, huh?", french="Yo! [CS:Y]Héliatronc[CR]![K]\nBelle journée, hein?", german="Jau! [CS:Y]Sonnflora[CR]![K]\nSchönes Wetter heute, nicht wahr?", italian="Yo! [CS:Y]Sunflora[CR]![K]\nStai facendo un giretto?", spanish="¡Buenas, [CS:Y]Sunflora[CR]![K]\nQué día tan bonito, ¿eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="By the way...[K]complete change\nof topic, I know...", french="Au fait...[K]\nJe sais, aucun rapport, mais...", german="Übrigens...[K] Komplett anderes\nThema, ich weiß...", italian="Senti...[K] Cambiando\ncompletamente argomento...", spanish="Por cierto...[K] Ya sé que es\nun cambio de tema un poco brusco, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Did you hear that [CS:K]Marowak[CR]\nDojo has reopened?", french="... tu sais que le [CS:K]Dojo Ossatueur[CR]\na rouvert ses portes?", german="Hast du gehört, dass das\n[CS:K]Knogga-Dojo[CR] wiedereröffnet wurde?", italian="Lo sapevi che il Dojo [CS:K]Marowak[CR]\nha riaperto?", spanish="¿Has oído que el [CS:K]Dojo Marowak[CR]\nha vuelto a abrir sus puertas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:K]Marowak[CR] Dojo...[K]\nThe one that closed recently?", french="Le [CS:K]Dojo Ossatueur[CR]...[K]\nCelui qui a fermé il n'y a pas longtemps?", german="[CS:K]Knogga-Dojo[CR]...[K]\nDas, das damals geschlossen wurde?", italian="Il Dojo [CS:K]Marowak[CR]...[K]\nQuello che aveva chiuso poco tempo fa?", spanish="El [CS:K]Dojo Marowak[CR]...[K]\n¿Ese que cerró hace poco?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yeah! [K]There weren't many\ncustomers...", french="Tout juste! [K]Il n'y avait pas\nbeaucoup de clients...", german="Genau![K] Es gab wohl nicht\ngenügend Kunden...", italian="Esatto! [K]Non c'erano molti\nclienti...", spanish="¡Ese mismo![K] Por lo visto\nno tenía mucha clientela..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="It wasn't well managed and went\nbankrupt in the end...", french="Il était mal géré\net a fini par faire faillite...", german="Und wegen Fehlern der\nGeschäftsführung ging es dann bankrott...", italian="... e la gestione non era delle\nmigliori, così alla fine era andato in\nfallimento.", spanish="No estaba bien administrado\ny acabó quebrando..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" That [CS:K]Marowak[CR] Dojo!", french=" Sacré [CS:K]Dojo Ossatueur[CR]!", german=" Genau das [CS:K]Knogga-Dojo[CR]!", italian=" Quel Dojo [CS:K]Marowak[CR]!", spanish=" Ese [CS:K]Dojo Marowak[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" But! [K]As in, however!", french=" Bah! [K]Quelle affaire!", german=" Nun...[K] Wie dem auch sei!", italian=" Beh, comunque!", spanish=" ¡Peeero![K] Es decir, ¡no obstante!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="It's been resurrected from the\nrubble![K] Back and better than ever!", french="Il vient de renaître de ses\ncendres, tel le phénix![K] Il revient, plus fort\nque jamais!", german="Es hat sich aus dem Schutt neu\nerhoben![K] Und es hat wieder geöffnet und ist\nzudem besser als je zuvor!", italian="È risorto dalle macerie![K]\nDi nuovo aperto e migliore che mai!", spanish="¡Ha resurgido de sus cenizas![K]\nEstá otra vez en funcionamiento ¡y mejor\nque nunca!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="What do you think?[K] How about\nyou go check out the new [CS:K]Marowak[CR] Dojo\nto train yourself, [CS:Y]Sunflora[CR]?", french="Qu'en dis-tu?[K] Et si tu allais jeter\nun œil au nouveau [CS:K]Dojo Ossatueur[CR]\npour t'entraîner, [CS:Y]Héliatronc[CR]?", german="Was denkst du?[K] Willst du\ndas neue [CS:K]Knogga-Dojo[CR] nicht für ein\npersönliches Training besuchen, [CS:Y]Sonnflora[CR]?", italian="Che ne dici, [CS:Y]Sunflora[CR]?[K] Perché\nnon vai a dare un'occhiata al nuovo\nDojo [CS:K]Marowak[CR] e ti alleni un po'?", spanish="¿Qué te parece?[K] ¿Por qué\nno vas a ver el nuevo [CS:K]Dojo Marowak[CR]\npara entrenarte, [CS:Y]Sunflora[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Well, I'd love to go...", french=" Hé bien, j'adorerais y aller...", german=" Tja, ich würde ja gerne...", italian=" Beh, mi piacerebbe molto...", spanish=" Bueno, como que me encantaría..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But I'm on my way to take care\nof a job.", french="... mais je suis en route pour\naller accomplir une mission.", german="Aber ich bin gerade unterwegs,\neinen Job zu erledigen.", italian="... ma adesso devo occuparmi\ndi una missione.", spanish="Pero voy de camino a\nocuparme de una misión."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="By the way... Why are you\npromoting the [CS:K]Marowak[CR] Dojo anyway, [CS:N]Vigoroth[CR]?", french="Mais dis... tu fais de la pub\npour le [CS:K]Dojo Ossatueur[CR], [CS:N]Vigoroth[CR]?", german="Wo wir gerade dabei sind...\nWie kommt es, dass du Werbung für das\n[CS:K]Knogga-Dojo[CR] machst, [CS:N]Muntier[CR]?", italian="A proposito... perché fai\npubblicità al Dojo [CS:K]Marowak[CR], [CS:N]Vigoroth[CR]?", spanish="Por cierto, [CS:N]Vigoroth[CR], ¿por qué\nhaces publicidad del [CS:K]Dojo Marowak[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Ha ha...[K] The truth is, [CS:N]Marowak[CR]\nasked me to, as a sort of part-time job.", french="Ha ha...[K] En fait, [CS:N]Ossatueur[CR]\nme l'a demandé, c'est un job à mi-temps.", german="Ha ha...[K] In Wahrheit hat [CS:N]Knogga[CR]\nmich darum gebeten, als eine Art Teilzeit-Job.", italian="Ah ah ah...[K] A dirla tutta me\nl'ha chiesto [CS:N]Marowak[CR]... È una specie\ndi lavoro part-time.", spanish="Ja, ja...[K] Pues es que [CS:N]Marowak[CR]\nme lo pidió, como un trabajillo temporal."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Well, I say that, but the pay is\nreally minuscule...", french="Bon, je dis ça, mais il me\npaye pas grand-chose...", german="Tja, ich sage das so einfach,\naber die Bezahlung ist wirklich erbärmlich...", italian="Anche se la paga è davvero\nmisera...", spanish="Aunque a decir verdad el sueldo\nno es ninguna maravilla..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="I guess you could say I'm\nactually a volunteer! Ha ha ha!", french="En fait, on peut même dire\nque je fais ça bénévolement! Ha ha ha!", german="Man kann das wohl eher als\nEhrenamt bezeichnen! Ha ha ha!", italian="Direi che il mio lavoro\nassomiglia di più a quello di un\nvolontario! Ah ah ah!", spanish="Prácticamente se podría decir\nque soy un voluntario. ¡Ja, ja, ja!"})
  -- message_Close
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
