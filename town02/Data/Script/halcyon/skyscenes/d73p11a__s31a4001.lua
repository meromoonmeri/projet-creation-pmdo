-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/s31a4001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GAME:FadeOut(false, 30)
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  GROUND:TeleportTo(hero, 348, 164, Direction.Down)
  GROUND:TeleportTo(partner, 316, 164, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:FadeIn(30)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 328, 136, Direction.Down, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[hero]! [partner]!\nYou rang?", french="[hero]! [partner]!\nVous avez fait sonner la cloche?", german="[hero]! [partner]!\nIhr habt geläutet?", italian="[hero]! [partner]!\nAvete suonato?", spanish="¡[hero]! ¡[partner]!\n¿Habéis tocado la campana?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_SetGround(LEVEL_G01P03A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_D73P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
