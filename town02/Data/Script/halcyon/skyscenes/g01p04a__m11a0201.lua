-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m11a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(12, 1) -- $SCENARIO_MAIN = scn[12,1] (ROM)
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM11') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 192, 296, Direction.Down, "NPC_DOGOOMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 232, 224, Direction.Down, "NPC_GUREGGURU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GAME:MoveCamera(484, 252, 1, false) end) -- SetPositionMark performer/caméra
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, let's get back to our guild\ntraining, [hero]!", french="Bon, reprenons l'entraînement\nde la Guilde, [hero]!", german="Tja, machen wir uns\nwieder ans Training, [hero]!", italian="Beh, [hero], si torna\nall'allenamento!", spanish="Bueno, ¡volvamos al\nentrenamiento, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess it's time to get back to\nour guild training, [hero]!", french="Bon, reprenons l'entraînement\nde la Guilde, [hero]!", german="Es ist wohl Zeit, das\nGildentraining wieder aufzunehmen,\n[hero]!", italian="Immagino sia ora di tornare al\nnostro allenamento, [hero]!", spanish="Bueno, ¡volvamos a\nnuestro entrenamiento, [hero]!"})
  else
  SkySceneKit.say({english="I imagine that it's time to get\nback to our guild training, [hero]!", french="Bon, reprenons l'entraînement\nde la Guilde, [hero]!", german="Ich würde sagen, es ist jetzt\nwieder Zeit fürs Gildentraining, [hero]!", italian="Immagino sia ora di tornare al\nnostro allenamento, [hero]!", spanish="Bueno, ¡volvamos al\nentrenamiento, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's work hard at it!", french=" Il faut qu'on travaille dur!", german=" Geben wir uns richtig Mühe!", italian=" Diamoci dentro!", spanish=" ¡Vamos a esforzarnos mucho!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's work hard at it!", french=" Il faut qu'on travaille dur!", german=" Geben wir uns richtig Mühe!", italian=" Mettiamocela tutta!", spanish=" ¡Vamos a esforzarnos mucho!"})
  else
  SkySceneKit.say({english=" Let's work hard at it!", french=" Il faut qu'on travaille dur!", german=" Geben wir uns richtig Mühe!", italian=" Mettiamocela tutta!", spanish=" ¡Vamos a esforzarnos mucho!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(16), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  -- SetAnimation(44) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now that's what I like to see! A\nlot of morning pep! Impressive!", french="Voilà ce que j'aime! De\nl'enthousiasme et de l'énergie dès le matin!\nImpressionnant!", german="So gefallt ihr mir! Mit Schwung\nin den neuen Tag! Ich bin beeindruckt!", italian="Così mi piacete! Traboccanti di\nenergia fin dal mattino!", spanish="¡Así me gusta! ¡Dando ánimos\ndesde las primeras horas de la mañana!\n¡Bien!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Let's see you put that pep to\ngood use today!", french="Mettons votre enthousiasme\nà profit aujourd'hui!", german="Mal sehen, ob ihr diesen\nSchwung heute auch gut nutzen könnt!", italian="Voglio immaginare che\nutilizzerete al meglio tutta questa energia!", spanish=" ¡Espero que sirva de algo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="WHAT?![K] You can't identify the\nfootprint?!", french="QUOI?![K] T'arrives pas\nà identifier l'empreinte?!", german="WAS?!?[K] Du kannst den\nFußabdruck nicht identifizieren?!?", italian="COSA???[K] Non riconosci la\nforma di quella zampa?", spanish="¡¿Qué?![K] ¡¿Cómo que no puedes\nidentificar la huella?!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  pcall(function() GAME:MoveCamera(228, 252, 60, false) end) -- performer/caméra
  pcall(function() GAME:MoveCamera(228, 312, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" What do you MEAN?!", french="Qu'est-ce que tu ENTENDS par\nlà?!", german=" Was soll das HEISSEN?!?", italian=" Vedi di spiegarti MEGLIO!", spanish=" ¡¿Qué quieres decir?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 408, 288, Direction.UpLeft, "NPC_DIGUDA")
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end) -- message_SetActor(ACTOR_NPC_DIGUDA)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I'm trying to tell you![K] I can't\nidentify what I don't know...", french="C'est ce que j'essaie de\nt'expliquer![K] Je ne peux pas identifier ce que\nje ne connais pas...", german="Ich versuche ja, es dir zu\nerklären![K] Ich kann nicht erkennen,\nwas ich nicht kenne...", italian="Ci sto provando![K] Ma non posso\ncerto riconoscere qualcosa che non ho mai\nvisto prima...", spanish="¡Estoy intentando decírtelo![K]\nNo puedo identificar lo que no conozco."})
  -- message_Close
  GROUND:TeleportTo(npc_npc_perappu, 360, 276, Direction.Down)
  GROUND:TeleportTo(hero, 368, 284, Direction.Down)
  GROUND:TeleportTo(partner, 392, 284, Direction.Down)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-96), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-112), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-104), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_perappu, 224, 276, false, 2)
  GROUND:MoveToPosition(hero, 248, 292, false, 2)
  GROUND:MoveToPosition(partner, 256, 308, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What's wrong?", french=" Quel est le problème?", german=" Wo liegt das Problem?", italian=" Cosa succede?", spanish=" ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="We have a Pokémon visitor up\ntop whose footprint we can't identify!", french="On a un visiteur dont\non n'arrive pas à identifier l'empreinte!", german="Auf dem Gitter steht ein\nPokémon, dessen Fußabdruck wir nicht\nidentifizieren können!", italian="È arrivato un Pokémon in visita\ne non riusciamo a riconoscere la forma della\nsua zampa!", spanish="¡Tenemos un visitante Pokémon\ncuya huella no podemos identificar!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" [CS:N]Diglett[CR] is an outstanding sentry.", french="[CS:N]Taupiqueur[CR] est une sentinelle\nexceptionnelle.", german="[CS:N]Digda[CR] ist ein hervorragender\nWachposten.", italian="[CS:N]Diglett[CR] è una sentinella\neccellente.", spanish=" [CS:N]Diglett[CR] es un centinela impecable."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="So it's rare for him to be\nstumped by footprints!", french="Alors c'est rare qu'une\nempreinte lui pose problème!", german="Es kommt selten vor, dass er\nbei einem Fußabdruck passen muss!", italian="È molto difficile che non riesca\na riconoscere la forma della zampa di\nqualcuno!", spanish="¡Así que no es normal que no\nsepa identificar una huella!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="If THOSE two were doing sentry\nduty, that'd be no shocker...", french="Si c'était CES DEUX-LA qui\nétaient de garde, je serais pas étonné...", german="Wenn DIESE beiden Wachdienst\nhätten, wäre es keine Überraschung...", italian="Certo, non ci sarebbe niente di\nstrano se ci fossero QUELLE DUE reclute\nal posto di guardia...", spanish="Si cierta pareja estuviera de\nguardia, no le extrañaría a nadie..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "angry", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yeah, right![K] So [CS:N]Diglett[CR] never\nfails to deliver, huh?", french="Ah vraiment![K] Alors puisque c'est\nsi rare que [CS:N]Taupiqueur[CR] sèche...", german="Ja, genau![K] [CS:N]Digda[CR] macht also\nnie einen Fehler, was?", italian="Sì, come no![K] E così [CS:N]Diglett[CR] non\nsbaglierebbe mai, eh?", spanish="¡Ya, claro![K] Así que [CS:N]Diglett[CR]\nnunca falla, ¿eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, really?[K] Well, if it's so rare\nthat [CS:N]Diglett[CR] gets stumped...", french="Ah vraiment![K] Alors puisque c'est\nsi rare que [CS:N]Taupiqueur[CR] sèche...", german="Oh, tatsächlich?[K] Tja, wenn es so\nselten vorkommt, dass [CS:N]Digda[CR] passen muss...", italian="Ehi![K] Ma nemmeno [CS:N]Diglett[CR] è\nperfetto...", spanish="¿Ah, sí?[K] Si es tan poco habitual\nque [CS:N]Diglett[CR] no reconozca una huella..."})
  else
  SkySceneKit.say({english="Who are you kidding?[K] If [CS:N]Diglett[CR]\nhere never gets stumped...", french="Ah vraiment![K] Alors puisque c'est\nsi rare que [CS:N]Taupiqueur[CR] sèche...", german="Wem willst du das\nweismachen?[K] Wenn [CS:N]Digda[CR] wirklich jeden\nFußabdruck kennt...", italian="Ehi![K] Ma nemmeno [CS:N]Diglett[CR] è\nperfetto...", spanish="¿A quién quieres engañar?[K]\nSi [CS:N]Diglett[CR] no falla con ninguna huella..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What about when we first got\nto the guild?", french="... comment tu expliques ce qui\ns'est passé à notre arrivée à la Guilde?", german="Was war dann, als wir das\nerste Mal zur Gilde kamen?", italian="E che mi dici allora di quando ci\nsiamo presentati qui per la prima volta, eh?", spanish="¿Qué fue lo que pasó cuando\nllegamos al [CS:N]Pokégremio[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What about when we first\narrived at the guild?", french="... comment tu expliques ce qui\ns'est passé à notre arrivée à la Guilde?", german="Was war dann, als wir das\nerste Mal zur Gilde kamen?", italian="Ricordate la prima volta che ci\nsiamo presentati alla Gilda?", spanish="¿Qué fue lo que pasó cuando\nllegamos al [CS:N]Pokégremio[CR]?"})
  else
  SkySceneKit.say({english="What about when we first\narrived at the guild?", french="... comment tu expliques ce qui\ns'est passé à notre arrivée à la Guilde?", german="Was war dann, als wir das\nerste Mal zur Gilde kamen?", italian="Avete dimenticato il nostro\nprimo giorno alla Gilda?", spanish="¿Qué fue lo que pasó cuando\nllegamos al [CS:N]Pokégremio[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You guys couldn't figure out\n[hero]'s footprint!", french="Vous n'avez pas été fichus\nd'identifier l'empreinte de [hero]!", german="Da habt ihr den Fußabdruck\nvon [hero] nicht erkannt!", italian="Non siete mica riusciti a\nriconoscere la forma della zampa di\n[hero]!", spanish="¡No fuisteis capaces de\nreconocer la huella de [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You guys couldn't recognize\n[hero]'s footprint.", french="Vous n'avez pas été fichus\nd'identifier l'empreinte de [hero]!", german="Da habt ihr den Fußabdruck\nvon [hero] nicht erkannt!", italian="Non avete riconosciuto la forma\ndella zampa di [hero].", spanish="¡No fuisteis capaces de\nreconocer la huella de [hero]!"})
  else
  SkySceneKit.say({english="You guys couldn't figure out\n[hero]'s footprint!", french="Vous n'avez pas été fichus\nd'identifier l'empreinte de [hero]!", german="Da habt ihr den Fußabdruck\nvon [hero] nicht erkannt!", italian="Non avete riconosciuto la forma\ndella zampa di [hero].", spanish="¡No pudisteis reconocer la huella\nde [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Right, [hero]?", french=" Pas vrai, [hero]?", german=" Nicht wahr, [hero]?", italian=" Dico male, [hero]?", spanish=" ¿Verdad, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Right, [hero]?", french=" Pas vrai, [hero]?", german=" Nicht wahr, [hero]?", italian=" Giusto, [hero]?", spanish=" ¿Verdad, [hero]?"})
  else
  SkySceneKit.say({english=" Right, [hero]?", french=" Pas vrai, [hero]?", german=" Nicht wahr, [hero]?", italian=" Giusto, [hero]?", spanish=" ¿Verdad, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end) -- message_SetActor(ACTOR_NPC_DIGUDA)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="...Hmmm?[K] ...Say again?[K]\nYou want to meet our Guildmaster?", french="... Hum?[K] ... Vous pourriez\nrépéter?[K] Vous voulez voir le Maître de\nla Guilde?", german="...Hmmm?[K] ...Wie bitte?[K]\nDu willst unseren Gildenmeister treffen?", italian="Mmm?[K] Come dici?[K]\nVuoi incontrare il capo della nostra Gilda?", spanish="¿Qué?[K] ¿Cómo dices?[K] ¿Que\nquieres ver al Gran Bluff?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Down)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Your name is...[K] [CS:N]Dusknoir[CR]?![K]\nOh! Please wait just a moment!", french="Et vous vous appelez...[K]\n[CS:N]Noctunoir[CR]?![K] Oh, veuillez patienter une petite\nseconde, je vous prie!", german="Dein Name ist...[K]\n[CS:N]Zwirrfinst[CR]?!?[K] Oh! Einen Moment, bitte!", italian="Ti chiami...[K] [CS:N]Dusknoir[CR]?[K]\nOh! Un attimo di pazienza, allora!", spanish="Dices que te llamas...[K] ¡¿[CS:N]Dusknoir[CR]?![K]\n¡Ah! ¡Espera un momento!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [CS:N]Dus[CR]...[CS:N]Dusknoir[CR]?!", french=" [CS:N]Noc[CR]... [CS:N]Noctunoir[CR]?!", german=" [CS:N]Zwirr[CR]...[CS:N]Zwirrfinst[CR]?!?", italian=" [CS:N]Dus[CR]... [CS:N]Dusknoir[CR]?!", spanish=" [CS:N]Dus[CR]... ¡¿[CS:N]Dusknoir[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" The world-famous [CS:N]Dusknoir[CR]?!", french=" Le célébrissime [CS:N]Noctunoir[CR]?!", german=" Der weltberühmte [CS:N]Zwirrfinst[CR]?!?", italian=" Il famoso [CS:N]Dusknoir[CR]?!", spanish=" ¡¿El famosísimo [CS:N]Dusknoir[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 60)
  -- supervision_Acting(1) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(324, 204, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(npc_npc_perappu, 344, 212, Direction.Down)
  GROUND:TeleportTo(hero, 256, 292, Direction.Down)
  GROUND:TeleportTo(partner, 232, 292, Direction.Down)
  GROUND:TeleportTo(npc_npc_dogoomu, 256, 268, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 344, 192, Direction.Left, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Thank you for visiting! What an\nhonor!", french="Nous vous remercions de nous\nrendre visite! C'est un grand honneur!", german="Danke für den Besuch! Welch\neine Ehre!", italian="Grazie per la sua visita! È un\nvero onore averla qui con noi! ♪", spanish="¡Gracias por visitarnos!\n¡Qué honor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 304, 192, Direction.Right, "NPC_YONOWAARU")
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" No, no! Think nothing of it!", french="Mais non, voyons, n'en faites\nrien!", german="Ach was! Das ist doch\nselbstverständlich!", italian="Sono io ad essere onorato della\nvostra accoglienza.", spanish=" ¡No, no, por favor!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" The honor is all mine!", french=" Tout l'honneur est pour moi!", german=" Es ist mir eine Ehre!", italian=" Piacere di conoscervi!", spanish=" ¡El honor es mío!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="There is no greater pleasure\nthan visiting [CS:N]Wigglytuff[CR]'s Guild! It's famous!", french="Rien ne peut me faire davantage\nplaisir que de visiter la Guilde de [CS:N]Grodoudou[CR]!\nVotre renommée n'est plus à faire!", german="Es bereitet mir das größte\nVergnügen, die [CS:N]Knuddeluff-Gilde[CR] zu besuchen!\nSie ist berühmt!", italian="Non esiste piacere più grande di\nvisitare la rinomata Gilda di [CS:N]Wigglytuff[CR]!", spanish="¡No hay mayor placer que visitar\nel ilustre [CS:N]Pokégremio de Exploradores[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(248, 280, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [CS:N]Loudred[CR].", french=" Dis, [CS:N]Ramboum[CR].", german=" Hey, [CS:N]Krakeelo[CR].", italian=" Ehi, [CS:N]Loudred[CR]...", spanish=" Oye, [CS:N]Loudred[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Excuse me, [CS:N]Loudred[CR]?", french=" Dis, [CS:N]Ramboum[CR].", german=" Entschuldige bitte, [CS:N]Krakeelo[CR]?", italian=" Scusami, [CS:N]Loudred[CR].", spanish=" Disculpa, [CS:N]Loudred[CR]..."})
  else
  SkySceneKit.say({english=" Tell me, [CS:N]Loudred[CR]...", french=" Dis, [CS:N]Ramboum[CR].", german=" Sag mal, [CS:N]Krakeelo[CR]...", italian=" Scusami, [CS:N]Loudred[CR].", spanish=" Dime una cosa, [CS:N]Loudred[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" What do you want?", french=" Tu veux quoi?", german=" Was willst du?", italian=" Cosa c'è?", spanish=" ¿Qué quieres?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who's that visitor?", french=" C'est qui cet étranger?", german=" Wer ist dieser Besucher?", italian=" Chi è quel tizio?", spanish=" ¿Quién es ese visitante?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who's that visitor?", french=" C'est qui cet étranger?", german=" Wer ist dieser Besucher?", italian=" Chi è questo visitatore?", spanish=" ¿Quién es ese visitante?"})
  else
  SkySceneKit.say({english=" Who's that visitor?", french=" C'est qui cet étranger?", german=" Wer ist dieser Besucher?", italian=" Chi è questo visitatore?", spanish=" ¿Quién es ese visitante?"})
  end
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 232, 256, Direction.UpRight, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 288, 272, Direction.UpRight, "NPC_BIPPA")
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="WHAT?![K] You haven't heard of\n[CS:N]Dusknoir[CR]?!", french="QUOI?![K] T'as jamais entendu\nparler de [CS:N]Noctunoir[CR]?!", german="WAS?!?[K] Ihr habt nichts von\n[CS:N]Zwirrfinst[CR] gehört?!?", italian="COOOOSA?[K] Non hai mai\nsentito parlare di [CS:N]Dusknoir[CR]?!", spanish="¡¿Qué?![K] ¡¿No habéis oído hablar\nde [CS:N]Dusknoir[CR]?!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" The famous explorer?!", french=" Le célèbre explorateur?!", german=" Dem berühmten Erkunder?!?", italian="È l'esploratore più famoso del\nmondo!", spanish=" ¡¿El famoso explorador?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! Well, uh, well...", french=" Argh! Eh bien, euh...", german=" Urk! Na ja, äh, also...", italian="Oops! Beh, mmm, certo che sì...\nInsomma...", spanish=" Bueno, yo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk... Well, you know, I...", french=" Argh! Eh bien, euh...", german=" Urk, na ja, weißt du, ich...", italian="Oh! Ehm, dovete sapere che...\nSì insomma...", spanish=" Bueno, yo... La verdad..."})
  else
  SkySceneKit.say({english=" Eeek... Well, maybe, I...", french=" Argh! Eh bien, euh...", german=" Ieeek! Also, vielleicht...", italian="Oh! Ehm, dovete sapere che...\nSì, insomma...", spanish=" Bueno, tal vez, yo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK, I don't know!", french="Bon, ça va, j'avoue: je ne sais\npas qui c'est!", german=" Okay, ich kenne ihn nicht!", italian=" Ok! No, non lo conosco!", spanish=" ¡Vale, no tengo ni idea!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I haven't heard of him!", french="Bon, ça va, j'avoue: je ne sais\npas qui c'est!", german="Ich habe noch nie etwas von\nihm gehört!", italian=" Ecco... No, non lo conosco.", spanish=" Nunca había oído hablar de él."})
  else
  SkySceneKit.say({english=" OK, I admit it...I haven't!", french="Bon, ça va, j'avoue: je ne sais\npas qui c'est!", german="Okay, ich gebe es zu. Ich kenne\nihn nicht!", italian=" Ecco... No, non lo conosco.", spanish=" Vale, lo admito... ¡No!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" That's not surprising, really!", french=" Ça n'a rien d'étonnant!", german="Das überrascht mich eigentlich\nnicht!", italian=" In effetti, non è poi così strano.", spanish=" ¡Tampoco es tan sorprendente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_kimawari, 4) end)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" He's a new arrival on the scene!", french="Il vient à peine de commencer\nsa carrière d'explorateur!", german=" Er ist erst seit Kurzem bekannt!", italian="Non è da molto che è diventato\ncosì famoso!", spanish="¡No hace mucho que se\nha hecho famoso!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="He came out of nowhere! Like a\ncomet! He became famous almost overnight!", french="Il est apparu de nulle part!\nComme une étoile filante! Et il est devenu\ncélèbre du jour au lendemain!", german="Er ist aus dem Nichts\naufgetaucht! Wie ein Komet! Er wurde über\nNacht berühmt!", italian="È apparso sulla scena davvero\nall'improvviso! Come dal nulla! È\ndiventato famoso nel giro di pochissimo!", spanish="¡Salió de la nada y se hizo\nfamoso de la noche a la mañana!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="They say his talents as an\nexplorer are superexceptional!", french="On raconte que ses talents\nd'explorateur sont absolument pro-di-gieux!", german="Seine Fähigkeiten als Erkunder\nsollen ganz außergewöhnlich sein!", italian="Dicono che sia un esploratore dal\ntalento supereccezionale!", spanish="¡Dicen que su talento como\nexplorador es superexcepcional!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So he's really that big of a deal,\nthis [CS:N]Dusknoir[CR]?", french="Alors il est vraiment si fort\nque ça, ce [CS:N]Noctunoir[CR]?", german="Ist er also wirklich so eine\ngroße Nummer, dieser [CS:N]Zwirrfinst[CR]?", italian="Wow! E così questo [CS:N]Dusknoir[CR]\nè davvero un pezzo grosso, eh?", spanish="¿Y realmente es para tanto\neste [CS:N]Dusknoir[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So this [CS:N]Dusknoir[CR] is really that\namazing?", french="Alors il est vraiment si fort\nque ça, ce [CS:N]Noctunoir[CR]?", german="Dieser [CS:N]Zwirrfinst[CR] ist also\nwirklich so umwerfend?", italian="Ooh! [CS:N]Dusknoir[CR] è davvero così\nin gamba?", spanish="¿Y de verdad es tan increíble\neste [CS:N]Dusknoir[CR]?"})
  else
  SkySceneKit.say({english=" So [CS:N]Dusknoir[CR] is really so great?", french="Alors il est vraiment si fort\nque ça, ce [CS:N]Noctunoir[CR]?", german="Dieser [CS:N]Zwirrfinst[CR] ist also\nwirklich so großartig?", italian="Ooh! [CS:N]Dusknoir[CR] è davvero così\nin gamba?", spanish="¿Y realmente es para tanto este\n[CS:N]Dusknoir[CR]?"})
  end
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_dogoomu, 4) end)
  -- message_FacePositionOffset(3, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Yeah! Here's some more good\nstuff that I heard!", french="Ouais! Et c'est pas tout!\nEcoutez ce que j'ai entendu dire.", german="Oh ja! Ich habe noch mehr über\nihn gehört!", italian=" Oh sì! E c'è di più!", spanish="¡Sí! ¡Y no sabéis las cosas que\nhe oído sobre él!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="He does things unlike anyone\nelse! First, he doesn't work in a team.[K] He does\nall his exploring solo.", french="Il fait rien comme les autres!\nDéjà, il ne travaille pas en équipe.[K] Il part\ntoujours en exploration en solo.", german="Er geht die Dinge anders als alle\nanderen an. Erstens arbeitet er nicht in einem\nTeam.[K] Er erkundet immer allein.", italian="Compie le sue imprese in modo\ndiverso dagli altri! Come prima cosa, non ha\nuna squadra.[K] Lui lavora da solo.", spanish="No hace las cosas como los demás.\nPara empezar, trabaja solo.[K] No explora\nen equipo."})
  -- message_Close
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Alone?", french=" Tout seul?", german=" Allein?", italian=" Da solo?", spanish=" ¿Solo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Alone?", french=" Tout seul?", german=" Allein?", italian=" Da solo?", spanish=" ¿Solo?"})
  else
  SkySceneKit.say({english=" Alone?", french=" Tout seul?", german=" Allein?", italian=" Da solo?", spanish=" ¿Solo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="That's right! He's got to be\npretty sure about his skills to do that!", french="Exact! Il faut vraiment avoir\nconfiance en son talent pour faire ça!", german="Genau! Dazu muss er sich seiner\nFähigkeiten ziemlich sicher sein!", italian="Proprio così! Solo un\nesploratore eccezionale può permettersi di\nlavorare da solo!", spanish="¡Así es! ¡Uno tiene que estar muy\nseguro de sus habilidades para hacer eso!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="But what's even more\nincredible?[K] His wealth of knowledge!", french="Encore plus incroyable:[K]\nil sait plein de choses!", german="Aber wisst ihr, was noch\nunglaublicher ist?[K] Sein unheimliches Wissen!", italian="Ma sapete cos'è davvero\nincredibile?[K] La sua conoscenza!", spanish="Pero, ¿sabéis lo que es más\nincreíble?[K] ¡Su gran sabiduría!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="It seems like there's nothing in\nthe world he doesn't know![K] That's how much\nhe knows!", french="On dirait qu'il y a rien au\nmonde qu'il connaisse pas![K] Vous imaginez?", german="Es scheint nichts auf der Welt\nzu geben, das er nicht weiß![K] So viel weiß er!", italian="Sembra che non ci sia niente al\nmondo che lui non conosca![K] È fenomenale!", spanish="¡Es como si lo supiera absolutamente\ntodo![K] ¡No hay ni una sola cosa que desconozca!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wow! So he knows that much?", french="Waouh! Alors il sait tant\nde choses que ça?", german=" Wow! Er weiß wirklich so viel?", italian="Wow! Pazzesco! È un pozzo di\nscienza, eh?", spanish=" ¡Vaya! ¿Y realmente sabe tanto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow! He's that knowledgeable?", french="Waouh! Alors il sait tant\nde choses que ça?", german=" Wow! Ist er so klug?", italian="Ooh! È veramente\nimpressionante!", spanish=" ¡Vaya! ¿Y realmente sabe tanto?"})
  else
  SkySceneKit.say({english="Oh, wow! So, he's really that\nknowledgeable?", french="Waouh! Alors il sait tant\nde choses que ça?", german="Oh, wow! Er ist also wirklich\nso klug?", italian="Ooh! È veramente\nimpressionante!", spanish=" ¡Vaya! ¿Y realmente sabe tanto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" So the rumor goes!", french=" C'est ce qu'on raconte!", german=" So lautet das Gerücht!", italian=" Così si dice in giro!", spanish=" ¡Eso dicen!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="But he has used his knowledge\nto succeed on many explorations so far!", french="Et ses connaissances lui ont\nété bien utiles pour mener à bien un max\nd'explorations!", german="Aber sein Wissen hat er schon\ndurch viele erfolgreiche Erkundungen bewiesen!", italian="Ha portato a termine molte\nincredibili esplorazioni grazie alla sua\nconoscenza!", spanish="¡Ha superado con éxito muchas\nmisiones gracias a su gran conocimiento!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="So many Pokémon revere\n[CS:N]Dusknoir[CR] for his achievements...", french="Il y a tant de Pokémon qui\nadmirent les exploits de [CS:N]Noctunoir[CR]...", german="Viele Pokémon bewundern\n[CS:N]Zwirrfinst[CR] für seine Leistungen...", italian="Molti Pokémon hanno una\nprofonda ammirazione per [CS:N]Dusknoir[CR]...", spanish="Muchos Pokémon veneran a\n[CS:N]Dusknoir[CR] por sus logros..."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="That's how I know the claims\nabout his mighty knowledge must be true!", french="... que tout ce qu'on dit à son\nsujet est forcément vrai!", german="Darum weiß ich, dass die\nGerüchte über sein großes Wissen stimmen!", italian="Le voci sulla sua inesauribile\nconoscenza devono essere per forza vere!", spanish="¡Por eso sé que lo que dicen\nde su sabiduría tiene que ser cierto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Does [CS:N]Dusknoir[CR] visit here often?", french="Est-ce que [CS:N]Noctunoir[CR] vient\nsouvent ici?", german="Kommt [CS:N]Zwirrfinst[CR] hier oft\nzu Besuch?", italian=" [CS:N]Dusknoir[CR] viene spesso qui?", spanish="¿Y este [CS:N]Dusknoir[CR] viene por aquí\na menudo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Does [CS:N]Dusknoir[CR] visit here often?", french="Est-ce que [CS:N]Noctunoir[CR] vient\nsouvent ici?", german="Kommt [CS:N]Zwirrfinst[CR] hier oft\nzu Besuch?", italian="[CS:N]Dusknoir[CR] viene spesso qui in\nvisita?", spanish=" ¿[CS:N]Dusknoir[CR] viene mucho por aquí?"})
  else
  SkySceneKit.say({english=" Does [CS:N]Dusknoir[CR] visit here often?", french="Est-ce que [CS:N]Noctunoir[CR] vient\nsouvent ici?", german="Kommt [CS:N]Zwirrfinst[CR] hier oft\nzu Besuch?", italian="[CS:N]Dusknoir[CR] viene spesso qui in\nvisita?", spanish="¿[CS:N]Dusknoir[CR] viene por aquí\na menudo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="No, this is his first time![K] That's\nwhy [CS:N]Diglett[CR] couldn't recognize him.", french="Non, c'est la première fois![K]\nC'est pour ça que [CS:N]Taupiqueur[CR] a pas réussi\nà le reconnaître.", german="Nein, das ist das erste Mal![K]\nDarum hat [CS:N]Digda[CR] ihn nicht erkannt.", italian="No, è la prima volta![K] Per\nquesto [CS:N]Diglett[CR] non è riuscito a riconoscerlo!", spanish="No, esta es la primera vez.[K]\n¿No has visto que [CS:N]Diglett[CR] no le reconocía?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I think the Guildmaster just met\nhim for the first time, too.", french="Je crois que c'est la première\nfois aussi que le Maître de la Guilde\nle rencontre.", german="Ich glaube, der Gildenmeister\ntrifft ihn auch gerade zum ersten Mal.", italian="Credo anche che sia la prima\nvolta che il Capitano lo incontra.", spanish="Creo que el Gran Bluff también\nle acaba de conocer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?!", french=" Pardon?!", german=" Was?!?", italian=" Eeh?!", spanish=" ¡¿Eh?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?!", french=" Pardon?!", german=" Was?!?", italian=" Davvero?!", spanish=" ¡¿Eh?!"})
  else
  SkySceneKit.say({english=" Pardon?!", french=" Pardon?!", german=" Wie bitte?!?", italian=" Davvero?!", spanish=" ¡¿Eh?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Then why is he being that\nfriendly?", french="Alors pourquoi il se montre si\namical?", german="Warum ist er dann so\nfreundlich?", italian="E allora perché è così\namichevole con lui?", spanish="Entonces, ¡¿por qué lo trata\ncomo si fueran amigos de toda la vida?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Then why is he being that\nfriendly?", french="Alors pourquoi il se montre si\namical?", german="Warum ist er dann so\nfreundlich?", italian="E allora perché è così\namichevole con lui?", spanish="Entonces, ¡¿por qué lo trata\ncomo si fueran amigos de toda la vida?!"})
  else
  SkySceneKit.say({english="Then why is he being that\nfriendly?", french="Alors pourquoi il se montre si\namical?", german="Warum ist er dann so\nfreundlich?", italian="E allora perché è così\namichevole con lui?", spanish="Entonces, ¡¿por qué lo trata\ncomo si fueran amigos de toda la vida?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Well, that's just how our\nGuildmaster is.", french="Ben, il est comme ça, le Maître\nde la Guilde.", german="Tja, so ist unser Gildenmeister\neben.", italian="Beh, quello è il naturale\ncomportamento del Capitano!", spanish=" Ya sabes cómo es el Gran Bluff."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Even if it's the first time he\nmeets someone.", french="Même quand il rencontre\nquelqu'un pour la première fois.", german="Sogar wenn er jemanden zum\nersten Mal trifft.", italian="Si comporta sempre così, anche\nla prima volta che incontra qualcuno.", spanish=" Aunque te acabe de conocer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() GAME:MoveCamera(324, 204, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="...I see.[K] Well, that must have\nbeen quite a disappointment for your guild!", french="... Je vois.[K] Eh bien, cela a dû\nreprésenter une immense déception pour\nvotre Guilde!", german="...Verstehe.[K] Nun, das muss eine\nziemliche Enttäuschung für deine Gilde\ngewesen sein!", italian="Capisco.[K] Dev'essere stata\nuna terribile delusione per la tua Gilda!", spanish="Ya veo.[K] ¡Vaya, ha tenido que ser\ntoda una decepción para el [CS:N]Pokégremio[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yes, that expedition was a waste\nof time! Didn't learn a thing about anything!", french="Oui, cette expédition a été\nune perte de temps! Nous n'avons rien\nappris de plus!", german="Ja, diese Expedition war reine\nZeitverschwendung! Wir haben nicht das\nGeringste herausgefunden!", italian="Eh già! Quella spedizione è stata\nuna vera perdita di tempo! Non abbiamo\nscoperto un bel niente!", spanish="Sí, esa expedición fue una\npérdida de tiempo. ¡No descubrimos nada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I had heard that [CS:N]Wigglytuff[CR]'s\nGuild was mounting an expedition to find\n[CS:P]Fogbound Lake[CR].", french="J'ai ouï dire que la Guilde de\n[CS:N]Grodoudou[CR] préparait une expédition dans le but\nde trouver le [CS:P]Lac des Brumes[CR].", german="Ich hatte gehört, dass die\n[CS:N]Knuddeluff-Gilde[CR] eine Expedition zur Suche\nnach dem [CS:P]Nebelsee[CR] plante.", italian="Avevo saputo che la Gilda\ndi [CS:N]Wigglytuff[CR] stava preparando una spedizione\nper trovare il [CS:P]Lago Foschia[CR].", spanish="Había oído que el [CS:N]Pokégremio[CR]\n[CS:N]de Exploradores[CR] iba a salir de expedición\nen busca del [CS:P]Lago Velado[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I came here hoping to hear about\nyour latest triumph...", french="Je suis venu céans dans l'espoir\nque vous me contiez votre triomphal exploit...", german="Ich kam hierher in der Hoffnung,\netwas über euren neuesten Triumph zu hören...", italian="Ero giunto qui con la speranza\ndi sentire tutto del vostro successo...", spanish="Vine aquí esperando escuchar\nnoticias sobre vuestro último triunfo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Sorry! We didn't learn a thing!", french="Désolé! On est rentrés\nbredouilles!", german="Tut mir leid! Wir haben nichts\nentdeckt!", italian="Spiacente! ♪ Non c'è stato\nalcun successo! ♪", spanish="¡Lo siento!\n¡No descubrimos nada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Not at all! It's no trouble to me!", french="Je vous en prie, il n'est nul\nexplorateur en ce monde qui soit infaillible!", german="Kein Grund, sich zu\nentschuldigen! Ich bin darüber nicht\nunglücklich!", italian=" Non importa!", spanish=" No importa. No pasa nada."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="This gave me an opportunity to\nvisit you!", french="Ainsi, j'ai eu l'opportunité\nde faire votre rencontre à tous!", german="Immerhin war es ein Anlass,\neuch zu besuchen!", italian="Ho avuto l'opportunità di venire\na farvi visita!", spanish="Así he tenido la ocasión de\nvisitaros."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I plan to stay in Treasure Town\nfor a short while.", french="J'escompte séjourner quelque\ntemps dans votre bonne ville de Bourg-Trésor.", german="Ich habe vor, eine Weile in\nSchatzstadt zu bleiben.", italian="È mia intenzione trascorrere del\ntempo qui a Borgo Tesoro.", spanish="Pienso quedarme unos días\nen Aldea Tesoro."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="May I visit with you occasionally\nduring my stay?", french="Puis-je vous rendre visite\nà l'occasion durant mon séjour?", german="Darf ich während meines\nAufenthalts gelegentlich vorbeikommen?", italian="Vorrei chiedervi il permesso di\nvenirvi a trovare ogni tanto.", spanish="¿Os importa que os visite de\nvez en cuando mientras siga por aquí?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Your guild constantly receives\nthe latest news. Good information would be a\nbig help on my explorations!", french="Votre Guilde est toujours au fait\ndes dernières nouvelles! Un explorateur digne\nde ce nom se doit d'être bien informé!", german="Eure Gilde erhält immer die\nneuesten Nachrichten. Eine gute Quelle wäre\nsehr hilfreich für meine Erkundungen!", italian="Da queste parti circolano sempre\nle notizie più recenti. Sarebbe\ndavvero un grande aiuto per me.", spanish="Tu [CS:N]Pokégremio[CR] siempre está\nal día. Tener información actualizada es\nmuy útil para mis exploraciones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" No problem!", french=" Pas de problème!", german=" Kein Problem!", italian=" Non c'è nessunissimo problema!", spanish=" ¡Sin problemas!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Other exploration teams visit us\nall the time. You're always welcome here!", french="Nous recevons sans cesse la\nvisite d'autres équipes d'exploration!\nVous serez toujours le bienvenu!", german="Wir haben hier ständig Besuch\nvon anderen Erkundungsteams. Du bist jederzeit\nwillkommen!", italian="Molte squadre d'esplorazione\nvengono a trovarci! Sarà sempre il\nbenvenuto! ♪", spanish="Otros equipos de exploración\nsuelen visitarnos continuamente.\n¡Puedes venir a vernos cuando quieras!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  pcall(function() GAME:MoveCamera(324, 268, 60, false) end) -- performer/caméra
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(0), p.Y+(16), false, 2) end
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 344, 296, Direction.Up, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_pukurin, 4) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.UpLeft, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 360, 280, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_pukurin, 4) end)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Everyone![K] This is [CS:N]Dusknoir[CR]!", french=" Vous autres![K] Voici [CS:N]Noctunoir[CR]!", german="Alles herhören![K] Dies ist\n[CS:N]Zwirrfinst[CR]!", italian="Attenzione, prego...[K] vi presento\n[CS:N]Dusknoir[CR]!", spanish="¡Escuchadme todos![K]\nOs presento a [CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="He's going to stay in Treasure\nTown for a while. Mind yourself around him!", french="Il va passer un moment\nà Bourg-Trésor! Faites-lui bon accueil!", german="Er wird sich eine Weile in\nSchatzstadt aufhalten. Behandelt ihn mit\nbesonderem Respekt!", italian="Resterà per un po' a Borgo\nTesoro. Mi raccomando! ♪\nAccoglietelo calorosamente! ♪", spanish="Va a estar un tiempo en Aldea\nTesoro. Portaos bien con él."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] is very famous and\nquite knowledgeable...", french="[CS:N]Noctunoir[CR] est un célèbre\nexplorateur très avisé...", german="[CS:N]Zwirrfinst[CR] ist sehr berühmt\nund sehr belesen...", italian="[CS:N]Dusknoir[CR] è famosissimo e\nconosce molte cose...", spanish="[CS:N]Dusknoir[CR] es muy famoso\ny erudito..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="So I bet everyone would like to\nget advice from him!", french="Alors je parie que vous aimeriez\ntous bénéficier de ses conseils!", german="Ich bin mir sicher, dass jeder\ngerne seinen Rat hören würde!", italian="Immagino che tutti voi avrete\ndelle domande da fargli, vero? ♪", spanish="Así que supongo que todos\nquerréis pedirle consejo."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But let's not overdo it! We don't\nwant to be a nuisance!", french="Mais n'en faites pas trop!\nNous ne voulons surtout pas l'importuner!", german="Aber übertreibt es nicht!\nWir wollen ihm nicht zur Last fallen!", italian="Ma cerchiamo di non esagerare!\nNon vogliamo essergli d'impiccio, giusto?", spanish="¡Pero sin pasaros!\n¡No tenemos que ser pesados!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-8), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now, everyone, our guest might\nbe famous...", french="Par ailleurs, notre hôte a beau\nêtre célèbre...", german="Nun, Pokémon, unser Gast ist\nzwar eine Berühmtheit...", italian="Ora, è vero che il nostro ospite\nè molto famoso...", spanish="Una cosa más: Puede que nuestro\ninvitado sea famoso..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But don't embarrass us by asking\nhim for autographs!", french="N'allez pas l'embarrasser en lui\ndemandant son autographe!", german="Aber erspart uns die\nPeinlichkeit, ihn um Autogramme zu bitten!", italian="Ma per favore, cerchiamo di non\nscomodarlo per chiedergli un autografo!", spanish="¡Pero no le pongáis en evidencia\npidiéndole autógrafos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="No, no! If it's autographs you\nwant, I'm sure that I can oblige!", french="Non point! Si ce sont des\nautographes que vous désirez, c'est de bon\ncœur que j'y consens!", german="Ach was! Wenn ihr Autogramme\nwollt, lässt sich das sicherlich einrichten!", italian="No, un momento! Se davvero\nvolete un autografo sono sicuro di potervi\naccontentare...", spanish="No, no... Si quieren autógrafos,\nno tengo ningún problema."})
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But...information? I'm afraid you\nflatter me. I have very little information.", french="En revanche... des informations?\nJe crains que vous ne me surestimiez. Je n'ai\nque très peu d'informations à vous offrir.", german="Aber Ratschläge? Das bringt\nmich in Verlegenheit. Ich kann kaum einen\nRatschlag erteilen.", italian="Però mi lusingate se pensate che\nio possa rispondere a qualsiasi domanda.\nIn realtà ci sono molte cose che non conosco.", spanish="Pero... ¿información? Me temo\nque me aduláis. No tengo mucha información."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="However, I would be delighted\nif I may be of service to you.", french="Quoi qu'il en soit, je serai ravi\nde vous venir en aide si je le puis.", german="Ich bin jedoch froh, wenn ich\neuch in irgendeiner Weise dienen kann.", italian="In ogni caso, sarò lieto di\nesservi d'aiuto.", spanish="Sin embargo, me encantaría\npoder prestaros mi ayuda."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If there is anything you wish to\nask of me, please don't hesitate.", french="N'hésitez pas à venir solliciter\nmon assistance si tel est votre souhait.", german="Wenn ihr irgendeine Bitte an\nmich habt, zögert nicht, mich zu fragen.", italian="Vi prego, non esitate se avete\nbisogno di consultarvi con me.", spanish="Por favor, no dudéis en pedirme\nlo que sea."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5137) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yup yup! It's a great honor!", french="Ouaip ouaip! C'est un grand\nhonneur, pour sûr!", german=" Jawollja! Es ist mir eine Ehre!", italian=" Già, già! È un grande onore!", spanish=" ¡Sí, señor! ¡Qué gran honor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oooh! I'm so very glad to have\nmet you!", french="Ben mince alors, ça me fait\ntrop plaisir de vous rencontrer!", german="Uuuh! Ich bin überglücklich,\ndich kennengelernt zu haben!", italian="Oooh! Sono così lieta di fare la\nsua conoscenza!", spanish="¡Oooh! ¡Cómo me alegra haberte\nconocido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- se_FadeOut(5137, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(15)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Come now, everyone![K] You're\ndismissed!", french="Allez, tout le monde![K]\nVous pouvez disposer!", german=" So, Pokémon![K] Ihr könnt gehen!", italian="Per ora è tutto![K] Rompete le\nrighe!", spanish="¡Eso es todo![K]\n¡Podéis retiraros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(324, 204, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(0), p.Y+(-24), false, 2) end
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_heigani, 4) end)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_kimawari, 4) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_yonowaaru, 4) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I think I'll go for a stroll in\nTreasure Town.", french="Je m'en vais faire un tour\nà Bourg-Trésor.", german="Ich glaube, ich werde mich ein\nwenig in Schatzstadt umsehen.", italian="Penso che andrò in centro a fare\nuna passeggiata.", spanish="Creo que voy a dar un paseo por\nAldea Tesoro."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Please do feel free to approach\nme with anything.[K] Good day!", french="N'hésitez surtout pas à venir\nme consulter.[K] Bonne journée!", german="Ihr könnt euch jederzeit an mich\nwenden.[K] Guten Tag!", italian="Sentitevi liberi di pormi\nqualsiasi quesito.[K] Con permesso...", spanish="Por favor, no os cortéis lo más\nmínimo si queréis algo de mí.[K] ¡Hasta luego!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_yonowaaru, 324, 164, false, 2)
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:MoveToPosition(npc_npc_yonowaaru, 324, 132, false, 2)
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(0), p.Y+(-32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(76), p.Y+(0), false, 2) end
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-40), p.Y+(40), false, 2) end
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(80), 80, false) end) -- MovePositionOffset performer/caméra
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(-16), false, 2) end
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Oh! You two!", french=" Oh! Vous voilà, vous deux!", german=" Oh! Ihr zwei!", italian=" Ehi! Voi due!", spanish=" ¡Ah! Aquí estáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(48), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(48), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I'd started saying earlier...[K]about\nyour assignment for today...", french="Alors revenons-en à...[K] votre\nmission du jour...", german="Um auf das zurückzukommen,\nvon dem ich zuvor sprach...[K] Eure Aufgabe für\nden heutigen Tag...", italian="Come stavo dicendo prima...[K]\nriguardo ai vostri incarichi per oggi...", spanish="Como estaba diciendo antes...[K]\nsobre vuestra tarea de hoy..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Today I want you to read over\nthe Job Bulletin Board and the Outlaw\nNotice Board.", french="Aujourd'hui, je veux que\nvous consultiez le Tableau des Missions\net les Avis de Recherche.", german="Ich will, dass ihr euch heute die\nJob- und Ganoven-Infobretter durchlest.", italian="Voglio che diate una bella\nocchiata alla Bacheca delle missioni\ne a quella dei ricercati.", spanish="Quiero que hoy repaséis\nel Tablón de Anuncios y el Tablón\n\"Se Busca\"."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And take some of the listed jobs!\nThat will do!", french="Accomplissez quelques-unes des\nmissions qui y sont affichées! Ce sera tout\npour la journée!", german="Und nehmt ein paar der\nausgeschriebenen Jobs an! Das ist alles!", italian="Scegliete qualche missione e\nportatela a termine! È tutto!", spanish="Completad algunas de esas\nmisiones. Eso bastará por hoy."})
  -- message_Close
  GAME:FadeOut(false, 60)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:TeleportTo(npc_npc_dogoomu, 216, 308, Direction.Down)
  GROUND:TeleportTo(npc_npc_perappu, 456, 220, Direction.Down)
  GROUND:TeleportTo(hero, 336, 228, Direction.Down)
  GROUND:TeleportTo(partner, 304, 228, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:WaitFrames(45)
  GAME:FadeIn(30)
  SkySceneKit.cleanup_npcs()
end
