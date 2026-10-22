-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0708.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I've given up on trying to turn back into\n[c_kind:NPC_TEST006].", french="I've given up on trying to turn back into\n[c_kind:NPC_TEST006].", german="I've given up on trying to turn back into\n[c_kind:NPC_TEST006].", italian="I've given up on trying to turn back into\n[c_kind:NPC_TEST006].", spanish="I've given up on trying to turn back into\n[c_kind:NPC_TEST006]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="From now on, I'm living as [c_kind:NPC_TEST007].\nPleased to meet you.", french="From now on, I'm living as [c_kind:NPC_TEST007].\nPleased to meet you.", german="From now on, I'm living as [c_kind:NPC_TEST007].\nPleased to meet you.", italian="From now on, I'm living as [c_kind:NPC_TEST007].\nPleased to meet you.", spanish="From now on, I'm living as [c_kind:NPC_TEST007].\nPleased to meet you."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
