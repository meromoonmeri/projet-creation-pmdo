-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m05a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(6, 1) -- $SCENARIO_MAIN = scn[6,1] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[8] = 1 -- $PERFORMANCE_PROGRESS_LIST[8] = 1 (ROM)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Er, ahem.[K] Everyone, listen up.\nI have an important announcement to make.", french="Hum hum.[K] Ecoutez tous.\nJ'ai une annonce importante à faire.", german="Ähem.[K] Hört bitte alle her.\nIch habe eine wichtige Neuigkeit.", italian="Ahem.[K] Posso avere la vostra\nattenzione? Devo fare un annuncio importante.", spanish="Ejem...[K] Escuchadme todos.\nTengo que anunciar algo importante."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Far to the northeast, then\nfarther into its outermost reaches...", french="Loin au nord-est, aux confins\nde notre monde...", german="Weit oben im Nordosten,\nund noch weiter draußen, in den äußersten\nGefilden...", italian="A nord-est, molto lontano da\nqui...", spanish="Muy lejos del [CS:N]Pokégremio[CR], más\nallá de los confines del noroeste..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There lies a place named\n[CS:P]Treeshroud Forest[CR]...", french="... se trouve un endroit connu\nsous le nom de [CS:P]Forêt Linceul[CR]...", german="Dort gibt es einen Ort namens\n[CS:P]Schemengehölz[CR]...", italian="... c'è un luogo chiamato\n[CS:P]Foresta Arcana[CR].", spanish="Se encuentra un lugar conocido\ncomo el [CS:P]Bosque Enraizado[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" In [CS:P]Treeshroud Forest[CR]...", french=" Dans cette [CS:P]Forêt Linceul[CR]...", german=" Im [CS:P]Schemengehölz[CR]...", italian=" Nella [CS:P]Foresta Arcana[CR]...", spanish=" En el [CS:P]Bosque Enraizado[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Time has apparently stopped...", french="... il semble que le temps se soit\narrêté...", german="Dort ist anscheinend die Zeit\nstehen geblieben...", italian="... il tempo sembra essersi\nfermato.", spanish=" El tiempo parece haberse detenido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Huh?!", french=" Hein?!", german=" Äh?!?", italian=" Eh?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Eek! What did you say?!", french=" Hiii! J'hallucine!", german=" Ieek! Was hast du gesagt?!?", italian=" Ehi! Cosa hai detto?!", spanish=" ¡Ayayay! ¡¿Qué has dicho?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="You're saying time stopped?!\nHey, hey, hey!", french="Tu es en train de dire que\nle temps s'est arrêté?! Dis donc!", german="Du sagst, die Zeit ist stehen\ngeblieben?!? Hey, hey, hey!", italian="Stai dicendo che il tempo si è\nfermato?! Ehi, ehi, ehi!", spanish="¡¿El tiempo se ha parado?!\n¿En serio?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Yes, that's correct...", french=" Oui, c'est exact...", german=" Ja, richtig...", italian=" Sì, è così...", spanish=" Así es."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
