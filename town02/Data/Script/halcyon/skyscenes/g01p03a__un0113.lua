-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0113.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_sutoraiku = SkySceneKit.spawn_npc("scyther", 408, 224, Direction.UpRight, "NPC_SUTORAIKU")
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="It seems like more bad Pokémon\nhave been appearing lately...", french="On dirait que beaucoup\nde méchants Pokémon sont\napparus dernièrement...", german="Anscheinend sind in letzter Zeit\nvermehrt bösartige Pokémon aufgetaucht...", italian="Sembra che ultimamente siano\napparsi molti Pokémon cattivi...", spanish="Parece que últimamente han\naparecido más Pokémon malvados..."})
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
