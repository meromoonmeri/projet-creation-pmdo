-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P27A/enter01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to go on?", french="[CN]Voulez-vous continuer?", german="[CN]Möchtest du weitergehen?", italian="[CN]Vuoi proseguire?", spanish="[CN]¿Quieres continuar?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 30 then
  -- main_EnterDungeon(18, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 35 then
  -- main_EnterDungeon(22, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 48 then
  -- main_EnterDungeon(30, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 56 then
  -- main_EnterDungeon(36, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 60 then
  -- main_EnterDungeon(39, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 68 then
  -- main_EnterDungeon(42, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 90 then
  -- main_EnterDungeon(52, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 177 then
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(48, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 98 then
  -- main_EnterDungeon(65, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 102 then
  -- main_EnterDungeon(68, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 77 then
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(54, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 78 then
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(56, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 79 then
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(58, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 157 then
  if (SkyProg.cmp(29, 13) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 13]
  -- @label_25 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(112, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(29, 13) -- $SCENARIO_MAIN = scn[29,13] (ROM)
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 158 then
  if (SkyProg.cmp(29, 15) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 15]
  -- @label_26 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(113, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(29, 15) -- $SCENARIO_MAIN = scn[29,15] (ROM)
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 159 then
  if (SkyProg.cmp(29, 17) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 17]
  -- @label_27 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(114, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(29, 17) -- $SCENARIO_MAIN = scn[29,17] (ROM)
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 160 then
  if (SkyProg.cmp(29, 19) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 19]
  -- @label_28 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(115, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(29, 19) -- $SCENARIO_MAIN = scn[29,19] (ROM)
  -- jump @label_28 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 161 then
  if (SkyProg.cmp(29, 21) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 21]
  -- @label_29 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(116, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(29, 21) -- $SCENARIO_MAIN = scn[29,21] (ROM)
  -- jump @label_29 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 162 then
  if (SkyProg.cmp(29, 23) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 23]
  -- @label_30 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(117, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(29, 23) -- $SCENARIO_MAIN = scn[29,23] (ROM)
  -- jump @label_30 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 163 then
  if (SkyProg.cmp(29, 25) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 25]
  -- @label_31 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(118, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(29, 25) -- $SCENARIO_MAIN = scn[29,25] (ROM)
  -- jump @label_31 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 164 then
  if (SkyProg.cmp(29, 27) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 27]
  -- @label_32 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[48] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[48]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[49] = 1 -- $SCENARIO_MAIN_BIT_FLAG[49] = 1 (ROM)
  -- @label_34 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(119, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- jump @label_34 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  SkyProg.set(29, 27) -- $SCENARIO_MAIN = scn[29,27] (ROM)
  -- jump @label_32 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 165 then
  if (SkyProg.cmp(29, 29) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 29]
  -- @label_35 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(120, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(29, 29) -- $SCENARIO_MAIN = scn[29,29] (ROM)
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- main_EnterDungeon(15, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  end
end
