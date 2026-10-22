-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/s20p0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P07A, 'US20') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 208, 208, Direction.Up, "NPC_SURIIPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 208, 168, Direction.Down, "NPC_MARIRU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 208, 184, Direction.Right, "NPC_RURIRI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" How's it looking, [CS:N]Drowzee[CR]?", french="Alors, qu'est-ce que tu en\npenses, [CS:N]Soporifik[CR]?", german=" Wie sieht es aus, [CS:N]Traumato[CR]?", italian=" Come sta andando, [CS:N]Drowzee[CR]?", spanish=" ¿Qué te parece, [CS:N]Drowzee[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" How is it going, [CS:N]Drowzee[CR]?", french="Alors, qu'est-ce que tu en\npenses, [CS:N]Soporifik[CR]?", german=" Wie sieht es aus, [CS:N]Traumato[CR]?", italian=" Come sta andando, [CS:N]Drowzee[CR]?", spanish=" ¿Qué te parece, [CS:N]Drowzee[CR]?"})
  else
  SkySceneKit.say({english=" How is it going, [CS:N]Drowzee[CR]?", french="Alors, qu'est-ce que tu en\npenses, [CS:N]Soporifik[CR]?", german=" Wie sieht es aus, [CS:N]Traumato[CR]?", italian=" Come sta andando, [CS:N]Drowzee[CR]?", spanish=" ¿Qué te parece, [CS:N]Drowzee[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you getting anywhere?", french=" Tu peux faire quelque chose?", german=" Kommst du voran?", italian=" Puoi fare qualcosa?", spanish=" ¿Has conseguido algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Can you do something?", french=" Tu peux faire quelque chose?", german=" Kannst du irgendetwas tun?", italian=" Puoi fare qualcosa?", spanish=" ¿Has podido hacer algo?"})
  else
  SkySceneKit.say({english=" Can you do something?", french=" Tu peux faire quelque chose?", german=" Kannst du irgendetwas tun?", italian=" Puoi fare qualcosa?", spanish=" ¿Has podido hacer algo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="...[K]Oh, you two![K] I want you\nto get stocked up for an exploration.", french="...[K] Oh, vous deux![K] Je veux que\nvous vous prépariez à une exploration.", german="...[K]Oh, ihr beiden![K] Ich möchte,\ndass ihr euch für eine Erkundung ausrüstet.", italian="...[K] Ah, voi due![K] Preparatevi\nper un'esplorazione.", spanish="Bien...[K] ¡Aquí estáis![K]\nDebéis prepararos para una expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="When you're all ready, I'll send\nyou on an exploration of...[K][CS:N]Azurill[CR]'s dream.", french="Une fois que vous aurez fini\nvos préparatifs, je vous enverrai explorer...[K]\nle rêve d'[CS:N]Azurill[CR].", german="Wenn ihr bereit seid, schicke ich\neuch auf eine Erkundung...[K] In den Traum von\n[CS:N]Azurill[CR].", italian="Quando sarà tutto pronto, vi\nmanderò a esplorare...[K] il sogno di [CS:N]Azurill[CR].", spanish="Cuando lo tengáis todo listo,\nos enviaré...[K] al sueño de [CS:N]Azurill[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] So that means...!", french=" Hein?![K] Alors ça veut dire...!", german=" Wie bitte?!?[K] Das bedeutet...", italian=" Eh?![K] Quindi significa che...!", spanish=" ¡¿Qué?![K] ¡Eso significa que...!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] So that means...!", french=" Hein?![K] Alors ça veut dire...!", german=" Was?!?[K] Das bedeutet...", italian=" Eh?![K] Quindi significa che...!", spanish=" ¡¿Qué?![K] ¡Eso significa que...!"})
  else
  SkySceneKit.say({english=" What?![K] So that means...!", french=" Hein?![K] Alors ça veut dire...!", german=" Was?!?[K] Das bedeutet...", italian=" Eh?![K] Quindi significa che...!", spanish=" ¡¿Qué?![K] ¡Eso significa que...!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_suriipu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="You guessed it.[K] It is possible to\nget into [CS:N]Azurill[CR]'s dream.", french="Vous avez deviné.[K] Il est possible\nd'aller dans le rêve d'[CS:N]Azurill[CR].", german="Ihr habt es erraten.[K] Es ist\nmöglich, in den Traum von [CS:N]Azurill[CR]\nhineinzugelangen.", italian="Avete indovinato.[K] È possibile\nentrare nel sogno di [CS:N]Azurill[CR].", spanish="Pues sí.[K] Se puede penetrar\nen el sueño de [CS:N]Azurill[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yes!", french=" Oui!", german=" Ja!", italian=" Sì!", spanish=" ¡Estupendo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes!", french=" Oui!", german=" Ja!", italian=" Sì!", spanish=" ¡Bien!"})
  else
  SkySceneKit.say({english=" Yes!", french=" Oui!", german=" Ja!", italian=" Sì!", spanish=" ¡Bien!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(npc_npc_mariru, Direction.Left)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Marill[CR]![K] We can tackle the\nmystery of the nightmare now!", french="[CS:N]Marill[CR]![K] Nous pouvons\nrésoudre le mystère du cauchemar!", german="[CS:N]Marill[CR]![K] Wir können jetzt\ndem Rätsel des Albtraums auf den Grund\ngehen!", italian="[CS:N]Marill[CR]![K] Adesso possiamo\nindagare sul mistero dell'incubo!", spanish="¡[CS:N]Marill[CR]![K] ¡Ahora podremos\nresolver el misterio de la pesadilla eterna!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Marill[CR]![K] We can tackle the\nmystery of the unending nightmare now!", french="[CS:N]Marill[CR]![K] Nous pouvons\nrésoudre le mystère du cauchemar!", german="[CS:N]Marill[CR]![K] Wir können jetzt\ndem Rätsel des nicht enden wollenden\nAlbtraums auf den Grund gehen!", italian="[CS:N]Marill[CR]![K] Adesso possiamo\nindagare sul mistero dell'incubo!", spanish="¡[CS:N]Marill[CR]![K] ¡Ahora podremos\nresolver el misterio de la pesadilla eterna!"})
  else
  SkySceneKit.say({english="[CS:N]Marill[CR]![K] We can tackle the\nmystery of the unending nightmare now!", french="[CS:N]Marill[CR]![K] Nous pouvons\nrésoudre le mystère du cauchemar!", german="[CS:N]Marill[CR]![K] Wir können jetzt\ndem Rätsel des nicht enden wollenden\nAlbtraums auf den Grund gehen!", italian="[CS:N]Marill[CR]![K] Adesso possiamo\nindagare sul mistero dell'incubo!", spanish="¡[CS:N]Marill[CR]![K] ¡Ahora podremos\nresolver el misterio de la pesadilla eterna!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Great!", french=" Génial!", german=" Klasse!", italian=" Grandioso!", spanish=" ¡Estupendo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="But I want you to be extra\ncareful when you're inside this kid's dream.", french="Mais je veux que vous fassiez\npreuve de prudence quand vous serez dans le\nrêve de ce garçon.", german="Aber ich will, dass ihr ganz\nbesonders vorsichtig seid, wenn ihr im Traum\ndes Kleinen seid.", italian="Ma voglio che facciate molta\nattenzione quando sarete all'interno del sogno\ndel ragazzo.", spanish="Debéis andar con muchísimo\ncuidado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:EntTurn(npc_npc_mariru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="There's something rotten about\nthis dream...[K] I have a feeling that something\nhas gone bad. Or gone wrong.", french="Il y a quelque chose de bizarre\ndans ce rêve...[K] J'ai l'impression que quelque\nchose a déraillé quelque part.", german="An dem Traum ist irgendwas\nfaul...[K] Ich glaube, da läuft irgendetwas\nverkehrt.", italian="C'è qualcosa che non mi\nconvince...[K] Ho la sensazione che qualcosa sia\nandato storto con questo sogno.", spanish="Algo va mal en su sueño...[K]\nCreo que ha ocurrido algo malo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...[K] Is that right...?", french=" Hein...[K] vraiment...?", german=" Uff...[K] Stimmt das?", italian=" Uh...[K] Dici davvero...?", spanish=" Glup...[K] ¿De verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...[K] Is that right...?", french=" Hein...[K] vraiment...?", german=" Uff...[K] Stimmt das?", italian=" Uh...[K] Dici davvero...?", spanish=" Glup...[K] ¿De verdad?"})
  else
  SkySceneKit.say({english=" Urk...[K] Is that right...?", french=" Hein...[K] vraiment...?", german=" Uff...[K] Stimmt das?", italian=" Uh...[K] Dici davvero...?", spanish=" Glup...[K] ¿De verdad?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. We'll be careful.", french=" D'accord. Nous ferons attention.", german="Alles klar. Wir werden\nvorsichtig sein.", italian=" Ok. Staremo in guardia.", spanish=" Muy bien. Tendremos cuidado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK. We'll be on our guard.", french=" D'accord. Nous ferons attention.", german="Okay, wir werden auf der Hut\nsein.", italian=" Ok. Staremo in guardia.", spanish=" Muy bien. Tendremos cuidado."})
  else
  SkySceneKit.say({english=" OK. We'll be careful.", french=" D'accord. Nous ferons attention.", german="Okay. Wir werden\nvorsichtig sein.", italian=" Ok. Staremo in guardia.", spanish=" Muy bien. Iremos con cuidado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="One more thing.[K] I want only you\ntwo to enter the dream.", french="Une chose encore.[K] Vous ne serez\nque deux dans ce rêve.", german="Noch eine Sache.[K] Ich möchte,\ndass nur ihr beiden in den Traum geht.", italian="Un'altra cosa.[K] Voglio che solo\nvoi due entriate nel sogno.", spanish="Otra cosa...[K]\nNadie más entrará en el sueño."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" I'd prefer to go as well, but...", french=" J'aurais préféré venir mais...", german="Ich würde gerne selber\nmitkommen...", italian=" Preferirei venire anch'io, ma...", spanish=" Me gustaría ir también, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="In all honesty, at my skill level,\nI think I'd slow you down too much.", french="... en toute sincérité, à mon\nniveau, je ne ferais que vous ralentir.", german="Aber um ehrlich zu sein, bei dem\nStand meiner Fähigkeiten würde ich euch nur\naufhalten.", italian="Penso che, visto il mio\nlivello, vi rallenterei troppo.", spanish="Para seros sincero, con mi\nnivel, solo os ralentizaría."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I'm sorry I couldn't do more for\nyou, but...", french="Désolé de ne pas pouvoir faire\nplus pour vous aider...", german="Tut mir leid, dass ich nicht mehr\nfür euch tun kann...", italian="Mi spiace non poter fare di\npiù, ma...", spanish="Lamento no poder ayudaros\nmás..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Don't be silly.[K] You're doing\nplenty, sending us into the dream.", french="Ne dis pas de bêtises.[K] Tu en fais\nénormément en nous envoyant dans ce rêve.", german="Sei nicht albern.[K] Du tust schon\nso viel für uns, indem du uns in den Traum\nhineinschickst.", italian="Non essere sciocco.[K] Stai già\nfacendo molto. Grazie a te riusciremo a\nentrare nel sogno.", spanish="No te preocupes.[K] Con enviarnos\na su sueño estás haciendo más que de sobra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="No, there's no need for that![K]\nSending us into the dream is more than enough!", french="Ne dis pas de bêtises.[K] Tu en fais\nénormément en nous envoyant dans ce rêve.", german="Nein, dazu gibt es keinen\nAnlass![K] Uns in den Traum zu schicken,\nist Hilfe genug!", italian="No, non devi scusarti.[K] Farci\nentrare nel sogno è già molto!", spanish="No te preocupes.[K] Con enviarnos\na su sueño estás haciendo más que de sobra."})
  else
  SkySceneKit.say({english="No, you're great.[K] Just sending us\ninto the dream is plenty.", french="Ne dis pas de bêtises.[K] Tu en fais\ndéjà énormément en nous envoyant dans\nce rêve.", german="Nein, du bist klasse.[K] Uns ist\ndadurch genug geholfen, dass du uns in den\nTraum schickst.", italian="No, sei grandioso.[K] Grazie a te\nriusciremo a entrare nel sogno.", spanish="No te preocupes.[K] Con enviarnos\na su sueño estás haciendo más que de sobra."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Thanks, [CS:N]Drowzee[CR].[K] We'll get\nready to go.", french="Merci, [CS:N]Soporifik[CR].[K] Nous allons\nnous préparer.", german="Danke, [CS:N]Traumato[CR].[K] Wir machen\nuns bereit zu gehen.", italian="Grazie, [CS:N]Drowzee[CR].[K] Noi andiamo a\nprepararci.", spanish="Gracias, [CS:N]Drowzee[CR].[K] Iremos a\nprepararnos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Thank you, [CS:N]Drowzee[CR].[K] We'll get\nready to go.", french="Merci, [CS:N]Soporifik[CR].[K] Nous allons\nnous préparer.", german="Danke dir, [CS:N]Traumato[CR].[K] Wir\nmachen uns bereit zu gehen.", italian="Grazie, [CS:N]Drowzee[CR].[K] Noi andiamo a\nprepararci.", spanish="Gracias, [CS:N]Drowzee[CR].[K] Iremos a\nprepararnos."})
  else
  SkySceneKit.say({english="Thank you, [CS:N]Drowzee[CR].[K] We'll get\nready to go.", french="Merci, [CS:N]Soporifik[CR].[K] Nous allons\nnous préparer.", german="Danke dir, [CS:N]Traumato[CR].[K] Wir\nmachen uns bereit zu gehen.", italian="Grazie, [CS:N]Drowzee[CR].[K] Noi andiamo a\nprepararci.", spanish="Gracias, [CS:N]Drowzee[CR].[K] Iremos a\nprepararnos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's move, [hero]!", french=" Allons-y, [hero]!", german=" Gehen wir, [hero]!", italian=" Muoviamoci, [hero]!", spanish=" ¡En marcha, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's hustle, [hero]!", french=" Allons-y, [hero]!", german=" Los geht's, [hero]!", italian=" Muoviamoci, [hero]!", spanish=" ¡En marcha, [hero]!"})
  else
  SkySceneKit.say({english=" Let's get moving, [hero]!", french=" Allons-y, [hero]!", german=" Ab dafür, [hero]!", italian=" Muoviamoci, [hero]!", spanish=" ¡En marcha, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll come back as soon as we\nget ready!", french="Nous reviendrons quand nous\naurons fini nos préparatifs!", german="Wir kommen zurück, sobald wir\nbereit sind!", italian="Torneremo non appena\nsarà tutto pronto!", spanish="¡Volveremos en cuanto estemos\nlistos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'll be back as soon as we\nget ready!", french="Nous reviendrons quand nous\naurons fini nos préparatifs!", german="Wir kommen zurück, sobald wir\nbereit sind!", italian="Torneremo non appena\nsarà tutto pronto!", spanish="¡Volveremos en cuanto estemos\nlistos!"})
  else
  SkySceneKit.say({english="We'll come back as soon as we\nget ready!", french="Nous reviendrons quand nous\naurons fini nos préparatifs!", german="Wir kommen zurück, sobald wir\nbereit sind!", italian="Torneremo non appena\nsarà tutto pronto!", spanish="¡Volveremos en cuanto nos\nhayamos preparado!"})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
