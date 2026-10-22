-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/un0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_pochiena_a = SkySceneKit.spawn_npc("poochyena", 368, 264, Direction.Up, "NPC_POCHIENA_A")
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="So which items should we buy\ntoday...?", french="Alors quels objets on va\nacheter aujourd'hui...?", german="Welche Items sollen wir heute\nkaufen gehen?", italian="Quindi oggi che strumenti\ndobbiamo comprare?", spanish="Me pregunto qué objetos\ndeberíamos comprar hoy."})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
