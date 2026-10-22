-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m16a0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM16') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...That's the current situation!", french="... Voilà donc où nous\nen sommes!", german=" ...Das ist unsere Situation!", italian=" E questa è la situazione attuale!", spanish=" Esta es la situación actual."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Until everything is resolved, we\nask that you go about your regular duties.", french="Jusqu'à ce que tout soit résolu,\nveuillez poursuivre vos tâches habituelles.", german="Bis alles geklärt ist, sollten wir\neinfach unseren gewohnten Pflichten nachgehen.", italian="Finché la questione non viene\nrisolta, vi preghiamo di tornare alle vostre\nnormali attività.", spanish="Hasta que todo se resuelva,\ntenemos que pediros que os encarguéis\nde vuestras responsabilidades habituales."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Yes, we would like you to spread\nthe rumor as much as possible...", french="Oui, nous aimerions que vous\npropagiez la rumeur autant que possible...", german="Ja, wir wollen, dass ihr das\nGerücht so weit wie möglich verbreitet.", italian="Inoltre, per favore, cercate di\nspargere la voce...", spanish="Por supuesto que nos gustaría\nque os pasarais todo el tiempo posible\nextendiendo el rumor..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But not so much that it would\nmake [CS:N]Grovyle[CR] suspicious.", french="... mais en vous appliquant à ne\npas éveiller les soupçons de [CS:N]Massko[CR].", german="Aber übertreibt es nicht, damit\n[CS:N]Reptain[CR] keinen Verdacht schöpft.", italian="Ma tenete a mente che\n[CS:N]Grovyle[CR] non deve insospettirsi.", spanish="Pero no tanto como para que\n[CS:N]Grovyle[CR] sospeche algo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Try to be natural! ♪", french=" Essayez d'avoir l'air naturel! ♪", german=" Verhaltet euch natürlich! ♪", italian=" Cercate di essere naturali!", spanish=" ¡Comportaos con naturalidad! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Go about your jobs in the usual\nmanner.[K] And, when possible, spread the rumor.", french="Accomplissez vos missions\ncomme vous le faites d'habitude.[K] Et propagez\nla rumeur quand l'occasion se présente.", german="Erledigt euren Job wie immer.[K]\nUnd wenn sich die Gelegenheit ergibt,\nverbreitet das Gerücht.", italian="Svolgete i vostri compiti come\nal solito.[K] E quando possibile, spargete la voce.", spanish="Cumplid vuestras misiones\ncomo de costumbre.[K] Y, si tenéis\nocasión, extended el rumor."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That is what we would like you\nto do for at least the next few days.", french="Voilà pour le programme\ndes prochains jours.", german="Das ist für mindestens ein paar\nTage eure Aufgabe.", italian="Questo sarà il vostro compito\nnei prossimi giorni.", spanish="Eso es lo que nos gustaría\nque hicierais durante los próximos días."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That is all!", french=" C'est tout!", german=" Das ist alles!", italian=" È tutto!", spanish=" ¡Eso es todo!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone! Let's have\nanother good day of work! ♪", french="Très bien, tout le monde! C'est\nparti pour une bonne journée de travail! ♪", german="In Ordnung, Pokémon! Auf einen\nweiteren erfolgreichen Arbeitstag! ♪", italian=" Facciamo del nostro meglio!", spanish="¡Muy bien! ¡A trabajar un día\nmás! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  -- SetAnimation(23) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
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
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 132, false, 2)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Oh, you two!", french=" Oh, vous autres!", german=" Oh, ihr zwei!", italian=" Oh, voi due!", spanish=" ¡Ah, aquí estáis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Today, take jobs on the Job\nBulletin Board and the Outlaw Notice Board.", french="Aujourd'hui, occupez-vous\ndes missions du Tableau des Missions et\ndes Avis de Recherche.", german="Erledigt heute die Jobs an\nden Job- und Ganoven-Infobrettern.", italian="Oggi dovreste tornare a dare\nun'occhiata alla Bacheca delle missioni e a\nquella dei ricercati.", spanish="Hoy tenéis que aceptar misiones\ndel Tablón de Anuncios y el Tablón \"Se Busca\"."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That will do! ♪", french=" Ce sera tout! ♪", german=" Das dürfte reichen! ♪", italian=" Buona fortuna!", spanish=" ¡Con eso será suficiente! ♪"})
  -- message_Close
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SPECIAL_EPISODE_OPEN = SV.SkyVars.SPECIAL_EPISODE_OPEN or {}; SV.SkyVars.SPECIAL_EPISODE_OPEN[2] = 1 -- $SPECIAL_EPISODE_OPEN[2] = 1 (ROM)
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayFanfare("Fanfare/Note") end) -- me_Play(7) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]The Exploration Team Federation\n[CN]has sent a message...[W:30]", french="[CN]La Fédération des Equipes d'Exploration\n[CN]a envoyé un message...[W:30]", german="[CN]Der Erkundungsteamverband\n[CN]hat eine Nachricht geschickt...[W:30]", italian="[CN]Arriva un messaggio della Federazione\n[CN]Squadre d'Esplorazione![W:30]", spanish="[CN]La Federación de Exploradores\n[CN]ha enviado un mensaje...[W:30]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_G01P09A) [neutre/état moteur]
  -- supervision_Acting(10) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(256) [anim idle native]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]The Special Episode\n[CN]\"Today's 'Oh My Gosh'\"\n[CN]has been unlocked![W:90]", french="[CN]L'Episode Spécial\n[CN]\"Ben mince alors!\"\n[CN]est maintenant disponible![W:90]", german="[CN]Die Bonusepisode\n[CN][F:S2]Das [F:S2]Auweia[F:E2] des Tages[F:E2]\n[CN]wurde freigeschaltet![W:90]", italian="[CN]L'episodio speciale\n[CN]\"Una giornata da shock\"\n[CN]è ora disponibile![W:90]", spanish="[CN]Se ha desbloqueado\n[CN]el capítulo especial\n[CN]\"¡O sea, pero qué fuerte!\".[W:90]"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]To play a Special Episode,\n[CN]select it from the Episode List\n[CN]on the Top Menu.", french="[CN]Pour jouer à un Episode Spécial,\n[CN]sélectionnez-le dans la Liste des épisodes\n[CN]à partir du menu principal.", german="[CN]Um eine Bonusepisode zu spielen,\n[CN]wähle sie in der Episodenliste\n[CN]im Hauptmenü aus.", italian="[CN]Per giocare a un episodio speciale,\n[CN]selezionalo dalla lista episodi\n[CN]nel menu principale.", spanish="[CN]Para jugar a un capítulo especial,\n[CN]elígelo en la lista de capítulos\n[CN]del menú principal."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]If you would like to play the Special Episode,\n[CN]save your adventure progress, and\n[CN]return to the Top Menu.", french="[CN]Si vous souhaitez jouer à cet Episode Spécial,\n[CN]sauvegardez d'abord votre aventure\n[CN]puis retournez au menu principal.", german="[CN]Wenn du eine Bonusepisode spielen\n[CN]möchtest, speichere deinen Spielstand\n[CN]und kehre zum Hauptmenü zurück.", italian="[CN]Se vuoi giocare all'episodio speciale,\n[CN]salva i progressi della tua avventura\n[CN]e torna al menu principale.", spanish="[CN]Si quieres jugar al capítulo especial,\n[CN]guarda tu progreso y\n[CN]vuelve al menú principal."})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM16') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkySceneKit.cleanup_npcs()
end
