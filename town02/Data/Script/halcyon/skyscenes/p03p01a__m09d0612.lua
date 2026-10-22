-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P01A/m09d0612.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(5)
  GAME:WaitFrames(10)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]That's it!", french="[CN]C'est ça!", german="[CN]Das ist es!", italian="[CN]Eccolo!", spanish="[CN]¡Eso es!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It's here!", french="[CN]C'est ici!", german="[CN]Es ist hier!", italian="[CN]È qui!", spanish="[CN]¡Aquí está!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It's here!", french="[CN]C'est là!", german="[CN]Es ist hier!", italian="[CN]È qui!", spanish="[CN]¡Aquí está!"})
  -- message_Close
  -- GAP: se_Play(5139) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOut
end
