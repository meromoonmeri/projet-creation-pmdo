-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a09a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('acting_M01A09A') [neutre/état moteur]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Color Effect Test will be conducted.", french="The Color Effect Test will be conducted.", german="The Color Effect Test will be conducted.", italian="The Color Effect Test will be conducted.", spanish="The Color Effect Test will be conducted."})
  -- message_Close
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:WaitFrames(320)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(0) -- screen_FlushIn
  -- screen2_FlushOut [sub déjà caché]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- screen2_FlushIn(0, 30, 2, 255, 0) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(0) -- screen_FlushIn
  SkySubScreen.Hide(0) -- screen2_FlushOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- screen2_FlushIn(0, 30, 4, 0, 255) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:WaitFrames(60)
  GAME:FadeIn(0) -- screen_FlushIn
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Test has completed.", french="The Test has completed.", german="The Test has completed.", italian="The Test has completed.", spanish="The Test has completed."})
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- supervision_RemoveActing(-2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
