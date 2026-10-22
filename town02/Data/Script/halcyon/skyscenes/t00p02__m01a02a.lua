-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P02/m01a02a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('acting_M01A02A') [neutre/état moteur]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An Acting Test will be conducted.", french="An Acting Test will be conducted.", german="An Acting Test will be conducted.", italian="An Acting Test will be conducted.", spanish="An Acting Test will be conducted."})
  -- message_Close
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(344, 236, 1, false) end)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(120)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Event Test is finished.", french="The Event Test is finished.", german="The Event Test is finished.", italian="The Event Test is finished.", spanish="The Event Test is finished."})
  -- message_Close
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
