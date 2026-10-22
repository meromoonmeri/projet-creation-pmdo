-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0407.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_namakero = SkySceneKit.spawn_npc("slakoth", 280, 224, Direction.UpLeft, "NPC_NAMAKERO")
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english=" Exploring is...[K]too much effort.", french="Raaagh... L'exploration... [K]c'est\ntrop d'efforts, trop fatigant.", german=" Erkunden ist...[K] zu anstrengend.", italian=" Esplorare è...[K] troppo faticoso.", spanish="Explorar supone...[K] demasiado\nesfuerzo."})
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english=" Huh? [K]It's not too much effort?", french="Hein? [K]\nÇa ne te fatigue pas trop?", german=" Was?[K] Nicht zu anstrengend?", italian=" Eh? [K]Non è troppo faticoso?", spanish="¿Cómo?[K] ¿Que no es\ndemasiado esfuerzo?"})
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english=".........[K]\nOh...[K]I see...", french=" .........[K] Oh...[K] Je vois...", german=".........[K]\nOh...[K] Ich verstehe...", italian="..........[K]\nOh...[K] Capisco...", spanish=" Ah...[K] Vale...[K] Entiendo..."})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
