-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/m07a1302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 8, 184, Direction.Right, "NPC_KIMAWARI")
  GROUND:MoveToPosition(npc_npc_kimawari, 216, 180, false, 2)
  GAME:WaitFrames(15)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 8, 184, Direction.Right, "NPC_CHIRIIN")
  GROUND:MoveToPosition(npc_npc_chiriin, 168, 180, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 176, 180, false, 2)
  GAME:WaitFrames(35)
  GROUND:MoveToPosition(partner, 144, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 192, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 224, 188, false, 2)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Left)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  GROUND:MoveToPosition(hero, 192, 164, false, 2)
  GROUND:MoveToPosition(partner, 160, 164, false, 2)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.DownLeft)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 8, 184, Direction.Right, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 128, 180, false, 2)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Whew! No one saw anything,\nexcept maybe [CS:N]Croagunk[CR]...", french="Ouaip! Personne a rien vu,\nsauf p'têt' [CS:N]Cradopaud[CR]...", german="Puh! Niemand hat etwas gesehen,\naußer vielleicht [CS:N]Glibunkel[CR].", italian="Fiuuu! Nessuno ha visto niente,\ntranne forse [CS:N]Croagunk[CR]...", spanish="Salvo [CS:N]Croagunk[CR], parece que\nnadie se ha fijado en nosotros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_bippa, 160, 204, false, 2)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What's up? Why'd you call us\nin here?", french="Qu'est-ce qui se passe? Pourquoi\nvous nous avez fait venir ici?", german="Was ist? Wieso hast du uns\ngerufen?", italian="Cosa succede? Perché ci avete\nportato qui?", spanish="¿Qué pasa? ¿Por qué nos habéis\nllamado?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What's going on? Why did you\ncall us in here?", french="Qu'est-ce qui se passe? Pourquoi\nvous nous avez fait venir ici?", german="Was ist los? Wieso hast du uns\ngerufen?", italian="Cosa succede? Perché ci avete\nportato qui?", spanish="¿Qué pasa? ¿Por qué nos habéis\nllamado?"})
  else
  SkySceneKit.say({english="What's up? Why did you call us\nin here?", french="Qu'est-ce qui se passe? Pourquoi\nvous nous avez fait venir ici?", german="Was ist? Wieso hast du uns\ngerufen?", italian="Cosa succede? Perché ci avete\nportato qui?", spanish="¿Qué pasa? ¿Por qué nos habéis\nllamado?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Well...here you go.", french=" Voilà...", german=" Nun ja... Hier, nehmt.", italian=" Beh... tenete.", spanish=" Aquí tenéis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:MoveToPosition(npc_npc_kimawari, 160, 188, false, 2)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GROUND:MoveToPosition(npc_npc_kimawari, 192, 188, false, 2)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GROUND:MoveToPosition(npc_npc_kimawari, 224, 188, false, 2)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! [CS:I]Apples[CR]!", french=" Oh! Des [CS:I]Pommes[CR]!", german=" Hey! [CS:I]Äpfel[CR]!", italian=" Ehi! Sono delle [CS:I]Mele[CR]!", spanish=" ¡Eh! ¡[CS:I]Manzanitas[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! [CS:I]Apples[CR]!", french=" Oh! Des [CS:I]Pommes[CR]!", german=" Oh! [CS:I]Äpfel[CR]!", italian=" Ehi! Sono delle [CS:I]Mele[CR]!", spanish=" ¡Eh! ¡[CS:I]Manzanitas[CR]!"})
  else
  SkySceneKit.say({english=" Oh! [CS:I]Apples[CR]!", french=" Oh! Des [CS:I]Pommes[CR]!", german=" Oh! [CS:I]Äpfel[CR]!", italian=" Ehi! Sono delle [CS:I]Mele[CR]!", spanish=" ¡Eh! ¡[CS:I]Manzanitas[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" You must be very hungry.", french=" Vous devez avoir très faim.", german=" Ihr habt sicher großen Hunger.", italian=" Dovete avere molta fame.", spanish=" Debéis de tener mucha hambre."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="We all set aside a little bit of\nour dinners last night for you.", french="Hier soir, on a tous mis un peu\nd'not' dîner de côté pour vous.", german="Wir haben gestern alle etwas\nvon unserem Abendessen für euch aufgehoben.", italian="Abbiamo tutti messo da parte\nun po' della nostra cena di ieri sera per voi.", spanish="Todos os hemos guardado algo\nde nuestra cena."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Now, eat up!", french="Allez, régalez-vous! C'est\ncadeau!", german=" Jetzt esst!", italian=" Mangiate adesso!", spanish=" Ahora, ¡comed un poco!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-thanks, everyone!", french=" Merci à vous tous!", german=" D-danke euch allen!", italian=" G-Grazie a tutti!", spanish=" ¡Muchas gracias a todos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-thanks, everyone!", french=" Merci à vous tous!", german=" D-danke euch allen!", italian=" G-Grazie a tutti!", spanish=" ¡Muchas gracias a todos!"})
  else
  SkySceneKit.say({english=" Th-thanks, everyone!", french=" Merci à vous tous!", german=" D-danke euch allen!", italian=" G-Grazie a tutti!", spanish=" ¡Muchas gracias a todos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_EATING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(4), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(4), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- SetAnimation(64) [anim idle native]
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- SetAnimation(64) [anim idle native]
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp![K]\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp![K]\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf![K]\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp![K]\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp![K]\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp![K]\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf![K]\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp![K]\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! Thanks! I'm revitalized!", french="Waouh! Merci! J'ai repris des\nforces!", german="Boah! Danke! Ich bin wieder\nvoller Energie!", italian=" Wow! Grazie! Mi sento meglio!", spanish="Vaya... ¡Muchas gracias!\n¡Ya me siento vivo otra vez!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whoa! Thanks! I'm revitalized!", french="Waouh! Merci! J'ai repris des\nforces!", german="Boah! Danke! Ich bin wieder\nvoller Energie!", italian=" Wow! Grazie! Mi sento meglio!", spanish="Vaya... ¡Muchas gracias!\n¡Ya me siento revitalizado!"})
  else
  SkySceneKit.say({english=" Whoa! Thanks! I'm revitalized!", french="Waouh! Merci! J'ai repris des\nforces!", german="Boah! Danke! Ich bin wieder\nvoller Energie!", italian=" Wow! Grazie! Mi sento meglio!", spanish="Vaya... ¡Muchas gracias!\n¡Ahora me siento llena de energía!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Great!", french=" Super!", german=" Großartig!", italian=" Grandioso!", spanish=" ¡Genial!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We can all use help when\nwe're down.", french="Il faut qu'on s'entraide quand\ncertains ne vont pas bien, non?", german="Wir brauchen alle mal Hilfe,\nwenn es uns schlecht geht.", italian="Tutti abbiamo bisogno d'aiuto\nquando ci sentiamo giù.", spanish="Todos necesitamos una ayudita\ncuando no nos van bien las cosas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Every one of us needs to be able\nto work hard in order to be picked for the\nexpedition. Yup yup!", french="On doit tous être capables\nd'travailler dur pour être choisis pour\nl'expédition. Ouaip ouaip!", german="Wir sollten alle hart arbeiten\nkönnen, um in das Expeditionsteam gewählt zu\nwerden. Jawollja!", italian="Dobbiamo tutti fare del nostro\nmeglio per essere scelti per la spedizione.\nGià, già!", spanish="¡Y todos debemos tener fuerzas\npara explorar lo mejor posible y que nos\nescojan para la expedición!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Sniffle... Thanks, everyone...", french=" Snif... Merci à vous tous...", german=" Schnief... Danke euch allen.", italian=" Sniff... Grazie a tutti...", spanish=" Snif... Gracias..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Sniffle... Thanks, everyone...", french=" Snif... Merci à vous tous...", german=" Schnief... Danke euch allen.", italian=" Sniff... Grazie a tutti...", spanish=" Snif... Gracias..."})
  else
  SkySceneKit.say({english=" Sniffle... Thanks, everyone...", french=" Snif... Merci à vous tous...", german=" Schnief... Danke euch allen.", italian=" Sniff... Grazie a tutti...", spanish=" Snif... Gracias..."})
  end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But about the expedition...\n[CS:N]Chatot[CR] just came and told us...", french="Mais en ce qui concerne\nl'expédition... [CS:N]Pijako[CR] vient de nous dire...", german="Was die Expedition angeht...\n[CS:N]Plaudagei[CR] hat uns gerade gesagt...", italian="Ma, a proposito della\nspedizione... [CS:N]Chatot[CR] ci ha appena detto\nuna cosa.", spanish="Pero... sobre la expedición...\n[CS:N]Chatot[CR] nos ha dicho antes..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But about the expedition...\n[CS:N]Chatot[CR] just came and told us...", french="Mais en ce qui concerne\nl'expédition... [CS:N]Pijako[CR] vient de nous dire...", german="Was die Expedition angeht...\n[CS:N]Plaudagei[CR] hat uns gerade gesagt...", italian="Ma, a proposito della\nspedizione... [CS:N]Chatot[CR] ci ha appena detto\nuna cosa.", spanish="Pero... sobre la expedición...\n[CS:N]Chatot[CR] nos ha dicho antes..."})
  else
  SkySceneKit.say({english="But about the expedition...\n[CS:N]Chatot[CR] just came and told us...", french="Mais en ce qui concerne\nl'expédition... [CS:N]Pijako[CR] vient de nous dire...", german="Was die Expedition angeht...\n[CS:N]Plaudagei[CR] hat uns gerade gesagt...", italian="Ma, a proposito della\nspedizione... [CS:N]Chatot[CR] ci ha appena detto\nuna cosa.", spanish="Pero... sobre la expedición...\n[CS:N]Chatot[CR] nos ha dicho antes..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're probably not going to\nbe picked...", french="... que nous n'en ferons\nprobablement pas partie...", german="Nun... Wahrscheinlich werden\nwir nicht ausgewählt.", italian="Probabilmente non faremo\nparte della squadra...", spanish="Que probablemente no nos\nvan a seleccionar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're probably not going to\nbe chosen...", french="... que nous n'en ferons\nprobablement pas partie...", german="Nun... Wahrscheinlich werden\nwir nicht ausgewählt.", italian="Probabilmente non faremo\nparte della squadra...", spanish="Que probablemente no nos\nvan a seleccionar..."})
  else
  SkySceneKit.say({english="We're probably not going to\nbe chosen...", french="... que nous n'en ferons\nprobablement pas partie...", german="Nun... Wahrscheinlich werden\nwir nicht ausgewählt.", italian="Probabilmente non faremo\nparte della squadra...", spanish="Que probablemente no nos\nvan a seleccionar..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="How could you say that?! There's\nno telling what might happen! No sirree!", french="Bah pourquoi qu'tu dis ça?!\nSi tu t'imagines qu'ils vous choisiront\npas, c'que tu t'goures, pardi!", german="Wie kann er so etwas sagen?!?\nMan weiß nie, was passiert! Niemals nicht!", italian="Come fate a dirlo?! Non si sa\nmai cosa può succedere! Nossignore!", spanish="¡¿Cómo podéis decir eso?!\n¿Quién sabe lo que puede ocurrir? ¡No, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="The members haven't been\npicked yet!", french="C'est vrai, on ne peut pas savoir\nce qui va s'passer, après tout! Les membres\nn'ont même pas encore été choisis!", german="Die Mitglieder stehen noch nicht\nfest!", italian="I componenti non sono ancora\nstati scelti!", spanish=" Todavía no se ha decidido nada."})
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(45)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Everyone... Thanks for trying to\ncheer us up, but...", french="Merci à tous d'essayer de nous\nremonter le moral, mais...", german="Danke, dass ihr versucht, uns\naufzubauen...", italian="Grazie a tutti per aver provato\na tirarci su.", spanish="Gracias a todos por intentar\nanimarnos, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Everyone... Thanks for trying to\ncheer us up, but...", french="Merci à tous d'essayer de nous\nremonter le moral, mais...", german="Danke, dass ihr versucht, uns\naufzubauen...", italian="Grazie a tutti per aver provato\na tirarci su.", spanish="Gracias a todos por intentar\nanimarnos, pero..."})
  else
  SkySceneKit.say({english="Everyone... Thanks for trying to\ncheer us up, but...", french="Merci à tous d'essayer de nous\nremonter le moral, mais...", german="Danke, dass ihr versucht, uns\naufzubauen...", italian="Grazie a tutti per aver provato\na tirarci su.", spanish="Gracias a todos por intentar\nanimarnos, pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Doesn't everybody want to go on\nthe expedition?", french="... tout le monde veut faire\npartie de l'expédition, non?", german="Wollen nicht alle bei der\nExpedition dabei sein?", italian="Ma non vogliamo, forse, fare\ntutti parte della spedizione?", spanish="¿No se supone que también\nqueréis ir a la expedición?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Doesn't everybody want to go on\nthe expedition?", french="... tout le monde veut faire\npartie de l'expédition, non?", german="Wollen nicht alle bei der\nExpedition dabei sein?", italian="Ma non vogliamo, forse, fare\ntutti parte della spedizione?", spanish="¿No se supone que también\nqueréis ir a la expedición?"})
  else
  SkySceneKit.say({english="Doesn't everybody want to go on\nthe expedition?", french="... tout le monde veut faire\npartie de l'expédition, non?", german="Wollen nicht alle bei der\nExpedition dabei sein?", italian="Ma non vogliamo, forse, fare\ntutti parte della spedizione?", spanish="¿No se supone que también\nqueréis ir a la expedición?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What if we get picked to go?", french="Et si jamais nous en faisons\npartie, qu'est-ce qui se passera?", german="Was, wenn wir ausgewählt\nwerden?", italian=" E se scegliessero noi?", spanish="¿Qué pasaría si al final nos\nescogiesen?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What if we were chosen to go?", french="Et si jamais nous en faisons\npartie, qu'est-ce qui se passera?", german="Was, wenn wir ausgewählt\nwerden?", italian=" E se scegliessero noi?", spanish="¿Qué pasaría si al final nos\nescogiesen?"})
  else
  SkySceneKit.say({english=" What if we were chosen to go?", french="Et si jamais nous en faisons\npartie, qu'est-ce qui se passera?", german="Was, wenn wir ausgewählt\nwerden?", italian=" E se scegliessero noi?", spanish="¿Qué pasaría si al final nos\nescogiesen?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If that happens, someone here\nmight not get to go.", french="Ça voudra dire que certains\nd'entre vous ne pourront pas y aller.", german="Dann kann jemand anderes\nvielleicht nicht mit.", italian="In questo caso, qualcuno di\nvoi potrebbe non partire.", spanish="Eso querría decir que alguno\nde vosotros no podría ir."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If that happens, someone here\nmight not get to go.", french="Ça voudra dire que certains\nd'entre vous ne pourront pas y aller.", german="Dann kann jemand anderes\nvielleicht nicht mit.", italian="In questo caso, qualcuno di\nvoi potrebbe non partire.", spanish="Eso querría decir que alguno\nde vosotros no podría ir."})
  else
  SkySceneKit.say({english="If that happens, someone here\nmight not get to go.", french="Ça voudra dire que certains\nd'entre vous ne pourront pas y aller.", german="Dann kann jemand anderes\nvielleicht nicht mit.", italian="In questo caso, qualcuno di\nvoi potrebbe non partire.", spanish="Eso querría decir que alguno\nde vosotros no podría ir."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Would you all be OK with that?", french=" Vous seriez d'accord avec ça?", german=" Wäre das okay für euch alle?", italian=" Vi andrebbe bene?", spanish=" ¿Eso os parecería bien?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Would you all be OK with that?", french=" Vous seriez d'accord avec ça?", german=" Wäre das okay für euch alle?", italian=" Vi andrebbe bene?", spanish=" ¿Eso os parecería bien?"})
  else
  SkySceneKit.say({english=" Would you all be OK with that?", french=" Vous seriez d'accord avec ça?", german=" Wäre das okay für euch alle?", italian=" Vi andrebbe bene?", spanish=" ¿Eso os parecería bien?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" No, I wouldn't like that...", french=" Non, je serais trop dégoûtée...", german=" Nein, das fände ich nicht gut.", italian=" No, non sarei contenta, ma...", spanish=" Pues no. La verdad es que no."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="But, of course, if someone\nis chosen...", french="On le sait bien! Si quelqu'un\nest choisi...", german="Aber wenn irgendwer\nausgewählt wird...", italian=" Certo, se qualcuno viene scelto...", spanish="Es bastante evidente.\nSi seleccionan a alguien..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Then someone else can't go.", french="... alors ce sera au détriment\nde quelqu'un d'autre.", german="Dann kann natürlich jemand\nanderes dafür nicht mit.", italian="... qualcun altro non potrà\npartire.", spanish=" Eso supone que otro no podrá ir."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" That's just the way it is!", french=" C'est comme ça!", german=" So ist das eben!", italian="Ma è così, non c'è niente da\nfare!", spanish=" ¡Pero así son las cosas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="If you don't get picked for the\nexpedition, you should cheer for those who did.", french="Ceux qui ne font pas partie de\nl'expédition devraient se réjouir pour ceux\nqui en font partie.", german="Wenn man nicht für die\nExpedition ausgewählt wird, sollte man\nsich für die freuen, die ausgewählt wurden.", italian="Se non si viene scelti per la\nspedizione, bisogna essere contenti per\nquelli che lo sono stati.", spanish="Si no te escogen para la\nexpedición, siempre puedes alegrarte\npor quien sí ha podido ir."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup! And everyone wants to\ngo on the expedition with you, [partner]\nand [hero].", french="Ouaip! Y'a tout l'monde qui veut\npartir en expédition avec vous, [partner]\net [hero].", german="Jawollja! Und alle wollen mit\neuch auf Expedition gehen, [partner]\nund [hero].", italian="Già, già! E tutti vogliono\npartecipare alla spedizione con voi,\n[partner] e [hero].", spanish="Sí, señor. Todos queremos ir a\nla expedición con [partner] y [hero]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sniffle... Everyone, honestly,\nthank you.", french="Snif... Sincèrement, merci à\nvous tous.", german="Schnief... Vielen Dank euch allen,\nehrlich.", italian=" Sniff... Grazie di cuore a tutti.", spanish="Snif... Sinceramente, gracias a\ntodos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sniffle... Everyone, honestly,\nthank you.", french="Snif... Sincèrement, merci à\nvous tous.", german="Schnief... Vielen Dank euch allen,\nehrlich.", italian=" Sniff... Grazie di cuore a tutti.", spanish="Snif... Sinceramente, gracias a\ntodos."})
  else
  SkySceneKit.say({english="Sniffle... Everyone, honestly,\nthank you.", french="Snif... Sincèrement, merci à\nvous tous.", german="Schnief... Vielen Dank euch allen,\nehrlich.", italian=" Sniff... Grazie di cuore a tutti.", spanish="Snif... Sinceramente, gracias a\ntodos."})
  end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(90) end)
  GAME:WaitFrames(90)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="OK! Then we'll keep trying our\nbest to get picked for the expedition.", french="Allez! On va donc continuer\nà faire de notre mieux pour faire partie\nde l'expédition.", german="Okay! Dann versuchen wir\nweiter unser Bestes, um für die Expedition\nausgewählt zu werden.", italian="Ok! Allora continueremo a fare\ndel nostro meglio per prendere parte alla\nspedizione.", spanish="De acuerdo. Haremos lo posible\npara que nos seleccionen para la expedición."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK! Then we'll keep trying our\nbest to get picked for the expedition.", french="Allez! On va donc continuer\nà faire de notre mieux pour faire partie\nde l'expédition.", german="Okay! Dann versuchen wir\nweiter unser Bestes, um für die Expedition\nausgewählt zu werden.", italian="Ok! Allora continueremo a fare\ndel nostro meglio per prendere parte alla\nspedizione.", spanish="De acuerdo. Haremos lo posible\npara que nos seleccionen para la expedición."})
  else
  SkySceneKit.say({english="OK! Then we'll keep trying our\nbest to get picked for the expedition.", french="Allez! On va donc continuer\nà faire de notre mieux pour faire partie\nde l'expédition.", german="Okay! Dann versuchen wir\nweiter unser Bestes, um für die Expedition\nausgewählt zu werden.", italian="Ok! Allora continueremo a fare\ndel nostro meglio per prendere parte alla\nspedizione.", spanish="De acuerdo. Haremos lo posible\npara que nos seleccionen para la expedición."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll keep on trying to the end!", french=" On se battra jusqu'au bout!", german="Wir werden bis zum Schluss\nkämpfen!", italian="Continueremo a mettercela tutta\nfino alla fine!", spanish="¡Seguiremos intentándolo hasta\nel final!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We'll keep on trying to the end!", french=" On se battra jusqu'au bout!", german="Wir werden bis zum Schluss\nkämpfen!", italian="Continueremo a mettercela tutta\nfino alla fine!", spanish="¡Seguiremos intentándolo hasta\nel final!"})
  else
  SkySceneKit.say({english=" We'll keep on trying to the end!", french=" On se battra jusqu'au bout!", german="Wir werden bis zum Schluss\nkämpfen!", italian="Continueremo a mettercela tutta\nfino alla fine!", spanish="¡Seguiremos intentándolo hasta\nel final!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yup yup! That's the spirit!", french="Bah ouaip! J'préfère ça! Faut\npas s'laisser abattre, hein!", german="Jawollja! Das ist die richtige\nEinstellung!", italian="Già, già! Questo è lo spirito\ngiusto!", spanish=" ¡Sí, señor! ¡Así se habla!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Yes! Let's all do our best!", french="Oui! Donnons le meilleur de\nnous-mêmes!", german=" Ja! Geben wir alle unser Bestes!", italian="Sì! Facciamo tutti del nostro\nmeglio!", spanish="¡Sí! ¡Todos trataremos de\nhacer lo que podamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We've got to try hard so\nwe all can go!", french="Nous devons travailler avec plus\nd'ardeur pour y aller tous!", german="Wir müssen uns Mühe geben,\ndamit wir alle an der Expedition teilnehmen\ndürfen!", italian="Dobbiamo impegnarci al\nmassimo, così potremo partecipare tutti!", spanish="¡Tendremos que esforzarnos\nal máximo para que todos podamos ir!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yep!", french=" Ouais!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes!", french=" Ouais!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  else
  SkySceneKit.say({english=" Yes!", french=" Ouais!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  end
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- SetAnimation(66) [anim idle native]
  -- SetAnimation(66) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(80)
  GAME:FadeOut(false, 60)
  SkyProg.set(8, 4) -- $SCENARIO_MAIN = scn[8,4] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.REQUEST_CLEAR_COUNT = 0 -- $REQUEST_CLEAR_COUNT = 0 (ROM)
  -- main_SetGround(LEVEL_G01P08A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_G01P04A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
