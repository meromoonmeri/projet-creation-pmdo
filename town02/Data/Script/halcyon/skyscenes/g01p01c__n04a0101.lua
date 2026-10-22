-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01C/n04a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if true --[[BranchDebug: retail EU]] then -- if ROM: not debug
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyScenarioSide = {main=43, sub=1} -- $SCENARIO_SIDE = scn[43,1] (ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]One night at the guild...", french="[CN]Une nuit, à la Guilde...", german="[CN]Eines Nachts in der Gilde...", italian="[CN]Una notte, alla Gilda...", spanish="[CN]Una noche, en el [CS:N]Pokégremio[CR]..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- back_SetGround(LEVEL_G01P01C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_FIRE_CRACKLING_LOUDER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  GAME:WaitFrames(150)
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  else
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[M:D2][CS:C]Start from where?[CR]", french="[M:D2][CS:C]Start from where?[CR]", german="[M:D2][CS:C]Start from where?[CR]", italian="[M:D2][CS:C]Start from where?[CR]", spanish="[M:D2][CS:C]Start from where?[CR]"})
  do local __choice = SkySceneKit.ask({{english="[M:D2]Beginning", french="[M:D2]Beginning", german="[M:D2]Beginning", italian="[M:D2]Beginning", spanish="[M:D2]Beginning"}, {english="[M:D2]SectionA", french="[M:D2]SectionA", german="[M:D2]SectionA", italian="[M:D2]SectionA", spanish="[M:D2]SectionA"}, {english="[M:D2]SectionB", french="[M:D2]SectionB", german="[M:D2]SectionB", italian="[M:D2]SectionB", spanish="[M:D2]SectionB"}, {english="[M:D2]SectionC", french="[M:D2]SectionC", german="[M:D2]SectionC", italian="[M:D2]SectionC", spanish="[M:D2]SectionC"}, {english="[M:D2]SectionD", french="[M:D2]SectionD", german="[M:D2]SectionD", italian="[M:D2]SectionD", spanish="[M:D2]SectionD"}, {english="[M:D2]SpringCaveMidpoint", french="[M:D2]SpringCaveMidpoint", german="[M:D2]SpringCaveMidpoint", italian="[M:D2]SpringCaveMidpoint", spanish="[M:D2]SpringCaveMidpoint"}, {english="[M:D2]SpringCaveDepths2ndTry", french="[M:D2]SpringCaveDepths2ndTry", german="[M:D2]SpringCaveDepths2ndTry", italian="[M:D2]SpringCaveDepths2ndTry", spanish="[M:D2]SpringCaveDepths2ndTry"}, {english="[M:D2]SectionF", french="[M:D2]SectionF", german="[M:D2]SectionF", italian="[M:D2]SectionF", spanish="[M:D2]SectionF"}, {english="[M:D2]TALK-N04-01", french="[M:D2]TALK-N04-01", german="[M:D2]TALK-N04-01", italian="[M:D2]TALK-N04-01", spanish="[M:D2]TALK-N04-01"}, {english="[M:D2]TALK-N04-02", french="[M:D2]TALK-N04-02", german="[M:D2]TALK-N04-02", italian="[M:D2]TALK-N04-02", spanish="[M:D2]TALK-N04-02"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  SV.SkyScenarioSide = {main=43, sub=1} -- $SCENARIO_SIDE = scn[43,1] (ROM)
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 3 then
  -- message_Close
  SV.SkyScenarioSide = {main=43, sub=2} -- $SCENARIO_SIDE = scn[43,2] (ROM)
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 4 then
  -- message_Close
  SV.SkyScenarioSide = {main=43, sub=4} -- $SCENARIO_SIDE = scn[43,4] (ROM)
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 5 then
  -- message_Close
  SV.SkyScenarioSide = {main=43, sub=6} -- $SCENARIO_SIDE = scn[43,6] (ROM)
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 6 then
  -- message_Close
  SV.SkyScenarioSide = {main=43, sub=7} -- $SCENARIO_SIDE = scn[43,7] (ROM)
  -- main_EnterGround(LEVEL_D57P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 7 then
  -- message_Close
  SV.SkyScenarioSide = {main=43, sub=8} -- $SCENARIO_SIDE = scn[43,8] (ROM)
  -- main_EnterGround(LEVEL_D57P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 8 then
  -- message_Close
  SV.SkyScenarioSide = {main=43, sub=9} -- $SCENARIO_SIDE = scn[43,9] (ROM)
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 9 then
  SV.SkyScenarioSide = {main=43, sub=1} -- $SCENARIO_SIDE = scn[43,1] (ROM)
  -- @label_11 [étiquette de flux ExplorerScript]
  -- message_Close
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 10 then
  SV.SkyScenarioSide = {main=43, sub=2} -- $SCENARIO_SIDE = scn[43,2] (ROM)
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
