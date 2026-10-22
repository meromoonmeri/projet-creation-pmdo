-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04C/m24a0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 504, 280, Direction.UpLeft, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Kabutops[CR] and his brutes attacked\nus without warning.", french="[CS:N]Kabutops[CR] et ses sbires\nnous ont attaqués sans crier gare.", german="[CS:N]Kabutops[CR] und seine Schergen\ngriffen uns ohne Vorwarnung an.", italian="[CS:N]Kabutops[CR] e i suoi scagnozzi ci\nhanno attaccato di sorpresa.", spanish="[CS:N]Kabutops[CR] y sus secuaces nos\natacaron sin previo aviso."})
  -- message_KeyWait
  pcall(function() SOUND:FadeOutBGM(160) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR] reacted first and shielded\nme from them, and he got knocked out.", french="[CS:N]Pijako[CR] a réagi le premier et\ns'est sacrifié pour me protéger. C'est comme\nça qu'il a été mis K.O.", german="[CS:N]Plaudagei[CR] reagierte zuerst\nund schirmte mich vor ihnen ab. Dabei wurde\ner K.O. geschlagen.", italian="[CS:N]Chatot[CR] ha reagito prontamente e\nmi ha fatto scudo col suo corpo.\nE così è andato KO.", spanish="[CS:N]Chatot[CR] reaccionó primero y\nme protegió del golpe, pero se quedó\nfuera de combate."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I sent [CS:N]Kabutops[CR]'s gang packing\nafter that, but...", french="Ensuite, j'ai mis la bande\nde [CS:N]Kabutops[CR] en déroute, mais...", german="Danach habe ich [CS:N]Kabutops[CR] und\nseine Bande Sterne sehen lassen, aber...", italian="Poi ho messo in fuga la banda di\n[CS:N]Kabutops[CR], ma...", spanish="Después les di una lección\na [CS:N]Kabutops[CR] y su banda, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR] was knocked out. I didn't\nknow what to do.", french="[CS:N]Pijako[CR] était évanoui\net je ne savais pas quoi faire.", german="[CS:N]Plaudagei[CR] war außer Gefecht.\nIch wusste nicht, was ich tun sollte.", italian="[CS:N]Chatot[CR] era a terra. Non sapevo\ncosa fare.", spanish="[CS:N]Chatot[CR] estaba muy mal.\nNo sabía qué hacer."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I was in a panic because I\ncouldn't help [CS:N]Chatot[CR].", french="J'étais paniqué parce que\nje ne pouvais rien faire pour aider [CS:N]Pijako[CR].", german="Ich geriet in Panik, weil ich\n[CS:N]Plaudagei[CR] nicht helfen konnte.", italian="Ero in preda al panico perché\nnon sapevo come aiutare [CS:N]Chatot[CR].", spanish="Sentí pánico porque no podía\nayudarle."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" That was when [CS:N]Lapras[CR] appeared.", french="Et c'est là que [CS:N]Lokhlass[CR]\na fait son apparition.", german=" Da tauchte [CS:N]Lapras[CR] auf.", italian=" Poi è comparso [CS:N]Lapras[CR].", spanish="Fue entonces cuando apareció\n[CS:N]Lapras[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 448, 264, Direction.DownRight, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" [CS:N]Lapras[CR]?", french=" [CS:N]Lokhlass[CR]?", german=" [CS:N]Lapras[CR]?", italian=" [CS:N]Lapras[CR]?", spanish=" ¿[CS:N]Lapras[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yep. [CS:N]Lapras[CR].", french=" Exact, [CS:N]Lokhlass[CR].", german=" Jep. [CS:N]Lapras[CR].", italian=" Già. [CS:N]Lapras[CR].", spanish=" Sí... [CS:N]Lapras[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Lapras[CR] saved [CS:N]Chatot[CR].", french="C'est [CS:N]Lokhlass[CR] qui a sauvé\n[CS:N]Pijako[CR].", german=" [CS:N]Lapras[CR] rettete [CS:N]Plaudagei[CR].", italian=" [CS:N]Lapras[CR] ha salvato [CS:N]Chatot[CR].", spanish=" [CS:N]Lapras[CR] salvó a [CS:N]Chatot[CR]."})
  -- message_Close
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
