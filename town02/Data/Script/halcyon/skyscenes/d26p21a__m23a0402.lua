-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D26P21A/m23a0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_LOWER_BRINE_CAVE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to go on?", french="[CN]Continuer?", german="[CN]Möchtest du weitermachen?", italian="[CN]Vuoi proseguire?", spanish="[CN]¿Quieres seguir adelante?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  GROUND:MoveToPosition(hero, 228, 28, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 228, 28, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(36, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
end
