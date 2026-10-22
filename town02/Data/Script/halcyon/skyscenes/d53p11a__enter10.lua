-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P11A/enter10.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 113 or __sw == 114 or __sw == 117 or __sw == 118 or __sw == 119 or __sw == 50 or __sw == 121 or __sw == 122 or __sw == 123 or __sw == 125 then
  -- @label_12 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 129 then
  if (SkyProg.cmp_side(48, 9) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 9]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 280, 144, Direction.Down, "NPC_YAMIRAMI")
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="I've had the desire to change the\nworld for some time now.", french="Ça fait quelque temps que\nj'éprouve le désir de changer le monde.", german="Ich habe bereits seit einiger Zeit\ndas Verlangen, die Welt zu verändern.", italian="È da tanto che vorrei cambiare\nil mondo.", spanish="Hace tiempo que deseo poder\ncambiar el mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" But...[K]it's hard to be brave...", french="Mais...[K] c'est dur de trouver\nle courage...", german="Aber...[K] Es ist schwer,\ntapfer zu sein...", italian="Ma...[K] essere coraggiosi\nnon è facile...", spanish=" Pero...[K] cuesta reunir el valor..."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(48, 6) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [48, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="I've had the desire to change the\nworld for some time now.", french="Ça fait quelque temps que\nj'éprouve le désir de changer le monde.", german="Ich habe bereits seit einiger Zeit\ndas Verlangen, die Welt zu verändern.", italian="È da tanto che vorrei cambiare\nil mondo.", spanish="Hace tiempo que deseo poder\ncambiar el mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" But...[K]it's hard to be brave...", french="Mais...[K] c'est dur de trouver\nle courage...", german="Aber...[K] Es ist schwer,\ntapfer zu sein...", italian="Ma...[K] essere coraggiosi\nnon è facile...", spanish=" Pero...[K] cuesta reunir el valor..."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="I've had the desire to change the\nworld for some time now.", french="Ça fait quelque temps que\nj'éprouve le désir de changer le monde.", german="Ich habe bereits seit einiger Zeit\ndas Verlangen, die Welt zu verändern.", italian="È da tanto che vorrei cambiare\nil mondo.", spanish="Hace tiempo que deseo poder\ncambiar el mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" But...[K]it's hard to be brave...", french="Mais...[K] c'est dur de trouver\nle courage...", german="Aber...[K] Es ist schwer,\ntapfer zu sein...", italian="Ma...[K] essere coraggiosi\nnon è facile...", spanish=" Pero...[K] cuesta reunir el valor..."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 131 then
  if (SkyProg.cmp_side(48, 9) >= 0) or (SkyProg.cmp_side(48, 8) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 9] || scn($SCENARIO_SIDE) >= [48
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
