-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05C/m05a0911.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P05C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_FIRE_CRACKLING3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 248, 232, Direction.UpLeft, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster, I've brought you\nTeam [team:].", french="Maître, voici l'Equipe\n[team:].", german="Gildenmeister, hier ist\nTeam [team:].", italian="Capitano, le ho portato\nil Team [team:].", spanish="Gran Bluff, aquí está el [CS:X]Equipo[CR]\n[team:]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Guildmaster...[K]Guildmaster?", french=" Maître...[K] Maître?", german=" Gildenmeister...[K] Gildenmeister?", italian=" Capitano...[K] Capitano?", spanish=" Gran Bluff...[K] ¿Gran Bluff?"})
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:WaitFrames(60)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 208, 200, Direction.Up, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Hiya!", french=" Amis du soir, bonsoir!", german=" Hallöchen!", italian=" Ullalà!", spanish=" ¿Qué hay?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Your team went through a lot\ntoday! Yes, a lot-lot!", french="Votre équipe a traversé\nbeaucoup d'épreuves aujourd'hui! Oh oui\nalors, beaucoup-beaucoup!", german="Euer Team hat heute viel\ndurchgemacht! Oh ja, eine Menge!", italian="La vostra squadra si è data\nmolto da fare oggi! Molto-molto!", spanish="¡Hoy vuestro equipo ha tenido\nun montón de experiencias! ¡Vaya que sí!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But don't worry! I'm keeping\nwatch on your activities!", french="Mais ne vous inquiétez pas!\nJe garde toujours un œil sur ce que vous\nfaites!", german="Aber keine Sorge! Ich behalte\neure Aktivitäten im Auge!", italian="Ma non preoccupatevi! Sono\nsempre al corrente delle vostre attività!", spanish="¡No os preocupéis! ¡Estoy\npendiente de todas vuestras actividades!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I should tell you why I called\nyou here.", french="Je vais vous dire pourquoi\nvous êtes là.", german="Ich sollte euch sagen, warum ich\neuch gerufen habe.", italian="Devo dirvi perché ho voluto\nvedervi.", spanish="Debería deciros por qué os\nhe llamado."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We're planning to mount a full\nexpedition soon! ♪", french="Nous sommes en train de\npréparer une grande expédition, et c'est\npour bientôt! ♪", german="Wir haben vor, bald eine große\nExpedition zu unternehmen! ♪", italian="Abbiamo intenzione di\norganizzare una spedizione a breve! ♪", spanish="¡Vamos a organizar una\nexpedición colectiva muy pronto! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" An expedition?", french=" Une expédition?", german=" Eine Expedition?", italian=" Una spedizione?", spanish=" ¿Una expedición?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" An expedition?", french=" Une expédition?", german=" Eine Expedition?", italian=" Una spedizione?", spanish=" ¿Una expedición?"})
  else
  SkySceneKit.say({english=" An expedition?", french=" Une expédition?", german=" Eine Expedition?", italian=" Una spedizione?", spanish=" ¿Una expedición?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Yes! The guild will go explore\nsomeplace far away!", french="Oui! La Guilde va partir explorer\nun endroit très lointain!", german="Ja! Die Gilde wird einen Ort\nerkunden, der sehr weit entfernt liegt!", italian="Sì! La Gilda andrà ad esplorare\nqualche luogo lontano!", spanish="¡Sí! ¡Saldremos a explorar\na un lugar muy lejano!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's much harder than exploring\nour nearby area.", french="C'est plus difficile que\nd'explorer les environs.", german="Das ist viel schwieriger als eine\nErkundungstour hier in der Nähe.", italian="È molto più difficile che\nesplorare le aree qui vicino.", spanish="Será mucho más duro que\nexplorar por aquí cerca."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That's why we need to prepare\nfor the big trip properly.", french="C'est pourquoi nous devons\nnous préparer correctement pour ce\ngrand voyage.", german="Darum müssen wir uns gut auf\ndiese Reise vorbereiten.", italian="Quindi dobbiamo prepararci\nper bene al grande viaggio.", spanish="Por eso tenemos que\nprepararnos a conciencia."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We carefully choose which guild\nmembers go on the expedition.", french="Nous allons trier sur le volet\nles membres de la Guilde qui participeront\nà l'expédition.", german="Wir wählen sorgfältig aus,\nwelche Gildenmitglieder mit auf die Expedition\ngehen werden.", italian="Sceglieremo con cura quali\nmembri della Gilda prenderanno parte alla\nspedizione.", spanish="Vamos a escoger con mucho\ncuidado a los exploradores del [CS:N]Pokégremio[CR] que\nestén más capacitados para ir a la expedición."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Really?!", french=" Vraiment?!", german=" Wirklich?!?", italian=" Davvero?!", spanish=" ¡¿De verdad?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Really?!", french=" Vraiment?!", german=" Wirklich?!?", italian=" Davvero?!", spanish=" ¡¿De verdad?!"})
  else
  SkySceneKit.say({english=" Really?!", french=" Vraiment?!", german=" Wirklich?!?", italian=" Davvero?!", spanish=" ¡¿De verdad?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Usually, we would never, ever\nconsider rookies to be expedition members.", french="Normalement, ce n'est pas\ndans nos habitudes d'emmener des novices\nen expédition.", german="Normalerweise würden wir\nniemals im Leben in Erwägung ziehen, Neulinge\nals Mitglieder für eine Expedition zu wählen.", italian="Normalmente non prenderemmo\nin considerazione delle reclute, mai e poi mai!", spanish="Normalmente, jamás de los\njamases nos plantearíamos llevar a ningún\nnovato a nuestras expediciones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But you two are working so\nvery hard!", french="Mais vous deux, vous avez\ntravaillé si dur!", german="Aber ihr zwei gebt euch so viel\nMühe!", italian="Ma voi due state lavorando così\ntanto!", spanish="¡Pero vuestro equipo se está\nesforzando mucho!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That's why we're making a\nspecial exception this time!", french="Cette fois, nous allons donc\nfaire une exception!", german="Darum machen wir diesmal eine\nbesondere Ausnahme!", italian="Per questo motivo,\nabbiamo deciso di fare un'eccezione questa\nvolta!", spanish="¡Y por eso esta vez vamos\na hacer una excepción... excepcional!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We decided to include you in\nthe list of candidates for the expedition!", french="Nous avons décidé de vous\ninscrire dans la liste des candidats à\nl'expédition!", german="Wir haben beschlossen, euch in\ndie Liste der Kandidaten für die Expedition\naufzunehmen!", italian="Abbiamo deciso di includervi\nnella lista dei candidati per la spedizione!", spanish="¡Hemos decidido incluiros\nen la lista de candidatos a la expedición!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" R-really?!", french=" Oh! Vraiment?!", german=" W-wirklich?!?", italian=" D-Davvero?!", spanish=" ¡¿En serio?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" R-really?!", french=" Oh! Vraiment?!", german=" W-wirklich?!?", italian=" D-Davvero?!", spanish=" ¡¿En serio?!"})
  else
  SkySceneKit.say({english=" R-really?!", french=" Oh! Vraiment?!", german=" W-wirklich?!?", italian=" D-Davvero?!", spanish=" ¡¿En serio?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Now, now!", french=" Mais attention!", german=" Na, na!", italian=" Calma, calma!", spanish=" ¡Bueno, bueno!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You haven't been chosen as\nexpedition members yet.", french="Vous n'êtes pas encore membres\nde l'expédition.", german="Ihr seid noch nicht als\nExpeditionsmitglieder ausgewählt.", italian="Non vi abbiamo ancora scelto\nper la spedizione.", spanish=" Eso no quiere decir nada."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There is still time before we\nset out on the expedition.", french="Celle-ci aura lieu dans quelque\ntemps.", german=" Bis zur Expedition ist noch Zeit.", italian="C'è ancora tempo prima\ndella partenza.", spanish="Todavía queda un tiempo antes\nde que tenga lugar la expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If you fail to do good work\nbefore then, you cannot expect to be selected\nfor the expedition.", french="Si vous ne faites pas du bon\ntravail d'ici là, vous n'en ferez pas partie.", german="Wenn ihr bis dahin keine gute\nArbeit leistet, könnt ihr nicht damit rechnen,\nfür die Expedition ausgewählt zu werden.", italian="Se non lavorerete con impegno,\nnon vi sceglieremo.", spanish="Si no exploráis de forma\nsatisfactoria estos días, no contéis con\nformar parte."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I'm sure you two can do it!", french="Je suis sûr que vous pouvez\ny arriver!", german="Ich bin mir sicher, ihr zwei\nkönnt es schaffen!", italian=" Sono sicuro che potete farcela!", spanish="¡Aunque estoy seguro de que\npodéis conseguirlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Try hard!", french=" Redoublez d'efforts!", german=" Gebt euch Mühe!", italian=" Fate del vostro meglio!", spanish=" ¡Haced un esfuerzo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup!", french=" Oui!", german=" Jawohl!", italian=" Sì!", spanish=" ¡Sí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes!", french=" Oui!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  else
  SkySceneKit.say({english=" Yep!", french=" Oui!", german=" Ja!", italian=" Sì!", spanish=" ¡Lo haremos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="An expedition! Isn't it amazing,\n[hero]?", french="Une expédition! Ce serait super,\n[hero]!", german="Eine Expedition! Ist das nicht\ntoll, [hero]?", italian="Una spedizione! Non è\nemozionante, [hero]?", spanish="¡Una expedición! ¿A que mola,\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="An expedition! Isn't it fantastic,\n[hero]?", french="Une expédition! Ce serait super,\n[hero]!", german="Eine Expedition! Ist das nicht\nfantastisch, [hero]?", italian="Una spedizione! Non è\nemozionante, [hero]?", spanish="¡Una expedición! ¿A que es\nfantástico, [hero]?"})
  else
  SkySceneKit.say({english="An expedition! Isn't it fantastic,\n[hero]?", french="Une expédition! Ce serait super,\n[hero]!", german="Eine Expedition! Ist das nicht\nfantastisch, [hero]?", italian="Una spedizione! Che cosa\nemozionante vero, [hero]?", spanish="¡Una expedición!\n¡Es fantástico, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="My heart is pounding all of a\nsudden!", french=" Mon cœur bat la chamade!", german=" Ich habe plötzlich Herzrasen!", italian=" Il cuore mi batte all'impazzata!", spanish="¡Me muero de ganas!\n¡Tenemos que ir sea como sea!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="My heart is pounding all of a\nsudden!", french=" Mon cœur bat la chamade!", german=" Ich habe plötzlich Herzrasen!", italian=" Mi batte forte il cuore!", spanish="¡Me muero de ganas!\n¡Tenemos que ir sea como sea!"})
  else
  SkySceneKit.say({english="My pulse is racing all of a\nsudden!", french=" Mon cœur bat la chamade!", german=" Ich habe plötzlich Herzrasen!", italian=" Il mio cuore è come impazzito!", spanish="¡Me muero de ganas!\n¡Tenemos que ir sea como sea!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's do our best and make sure\nwe get picked for the expedition!", french="Faisons de notre mieux pour\nassurer notre place au sein de l'expédition!", german="Tun wir unser Bestes, damit wir\nganz sicher für die Expedition ausgesucht\nwerden!", italian="Facciamo del nostro meglio,\ncosì ci faranno partecipare alla spedizione!", spanish="¡Vamos a hacer lo posible\npara que nos seleccionen!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's try our best and make sure\nwe get picked for the expedition!", french="Faisons de notre mieux pour\nassurer notre place au sein de l'expédition!", german="Tun wir unser Bestes, damit wir\nganz sicher für die Expedition ausgesucht\nwerden!", italian="Facciamo del nostro meglio,\ncosì ci faranno partecipare alla spedizione!", spanish="¡Vamos a hacer lo posible\npara que nos seleccionen!"})
  else
  SkySceneKit.say({english="Let's try our best and make sure\nwe get picked for the expedition!", french="Faisons de notre mieux pour\nassurer notre place au sein de l'expédition!", german="Tun wir unser Bestes, damit wir\nganz sicher für die Expedition ausgesucht\nwerden!", italian="Facciamo del nostro meglio,\ncosì ci faranno partecipare alla spedizione!", spanish="¡Vamos a hacer lo posible\npara que nos seleccionen!"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(66) [anim idle native]
  -- SetAnimation(66) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(80)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkyProg.set(7, 0) -- $SCENARIO_MAIN = scn[7,0] (ROM)
  SkySceneKit.cleanup_npcs()
end
