-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04C/m24a0111.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 448, 264, Direction.DownRight, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" So...[K]what happened?", french="Et ensuite...[K] qu'est-ce qui s'est\npassé?", german=" Und...[K] Was geschah dann?", italian=" E poi...[K] cosa è successo?", spanish=" Entonces...[K] ¿Qué ocurrió?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 504, 280, Direction.Left, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Lapras[CR] revealed it to me.", french=" [CS:N]Lokhlass[CR] m'a révélé le secret.", german=" [CS:N]Lapras[CR] offenbarte es mir.", italian=" [CS:N]Lapras[CR] me l'ha rivelata.", spanish=" [CS:N]Lapras[CR] me lo reveló."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="He said that the Relic Fragment\nchooses who will go to the [CS:P]Hidden Land[CR].", french="Il m'a dit que le Fragment\nde Relique choisissait le Pokémon qui aurait\nle droit d'aller dans les [CS:P]Terres Illusoires[CR].", german="Er sagte, das Reliktfragment\nwähle denjenigen aus, der zum\n[CS:P]Verborgenen Land[CR] gehen wird.", italian="Ha detto che è il Frammento\nAntico stesso a scegliere chi può andare nella\n[CS:P]Terra Nascosta[CR].", spanish="Dijo que la Reliquia de Piedra es\nla que escoge quién puede tener acceso a la\n[CS:P]Tierra Oculta[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 440, 240, Direction.DownRight, "NPC_DOGOOMU")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 424, 280, Direction.Right, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 416, 256, Direction.Right, "NPC_BIPPA")
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "exclaim", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 488, 240, Direction.DownRight, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 448, 288, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(30)
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="The Relic Fragment itself does\nthat?!", french="C'est le Fragment de Relique\nlui-même qui choisit?!", german="Das Reliktfragment selbst tut\ndas?!?", italian=" Lo sceglie il Frammento Antico?!", spanish="¡¿La Reliquia de Piedra puede\nhacer algo así?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 472, 280, Direction.Right, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" It chooses. On its own?", french=" Il choisit... tout seul?", german=" Es wählt aus. Von selbst?", italian=" Lo sceglie da solo?", spanish=" ¿Escoger por sí misma?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yep. Apparently so! ♪", french=" Oui, apparemment! ♪", german=" Jep. Anscheinend ist es so! ♪", italian=" Già. Pare sia così! ♪", spanish=" Pues parece ser que sí. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="And the Relic Fragment chose\n[partner].", french="Et c'est sur [partner] que\nle choix du Fragment de Relique s'est porté.", german="Und das Reliktfragment wählte\n[partner] aus.", italian="E il Frammento Antico ha scelto\n[partner].", spanish="Y la Reliquia de Piedra escogió\na [partner]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey! Why did the Relic Fragment\nchoose [partner]?", french="Eh dis donc, pourquoi\n[partner]?", german="Hey! Warum hat das\nReliktfragment [partner] ausgewählt?", italian="Ehi! Perché il Frammento Antico\nha scelto [partner]?", spanish=" ¡Oye! ¿Por qué lo elegiría?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I don't really know.", french=" Je ne sais pas trop.", german=" Ich weiß es nicht wirklich.", italian=" Non lo so davvero.", spanish=" Lo cierto es que no lo sé."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I think [CS:N]Dialga[CR] wants to prevent\nthose with bad intentions in their hearts from\nentering [CS:P]Temporal Tower[CR].", french="Je pense que [CS:N]Dialga[CR] veut\nempêcher les individus mal intentionnés\nd'accéder à la [CS:P]Tour du Temps[CR].", german="Ich glaube, [CS:N]Dialga[CR] möchte\ndiejenigen vom Eindringen in den [CS:P]Zeitturm[CR]\nabhalten, die böse Absichten im Herzen tragen.", italian="Penso che [CS:N]Dialga[CR] voglia evitare\nche qualcuno che coltiva cattive intenzioni\npossa entrare nella [CS:P]Torre del Tempo[CR].", spanish="Creo que [CS:N]Dialga[CR] quiere evitar\nque aquellos con malas intenciones puedan\nentrar en la [CS:P]Torre del Tiempo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That's why the important thing\nis the purity of heart.", french="La qualité déterminante\nest donc un cœur pur.", german="Darum ist das wichtigste\nKriterium die Herzensgüte.", italian="Perciò la cosa più importante è\navere un cuore puro.", spanish="Por eso la pureza de corazón\nes lo importante."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="So [partner]'s heart must\nhave resonated with the Relic Fragment.", french="Et le cœur de [partner] a dû\nrépondre aux attentes du Fragment de Relique.", german="Und deswegen muss das Herz\nvon [partner] auf einer Wellenlänge\nmit dem Reliktfragment gelegen haben.", italian="Dunque il Frammento Antico deve\naver sentito le vibrazioni del cuore di\n[partner].", spanish="La Reliquia de Piedra debió de\nver algo así en el interior de [partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Anyway, we can do no more\nto help.", french="Bref, tout cela n'est plus\nen notre pouvoir.", german="Wir können nicht mehr tun, um\nzu helfen.", italian="Comunque, non possiamo più\nessere d'aiuto.", spanish="En cualquier caso, nuestro papel\nse acaba aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="From now on...[K]this burden\nbelongs to [partner] and [hero]...", french="Désormais...[K] ce sont\n[partner] et [hero] qui doivent\nporter ce fardeau...", german="Von jetzt an...[K] ruht diese Bürde\nauf den Schultern von [partner] und\n[hero]...", italian="D'ora in poi...[K] questo peso\nricade sulle spalle di [partner] e\n[hero]...", spanish="De ahora en adelante...[K] esta\ncarga le corresponde a [partner] y\na [hero]..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It's Team [team:]'s weight\nto bear now.", french="C'est à l'Equipe [team:]\nde jouer maintenant.", german="Dieses Päckchen muss jetzt\nTeam [team:] tragen.", italian="Ora sarà il Team [team:]\na portare questo fardello.", spanish="Todo está en manos del [CS:X]Equipo[CR]\n[team:]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It's entirely up to them to get to\nthe [CS:P]Hidden Land[CR].[K] It falls to them to stop the\ndestruction of time...", french="A elle de rallier les [CS:P]Terres\nIllusoires[CR].[K] A elle aussi de mettre un terme\nà la destruction du temps...", german="Es liegt ganz an ihnen, zum\n[CS:P]Verborgenen Land[CR] zu gelangen.[K] Sie sind es, die\ndie Zerstörung der Zeit aufhalten müssen...", italian="Solo loro potranno raggiungere\nla [CS:P]Terra Nascosta[CR].[K] Toccherà a loro evitare\nla distruzione del tempo...", spanish="Tendrán que encontrar la forma\nde llegar a la [CS:P]Tierra Oculta[CR] y...[K] de evitar\nla destrucción del tiempo."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 19 -- $COMPULSORY_SAVE_POINT = 19 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
