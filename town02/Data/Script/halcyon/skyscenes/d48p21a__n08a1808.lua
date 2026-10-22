-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D48P21A/n08a1808.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- GAP: BGM BGM_TEMPORAL_SPIRE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to go on?", french="[CN]Voulez-vous continuer?", german="[CN]Fortfahren?", italian="[CN]Vuoi proseguire?", spanish="[CN]¿Quieres continuar?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  if (SkyProg.cmp_side(47, 8) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [47, 8]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(138, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SV.SkyScenarioSide = {main=47, sub=8} -- $SCENARIO_SIDE = scn[47,8] (ROM)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
