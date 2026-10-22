-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V37P02A/s31a3702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V37P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(128, 284, 60, false) end) -- performer/caméra
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- supervision_SpecialActing(16, 20, 120) [cadrage NDS]
  -- supervision2_SpecialActing(16, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- GAP: se_Play(11017) — id SE NDS sans portage PMDO identifié
  -- screen2_FadeIn(0, 60) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(60)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker("Breloom", true, "breloom", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_KINOGASSA) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" W-wow...", french=" O-ouah...", german=" B-boah...", italian=" W-Wow...", spanish=" Jo... qué fuerte..."})
  -- message_Close
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- supervision2_SpecialActing(3, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
