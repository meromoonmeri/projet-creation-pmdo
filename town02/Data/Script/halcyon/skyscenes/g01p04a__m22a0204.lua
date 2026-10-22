-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m22a0204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM22') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 384, 224, Direction.Left, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 264, 256, Direction.UpRight, "NPC_DOGOOMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 312, 272, Direction.Up, "NPC_GUREGGURU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's it!)", french="(J'y suis!)", german="(Das ist es!)", italian="(Ma certo!)", spanish="(¡Eso es!)"})
  else
  SkySceneKit.say({english="(That's it!)", french="(J'y suis!)", german="(Das ist es!)", italian="(Ma certo!)", spanish="(¡Eso es!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The Relic Fragment was inscribed with a\npeculiar pattern!)", french="(Le Fragment de Relique! Un symbole\nparticulier est gravé dessus!)", german="(Auf dem Reliktfragment war ein seltsames\nMuster!)", italian="(Il Frammento Antico aveva un'incisione\nparticolare!)", spanish="(¡La Reliquia de Piedra tenía un dibujo muy\nraro!)"})
  else
  SkySceneKit.say({english="(The Relic Fragment was inscribed with a\npeculiar pattern!)", french="(Le Fragment de Relique! Un symbole\nparticulier est gravé dessus!)", german="(Auf dem Reliktfragment war ein seltsames\nMuster!)", italian="(Il Frammento Antico aveva un'incisione\nparticolare!)", spanish="(¡La Reliquia de Piedra tenía un dibujo muy\nraro!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hm? What's up, [hero]?", french="Hmm? Qu'est-ce qu'il y a,\n[hero]?", german=" Hm? Was ist los, [hero]?", italian=" Eh? Che c'è, [hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hm? What is it, [hero]?", french="Hmm? Qu'est-ce qu'il y a,\n[hero]?", german=" Hm? Was ist los, [hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  else
  SkySceneKit.say({english=" Hm? What is it, [hero]?", french="Hmm? Qu'est-ce qu'il y a,\n[hero]?", german=" Hm? Was ist los, [hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? My Relic Fragment?", french=" Quoi? Mon Fragment de Relique?", german=" Wie bitte? Mein Reliktfragment?", italian=" Eh? Il mio Frammento Antico?", spanish=" ¿Qué? ¿Mi Reliquia de Piedra?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? My Relic Fragment?", french=" Quoi? Mon Fragment de Relique?", german=" Was? Mein Reliktfragment?", italian=" Cosa? Il mio Frammento Antico?", spanish=" ¿Qué? ¿Mi Reliquia de Piedra?"})
  else
  SkySceneKit.say({english=" Pardon? My Relic Fragment?", french=" Quoi? Mon Fragment de Relique?", german=" Bitte? Mein Reliktfragment?", italian="Scusa? Il mio Frammento\nAntico?", spanish=" ¿Qué? ¿Mi Reliquia de Piedra?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, right![K] That pattern!", french=" Oh, c'est vrai![K] Ce symbole-là!", german=" Oh, richtig![K] Dieses Muster!", italian=" Oh, giusto![K] Quel disegno!", spanish=" ¡Ah, claro![K] ¡El dibujo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, right![K] That pattern!", french=" Oh, c'est vrai![K] Ce symbole-là!", german=" Oh, richtig![K] Dieses Muster!", italian=" Oh, è vero![K] Quel disegno!", spanish=" ¡Ah, claro![K] ¡El dibujo!"})
  else
  SkySceneKit.say({english=" Oh, right![K] That pattern!", french=" Oh, c'est vrai![K] Ce symbole-là!", german=" Oh, richtig![K] Dieses Muster!", italian=" Oh, è vero![K] Quel disegno!", spanish=" ¡Ah, claro![K] ¡El dibujo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kootasu = SkySceneKit.spawn_npc("torkoal", 328, 216, Direction.Down, "NPC_KOOTASU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kootasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kootasu, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey.[K] Can you take a look at this\nfor me?", french="S'il te plaît,[K] tu peux jeter\nun coup d'œil à ça?", german="Hey.[K] Kannst du für mich da mal\neinen Blick draufwerfen?", italian="Ehi.[K] Puoi dare un'occhiata a\nquesto?", spanish="Disculpa...[K]\n¿Puedes echarle un vistazo a esto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Excuse me.[K] Could you have a\nlook at this?", french="S'il te plaît,[K] tu peux jeter\nun coup d'œil à ça?", german="Verzeihung.[K] Könntest du dir das\nhier mal ansehen?", italian="Scusami.[K] Puoi dare un'occhiata\na questo?", spanish="Disculpa...[K]\n¿Puedes echarle un vistazo a esto?"})
  else
  SkySceneKit.say({english="Excuse me.[K] Could you have a\nlook at this, please?", french="S'il te plaît,[K] tu peux jeter\nun coup d'œil à ça?", german="Verzeihung.[K] Könntest du dir das\nhier mal bitte ansehen?", italian="Scusami.[K] Puoi dare un'occhiata\na questo?", spanish="Disculpa...[K]\n¿Puedes echarle un vistazo a esto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(15)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Oh![K] Th-this is it!", french=" Oh![K] C'est... c'est bien ça!", german=" Oh![K] D-das ist es!", italian=" Oh![K] È q-questo!", spanish=" ¡Oh![K] Era... ¡Era exactamente así!"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" It's a pattern exactly like this!", french="C'est un symbole identique\nà celui-ci!", german="Ein Muster genau wie dieses ist\nes!", italian="È esattamente un disegno come\nquesto!", spanish="¡Se trata de una forma idéntica\na esta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 336, 272, Direction.Up, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "shock", 1) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 288, 264, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 272, 240, Direction.UpRight, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 376, 256, Direction.UpLeft, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 360, 272, Direction.UpLeft, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHAT?!", french="[CS:N]Tous[CR]: QUOI?!", german="[CS:N]Alle[CR]: WAS?!?", italian="[CS:N]Tutti[CR]: COSA?!", spanish="[CS:N]Todos[CR]: ¡¿QUÉ?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kootasu, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Where...where did you get this?", french=" Où... où as-tu trouvé ça?", german=" Wo... Wo hast du das her?", italian=" Dove... l'avete preso?", spanish="¿De dónde...?\n¿De dónde has sacado eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Uh, I'm not sure if I remember\nwhere...", french="Euh, je ne me rappelle plus\ntrop où...", german="Ähm, ich bin mir nicht sicher, ob\nich mich daran erinnere...", italian="Ah, non sono sicuro di ricordare\ndove...", spanish=" Yo... No sé si lo recuerdo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, I'm not sure if I can\nremember.", french="Euh, je ne me rappelle plus\ntrop où...", german="Nun, ich bin nicht sicher, ob ich\nmich daran erinnere.", italian="Beh, non sono sicuro di\nricordarmi.", spanish=" Yo... No sé si lo recuerdo..."})
  else
  SkySceneKit.say({english="Um, I can't say if I even\nremember where.", french="Euh, je ne me rappelle plus\ntrop où...", german="Öhm, ich kann nicht mal sagen,\nob ich das noch weiß.", italian="Uhm, non mi ricordo neanche\ndove l'ho preso.", spanish=" Yo... No sé si lo recuerdo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I just happened to pick it up.", french="Je l'ai juste ramassé quelque\npart.", german="Ich habe das zufällig\naufgesammelt.", italian=" L'ho raccolto da qualche parte.", spanish=" Simplemente lo encontré un día."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I just happened to pick it up.", french="Je l'ai juste ramassé quelque\npart.", german="Ich habe das zufällig\naufgesammelt.", italian=" L'ho raccolto da qualche parte.", spanish=" Simplemente lo encontré un día."})
  else
  SkySceneKit.say({english=" I just happened to pick it up.", french="Je l'ai juste ramassé quelque\npart.", german="Ich habe das zufällig\naufgesammelt.", italian=" L'ho raccolto da qualche parte.", spanish=" Simplemente lo encontré un día."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Yippee! This is fabulous!", french=" Youpiii! C'est fabuleux!", german="Du meine Güte! Das ist\nfabelhaft!", italian=" Evviva! È favoloso!", spanish=" ¡Esto es superfabuloso!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Since [partner] has\nthis...[K] Does it mean...", french="Puisque [partner] est en\npossession de ça...[K] Est-ce que ça veut dire...", german="Da [partner] es besitzt...[K]\nBedeutet das etwa...", italian="Dato che [partner] ha\nquesto...[K] significa...", spanish="Si [partner] tiene esto...[K]\n¿Significa entonces...?"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="That [partner] is qualified to\ngo to the [CS:P]Hidden Land[CR]?", french="... que [partner] est apte\nà se rendre dans les [CS:P]Terres Illusoires[CR]?", german="Bedeutet das, [partner] ist\ndazu qualifiziert, zum [CS:P]Verborgenen Land[CR] zu\ngehen?", italian="Significa che [partner] ha i\nrequisiti per andare nella [CS:P]Terra Nascosta[CR]?", spanish="¿Que cumple el requisito para\nacceder a la [CS:P]Tierra Oculta[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="That, I wouldn't know.[K]\nMaybe yes, maybe no.", french="Ça, je n'en ai aucune idée.[K]\nPeut-être bien que oui, peut-être bien que non.", german="Das kann ich nicht wissen.[K]\nVielleicht ja, vielleicht nein.", italian="Questo non lo so.[K] Forse sì,\nforse no.", spanish="Eso no sabría decirlo.[K]\nPuede que sí, y puede que no."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="To go to the [CS:P]Hidden Land[CR], one\nmust surely possess that proof.", french="Pour accéder aux [CS:P]Terres\nIllusoires[CR], il faut absolument avoir\ncette preuve.", german="Um zum [CS:P]Verborgenen Land[CR] zu\ngehen, muss man diesen Nachweis sicherlich\nbesitzen.", italian="Per andare nella [CS:P]Terra[CR]\n[CS:P]Nascosta[CR], sicuramente bisogna possedere\nquesta prova.", spanish="Para ir a la [CS:P]Tierra Oculta[CR],\nestá claro que hay que poseer algo así."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="But that doesn't necessarily\nmean that the bearer of the proof really\npossesses the qualifications to be...chosen.", french="Mais ça ne signifie pas\nforcément que le porteur de la preuve a les\naptitudes requises pour être... élu.", german="Aber das bedeutet nicht\nzwangsläufig, dass der Besitzer des\nNachweises qualifiziert ist als... Auserwählter.", italian="Ma non significa che chi possiede\nquesta prova abbia necessariamente i requisiti\nper essere... prescelto.", spanish="Pero eso no significa que\nel portador haya pasado la prueba y\nsea el elegido."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="That proof may be merely the\nphysical key to the [CS:P]Hidden Land[CR].", french="Peut-être que cette preuve n'est\nqu'une clé qui ouvre l'accès aux [CS:P]Terres\nIllusoires[CR].", german="Dieser Nachweis könnte einfach\nder physische Schlüssel für das\n[CS:P]Verborgene Land[CR] sein.", italian="Questa prova può essere\nanche solo la chiave fisica per la [CS:P]Terra[CR]\n[CS:P]Nascosta[CR].", spanish="Ese objeto puede ser tan solo\nla llave física a la [CS:P]Tierra Oculta[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Even before that, though, this\nshares the same inscribed pattern...", french="Et bien que ce symbole soit\nidentique à celui gravé sur la preuve...", german="Aber sogar schon vorher hat er\ndas gleiche Muster als Inschrift...", italian="Tuttavia qui c'è inciso\nlo stesso disegno...", spanish="Aunque evidentemente el dibujo\ntiene la misma forma..."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="There's no sure connection\nbetween this Relic Fragment and the [CS:P]Hidden\nLand[CR].", french="... rien ne prouve que\nce Fragment de Relique soit lié aux\n[CS:P]Terres Illusoires[CR].", german="Es gibt keine gesicherte\nVerbindung zwischen diesem Reliktfragment\nund dem [CS:P]Verborgenen Land[CR].", italian="Non c'è una connessione sicura\ntra il Frammento Antico e la [CS:P]Terra Nascosta[CR].", spanish="No hay una conexión clara entre\nesta Reliquia de Piedra y la [CS:P]Tierra Oculta[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 360, 216, Direction.DownLeft, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_kootasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_kootasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Oh! But...![K] There's no question\nthat this pattern has something to do with the\n[CS:P]Hidden Land[CR]?", french="Oh! Pourtant...[K] Ce symbole est\nbien lié aux [CS:P]Terres Illusoires[CR], ça ne fait aucun\ndoute!", german="Oh! Aber...[K] Steht es dann außer\nFrage, dass dieses Muster etwas mit dem\n[CS:P]Verborgenen Land[CR] zu tun hat?", italian="Oh! Ma...![K] Non c'è alcun dubbio\nche questo disegno abbia qualcosa a che fare\ncon la [CS:P]Terra Nascosta[CR].", spanish="Bueno, pero...[K] no se puede negar\nque el dibujo tiene algo que ver con\nla [CS:P]Tierra Oculta[CR], ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Knowing only that is a lot! ♪", french=" C'est déjà bien de savoir ça! ♪", german="Das zu wissen, ist doch schon\netwas! ♪", italian="E saperlo è già un buon punto di\npartenza! ♪", spanish=" ¡Eso ya es mucho! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" I suppose so...", french=" Je suppose que oui...", german=" Zumindest nehme ich das an...", italian=" Penso di sì...", spanish=" Supongo que sí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kootasu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Wait...[K] You do realize that the\n[CS:P]Hidden Land[CR] is only a spoken legend, right?", french="Attendez un peu...[K] Vous êtes\nconscients que les [CS:P]Terres Illusoires[CR] ne sont\nqu'une légende, n'est-ce pas?", german="Moment...[K] Ihr seid euch bewusst,\ndass das [CS:P]Verborgene Land[CR] nur eine mündliche\nLegende ist, richtig?", italian="Aspettate un attimo...[K] Lo sapete\nche la [CS:P]Terra Nascosta[CR] è solo una leggenda,\nvero?", spanish="Esperad...[K] ¿Sois conscientes de\nque la [CS:P]Tierra Oculta[CR] solo es una leyenda?"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="You're surely not trying to find\nthe [CS:P]Hidden Land[CR]?", french="Vous n'essayez pas réellement\nde trouver les [CS:P]Terres Illusoires[CR]?", german="Ihr versucht sicher nicht, das\n[CS:P]Verborgene Land[CR] zu finden?", italian="Non starete davvero cercando la\n[CS:P]Terra Nascosta[CR]?", spanish="No estaréis tratando de\nencontrarla, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yes! We are! ♪", french="Si, c'est précisément ce que\nnous faisons! ♪", german=" Doch! Das tun wir! ♪", italian=" Sì! La stiamo cercando! ♪", spanish=" ¡Eso pretendemos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" My goodness![K] What a surprise!", french=" Diantre![K] Quelle surprise!", german="Meine Güte![K] Was für eine\nÜberraschung!", italian=" Accipicchia![K] Che sorpresa!", spanish=" ¡Increíble![K] ¡Vaya sorpresa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="This pattern...[K] We've seen this\nsomewhere. Haven't we?", french="Ce symbole...[K] nous l'avons déjà\nvu quelque part, n'est-ce pas?", german="Dieses Muster...[K] Wir haben es\nirgendwo gesehen. Oder nicht?", italian="Questo disegno...[K] L'abbiamo già\nvisto da qualche parte, vero?", spanish="Ese dibujo...[K] Tú y yo lo hemos\nvisto en alguna parte, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHAT?!", french="[CS:N]Tous[CR]: QUOI?!", german="[CS:N]Alle[CR]: WAS?!?", italian="[CS:N]Tutti[CR]: COSA?!", spanish="[CS:N]Todos[CR]: ¡¿QUÉ?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Y-yes...", french=" Oui...", german=" J-ja...", italian=" S-Sì...", spanish=" Así es..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" The sea inlet to the northwest...", french=" Dans la crique au nord-ouest...", german=" Der Meeresarm im Nordwesten...", italian="Quell'insenatura della costa a\nnord-ovest...", spanish=" En la ensenada del noroeste..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Inside [CS:P]Brine Cave[CR]...", french="A l'intérieur de la [CS:P]Caverne\nSaline[CR]...", german=" In der [CS:P]Salzwasserhöhle[CR]...", italian="All'interno della [CS:P]Grotta[CR]\n[CS:P]Salmastra[CR]...", spanish=" Dentro de la [CS:P]Cueva Aguamar[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" But, Guildmaster! That place...!", french=" Mais, Maître! Cet endroit...!", german="Aber Gildenmeister! Dieser\nOrt...", italian=" Ma, Capitano! Quel posto...!", spanish=" ¡Gran Bluff! Pero ese lugar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yes, I know. That vicious bandit\nwas there.", french="Oui, je sais. C'est là que\nse trouvait cet infâme scélérat.", german="Ja, ich weiß. Dieser boshafte\nBandit war dort.", italian=" Sì, lo so. C'era quel farabutto!", spanish="Sí, ya lo sé. Allí es donde se\nescondía aquel despiadado bandido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" A vicious...", french=" Un infâme...", german=" Ein boshafter...", italian=" Un farabutto...", spanish=" Un despiadado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Bandit? By golly!", french=" Un scélérat? Sapristi!", german=" Bandit? Donnerwetter!", italian=" Farabutto? Ohibò!", spanish=" ¿Bandido? ¡Huyuyuy!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Everyone, please listen.", french="S'il vous plaît, écoutez-moi\ntous.", german=" Hört mal bitte alle zu.", italian=" Gente, ascoltate per favore.", spanish=" Escuchadme todos, por favor."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I once saw this same pattern\ndeep inside a place called [CS:P]Brine Cave[CR].", french="J'ai déjà vu ce symbole au\ntréfonds de la [CS:P]Caverne Saline[CR].", german="Ich habe dieses Muster einmal\nan einem Ort namens [CS:P]Salzwasserhöhle[CR] gesehen.", italian="Una volta ho visto lo stesso\ndisegno nelle profondità di un posto chiamato\n[CS:P]Grotta Salmastra[CR].", spanish="Vi esa misma forma en las\nprofundidades de un lugar llamado\nla [CS:P]Cueva Aguamar[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I think we can discover more by\ntaking the Relic Fragment there.", french="Je pense qu'on en saura plus si\non emporte le Fragment de Relique là-bas.", german="Wir können wohl mehr\nherausfinden, wenn wir das Reliktfragment\ndorthin bringen.", italian="Penso che potremmo scoprire\nqualcosa di più portando là il Frammento\nAntico.", spanish="Creo que podremos descubrir\nalgo más si llevamos la Reliquia de Piedra allí."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" However, there is one problem.", french=" Cependant, il reste un problème.", german="Es gibt da allerdings ein\nProblem.", italian=" Ad ogni modo, c'è un problema.", spanish=" Aunque hay un problema."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="A Pokémon lurks there who is a\nvicious bandit.", french="Une ignoble créature se tapit\ndans l'ombre de ce donjon.", german="Da schleicht ein Pokémon herum,\ndas ein boshafter Bandit ist.", italian="Laggiù si nasconde un\nPokémon malvagio.", spanish="Un Pokémon despiadado podría\nacecharnos en la cueva."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kootasu, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! We're not about to let\nthat scare us!", french="Eh dis donc, on ne va pas\nse laisser intimider pour autant!", german="Hey, hey! Davon lassen wir uns\nkeine Angst machen!", italian="Ehi, ehi! Non ci lasceremo\nimpressionare!", spanish="¡Oye, oye! ¡No vamos a permitir\nque eso nos asuste!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Aren't we explorers?", french="On est des explorateurs, OUI\nOU NON?", german=" Sind wir etwa keine Erkunder?", italian=" Non siamo esploratori?", spanish=" ¿No somos exploradores?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" We all need to be brave!", french=" Haut les cœurs, les amis!", german=" Wir müssen nur tapfer sein!", italian=" Dobbiamo essere coraggiosi!", spanish=" ¡Tenemos que ser valientes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 376, 240, Direction.UpLeft, "NPC_DIGUDA")
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(120)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Thanks, everyone! ♪", french=" Merci, tout le monde! ♪", german=" Danke, Leute! ♪", italian=" Grazie, gente! ♪", spanish=" ¡Muchas gracias a todos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But that place is challenging.\nEveryone should take time today to get ready.", french="Mais préparez-vous bien\naujourd'hui, cet endroit est dangereux.", german="Aber dieser Ort ist eine\nHerausforderung. Wir sollten uns heute Zeit\nnehmen, um uns für morgen bereit zu machen.", italian="Ma quel posto è pieno di insidie.\nOggi dovreste tutti dedicare la giornata a\nprepararvi al meglio.", spanish="Pero se trata de un lugar muy\npeligroso. Hay que prepararse bien antes."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We'll set off for [CS:P]Brine Cave[CR]\ntomorrow!", french="Nous partirons pour la [CS:P]Caverne\nSaline[CR] demain!", german="Wir werden uns zur\n[CS:P]Salzwasserhöhle[CR] begeben!", italian="Domani partiremo per la\n[CS:P]Grotta Salmastra[CR]!", spanish="¡Partiremos a la [CS:P]Cueva Aguamar[CR]\nmañana!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Left)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownLeft)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(90)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Ho-ho-ho...[K] I thought that the\n[CS:P]Hidden Land[CR] was nothing more than folklore!", french="Oh, ça alors...[K] Je croyais que les\n[CS:P]Terres Illusoires[CR] n'étaient rien de plus\nqu'une légende!", german="Ho-ho-ho...[K] Ich dachte, das\n[CS:P]Verborgene Land[CR] sei nicht mehr als Folklore!", italian="Oh-oh-oh...[K] Pensavo che la\n[CS:P]Terra Nascosta[CR] non fosse altro che una\ncredenza popolare!", spanish="¡Jo, jo, jo![K] ¡Y yo que creía que\nla [CS:P]Tierra Oculta[CR] solo era un cuento de viejas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kootasu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kootasu, 4) end)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Left)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Getting old has made my thinking\nso inflexible. That's very sad.", french="La vieillesse a étriqué ma façon\nde voir les choses. C'est très triste.", german="Das Alter hat meinen Geist\nunbeweglich werden lassen. Es ist sehr traurig.", italian="Invecchiando sono diventato\ndavvero poco elastico di mente. Che tristezza.", spanish="Cada vez pienso de forma más\ninflexible; supongo que por la vejez.\nEs una pena."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="This all makes me remember the\ndays when I dreamt of romance and adventure!", french="Ça me rappelle ma jeunesse,\nà l'époque où je rêvais de grandes aventures\népiques!", german="Das alles lässt mich an die Tage\nzurückdenken, als ich von Romantik und\nAbenteuer träumte.", italian="Tutto questo mi ricorda i giorni\nin cui sognavo l'amore e l'avventura!", spanish="¡Esto me hace recordar los días\nen los que soñaba todo el día con idilios y\naventuras!"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Help me see my dreams again![K]\nDo your best! Ho-ho-ho!", french="Faites revivre mes rêves\nd'antan![K] Redoublez d'efforts!\nHo ho ho!", german="Helft mir, meine Träume\nzurückzubekommen![K] Gebt euer Bestes!\nHo-ho-ho!", italian="Aiutatemi a rivivere i miei\nsogni![K] Mettetecela tutta! Oh-oh-oh!", spanish="¡Ayudadme a revivir mis sueños![K]\n¡Hacedlo lo mejor que podáis! ¡Jo, jo, jo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kootasu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_kootasu, 324, 172, false, 1)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_kootasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_kootasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_kootasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_kootasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_kootasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_kootasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_kootasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_kootasu, 4) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup! Count on it!", french="Oui! Tu peux compter\nsur nous!", german=" Jep! Verlass dich darauf!", italian=" Sì! Conta su di noi!", spanish=" ¡Sí! ¡Cuenta con ello!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes! You can count on us!", french="Oui! Tu peux compter\nsur nous!", german=" Ja! Du kannst auf uns zählen!", italian=" Sì! Puoi contare su di noi!", spanish="¡Sí! ¡Puedes contar con\nnosotros!"})
  else
  SkySceneKit.say({english=" Yep! You can count on us!", french="Oui! Tu peux compter\nsur nous!", german=" Jep! Du kannst auf uns zählen!", italian=" Sì! Puoi contare su di noi!", spanish="¡Sí! ¡Puedes contar con\nnosotros!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Thank you, [CS:N]Torkoal[CR]!", french=" Merci, [CS:N]Chartor[CR]!", german=" Danke sehr, [CS:N]Qurtel[CR]!", italian=" Grazie, [CS:N]Torkoal[CR]!", spanish=" ¡Gracias, [CS:N]Torkoal[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kootasu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Oh, it was nothing. Ho-ho-ho!", french=" De rien. Ho ho ho!", german="Ach, nicht der Rede wert.\nHo-ho-ho!", italian=" Oh, non è nulla. Oh-oh-oh!", spanish=" Oh, de nada. ¡Jo, jo, jo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kootasu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_kootasu, 324, 124, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="All right, everyone![K] Spend the\nrest of today getting ready! ♪", french="Très bien, tout le monde![K]\nProfitez du reste de la journée pour vous\npréparer! ♪", german="Alles klar, Leute![K] Nutzt den Rest\ndes Tages zur Vorbereitung! ♪", italian="E va bene, gente![K] Utilizzate\nil resto della giornata per prepararvi! ♪", spanish="¡Muy bien, escuchadme![K]\nTenéis el resto del día para prepararos. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" OK! Dismissed!", french=" Rompez!", german=" Okay! Wegtreten!", italian=" Ok! Potete andare!", spanish=" ¡Ahora podéis retiraros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(12), p.Y+(-12), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-12), p.Y+(12), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup! We'll get ready,\nby golly!", french="Et comment qu'on va\ns'préparer, pardi!", german="Jawollja! Wir machen uns\nbereit, Donnerwetter!", italian="Sì, sì! Andiamo a prepararci,\nohibò!", spanish="¡Sí, señor! ¡Vamos a\nprepararnos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! This will be so\nexciting!", french="Trop cool! Ça va être\nhallucinant!", german=" Auweia! Das wird so aufregend!", italian=" Shock! Sarà così emozionante!", spanish=" ¡Esto es superemocionante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 216, 304, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 228, 272, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 256, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 360, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 228, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 124, false, 2)
  -- SetAnimation(19) [anim idle native]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(44), g.ViewCenter.Y+(0), 44, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GAME:MoveCamera(368, 232, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR], you stay at the guild\ntomorrow on standby. ♪", french="[CS:N]Pijako[CR], demain, tu es de garde\nà la Guilde. ♪", german="[CS:N]Plaudagei[CR], du hältst dich morgen\nin der Gilde auf Abruf bereit. ♪", italian="[CS:N]Chatot[CR], domani tu resti di\nguardia alla Gilda. ♪", spanish="[CS:N]Chatot[CR], tú te quedarás mañana\nen el [CS:N]Pokégremio[CR], a la espera. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="G-Guildmaster![K] Forgive me if\nI'm out of line, but...", french="Mais, Maître![K] Excusez\nmon outrecuidance, mais...", german="G-Gildenmeister![K] Verzeih mir,\nwenn ich offen spreche, aber...", italian="C-Capitano![K] Mi perdoni se\noso contraddirla, ma...", spanish="¡Gran Bluff![K] Perdóname si esto\nte resulta inapropiado, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Please, let me go to [CS:P]Brine Cave[CR]!", french="Laissez-moi venir à la [CS:P]Caverne\nSaline[CR], je vous en prie!", german="Bitte lass mich zur\n[CS:P]Salzwasserhöhle[CR] mitgehen!", italian="La prego, mi faccia venire\nalla [CS:P]Grotta Salmastra[CR]!", spanish="¡Tienes que dejarme ir a\nla [CS:P]Cueva Aguamar[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Nope! I can't let you face danger\nlike that ever again.", french="Nan! Jamais plus je ne te\nlaisserai affronter un tel danger.", german="Nein! Ich kann dich niemals\nwieder einer solchen Gefahr aussetzen.", italian="No! Non ti posso far rischiare la\npelle come l'altra volta.", spanish="¡Ni hablar! Nunca permitiré que\nvuelvas a correr peligro de esa forma."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But that's why![K] That's why I\nmust go!", french="Mais c'est précisément\npour ça![K] C'est précisément pour ça que\nje dois venir!", german="Aber genau deswegen![K] Deswegen\nmuss ich dabei sein!", italian="Ma è per questo![K] È per questo\nche devo venire!", spanish="Ese es precisamente el motivo.[K]\n¡Por eso tengo que ir!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Please, take me to [CS:P]Brine Cave[CR]!", french="S'il vous plaît, emmenez-moi\nà la [CS:P]Caverne Saline[CR] avec vous!", german="Bitte nimm mich mit zur\n[CS:P]Salzwasserhöhle[CR]!", italian="Per favore, mi porti alla [CS:P]Grotta[CR]\n[CS:P]Salmastra[CR]!", spanish="Por favor, ¡déjame ir a\nla [CS:P]Cueva Aguamar[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" ...[K]OK.", french=" ... [K]D'accord.", german=" ...[K]Okay.", italian=" ...[K] Ok.", spanish=" Hum...[K] De acuerdo."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Then I want you to go with\nTeam [team:] tomorrow.", french="Alors je veux que tu\naccompagnes l'Equipe [team:].", german="Dann möchte ich, dass du\nmorgen mit Team [team:] gehst.", italian="Allora voglio che domani tu vada\ncon il Team [team:].", spanish="Entonces, querría que fueses\ncon el [CS:X]Equipo[CR] [team:]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Guide [hero]'s team to the\nplace where we saw that strange pattern.", french="Guide l'équipe de [hero]\njusqu'à l'endroit où nous avons vu cet étrange\nsymbole.", german="Führe das Team von\n[hero] dorthin, wo wir dieses seltsame\nMuster gesehen haben.", italian="Guida la squadra di [hero]\nnel posto in cui abbiamo visto quello strano\ndisegno.", spanish="Guía al equipo de [hero]\nal lugar donde vimos aquella extraña forma."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" But I want you to be careful.", french=" Mais sois prudent.", german="Ich möchte aber, dass du\nvorsichtig bist.", italian="Ma voglio che tu faccia\nattenzione.", spanish=" Pero ve con mucho cuidado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Thank you! I won't let you down!", french=" Merci! Je ne vous décevrai pas!", german="Danke schön! Ich werde dich\nnicht enttäuschen!", italian=" Grazie! Non la deluderò!", spanish=" ¡Gracias! ¡No te decepcionaré!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Another thing...[K]I have something\nI need to do, so I have to go out.", french="Autre chose...[K] J'ai quelque chose\nà faire, je dois quitter la Guilde.", german="Noch etwas...[K] Ich habe etwas zu\nerledigen, deswegen muss ich nach draußen.", italian="Un'altra cosa...[K] Devo uscire\nperché devo occuparmi di una questione.", spanish="Hay algo más...[K] Tengo un asunto\npendiente y debo marcharme."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" You're in charge while I'm gone.", french="Prends les commandes pendant\nmon absence.", german="Du hast das Kommando, solange\nich weg bin.", italian="Mentre sono via ti affido il\ncomando.", spanish="Mientras esté fuera, tú estarás\nal mando."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" As you wish.", french=" Vos désirs sont des ordres.", german=" Wie du wünschst.", italian=" Come desidera.", spanish=" Como desees."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpRight)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(-8), false, 2) end
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 204, false, 2)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(-24), false, 2) end
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  GROUND:TeleportTo(npc_npc_guregguru, 228, 220, Direction.Down)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(324, 232, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_perappu, 324, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So that's where it stands. You\ntwo will be with me tomorrow.", french="Voilà, demain, je vous\naccompagnerai officiellement,\nnous serons donc trois.", german="Also so stehen die Dinge. Ihr\nbeiden geht morgen mit mir.", italian="Allora le cose stanno così. Voi\ndue domani verrete con me.", spanish="Pues eso es todo. Mañana os\nvendréis conmigo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As such, Team [team:]'s\nnonguild members may not come along.", french="C'est pourquoi vous ne pourrez\npas emmener de membres de l'Equipe\n[team:] n'appartenant pas à la Guilde.", german="Die Mitglieder von Team\n[team:], die nicht der Gilde angehören,\ndürfen nicht mitkommen.", italian="In quanto tali, i membri esterni\ndel Team [team:] non possono\nunirsi a noi.", spanish="Los miembros del [CS:X]Equipo[CR]\n[team:] que no pertenezcan al\n[CS:N]Pokégremio[CR] no podrán acompañarnos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:P]Brine Cave[CR] has a vicious foe\nlying in wait.[K] You mustn't let down your guard!", french="Il y a un infâme bandit tapi dans\nla [CS:P]Caverne Saline[CR].[K] Restez sur vos gardes!", german="In der [CS:P]Salzwasserhöhle[CR] liegt ein\nheimtückischer Gegner auf der Lauer.[K] Niemals\ndie Deckung fallen lassen!", italian="Nella [CS:P]Grotta Salmastra[CR] vi\naspetta un avversario spietato.[K] Non dovete\nabbassare la guardia!", spanish="En la [CS:P]Cueva Aguamar[CR] nos espera\nun rival despiadado.[K]\n¡No hay que bajar nunca la guardia!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And don't do anything that keeps\nme from succeeding there!", french="Et ne faites rien qui ralentisse\nma progression!", german="Und tut nichts, was mich davon\nabhalten könnte, dort Erfolg zu haben!", italian="E non fate nulla che\ncomprometta la buona riuscita della mia\noperazione!", spanish="¡Y no hagáis nada que pueda\nponerme en evidencia!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! OK.", french=" Argh! C'est noté.", german=" Umpf! Okay.", italian=" Uh! Ok.", spanish=" ¡Glup! De acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! OK.", french=" Argh! C'est noté.", german=" Umpf! Okay.", italian=" Uh! Ok.", spanish=" ¡Glup! De acuerdo."})
  else
  SkySceneKit.say({english=" Urk! OK.", french=" Argh! C'est noté.", german=" Umpf! Okay.", italian=" Uh! Ok.", spanish=" ¡Glup! De acuerdo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [hero]!", french=" [hero]!", german=" [hero]!", italian=" [hero]!", spanish=" ¡[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero]!", french=" [hero]!", german=" [hero]!", italian=" [hero]!", spanish=" ¡[hero]!"})
  else
  SkySceneKit.say({english=" [hero]!", french=" [hero]!", german=" [hero]!", italian=" [hero]!", spanish=" ¡[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We should go get ready.", french=" On devrait aller se préparer.", german=" Wir sollten uns bereit machen.", italian=" Dobbiamo andare a prepararci.", spanish=" Ahora tenemos que prepararnos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go get ready.", french=" On devrait aller se préparer.", german=" Machen wir uns bereit.", italian=" Andiamo a prepararci.", spanish=" Ahora tenemos que prepararnos."})
  else
  SkySceneKit.say({english=" We should go get ready.", french=" On devrait aller se préparer.", german=" Wir sollten uns bereit machen.", italian=" Dobbiamo andare a prepararci.", spanish=" Ahora tenemos que prepararnos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go down to Treasure Town.", french=" Allons à Bourg-Trésor.", german=" Lass uns nach Schatzstadt gehen.", italian=" Andiamo a Borgo Tesoro.", spanish=" Vamos a Aldea Tesoro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go to Treasure Town.", french=" Allons à Bourg-Trésor.", german=" Lass uns nach Schatzstadt gehen.", italian=" Andiamo a Borgo Tesoro.", spanish=" Vamos a Aldea Tesoro."})
  else
  SkySceneKit.say({english=" Let's go down to Treasure Town.", french=" Allons à Bourg-Trésor.", german=" Lass uns nach Schatzstadt gehen.", italian=" Andiamo a Borgo Tesoro.", spanish=" Vamos a Aldea Tesoro."})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
