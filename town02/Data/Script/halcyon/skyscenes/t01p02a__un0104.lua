-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/un0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 336, 240, Direction.Down, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="It's all right![K] You'll succeed in\nthe exploration, [CS:Y]Bidoof[CR]!", french="C'est cool![K] Tu vas réussir ton\nexploration, [CS:Y]Keunotor[CR]!", german="Alles klar![K] Du wirst auf deiner\nErkundung erfolgreich sein, [CS:Y]Bidiza[CR]!", italian="Tranquillo [CS:Y]Bidoof[CR]![K]\nLa tua esplorazione andrà benissimo!", spanish="No te preocupes...[K] La exploración\nirá muy bien, [CS:Y]Bidoof[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Do your best! [K]Fight, fight!", french="Fais de ton mieux![K]\nBats-toi, bats-toi!", german=" Gib dein Bestes![K] Sei tapfer!", italian=" Fai del tuo meglio! [K]Forza, forza!", spanish=" ¡A por todas![K] ¡Ánimo, campeón!"})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 3) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Today I'm handling jobs with\n[CS:N]Corphish[CR].", french="Aujourd'hui, je vais remplir des\nmissions avec [CS:N]Ecrapince[CR].", german="Heute erledige ich Jobs\nzusammen mit [CS:N]Krebscorps[CR].", italian="Oggi devo lavorare con\n[CS:N]Corphish[CR].", spanish="Hoy me ocupo de las misiones\ncon [CS:N]Corphish[CR]."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh, [CS:Y]Bidoof[CR]![K]\nAre you headed somewhere?", french="Oh, [CS:Y]Keunotor[CR]![K]\nTu fais une petite balade?", german="Oh, [CS:Y]Bidiza[CR]![K]\nSchon unterwegs?", italian="Oh, [CS:Y]Bidoof[CR]![K]\nVai da qualche parte?", spanish="¡Eh, [CS:Y]Bidoof[CR]![K]\n¿Te vas de compras? ¡Qué ideal!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Take care!", french=" Fais attention à toi!", german=" Pass auf dich auf!", italian=" Fai attenzione!", spanish=" ¡Qué envidia, yo también quiero!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Well, it's time to do our\ndaily chores!", french="Eh bien, il est temps de nous\nmettre au travail!", german="Nun ja, es wird Zeit, unsere\ntäglichen Pflichten zu erledigen!", italian="Bene, è ora di mettersi\nal lavoro!", spanish="Bueno, ahora toca ocuparse de\nlas tareas diarias."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
