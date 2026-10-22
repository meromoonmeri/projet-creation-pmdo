-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/hus04.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_rejirokku = SkySceneKit.spawn_npc("regirock", 280, 376, Direction.Up, "NPC_REJIROKKU")
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- message_Close
  -- @label_0 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
