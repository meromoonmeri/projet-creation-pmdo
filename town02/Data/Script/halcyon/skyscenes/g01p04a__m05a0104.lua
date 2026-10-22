-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m05a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.Right, "NPC_GUREGGURU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.Right, "NPC_DAGUTORIO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Left, "NPC_HEIGANI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.DownRight, "NPC_BIPPA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.UpRight, "NPC_DOGOOMU")
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" T-time has stopped?!", french=" Le... le temps s'est arrêté?!", german=" Die Z-zeit ist stehen geblieben?", italian=" I-Il tempo non scorre più?!", spanish=" El tiempo... ¡¿se ha detenido?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Down, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, -4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="How could something this\nawful happen?", french="Comment quelque chose de si\nterrible a pu arriver?", german="Wie konnte etwas so Schlimmes\nnur geschehen?", italian="Come è potuta succedere una\ncosa del genere?", spanish="¿Cómo ha podido ocurrir algo\ntan horrible?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" It's unthinkable!", french=" C'est inconcevable!", german=" Das ist ja unvorstellbar!", italian=" È impensabile!", spanish=" ¡Es impensable!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Yes, the unthinkable\nhas happened.", french="Oui, exactement. C'est une\nvéritable catastrophe.", german="Ja, das Unvorstellbare ist\ngeschehen.", italian=" Sì, è successo l'inimmaginabile.", spanish="En efecto, ha ocurrido algo\ninimaginable."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Left, "NPC_CHIRIIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Why has time stopped in\n[CS:P]Treeshroud Forest[CR]?", french="Pourquoi le temps s'est-il arrêté\ndans la [CS:P]Forêt Linceul[CR]?", german="Wieso die Zeit im\n[CS:P]Schemengehölz[CR] stehen geblieben ist?", italian="Perché si è fermato il tempo\nnella [CS:P]Foresta Arcana[CR]?", spanish="Os preguntaréis por qué se ha\ndetenido el tiempo en esa zona..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well, it's because [CS:P]Treeshroud\nForest[CR]'s Time Gear was...", french="Eh bien, c'est parce que\nle Rouage du Temps de la [CS:P]Forêt Linceul[CR]\na été...", german="Nun, weil das Zahnrad der Zeit\ndes [CS:P]Schemengehölzes[CR]...", italian="Beh, dovete sapere che\nl'Ingranaggio del Tempo della [CS:P]Foresta Arcana[CR]\nè stato...", spanish="El motivo es que el Engranaje del\nTiempo del [CS:P]Bosque Enraizado[CR] ha sido..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Stolen!", french=" ... volé!", german=" Ähem... Es wurde gestohlen!", italian=" ... rubato!", spanish=" ¡Robado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Huh?!", french=" Heiiin?!", german=" Was?!?", italian=" Eh?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" The Time Gear was s-stolen?!", french=" Le Rouage du Temps a été volé?", german="Das Zahnrad der Zeit wurde\ng-gestohlen?!?", italian="L'Ingranaggio del Tempo\nè stato r-rubato?!", spanish="¡¿Han robado el Engranaje del\nTiempo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="That's what made time stop!\nHey, hey, hey!", french="C'est pour ça que le temps s'est\narrêté! Dis donc!", german="Das hat die Zeit angehalten!\nHey, hey, hey!", italian="Ecco perché il tempo si è\nfermato! Ehi, ehi, ehi!", spanish="¡Eso es lo que ha hecho que\nel tiempo se detenga! ¡Madre mía!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'd heard it was possible![K]\nBut now it's really happened.", french="J'avais entendu dire que c'était\npossible![K] Et maintenant, c'est devenu réalité.", german="Ich hatte schon gehört, dass das\npassieren kann![K] Aber jetzt ist es wirklich\npassiert.", italian="Sapevo che era possibile![K]\nE adesso è successo davvero.", spanish="Había oído rumores...[K] y, por\ndesgracia, han resultado ser ciertos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I don't get it, though![K] Why would\nANYONE take a Time Gear?!", french="Je comprends pas![K] Pourquoi\nPIQUER un Rouage du Temps?!", german="Ich versteh es trotzdem nicht![K]\nWieso sollte IRGENDWER ein Zahnrad der Zeit\nstehlen?!?", italian="Però non capisco...[K] Perché\nQUALCUNO dovrebbe prendere l'Ingranaggio del\nTempo?!", spanish="¡No lo entiendo![K] ¿Por qué iba a\nrobar nadie un Engranaje del Tiempo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Quiet, everyone!", french=" Silence!", german=" Seid alle still!", italian=" Fate silenzio!", spanish=" ¡Silencio todos!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Officer [CS:N]Magnezone[CR] has already\nstarted an investigation.", french="Le shérif [CS:N]Magnézone[CR] a déjà\ncommencé à enquêter.", german="Oberwachtmeister [CS:N]Magnezone[CR]\nhat bereits mit den Ermittlungen begonnen.", italian="Il Commissario [CS:N]Magnezone[CR] ha\ngià iniziato a indagare.", spanish="El agente [CS:N]Magnezone[CR] ya ha iniciado\nuna investigación."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's hard to believe that anyone\nwould dare steal a Time Gear.", french="Il est difficile de croire que\nquelqu'un ait osé voler un Rouage du Temps.", german="Es ist schwer zu glauben, dass\njemand es wagen würde, ein Zahnrad der Zeit\nzu stehlen.", italian="È difficile credere che qualcuno\nosi rubare un Ingranaggio del Tempo.", spanish="Es difícil creer que alguien se haya\natrevido a robar un Engranaje del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But if one Time Gear can be\nstolen, the others may also be in danger.", french="Mais si un Rouage du Temps a\nété volé, les autres sont susceptibles d'être\ndérobés à leur tour!", german="Doch wenn ein Zahnrad der Zeit\ngestohlen werden konnte, sind vielleicht auch\ndie anderen in Gefahr.", italian="Ma se ne hanno rubato uno,\nanche gli altri potrebbero essere in pericolo.", spanish="Pero si esto es cierto, los otros\nEngranajes del Tiempo podrían estar en\npeligro."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The officer asked to be notified\nimmediately if we notice any suspicious\ncharacters.", french="Le shérif veut que nous le\nprévenions immédiatement si nous\nremarquons des individus suspects.", german="Der Oberwachtmeister bat\ndarum, sofort benachrichtigt zu werden, wenn\nuns verdächtige Pokémon auffallen.", italian="Il Commissario ha chiesto di\nessere informato immediatamente se notiamo\ndei tipi sospetti.", spanish="El agente nos ha pedido que le\nnotifiquemos si vemos a algún individuo\nsospechoso."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So keep that in mind. Let us\nknow if you notice anything.", french="Gardez bien ça en tête. Et\nprévenez-nous si vous remarquez\nquelque chose.", german="Also denkt daran. Lasst es uns\nwissen, wenn euch etwas auffällt.", italian="Quindi, ricordatevi di informarci\nse notate qualcosa.", spanish="Así que tened los ojos abiertos.\nAvisadnos si veis cualquier cosa."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That is all.", french=" C'est tout.", german=" Das ist alles.", italian=" È tutto.", spanish=" Eso es todo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone! Here's to\nanother busy day of work! ♪", french="Très bien, tout le monde! Une\nrude journée de travail nous attend! ♪", german="In Ordnung, Pokémon! Macht\neuch an die Arbeit! ♪", italian="Bene, gente! Prepariamoci\nad un'altra intensa giornata di lavoro! ♪", spanish=" ¡Ahora todos a trabajar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GAME:WaitFrames(1)
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
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
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
  SkySceneKit.say({english=" Oh, you there.", french=" Hé, vous là-bas.", german=" Oh, ihr da.", italian=" Ehi, voi.", spanish=" Oh, ahí estáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You two, come here.", french=" Oui, vous deux! Venez ici.", german=" Ihr beide, kommt her.", italian=" Voi due, venite qui.", spanish=" Pareja, venid aquí."})
  -- message_Close
  pcall(function() GAME:MoveCamera(456, 240, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 472, 248, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 440, 248, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You've become quite good at\nyour work.", french=" Vous avez fait des progrès.", german="Ihr macht eure Arbeit\nmittlerweile ganz gut.", italian=" Avete fatto dei buoni progressi.", spanish="Parece que el trabajo se os da\nbastante bien."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I'm impressed with your capture\nof [CS:N]Drowzee[CR]. That was very admirable! ♪", french="Je n'arrive pas à croire que\nvous ayez réussi à capturer [CS:N]Soporifik[CR].\nBeau travail! ♪", german="Ich war sehr beeindruckt, als\nihr [CS:N]Traumato[CR] gestellt habt. Das war\nbewundernswert! ♪", italian="Sono rimasto colpito da come\navete catturato [CS:N]Drowzee[CR]. Davvero\nammirevole! ♪", spanish="Me habéis impresionado con vuestra\ncaptura de [CS:N]Drowzee[CR]. ¡Ha sido admirable! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" So!", french=" En conséquence de quoi...", german=" Also...", italian=" Quindi!", spanish=" Así que..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You all will finally be assigned a\nmission worthy of a proper exploration team.", french="... on va enfin vous assigner\nune mission digne d'une véritable équipe\nd'exploration.", german="Ihr werdet endlich eine\nMission bekommen, die eines richtigen\nErkundungsteams würdig ist.", italian="Vi verrà finalmente assegnata\nuna missione degna di una vera e propria\nsquadra d'esplorazione.", spanish="Por fin os vamos a asignar un trabajo\ndigno de un auténtico equipo explorador."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" R-really?! Woo-hoo!", french=" Vraiment?! Youhou!", german=" W-wirklich?!? Juchhu!", italian=" D-Davvero?! Woooow!", spanish=" ¿De... de verdad? ¡Bravo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" R-really?! Hooray!", french=" Vraiment?! Youhou!", german=" W-wirklich?!? Hurra!", italian=" D-Davvero?! Urrà!", spanish=" ¿De... de verdad? ¡Hurra!"})
  else
  SkySceneKit.say({english=" R-really?! Yay!", french=" Vraiment?! Youhou!", german=" W-wirklich?!? Jippie!", italian=" D-Davvero?! Che bello!", spanish=" ¿De... de verdad? ¡Bien!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Let me see your Wonder Map.", french="Faites-moi voir votre Carte\nMiracle.", german=" Zeigt mir eure Wunderkarte.", italian="Fatemi vedere la vostra Mappa\ndelle meraviglie.", spanish=" Dejadme ver vuestro Mapa Mágico."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN][hero] opened\n[CN]the Wonder Map.", french="[CN][hero] ouvre\n[CN]la Carte Miracle.", german="[CN][hero] öffnet\n[CN]die Wunderkarte.", italian="[CN][hero] apre\n[CN]la Mappa delle meraviglie.", spanish="[CN][hero] abrió\n[CN]el Mapa Mágico."})
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
