-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P21A/m25a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- GAP: BGM BGM_TEMPORAL_SPIRE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to go on?", french="[CN]Voulez-vous continuer?", german="[CN]Möchtest du weitermachen?", italian="[CN]Vuoi proseguire?", spanish="[CN]¿Quieres continuar?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  GROUND:MoveToPosition(hero, 228, 20, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 228, 20, false, 2)
  GAME:WaitFrames(20)
  if (SkyProg.cmp(26, 5) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [26, 5]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(42, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(26, 5) -- $SCENARIO_MAIN = scn[26,5] (ROM)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
