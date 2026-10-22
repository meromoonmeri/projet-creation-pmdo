-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m03d0313.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]H-h-h...HELP!", french="[CN]A... A L'AIDE!", german="[CN]H-h-h...HILFE!", italian="[CN]A-A-Aiuto...!", spanish="[CN]¡So... socorro!"})
  -- message_Close
  -- GAP: se_Play(5139) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOut
end
