-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) or (SkyProg.cmp_side(40, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_poppo = SkySceneKit.spawn_npc("pidgey", 392, 296, Direction.Right, "NPC_POPPO")
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="Even though we may be small,\nwe've got big dreams!", french="On n'est peut-être pas\nbien grands, mais nos rêves, eux, le sont!", german="Auch wenn wir klein sein mögen:\nUnsere Träume sind groß!", italian="Saremo anche piccoli, ma\nabbiamo grandi aspirazioni!", spanish="¡Aunque seamos pequeños,\nnuestros sueños son enormes!"})
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="We have big dreams as an\nexploration team!", french="En tant qu'équipe d'exploration,\nnous avons de grandes aspirations!", german="Wir haben große Träume für\nunser Erkundungsteam!", italian="La nostra squadra di\nesplorazione sogna in grande!", spanish="¡Y tenemos grandes sueños para\nnuestro equipo explorador!"})
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english=" By becoming more well known...", french="En devenant de grands\nexplorateurs...", german="Unser Ziel sollte es sein,\nbekannter zu werden...", italian=" Vogliamo diventare famosi...", spanish=" Vamos a ser famosísimos..."})
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="We want the whole world to\nknow the name Team [CS:X]Seedgey[CR]!", french="... on veut que le monde entier\nentende parler de l'Equipe [CS:X]Grainicool[CR]!", german="Denn wir wollen, dass die ganze\nWelt den Namen Team [CS:X]Tauburzel[CR] kennt!", italian="Così tutto il mondo conoscerà\nil Team [CS:X]Seedgey[CR]!", spanish="¡Queremos que todo el mundo\nconozca al [CS:X]Equipo Seedgey[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="Accomplishing jobs off the\nBulletin Board is just one step![K]\nWe'll accomplish lots of them!", french="Accomplir les missions\naffichées sur le Tableau des Missions n'est\nqu'une étape![K] On va en accomplir des tas!", german="Jobs vom Infobrett zu\nerledigen, ist nur ein Schritt![K] Wir werden\nviele dieser Jobs erledigen!", italian="Controllare la Bacheca delle\nmissioni è solo il primo passo![K] Noi vogliamo\nportarne a termine moltissime!", spanish="Cumplir misiones del Tablón de\nAnuncios es solo el primer paso.[K]\n¡Vamos a ser los mejores!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
