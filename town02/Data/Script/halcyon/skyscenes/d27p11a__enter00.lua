-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D27P11A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 25 then
  SkySceneKit.play_scene("d27p11a__um2400", "d27p11a__um24", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D27P11A, 'UM24', 0) [chaînage scène ROM]
  -- @label_3 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[7] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[7]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 0 -- $SCENARIO_MAIN_BIT_FLAG[7] = 0 (ROM)
  -- supervision_StationCommon(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_6 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Hidden Land.ogg", true) end)
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- @label_5 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  elseif true then -- default
  do local __sw = ((SV.SkyVars or {}).GROUND_GETOUT or -1) -- switch($GROUND_GETOUT) [GameVar GROUND_GETOUT: sortie précédente]
  if __sw == 11 then
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_9 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  elseif __sw == 26 then
  SkySceneKit.play_scene("d27p11a__um2500", "d27p11a__um25", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D27P11A, 'UM25', 0) [chaînage scène ROM]
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- back_SetGround(LEVEL_D27P11A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
