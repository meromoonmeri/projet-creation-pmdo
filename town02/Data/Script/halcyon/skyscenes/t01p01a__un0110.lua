-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0110.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_nyorotono = SkySceneKit.spawn_npc("politoed", 400, 184, Direction.Left, "NPC_NYOROTONO")
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="Mystery dungeons are usually\njust that--mysterious!", french="Les donjons mystères sont\ncomme leur nom l'indique: mystérieux!", german="Mystery Dungeons sind meistens\n...ziemlich mysteriös!", italian="Di solito i dungeon misteriosi\nsono... misteriosi, ecco!", spanish="Los territorios misteriosos\nsuelen serlo... ¡misteriosos, quiero decir!"})
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="But I don't think that they're\nthat mysterious.", french="Mais moi, je ne les trouve pas\nsi mystérieux.", german="Obwohl sie im Endeffekt doch\nnicht so mysteriös sind, denke ich.", italian="Ma non credo che lo siano così\ntanto, dopotutto.", spanish="Pero a mí no me parecen\ntan, tan misteriosos."})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
