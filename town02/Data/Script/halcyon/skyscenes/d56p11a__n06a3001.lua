-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P11A/n06a3001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 288, 216, Direction.Left, "NPC_SAANAITO")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 224, 216, Direction.Right, "NPC_CHAAREMU")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Continue through the wall?", french="[CN]Voulez-vous traverser le mur?", german="[CN]Durch die Wand gehen?", italian="[CN]Vuoi attraversare la parete?", spanish="[CN]¿Quieres atravesar el muro?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  -- SetPositionLives(9) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  GROUND:MoveToPosition(hero, 252, 168, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 252, 148, false, 2)
  -- supervision_Acting(4) [neutre/état moteur]
  -- GAP: se_Play(10253) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_chaaremu, 252, 188, false, 2)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D56P11A3_536) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_chaaremu, 252, 156, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 252, 188, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_chaaremu, 252, 148, false, 2)
  -- supervision_Acting(5) [neutre/état moteur]
  -- GAP: se_Play(10253) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:MoveToPosition(npc_npc_saanaito, 252, 148, false, 2)
  -- supervision_Acting(6) [neutre/état moteur]
  -- GAP: se_Play(10253) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D56P11A3_537) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D56P11A3_538) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(155, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  SkySceneKit.cleanup_npcs()
end
