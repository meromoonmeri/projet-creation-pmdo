-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0105.ssb (ROM sha256 1fa39d35…).
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
  local npc_npc_namakero = SkySceneKit.spawn_npc("slakoth", 280, 224, Direction.UpLeft, "NPC_NAMAKERO")
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english=" ...[K]Hmm...", french=" ...[K] Hum...", german=" ...[K]Hmm...", italian=" ...[K] Mmmh...", spanish=" Hum...[K] Mmm..."})
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="Seems like you...[K]\nand I have the same style...", french="On dirait que toi...[K]\net moi... on a le même style...", german="Es scheint, als hätten...[K]\ndu und ich denselben Stil...", italian="Sembra che tu...[K]\nabbia il mio stesso stile...", spanish="Parece que tú y yo...[K]\ntenemos el mismo estilo."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
