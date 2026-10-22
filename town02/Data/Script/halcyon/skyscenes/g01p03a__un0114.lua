-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0114.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_sandopan = SkySceneKit.spawn_npc("sandslash", 480, 224, Direction.UpLeft, "NPC_SANDOPAN")
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="As I hear, ever since time\nbecame weird, there have been more\nbad Pokémon...", french="J'ai entendu dire que, depuis que\nle temps est détraqué, il y a de plus en plus\nde méchants Pokémon.", german="Wie ich höre, gibt es mehr\nbösartige Pokémon, seitdem die Zeit\nverrücktspielt...", italian="Ho sentito che da quando il\ntempo ha cominciato ad andare fuori controllo,\nsono comparsi sempre più Pokémon cattivi...", spanish="Por lo que he oído, desde que\nel tiempo anda raro no paran de aparecer\nPokémon malvados..."})
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
