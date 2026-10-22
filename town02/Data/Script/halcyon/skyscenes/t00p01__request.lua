-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/request.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('acting_REQUEST') [neutre/état moteur]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_JOB_REWARD_TYPE"] or 0) -- switch(message_Menu(MENU_JOB_REWARD_TYPE)) [message_Menu(MENU_JOB_REWARD_TYPE): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 1 or __sw == 2 or __sw == 3 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_T00P01) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(512, 324, 1, false) end)
  GAME:FadeIn(30)
  -- switch(message_Menu(MENU_JOB_REWARD_TEXT)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:FadeOut(false, 30)
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  end
  end
end
