-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/s03p0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'US03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(17) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 496, 248, Direction.DownLeft, "NPC_MANAFI")
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...And that's why we're here.", french="... Et c'est pour ça que nous\nsommes là.", german=" ...Und darum sind wir hier.", italian=" ... Ed ecco perché siamo qui.", spanish=" Y por eso estamos aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...And so we came to see you.", french="... Et c'est pour ça que nous\nsommes là.", german="...Und deshalb sind wir zu dir\ngekommen.", italian=" ... Ed ecco perché siamo qui.", spanish=" Y por eso estamos aquí."})
  else
  SkySceneKit.say({english=" ...And that's why we're here.", french="... Et c'est pour ça que nous\nsommes là.", german=" ...Und darum sind wir hier.", italian=" ... Ed ecco perché siamo qui.", spanish=" Y por eso estamos aquí."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Do you have any idea what kind\nof Pokémon this little guy is, [CS:N]Chatot[CR]?", french="As-tu une idée sur l'espèce de\nce Pokémon, [CS:N]Pijako[CR]?", german="Hast du irgendeine Ahnung, was\nfür eine Art Pokémon dieses kleine Kerlchen\nist, [CS:N]Plaudagei[CR]?", italian="Sai dirci di che specie di\nPokémon si tratta, [CS:N]Chatot[CR]?", spanish="¿Tienes idea de qué tipo de\nPokémon puede ser, [CS:N]Chatot[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Do you have any idea what kind\nof Pokémon this little guy is, [CS:N]Chatot[CR]?", french="As-tu une idée sur l'espèce de\nce Pokémon, [CS:N]Pijako[CR]?", german="Hast du irgendeine Ahnung, was\nfür eine Art Pokémon dieses kleine Kerlchen\nist, [CS:N]Plaudagei[CR]?", italian="Sai dirci di che specie di\nPokémon si tratta, [CS:N]Chatot[CR]?", spanish="¿Tienes idea de qué tipo de\nPokémon puede ser, [CS:N]Chatot[CR]?"})
  else
  SkySceneKit.say({english="Do you have any idea what kind\nof Pokémon this little guy is, [CS:N]Chatot[CR]?", french="As-tu une idée sur l'espèce de\nce Pokémon, [CS:N]Pijako[CR]?", german="Hast du irgendeine Ahnung, was\nfür eine Art Pokémon dieses kleine Kerlchen\nist, [CS:N]Plaudagei[CR]?", italian="Sai dirci di che specie di\nPokémon si tratta, [CS:N]Chatot[CR]?", spanish="¿Tienes idea de qué tipo de\nPokémon puede ser, [CS:N]Chatot[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 464, 232, Direction.DownRight, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hmm...[K] Well, to be honest, this\nis the first time I've actually seen a Pokémon\nof this sort.", french="Hum...[K] Eh bien, pour être\nhonnête, c'est la première fois que je vois un\nPokémon de ce genre.", german="Hmm...[K] Um ehrlich zu sein,\ndas ist das erste Mal, dass ich ein Pokémon\ndieser Art zu sehen bekomme.", italian="Mmm...[K] Beh, a dire la verità, è\nla prima volta che vedo un Pokémon\ndel genere.", spanish="Hum...[K] Para serte sincero, es\nla primera vez que veo un Pokémon así."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But judging from what you've\ntold me...[K] This youngster appears to be a\nPokémon named [CS:N]Manaphy[CR].", french="Mais d'après ce que vous m'avez\ndit...[K] Ce petit pourrait être un Pokémon appelé\n[CS:N]Manaphy[CR].", german="Aber nach dem, was ihr mir\nerzählt habt...[K] Dieser Jungspund scheint ein\nPokémon namens [CS:N]Manaphy[CR] zu sein.", italian="Ma da quello che mi avete\ndetto,[K] questo piccolo potrebbe essere un\nPokémon chiamato [CS:N]Manaphy[CR].", spanish="Por lo que me habéis contado...[K]\nDiría que es un Pokémon llamado [CS:N]Manaphy[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]?", french=" [CS:N]Manaphy[CR]?", german=" [CS:N]Manaphy[CR]?", italian=" [CS:N]Manaphy[CR]?", spanish=" ¿[CS:N]Manaphy[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]?", french=" [CS:N]Manaphy[CR]?", german=" [CS:N]Manaphy[CR]?", italian=" [CS:N]Manaphy[CR]?", spanish=" ¿[CS:N]Manaphy[CR]?"})
  else
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]?", french=" [CS:N]Manaphy[CR]?", german=" [CS:N]Manaphy[CR]?", italian=" [CS:N]Manaphy[CR]?", spanish=" ¿[CS:N]Manaphy[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Correct.[K] This youngster is an\nextremely rare Pokémon. There are only a\nfew in the whole world.", french="Exact.[K] C'est un Pokémon\nextrêmement rare. Il n'en existe qu'une\npoignée sur toute la planète.", german="Korrekt.[K] Dieser Jungspund ist\nein extrem seltenes Pokémon. Es gibt nur ein\npaar davon auf der ganzen Welt.", italian="Esatto.[K] Si tratta di un\nPokémon rarissimo. Ne esistono pochissimi\nin tutto il mondo.", spanish="Exacto.[K] Este jovencito es un\nPokémon muy poco común. Hay muy pocos\nen el mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's said to hatch at the bottom\nof a cold sea. It then travels the seas over\nthousands of miles.", french="On dit qu'il éclot au fond\ndes eaux froides, et qu'il parcourt ensuite\nles mers sur des milliers de kilomètres.", german="Es soll angeblich auf dem Grund\neines kalten Meeres schlüpfen. Danach wandert\nes Tausende von Kilometern.", italian="Si dice che nascano sui fondali\ndei mari freddi. Poi si spostano nel mare per\nmigliaia di chilometri.", spanish="Según parece, eclosionan en las\nprofundidades de un frío mar y, después,\nviajan durante leguas atravesando el océano."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I should emphasize that a\n[CS:N]Manaphy[CR] is very rarely sighted.", french="J'insiste sur le fait qu'on\nn'aperçoit [CS:N]Manaphy[CR] que dans des\ncirconstances très exceptionnelles.", german="Ich sollte betonen, dass [CS:N]Manaphy[CR]\nsehr selten gesehen werden.", italian="Voglio sottolineare che è molto\nraro avvistare un [CS:N]Manaphy[CR].", spanish="Querría subrayar que raramente\nse ve a un [CS:N]Manaphy[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As a result, little is actually\nknown about the Pokémon.", french="Il en résulte qu'on en sait\ntrès peu sur ce Pokémon.", german="Aus diesem Grund ist sehr wenig\nüber diese Pokémon bekannt.", italian="Di conseguenza, si sa molto\npoco al loro riguardo.", spanish="Así que se sabe muy poco de\nellos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wow.[K] So this little guy's a\nreally rare Pokémon.", french="Oh.[K] Alors ce petit gars est\nun Pokémon très rare.", german="Wow.[K] Also ist dieses kleine\nKerlchen ein echt seltenes Pokémon.", italian="Wow.[K] Quindi questo piccolino\nè un Pokémon davvero raro.", spanish="Vaya.[K] Así que es un Pokémon\nmuy raro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow.[K] So this little guy's a\nreally rare Pokémon.", french="Oh.[K] Alors ce petit gars est\nun Pokémon très rare.", german="Wow.[K] Also ist dieses kleine\nKerlchen ein echt seltenes Pokémon.", italian="Wow.[K] Quindi questo piccolino\nè un Pokémon davvero raro.", spanish="Vaya.[K] Así que es un Pokémon\nmuy raro."})
  else
  SkySceneKit.say({english="Wow.[K] So this little cutie's a\nreally rare Pokémon.", french="Oh.[K] Alors ce petit gars est\nun Pokémon très rare.", german="Wow.[K] Also ist dieses kleine\nKerlchen ein echt seltenes Pokémon.", italian="Wow.[K] Quindi questo piccolino\nè un Pokémon davvero raro.", spanish="Vaya.[K] Así que es un Pokémon\nmuy raro."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Rare-rare! ♪", french=" Rar-rar! ♪", german=" Selten-selten! ♪", italian=" Raro-raro! ♪", spanish=" ¡Raro, raro! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So, you two.[K] What do you intend\nto do with this youngster?", french="Alors vous deux.[K] Qu'est-ce que\nvous allez faire de lui?", german="So, ihr zwei.[K] Was gedenkt ihr\nmit diesem Kleinen zu tun?", italian="E voi?[K] Cosa avete intenzione\ndi fare con questo cucciolo?", spanish="A ver...[K] ¿Qué pretendéis hacer\ncon este jovencito?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] What should we do?", french=" Hum![K] Que faire?", german=" Ähem?[K] Was sollten wir tun?", italian=" Eh?[K] Cosa dovremmo fare?", spanish=" ¿Qué?[K] ¿Qué deberíamos hacer?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?[K] What should we do?", french=" Hum![K] Que faire?", german=" Was?[K] Was sollten wir tun?", italian=" Eh?[K] Cosa dovremmo fare?", spanish=" ¿Qué?[K] ¿Qué deberíamos hacer?"})
  else
  SkySceneKit.say({english=" What?[K] What should we do?", french=" Hum![K] Que faire?", german=" Was?[K] Was sollten wir tun?", italian=" Eh?[K] Cosa dovremmo fare?", spanish=" ¿Qué?[K] ¿Qué deberíamos hacer?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, come to think of it...[K]\nWhat to do?[K] We didn't consider that at all.", french="Oui, c'est vrai, ça...[K] Qu'est-ce\nqu'on peut bien en faire?[K] On n'y a pas encore\nréfléchi.", german="Hm, jetzt, wo du das sagst...[K]\nWas ist zu tun?[K] Darüber haben wir uns\ngar keine Gedanken gemacht.", italian="Beh, a pensarci...[K] Cosa\nfacciamo?[K] Non ci abbiamo ancora riflettuto.", spanish="Bueno, ahora que lo dices...[K]\n¿Qué hacemos?[K] No habíamos pensado en eso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, come to think of it...[K]\nWhat to do?[K] We haven't given it much thought.", french="Oui, c'est vrai, ça...[K] Qu'est-ce\nqu'on peut bien en faire?[K] On n'y a pas encore\nréfléchi.", german="Hm, jetzt, wo du das sagst...[K]\nWas ist zu tun?[K] Wir haben daran noch nicht\nviele Gedanken verschwendet.", italian="Beh, a pensarci...[K] Cosa\nfacciamo?[K] Non ci abbiamo ancora riflettuto.", spanish="Bueno, ahora que lo dices...[K]\n¿Qué hacemos?[K] No habíamos pensado en nada."})
  else
  SkySceneKit.say({english="Well, come to think of it...[K]\nWhat to do?[K] We hadn't thought about that yet.", french="Oui, c'est vrai, ça...[K] Qu'est-ce\nqu'on peut bien en faire?[K] On n'y a pas encore\nréfléchi.", german="Hm, jetzt, wo du das sagst...[K]\nWas ist zu tun?[K] Darüber haben wir uns noch\nnicht den Kopf zerbrochen.", italian="Beh, a pensarci...[K] Cosa\nfacciamo?[K] Non ci abbiamo ancora riflettuto.", spanish="Bueno, ahora que lo dices...[K]\n¿Qué hacemos?[K] No habíamos pensado nada."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(42) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Weh...[K] Weh...[K] Waaaah!", french=" Ouin...[K] Ouin...[K] Ouiiiiiiiiiiiiiiin!", german=" He...[K] He...[K] Huaaaaaah!", italian=" Weh...[K] Weh...[K] Waaaah!", spanish=" Snif...[K] snif...[K] ¡Buaaaa!"})
  pcall(function() SOUND:StopBGM() end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa![K] What...[K]what's wrong?[K]\nThe baby started crying all of a sudden!", french="Ouah![K] Que...[K] qu'est-ce qui ne\nva pas?[K] Le bébé se met à pleurer d'un coup!", german="Holla![K] Was...[K] Was ist denn\nlos?[K] Das Kleine hat plötzlich angefangen zu\nschreien!", italian="Ehi![K] Cosa...[K] Cosa succede?[K]\nIl cucciolo ha iniziato a piangere\ntutto d'un tratto!", spanish="Pero...[K] ¿Qué...?[K] ¿Qué le pasa?[K]\n¡Ha empezado a llorar de repente!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Whoa![K] What...[K]what's wrong?[K]\nThe baby started crying all of a sudden!", french="Ouah![K] Que...[K] qu'est-ce qui ne\nva pas?[K] Le bébé se met à pleurer d'un coup!", german="Holla![K] Was...[K] Was ist denn\nlos?[K] Das Kleine hat plötzlich angefangen zu\nschreien!", italian="Ehi![K] Cosa...[K] Cosa succede?[K]\nIl cucciolo ha iniziato a piangere\ntutto d'un tratto!", spanish="Pero...[K] ¿Qué...?[K] ¿Qué le pasa?[K]\n¡Ha empezado a llorar de repente!"})
  else
  SkySceneKit.say({english="Whoa![K] What...[K]what's wrong?[K]\nThe baby started crying all of a sudden!", french="Ouah![K] Que...[K] qu'est-ce qui ne\nva pas?[K] Le bébé se met à pleurer d'un coup!", german="Holla![K] Was...[K] Was ist denn\nlos?[K] Das Kleine hat plötzlich angefangen zu\nschreien!", italian="Ehi![K] Cosa...[K] Cosa succede?[K]\nIl cucciolo ha iniziato a piangere\ntutto d'un tratto!", spanish="Pero...[K] ¿Qué...?[K] ¿Qué le pasa?[K]\n¡Ha empezado a llorar de repente!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I would imagine he's hungry.", french=" J'imagine qu'il a faim.", german=" Ich schätze mal, es hat Hunger.", italian=" Immagino che abbia fame.", spanish=" Tendrá hambre."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Right. What should we give him?", french="Très bien. Qu'est-ce qu'on lui\ndonne?", german="Okay. Was sollen wir ihm\ngeben?", italian=" Giusto. E cosa dobbiamo dargli?", spanish=" Sí. ¿Y qué le damos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Right. What should we feed him?", french="Très bien. Qu'est-ce qu'on lui\ndonne?", german="Okay. Was geben wir ihm\nzum Essen?", italian=" Giusto. E cosa dobbiamo dargli?", spanish=" Sí. ¿Y qué le damos?"})
  else
  SkySceneKit.say({english="Oh, of course. What do you think\nhe eats?", french="Très bien. Qu'est-ce qu'on lui\ndonne?", german="Oh, natürlich. Was, denkst du,\nisst es wohl?", italian=" Giusto. E cosa dobbiamo dargli?", spanish=" Claro. ¿Y qué comerá?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hmm...[K] I'm not sure, but because\nthis youngster is a Water-type Pokémon...", french="Hum...[K] Je n'en suis pas sûr,\nmais puisque ce petit est un Pokémon de\ntype Eau...", german="Hmm...[K] Ich bin mir nicht\nsicher, aber da das Kleine ein\nWasser-Pokémon ist...", italian="Mmm...[K] Non ne sono sicuro, ma\nvisto che si tratta di un Pokémon\ndi tipo Acqua...", spanish="Hum...[K] No estoy seguro, pero\ndado que es un Pokémon de tipo Agua..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="How about feeding him some\n[CS:I]Blue Gummis[CR]?", french="Pourquoi ne pas lui donner\ndes [CS:I]Gelées Bleues[CR]?", german="Sollen wir ihm mal ein paar\n[CS:I]Blaugummis[CR] geben?", italian="Che ne dite di dargli delle\n[CS:I]Gommeblu[CR]?", spanish="¿Qué tal si le damos unas\n[CS:I]Gomis Azules[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Gotcha. [CS:I]Blue Gummis[CR].", french=" D'accord. Des [CS:I]Gelées Bleues[CR].", german=" Verstanden. [CS:I]Blaugummis[CR].", italian=" Afferrato. [CS:I]Gommeblu[CR].", spanish=" Vale. [CS:I]Gomis Azules[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Some [CS:I]Blue Gummis[CR].", french=" D'accord. Des [CS:I]Gelées Bleues[CR].", german=" Okay! Ein paar [CS:I]Blaugummis[CR].", italian=" Afferrato! Delle [CS:I]Gommeblu[CR].", spanish=" Vale. [CS:I]Gomis Azules[CR]."})
  else
  SkySceneKit.say({english=" OK![K] Some [CS:I]Blue Gummis[CR].", french=" D'accord. Des [CS:I]Gelées Bleues[CR].", german=" Okay![K] Ein paar [CS:I]Blaugummis[CR].", italian=" Afferrato! Delle [CS:I]Gommeblu[CR].", spanish=" Vale. [CS:I]Gomis Azules[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's see...[K] [CS:I]Blue Gummis[CR]...\nI think we found some at [CS:P]Craggy Coast[CR] before.", french="Voyons...[K] Des [CS:I]Gelées Bleues[CR]...\nJe crois qu'on peut en trouver sur la\n[CS:P]Côte Escarpée[CR].", german="Mal sehen...[K] [CS:I]Blaugummis[CR]. Ich\nglaube, wir haben mal welche an der\n[CS:P]Schroffküste[CR] gefunden.", italian="Vediamo un po'...[K] [CS:I]Gommeblu[CR]...\nMi sembra di averle viste al [CS:P]Dirupo Costiero[CR].", spanish="A ver...[K] [CS:I]Gomis Azules[CR]...\nSi no recuerdo mal, encontramos algunas\nen la [CS:P]Costa Escarpada[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's see...[K] [CS:I]Blue Gummis[CR]...\nWe found some at [CS:P]Craggy Coast[CR], I think.", french="Voyons...[K] Des [CS:I]Gelées Bleues[CR]...\nJe crois qu'on peut en trouver sur la\n[CS:P]Côte Escarpée[CR].", german="Mal sehen...[K] [CS:I]Blaugummis[CR]. Wir\nhaben welche an der [CS:P]Schroffküste[CR] gefunden,\nmeine ich.", italian="Vediamo un po'...[K] [CS:I]Gommeblu[CR]...\nMi sembra di averle viste al [CS:P]Dirupo Costiero[CR].", spanish="A ver...[K] [CS:I]Gomis Azules[CR]...\nSi no recuerdo mal, encontramos algunas\nen la [CS:P]Costa Escarpada[CR]."})
  else
  SkySceneKit.say({english="Let's see...[K] [CS:I]Blue Gummis[CR]...\nWe found some at [CS:P]Craggy Coast[CR], I think.", french="Voyons...[K] Des [CS:I]Gelées Bleues[CR]...\nJe crois qu'on peut en trouver sur la\n[CS:P]Côte Escarpée[CR].", german="Mal sehen...[K] [CS:I]Blaugummis[CR]. Wir\nhaben welche an der [CS:P]Schroffküste[CR] gefunden,\nmeine ich.", italian="Vediamo un po'...[K] [CS:I]Gommeblu[CR]...\nMi sembra di averle viste al [CS:P]Dirupo Costiero[CR].", spanish="A ver...[K] [CS:I]Gomis Azules[CR]...\nSi no recuerdo mal, encontramos algunas\nen la [CS:P]Costa Escarpada[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go get some [CS:I]Blue Gummis[CR],\n[hero]!", french="Allons chercher des [CS:I]Gelées\nBleues[CR], [hero]!", german="Besorgen wir ein paar\n[CS:I]Blaugummis[CR], [hero]!", italian="Andiamo a prendere delle\n[CS:I]Gommeblu[CR], [hero]!", spanish="¡Vamos a por [CS:I]Gomis Azules[CR],\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go get some [CS:I]Blue Gummis[CR],\n[hero]!", french="Allons chercher des [CS:I]Gelées\nBleues[CR], [hero]!", german="Besorgen wir ein paar\n[CS:I]Blaugummis[CR], [hero]!", italian="Andiamo a prendere delle\n[CS:I]Gommeblu[CR], [hero]!", spanish="¡Vamos a por [CS:I]Gomis Azules[CR],\n[hero]!"})
  else
  SkySceneKit.say({english="Let's go get some [CS:I]Blue Gummis[CR],\n[hero]!", french="Allons chercher des [CS:I]Gelées\nBleues[CR], [hero]!", german="Besorgen wir ein paar\n[CS:I]Blaugummis[CR], [hero]!", italian="Andiamo a prendere delle\n[CS:I]Gommeblu[CR], [hero]!", spanish="¡Vamos a por [CS:I]Gomis Azules[CR],\n[hero]!"})
  end
  -- message_Close
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkySceneKit.cleanup_npcs()
end
