-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/n01a0705.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 376, 272, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 472, 272, Direction.Up, "NPC_DIGUDA")
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 440, 272, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 408, 256, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 440, 256, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: AND...THREE![K] SMILES GO FOR MILES!", french="[CS:N]Tous[CR]: TROIS![K] GARDE LE SOURIRE POUR\nREUSSIR!", german="[CS:N]Alle[CR]: DRITTENS![K] MIT EINEM LACHEN\nWERDEN WIR ES MACHEN!", italian="[CS:N]Tutti[CR]: TRE![K] OGNI SORRISO VA CONDIVISO!", spanish="[CS:N]Todos[CR]: ¡TRES![K] ¡SONRISAS PARA TODOS\nY ENCONTRARÉIS MUCHOS TESOROS!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  -- message_Close
  GAME:WaitFrames(15)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="OK, Pokémon! ♪[K] Time to get\nto work! ♪", french="Bien, mes amis Pokémon! ♪[K]\nAu travail! ♪", german=" Gut, Pokémon! An die Arbeit! ♪", italian=" Ok, Pokémon! ♪[K] Al lavoro! ♪", spanish="¡De acuerdo, Pokémon! ♪\n¡Ya es hora de trabajar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  GAME:WaitFrames(1)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 376, 256, Direction.UpRight, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 408, 272, Direction.Up, "NPC_HEIGANI")
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(25) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
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
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 388, 252, false, 2)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(150)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Huh?[K] Something wrong, [CS:Y]Bidoof[CR]?", french="Hein?[K]\nUn problème, [CS:Y]Keunotor[CR]?", german=" Wie bitte?[K] Ist etwas, [CS:Y]Bidiza[CR]?", italian="Uh?[K] C'è qualcosa che non va,\n[CS:Y]Bidoof[CR]?", spanish=" ¿Eh?[K] ¿Te ocurre algo, [CS:Y]Bidoof[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Quit staring off into space, and\nget to your assignments.", french="Arrête un peu de rêvasser\net mets-toi plutôt au travail.", german="Hör auf, Löcher in die Luft\nzu starren, und hol dir deinen Auftrag ab.", italian="Smettila di fissare il vuoto\ne mettiti al lavoro...", spanish="Deja ya de mirar al infinito y\nponte a hacer tus tareas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(456, 244, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 456, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K][CS:N]Chatot[CR], you know a lot of\nstuff, don't you?", french="...[K] [CS:N]Pijako[CR], tu connais un tas\nd'trucs sur plein de choses, pas vrai?", german="...[K][CS:N]Plaudagei[CR], du weißt doch\neine Menge, oder?", italian="...[K] [CS:N]Chatot[CR], tu sai un sacco\ndi cose, non è vero?", spanish="Oye...[K] [CS:N]Chatot[CR], tú sabes un\nmontón de cosas, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Yes, that's right. ♪ [K]I do know\na lot of info. I'm an encyclopedia. ♪\nHee hee! ♪", french="Oui, on peut dire ça. ♪[K]\nJ'ai une culture assez étendue. Je suis une\nvraie encyclopédie, en fait. ♪ Hi hi! ♪", german="Ja, das stimmt. ♪ [K]Ich weiß\neine Menge Dinge. Ich bin ein wandelndes\nLexikon. ♪ Hihi! ♪", italian="Proprio così. ♪[K] Conosco\ndavvero molte cose. Sono una specie\ndi enciclopedia. ♪ Eh eh! ♪", spanish="Pues sí, es cierto. ♪[K] Soy una\nenciclopedia andante, ¡sé de todo! ♪\n¡Ji, ji! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Is there something you wanted\nto ask me? [K]You don't have to hesitate.\nGo ahead and ask. ♪", french="Y a-t-il un renseignement que tu\nvoudrais me demander? [K]Il ne faut pas hésiter,\ndans ce cas. Lance-toi, pose ta question. ♪", german="Wolltest du mich etwas fragen?[K]\nDu brauchst nicht zu zögern. Trau dich und\nstell deine Frage. ♪", italian="Volevi chiedermi qualcosa?[K]\nNon essere timido. Domanda pure. ♪", spanish="¿Es que hay algo que quieres\npreguntarme?[K] No lo dudes ni un segundo,\npregúntame lo que quieras. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But...[K] Please keep it brief.[K]\nI don't really have the time to dawdle.", french="Mais...[K] sois bref, néanmoins.[K]\nJe n'ai pas vraiment le temps de lambiner.", german="Aber...[K] Fasse dich kurz.[K]\nIch habe keine Zeit zu vertrödeln.", italian="Ma...[K] cerca di essere rapido.[K]\nNon ho tempo da perdere in chiacchiere.", spanish="Pero...[K] que sea breve.[K]\nNo puedo estar perdiendo mi valioso tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K]\nI'm not really confident...", french="Snif...[K]\nJ'suis pas vraiment sûr...", german="Schnief...[K]\nIch traue mich kaum...", italian="Sniff...[K]\nNon ne sono molto sicuro...", spanish="Jo...[K]\nMe falta confianza..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR]...[K]do you know anything\nabout a place called [CS:P]Star Cave[CR]?", french="[CS:N]Pijako[CR]...[K] T'as entendu parler d'un\nendroit appelé la [CS:P]Caverne Etoile[CR]?", german="[CS:N]Plaudagei[CR]...[K] Weißt du etwas\nüber einen Ort namens [CS:P]Sternenhöhle[CR]?", italian="[CS:N]Chatot[CR]...[K] Hai mai sentito parlare\ndi un posto chiamato [CS:P]Caverna Stellata[CR]?", spanish="[CS:N]Chatot[CR]...[K] ¿Sabes algo de\nun lugar llamado la [CS:P]Cueva Estrella[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:P]Star Cave[CR]?[K]\nHmm...[K] Yes, I think I've heard of it.", french="La [CS:P]Caverne Etoile[CR]?[K]\nMmh...[K] Oui, je crois que ça me dit\nquelque chose.", german="[CS:P]Sternenhöhle[CR]?[K]\nHmm...[K] Ja, davon habe ich schon einmal gehört.", italian="[CS:P]Caverna Stellata[CR]?[K]\nUhm...[K] Mi pare di sì.", spanish="¿La [CS:P]Cueva Estrella[CR]?[K]\nHum...[K] Sí, creo que he oído hablar de ese sitio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh?![K] Really?!", french=" Ah?![K] Vrai de vrai?!", german=" Was?!?[K] Wirklich?!?", italian="Eh?![K] Sul serio?!", spanish=" ¡¿Cómo?![K] ¡¿De verdad?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Yes. ♪[K] Of course I have. ♪", french="Mais oui. ♪[K]\nBien sûr que j'en ai entendu parler. ♪", german="Ja. ♪[K]\nNatürlich habe ich das. ♪", italian=" Certo. ♪[K] Naturalmente. ♪", spanish=" Sí. ♪[K] Claro que sí. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Didn't I just tell you I'm like\nan encyclopedia? ♪ Hee hee hee! ♪", french="Je te l'ai dit, non? Je suis une\nvraie encyclopédie. ♪ Hi hi hi! ♪", german="Sagte ich nicht, ich bin ein\nwandelndes Lexikon? ♪ Hi hi hi! ♪", italian="Non ti ho appena detto che sono\nuna specie di enciclopedia? ♪ Ih ih ih! ♪", spanish="¿No te acabo de decir que soy\nuna enciclopedia andante? ♪ ¡Ji, ji, ji! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well... [CS:P]Star Cave[CR] is a legendary\nplace, but nobody knows where it is...", french="Voyons... La [CS:P]Caverne Etoile[CR] est\nun lieu légendaire dont personne ne connaît\nl'emplacement exact...", german="Nun... Die [CS:P]Sternenhöhle[CR] ist ein\nlegendärer Ort. Nur weiß niemand, wo er\nsich befindet...", italian="Dunque... La [CS:P]Caverna Stellata[CR]\nè un luogo leggendario, ma nessuno sa\nveramente dove si trovi...", spanish="En fin... La [CS:P]Cueva Estrella[CR] es un\nlugar legendario, pero nadie sabe dónde está..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" N-nobody knows? Golly...", french=" P-personne? Sapristi...", german="N-niemand weiß es?\nDonnerwetter...", italian=" N-Nessuno? Ohibò...", spanish=" ¿Que... nadie lo sabe? Caramba..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That's right.[K] It's a legend that's\nbeen passed down for generations.", french="En effet.[K] C'est une légende qui\nse transmet de génération en génération...", german="Genau.[K] Es ist eine Legende,\ndie seit Generationen weitererzählt wird.", italian="Esatto.[K] È una leggenda che si\ntramanda di generazione in generazione.", spanish="Exacto.[K] Es una leyenda que se\nha ido transmitiendo a lo largo de generaciones."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" The truth is buried in history.", french="La vérité à son sujet s'est\nperdue dans les brumes de l'histoire.", german="Doch jede Legende\nbesitzt einen wahren Kern.", italian="La verità si perde nella notte\ndei tempi...", spanish="La verdad sobre esa historia\nse ha perdido con el paso del tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But according to the legend...[K]\nDeep within [CS:P]Star Cave[CR]...", french="Mais selon cette légende...[K]\nau fin fond de la [CS:P]Caverne Etoile[CR]...", german="Laut der Legende[K] liegt etwas\ntief in der [CS:P]Sternenhöhle[CR]...", italian="Ma a quanto si narra...[K]\nNelle profondità della [CS:P]Caverna Stellata[CR]...", spanish="Según la leyenda...[K]\nEn lo más profundo de la [CS:P]Cueva Estrella[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The rare Pokémon[K] [CS:N]Jirachi[CR]\nlies sleeping...", french="... le Pokémon mythique[K] [CS:N]Jirachi[CR]\nserait plongé dans un profond sommeil...", german="Es ist das seltene Pokémon\n[CS:N]Jirachi[CR], das sich dort befinden soll. Und zwar\nin einem tiefen Schlaf...", italian="...[K] [CS:N]Jirachi[CR], il Pokémon raro,\ngiace addormentato...", spanish="Yace dormido el raro Pokémon\n[CS:N]Jirachi[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's said that if you can wake\n[CS:N]Jirachi[CR]...[K]he'll grant you a wish.", french="Il est dit que quiconque se\nrévélera capable de réveiller [CS:N]Jirachi[CR]...[K]\nse verra exaucer un vœu...", german="Man sagt, dass derjenige, der\n[CS:N]Jirachi[CR] aufweckt, von diesem einen Wunsch\nerfüllt bekommt.", italian="Secondo la leggenda, chi\nrisveglierà [CS:N]Jirachi[CR]...[K] potrà esprimere\nun desiderio.", spanish="Se dice que, si logras despertar\na [CS:N]Jirachi[CR]...[K] te concederá un deseo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh?! [K]He'll grant you a wish?!", french=" Hein?! [K]Un vœu, qu'tu dis?!!", german="Wie bitte?!?[K]\nEs wird demjenigen einen Wunsch erfüllen?!?", italian=" Eh?![K] Un desiderio?!", spanish=" ¡¿Cómo?![K] ¡¿Un deseo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="A wish...[K] A wish-granting\nrare Pokémon...", french="Un vœu...[K] Un vœu exaucé par\nun Pokémon mythique...", german="Einen Wunsch...[K]\nEin wunscherfüllendes, seltenes Pokémon...", italian="Un desiderio...[K] Un Pokémon raro\nche esaudisce desideri...", spanish="Un deseo...[K] Un Pokémon\nque concede deseos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" His name is [CS:N]Jirachi[CR]?!", french=" Et son nom, c'est [CS:N]Jirachi[CR]?!", german=" Und es heißt [CS:N]Jirachi[CR]?!?", italian=" E il suo nome è [CS:N]Jirachi[CR]?!", spanish=" ¡¿Y dices que se llama [CS:N]Jirachi[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="He...[K] Hey, hey![K]\nIt's only a legend!", french="Oui, il...[K] Holà, doucement![K]\nC'est une légende, rien de plus!", german="Ha...[K] Hallo, hallo![K]\nAufwachen! Es ist nur eine Legende!", italian="Eh...[K] Ehi, ehi![K]\nÈ solo una leggenda!", spanish="Eh...[K] ¡Espera, no te embales![K]\n¡Que es solo una leyenda!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I already said that nobody\nknows where the cave is, didn't I?![K] ...HEY!", french="Je t'ai dit que personne ne\nsait où se trouve cette grotte![K] ... Hé!", german="Ich habe dir doch gerade gesagt,\ndass niemand weiß, wo sich diese Höhle\nbefindet, oder?!?[K] HEY!", italian="Ti ho già detto che nessuno\nconosce la posizione esatta della caverna...![K]\nEHI!", spanish="Ya te he dicho que nadie sabe\ndónde está esa cueva, ¡¿no?![K] ¡Pues ya está!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(90)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="...[K]Hey, [CS:Y]Bidoof[CR]. [K][CS:Y]Bidoof[CR], what are\nyou thinking of? [CS:Y]Bidoof[CR]?", french="...[K] Hé, [CS:Y]Keunotor[CR]. [K][CS:Y]Keunotor[CR],\nqu'est-ce qui te trotte dans la tête?\n[CS:Y]Keunotor[CR]?", german="...[K]Hey [CS:Y]Bidiza[CR].[K] Woran denkst du?\n[CS:Y]Bidiza[CR]?", italian="...[K] Ehi, [CS:Y]Bidoof[CR].[K] [CS:Y]Bidoof[CR], che\ncos'hai in mente? [CS:Y]Bidoof[CR]?", spanish="Oye...[K] Menuda cara, [CS:Y]Bidoof[CR].[K]\nDime, ¿qué se te pasa por la cabeza?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_BEYOND_THE_DREAM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff... (If I meet [CS:N]Jirachi[CR]...[K]he\ncan grant a wish...)", french="Snif... (Si je peux trouver ce\n[CS:N]Jirachi[CR]...[K] il exaucera mon vœu...)", german="Schnief... (Wenn ich [CS:N]Jirachi[CR]\nträfe...[K] Es kann einen Wunsch erfüllen...)", italian="Sniff... (Se incontrassi [CS:N]Jirachi[CR]...[K]\npotrebbe esaudire un mio desiderio...)", spanish="Ay... (Si encuentro a [CS:N]Jirachi[CR]...[K]\nme concederá un deseo...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Um um um... (That could be\nmy dream...)", french="Bla rêve blablabla...\n(Mais alors, mon rêve...)", german=" Öhm, öhm... (Mein Traum...)", italian="Uhm uhm uhm... (Coronerei\nil mio sogno...)", spanish="Eh... Hum... (Podría pedirle que\nhiciera realidad mi sueño...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Best... (My dream--to be the\nbest explorer ever...[CS:N]Jirachi[CR] can make it come\ntrue, yup yup!)", french="Bla meilleur blablabla... (Mon\nrêve de dev'nir le meilleur explorateur de tous\nles temps... [CS:N]Jirachi[CR] peut l'réaliser, pardi!)", german="Der Beste... (Mein Traum... Der\nbeste Erkunder überhaupt zu sein... [CS:N]Jirachi[CR]\nkönnte ihn mir erfüllen, jawollja!)", italian="Il migliore... (Il mio sogno...\ndiventare il miglior esploratore che esista...\n[CS:N]Jirachi[CR] può trasformarlo in realtà, già, già!)", spanish="Mejor... (Mi sueño es ser el\nmejor explorador que haya existido...\n¡Y [CS:N]Jirachi[CR] puede cumplirlo, sí, señor!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And... (And I've got that map\nwith [CS:P]Star Cave[CR] marked on it...)", french="Bla carte blablabla... (Et j'ai\ncette carte, là, avec la [CS:P]Caverne Etoile[CR]\nqui y est indiquée...)", german="Und... (Und ich besitze die Karte,\nauf der die [CS:P]Sternenhöhle[CR] verzeichnet ist...)", italian="E... (E ho quella mappa dove\nè segnata la [CS:P]Caverna Stellata[CR]...)", spanish="Y... (Y tengo ese mapa con la\n[CS:P]Cueva Estrella[CR] señalada...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Got... Mmm... (I've got that\nmap in my possession now, yup yup!)", french="Bla moi blablabla... (Oui, cette\ncarte, maintenant, c'est moi qui l'ai, pardi!)", german="Besitze... hmmm... (Die Karte\nbefindet sich in meinem Besitz, jawollja!)", italian="La... Uhm... (La mappa ce l'ho io\nadesso, già, già!)", spanish="Poder... hum... (¡Ese mapa\ntan valioso está en mi poder, sí, señor!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Star... (Right now, I'm...[K] I'm...[K]\nI'm the only one who knows where [CS:P]Star Cave[CR]\nis! Just li'l ol' me!)", french="Bla Etoile blabla... (Pour l'heure,\nj'suis...[K] j'suis l'seul à connaître l'emplacement\nd'la [CS:P]Caverne Etoile[CR], rien qu'moi tout seul!)", german="Sternen... (Zurzeit bin...[K] bin...[K]\nich der Einzige, der weiß, wo sich die\n[CS:P]Sternenhöhle[CR] befindet! Einzig und allein ich!)", italian="Caverna... (In questo momento,\nsono...[K] sono...[K] sono l'unico che sappia dove\nsi trova la [CS:P]Caverna Stellata[CR]! Io e solo io!)", spanish="Estrella... (Ahora soy...[K] Soy...[K]\n¡Soy el único que sabe dónde está la [CS:P]Cueva[CR]\n[CS:P]Estrella[CR]! ¡Solo yo lo sé!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Th... (Th-this...)", french="Bla mais blablabla...\n(M-mais c'est...)", german=" Da... (D-das...)", italian=" Q... (Q-Questo...)", spanish=" Es... (Es... esto...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Th... (This is...)", french="Bla c'est blablabla...\n(C'est...)", german=" Da... (Das ist...)", italian=" Q... (Q-Questo...)", spanish=" Es... (Esto es...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So c... (So cool! So awesome!\nYup yup!)", french="Bla trop blablabla... (C'est trop\nla classe! Trop cool! Nom d'une pipe!)", german="Da... (Das ist der Wahnsinn!\nUnglaublich! Jawollja!)", italian="È f... (È fantastico! Incredibile!\nGià, già!)", spanish="Geni... (¡Genial! ¡Estupendo!\n¡Sí, señor!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So h... (I'm so happy, I could\nbust!)", french="Bla si blablabla...\n(J'suis si heureux que j'pourrais\nsauter d'joie!)", german="Glü... (Bin so glücklich, ich\nkönnte hüpfen vor Freude!)", italian="Così f... (Sono così felice che\npotrei scoppiare!)", spanish="Soy... (¡Soy tan feliz que\npodría ponerme a cantar!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hey. ♪", french=" Hé. ♪", german=" Hey. ♪", italian=" Ehi. ♪", spanish=" Oye. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...Huh?!", french=" ... Hein?!", german=" ...Öhm, ja?!?", italian=" ... Eh?!", spanish=" ¡¿Eh?!..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Are you all right, [CS:Y]Bidoof[CR]?[K]\nYou kind of spaced out for a while.", french="Tout va bien, [CS:Y]Keunotor[CR]?[K]\nTu avais l'air un peu perdu dans tes rêveries.", german="Ist mit dir alles in Ordnung,\n[CS:Y]Bidiza[CR]?[K] Du sahst mir gerade leicht\nweggetreten aus.", italian="Va tutto bene, [CS:Y]Bidoof[CR]?[K]\nPer un attimo avevi lo sguardo trasognato.", spanish="¿Estás bien, [CS:Y]Bidoof[CR]?[K]\nParecías distraído."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And you were smiling\nto yourself.", french=" Et tu souriais béatement.", german="Und du hast ganz schön\ndeutlich in dich hineingegrinst...", italian=" E sorridevi tra te e te.", spanish=" Y no parabas de sonreír."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Something happen?", french=" Il se passe quelque chose?", german=" Ist etwas passiert?", italian=" È successo qualcosa?", spanish=" ¿Ha ocurrido algo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Nope![K] Nope, nope, nope, nope!", french=" Ben nan![K] Nan, nan, nan, nan!", german=" Nee![K] Nee, nee, nee, nee!", italian=" No![K] No no no no no!", spanish=" ¡No![K] ¡No, qué va, qué va!"})
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" N-nothin' at all! No sirree!", french=" R-rien du tout! R.A.S., chef!", german="Ü-überhaupt nicht! Ganz und\ngar nicht!", italian=" N-Niente di niente! Nossignore!", spanish=" ¡Na... nada de nada! ¡No, no!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I wasn't...[K] I wasn't thinking of\nanything! Not about [CS:P]Star Cave[CR]! Golly, no!", french="Je...[K] j'pensais à rien du tout,\ndu tout! Surtout pas à la [CS:P]Caverne Etoile[CR]!\nÇa non, pardi!", german="Ich habe...[K] Ich habe an gar\nnichts gedacht! Vor allem nicht an die\n[CS:P]Sternenhöhle[CR]! Donnerwetter, nein!", italian="Non...[K] Non pensavo a nulla!\nA nessuna [CS:P]Caverna Stellata[CR]! Ohibò, no!", spanish="No estaba...[K] No estaba pensando\nen nada. Desde luego, no en la [CS:P]Cueva Estrella[CR].\n¡Huy, no, qué va!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...Is that so?", french=" ... Vraiment?", german=" ...Ist das so?", italian=" ... Davvero?", spanish=" ¿De verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You say you weren't thinking of\nanything...[K] But that's a bit suspicious...", french="Tu prétends que tu ne pensais à\nrien du tout...[K] Pourtant, permets-moi\nd'en douter...", german="Du sagst, du hättest an gar\nnichts gedacht...[K] Aber das kommt mir ein\nwenig merkwürdig vor...", italian="Hai detto che non stavi pensando\na nulla...[K] Ma questa cosa mi insospettisce...", spanish="Dices que no estabas pensando\nen nada...[K] Pero eso es un poco sospechoso..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Eeek! (I gave myself away!)", french=" Aaaaargh! (J'me suis trahi!)", german="Ieek!\n(Habe ich mich etwa verraten?)", italian=" Aaah! (Mi sono tradito!)", spanish=" ¡Aaaay! (¡Soy un bocazas!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="With that mischievous smirk,\nyou had to be thinking of something,\ndon't you agree?", french="Ce petit sourire roublard me\npousse à croire que tu pensais bien à quelque\nchose en particulier, tu n'es pas d'accord?", german="Dein schelmisches Grinsen\nkommt doch nicht von ungefähr! Ich kann nicht\nglauben, dass gar nichts in dir vorgegangen ist.", italian="Con quello strano sorrisetto che\navevi, stavi pensando di certo a qualcosa.\nNon è così?", spanish="Con la sonrisa picarona que\nlucías tenías que estar pensando en algo,\n¿no crees?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Like you were secretly excited\nabout something...", french="Comme si tu cherchais à\ndissimuler ton excitation...", german="Als ob du im Stillen kaum an\ndich halten konntest vor lauter Aufregung...", italian="Era come se fossi stranamente\nemozionato da qualcosa...", spanish="Parecía que estabas nervioso\npor algún tipo de secreto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="B-but... (Th-that was to\nthe point!)", french=" M-mais... (Argh, touché!)", german="A-aber... (Sch-scharf\nbeobachtet!)", italian="M-Ma... (C-Ci ha azzeccato\nin pieno!)", spanish="Pe... pero... (¡Me... Me ha calado\ndel todo!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Like you were so excited about\nsomething that you thought you would\njust burst...", french="Comme si tu cherchais à\nréfréner une envie soudaine de sauter\nde joie...", german="Als ob du vor Aufregung hättest\numherhüpfen wollen...", italian="Emozionato da qualcosa di\ntalmente bello da farti scoppiare di gioia...", spanish="Parecía que estabas tan emocionado\npor algo que ibas a ponerte a cantar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="N-no, nuh-huh! (How in\nthe world did he know about that?)", french="N-non, heu, non, non!\n(Mais comment il a fait pour voir ça?)", german="N-nein, ööh-hö! (Woher um\nalles in der Welt weiß er das?)", italian="N-No, ehm-ehm! (Come ha fatto\na capirlo?)", spanish="¡No, pero qué dices! (¿Cómo lo\nha sabido? Sí que soy transparente...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:TeleportTo(npc_npc_dogoomu, 216, 308, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:TeleportTo(npc_npc_guregguru, 228, 220, Direction.Down)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" HEEEEY! [CS:Y]BIDOOF[CR]!", french=" HOLAAAAAA! [CS:Y]KEUNOTOR[CR]!", german=" HEEEEY! [CS:Y]BIDIZA[CR]!", italian=" EHIII! [CS:Y]BIDOOF[CR]!", spanish=" ¡Eh, [CS:Y]Bidoof[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(7)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yes! What is it?!", french=" Oui! Quoi donc?!", german=" Ja! Was gibt es denn?!?", italian=" Sì! Che c'è?!", spanish=" Dime, ¡¿qué ocurre?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" You've GOT a VISITOR!", french=" Tu AS de la VISITE!", german=" DU hast BESUCH!", italian=" HAI VISITE!", spanish=" ¡Tienes visita!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh? A visitor?", french=" Hein? De la visite?", german=" Was? Besuch?", italian=" Eh? Visite?", spanish=" ¿Cómo? ¿Que tengo visita?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 300, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 252, 280, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" G-golly, a visitor?[K] For me?", french="S-sapristi, de la visite?[K]\nMoi?", german="D-donnerwetter, Besuch?[K]\nFür mich?", italian=" O-Ohibò, visite?[K] Per me?", spanish=" Caramba, tengo visita...[K] ¿Yo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Yeah, THAT'S right.[K] They're\nWAITING by the GUILD entrance.", french="Ouais, TOUT JUSTE.[K]\nA l'entrée de la GUILDE.", german="Ja, GENAU.[K] Er WARTET am\nEINGANG der Gilde auf DICH.", italian="Già, ESATTO.[K] C'è qualcuno che\nti ASPETTA all'ingresso della GILDA.", spanish="Sí, sí, eso mismo.[K] Te están\nesperando en la entrada del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Hurry UP and get OUT there!", french=" BOUGE-TOI et VAS-Y!", german=" LOS, RAUS mit dir!", italian=" MUOVITI e vai lì FUORI!", spanish=" ¡Date prisa y sal ya!"})
  -- message_Close
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
