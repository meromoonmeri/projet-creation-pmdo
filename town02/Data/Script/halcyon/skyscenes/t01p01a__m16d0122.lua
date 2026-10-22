-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m16d0122.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 192, Direction.Down, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It was nothing less than...[K]\ncausing the planet's paralysis.", french="Rien moins que...[K]\nprovoquer la Paralysie de la Planète.", german="Keinen geringeren Plan[K]\nals die Lähmung des Planeten!", italian="Il suo scopo consiste...[K]\nnientemeno che nella totale paralisi del\nmondo.", spanish="Pues nada más y nada menos...[K]\nque causar la parálisis del planeta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_s_perappu = SkySceneKit.spawn_npc("chatot", 376, 216, Direction.Up, "NPC_S_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 352, 176, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" The planet's...[K]paralysis?", french=" La Paralysie...[K] de la Planète?", german=" Die...[K] Lähmung des Planeten?", italian=" La paralisi...[K] del mondo?", spanish="¿Cómo?[K] ¿La parálisis del\nplaneta?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Yes.", french=" C'est cela même.", german=" Ja.", italian=" Esattamente.", spanish=" Así es."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If a planet becomes paralyzed,\nall movement upon it ceases.", french="Quand une planète est paralysée,\nelle est totalement privée de mouvement.", german="Wenn ein Planet gelähmt wird,\nhört jede Bewegung auf ihm auf.", italian="Se un pianeta subisce la paralisi,\nogni movimento cessa istantaneamente.", spanish="Si un planeta queda paralizado,\ncesa todo movimiento sobre su superficie."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="When a Time Gear is removed,\nthe flow of time slows in its region.", french="Dans une région privée\nde Rouage du Temps, le cours du temps\nest ralenti.", german="Wenn ein Zahnrad der Zeit\nentfernt wird, verlangsamt sich der Fluss der\nZeit in der jeweiligen Region.", italian="Quando viene rimosso un\nIngranaggio del Tempo, lo scorrere del tempo\nin quella zona subisce un rallentamento.", spanish="Al retirar un Engranaje del\nTiempo, el flujo temporal se para en\nesa zona."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="As many more are taken, time\nslows in an ever-larger area.", french="Et plus le nombre de Rouages\ndu Temps subtilisés croît, plus le phénomène\nprend une ampleur dramatique.", german="Je mehr Zahnräder der Zeit\ngestohlen werden, desto größer das Gebiet,\nin dem die Zeit langsamer fließt.", italian="Se ne vengono rimossi altri, il\ntempo rallenta in una zona ancora più ampia.", spanish="Cuantos más engranajes se\nquitan mayor es el área donde se detiene\nel tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Eventually, the planet's flow\nslows down so much that it stops entirely.", french="De telle sorte que le cours\ndu temps finit par s'arrêter complètement.", german="Schließlich wird der Fluss der\nZeit so langsam, dass sie ganz zum Stillstand\nkommt.", italian="In seguito, il tempo sull'intero\npianeta può rallentare fino all'arresto totale.", spanish="Al final, se alcanza un punto en\nel que el tiempo se detiene en todo el planeta."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Ultimately, the planet reaches a\nstate of total paralysis...", french="En dernier ressort, la planète\nest atteinte d'une paralysie totale...", german="Am Ende verfällt der Planet in\neinen Zustand vollkommener Lähmung.", italian="E infine, il pianeta rimane\ncompletamente paralizzato...", spanish="En la última fase del proceso,\nel planeta alcanza la parálisis total."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 272, 192, Direction.Right, "NPC_HIMEGUMA")
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="If the planet is paralyzed...[K]\nWhat happens to this world?", french="Et si la planète est paralysée...[K]\nque deviendra notre monde?", german="Wenn der Planet gelähmt ist...[K]\nWas geschieht dann mit der Welt?", italian="Se il pianeta subisce la\nparalisi...[K] cosa succede al nostro\nmondo?", spanish="Si el planeta se paraliza...[K]\n¿Qué es lo que pasaría?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="In a world where the planet has\nbecome paralyzed...", french="Dans un monde où la planète\nest paralysée...", german="In einer Welt, in der die\nLähmung des Planeten eingetreten ist...", italian="In un mondo dove è avvenuta la\nparalisi totale...", spanish="Si el planeta quedase totalmente\nparalizado..."})
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
