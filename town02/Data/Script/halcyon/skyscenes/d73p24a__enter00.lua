-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P24A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- debug_Print('START') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- debug_Print('START2') [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- debug_Print('START3') [neutre/état moteur]
  if (SkyProg.cmp(29, 93) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 93]
  SkySceneKit.play_scene("d73p24a__us2300", "d73p24a__us23", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P24A, 'US23', 0) [chaînage scène ROM]
  -- @label_9 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- debug_Print('LABEL_TEAM_SET') [neutre/état moteur]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_10 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_11 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_END') [neutre/état moteur]
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- debug_Print('LABEL_PLAYER_SET') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[4] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[4]
  -- debug_Print('LABEL_REBIRTH') [neutre/état moteur]
  -- supervision_StationCommon(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_14 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Sky Peak Prairie.ogg", true) end)
  -- debug_Print('LABEL_ENTER_END') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[4] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[4]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[4] = 0 -- $SCENARIO_MAIN_BIT_FLAG[4] = 0 (ROM)
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[46] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[46]
  GAME:FadeIn(30)
  GAME:FadeIn(30)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[46] = 0 -- $SCENARIO_MAIN_BIT_FLAG[46] = 0 (ROM)
  local npc_npc_fuwaraido = SkySceneKit.spawn_npc("drifblim", 144, 232, Direction.Down, "NPC_FUWARAIDO")
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english="[CS:P]Sky Peak[CR] 4th Station Clearing.\n4th Station Clearing.", french="[CS:P]Pic Céleste[CR], trouée du 4[F:E] Relais,\ntrouée du 4[F:E] Relais!", german="Nächster Halt [CS:P]Himmelsgipfel[CR]\n4. Zwischenlagerlichtung.\n4. Zwischenlagerlichtung.", italian="Bivacco 4 [CS:P]Picco del Cielo[CR]!\nBivacco 4!", spanish="Base del Cuarto Puerto de la\n[CS:P]Cumbre del Cielo[CR].\nHemos llegado a la Base del Cuarto Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english=" Thank you for your patronage.", french="Merci d'avoir utilisé\nnos services.", german="Es ist mir immer ein Vergnügen,\ndich als Kunden begrüßen zu dürfen.", italian=" Grazie per averci scelto.", spanish=" Esperamos verte pronto, gracias."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  else
  -- @label_13 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_PLAYER_SET_RESUME') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[7] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[7]
  -- debug_Print('LABEL_RESUME') [neutre/état moteur]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 0 -- $SCENARIO_MAIN_BIT_FLAG[7] = 0 (ROM)
  -- supervision_StationCommon(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[46] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[46]
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- @label_17 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_PLAYER_SET_NORMAL') [neutre/état moteur]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif (SkyProg.cmp(29, 86) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 86]
  SkySceneKit.play_scene("d73p24a__us2200", "d73p24a__us22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P24A, 'US22', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 77) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 77]
  SkySceneKit.play_scene("d73p24a__us2100", "d73p24a__us21", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P24A, 'US21', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 68) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 68]
  SkySceneKit.play_scene("d73p24a__us2000", "d73p24a__us20", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P24A, 'US20', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54]
  SkySceneKit.play_scene("d73p24a__us0400", "d73p24a__us04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P24A, 'US04', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  SkySceneKit.play_scene("d73p24a__us0300", "d73p24a__us03", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P24A, 'US03', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 32]
  SkySceneKit.play_scene("d73p24a__us0200", "d73p24a__us02", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P24A, 'US02', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 7]
  -- @label_8 [étiquette de flux ExplorerScript]
  SkySceneKit.play_scene("d73p24a__us3100", "d73p24a__us31", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P24A, 'US31', 0) [chaînage scène ROM]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- debug_Print('LABEL_BACK_SET') [neutre/état moteur]
  -- back_SetGround(LEVEL_D73P24A) [neutre/état moteur]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
