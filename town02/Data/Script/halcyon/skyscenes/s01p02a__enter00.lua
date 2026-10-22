-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P02A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('ENTER_S01P02A') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:WaitFrames(4) -- WaitMoveCamera (join caméra)
  -- SetFunctionAttribute(2) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- supervision_RemoveActing(-2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  -- screen2_FadeIn(1, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  elseif __sw == 2 then
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  -- screen2_FadeIn(1, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  elseif true then -- default
  -- back_SetGround(LEVEL_S01P02A) [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[31] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[31]
  do local __sw = ((SV.SkyVars or {}).GROUND_START_MODE or 0) -- switch($GROUND_START_MODE) [GameVar GROUND_START_MODE]
  if __sw == 10 or __sw == 11 then
  -- debug_Print('RESCUE_DEAD') [neutre/état moteur]
  SkySubScreen.Hide(0) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.play_scene("s01p02a__dead00", "s01p02a__dead", hero, partner) -- supervision_ExecuteActing(LEVEL_S01P02A, 'DEAD', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 9 then
  -- debug_Print('RESCUE_RETURN') [neutre/état moteur]
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.play_scene("s01p02a__return00", "s01p02a__return", hero, partner) -- supervision_ExecuteActing(LEVEL_S01P02A, 'RETURN', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 8 then
  -- debug_Print('RESCUE_CONQUEST') [neutre/état moteur]
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.play_scene("s01p02a__conquest00", "s01p02a__conquest", hero, partner) -- supervision_ExecuteActing(LEVEL_S01P02A, 'CONQUEST', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  -- GAP: BGM BGM_PELIPPER_ISLAND non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[40] = 0 -- $SCENARIO_MAIN_BIT_FLAG[40] = 0 (ROM)
  -- @label_6 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:FadeOut(false,  0)
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  else
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[31] = 1 -- $SCENARIO_MAIN_BIT_FLAG[31] = 1 (ROM)
  -- debug_Print('RESCUE_1ST') [neutre/état moteur]
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.play_scene("s01p02a__first00", "s01p02a__first", hero, partner) -- supervision_ExecuteActing(LEVEL_S01P02A, 'FIRST', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
end
