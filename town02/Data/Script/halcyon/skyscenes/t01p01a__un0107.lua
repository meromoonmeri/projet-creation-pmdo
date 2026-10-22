-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0107.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 296, 200, Direction.UpRight, "NPC_HIMEGUMA")
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Oh, hi, [CS:Y]Bidoof[CR]!", french=" Oh, salut, [CS:Y]Keunotor[CR]!", german=" Oh, hallo, [CS:Y]Bidiza[CR]!", italian=" Oh, ciao, [CS:Y]Bidoof[CR]!", spanish=" ¡Eh, hola, [CS:Y]Bidoof[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="Errands again today?[K]\nYou're working hard as always.", french="Encore des commissions,\naujourd'hui?[K]\nTu travailles dur, comme toujours.", german="Wieder Besorgungen zu\nerledigen?[K] Du bist fleißig wie immer.", italian="Sei di nuovo in giro per qualche\ncommissione, eh?[K] Lavori sodo come sempre.", spanish="¿Sigues haciendo recados?[K]\nSiempre trabajas durísimo."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
