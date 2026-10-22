-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/un0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The Guildmaster gave you this\nopportunity!", french="Le Maître de la Guilde t'a donné\ncette opportunité!", german="Der Gildenmeister hat dir dies\nermöglicht!", italian="Il Capitano ti ha concesso questa\nopportunità!", spanish="¡El Gran Bluff os ha dado\nesta gran oportunidad!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Do your best!", french=" Fais de ton mieux!", german=" Mach das Beste daraus!", italian=" Fai del tuo meglio!", spanish=" ¡Hacedlo lo mejor posible!"})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 3) >= 0) or (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 3] || scn($SCENARIO_SIDE) >= [40
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ......", french=" ......", german=" ......", italian=" ......", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Your request for a day off is\ngranted...[K]but...", french="Ton congé est accordé...[K]\nmais...", german="Deinem Antrag auf ein bisschen\nfreie Zeit wird stattgegeben...[K] Aber...", italian="Ti concedo qualche giorno\nlibero...[K] ma...", spanish="No hay problema con que te\ncojas algún día libre...[K] Eso sí..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Don't cause any trouble for\nother teams, OK?", french="... n'importune pas les autres\néquipes, d'accord?", german="Behindere andere Teams nicht\nbei ihrer Arbeit, okay?", italian="... non disturbare il lavoro\ndelle altre squadre, intesi?", spanish="No des problemas a los\ndemás equipos, ¿de acuerdo?"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" About the chore I mentioned...", french=" En parlant de travail...", german="Zu der Aufgabe, die ich\nerwähnte...", italian="A proposito del compito di cui\nti parlavo...", spanish=" Sobre la tarea que mencioné..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Could you head over to [CS:K]Kecleon[CR]\nMarket and find out how many [CS:I]Oran Berries[CR]\nthey have for sale? ♪", french="Est-ce que tu pourrais aller au\n[CS:K]Marché Kecleon[CR] et demander combien\nde [CS:I]Baies Oran[CR] ils ont à vendre? ♪", german="Würdest du bitte zum\n[CS:K]Kecleon-Markt[CR] gehen und fragen, wie viele\n[CS:I]Sinelbeeren[CR] sie heute zum Verkauf haben? ♪", italian="Potresti andare al [CS:K]Kecleon[CR]\nMarket e scoprire quante [CS:I]Baccarance[CR]\nvendono? ♪", spanish="¿Te importaría acercarte al\n[CS:K]Bazar Kecleon[CR] y averiguar cuántas\n[CS:I]Bayas Aranja[CR] tienen a la venta? ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I'll leave you to it! ♪", french=" Je te laisse faire! ♪", german="Ich überlasse dir das dann\nmal! ♪", italian=" Conto su di te! ♪", spanish=" ¡Lo dejo en tus manos! ♪"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
