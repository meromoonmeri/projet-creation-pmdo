-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/s22p0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Yes, that's exactly it!", french="[CN]Oui, c'est exactement cela!", german="[CN]Ja, genau das ist es!", italian="[CN]Sì, è proprio così!", spanish="[CN]¡Exacto!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Never abandon hope!", french="[CN]Gardez espoir!", german="[CN]Niemals die Hoffnung aufgeben!", italian="[CN]Non bisogna mai disperare!", spanish="[CN]¡Nunca hay que perder la esperanza!"})
  -- message_Close
  -- GAP: se_Play(6672) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(3)
  GAME:FadeOut(false, 0)
end
