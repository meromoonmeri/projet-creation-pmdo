-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/s31a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Return to\n[CN]Treasure Town?", french="[CN]Retourner à\n[CN]Bourg-Trésor?", german="[CN]Nach Schatzstadt\n[CN]zurückkehren?", italian="[CN]Vuoi tornare\n[CN]a Borgo Tesoro?", spanish="[CN]¿Quieres volver a\n[CN][CS:P]Aldea Tesoro[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  if (SkyProg.cmp(29, 11) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 11]
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(29, 11) -- $SCENARIO_MAIN = scn[29,11] (ROM)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
