-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_sutoraiku = SkySceneKit.spawn_npc("scyther", 336, 160, Direction.UpRight, "NPC_SUTORAIKU")
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english=" You're [CS:Y]Sunflora[CR] from the guild?", french=" Tu es [CS:Y]Héliatronc[CR], de la Guilde?", german="Du bist [CS:Y]Sonnflora[CR] von\nder Gilde?", italian="Tu sei [CS:Y]Sunflora[CR], quella della\nGilda?", spanish=" ¿Eres [CS:Y]Sunflora[CR], del [CS:N]Pokégremio[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_sutoraiku) end)
  SkySceneKit.say({english="I've heard you are one of the\nbest apprentices in [CS:N]Wigglytuff[CR]'s Guild.", french="J'ai entendu dire que tu étais\nparmi les meilleurs apprentis de la Guilde\nde [CS:N]Grodoudou[CR].", german="Man erzählt sich, dass du zu\nden Besten der [CS:N]Knuddeluff-Gilde[CR] gehörst.", italian="Ho sentito che sei uno dei\nmigliori apprendisti della Gilda di [CS:N]Wigglytuff[CR].", spanish="He oído que eres de las mejores\naprendices del [CS:N]Pokégremio de Exploradores[CR]."})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
