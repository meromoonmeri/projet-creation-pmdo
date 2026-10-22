-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V37P03A/s31a3704.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V37P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(128, 556, 60, false) end) -- performer/caméra
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V37P03A1_405) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Breloom", true, "breloom", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_KINOGASSA) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Wow!\nA-amazing!", french="Waouh!\nIn... incroyable!", german="Wow!\nU-unglaublich!", italian="Wow!\nM-Magnifico!", spanish=" ¡Córcholis! Es... increíble..."})
  -- message_Close
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
