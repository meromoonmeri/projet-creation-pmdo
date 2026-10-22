-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/s20p0504.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P07A, 'US20') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 208, 168, Direction.DownLeft, "NPC_MARIRU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 184, 160, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 144, 192, Direction.UpRight, "NPC_KOIRU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 152, 160, Direction.DownRight, "NPC_PUKURIN")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 208, 184, Direction.Right, "NPC_RURIRI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  GAME:FadeIn(15)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yeah, that's him all right!", french=" Oui, c'est bien lui!", german=" Ja, das ist er!", italian=" Sì, è proprio lui!", spanish=" ¡Es verdad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yeah, that's him!", french=" Oui, c'est bien lui!", german=" Ja, das ist er!", italian=" Sì, è proprio lui!", spanish=" ¡Ya me acuerdo!"})
  else
  SkySceneKit.say({english=" Yes, that's him all right!", french=" Oui, c'est bien lui!", german=" Ja, das ist er!", italian=" Sì, è proprio lui!", spanish=" ¡Ya me acuerdo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Drowzee[CR] is the first outlaw\nthat we ever caught!", french="[CS:N]Soporifik[CR], c'est le tout premier\nbandit qu'on a attrapé!", german="[CS:N]Traumato[CR] war der erste\nGesetzlose, den wir je gefangen haben!", italian="[CS:N]Drowzee[CR] è il primo ricercato\nche abbiamo catturato!", spanish="¡[CS:N]Drowzee[CR] fue el primer\nmalhechor al que atrapamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Drowzee[CR]...[K] He's that outlaw!\nThe first one we ever caught!", french="[CS:N]Soporifik[CR], c'est le tout premier\nbandit qu'on a attrapé!", german="[CS:N]Traumato[CR]...[K] Dieser Gesetzlose!\nDer erste, den wir je gefangen haben!", italian="[CS:N]Drowzee[CR] è il primo ricercato\nche abbiamo catturato!", spanish="¡[CS:N]Drowzee[CR] fue el primer\nmalhechor al que atrapamos!"})
  else
  SkySceneKit.say({english="[CS:N]Drowzee[CR]...[K] He's that outlaw!\nThe first one we ever caught!", french="[CS:N]Soporifik[CR], c'est le tout premier\nbandit qu'on a attrapé!", german="[CS:N]Traumato[CR] war der erste\nGesetzlose, den wir je gefangen haben!", italian="[CS:N]Drowzee[CR] è il primo ricercato\nche abbiamo catturato!", spanish="¡[CS:N]Drowzee[CR] fue el primer\nmalhechor al que atrapamos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...[K]why [CS:N]Drowzee[CR]?", french=" Mais...[K] pourquoi [CS:N]Soporifik[CR]?", german=" Aber...[K] warum [CS:N]Traumato[CR]?", italian=" Ma...[K] perché [CS:N]Drowzee[CR]?", spanish=" Pero...[K] ¿por qué [CS:N]Drowzee[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...[K]why [CS:N]Drowzee[CR]?", french=" Mais...[K] pourquoi [CS:N]Soporifik[CR]?", german=" Aber...[K] warum [CS:N]Traumato[CR]?", italian=" Ma...[K] perché [CS:N]Drowzee[CR]?", spanish=" Pero...[K] ¿por qué [CS:N]Drowzee[CR]?"})
  else
  SkySceneKit.say({english=" But...[K]why [CS:N]Drowzee[CR]?", french=" Mais...[K] pourquoi [CS:N]Soporifik[CR]?", german=" Aber...[K] warum [CS:N]Traumato[CR]?", italian=" Ma...[K] perché [CS:N]Drowzee[CR]?", spanish=" Pero...[K] ¿por qué [CS:N]Drowzee[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Right)
  GROUND:EntTurn(npc_npc_mariru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" This is just rumor, mind you...", french="Veuillez noter que ce n'est\nqu'une rumeur...", german="Denk daran, das sind nur\nGerüchte...", italian=" Sono solo voci...", spanish="Bueno, no es más que un\nrumor..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But they say that [CS:N]Drowzee[CR] has\nthe amazing ability to enter others' dreams.", french="... mais on raconte que [CS:N]Soporifik[CR]\na l'incroyable pouvoir d'entrer dans les rêves.", german="Aber man sagt, dass [CS:N]Traumato[CR]\ndie erstaunliche Fähigkeit hat, in die Träume\nanderer einzudringen.", italian="Si dice che [CS:N]Drowzee[CR] abbia\nl'incredibile capacità di entrare nei sogni degli\naltri Pokémon.", spanish="Pero dicen que [CS:N]Drowzee[CR] es\ncapaz de penetrar en los sueños ajenos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 208, 216, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 152, 216, Direction.Up, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, "shock", 1) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 184, 216, Direction.Up, "NPC_BIPPA")
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 224, 200, Direction.UpLeft, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 232, 176, Direction.Left, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Really?! He can go into dreams?", french="Vraiment?! Il peut visiter les\nrêves?", german="Wirklich?!? Er kann in Träume\nvon anderen eindringen?", italian="Davvero?! Può davvero entrare\nnei sogni?", spanish="¿De veras? ¿Puede penetrar\nen los sueños?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Really?! He can enter dreams?", french="Vraiment?! Il peut visiter les\nrêves?", german="Wirklich?!? Er kann in Träume\neindringen?", italian="Davvero?! Può davvero entrare\nnei sogni?", spanish="¿De veras? ¿Puede penetrar\nen los sueños?"})
  else
  SkySceneKit.say({english=" Really?! He can go into dreams?", french="Vraiment?! Il peut visiter les\nrêves?", german="Wirklich?!? Er kann in Träume\nvon anderen eindringen?", italian="Davvero?! Può davvero entrare\nnei sogni?", spanish="¿De veras? ¿Puede penetrar\nen los sueños?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's strictly rumor. I couldn't\nvouch for its truth.", french="Ce n'est qu'une rumeur.\nJe ne peux jurer de rien.", german="Es ist nur ein Gerücht. Ich\nwürde meine Hand nicht dafür ins Feuer legen.", italian="Sono solo voci. Non posso\nconfermare che sia la verità.", spanish="Es un rumor. No puedo poner\nla mano en el fuego."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" However, the possibility exists.", french="Cependant, cette possibilité\nexiste bel et bien.", german="Allerdings besteht die\nMöglichkeit.", italian="Tuttavia, esiste la possibilità\nche sia vero.", spanish=" Pero podría ser posible."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Gotcha.[K] So if we were to ask\n[CS:N]Drowzee[CR]...", french="Compris.[K] Donc si nous\nle demandons à [CS:N]Soporifik[CR]...", german="Verstanden.[K] Wenn wir also\n[CS:N]Traumato[CR] fragen würden...", italian="Capito.[K] Quindi, se chiedessimo\na [CS:N]Drowzee[CR]...", spanish="Así que...[K] si se lo pidiéramos\na [CS:N]Drowzee[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK, I get it.[K] So if we were to\nask [CS:N]Drowzee[CR]...", french="Compris.[K] Donc si nous\nle demandons à [CS:N]Soporifik[CR]...", german="Okay, ich habe es kapiert.[K] Wenn\nwir also [CS:N]Traumato[CR] fragen würden...", italian="Ok, ho capito.[K] Quindi, se\nchiedessimo a [CS:N]Drowzee[CR]...", spanish="Así que...[K] si se lo pidiéramos\na [CS:N]Drowzee[CR]..."})
  else
  SkySceneKit.say({english="I get it.[K] So if we were to ask\n[CS:N]Drowzee[CR]...", french="Compris.[K] Donc si nous\nle demandons à [CS:N]Soporifik[CR]...", german="Ich verstehe.[K] Wenn wir also\n[CS:N]Traumato[CR] fragen würden...", italian="Ho capito.[K] Quindi, se\nchiedessimo a [CS:N]Drowzee[CR]...", spanish="Así que...[K] si se lo pidiéramos\na [CS:N]Drowzee[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe he'll be able to get into\n[CS:N]Azurill[CR]'s nightmare!", french="... peut-être qu'il pourra entrer\ndans le cauchemar d'[CS:N]Azurill[CR]!", german="Dann könnte er uns vielleicht in\nden Albtraum von [CS:N]Azurill[CR] hineinbringen!", italian="... forse sarebbe in grado di\nentrare nell'incubo di [CS:N]Azurill[CR]!", spanish="¡Quizás pueda meterse en la\npesadilla de [CS:N]Azurill[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Maybe he'll be able to get into\n[CS:N]Azurill[CR]'s nightmare!", french="... peut-être qu'il pourra entrer\ndans le cauchemar d'[CS:N]Azurill[CR]!", german="Dann könnte er uns vielleicht in\nden Albtraum von [CS:N]Azurill[CR] hineinbringen!", italian="... forse sarebbe in grado di\nentrare nell'incubo di [CS:N]Azurill[CR]!", spanish="¡Quizás pueda meterse en la\npesadilla de [CS:N]Azurill[CR]!"})
  else
  SkySceneKit.say({english="Maybe he'll be able to get into\n[CS:N]Azurill[CR]'s nightmare!", french="... peut-être qu'il pourra entrer\ndans le cauchemar d'[CS:N]Azurill[CR]!", german="Dann könnte er uns vielleicht in\nden Albtraum von [CS:N]Azurill[CR] hineinbringen!", italian="... forse sarebbe in grado di\nentrare nell'incubo di [CS:N]Azurill[CR]!", spanish="¡Quizás pueda meterse en la\npesadilla de [CS:N]Azurill[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [CS:N]Magnemite[CR].", french=" Dis, [CS:N]Magnéti[CR].", german=" Hey, [CS:N]Magnetilo[CR].", italian=" Ehi, [CS:N]Magnemite[CR].", spanish=" Oye, [CS:N]Magnemite[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [CS:N]Magnemite[CR].", french=" Dis, [CS:N]Magnéti[CR].", german=" Hey, [CS:N]Magnetilo[CR].", italian=" Ehi, [CS:N]Magnemite[CR].", spanish=" Oye, [CS:N]Magnemite[CR]."})
  else
  SkySceneKit.say({english=" Say, [CS:N]Magnemite[CR].", french=" Dis, [CS:N]Magnéti[CR].", german=" Sag mal, [CS:N]Magnetilo[CR].", italian=" Ehi, [CS:N]Magnemite[CR].", spanish=" Oye, [CS:N]Magnemite[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_koiru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_koiru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_koiru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_koiru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_koiru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_koiru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_koiru, 4) end)
  GROUND:EntTurn(npc_npc_mariru, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_koiru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What happened to [CS:N]Drowzee[CR] after\nyou guys arrested him?", french="Qu'est devenu [CS:N]Soporifik[CR] après\nson arrestation?", german="Was ist mit [CS:N]Traumato[CR]\ngeschehen, nachdem ihr ihn verhaftet habt?", italian="Cosa ne è stato di [CS:N]Drowzee[CR]\ndopo che l'avete arrestato?", spanish="¿Qué fue de [CS:N]Drowzee[CR] después\nde que lo arrestarais?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What became of [CS:N]Drowzee[CR] after\nyou guys arrested him?", french="Qu'est devenu [CS:N]Soporifik[CR] après\nson arrestation?", german="Was ist mit [CS:N]Traumato[CR]\ngeschehen, nachdem ihr ihn verhaftet habt?", italian="Cosa ne è stato di [CS:N]Drowzee[CR]\ndopo che l'avete arrestato?", spanish="¿Qué fue de [CS:N]Drowzee[CR] después\nde que lo arrestarais?"})
  else
  SkySceneKit.say({english="What became of [CS:N]Drowzee[CR] after\nhis arrest?", french="Qu'est devenu [CS:N]Soporifik[CR] après\nson arrestation?", german="Was ist mit [CS:N]Traumato[CR]\ngeschehen, nachdem ihr ihn verhaftet habt?", italian="Cosa ne è stato di [CS:N]Drowzee[CR]\ndopo che l'avete arrestato?", spanish="¿Qué fue de [CS:N]Drowzee[CR] después\nde que lo arrestarais?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! [CS:N]Drowzee[CR] was subjected to\nintense grilling by Officer [CS:N]Magnezone[CR]. Zzzt!", french="Zzzt! [CS:N]Soporifik[CR] a subi\nun interrogatoire musclé de la part\ndu shérif [CS:N]Magnézone[CR]. Zzzt!", german="Zzzt! [CS:N]Traumato[CR] wurde von\nOberwachtmeister [CS:N]Magnezone[CR] intensiv in die\nMangel genommen. Zzzt!", italian="Zzzt! [CS:N]Drowzee[CR] è stato\ninterrogato per ore dal Commissario\n[CS:N]Magnezone[CR].", spanish="¡Bzz! [CS:N]Drowzee[CR] fue sometido a\nun interrogatorio por el agente [CS:N]Magnezone[CR].\n¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! He expressed remorse.\nHe vowed never to break the law again. Zzzt!", french="Zzzt! Il a exprimé des remords\net juré de ne jamais plus enfreindre la\nloi. Zzzt!", german="Zzzt! Er drückte sein Bedauern\naus und versprach, niemals wieder das Gesetz\nzu brechen. Zzzt!", italian="Zzzt! Ha detto di essersi pentito.\nHa promesso di non infrangere mai più la\nlegge. Zzzt!", spanish="¡Bzz! Dijo que se arrepentía de\ntodo y prometió no volver a quebrantar\nla ley. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english=" Zzzt! So we released him. Zzzt!", french="Zzzt! Nous l'avons donc\nrelâché. Zzzt!", german="Zzzt! Deshalb haben wir ihn\nfreigelassen. Zzzt!", italian="Zzzt! Quindi l'abbiamo\nlasciato andare. Zzzt!", spanish=" ¡Bzz! Así que le soltamos. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! But did he really\nstraighten out?", french="Eh dis donc! Mais est-ce qu'il\ns'est vraiment racheté une conduite?", german="Hey, hey! Aber ist er wirklich\nsauber geblieben?", italian="Ehi, ehi! Ma si sarà davvero\npentito?", spanish="¡Oye, oye! ¿Pero seguro que\nya estaba encarrilado?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Sounds really sketchy, hey, hey?!", french="Ça me paraît un peu rapide,\ntout de même, dis donc!", german="Hört sich aber sehr verdächtig\nan, hey, hey?!?", italian="Sembra un po' sospetto,\nehi, ehi?!", spanish=" ¡No suena muy convincente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_kimawari, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_koiru, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_kimawari, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="[CS:N]Corphish[CR].[K] Now is no time to be\nquibbling over that.", french="[CS:N]Ecrapince[CR].[K] On n'a pas le temps\nde chipoter là-dessus.", german="[CS:N]Krebscorps[CR].[K] Jetzt ist nicht die\nZeit für Spitzfindigkeiten.", italian="[CS:N]Corphish[CR].[K] Non è il momento di\ndiscutere.", spanish="[CS:N]Corphish[CR]...[K] No es el momento\nde discutir esas cosas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kimawari, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" So...[K]where is [CS:N]Drowzee[CR] now?", french=" Alors...[K] où est [CS:N]Soporifik[CR]?", german="Also...[K] wo hält sich [CS:N]Traumato[CR]\nderzeit auf?", italian="Dunque...[K] dove si trova\n[CS:N]Drowzee[CR] adesso?", spanish="Entonces...[K] ¿dónde está [CS:N]Drowzee[CR]\nahora?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_koiru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_koiru, 4) end)
  GROUND:EntTurn(partner, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_koiru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_koiru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_koiru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_koiru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_koiru, 4) end)
  GROUND:EntTurn(npc_npc_mariru, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_koiru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! He has gone away to\ncleanse his mind and spirit. Zzzt!", french="Zzzt! Il est parti se purifier\nl'esprit. Zzzt!", german="Zzzt! Er ist ausgezogen, um\nseinen Geist und sein Bewusstsein zu reinigen.\nZzzt!", italian="Zzzt! È andato via per\npurificare la sua mente e il suo spirito. Zzzt!", spanish="¡Bzz! Ha ido a purificar cuerpo\ny alma. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! He stated that he would\nstudy self-discipline on [CS:P]Mt. Travail[CR]. Zzzt!", french="Zzzt! Il a déclaré qu'il voulait\napprendre l'autodiscipline sur le [CS:P]Mt Labeur[CR].\nZzzt!", german="Zzzt! Er sagte, er wolle\nsich auf dem [CS:P]Mühsalberg[CR] in Selbstdisziplin\nüben. Zzzt!", italian="Zzzt! Ha detto che sarebbe\nandato al [CS:P]Monte Odissea[CR]. Zzzt!", spanish="¡Bzz! Dijo que iría a estudiar\nautodisciplina al [CS:P]Monte Tribulaciones[CR]. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:P]Mt. Travail[CR]?[K] That would be in\nthe mountainous region.", french="Le [CS:P]Mt Labeur[CR]?[K] Ça doit être\ndans la Région Montagneuse.", german="[CS:P]Mühsalberg[CR]?[K] Das wäre in der\nBergregion.", italian="Il [CS:P]Monte Odissea[CR]?[K] Si trova\nnella regione montuosa.", spanish="¿El [CS:P]Monte Tribulaciones[CR]?[K]\nDebe de estar en la zona montañosa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right. So that's where\n[CS:N]Drowzee[CR] is now.", french="Très bien. C'est donc là-bas que\n[CS:N]Soporifik[CR] se trouve.", german="Alles klar. Dort hält sich\n[CS:N]Traumato[CR] also jetzt auf.", italian="Va bene. Quindi è lì che si trova\n[CS:N]Drowzee[CR] adesso.", spanish="De acuerdo. Así que [CS:N]Drowzee[CR]\ndebe encontrarse por esa región."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK. So that's where [CS:N]Drowzee[CR]\nis now.", french="Très bien. C'est donc là-bas que\n[CS:N]Soporifik[CR] se trouve.", german="Okay. Das ist also der derzeitige\nAufenthaltsort von [CS:N]Traumato[CR].", italian="Va bene. Quindi è lì che si trova\n[CS:N]Drowzee[CR] adesso.", spanish="De acuerdo. Así que [CS:N]Drowzee[CR]\ndebe encontrarse por esa región."})
  else
  SkySceneKit.say({english="OK. So that's where [CS:N]Drowzee[CR]\nis now.", french="Très bien. C'est donc là-bas que\n[CS:N]Soporifik[CR] se trouve.", german="Okay. Das ist also der derzeitige\nAufenthaltsort von [CS:N]Traumato[CR].", italian="Va bene. Quindi è lì che si trova\n[CS:N]Drowzee[CR] adesso.", spanish="De acuerdo. Así que [CS:N]Drowzee[CR]\ndebe encontrarse por esa región."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  GROUND:EntTurn(npc_npc_mariru, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_koiru, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to go, [hero]!\nOff to [CS:P]Mt. Travail[CR]!", french="Nous devons y aller,\n[hero]! Direction le [CS:P]Mt Labeur[CR]!", german="Wir müssen los, [hero]!\nAuf zum [CS:P]Mühsalberg[CR]!", italian="Dobbiamo andare, [hero]!\nForza, al [CS:P]Monte Odissea[CR]!", spanish="¡Hay que moverse, [hero]!\n¡Nos vamos al [CS:P]Monte Tribulaciones[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to go, [hero]!\nOff to [CS:P]Mt. Travail[CR]!", french="Nous devons y aller,\n[hero]! Direction le [CS:P]Mt Labeur[CR]!", german="Wir müssen los, [hero]!\nAuf zum [CS:P]Mühsalberg[CR]!", italian="Dobbiamo andare, [hero]!\nForza, al [CS:P]Monte Odissea[CR]!", spanish="¡En marcha, [hero]!\n¡Nos vamos al [CS:P]Monte Tribulaciones[CR]!"})
  else
  SkySceneKit.say({english="We have to go, [hero]!\nOff to [CS:P]Mt. Travail[CR]!", french="Nous devons y aller,\n[hero]! Direction le [CS:P]Mt Labeur[CR]!", german="Wir müssen los, [hero]!\nAuf zum [CS:P]Mühsalberg[CR]!", italian="Dobbiamo andare, [hero]!\nForza, al [CS:P]Monte Odissea[CR]!", spanish="¡Debemos irnos, [hero]!\n¡En marcha hacia el [CS:P]Monte Tribulaciones[CR]!"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Oh, [partner]...", french=" Oh, [partner]...", german=" Oh, [partner]...", italian=" Oh, [partner]...", spanish=" Oh, [partner]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wait for us, [CS:N]Marill[CR].", french=" Attends-nous, [CS:N]Marill[CR].", german=" Warte auf uns, [CS:N]Marill[CR].", italian=" Aspettaci, [CS:N]Marill[CR].", spanish=" Espéranos, [CS:N]Marill[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wait for us, [CS:N]Marill[CR].", french=" Attends-nous, [CS:N]Marill[CR].", german=" Warte auf uns, [CS:N]Marill[CR].", italian=" Aspettaci, [CS:N]Marill[CR].", spanish=" Espéranos, [CS:N]Marill[CR]."})
  else
  SkySceneKit.say({english="Just give us a little time,\n[CS:N]Marill[CR].", french=" Attends-nous, [CS:N]Marill[CR].", german="Gib uns nur ein bisschen Zeit,\n[CS:N]Marill[CR].", italian=" Aspettaci, [CS:N]Marill[CR].", spanish="Danos un poco de tiempo,\n[CS:N]Marill[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Have no fear, we'll be back with\n[CS:N]Drowzee[CR].", french="Ne crains rien, nous reviendrons\navec [CS:N]Soporifik[CR].", german="Keine Angst, wir werden mit\n[CS:N]Traumato[CR] zurückkehren.", italian="Non temere, torneremo con\n[CS:N]Drowzee[CR].", spanish="No temas, volveremos con\n[CS:N]Drowzee[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We promise we'll come back\nwith [CS:N]Drowzee[CR].", french="Ne crains rien, nous reviendrons\navec [CS:N]Soporifik[CR].", german="Wir versprechen, dass wir mit\n[CS:N]Traumato[CR] zurückkommen werden.", italian="Non temere, torneremo con\n[CS:N]Drowzee[CR].", spanish="No temas, volveremos con\n[CS:N]Drowzee[CR]."})
  else
  SkySceneKit.say({english="We'll be sure to come back with\n[CS:N]Drowzee[CR].", french="Ne crains rien, nous reviendrons\navec [CS:N]Soporifik[CR].", german="Wir kommen ganz sicher mit\n[CS:N]Traumato[CR] zurück.", italian="Non temere, torneremo con\n[CS:N]Drowzee[CR].", spanish="Ten por seguro que\nregresaremos con [CS:N]Drowzee[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Urf... [partner]...", french=" Ah... [partner]...", german=" Uff... [partner]...", italian=" Uh... [partner]...", spanish=" Vaya... [partner]..."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="You always, always help us...[K]\nThank you so much.", french="Vous passez votre temps\nà nous aider...[K] Merci pour tout.", german="Ihr seid immer, wirklich immer\nfür uns da...[K] Vielen, vielen Dank!", italian="Siete sempre pronti ad\naiutarci...[K] Grazie mille.", spanish="Siempre nos ayudáis...[K]\nMuchísimas gracias."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(4), p.Y+(4), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" It's decided, then! ♪", french=" C'est décidé, alors! ♪", german=" Dann ist es entschieden! ♪", italian=" Allora è deciso! ♪", spanish=" ¡Decidido! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_koiru, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We'll leave this matter to\nTeam [team:]! ♪", french="Nous confions cette affaire\nà l'Equipe [team:]! ♪", german="Wir überlassen die Angelegenheit\nTeam [team:]! ♪", italian="Lasceremo che se ne occupi\nil Team [team:]! ♪", spanish="¡Dejaremos que el [CS:X]Equipo[CR]\n[team:] se haga cargo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Right)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Everyone is worried about\n[CS:N]Azurill[CR]. But let's have Team [team:]\nhandle it.", french="Tout le monde s'inquiète pour\n[CS:N]Azurill[CR]. Mais l'Equipe [team:]\nva s'en occuper.", german="Alle haben Angst um [CS:N]Azurill[CR].\nAber lassen wir Team [team:] das regeln.", italian="Siamo tutti preoccupati per\n[CS:N]Azurill[CR].\nMa lasciamo fare al Team [team:].", spanish="A todos nos preocupa [CS:N]Azurill[CR],\npero podemos dejarlo en manos del [CS:X]Equipo[CR]\n[team:]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Everyone else should go on\nas usual! ♪", french="Que tout le monde reprenne\nses activités habituelles! ♪", german="Ihr anderen solltet\nweitermachen wie üblich! ♪", italian="Tutti gli altri dovrebbero\ntornare ai loro soliti compiti! ♪", spanish="¡Todos los demás, a proseguir\ncon sus tareas! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone!\nTime for work! ♪", french="Très bien, vous tous!\nAu travail! ♪", german="Alles klar, Leute! Zeit zu\narbeiten! ♪", italian="Forza, gente! È ora di mettersi\nal lavoro! ♪", spanish=" ¡Muy bien! ¡Hora de trabajar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_koiru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, "happy", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Apprentices[CR]: HOORAY!", french="[CS:N]Apprentis[CR]: HOURRA!", german="[CS:N]Lehrlinge[CR]: HURRA!", italian="[CS:N]Apprendisti[CR]: URRÀ!", spanish="[CS:N]Aprendices[CR]: ¡Hurra!"})
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You're in charge of finding\n[CS:N]Drowzee[CR].[K] Don't fail us! ♪", french="Trouver [CS:N]Soporifik[CR] est votre\ndevoir.[K] Il est hors de question pour vous\nd'échouer! ♪", german="Es liegt an euch, [CS:N]Traumato[CR] zu\nfinden.[K] Lasst uns nicht hängen! ♪", italian="Avete il compito di trovare\n[CS:N]Drowzee[CR].[K] Non deludeteci! ♪", spanish="Ahora tenéis que encargaros\nde encontrar a [CS:N]Drowzee[CR].[K]\n¡No nos falléis! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's move!", french=" Très bien! Allons-y!", german=" Alles klar! Los geht's!", italian=" Forza! Andiamo!", spanish=" ¡Muy bien! ¡En marcha!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Let's move it!", french=" Très bien! Allons-y!", german=" Okay! Legen wir los!", italian=" Forza! Andiamo!", spanish=" ¡Muy bien! ¡En marcha!"})
  else
  SkySceneKit.say({english=" OK! Let's go!", french=" Très bien! Allons-y!", german=" Okay! Gehen wir!", italian=" Forza! Andiamo!", spanish=" ¡Muy bien! ¡En marcha!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're heading for [CS:P]Mt. Travail[CR] to\nfind [CS:N]Drowzee[CR]!", french="Allons sur le [CS:P]Mt Labeur[CR] et\ntrouvons [CS:N]Soporifik[CR]!", german="Wir machen uns auf den Weg\nzum [CS:P]Mühsalberg[CR], um [CS:N]Traumato[CR] zu finden!", italian="Dobbiamo recarci al [CS:P]Monte\nOdissea[CR] per trovare [CS:N]Drowzee[CR]!", spanish="¡Rumbo al [CS:P]Monte Tribulaciones[CR]!\n¡En busca de [CS:N]Drowzee[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're off to [CS:P]Mt. Travail[CR]!\nLet's find that [CS:N]Drowzee[CR]!", french="Allons sur le [CS:P]Mt Labeur[CR] et\ntrouvons [CS:N]Soporifik[CR]!", german="Wir machen uns auf den Weg\nzum [CS:P]Mühsalberg[CR]! Lass uns diesen [CS:N]Traumato[CR]\nfinden!", italian="Dobbiamo recarci al [CS:P]Monte\nOdissea[CR] per trovare [CS:N]Drowzee[CR]!", spanish="¡Rumbo al [CS:P]Monte Tribulaciones[CR]!\n¡En busca de [CS:N]Drowzee[CR]!"})
  else
  SkySceneKit.say({english="We're heading for [CS:P]Mt. Travail[CR] to\nfind [CS:N]Drowzee[CR]!", french="Allons sur le [CS:P]Mt Labeur[CR] et\ntrouvons [CS:N]Soporifik[CR]!", german="Wir machen uns auf den Weg\nzum [CS:P]Mühsalberg[CR]! Lass uns diesen [CS:N]Traumato[CR]\nfinden!", italian="Dobbiamo recarci al [CS:P]Monte\nOdissea[CR] per trovare [CS:N]Drowzee[CR]!", spanish="¡Rumbo al [CS:P]Monte Tribulaciones[CR]!\n¡En busca de [CS:N]Drowzee[CR]!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:TeleportTo(hero, 176, 188, Direction.Down)
  GROUND:TeleportTo(partner, 152, 188, Direction.Down)
  GROUND:TeleportTo(npc_npc_koiru, 168, 212, Direction.Down)
  GROUND:TeleportTo(npc_npc_pukurin, 144, 164, Direction.Down)
  GROUND:TeleportTo(npc_npc_perappu, 168, 156, Direction.Down)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GROUND:EntTurn(npc_npc_koiru, Direction.Up)
  GROUND:EntTurn(npc_npc_mariru, Direction.Down)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(45)
  GAME:FadeIn(30)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[62] = 1 -- dungeon_mode(62) = DMODE_OPEN (ROM)
  SkySceneKit.cleanup_npcs()
end
