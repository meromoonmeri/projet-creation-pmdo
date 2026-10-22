-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P21A/m24a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 232, 168, Direction.Down, "NPC_JUPUTORU")
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, hero, 4) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to go on?", french="[CN]Voulez-vous continuer?", german="[CN]Möchtest du weitermachen?", italian="[CN]Vuoi proseguire?", spanish="[CN]¿Quieres continuar?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 228, 20, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 228, 20, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 228, 20, false, 2)
  GAME:WaitFrames(20)
  if (SkyProg.cmp(25, 3) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [25, 3]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- main_EnterDungeon(39, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  SkyProg.set(25, 3) -- $SCENARIO_MAIN = scn[25,3] (ROM)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
