-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/un0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_KECLEON_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 3) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  if ((SV.SkyTalkBitFlags or {})[129] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[129]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[129] = 1 -- $SCENARIO_TALK_BIT_FLAG[129] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="We've got a lot of different\nitems again today! ♪", french="Nous avons plein d'objets\ndivers et variés aujourd'hui! ♪", german="Wir haben heute wieder eine\nAuswahl verschiedener Items im Angebot! ♪", italian="Oggi abbiamo tanti nuovi\nstrumenti! ♪", spanish="¡Hoy también tenemos un montón\nde objetos diferentes! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Please, take your time\nlooking! ♪", french="Je t'en prie, prends ton temps\npour regarder! ♪", german="Bitte, nimm dir Zeit beim\nStöbern! ♪", italian="Prego, guarda pure con\ncalma! ♪", spanish="¡Écheles un vistazo,\nsin prisas! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
