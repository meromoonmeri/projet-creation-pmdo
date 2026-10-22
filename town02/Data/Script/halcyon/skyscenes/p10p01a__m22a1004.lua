-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P10P01A/m22a1004.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P10P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_rapurasu = SkySceneKit.spawn_npc("lapras", 32, 128, Direction.Right, "NPC_RAPURASU")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- GAP: SetEffect 646 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  GROUND:MoveToPosition(npc_npc_rapurasu, 164, 124, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 216, 128, Direction.Left, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Lapras[CR]![K] Long time no see! ♪", french="[CS:N]Lokhlass[CR]![K] Ça faisait\nlongtemps! ♪", german=" [CS:N]Lapras[CR]![K] Lange nicht gesehen! ♪", italian="[CS:N]Lapras[CR]![K] È da tanto che non ci\nvediamo! ♪", spanish="¡[CS:N]Lapras[CR]![K]\n¡Cuánto tiempo sin vernos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="It's been too long, [CS:N]Wigglytuff[CR].[K]\nYou look well.", french="Trop longtemps, [CS:N]Grodoudou[CR].[K]\nTu as l'air de te porter comme un charme.", german="Zu lange nicht, [CS:N]Knuddeluff[CR].[K]\nGut siehst du aus.", italian="Quanto tempo, [CS:N]Wigglytuff[CR].[K]\nMi sembri in forma.", spanish="Ha pasado mucho tiempo,\n[CS:N]Wigglytuff[CR].[K] Tienes buen aspecto."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Is [CS:N]Chatot[CR] doing well too?", french=" Comment va [CS:N]Pijako[CR]?", german=" Geht es [CS:N]Plaudagei[CR] auch gut?", italian=" Sta bene anche [CS:N]Chatot[CR]?", spanish=" ¿[CS:N]Chatot[CR] también está bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yes![K] Very well! ♪", french=" Bien![K] Très bien! ♪", german=" Ja![K] Sehr gut! ♪", italian=" Sì![K] Molto bene! ♪", spanish=" ¡Sí![K] ¡Muy bien! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" I'm glad to hear that!", french=" Ravi de l'apprendre!", german=" Freut mich zu hören!", italian=" Mi fa piacere!", spanish=" ¡Me alegro de oírlo!"})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" I've always meant to thank you.", french=" Je voulais te remercier.", german="Ich wollte dir schon immer\ndanken.", italian="Avrei sempre voluto\nringraziarvi.", spanish="Siempre he querido darte\nlas gracias."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="I deeply appreciate the promise\nyou made...and upheld for all this time.", french="J'apprécie à sa juste valeur\nla promesse que tu as faite... et tenue pendant\ntout ce temps.", german="Ich weiß dein Versprechen sehr\nzu schätzen... Und dass du es all die Zeit\ngehalten hast.", italian="Ho apprezzato profondamente la\npromessa che avete fatto... e che avete\nmantenuto per tutto questo tempo.", spanish="Aprecio la promesa que hiciste\ny que has mantenido todo este tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" No problem! ♪ No big deal! ♪", french="Pas de problème! ♪\nPas la peine d'en faire tout un plat! ♪", german="Kein Problem! ♪ Nicht der\nRede wert! ♪", italian=" Nessun problema! ♪ Capirai! ♪", spanish="¡Ningún problema! ♪\n¡No es para tanto! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But today...[K] I am here to see\nyou about that promise.", french="Mais si je suis ici aujourd'hui...[K]\nc'est justement à cause de cette promesse.", german="Aber heute...[K] Heute bin ich\nwegen dieses Versprechens zu dir gekommen.", italian="Ma oggi...[K] sono qui per parlarti\ndi quella promessa.", spanish="Pero hoy...[K] he venido\na verte para hablarte de esa promesa."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We find ourselves in a situation\nwhere we can't afford to uphold that promise.\nI suspect that you know why.", french="Nous nous trouvons dans\nune situation qui ne nous permet plus de tenir\nparole. Je pense que tu sais pourquoi.", german="Unsere Situation erlaubt es\nnicht, dass wir uns an dieses Versprechen\nhalten. Du weißt vermutlich, warum.", italian="Ci troviamo nella situazione di\nnon poterla più mantenere. Immagino che tu\nsappia il perché.", spanish="Nos encontramos en una\nsituación en la que no me puedo permitir\nmantenerla. Creo que sabes por qué."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" So please tell me...", french="Alors, s'il te plaît,\nexplique-moi...", german=" Also erzähl mir bitte etwas...", italian="Dunque, per favore,\ndimmi tutto...", spanish=" Querría pedirte que..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="about that...[K]strange pattern we\nonce saw.", french="... ce symbole...[K] étrange\nque nous avons vu une fois.", german="Und zwar über...[K] Über\ndieses seltsame Muster, das wir einmal\ngesehen haben.", italian="Parlami di quello...[K] strano\ndisegno che abbiamo visto quella volta.", spanish="Me hablaras de...[K] aquella extraña\nforma que vimos."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkyProg.set(24, 0) -- $SCENARIO_MAIN = scn[24,0] (ROM)
  SkySceneKit.cleanup_npcs()
end
