-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P02A/m10a0902.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_P03P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- GAP: BGM BGM_RAIN2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 376, 616, Direction.Up, "NPC_HEIGANI")
  GROUND:MoveToPosition(npc_npc_heigani, 376, 476, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_heigani, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey, hey![K] Check this out,\neveryone!", french="Eh dis donc![K] Regardez ça, vous\nautres!", german=" Hey, hey, hey![K] Seht mal alle her!", italian=" Ehi, ehi, ehi![K] Guardate qui!", spanish=" ¡Mirad![K] ¡Venid todos a ver esto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 416, 624, Direction.Up, "NPC_KIMAWARI")
  GROUND:MoveToPosition(npc_npc_kimawari, 416, 468, false, 2)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 344, 616, Direction.Up, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 344, 468, false, 2)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 424, 664, Direction.Up, "NPC_CHIRIIN")
  GROUND:MoveToPosition(npc_npc_chiriin, 424, 512, false, 2)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 336, 648, Direction.Up, "NPC_DIGUDA")
  GROUND:MoveToPosition(npc_npc_diguda, 332, 492, false, 2)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 352, 664, Direction.Up, "NPC_DAGUTORIO")
  GROUND:MoveToPosition(npc_npc_dagutorio, 352, 520, false, 2)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 360, 648, Direction.Up, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 400, 496, false, 2)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 384, 640, Direction.Up, "NPC_DOGOOMU")
  GROUND:MoveToPosition(npc_npc_dogoomu, 360, 500, false, 2)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 392, 664, Direction.Up, "NPC_GUREGGURU")
  GROUND:MoveToPosition(npc_npc_guregguru, 396, 524, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- se_FadeOut(6916, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" This is it?[K] The Groudon statue?", french="C'est donc ça?[K] La statue\nde Groudon?", german="Ist sie das?[K] Die Statue von\nGroudon?", italian="E questa cos'è?[K] Una statua di\nGroudon?", spanish=" ¿Esto?[K] ¿La estatua de Groudon?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GAME:WaitFrames(30)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Oh! But there's no one else here!", french=" Oh! Mais il n'y a personne!", german=" Oh! Aber es ist niemand hier!", italian=" Oh! Ma non c'è nient'altro qui!", spanish="¡Oh! ¡Pero si aquí no hay nadie\nmás!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Are you really sure that you saw\nthe Guildmaster, [CS:N]Corphish[CR]?", french="Es-tu bien sûr d'avoir vu\nle Maître de la Guilde, [CS:N]Ecrapince[CR]?", german="Bist du dir sicher, dass du den\nGildenmeister gesehen hast, [CS:N]Krebscorps[CR]?", italian="Sei sicuro di aver visto il\nCapitano, [CS:N]Corphish[CR]?", spanish="¿Seguro que has visto al Gran\nBluff, [CS:N]Corphish[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_heigani, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Sure, I'm sure!", french=" Bien sûr que j'en suis sûr!", german=" Sicher bin ich mir sicher!", italian=" Sicuro che sono sicuro!", spanish=" ¡Seguro, seguro!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I saw him when I was scuttling\nback to base camp.", french="Je l'ai croisé en revenant au\ncamp de base.", german="Ich habe ihn gesehen, als ich\nauf dem Weg zurück zum Basislager war.", italian="L'ho visto mentre stavo\ntornando verso il Campo Base.", spanish="Le vi cuando volvía\nal campamento base."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="The Guildmaster dashed past, all\nwilly-nilly, in hot pursuit of a Perfect Apple!", french="Le Maître de la Guilde est passé\nà côté de moi en vitesse, tout excité,\nà la poursuite d'une Pomme Parfaite!", german="Der Gildenmeister hetzte auf der\nJagd nach einem Perfekten Apfel vorbei!", italian="Il Capitano è schizzato alla\nvelocità della luce alla ricerca di una Mela\nPerfetta!", spanish="¡El Gran Bluff corría enloquecido\ntras una Manzana Perfecta!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I gave him a shout and a wave,\nbut he seemed too occupied to holler back.", french="Je l'ai salué et lui ai fait signe,\nmais il avait l'air trop occupé pour répondre.", german="Ich habe gerufen und gewinkt,\naber er war anscheinend zu abgelenkt und hat\nnicht reagiert.", italian="L'ho chiamato ad alta voce! Mi\nsono sbracciato! Tutto inutile... Sembrava\ntroppo indaffarato per rispondermi!", spanish="Intenté atraer su atención,\npero parecía estar demasiado ocupado\npara darse por aludido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_heigani, Direction.DownRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="But I'd guess that [hero]'s\nteam went ahead.", french="Mais je pense que l'équipe\nde [hero] est partie la première.", german="Aber ich würde sagen, dass\ndas Team von [hero] vorgegangen ist.", italian="Ma immagino che la squadra di\n[hero] sia andata avanti.", spanish="Doy por hecho que el equipo\nde [hero] siguió adelante."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="So I'd bet that the Guildmaster\nwent up after them, don't you think?", french="Alors je dirais que le Maître\nde la Guilde a voulu les suivre, vous croyez\npas?", german="Bestimmt ist der Gildenmeister\nihnen nachgegangen, glaubst du nicht auch?", italian="Scommetterei che il Capitano li\nstia raggiungendo ormai, non credete?", spanish="Supongo que el Gran Bluff iría\ntras ellos, ¿no creéis?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6935) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  -- GAP: se_Play(6935) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Hmm?[K] The ground...", french=" Hum?[K] La terre...", german=" Hmm?[K] Der Boden...", italian=" Che succede?[K] La terra...", spanish=" ¿Eh?[K] La tierra..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Uh-what...? It's shaking!", french=" Heiiin, quoi...? Elle tremble!", german=" Zum Kuckuck? Er bebt!", italian=" ... sta... sta... sta tremando!", spanish=" ¿Qué...? ¡Está temblando!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  -- GAP: se_Play(6934) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRROOOOOOH...!", french="GRROOOOOOH...!", german="GRROOOOOOH!", italian="GRROOOOOOH...!", spanish="¡GRRRRRRRRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" What...[K]whatever could that be?!", french="Que...[K] qu'est-ce que ça peut bien\nêtre?!", german=" Was...[K] Was ist das bloß?!?", italian=" Cosa...[K] Cos'era quello?!", spanish=" ¿Qué?[K] ¿Qué será eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" What an uproar![K] Is it maybe...?", french="Mais quel BOUCAN![K]\nSe pourrait-il...?", german="Was für ein Lärm![K] Ist das\nvielleicht...", italian=" Che boato![K] Cosa potrebbe mai...", spanish="¡Vaya estruendo![K]\n¿Tal vez será...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Something is going on up there!", french="Il se passe quelque chose\nlà-haut!", german=" Irgendetwas geht da oben vor!", italian=" Sta succedendo qualcosa laggiù!", spanish=" ¡Algo pasa allí arriba!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Let's head up! Hurry!", french=" Allons voir! Vite!", german=" Laufen wir hoch! Schnell!", italian=" Presto! Muoviamoci!", spanish=" ¡Rápido, subamos ahora mismo!"})
  -- message_Close
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(120), p.Y+(0), false, 2) end
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(120), p.Y+(0), false, 2) end
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(120), p.Y+(-16), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(160), p.Y+(0), false, 2) end
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(160), p.Y+(0), false, 2) end
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(120), p.Y+(0), false, 2) end
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(200), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(56), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(76), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Hmm?", french=" Hum?", german=" Hmm?", italian=" Mmm?", spanish=" ¿Qué?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_dagutorio, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Hey, Dad! Did you hear something\nright over there?", french="Père! Tu as entendu quelque\nchose par là?", german="Hey, Papa! Hast du das da\ndrüben gehört?", italian="Ehi, papà![K] Non hai sentito\nniente tu?", spanish=" ¡Eh, papá! ¿Tú has oído algo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Like moaning and groaning?", french="Comme des râles\net des grognements?", german=" So ein Ächzen und Stöhnen?", italian=" Come una specie di lamento?", spanish=" ¿Como quejidos y gemidos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_diguda, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Oh, you just imagined it![K]\nNow, let's hurry!", french="Ton imagination te joue\ndes tours, voilà tout![K] Allez, dépêchons!", german="Oh, das hast du dir eingebildet![K]\nBeeilen wir uns jetzt!", italian="Te lo devi essere immaginato![K]\nAndiamo, dai!", spanish="¡Te lo habrás imaginado![K]\n¡Démonos prisa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_dagutorio, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Yep!", french=" Ouaip!", german=" Jep!", italian=" Ok!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(150), p.Y+(-24), false, 2) end
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(160), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 184, 488, Direction.Right, "NPC_SUKATANKU")
  -- SetAnimation(24) [anim idle native]
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 136, 472, Direction.DownRight, "NPC_ZUBATTO")
  -- SetAnimation(24) [anim idle native]
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 136, 496, Direction.Down, "NPC_DOGAASU")
  -- SetAnimation(24) [anim idle native]
  pcall(function() GAME:MoveCamera(156, 508, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(45)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Ouchee-wow-wow!", french=" Ouille! Aïe aïe aïe!", german=" Auauauauuuutsch!", italian=" Ahi ahi ahi!", spanish=" ¡Ay, ay, ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" I'm d-d-[K]deflated! I can't move!", french="Je suis tout d-d-[K]dégonflé!\nJe peux plus bouger!", german="Ich bin ganz a-a-[K]ausgelaugt!\nIch kann mich nicht bewegen!", italian="Sono...[K] distrutto! Non riesco a\nmuovermi!", spanish="Estoy des...[K] ¡desinflado!\n¡No puedo ni moverme!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Hork-ork-[K]how did that happen?", french="Kof kof! [K]Comment ça a pu\nse produire?", german=" W-wa...[K] Wie ist das passiert?", italian="Argh![K] Come è potuto\nsuccedere?", spanish=" Ay, ay...[K] ¿Cómo ha podido pasar?"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="How did [CS:N]Wigglytuff[CR] shrug off\nour noxious-gas special like it was nothing?", french="Comment [CS:N]Grodoudou[CR] a-t-il fait\npour ignorer notre double attaque au gaz\nnauséabond comme si de rien n'était?", german="Wie hat [CS:N]Knuddeluff[CR] unsere\ngiftige Gas-Spezial-Kombo so leicht\nabgeschüttelt?", italian="Come ha fatto [CS:N]Wigglytuff[CR] a\ndifendersi dal nostro micidiale gas puzzolente?", spanish="¿Cómo ha podido evitar\n[CS:N]Wigglytuff[CR] nuestro gas nocivo como\nsi no fuera nada?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="And h-h-how did [CS:N]Wigglytuff[CR]\nstrike back at us...", french="Et comment est-ce qu'il a fait\npour riposter comme ça...", german="Und w-w-wie hat [CS:N]Knuddeluff[CR]\nzurückgeschlagen?", italian="E soprattutto, come ha fatto a\ndarcene così tante dopo...?", spanish="Y encima, ¿cómo ha podido\ncontraatacar?"})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" It's un-[K]believable...", french=" C'est carrément...[K] incroyable...", german=" Es ist un-[K]glaublich...", italian=" È...[K] davvero incredibile...", spanish=" Es sencillamente...[K] increíble..."})
  -- message_KeyWait
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(3), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(1)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(-3), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Ack...", french=" Argh...", german=" Argh...", italian=" Bleah...", spanish=" Ay..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(3), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(1)
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(-3), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Erk...", french=" Ergh...", german=" Urgh...", italian=" Sob...", spanish=" Hey..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(3), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(1)
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(-3), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Ork...", french=" Orgh...", german=" Orgh...", italian=" Argh...", spanish=" Huy..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
