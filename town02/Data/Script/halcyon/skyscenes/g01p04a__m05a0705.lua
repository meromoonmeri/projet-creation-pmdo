-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m05a0705.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Your waterfall discovery is just\namazing![K] The Guildmaster must be told! ♪", french="Cette découverte est vraiment\nsensationnelle![K] Il faut en informer le Maître\nde la Guilde! ♪", german="Eure Entdeckung ist einfach\nunglaublich![K] Der Gildenmeister muss davon\nerfahren! ♪", italian="La vostra scoperta è\nfenomenale![K] Devo informare il Capitano! ♪", spanish="¡El descubrimiento que habéis\nhecho en la cascada es increíble![K]\n¡Tenemos que informar al Gran Bluff! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? What's up, [hero]?", french="Hein? Qu'est-ce qu'il y a,\n[hero]?", german=" Huch? Was ist, [hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What? What's wrong,\n[hero]?", french="Hein? Qu'est-ce qu'il y a,\n[hero]?", german="Stimmt etwas nicht,\n[hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  else
  SkySceneKit.say({english="Oh? What's the matter,\n[hero]?", french="Hein? Qu'est-ce qu'il y a,\n[hero]?", german=" Oh? Was ist los, [hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?", french=" Pardon?", german=" Äh?", italian=" Eh?", spanish=" ¿Qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?", french=" Pardon?", german=" Äh?", italian=" Eh?", spanish=" ¿Qué?"})
  else
  SkySceneKit.say({english=" Pardon?!", french=" Pardon?", german=" Wie bitte?!?", italian=" Come?!", spanish=" ¿Qué?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're saying that [CS:N]Wigglytuff[CR]\nhas been to the waterfall before?!", french="Tu es en train de me dire que\n[CS:N]Grodoudou[CR] est déjà allé à la cascade?!", german="Du sagst, dass [CS:N]Knuddeluff[CR] schon\nmal an dem Wasserfall war?!?", italian="Stai dicendo che [CS:N]Wigglytuff[CR]\nè già stato alla cascata?!", spanish="¡¿Crees que [CS:N]Wigglytuff[CR] ya había\nestado en la cueva que hay tras la cascada?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You're saying [CS:N]Wigglytuff[CR] may\nhave been at that waterfall before?!", french="Tu es en train de me dire que\n[CS:N]Grodoudou[CR] est déjà allé à la cascade?!", german="Du sagst, dass [CS:N]Knuddeluff[CR] schon\nmal an dem Wasserfall war?!?", italian="Stai dicendo che [CS:N]Wigglytuff[CR]\nè già stato alla cascata?!", spanish="¡¿Crees que [CS:N]Wigglytuff[CR] ya había\nestado en la cueva que hay tras la cascada?!"})
  else
  SkySceneKit.say({english="You're saying [CS:N]Wigglytuff[CR] may\nhave gone to that waterfall before?!", french="Tu es en train de me dire que\n[CS:N]Grodoudou[CR] est déjà allé à la cascade?!", german="Du sagst, dass [CS:N]Knuddeluff[CR] schon\nmal an dem Wasserfall war?!?", italian="Stai dicendo che [CS:N]Wigglytuff[CR]\nè già stato alla cascata?!", spanish="¡¿Crees que [CS:N]Wigglytuff[CR] ya había\nestado en la cueva que hay tras la cascada?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(20) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="No, no, no! Emphatically no![K]\nThat's inconceivable!", french="Non, non! Trois fois non![K]\nC'est totalement inconcevable!", german="Nein, nein, nein! Mit Sicherheit\nnicht![K] Das ist absolut undenkbar!", italian="No, no, no! Assolutamente no![K]\nÈ impossibile!", spanish="¡No, no y no![K]\n¡Eso es inconcebible!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If that were so, the Guildmaster\nwouldn't have ordered you to investigate the\nplace, right?", french="Si c'était le cas, le Maître de la\nGuilde n'aurait pas ordonné que vous exploriez\ncet endroit, vous ne pensez pas?", german="Wenn dem so wäre, hätte der\nGildenmeister euch nicht mit der Erkundung\nbeauftragt, oder?", italian="Se fosse vero, il Capitano non vi\navrebbe ordinato di ispezionare quel luogo,\ngiusto?", spanish="Si fuera así, el Gran Bluff\nno os habría ordenado ir a investigar\nese sitio, ¿verdad?"})
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hmm. However, since you insist,\nI will confirm it with the Guildmaster...", french="Hmm. Enfin, puisque vous\ninsistez, je vais demander confirmation\nau Maître de la Guilde...", german="Hmm. Aber da ihr darauf\nbesteht, werde ich den Gildenmeister selbst\nfragen.", italian="Mmm... Tuttavia, visto che\ninsistete, chiederò al Capitano.", spanish="Hum. Sin embargo, y dado que\ninsistís, vamos a preguntárselo directamente."})
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hmm... But why would they want\nto spoil their own discovery! How strange!", french="Hmm... Mais pourquoi est-ce que\nces deux-là veulent gâcher leur propre\ndécouverte? Comme c'est étrange!", german="Hmm... Wieso sollten sie ihre\neigene Entdeckung verderben wollen?!?\nWie seltsam!", italian="Mmm... Perché non vogliono\ntenersi il merito della scoperta?\nChe strano!", spanish="Hum. ¿Para qué iba a querer que\nalguien se apropiase de su descubrimiento?\n¡Qué raro!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I should be used to it by now...", french="Enfin, cela ne devrait plus\nm'étonner, depuis le temps...", german="Ich sollte so etwas mittlerweile\ngewohnt sein.", italian=" Ormai dovrei esserci abituato...", spanish="Ya tendría que estar más que\nacostumbrado a esto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="These apprentices are yet\nanother strange crew, aren't they...?", french="Ces deux-là sont décidément\ntrès bizarres...", german="Diese Lehrlinge sind mal wieder\nkomische Käuze.", italian="Gli apprendisti sono proprio\nstrambi a volte...", spanish="Este equipo es muy peculiar, la\nverdad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What was that, [CS:N]Chatot[CR]?", french=" Qu'as-tu dit, [CS:N]Pijako[CR]?", german=" Was war das?", italian=" Cosa stai dicendo, [CS:N]Chatot[CR]?", spanish=" ¿Qué decías, [CS:N]Chatot[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What was that, [CS:N]Chatot[CR]?", french=" Qu'as-tu dit, [CS:N]Pijako[CR]?", german=" Was war das?", italian=" Cosa stai dicendo, [CS:N]Chatot[CR]?", spanish=" ¿Qué decías, [CS:N]Chatot[CR]?"})
  else
  SkySceneKit.say({english=" What was that, [CS:N]Chatot[CR]?", french=" Qu'as-tu dit, [CS:N]Pijako[CR]?", german=" Was war das?", italian=" Cosa stai dicendo, [CS:N]Chatot[CR]?", spanish=" ¿Qué decías, [CS:N]Chatot[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(42) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="What? Oh, nothing, nothing.\nNothing at all!", french="Comment? Oh... euh... rien.\nRien du tout!", german="Was? Oh, nichts, nichts.\nÜberhaupt nichts!", italian="Cosa? Oh, niente, niente.\nProprio niente!", spanish=" ¿Qué? Oh, nada. ¡Nada de nada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Anyway, I will go confirm what\nyou told me with the Guildmaster.", french="Je vais confirmer tout ce que\nvous m'avez dit auprès du Maître de la Guilde.", german="Wie auch immer, ich werde den\nGildenmeister fragen, ob eure Geschichte\nstimmt.", italian="Comunque, vado dal Capitano\nper verificare quello che mi avete detto.", spanish="De todas formas, voy a\nconfirmar lo que me habéis dicho."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Please wait here.", french=" Veuillez attendre ici.", german=" Bitte wartet hier.", italian=" Aspettate qui, per favore.", spanish="Hacedme el favor de\nesperar aquí."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_perappu, 416, 180, false, 2)
  GAME:WaitFrames(10)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(120)
  GROUND:MoveToPosition(npc_npc_perappu, 456, 220, false, 2)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So how did it go?", french=" Alors, qu'est-ce qu'il a dit?", german=" Und, wie lief es?", italian=" Allora, come è andata?", spanish=" ¿Qué ha dicho?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So how did it go?", french=" Alors, qu'est-ce qu'il a dit?", german=" Und, wie lief es?", italian=" Allora, come è andata?", spanish=" ¿Qué ha dicho?"})
  else
  SkySceneKit.say({english=" So how did it go?", french=" Alors, qu'est-ce qu'il a dit?", german=" Und, wie lief es?", italian=" Allora, come è andata?", spanish=" ¿Qué ha dicho?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="When I asked the Guildmaster,\nhe mulled it over for a bit.", french="Quand j'ai posé la question au\nMaître, il s'est plongé dans ses pensées\npendant quelques instants.", german="Als ich den Gildenmeister fragte,\nwurde er erst einmal sehr nachdenklich.", italian="Quando gliel'ho detto, il Capitano\nsi è messo a rimuginare un po'.", spanish="Cuando le pregunté al Gran\nBluff, se lo pensó un rato."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" And then he said...", french=" Et puis il a dit...", german=" Und dann sagte er...", italian=" Poi ha detto...", spanish=" Y entonces dijo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="\"Oh, memories! ♪ Sweet\nmemories! ♪[K] YOOM...TAH!\"", french="\"Oh, souvenirs! Doux souvenirs!\nQue de rêves, que de bonheur! ♪[K]\nTA-DAAAAA!!\"", german="[F:S2]Oh, Erinnerung! ♪ Süße\nErinnerung! ♪[K] LUUUU... FIIII![F:E2]", italian="\"Oh, ricordi! ♪ Dolci\nricordi! ♪[K] BADABUM!\"", spanish="\"¡Oh, recuerdos! ♪ ¡Dulces\nrecuerdos! ♪[K] ¡GENIAL!\""})
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(26) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Then he danced around a bit.[K]\nAnd then he said...", french="Il a ensuite esquissé quelques\npas de danse, avant de me dire...", german="Dann tanzte er eine Weile durch\ndie Gegend.[K] Und dann sagte er...", italian="Poi ha ballato per un po'.[K]\nDopodiché ha detto...", spanish="Luego bailó un rato.[K]\nY dijo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="\"Yes, yes! When I think hard,\nmaybe I did go there once!\"", french="\"Ah oui, oui! Mais c'est bien sûr!\nMaintenant que tu me le dis, peut-être\nbien que j'y suis déjà allé à l'époque!\"", german="[F:S2]Ja, ja! Wenn ich recht\nüberlege, war ich vielleicht wirklich einmal\nda![F:E2]", italian="... \"Sì, sì! A pensarci bene,\nforse ci sono già stato una volta!\"", spanish="\"¡Sí, sí! Pensándolo bien,\n¡a lo mejor estuve allí una vez!\""})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And that's just what the\nGuildmaster said.", french=" Et il n'a rien dit de plus...", german="Das waren die Worte des\nGildenmeisters.", italian="E questo è esattamente ciò che\nha detto il Capitano.", spanish=" Y eso fue todo lo que dijo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="To sum it up, it's just as\n[hero] suspected...[K] He has indeed already\nbeen to [CS:P]Waterfall Cave[CR].", french="Pour résumer, c'est bien ce que\n[hero] pensait...[K] Il s'est déjà rendu\nà la [CS:P]Grotte Cascade[CR].", german="Kurz gesagt, es ist so, wie\n[hero] vermutet hat.[K] Er war tatsächlich\nschon einmal in der [CS:P]Wasserfallhöhle[CR].", italian="Per riassumere, è come\nsospettava [hero]...[K] È già stato alla\n[CS:P]Grotta della Cascata[CR].", spanish="En resumen, es justo lo que\n[hero] sospechaba...[K] En efecto, él ya\nhabía estado antes en la [CS:P]Cueva Cascada[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh... Is that so?[K] That's so\ndisappointing...", french=" Ah bon...[K] Quelle déception...", german="Oh... Tatsächlich?[K] Das ist aber\nschade...", italian=" Ah... È così?[K] Che delusione...", spanish="Oh... ¿De verdad?[K]\n¡Menudo chasco!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh... OK.[K] That's kind of\ndisappointing...", french=" Ah bon...[K] Quelle déception...", german="Oh... Okay.[K] Das ist irgendwie\nschade...", italian=" Oh... È così?[K] Che delusione...", spanish=" Oh... Vaya.[K] ¡Qué decepción!"})
  else
  SkySceneKit.say({english="Oh... OK.[K] That's kind of\ndisappointing...", french=" Ah bon...[K] Quelle déception...", german="Oh... Okay.[K] Das ist irgendwie\nschade...", italian=" Oh... È così?[K] Che delusione...", spanish=" Oh... Vaya.[K] ¡Qué decepción!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We really thought we'd\ndiscovered a new place.", french="Nous qui pensions avoir\nvraiment découvert un lieu inexploré...", german="Wir dachten wirklich, wir\nhätten eine Entdeckung gemacht.", italian="Pensavamo davvero di aver\nscoperto un posto nuovo.", spanish="Creíamos haber descubierto un\nlugar nuevo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We really thought we'd\ndiscovered a new place.", french="Nous qui pensions avoir\nvraiment découvert un lieu inexploré...", german="Wir dachten wirklich, wir\nhätten eine Entdeckung gemacht.", italian="Pensavamo davvero di aver\nscoperto un posto nuovo.", spanish="Creíamos haber descubierto un\nlugar nuevo."})
  else
  SkySceneKit.say({english="We really thought we'd\ndiscovered a new place.", french="Nous qui pensions avoir\nvraiment découvert un lieu inexploré...", german="Wir dachten wirklich, wir\nhätten eine Entdeckung gemacht.", italian="Pensavamo davvero di aver\nscoperto un posto nuovo.", spanish="Creíamos haber descubierto un\nlugar nuevo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I wish [CS:N]Wigglytuff[CR] had told us\nright from the start...", french="J'aurais préféré que [CS:N]Grodoudou[CR]\nnous le dise dès le début...", german="Ich wünschte, [CS:N]Knuddeluff[CR] hätte\nuns das gleich gesagt.", italian="Se solo [CS:N]Wigglytuff[CR] ce l'avesse\ndetto subito...", spanish="Preferiría que [CS:N]Wigglytuff[CR] nos\nlo hubiera dicho desde el principio."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I wish [CS:N]Wigglytuff[CR] had told us\nright from the start...", french="J'aurais préféré que [CS:N]Grodoudou[CR]\nnous le dise dès le début...", german="Ich wünschte, [CS:N]Knuddeluff[CR] hätte\nuns das gleich gesagt.", italian="Se solo [CS:N]Wigglytuff[CR] ce l'avesse\ndetto subito...", spanish="Ojalá [CS:N]Wigglytuff[CR] nos lo hubiera\ndicho desde el principio."})
  else
  SkySceneKit.say({english="I wish [CS:N]Wigglytuff[CR] had told us\nright from the start...", french="J'aurais préféré que [CS:N]Grodoudou[CR]\nnous le dise dès le début...", german="Ich wünschte, [CS:N]Knuddeluff[CR] hätte\nuns das gleich gesagt.", italian="Se solo [CS:N]Wigglytuff[CR] ce l'avesse\ndetto subito...", spanish="[CS:N]Wigglytuff[CR] tendría que\nhabérnoslo dicho desde el principio."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The Guildmaster can be rather,\nuh, erratic at times...", french="Il est vrai que le Maître de\nla Guilde peut se montrer... disons... assez\nimprévisible quelquefois...", german="Der Gildenmeister kann\nmanchmal ziemlich, äh, launisch sein.", italian="Il Capitano può essere alquanto,\neh, imprevedibile, a volte...", spanish="El Gran Bluff a veces\npuede ser... esto, impredecible."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Even I can't quite fathom what\ngoes on in his head.", french="Parfois, même moi j'ai du mal\nà comprendre ce qui lui passe par la tête.", german="Selbst ich ahne oft nicht, was in\nseinem Kopf vorgeht.", italian=" Neppure io capisco cosa pensa.", spanish="Ni yo alcanzo a comprender\ncompletamente lo que pasa por su cabeza."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Well, that's too bad for you.", french=" C'est regrettable pour vous.", german="Nun, das ist wirklich schade für\neuch.", italian=" Beh, mi dispiace per voi.", spanish=" Vaya, lo lamento."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Nevertheless, I shall expect your\nbest effort tomorrow! ♪", french="Néanmoins, j'attends que vous\nredoubliez d'efforts dès demain! ♪", german="Nichtsdestotrotz erwarte ich\nmorgen euren vollsten Einsatz! ♪", italian="Ciononostante, mi aspetto che\nfacciate del vostro meglio domani! ♪", spanish="De todas formas, ¡espero\nque mañana sigáis esforzándoos así! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urf...", french=" Arf...", german=" Urf...", italian=" Uff...", spanish=" Uf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urf...", french=" Arf...", german=" Urf...", italian=" Uff...", spanish=" Uf..."})
  else
  SkySceneKit.say({english=" Urf...", french=" Arf...", german=" Urf...", italian=" Uff...", spanish=" Uf..."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
