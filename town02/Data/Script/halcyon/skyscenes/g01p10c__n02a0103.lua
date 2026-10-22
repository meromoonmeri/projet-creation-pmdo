-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P10C/n02a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P10C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 264, 200, Direction.Down, "NPC_DOGOOMU")
  -- SetAnimation(44) [anim idle native]
  GAME:WaitFrames(10)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 176, 200, Direction.Down, "NPC_HEIGANI")
  -- SetAnimation(45) [anim idle native]
  GAME:WaitFrames(5)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 232, 232, Direction.Left, "NPC_BIPPA")
  -- SetAnimation(46) [anim idle native]
  -- GAP: se_Play(9217) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="GUGOOoooooOOoaaaaaaahhhh![K]\nGUGOOOOOOOooooooaaaaaaahhhhhh!", french="RRROnZZZZRONRONZZZZZZZZ![K]\nZZZZZZZZZZZZZZZZzzzzzzzzzzzzzzzzzzzzzzz!", german="GUGOOoooooOOoaaaaaaah![K]\nGUGOOOOOOOooooooaaaaaaah!", italian="ROROROOooooOOooOOnfffaaah![K]\nROROOOOOOooooooNNNfff! ZzzzzZZZZ!", spanish="¡Grooooooooooonf![K]\n¡Fiiiiiiiiiiiiiiiiiiiiiiiiiiiuuuuuuuuuuuuu!"})
  -- message_Close
  -- se_FadeOut(9217, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
