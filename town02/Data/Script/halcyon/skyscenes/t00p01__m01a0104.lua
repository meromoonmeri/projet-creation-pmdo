-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Do you need something?", french="Do you need something?", german="Do you need something?", italian="Do you need something?", spanish="Do you need something?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Yes", german="Yes", italian="Yes", spanish="Yes"}, {english="No", french="No", german="No", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Do you really need something from me?", french="Do you really need something from me?", german="Do you really need something from me?", italian="Do you really need something from me?", spanish="Do you really need something from me?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Yes", german="Yes", italian="Yes", spanish="Yes"}, {english="No", french="No", german="No", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- @label_1 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I see...", french="I see...", german="I see...", italian="I see...", spanish="I see..."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- item_Set(0, 18, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- item_Set(1, 69, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- item_GetVariable(0, $ITEM_BACKUP) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- item_SetVariable(2, $ITEM_BACKUP) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[s_item:0] and [s_item:1]", french="Les objets [s_item:0] et [s_item:1]", german="[s_item:0] and [s_item:1]", italian="[s_item:0] and [s_item:1]", spanish="¡[s_item:0] y [s_item:1]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[s_item:2]?", french="L'objet [s_item:2]?", german="[s_item:2]?", italian="[s_item:2]?", spanish="¿[s_item:2]?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I can't help you with anything right now.", french="I can't help you with anything right now.", german="I can't help you with anything right now.", italian="I can't help you with anything right now.", spanish="I can't help you with anything right now."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  end
  end
end
