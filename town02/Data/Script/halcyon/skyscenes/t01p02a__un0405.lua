-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/un0405.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp_side(43, 2) >= 0) or ((SV.SkyTalkBitFlags or {})[137] == 1) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2] || $SCENARIO_TALK_BIT_FLAG[13
  -- @label_0 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_KECLEON_WARES)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[137] = 1 -- $SCENARIO_TALK_BIT_FLAG[137] = 1 (ROM)
  local npc_npc_kakureon2 = SkySceneKit.spawn_npc("kecleon", 352, 168, Direction.Down, "NPC_KAKUREON2")
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english=" Ah! Hello, [CS:Y]Sunflora[CR]! ♪", french=" Ah! Salut, [CS:Y]Héliatronc[CR]! ♪", german=" Ah! Hallo, [CS:Y]Sonnflora[CR]! ♪", italian=" Ah! Ciao, [CS:Y]Sunflora[CR]! ♪", spanish=" ¡Anda, hola, [CS:Y]Sunflora[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english=" Oh? [K]Is it a new job?", french=" Oh? [K]C'est une nouvelle mission?", german=" Oh?[K] Ein neuer Job?", italian=" Oh? [K]Hai una nuova missione?", spanish=" ¿Eh?[K] ¿Tiene una nueva misión?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
