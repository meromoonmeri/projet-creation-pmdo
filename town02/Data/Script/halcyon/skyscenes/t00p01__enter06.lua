-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/enter06.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_11 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Which function will you access?", french="Which function will you access?", german="Which function will you access?", italian="A che funzione vuoi accedere?", spanish="Which function will you access?"})
  do local __choice = SkySceneKit.ask({{english="Job Bulletin Board", french="Job Bulletin Board", german="Job Bulletin Board", italian="Job Bulletin Board", spanish="Job Bulletin Board"}, {english="Outlaw Notice Board", french="Outlaw Notice Board", german="Outlaw Notice Board", italian="Outlaw Notice Board", spanish="Outlaw Notice Board"}, {english="Exploration Results", french="Exploration Results", german="Exploration Results", italian="Exploration Results", spanish="Exploration Results"}, {english="Team Controls", french="Team Controls", german="Team Controls", italian="Team Controls", spanish="Team Controls"}, {english="Status Update", french="Status Update", german="Status Update", italian="Status Update", spanish="Status Update"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  -- switch(message_Menu(MENU_JOB_BOARD)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 2 then
  -- message_Close
  -- switch(message_Menu(MENU_OUTLAW_BOARD)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 3 then
  -- message_Close
  -- switch(ProcessSpecial(55, 5, 20)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(message_Menu(MENU_DUNGEON_EXPLORATION_RESULTS)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 4 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Which function will you access?", french="Which function will you access?", german="Which function will you access?", italian="Which function will you access?", spanish="Which function will you access?"})
  do local __choice = SkySceneKit.ask({{english="Initialize Team", french="Initialize Team", german="Initialize Team", italian="Initialize Team", spanish="Initialize Team"}, {english="Team Returns from Map", french="Team Returns from Map", german="Team Returns from Map", italian="Team Returns from Map", spanish="Team Returns from Map"}, {english="Team Defeated in Map", french="Team Defeated in Map", german="Team Defeated in Map", italian="Team Defeated in Map", spanish="Team Defeated in Map"}, {english="Inspect Team", french="Inspect Team", german="Inspect Team", italian="Inspect Team", spanish="Inspect Team"}, {english="Default Team Setup 1", french="Default Team Setup 1", german="Default Team Setup 1", italian="Default Team Setup 1", spanish="Default Team Setup 1"}, {english="Default Team Setup 2", french="Default Team Setup 2", german="Default Team Setup 2", italian="Default Team Setup 2", spanish="Default Team Setup 2"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- message_Close
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 2 then
  -- message_Close
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 3 then
  -- message_Close
  -- switch(message_Menu(MENU_DUNGEON_TEAM_DEFEATED_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 4 then
  -- message_Close
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Hero & Partner Only", french="Hero & Partner Only", german="Hero & Partner Only", italian="Hero & Partner Only", spanish="Hero & Partner Only"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTN) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Partner & Hero Only", french="Partner & Hero Only", german="Partner & Hero Only", italian="Partner & Hero Only", spanish="Partner & Hero Only"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_CONTAINS_PARTNER_AND_HERO"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_CONTA) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_CONTAINS_PARTNER_AND_HERO): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Hero & Partner Present", french="Hero & Partner Present", german="Hero & Partner Present", italian="Hero & Partner Present", spanish="Hero & Partner Present"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_SOLO"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_SOLO,) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_SOLO): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Solo Player Character", french="Solo Player Character", german="Solo Player Character", italian="Solo Player Character", spanish="Solo Player Character"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Other Teams", french="Other Teams", german="Other Teams", italian="Other Teams", spanish="Other Teams"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  end
  end
  end
  end
  end
  end
  elseif __choice == 5 then
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 6 then
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_ONLY, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 5 then
  -- switch(ProcessSpecial(PROCESS_SPECIAL_STATUS_UPDATE, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
end
