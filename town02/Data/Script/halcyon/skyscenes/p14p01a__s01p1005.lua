-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P14P01A/s01p1005.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Crystal Cave.ogg", true) end)
  -- back_SetGround(LEVEL_P14P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR] also said this was\nwhere Pokémon would come to evolve...", french="[CS:N]Grodoudou[CR] a aussi dit que\nc'était ici que les Pokémon se rendaient\npour évoluer...", german="[CS:N]Knuddeluff[CR] sagte auch, dass dies\nder Ort sei, den Pokémon für ihre Entwicklung\naufsuchen würden.", italian="[CS:N]Wigglytuff[CR] ha anche detto\nche una volta i Pokémon venivano qui per\nevolversi...", spanish="[CS:N]Wigglytuff[CR] también dijo que\nlos Pokémon solían venir a evolucionar a\neste lugar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR] also said this was\nwhere Pokémon would come to evolve...", french="[CS:N]Grodoudou[CR] a aussi dit que\nc'était ici que les Pokémon se rendaient\npour évoluer...", german="[CS:N]Knuddeluff[CR] sagte auch, dass dies\nder Ort sei, den Pokémon für ihre Entwicklung\naufsuchen würden.", italian="[CS:N]Wigglytuff[CR] ha anche detto\nche una volta i Pokémon venivano qui per\nevolversi...", spanish="[CS:N]Wigglytuff[CR] también dijo que\nlos Pokémon solían venir a evolucionar a\neste lugar..."})
  else
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR] also said this was\nwhere Pokémon would come to evolve...", french="[CS:N]Grodoudou[CR] a aussi dit que\nc'était ici que les Pokémon se rendaient\npour évoluer...", german="[CS:N]Knuddeluff[CR] sagte auch, dass dies\nder Ort sei, den Pokémon für ihre Entwicklung\naufsuchen würden.", italian="[CS:N]Wigglytuff[CR] ha anche detto\nche una volta i Pokémon venivano qui per\nevolversi...", spanish="[CS:N]Wigglytuff[CR] también dijo que\nlos Pokémon solían venir a evolucionar a\neste lugar..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But what is evolution?", french="Mais ça veut dire quoi,\névoluer?", german=" Aber was ist Entwicklung?", italian=" Ma cos'è l'evoluzione?", spanish="Pero, ¿a qué se refería\ncon eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But what is evolution?", french="Mais ça veut dire quoi,\névoluer?", german=" Aber was ist Entwicklung?", italian=" Ma cos'è l'evoluzione?", spanish="Pero, ¿a qué se refería\ncon eso?"})
  else
  SkySceneKit.say({english=" But what is evolution?", french="Mais ça veut dire quoi,\névoluer?", german=" Aber was ist Entwicklung?", italian=" Ma cos'è l'evoluzione?", spanish="Pero, ¿a qué se refería\ncon eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 320, 248, Direction.DownLeft, "NPC_RINGUMA")
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Oh, you don't know what\nevolution is? What it means to evolve?", french="Oh, vous ne savez pas ce que\nsont les évolutions ou ce qu'elles signifient?", german="Oh, du weißt nicht, was\nEntwicklung ist? Was es bedeutet, sich zu\nentwickeln?", italian="Oh, vuoi dire che non sai che\ncos'è l'evoluzione? Cosa significa\nevolversi?", spanish="Ah, ¿pero es que no sabes qué\nes evolucionar? ¿Lo que significa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 288, 248, Direction.Down, "NPC_HIMEGUMA")
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="Some kinds of Pokémon can\nevolve if specific conditions are first met.", french="Certains Pokémon peuvent\névoluer sous certaines conditions très\nspécifiques.", german="Manche Arten von Pokémon\nkönnen sich entwickeln, wenn gewisse\nBedingungen gegeben sind.", italian="Alcuni tipi di Pokémon possono\nevolversi a patto che vengano soddisfatte\nalcune condizioni specifiche.", spanish="Algunos tipos de Pokémon pueden\nevolucionar si reúnen una serie de condiciones."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="When a Pokémon evolves, its\nappearance changes, sometimes dramatically.", french="Quand un Pokémon évolue, son\napparence change, parfois de façon radicale.", german="Wenn ein Pokémon sich\nentwickelt, ändert sich sein Erscheinungsbild -\nmanchmal sogar dramatisch.", italian="Quando un Pokémon si evolve,\nil suo aspetto cambia, a volte in modo radicale.", spanish="Cuando un Pokémon evoluciona,\ncambia su aspecto. A veces, drásticamente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Really?![K] Your appearance\nchanges?!", french="Vraiment?![K] Son apparence\nchange?!", german="Wirklich?!?[K] Deine Erscheinung\nverändert sich?!?", italian=" Davvero?![K] L'aspetto cambia?!", spanish="¡¿En serio?![K] ¡¿Cambia tu\naspecto?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Really?![K] Your appearance\nchanges?!", french="Vraiment?![K] Son apparence\nchange?!", german="Wirklich?!?[K] Deine Erscheinung\nverändert sich?!?", italian=" Davvero?![K] L'aspetto cambia?!", spanish="¡¿En serio?![K] ¡¿Cambia tu\naspecto?!"})
  else
  SkySceneKit.say({english="Really?![K] Your appearance\nchanges?!", french="Vraiment?![K] Son apparence\nchange?!", german="Wirklich?!?[K] Deine Erscheinung\nverändert sich?!?", italian=" Davvero?![K] L'aspetto cambia?!", spanish="¡¿Ah, sí?![K] ¡¿Cambia tu\naspecto?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" That's right.", french=" C'est exact.", german=" So ist es.", italian=" Proprio così.", spanish=" Efectivamente."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="And it may not just be how you\nlook that changes, either.", french="Et ce n'est pas seulement\nl'apparence.", german="Und es kann sich auch nicht nur\ndein Aussehen verändern.", italian="E a volte non cambia solo\nquello.", spanish=" Y no solo cambia tu aspecto."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="When you evolve, sometimes\nyour form and abilities can even change.\nHow about that?", french="Quand on évolue, le type et les\naptitudes peuvent changer aussi. Incroyable,\nnon?", german="Wenn du dich entwickelst,\nändern sich manchmal auch deine Form und\ndeine Fähigkeiten. Was sagst du dazu?", italian="Quando ci si evolve, possono\ncambiare anche le caratteristiche.\nNon lo sapevate?", spanish="Al evolucionar, incluso pueden\nmejorar las habilidades. ¿Qué os parece?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" R-really?!", french=" Vraiment?!", german=" E-echt?!?", italian=" D-Davvero?!", spanish=" ¿En... En serio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" R-really?!", french=" Vraiment?!", german=" E-echt?!?", italian=" D-Davvero?!", spanish=" ¿En... En serio?"})
  else
  SkySceneKit.say({english=" R-really?!", french=" Vraiment?!", german=" E-echt?!?", italian=" D-Davvero?!", spanish=" ¿En... En serio?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Yup!", french=" Oui!", german=" Jep!", italian=" Sì!", spanish=" ¡Sí!"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" I've wanted to get stronger.", french="J'ai toujours voulu être plus\nforte.", german="Ich wollte schon immer stärker\nwerden.", italian=" Voglio diventare più forte.", spanish=" Yo quería ser más fuerte."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="So I've been hoping to evolve\nfor a long time.", french="Je voulais évoluer depuis\nlongtemps.", german="Also habe ich seit Langem\ngehofft, mich zu entwickeln.", italian="Quindi è da tanto tempo che\nspero di riuscire a evolvermi.", spanish="Y llevo mucho tiempo esperando\nevolucionar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_himeguma, npc_npc_ringuma, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ringuma, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" I'll try it out right away.", french=" Je vais essayer dès maintenant.", german=" Ich probiere das sofort aus.", italian=" Voglio provarci subito.", spanish=" Lo voy a intentar ahora mismo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_himeguma, 300, 208, false, 2)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_himeguma, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="[CN]Those that seek awakening...", french="[CN]Quiconque cherche l'éveil...", german="[CN]Jene, die erwachen wollen...", italian="[CN]Coloro che vogliono rinascere...", spanish="[CN]Aquellos que buscan despertar..."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="[CN]This is [CS:P]Luminous Spring[CR].[K]\n[CN]Do you seek to evolve?", french="[CN]Je suis la [CS:P]Source Lumineuse[CR].[K]\n[CN]Désires-tu évoluer?", german="[CN]Dies ist die [CS:P]Glitzerquelle[CR].[K]\n[CN]Möchtest du dich entwickeln?", italian="[CN]Questa è la [CS:P]Sorgente Luccichio[CR].[K]\n[CN]Desideri evolverti?", spanish="[CN]Este es el [CS:P]Manantial Luminoso[CR].[K]\n[CN]¿Quieres evolucionar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Yup! Please!", french=" Oui! S'il vous plaît!", german=" Jawohl! Bitte!", italian=" Sì, per favore!", spanish=" ¡Sí! ¡Por favor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="[CN]Do you need an item to do so?", french="[CN]As-tu besoin d'un objet à cette fin?", german="[CN]Benötigst du dazu ein Item?", italian="[CN]È necessario uno strumento per la\n[CN]tua evoluzione?", spanish="[CN]¿Necesitas un objeto para evolucionar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Nope! I don't need one!", french=" Non! Je n'en ai pas besoin!", german=" Nein! Ich brauche keins!", italian=" No! Non ne ho bisogno!", spanish=" ¡No! ¡No necesito ningún objeto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="[CN]So be it...", french="[CN]Qu'il en soit ainsi...", german="[CN]So sei es...", italian="[CN]Così sia...", spanish="[CN]Que así sea..."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="[CN]Seeker of awakening...[K]\n[CN]Let us begin.", french="[CN]Toi qui cherches l'éveil...[K]\n[CN]Commençons.", german="[CN]Du, der du erwachen willst...[K]\n[CN]Lass uns beginnen.", italian="[CN]Tu che aspiri a rinascere...[K]\n[CN]Preparati.", spanish="[CN]Tú que buscas despertar...[K]\n[CN]Comencemos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetOutputAttribute(32) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="[CN]Something is happening...[K]to [CS:N]Teddiursa[CR]...", french="[CN]Quelque chose arrive...[K] à [CS:N]Teddiursa[CR]...", german="[CN]Etwas geschieht mit [K][CS:N]Teddiursa[CR]...", italian="[CN]Sta succedendo qualcosa...[K] a [CS:N]Teddiursa[CR]...", spanish="[CN]Algo está pasando con... [K][CS:N]Teddiursa[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="[CN][CS:N]Teddiursa[CR]'s appearance is changing...", french="[CN]L'apparence de [CS:N]Teddiursa[CR]\n[CN]est en train de changer...", german="[CN]Die Erscheinung von [CS:N]Teddiursa[CR] verändert sich.", italian="[CN]L'aspetto di [CS:N]Teddiursa[CR] sta cambiando...", spanish="[CN]El aspecto de [CS:N]Teddiursa[CR] ha cambiado..."})
  -- message_Close
  -- GAP: se_Play(5135) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/Promotion") end) -- me_Play(8) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="[CN][CS:N]Teddiursa[CR] evolved into [CS:N]Ursaring[CR]!", french="[CN][CS:N]Teddiursa[CR] a évolué en [CS:N]Ursaring[CR]!", german="[CN][CS:N]Teddiursa[CR] hat sich zu [CS:N]Ursaring[CR] entwickelt!", italian="[CN][CS:N]Teddiursa[CR] si evolve in [CS:N]Ursaring[CR]!", spanish="[CN]¡[CS:N]Teddiursa[CR] ha evolucionado a [CS:N]Ursaring[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa![K] [CS:N]Teddiursa[CR] looks just like\n[CS:N]Ursaring[CR] now!", french="Ouah![K] [CS:N]Teddiursa[CR] ressemble\nvraiment à [CS:N]Ursaring[CR] maintenant!", german="Holla![K] [CS:N]Teddiursa[CR] sieht jetzt\ngenauso wie [CS:N]Ursaring[CR] aus!", italian="Wow![K] Adesso [CS:N]Teddiursa[CR] è\nuguale a [CS:N]Ursaring[CR]!", spanish="¡Vaya![K] ¡[CS:N]Teddiursa[CR] ahora es\nigualita a [CS:N]Ursaring[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Waah![K] [CS:N]Teddiursa[CR] looks just like\n[CS:N]Ursaring[CR] now!", french="Ouah![K] [CS:N]Teddiursa[CR] ressemble\nvraiment à [CS:N]Ursaring[CR] maintenant!", german="Uaah![K] [CS:N]Teddiursa[CR] sieht jetzt\ngenauso wie [CS:N]Ursaring[CR] aus!", italian="Wow![K] Adesso [CS:N]Teddiursa[CR] è\nuguale a [CS:N]Ursaring[CR]!", spanish="¡Mira![K] ¡[CS:N]Teddiursa[CR] ahora es\nigualita a [CS:N]Ursaring[CR]!"})
  else
  SkySceneKit.say({english="Waah![K] [CS:N]Teddiursa[CR] looks just like\n[CS:N]Ursaring[CR] now!", french="Ouah![K] [CS:N]Teddiursa[CR] ressemble\nvraiment à [CS:N]Ursaring[CR] maintenant!", german="Uaah![K] [CS:N]Teddiursa[CR] sieht jetzt\ngenauso wie [CS:N]Ursaring[CR] aus!", italian="Wow![K] Adesso [CS:N]Teddiursa[CR] è\nuguale a [CS:N]Ursaring[CR]!", spanish="¡Vaya![K] ¡[CS:N]Teddiursa[CR] ahora es\nigualita a [CS:N]Ursaring[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_ringuma2 = SkySceneKit.spawn_npc("ursaring", 304, 208, Direction.Down, "NPC_RINGUMA2")
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Yay!", french=" Ouais!", german=" Jaaa!", italian=" Sì!", spanish=" ¡Estupendo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_ringuma2, 284, 244, false, 2)
  GROUND:EntTurn(npc_npc_ringuma2, Direction.Right)
  GROUND:EntTurn(npc_npc_ringuma, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Crystal Cave.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Hey, [CS:N]Ursaring[CR]![K] I've evolved!", french="Hé, [CS:N]Ursaring[CR]?[K]\nJ'ai évolué!", german="Hey, [CS:N]Ursaring[CR]?[K] Ich habe mich\nentwickelt!", italian="Ehi, [CS:N]Ursaring[CR]![K]\nMi sono evoluta!", spanish="Eh, ¡mira, [CS:N]Ursaring[CR]![K]\n¡He evolucionado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Congratulations![K] All the leveling\nup you went through finally paid off!", french="Félicitations![K] Tu vois,\ntes augmentations de niveau ont fini par\nporter leurs fruits!", german="Herzlichen Glückwunsch![K] All die\nLevelaufstiege, die du erreicht hast, haben\nsich endlich ausgezahlt!", italian="Congratulazioni![K] Finalmente\ntutti gli sforzi che hai fatto per salire di\nlivello si sono rivelati utili!", spanish="¡Felicidades![K] ¡Al final ha dado\nsus frutos el subir de nivel!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Now it's hard to tell us apart...", french="Maintenant, c'est difficile\nde nous différencier...", german="Jetzt kann man uns nur schwer\nauseinanderhalten...", italian="Anche se adesso è difficile\ndistinguerci...", spanish=" Ahora cuesta diferenciarnos..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" But good for you!", french=" Mais tant mieux pour toi!", german="Ich freue mich trotzdem für\ndich!", italian=" ... sono comunque felice per te!", spanish=" ¡Pero me alegro por ti!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We should try evolving too,\n[hero]!", french="Nous aussi, on devrait essayer\nd'évoluer, [hero]!", german="Wir sollten auch versuchen, uns\nzu entwickeln, [hero]!", italian="Anche noi dovremmo provare ad\nevolverci, [hero]!", spanish="¡Deberíamos intentar evolucionar\ntambién, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's try evolving too,\n[hero]!", french="Nous aussi, on devrait essayer\nd'évoluer, [hero]!", german="Entwickeln wir uns doch auch,\n[hero]!", italian="Anche noi dovremmo provare ad\nevolverci, [hero]!", spanish="¡Deberíamos intentar evolucionar\ntambién, [hero]!"})
  else
  SkySceneKit.say({english="We should try evolving too,\n[hero]!", french="Nous aussi, on devrait essayer\nd'évoluer, [hero]!", german="Wir sollten auch versuchen, uns\nzu entwickeln, [hero]!", italian="Anche noi dovremmo provare ad\nevolverci, [hero]!", spanish="¡Deberíamos intentar evolucionar\ntambién, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_ringuma, Direction.Down)
  GROUND:EntTurn(npc_npc_ringuma2, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'll try first, OK?", french=" J'y vais en premier, d'accord?", german=" Ich versuche es zuerst, okay?", italian=" Vado prima io, va bene?", spanish=" ¿Yo primero, vale?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'll try first.", french=" J'y vais en premier, d'accord?", german=" Ich versuche es zuerst.", italian=" Vado prima io, va bene?", spanish=" ¿Yo primero, vale?"})
  else
  SkySceneKit.say({english=" I'll try it first.", french=" J'y vais en premier, d'accord?", german=" Ich versuche es zuerst.", italian=" Vado prima io, va bene?", spanish="Pero iré yo en primer lugar,\n¿vale?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 300, 208, false, 2)
  GAME:WaitFrames(7)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-24), p.Y+(0), false, 2) end
  do local p=npc_npc_ringuma.Position; GROUND:MoveToPosition(npc_npc_ringuma, p.X+(16), p.Y+(0), false, 2) end
  do local p=npc_npc_ringuma2.Position; GROUND:MoveToPosition(npc_npc_ringuma2, p.X+(-16), p.Y+(0), false, 2) end
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_ringuma2, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Those that seek awakening...", french="[CN]Quiconque cherche l'éveil...", german="[CN]Jene, die erwachen wollen...", italian="[CN]Coloro che vogliono rinascere...", spanish="[CN]Aquellos que buscan despertar..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]This is [CS:P]Luminous Spring[CR].[K]\n[CN]Do you seek to evolve?", french="[CN]Je suis la [CS:P]Source Lumineuse[CR].[K]\n[CN]Désires-tu évoluer?", german="[CN]Dies ist die [CS:P]Glitzerquelle[CR].[K]\n[CN]Möchtest du dich entwickeln?", italian="[CN]Questa è la [CS:P]Sorgente Luccichio[CR].[K]\n[CN]Desideri evolverti?", spanish="[CN]Este es el [CS:P]Manantial Luminoso[CR].[K]\n[CN]¿Quieres evolucionar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yep! I want to evolve!", french=" Oui! Je veux évoluer!", german=" Ja! Ich will mich entwickeln!", italian=" Sì! Voglio evolvermi!", spanish=" ¡Sí! ¡Quiero evolucionar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes! I want to evolve!", french=" Oui! Je veux évoluer!", german=" Ja! Ich will mich entwickeln!", italian=" Sì! Voglio evolvermi!", spanish=" ¡Sí! ¡Quiero evolucionar!"})
  else
  SkySceneKit.say({english=" Yes! I want to evolve!", french=" Oui! Je veux évoluer!", german=" Ja! Ich will mich entwickeln!", italian=" Sì! Voglio evolvermi!", spanish=" ¡Sí! ¡Quiero evolucionar!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Please! Oh, this is exciting!", french="Oui, s'il vous plaît! Ooh, je suis\nsi impatient!", german=" Ja bitte! Oh, wie aufregend!", italian="Sì, per favore!\nOh, com'è emozionante!", spanish="¡Sí, por favor!\n(¡Qué emocionante!)"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Please! Oh, this is exciting!", french="Oui, s'il vous plaît! Ooh, je suis\nsi impatient!", german=" Ja bitte! Oh, wie aufregend!", italian="Sì, per favore!\nOh, com'è emozionante!", spanish="¡Sí, por favor!\n(¡Qué emocionante!)"})
  else
  SkySceneKit.say({english=" Please! Oh, this is exciting!", french="Oui, s'il vous plaît! Ooh, je suis\nsi impatiente!", german=" Ja bitte! Oh, wie aufregend!", italian="Sì, per favore!\nOh, com'è emozionante!", spanish="¡Sí, por favor!\n(¡Qué emocionante!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Do you need an item to do so?", french="[CN]As-tu besoin d'un objet à cette fin?", german="[CN]Benötigst du dazu ein Item?", italian="[CN]È necessario uno strumento per la\n[CN]tua evoluzione?", spanish="[CN]¿Necesitas un objeto para evolucionar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" An item?[K] ...I don't know...", french=" Un objet?[K] ... Je ne sais pas...", german=" Ein Item?[K] Ich weiß nicht...", italian=" Uno strumento?[K] Non lo so...", spanish=" ¿Un objeto?[K] No lo sé..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" An item?[K] ...I don't know...", french=" Un objet?[K] ... Je ne sais pas...", german=" Ein Item?[K] Ich weiß nicht...", italian=" Uno strumento?[K] Non lo so...", spanish="¿Un objeto?[K] No sé a qué te\nrefieres..."})
  else
  SkySceneKit.say({english=" An item?[K] ...I don't know...", french=" Un objet?[K] ... Je ne sais pas...", german=" Ein Item?[K] Ich weiß nicht...", italian=" Uno strumento?[K] Non lo so...", spanish=" ¿Un objeto?[K] No entiendo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh, no. I don't need one.", french=" Euh, non. Je n'en ai pas besoin.", german=" Äh, nein. Ich brauche keins.", italian=" Eh, no. Non ne ho bisogno.", spanish="Esto... no. No necesito ningún\nobjeto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Um, no. No item for me.", french=" Euh, non. Je n'en ai pas besoin.", german=" Äh, nein. Kein Item für mich.", italian=" Eh, no. Non ne ho bisogno.", spanish="Esto... no. No necesito ningún\nobjeto."})
  else
  SkySceneKit.say({english=" Um, no. I don't need an item.", french=" Euh, non. Je n'en ai pas besoin.", german=" Äh, nein. Ich brauche kein Item.", italian=" Eh, no. Non ne ho bisogno.", spanish="Eh... no. No necesito ningún\nobjeto."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]So be it...", french="[CN]Qu'il en soit ainsi...", german="[CN]So sei es...", italian="[CN]Così sia...", spanish="[CN]Que así sea..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Seeker of awakening...[K]\n[CN]Let us begin.", french="[CN]Toi qui cherches l'éveil...[K]\n[CN]Commençons.", german="[CN]Du, der du erwachen willst...[K]\n[CN]Lass uns beginnen.", italian="[CN]Tu che aspiri a rinascere...[K]\n[CN]Preparati.", spanish="[CN]Tú que buscas despertar...[K]\n[CN]Comencemos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(120)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]....................................", french="[CN]....................................", german="[CN]....................................", italian="[CN]....................................", spanish="[CN]..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]No.[K] Impossible...\n[CN]You may not evolve.", french="[CN]Non.[K] Impossible...\n[CN]Tu ne peux évoluer.", german="[CN]Nein.[K] Unmöglich...\n[CN]Du kannst dich nicht entwickeln.", italian="[CN]No.[K] Impossibile...\n[CN]Non puoi evolverti.", spanish="[CN]No.[K] Imposible...\n[CN]No puedes evolucionar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma2, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? Why not?!", french=" Hein? Et pourquoi pas?!", german=" Warum nicht?!?", italian=" Eh? Perché no?!", spanish=" ¿Qué? ¡¿Por qué no?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? Why not?!", french=" Hein? Et pourquoi pas?!", german=" Was? Warum nicht?!?", italian=" Eh? Perché no?!", spanish=" ¿Qué? ¡¿Por qué no?!"})
  else
  SkySceneKit.say({english=" What? Why not?!", french=" Hein? Et pourquoi pas?!", german=" Was? Warum nicht?!?", italian=" Eh? Perché no?!", spanish=" ¿Cómo? ¡¿Por qué no?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Why can't I evolve?", french="Pourquoi je ne peux pas\névoluer?!", german="Warum kann ich mich nicht\nentwickeln?", italian=" Perché non posso evolvermi?", spanish=" ¿Por qué no puedo evolucionar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Why can't I evolve?", french="Pourquoi je ne peux pas\névoluer?!", german="Warum kann ich mich nicht\nentwickeln?", italian=" Perché non posso evolvermi?", spanish=" ¿Por qué no puedo evolucionar?"})
  else
  SkySceneKit.say({english=" Why can't I evolve?", french="Pourquoi je ne peux pas\névoluer?!", german="Warum kann ich mich nicht\nentwickeln?", italian=" Perché non posso evolvermi?", spanish=" ¿Por qué no puedo evolucionar?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is it maybe because I haven't\nmet my requirements for evolving?", french="Peut-être que je ne remplis\npas les conditions pour évoluer?", german="Habe ich vielleicht noch nicht die\nVoraussetzungen für meine Entwicklung\ngeschaffen?", italian="Forse perché non soddisfo\ni requisiti per l'evoluzione?", spanish="¿Es que no cumplo los\nrequisitos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is it maybe because I haven't\nmet my requirements for evolving?", french="Peut-être que je ne remplis\npas les conditions pour évoluer?", german="Habe ich vielleicht noch nicht die\nVoraussetzungen für meine Entwicklung\ngeschaffen?", italian="Forse perché non soddisfo\ni requisiti per l'evoluzione?", spanish="¿Es que no cumplo los\nrequisitos?"})
  else
  SkySceneKit.say({english="Is it maybe because I haven't\nmet my requirements for evolving?", french="Peut-être que je ne remplis\npas les conditions pour évoluer?", german="Habe ich vielleicht noch nicht die\nVoraussetzungen für meine Entwicklung\ngeschaffen?", italian="Forse perché non soddisfo\ni requisiti per l'evoluzione?", spanish="¿Es que no cumplo los\nrequisitos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]No.[K] That is not it...", french="[CN]Non.[K] Ce n'est pas cela...", german="[CN]Nein.[K] Das ist es nicht...", italian="[CN]No.[K] Non è per quello...", spanish="[CN]No.[K] No es eso..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]It is not merely a problem\n[CN]of not meeting requirements...", french="[CN]Il ne suffit point de remplir\n[CN]quelque condition...", german="[CN]Das Problem hat nichts mit den\n[CN]Voraussetzungen für die Entwicklung zu tun...", italian="[CN]Non è solo un problema relativo\n[CN]alla mancanza dei requisiti...", spanish="[CN]No se trata de cumplir\n[CN]los requisitos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Then, why?", french=" Alors, pourquoi?", german=" Warum klappt es dann nicht?", italian=" Allora perché?", spanish=" ¿Y entonces?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Then, why?", french=" Alors, pourquoi?", german=" Warum klappt es dann nicht?", italian=" Allora perché?", spanish=" ¿Y entonces?"})
  else
  SkySceneKit.say({english=" Then, why?", french=" Alors, pourquoi?", german=" Warum klappt es dann nicht?", italian=" Allora perché?", spanish=" ¿Y entonces?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Teddiursa[CR] was able to evolve...", french=" [CS:N]Teddiursa[CR] a pu évoluer...", german="[CS:N]Teddiursa[CR] konnte sich\nentwickeln...", italian=" [CS:N]Teddiursa[CR] si è potuta evolvere...", spanish="[CS:N]Teddiursa[CR] sí que ha podido\nevolucionar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Teddiursa[CR] was able to evolve...", french=" [CS:N]Teddiursa[CR] a pu évoluer...", german="[CS:N]Teddiursa[CR] konnte sich\nentwickeln...", italian=" [CS:N]Teddiursa[CR] si è potuta evolvere...", spanish="[CS:N]Teddiursa[CR] sí que ha podido\nevolucionar..."})
  else
  SkySceneKit.say({english=" [CS:N]Teddiursa[CR] was able to evolve...", french=" [CS:N]Teddiursa[CR] a pu évoluer...", german="[CS:N]Teddiursa[CR] konnte sich\nentwickeln...", italian=" [CS:N]Teddiursa[CR] si è potuta evolvere...", spanish="[CS:N]Teddiursa[CR] sí que ha podido\nevolucionar..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Why can't I evolve?", french="Pourquoi je ne peux pas\névoluer?", german="Warum kann ich mich nicht\nentwickeln?", italian=" Perché io non posso?", spanish="¿Por qué yo no puedo\nevolucionar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Why can't I evolve?", french="Pourquoi je ne peux pas\névoluer?", german="Warum kann ich mich nicht\nentwickeln?", italian=" Perché io non posso?", spanish="¿Por qué yo no puedo\nevolucionar?"})
  else
  SkySceneKit.say({english=" Why can't I evolve?", french="Pourquoi je ne peux pas\névoluer?", german="Warum kann ich mich nicht\nentwickeln?", italian=" Perché io non posso?", spanish="¿Por qué yo no puedo\nevolucionar?"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Why can you not evolve...?", french="[CN]Pourquoi ne peux-tu pas évoluer...?", german="[CN]Warum du dich nicht entwickeln kannst?", italian="[CN]Perché non puoi evolverti?", spanish="[CN]¿Que por qué no puedes evolucionar tú?"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]It may be influenced by a distortion\n[CN]in the fabric of space...", french="[CN]Peut-être est-ce dû à une distorsion\n[CN]dans la trame de l'espace...", german="[CN]Vielleicht hat die Verzerrung des\n[CN]Raumgefüges etwas damit zu tun...", italian="[CN]Potrebbe essere dovuto a una\n[CN]distorsione della struttura dello spazio...", spanish="[CN]Podría deberse a\n[CN]una deformación del espacio..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Distortion?[K] The fabric of space?", french="Une distorsion?[K] Dans la trame\nde l'espace?", german=" Verzerrung?[K] Das Raumgefüge?", italian="Distorsione?[K] Della struttura\ndello spazio?", spanish=" ¿Deformación?[K] ¿Del espacio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Distortion?[K] The fabric of space?", french="Une distorsion?[K] Dans la trame\nde l'espace?", german=" Verzerrung?[K] Das Raumgefüge?", italian="Distorsione?[K] Della struttura\ndello spazio?", spanish=" ¿Deformación?[K] ¿Del espacio?"})
  else
  SkySceneKit.say({english=" Distortion?[K] The fabric of space?", french="Une distorsion?[K] Dans la trame\nde l'espace?", german=" Verzerrung?[K] Das Raumgefüge?", italian="Distorsione?[K] Della struttura\ndello spazio?", spanish=" ¿Deformación?[K] ¿Del espacio?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Why that should be, I do not know...", french="[CN]Quelle en est la cause, je l'ignore...", german="[CN]Ich weiß nicht, warum das so sein könnte...", italian="[CN]Il motivo, non lo conosco...", spanish="[CN]No sé por qué..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]But your presence...[K]is somehow related\n[CN]to the distortion of space itself.", french="[CN]Mais ta présence...[K] est liée\n[CN]à la distorsion elle-même.", german="[CN]Aber deine Existenz...[K] Sie hängt\n[CN]irgendwie mit der Verzerrung des Raumes\n[CN]selbst zusammen.", italian="[CN]Tuttavia, la tua presenza...[K] è in qualche modo\n[CN]collegata alla distorsione dello spazio.", spanish="[CN]Pero tu presencia...[K] está de algún modo\n[CN]relacionada con la deformación del espacio."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]And as a result of that,\n[CN]you cannot evolve...", french="[CN]Il en résulte que\n[CN]tu ne peux évoluer...", german="[CN]Und als Folge daraus\n[CN]kannst du dich nicht entwickeln...", italian="[CN]Di conseguenza,\n[CN]non puoi evolverti...", spanish="[CN]Y por eso...\n[CN]no puedes evolucionar."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]No.[K] It is not only you...[K]\n[CN]There is yet another...", french="[CN]Non.[K] Pas seulement toi...[K]\n[CN]Il y a encore quelqu'un d'autre...", german="[CN]Nein.[K] Es trifft nicht nur dich...[K]\n[CN]Es gibt noch ein anderes Pokémon...", italian="[CN]No.[K] Non sei solo tu.[K]\n[CN]C'è un altro Pokémon...", spanish="[CN]Y...[K] no solo tú...[K]\n[CN]Hay alguien más..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]The one behind you...[K]is also\n[CN]forbidden its evolution.", french="[CN]Le Pokémon derrière toi...[K] est\n[CN]également interdit d'évolution.", german="[CN]Das Pokémon hinter dir...[K] Auch ihm\n[CN]bleibt eine Entwicklung versagt.", italian="[CN]Quello dietro di te...[K] anche a quel Pokémon\n[CN]l'evoluzione è preclusa.", spanish="[CN]Detrás de ti...[K] Ese Pokémon\n[CN]tampoco puede evolucionar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma2, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_ringuma, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_ringuma2, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?! [hero] too?!", french=" Hein?! [hero] aussi?!", german=" Huch?!? [hero] auch?!?", italian=" Eh?! Anche [hero]?!", spanish="¡¿Quéee?! ¿[hero]\ntampoco?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! [hero] too?!", french=" Hein?! [hero] aussi?!", german=" Was?!? [hero] auch?!?", italian=" Cosa?! Anche [hero]?!", spanish="¡¿Quéee?! ¿[hero]\ntampoco?"})
  else
  SkySceneKit.say({english=" What?! [hero] too?!", french=" Hein?! [hero] aussi?!", german=" Was?!? [hero] auch?!?", italian=" Cosa?! Anche [hero]?!", spanish="¡¿Quéee?! ¿[hero]\ntampoco?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What...[K]me too?)", french="(Quoi...[K] moi aussi?)", german="(Was...[K] Mir auch?)", italian="(Cosa...[K] anche io?)", spanish="(¿Cómo?[K] ¿Yo tampoco?)"})
  else
  SkySceneKit.say({english="(What...[K]me too?)", french="(Quoi...[K] moi aussi?)", german="(Was...[K] Mir auch?)", italian="(Cosa...[K] anche io?)", spanish="(¿Cómo?[K] ¿Yo tampoco?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]That is all that I can tell...", french="[CN]Je n'en sais pas plus...", german="[CN]Das ist alles, was ich erkennen kann...", italian="[CN]È tutto quello che posso dirvi...", spanish="[CN]Es todo cuanto puedo decir..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]This is [CS:P]Luminous Spring[CR].[K]\n[CN]If you seek new evolution,\n[CN]then you shall return...", french="[CN]Je suis la [CS:P]Source Lumineuse[CR].[K]\n[CN]Si tu désires évoluer, alors\n[CN]tu reviendras en ce lieu...", german="[CN]Dies ist die [CS:P]Glitzerquelle[CR].[K]\n[CN]Falls du weitere Entwicklung suchst,\n[CN]so kehre zurück...", italian="[CN]Questa è la [CS:P]Sorgente Luccichio[CR].[K]\n[CN]Colui che desidera una nuova evoluzione\n[CN]dovrà fare ritorno...", spanish="[CN]El [CS:P]Manantial Luminoso[CR] ha hablado.[K]\n[CN]Si queréis evolucionar,\n[CN]regresad..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5125) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- back_ChangeGround(LEVEL_P14P01A2) [décor déjà chargé par EnterZone PMDO]
  GAME:WaitFrames(60)
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I guess it's not just me...", french=" Ce n'est pas seulement moi...", german=" Ich bin wohl nicht der Einzige...", italian=" Non riguarda solo me...", spanish=" Al parecer, no soy solo yo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Looks like it's not just me...", french=" Ce n'est pas seulement moi...", german=" Ich bin wohl nicht der Einzige...", italian=" Non riguarda solo me...", spanish=" Al parecer, no soy solo yo..."})
  else
  SkySceneKit.say({english=" Looks like it's not just me...", french=" Ce n'est pas seulement moi...", german=" Ich bin wohl nicht die Einzige...", italian=" Non riguarda solo me...", spanish=" Al parecer, no soy solo yo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I guess you can't evolve, either,\n[hero].", french="Tu ne peux pas évoluer non plus,\n[hero].", german="Ich nehme an, du kannst dich\nauch nicht entwickeln, [hero].", italian="Hai visto, neanche tu puoi\nevolverti, [hero].", spanish="Parece que tú tampoco puedes\nevolucionar, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess you can't evolve, either,\n[hero].", french="Tu ne peux pas évoluer non plus,\n[hero].", german="Ich nehme an, du kannst dich\nauch nicht entwickeln, [hero].", italian="Hai visto, neanche tu puoi\nevolverti, [hero].", spanish="Parece que tú tampoco puedes\nevolucionar, [hero]."})
  else
  SkySceneKit.say({english="You can't evolve, either,\n[hero].", french="Tu ne peux pas évoluer non plus,\n[hero].", german="Ich nehme an, du kannst dich\nauch nicht entwickeln, [hero].", italian="Hai visto, neanche tu puoi\nevolverti, [hero].", spanish="Tú tampoco puedes evolucionar,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't get why we're not\nallowed to evolve, though.", french="Mais je ne comprends pas\npourquoi nous ne pouvons pas évoluer.", german="Ich kapiere nicht, warum uns die\nEntwicklung versagt bleibt.", italian="Però non capisco proprio perché\na noi non è permesso.", spanish=" Aunque no sé por qué."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't understand why we can't\nevolve, though.", french="Mais je ne comprends pas\npourquoi nous ne pouvons pas évoluer.", german="Ich verstehe nicht, warum uns\ndie Entwicklung versagt bleibt.", italian="Però non capisco proprio perché\na noi non è permesso.", spanish=" Aunque no sé por qué."})
  else
  SkySceneKit.say({english="I don't understand why we're not\nallowed to evolve, though.", french="Mais je ne comprends pas\npourquoi nous ne pouvons pas évoluer.", german="Ich verstehe nicht, warum uns\ndie Entwicklung versagt bleibt.", italian="Però non capisco proprio perché\na noi non è permesso.", spanish=" Aunque no sé por qué."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Anyway, we have the Perfect\nApple that was in the treasure box.", french="Quoi qu'il en soit, nous avons la\nPomme Parfaite qui était dans le Coffre au\nTrésor.", german="Na ja, immerhin haben wir den\nPerfekten Apfel, der sich in der Schatzbox\nbefand.", italian="Ad ogni modo, abbiamo la Mela\nPerfetta che si trovava nel forziere.", spanish="De todos modos tenemos la\nManzana Perfecta que había en el cofre\ndel tesoro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Anyway, we have the Perfect\nApple that was in the treasure box.", french="Quoi qu'il en soit, nous avons la\nPomme Parfaite qui était dans le Coffre au\nTrésor.", german="Na ja, immerhin haben wir den\nPerfekten Apfel, der sich in der Schatzbox\nbefand.", italian="Ad ogni modo, abbiamo la Mela\nPerfetta che si trovava nel forziere.", spanish="De todos modos tenemos la\nManzana Perfecta que había en el cofre\ndel tesoro."})
  else
  SkySceneKit.say({english="Anyway, we have the Perfect\nApple that was in the treasure box.", french="Quoi qu'il en soit, nous avons la\nPomme Parfaite qui était dans le Coffre au\nTrésor.", german="Na ja, immerhin haben wir den\nPerfekten Apfel, der sich in der Schatzbox\nbefand.", italian="Ad ogni modo, abbiamo la Mela\nPerfetta che si trovava nel forziere.", spanish="De todos modos tenemos la\nManzana Perfecta que había en el cofre\ndel tesoro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's take it back to the guild.", french=" Rapportons-la à la Guilde.", german="Lass ihn uns mit zur Gilde\nnehmen.", italian=" Riportiamola alla Gilda.", spanish=" Llevémosla al [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should go back to the guild\nwith it.", french=" Rapportons-la à la Guilde.", german="Wir sollten damit zur Gilde\nzurückkehren.", italian=" Riportiamola alla Gilda.", spanish=" Regresemos al [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english=" Let's go back to the guild with it.", french=" Rapportons-la à la Guilde.", german="Lass uns mit dem Perfekten\nApfel zurück zur Gilde gehen.", italian=" Riportiamola alla Gilda.", spanish=" Llevémosla al [CS:N]Pokégremio[CR]."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
