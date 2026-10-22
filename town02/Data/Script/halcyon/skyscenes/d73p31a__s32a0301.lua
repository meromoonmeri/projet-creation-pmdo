-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P31A/s32a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Return to the\n[CN][CS:P]Shaymin Village[CR]?", french="[CN]Retourner au\n[CN][CS:P]Village Shaymin[CR]?", german="[CN]Nach\n[CN][CS:P]Shaymin-Dorf[CR] zurückkehren?", italian="[CN]Vuoi tornare\n[CN]al [CS:P]Villaggio Shaymin[CR]?", spanish="[CN]¿Quieres volver a\n[CN][CS:P]Aldea Shaymin[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  -- switch(message_Menu(MENU_DUNGEON_EXPLORATION_RESULTS)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D73P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- message_Close
  end
  end
end
