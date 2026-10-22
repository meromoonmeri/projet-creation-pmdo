-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m00p1401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_T01P01A, 'US23') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 304, 240, Direction.DownRight, "NPC_RINGUMA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_ringuma2 = SkySceneKit.spawn_npc("ursaring", 328, 264, Direction.UpLeft, "NPC_RINGUMA2")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(276, 228, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 252, 196, false, 2)
  GROUND:MoveToPosition(partner, 252, 220, false, 2)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma2, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Oh! [K][hero]! [partner]!", french=" Oh! [K][hero]! [partner]!", german=" Oh! [K][hero]! [partner]!", italian=" Oh! [K][hero]! [partner]!", spanish="¡Anda![K] ¡Si son [hero] y\n[partner]!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_ringuma, 304, 196, false, 2)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_ringuma2, 304, 228, false, 2)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(npc_npc_ringuma, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_ringuma2, Direction.Left)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, what's going on over here?", french=" Salut! Que se passe-t-il ici?", german=" Hey, was ist denn hier los?", italian=" Ehi, cosa succede qui?", spanish=" Oye, ¿qué hacéis aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, what's going on over here?", french=" Salut! Que se passe-t-il ici?", german=" Hey, was ist denn hier los?", italian=" Ehi, cosa succede qui?", spanish=" Oye, ¿qué hacéis aquí?"})
  else
  SkySceneKit.say({english=" Hey, what's going on over here?", french=" Salut! Que se passe-t-il ici?", german=" Hey, was ist denn hier los?", italian=" Ehi, cosa succede qui?", spanish=" Oye, ¿qué hacéis aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="We went to [CS:P]Luminous Spring[CR]\nrecently.", french="On s'est rendus à la\n[CS:P]Source Lumineuse[CR] récemment.", german="Wir haben uns neulich zur\n[CS:P]Glitzerquelle[CR] begeben.", italian="Poco tempo fa siamo andati\nalla [CS:P]Sorgente Luccichio[CR].", spanish="Fuimos hace poco al\n[CS:P]Manantial Luminoso[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Look...[K] You know how you can't\nreally tell us apart now?", french="Regardez...[K] Vous avez vu\ncomme il est difficile de nous\ndifférencier maintenant?", german="Seht mal...[K] Jetzt kann man uns\nnur leider nicht mehr auseinanderhalten.", italian="E guarda...[K] ora non riescono\npiù a distinguerci!", spanish="Y...[K] ¿te has fijado en que\nahora no hay forma de distinguirnos?"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Well, because of that, I'd like to\nevolve again...", french="Eh bien, c'est justement la\nraison pour laquelle on aimerait évoluer\nune nouvelle fois...", german="Genau deswegen wollte ich mich\ngerne noch einmal entwickeln...", italian="Quindi mi sarebbe piaciuto\nevolvermi ancora...", spanish="Bueno, pues no me hace ninguna\ngracia y me gustaría volver a evolucionar..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="So we went back to\n[CS:P]Luminous Spring[CR] to see.", french="Alors on est retournés à la\n[CS:P]Source Lumineuse[CR] pour voir.", german="Also gingen wir zurück zur\n[CS:P]Glitzerquelle[CR], um es herauszufinden.", italian="Così siamo tornati alla\n[CS:P]Sorgente Luccichio[CR] per riprovare.", spanish="Por eso volvimos al [CS:P]Manantial\nLuminoso[CR] a ver qué pasaba."})
  -- message_Close
  GROUND:EntTurn(npc_npc_ringuma, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_ringuma, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="How many times do I have to\ntell her that we can't evolve past this form?", french="Combien de fois il faudra que je\nlui explique qu'on ne peut plus évoluer après\ncette forme?", german="Wie viele Male muss ich ihr\nnoch erklären, dass sie sich in dieser Form\nnicht weiterentwickeln kann?", italian="Non so quante volte le ho\nripetuto che non possiamo più evolverci.", spanish="¿Cuántas veces tendré que\ndecirle que ya no podemos evolucionar más?"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="But she just doesn't listen to me,\nno matter how many times I tell her...", french="J'ai beau le lui dire et le lui\nrépéter, elle ne veut rien entendre...", german="Aber sie hört mir einfach nicht\nzu, egal wie häufig ich es ihr erkläre...", italian="Ma per quante volte glielo dica,\nnon vuole starmi a sentire...", spanish="¡Pero es que no me escucha! Por\nmás que se lo digo, ella no me hace ni caso..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="So we had no choice but to go\nthere and prove it...", french="Alors on n'a pas eu d'autre choix\nque d'y retourner pour qu'elle en ait\nla preuve...", german="Auf jeden Fall blieb uns keine\nandere Wahl, als zurückzukehren und die\nProbe aufs Exempel zu machen.", italian="Così non ho avuto altra scelta\nche riportarla lì per dimostrarglielo...", spanish="Por eso fuimos otra vez\npara que lo viera con sus propios ojos..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Of course, we can't evolve.[K]\n...But that's what I've been saying all along.", french="Bien sûr que nous ne pouvons\nplus évoluer...[K]\nC'est ce que je n'arrête pas de lui répéter...", german="Natürlich konnten wir uns nicht\nmehr entwickeln.[K]\n...Aber das hatte ich ja gleich gesagt.", italian="E naturalmente non ci siamo\nevoluti.[K] Ma è quello che le ho ripetuto\ncentinaia di volte.", spanish="Obviamente no evolucionamos.[K]\nEs lo que llevo diciéndole desde el principio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_ringuma, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  GROUND:EntTurn(hero, Direction.DownRight)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But?", french=" Mais?", german=" Aber?", italian=" Ma?", spanish=" ¿Pero?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But?", french=" Mais?", german=" Aber?", italian=" Ma?", spanish=" ¿Pero?"})
  else
  SkySceneKit.say({english=" But?", french=" Mais?", german=" Aber?", italian=" Ma?", spanish=" ¿Pero?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Something about the place feels\ndifferent...[K]from the last time we went...", french="Il y a quelque chose de différent\nlà-bas...[K] par rapport à la dernière fois\nqu'on y est allés...", german="Etwas an diesem Ort fühlte sich\nanders an...[K] Im Vergleich zum letzten Mal, als\nwir dort waren...", italian="Rispetto all'ultima volta che\nsiamo stati in quel posto...[K] è cambiato\nqualcosa...", spanish="Noto algo diferente en ese\nlugar...[K] desde la última vez que fuimos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Different...?", french=" Quelque chose de différent...?", german=" Anders?", italian=" Cambiato qualcosa...?", spanish=" ¿Diferente...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Different...?", french=" Quelque chose de différent...?", german=" Anders?", italian=" Cambiato qualcosa...?", spanish=" ¿Diferente...?"})
  else
  SkySceneKit.say({english=" Different...?", french=" Quelque chose de différent...?", german=" Anders?", italian=" Cambiato qualcosa...?", spanish=" ¿Diferente...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Yeah.", french=" Ouais.", german=" Genau!", italian=" Sì.", spanish=" Sí, sí."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="The atmosphere is different...[K]\nLike a fog has been lifted, or something...", french="L'atmosphère a changé...[K]\nUn peu comme si un brouillard s'était levé...", german="Die Atmosphäre ist anders...[K]\nAls ob sich ein Nebel gelichtet hätte, oder so...", italian="C'è un'atmosfera diversa...[K]\nCome se si fosse diradata una nebbia\no qualcosa di simile...", spanish="El ambiente es diferente...[K]\nComo si se hubiera retirado una niebla\no algo así..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="I can't really explain it...[K]\nBut it's like it's a different [CS:P]Luminous Spring[CR]\nthan before...", french="Je ne peux pas vraiment\nl'expliquer...[K] Mais c'est comme si c'était une\ntoute autre [CS:P]Source Lumineuse[CR] qu'avant...", german="Ich kann es nicht so recht\nbeschreiben...[K] Aber man hat das Gefühl, dass\nes eine andere [CS:P]Glitzerquelle[CR] ist als zuvor...", italian="Non riesco a spiegarlo bene...[K]\nMa la [CS:P]Sorgente Luccichio[CR] sembra diversa\nrispetto a prima...", spanish="No sé cómo explicarlo...[K]\npero es como si fuera un [CS:P]Manantial Luminoso[CR]\ndistinto al de antes..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_ringuma, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(3)
  GROUND:EntTurn(partner, Direction.UpRight)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" I felt that too.", french=" Je l'ai senti, moi aussi.", german=" Das habe ich auch gespürt.", italian="Anch'io ho avuto\nla stessa sensazione.", spanish=" A mí también me lo pareció."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Just looking at it,\nnothing's changed...", french="Quand on la regarde,\nrien ne semble avoir changé...", german="Alles sieht noch so aus\nwie zuvor...", italian="A guardarla non è cambiato\nnulla...", spanish="A simple vista nada\nha cambiado..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" But there's something different.", french="Pourtant, il y a quelque chose\nde différent.", german=" Aber etwas ist anders.", italian=" ... ma c'è qualcosa di diverso.", spanish=" Pero hay algo diferente."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="And...[K]I just remembered\nsomething...", french="Et...[K] je viens de me souvenir\nde quelque chose...", german=" Und...[K] Da fiel mir etwas ein...", italian=" E...[K] ora che ci penso...", spanish="Ah...[K] Me acabo de acordar\nde algo..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="You...[K] You tried to evolve there\nbefore, didn't you? But you couldn't?", french="Vous...[K] Vous avez essayé\nd'évoluer là-bas, avant, pas vrai?\nMais sans succès?", german="Ihr...[K] Ihr habt doch auch\nersucht, euch dort zu entwickeln, nicht wahr?\nAber es klappte nicht...", italian="Voi...[K] avete tentato di evolvervi\nin passato, ma senza successo. Non è vero?", spanish="Intentasteis...[K] evolucionar,\n¿no es así? Pero no pudisteis, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="If I recall correctly, it was said\nyou couldn't evolve for some reason...", french="Si je me souviens bien, on disait\nque, pour une certaine raison, il vous était\nimpossible d'évoluer...", german="Wenn ich mich recht entsinne,\nwurde euch gesagt, ihr könntet euch aus einem\nbestimmten Grund nicht entwickeln...", italian="Se ricordo bene, vi è stato\ndetto che non potevate evolvervi\nper un qualche motivo...", spanish="Si mal no recuerdo, os dijeron\nque no podíais evolucionar por algún motivo..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="But since something seems to be\ndifferent about [CS:P]Luminous Spring[CR]...", french="Mais comme la [CS:P]Source\nLumineuse[CR] semble avoir changé...", german="Aber da sich nun anscheinend\netwas an der [CS:P]Glitzerquelle[CR] verändert hat...", italian="Ma visto che sembra essere\ncambiato qualcosa alla [CS:P]Sorgente Luccichio[CR]...", spanish="Pero como algo parece haber\ncambiado en el [CS:P]Manantial Luminoso[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Maybe whatever was blocking\nyou is gone...[K] That is...", french="... peut-être que ce qui vous\nempêchait d'évoluer n'est plus là...[K]\nCe qui voudrait dire...", german="Das, was auch immer eure\nEntwicklung verhindert hat, könnte ja\nverschwunden sein...", italian="Forse ciò che impediva la vostra\nevoluzione è scomparso...[K] Proprio così...", spanish="Puede que lo que fuera que os lo\nimpedía haya desaparecido...[K] Es decir..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="I think that you might be\nable to evolve now, if you want to.", french="Je pense qu'à partir de\nmaintenant, vous pouvez évoluer,\nsi vous le souhaitez.", german="Ich vermute, dass ihr euch jetzt\nentwickeln könnt, wenn ihr wollt.", italian="Credo che ora potreste farcela,\nse lo desiderate.", spanish="Que creo que ahora podríais\nevolucionar, si así lo deseáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Really? [K]You think we can\nevolve? Awesome!", french="Vraiment? [K]Tu penses qu'on peut\névoluer, maintenant? Mais c'est génial!", german="Wirklich? [K] Du glaubst, wir\nkönnen uns jetzt entwickeln? Wahnsinn!", italian="Davvero? [K]Possiamo evolverci?\nGrandioso!", spanish="¿En serio?[K] ¿Crees que ahora\nsí podremos evolucionar? ¡Mola!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Really? [K]We can evolve now?", french="Vraiment? [K]Tu penses qu'on peut\névoluer, maintenant? Mais c'est génial!", german="Wirklich? [K]\nWir können uns jetzt entwickeln?", italian="Davvero? [K]Ora possiamo\nevolverci?", spanish="¿De verdad?[K] ¿Ahora\npodemos evolucionar?"})
  else
  SkySceneKit.say({english=" Really? [K]We can evolve now?", french="Vraiment? [K]Tu penses qu'on peut\névoluer, maintenant? Mais c'est génial!", german="Wirklich? [K]\nWir können uns jetzt entwickeln?", italian="Dici sul serio? [K]Ora possiamo\nevolverci?", spanish="¿De verdad?[K] ¿Ahora\npodríamos evolucionar?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Well, I don't really know if\nyou can...", french="Eh bien, techniquement, je ne\nsais pas vraiment si c'est possible...", german="Nun, mit absoluter Sicherheit\nkann ich das natürlich nicht sagen...", italian=" Beh, non so se sia così o meno...", spanish="Bueno, no sé si será posible\nde verdad..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="I'm just saying that I think it\nmight now be possible...", french="Je dis juste qu'il se pourrait\nque ce soit possible, d'après moi...", german="Ich sage nur, dass ich vermute,\nes könnte jetzt möglich sein...", italian="Dico solo che secondo me\nadesso potrebbe essere possibile...", spanish="Solo digo que ahora\ncabe esa posibilidad."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="But...[K] It would be worth\ngiving it a shot.", french="Mais...[K] ça vaut le coup\nd'essayer.", german="Aber...[K] Es ist auf jeden Fall\neinen Versuch wert.", italian="Però...[K] credo che varrebbe\nla pena dare un'occhiata.", spanish="Pero...[K] supongo que ir a\ncomprobarlo puede merecer la pena."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="So if you want to evolve, then\nhead back over to [CS:P]Luminous Spring[CR] and see.", french="Alors si vous voulez essayer\nd'évoluer, allez à la [CS:P]Source Lumineuse[CR]\npour voir.", german="Wenn ihr euch entwickeln wollt,\nmacht euch wieder auf zur [CS:P]Glitzerquelle[CR]\nund probiert es aus.", italian="Quindi, se volete evolvervi,\nritornate alla [CS:P]Sorgente Luccichio[CR] e provateci.", spanish="Así que, si queréis evolucionar,\nvolved al [CS:P]Manantial Luminoso[CR] a ver qué pasa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" We just wanted to let you know.", french="Voilà, on tenait à vous le\nfaire savoir.", german=" Das wollten wir euch mitteilen.", italian=" Volevamo solo che lo sapeste.", spanish=" Solo queríamos que lo supierais."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" See you.", french=" A la prochaine.", german=" Bis bald.", italian=" A presto.", spanish=" Hasta otra."})
  -- message_Close
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_ringuma2, 328, 276, false, 2)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(10)
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:MoveToPosition(npc_npc_ringuma, 304, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_ringuma2, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_ringuma, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[10] = 1 -- $PERFORMANCE_PROGRESS_LIST[10] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SCENARIO_BALANCE_FLAG = 7 -- $SCENARIO_BALANCE_FLAG = 7 (ROM)
  SkySceneKit.cleanup_npcs()
end
