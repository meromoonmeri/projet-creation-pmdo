-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- debug_Print('START') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 93) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 93]
  SkySceneKit.play_scene("d73p11a__us2300", "d73p11a__us23", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P11A, 'US23', 0) [chaînage scène ROM]
  -- @label_9 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_PLAYER_SET') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[4] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[4]
  -- debug_Print('LABEL_REBIRTH') [neutre/état moteur]
  -- supervision_StationCommon(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_13 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  -- GAP: BGM BGM_SHAYMIN_VILLAGE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- debug_Print('LABEL_ENTER_END') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[4] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[4]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[4] = 0 -- $SCENARIO_MAIN_BIT_FLAG[4] = 0 (ROM)
  -- @label_10 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_END') [neutre/état moteur]
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif ((SV.SkyScenarioBitFlags or {})[46] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[46]
  GAME:FadeIn(30)
  GAME:FadeIn(30)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[46] = 0 -- $SCENARIO_MAIN_BIT_FLAG[46] = 0 (ROM)
  local npc_npc_fuwaraido = SkySceneKit.spawn_npc("drifblim", 280, 232, Direction.Down, "NPC_FUWARAIDO")
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english="The [CS:P]Shaymin Village[CR].\nThe [CS:P]Shaymin Village[CR].", french="[CS:P]Village Shaymin[CR],\n[CS:P]Village Shaymin[CR]!", german="Nächster Halt [CS:P]Shaymin-Dorf[CR].\nNächster Halt [CS:P]Shaymin-Dorf[CR].", italian="[CS:P]Villaggio Shaymin[CR]!\n[CS:P]Villaggio Shaymin[CR]!", spanish="[CS:P]Aldea Shaymin[CR].\nHemos llegado a [CS:P]Aldea Shaymin[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english=" Thank you for your patronage.", french="Merci d'avoir utilisé\nnos services.", german="Es ist mir immer ein Vergnügen,\ndich als Kunden begrüßen zu dürfen.", italian=" Grazie per averci scelto.", spanish=" Esperamos verte pronto, gracias."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  else
  -- @label_12 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_PLAYER_SET_RESUME') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[7] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[7]
  -- debug_Print('LABEL_RESUME') [neutre/état moteur]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 0 -- $SCENARIO_MAIN_BIT_FLAG[7] = 0 (ROM)
  -- supervision_StationCommon(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_13 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- @label_15 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_PLAYER_SET_NORMAL') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[46] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[46]
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_13 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  do local __sw = ((SV.SkyVars or {}).GROUND_GETOUT or -1) -- switch($GROUND_GETOUT) [GameVar GROUND_GETOUT: sortie précédente]
  if __sw == 202 then
  -- supervision_StationCommon(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_13 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 224 then
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_13 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_19 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_13 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  elseif (SkyProg.cmp(29, 86) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 86]
  SkySceneKit.play_scene("d73p11a__us2200", "d73p11a__us22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P11A, 'US22', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 77) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 77]
  SkySceneKit.play_scene("d73p11a__us2100", "d73p11a__us21", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P11A, 'US21', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 68) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 68]
  SkySceneKit.play_scene("d73p11a__us2000", "d73p11a__us20", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P11A, 'US20', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54]
  SkySceneKit.play_scene("d73p11a__us0400", "d73p11a__us04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P11A, 'US04', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  SkySceneKit.play_scene("d73p11a__us0300", "d73p11a__us03", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P11A, 'US03', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 32]
  SkySceneKit.play_scene("d73p11a__us0200", "d73p11a__us02", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P11A, 'US02', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 7]
  -- @label_8 [étiquette de flux ExplorerScript]
  SkySceneKit.play_scene("d73p11a__us3100", "d73p11a__us31", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P11A, 'US31', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- debug_Print('LABEL_BACK_SET') [neutre/état moteur]
  -- back_SetGround(LEVEL_D73P11A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
