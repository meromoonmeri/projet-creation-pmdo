-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m06a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(7, 4) -- $SCENARIO_MAIN = scn[7,4] (ROM)
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM06') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 168, 288, Direction.Down, "NPC_DOGOOMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" HEY, YOU TWO!", french=" HEP LA, VOUS DEUX!", german=" HEY, IHR ZWEI!", italian=" EHI, VOI DUE!", spanish=" ¡EH! ¡VENID AQUÍ!"})
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-48), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-48), p.Y+(0), false, 2) end
  GAME:FadeOut(false, 60)
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(188, 320, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(hero, 224, 292, Direction.Down)
  GROUND:TeleportTo(partner, 224, 324, Direction.Down)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 160, 304, Direction.Right, "NPC_DIGUDA")
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I'm sorry, but I have something\nelse I have to do today.", french="Je suis désolé, mais j'ai une\ntâche à vous confier aujourd'hui.", german="Tut mir leid, aber ich habe heute\netwas anderes zu erledigen.", italian="Spiacente, ma oggi ho\nqualcos'altro per voi.", spanish="Lo siento, pero hoy tengo\notras cosas que hacer."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Please take over my sentry duty\nagain today. Bye.", french="Merci d'occuper le poste de guet\nà ma place aujourd'hui. A plus tard!", german="Bitte übernehmt heute wieder\nmeinen Wachdienst. Tschüss!", italian="Per favore, fate di nuovo la\nguardia al posto mio. Ciao.", spanish="Necesito que os ocupéis de\nmi turno de vigilancia. Hasta luego."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpLeft)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" All right! Let's DO this!", french=" Allez! C'est PARTI!", german=" In Ordnung! Es geht LOS!", italian=" Va bene! AL LAVORO!", spanish=" De acuerdo, ¡ahora a trabajar!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You've done this sentry-duty\nthing once before, RIGHT?", french="Vous avez déjà fait le guet\nla dernière fois, PAS VRAI?", german="Das mit dem Wachdienst habt\nihr schon mal gemacht, ODER?", italian="Avete già fatto il turno\ndi guardia una volta, GIUSTO?", spanish="Ya habéis hecho esto antes,\n¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You'll be fine without me\nexplaining the job again?", french="Vous allez pouvoir vous\ndébrouiller sans que je vous réexplique\ntout, hein?", german=" Ihr wisst also, was zu tun ist?", italian="Vi devo spiegare di nuovo come\nfunziona?", spanish="Podéis hacer este trabajo sin\nque os lo tenga que explicar de nuevo, ¿no?"})
  do local __choice = SkySceneKit.ask({{english="Yes, no problem!", french="Oui, pas de problème!", german="Ja, kein Problem!", italian="Nessun problema!", spanish="¡Perfectamente!"}, {english="No, please explain...", french="Non, réexplique-nous, s'il te plaît...", german="Nein, bitte noch mal erklären...", italian="Spiega di nuovo, per favore...", spanish="¡Explícanoslo otra vez!"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="WHAT?! You need me to explain\nit again?!", french="QUOI?! Vous avez encore besoin\nd'une explication?!", german="WAS?!? Ihr wollt alles noch mal\nerklärt bekommen?!?", italian="COSA?! Volete che ve lo spieghi\ndi nuovo?!", spanish="¡¿Qué?! ¡¿Tengo que explicarlo\notra vez?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(20)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="All right. I've got a BIG heart.\nI'll explain as much as you want.", french="Bon, d'accord. C'est bien parce\nque j'ai BON cœur, hein. Je vous expliquerai\nautant de fois que vous voulez.", german="Na gut. Weil ich so GÜTIG bin,\nwerde ich es so oft erklären, wie ihr wollt.", italian="Va bene. Sono TROPPO buono.\nVe lo spiegherò quante volte volete.", spanish="Tenéis suerte de que sea buena\npersona. Os explicaré esto tantas veces como\nqueráis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(false, 30)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Good![K] Then, let's get to WORK!", french="Bien![K] Alors au BOULOT!\nHOP HOP HOP!", german=" Gut![K] Na dann, an die ARBEIT!", italian=" Bene![K] Allora, al LAVORO!", spanish=" Estupendo.[K] Ahora, ¡a trabajar!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Buck up and do a GOOD job!", french="Grouillez-vous et faites du BON\nboulot!", german=" Los, und macht eure Sache GUT!", italian="Rimboccatevi le maniche e fate\nun BUON LAVORO!", spanish=" ¡Espabilad y hacedlo bien!"})
  -- message_Close
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:MoveToPosition(hero, 200, 292, false, 2)
  GROUND:MoveToPosition(partner, 224, 316, false, 2)
  GROUND:MoveToPosition(hero, 192, 300, false, 2)
  GROUND:MoveToPosition(partner, 208, 300, false, 2)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  SkyProg.set(7, 5) -- $SCENARIO_MAIN = scn[7,5] (ROM)
  -- @label_2 [étiquette de flux ExplorerScript]
  end
  end
  SkySceneKit.cleanup_npcs()
end
