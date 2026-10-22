-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/un0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh. How was it?\nHow's the job?", french="Mwé hé hé. Alors?\nEt cette mission?", german="Mehehe. Wie war es?\nWas ist das für ein Job?", italian="Eh eh eh! Allora?\nDi che missione si tratta?", spanish="Je, je, je. ¿Cómo ha ido?\n¿Qué tal la misión?"})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="You came all the way back here.\nThat must mean...", french="Tu es revenue ici... Ça veut\nsûrement dire...", german="Du bist den ganzen Weg hierher\nzurückgekommen...", italian="Sei tornata qui. Allora significa\nche...", spanish="Has vuelto hasta aquí.\nEso debe de querer decir..."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Must have been a tough time, I'm\nguessing? Meh-heh-heh.", french="Tu as dû passer un sale\nmoment, j'imagine? Mwé hé hé.", german="War eine harte Zeit, was?\nMehehe.", italian="... te la sei vista brutta,\nnon è vero? Eh eh eh!", spanish="Que las habrás pasado canutas,\n¿me equivoco? Je, je, je."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Well, do your best!\nMeh-heh-heh.", french="Hé bien, fais de ton mieux!\nMwé hé hé.", german="Gib dein Bestes!\nMehehe.", italian="Beh, dacci dentro!\nEh eh eh!", spanish="Bueno, ¡a darlo todo!\nJe, je, je."})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="The Guildmaster was looking for\nyou earlier. Meh-heh-heh.", french="Le Maître de la Guilde te\ncherchait tout à l'heure. Mwé hé hé.", german="Der Gildenmeister hat vorhin\nnach dir gesucht. Mehehe.", italian="Il Capitano ti stava cercando.\nEh eh eh!", spanish="El Gran Bluff te buscaba\nantes. Je, je, je."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="It was just after Officer\n[CS:N]Magnezone[CR] went in...", french="Juste après l'arrivée du shérif\n[CS:N]Magnézone[CR]...", german="Kurz nachdem Oberwachtmeister\n[CS:N]Magnezone[CR] hereinkam...", italian="È successo poco dopo l'arrivo\ndel Commissario [CS:N]Magnezone[CR]...", spanish="Justo después de que el agente\n[CS:N]Magnezone[CR] entrara..."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Seems almost like official\nbusiness! Meh-heh-heh!", french="Ça sonne presque comme un\nboulot officiel! Mwé hé hé!", german="Sieht fast wie eine offizielle\nGeschichte aus! Mehehe!", italian="Pare che si tratti di qualcosa\ndi ufficiale! Eh eh eh!", spanish="¡Casi parecía un asunto oficial\ny todo! ¡Je, je, je!"})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I don't know what kind of job\nthey'll give you, but don't fail! Meh-heh-heh.", french="Je ne sais pas quel genre de\nmission ils vont te confier, mais n'échoue pas!\nMwé hé hé.", german="Ich weiß ja nicht, was für eine\nArt Job sie dir geben werden, aber sieh zu,\ndass du ihn nicht vergeigst! Mehehe.", italian="Non so che razza di missione ti\naffideranno, ma vedi di non fallire! Eh eh eh!", spanish="No sé qué tipo de misión\nte darán, ¡pero no metas la pata! Je, je, je."})
  -- message_Close
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
