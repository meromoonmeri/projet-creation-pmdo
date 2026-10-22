-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D15P21A/enter12.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return\n[CN]to Treasure Town?", french="[CN]Voulez-vous retourner\n[CN]à Bourg-Trésor?", german="[CN]Möchtet ihr nach Schatzstadt\n[CN]zurückkehren?", italian="[CN]Vuoi tornare a Borgo Tesoro?", spanish="[CN]¿Quieres volver a\n[CN]Aldea Tesoro?"})
  -- @label_37 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- @label_27 [étiquette de flux ExplorerScript]
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.GROUND_START_MODE = 9 -- $GROUND_START_MODE = 9 (ROM)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 228 then
  -- @label_57 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- @label_58 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- supervision_ExecuteCommon(CORO_EVENT_N01_10YARARETA) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_59 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  if (SkyProg.cmp_side(43, 9) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 9]
  -- supervision_ExecuteCommon(CORO_EVENT_N04_23) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- supervision_ExecuteCommon(CORO_EVENT_N04_06) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  elseif __sw == 2 then
  -- jump @label_59 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_ExecuteCommon(CORO_GETOUT_REQUEST_DUNGEON) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_58 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[29] = 1 -- $SCENARIO_MAIN_BIT_FLAG[29] = 1 (ROM)
  -- jump @label_57 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif __sw == 1 then
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN][CS:P]Armaldo's Shelter[CR]?", french="[CN]Voulez-vous retourner\n[CN]à l'[CS:P]Abri d'Armaldo[CR]?", german="[CN]Möchtet ihr zur [CS:P]Zuflucht von Armaldo[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare al\n[CN][CS:P]Rifugio di Armaldo[CR]?", spanish="[CN]¿Quieres volver a la\n[CN][CS:P]Guarida de Armaldo[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.GROUND_START_MODE = 9 -- $GROUND_START_MODE = 9 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[29] = 1 -- $SCENARIO_MAIN_BIT_FLAG[29] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- supervision_ExecuteCommon(CORO_EVENT_N03_11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  elseif __sw == 4 then
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(1)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 119 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN][CS:P]Temporal Tower's entrance[CR]?", french="[CN]Voulez-vous retourner à [CS:P]l'entrée\n[CN]de la Tour du Temps[CR]?", german="[CN]Möchtet ihr zum [CS:P]Zeitturmeingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'ingresso della\n[CN][CS:P]Torre del Tempo[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]de la [CS:P]Torre del Tiempo[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- supervision_ExecuteCommon(CORO_EVENT_N08_16) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  elseif __sw == 123 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN][CS:P]Dark Ice Mountain's entrance[CR]?", french="[CN]Voulez-vous retourner\n[CN]à l'[CS:P]entrée de la Montagne Sombre Gel[CR]?", german="[CN]Möchtet ihr zum [CS:P]Dunkeleisbergeingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'ingresso del\n[CN][CS:P]Ghiacciaio Tenebroso[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]del [CS:P]Iceberg Oscuro[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  if (SkyProg.cmp_side(48, 4) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 4]
  -- supervision_ExecuteCommon(CORO_EVENT_N09_07) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- supervision_ExecuteCommon(CORO_EVENT_N09_01) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  elseif __sw == 131 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN][CS:P]Vast Ice Mountain's entrance[CR]?", french="[CN]Voulez-vous retourner\n[CN]à l'[CS:P]entrée de la Montagne Glacier[CR]?", german="[CN]Möchtet ihr zum [CS:P]Rieseneisbergeingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'ingresso\n[CN]dell'[CS:P]Altopiano Ghiacciato[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]del [CS:P]Gran Iceberg[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  if (SkyProg.cmp_side(48, 9) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 9]
  -- supervision_ExecuteCommon(CORO_EVENT_N09_20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- supervision_ExecuteCommon(CORO_EVENT_N09_14) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  elseif true then -- default
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN][CS:P]Barren Valley's entrance[CR]?", french="[CN]Voulez-vous retourner\n[CN]à l'[CS:P]entrée de la Vallée Stérile[CR]?", german="[CN]Möchtest du zum [CS:P]Kargtaleingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'ingresso della\n[CN][CS:P]Valle Desolata[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]del [CS:P]Valle Desolado[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  if (SkyProg.cmp_side(47, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [47, 3]
  -- supervision_ExecuteCommon(CORO_EVENT_N08_09) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- supervision_ExecuteCommon(CORO_EVENT_N08_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  end
  end
  elseif __sw == 3 then
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 143 then
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN][CS:P]Illusion Stone Chamber[CR]?", french="[CN]Voulez-vous retourner\n[CN]au [CS:P]Passage du Mur Mirage[CR]?", german="[CN]Möchtet ihr zur [CS:P]Illusionssteinkammer[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare alla\n[CN][CS:P]Sala dell'Inganno[CR]?", spanish="[CN]¿Quieres volver a la\n[CN][CS:P]Cámara Espejismo[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.GROUND_START_MODE = 9 -- $GROUND_START_MODE = 9 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[29] = 1 -- $SCENARIO_MAIN_BIT_FLAG[29] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  if (SkyProg.cmp_side(47, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [47, 3]
  -- supervision_ExecuteCommon(CORO_EVENT_N06_37) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- supervision_ExecuteCommon(CORO_EVENT_N06_29) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  elseif true then -- default
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN][CS:P]Boulder Quarry's entrance[CR]?", french="[CN]Voulez-vous retourner\n[CN]à l'[CS:P]entrée de la Carrière Rocher[CR]?", german="[CN]Möchtet ihr zum [CS:P]Geröllbrucheingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'ingresso della\n[CN][CS:P]Cava Rocciosa[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]del [CS:P]Roquedal[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.GROUND_START_MODE = 9 -- $GROUND_START_MODE = 9 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[29] = 1 -- $SCENARIO_MAIN_BIT_FLAG[29] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  if (SkyProg.cmp_side(45, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [45, 7]
  -- supervision_ExecuteCommon(CORO_EVENT_N06_16) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- supervision_ExecuteCommon(CORO_EVENT_N06_09) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  end
  end
  elseif __sw == 2 then
  -- SetAnimation(2) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return\n[CN]to Treasure Town?", french="[CN]Voulez-vous retourner\n[CN]à Bourg-Trésor?", german="[CN]Möchtet ihr nach Schatzstadt\n[CN]zurückkehren?", italian="[CN]Vuoi tornare a Borgo Tesoro?", spanish="[CN]¿Quieres volver a\n[CN]Aldea Tesoro?"})
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 27 then
  if (SkyProg.cmp(12, 0) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [12, 0]
  -- @label_25 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp(29, 5) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 5]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return\n[CN]to Sharpedo Bluff?", french="[CN]Voulez-vous retourner\n[CN]à la Falaise Sharpedo?", german="[CN]Möchtet ihr zur Tohaido-Klippe\n[CN]zurückkehren?", italian="[CN]Vuoi tornare al Promontorio Sharpedo?", spanish="[CN]¿Quieres volver al\n[CN]Risco Sharpedo?"})
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 25 or __sw == 26 then
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return\n[CN]to Treasure Town?", french="[CN]Voulez-vous retourner\n[CN]à Bourg-Trésor?", german="[CN]Möchtet ihr nach Schatzstadt\n[CN]zurückkehren?", italian="[CN]Vuoi tornare a Borgo Tesoro?", spanish="[CN]¿Quieres volver a\n[CN]Aldea Tesoro?"})
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return\n[CN]to the guild?", french="[CN]Voulez-vous retourner\n[CN]à la Guilde?", german="[CN]Möchtet ihr zur Gilde\n[CN]zurückkehren?", italian="[CN]Vuoi tornare alla Gilda?", spanish="[CN]¿Quieres volver al\n[CN][CS:N]Pokégremio de Exploradores[CR]?"})
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  else
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN][CS:P]Steam Cave's entrance[CR]?", french="[CN]Voulez-vous retourner à [CS:P]l'entrée\n[CN]de la Grotte Etuve[CR]?", german="[CN]Möchtet ihr zum [CS:P]Dunsthöhleneingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'ingresso della\n[CN][CS:P]Grotta del Vapore[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]de la [CS:P]Cueva Vapor[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D09P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  elseif __sw == 48 then
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN]the [CS:P]Sealed Ruin's entrance[CR]?", french="[CN]Voulez-vous retourner à [CS:P]l'entrée\n[CN]de la Ruine Scellée[CR]?", german="[CN]Möchtet ihr zum [CS:P]Ruinenverlieseingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'ingresso delle\n[CN][CS:P]Rovine Inviolabili[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]de las [CS:P]Ruinas Herméticas[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D20P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  elseif __sw == 56 then
  if (SkyProg.cmp(25, 0) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [25, 0]
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN][CS:P]Brine Cave's entrance[CR]?", french="[CN]Voulez-vous retourner à [CS:P]l'entrée\n[CN]de la Caverne Saline[CR]?", german="[CN]Möchtet ihr zum [CS:P]Salzwasserhöhleneingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'ingresso della\n[CN][CS:P]Grotta Salmastra[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]de la [CS:P]Cueva Aguamar[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D25P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  elseif __sw == 60 then
  if (SkyProg.cmp(27, 0) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [27, 0]
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN]the [CS:P]Hidden Land's entrance[CR]?", french="[CN]Voulez-vous retourner à [CS:P]l'entrée\n[CN]des Terres Illusoires[CR]?", german="[CN]Möchtet ihr zum [CS:P]Verborgenes Land-Eingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'ingresso della\n[CN][CS:P]Terra Nascosta[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]de la [CS:P]Tierra Oculta[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D27P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  elseif __sw == 67 then
  if (SkyProg.cmp(27, 0) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [27, 0]
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN]the [CS:P]Hidden Land's entrance[CR]?", french="[CN]Voulez-vous retourner à [CS:P]l'entrée\n[CN]des Terres Illusoires[CR]?", german="[CN]Möchtet ihr zum [CS:P]Verborgenes Land-Eingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'Ingresso della\n[CN][CS:P]Terra Nascosta[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]de la [CS:P]Tierra Oculta[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- main_EnterGround(LEVEL_D27P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  elseif __sw == 68 then
  if (SkyProg.cmp(27, 0) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [27, 0]
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN][CS:P]Temporal Tower's entrance[CR]?", french="[CN]Voulez-vous retourner à [CS:P]l'entrée\n[CN]de la Tour du Temps[CR]?", german="[CN]Möchtet ihr zum [CS:P]Zeitturmeingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'ingresso della\n[CN][CS:P]Torre del Tempo[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]de la [CS:P]Torre del Tiempo[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D29P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  elseif __sw == 98 then
  if (SkyProg.cmp(29, 86) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 86]
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return to\n[CN][CS:P]Spacial Rift's entrance[CR]?", french="[CN]Voulez-vous retourner à [CS:P]l'entrée\n[CN]de la Faille Spatiale[CR]?", german="[CN]Möchtet ihr zum [CS:P]Raumspalteneingang[CR]\n[CN]zurückkehren?", italian="[CN]Vuoi tornare all'ingresso della\n[CN][CS:P]Valle Dimensionale[CR]?", spanish="[CN]¿Quieres volver a la entrada\n[CN]de la [CS:P]Grieta Espacial[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D38P12A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  elseif __sw == 228 then
  if (SkyProg.cmp(29, 5) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 5]
  -- @label_13 [étiquette de flux ExplorerScript]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to return\n[CN]to Treasure Town?", french="[CN]Voulez-vous retourner\n[CN]à Bourg-Trésor?", german="[CN]Möchtet ihr nach Schatzstadt\n[CN]zurückkehren?", italian="[CN]Vuoi tornare a Borgo Tesoro?", spanish="[CN]¿Quieres volver a\n[CN]Aldea Tesoro?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  else
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 74 then
  -- jump @label_13 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 156 then
  -- supervision_ExecuteCommon(CORO_EVENT_S31_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 157 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- supervision_ExecuteCommon(CORO_EVENT_S31_07) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 158 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- supervision_ExecuteCommon(CORO_EVENT_S31_10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 159 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- supervision_ExecuteCommon(CORO_EVENT_S31_13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 160 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- supervision_ExecuteCommon(CORO_EVENT_S31_16) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 161 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- supervision_ExecuteCommon(CORO_EVENT_S31_38) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 162 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- supervision_ExecuteCommon(CORO_EVENT_S31_22) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 163 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- supervision_ExecuteCommon(CORO_EVENT_S31_25) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 164 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- supervision_ExecuteCommon(CORO_EVENT_S31_29) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 165 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- supervision_ExecuteCommon(CORO_EVENT_S31_32) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 166 then
  -- supervision_ExecuteCommon(CORO_EVENT_S32_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
end
