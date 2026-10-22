-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P11A/m26a0806.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- switch($LANGUAGE_TYPE): case unique compilée (textes 5 langues résolus par le kit au runtime)
  -- @label_0 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_V26P11A2) [neutre/état moteur]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[9] = 1 -- $PERFORMANCE_PROGRESS_LIST[9] = 1 (ROM)
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  GAME:FadeIn(120)
  GAME:WaitFrames(360)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="", french="", german="", italian="", spanish=""})
  -- message_Close
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(90)
  SkyProg.set(29, 0) -- $SCENARIO_MAIN = scn[29,0] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[1] = 3 -- dungeon_mode(1) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[3] = 3 -- dungeon_mode(3) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[4] = 3 -- dungeon_mode(4) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[6] = 3 -- dungeon_mode(6) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[7] = 3 -- dungeon_mode(7) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[8] = 3 -- dungeon_mode(8) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[10] = 3 -- dungeon_mode(10) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[12] = 3 -- dungeon_mode(12) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[14] = 3 -- dungeon_mode(14) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[17] = 3 -- dungeon_mode(17) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[20] = 3 -- dungeon_mode(20) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[21] = 3 -- dungeon_mode(21) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[24] = 3 -- dungeon_mode(24) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[25] = 3 -- dungeon_mode(25) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[34] = 3 -- dungeon_mode(34) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[35] = 3 -- dungeon_mode(35) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[38] = 2 -- dungeon_mode(38) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[41] = 2 -- dungeon_mode(41) = DMODE_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.GROUND_PLACE = 307 -- $GROUND_PLACE = 307 (ROM)
  -- switch(message_Menu(MENU_SAVE_MENU)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(ProcessSpecial(24, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
end
