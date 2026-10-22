-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/n03a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep...[K] Just like this.", french=" Voui...[K] Comme ça.", german=" Ja...[K] Einfach so.", italian=" Sì...[K] Proprio così.", spanish=" Sí...[K] Así, sin más."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I had so much fun today...[K]\nTime to head home. ♪", french="Je me suis amusé comme un fou\naujourd'hui...[K] Il est l'heure de rentrer. ♪", german="Das hat heute so viel Spaß\ngemacht...[K] Zeit, heimzukehren. ♪", italian="Mi sono divertito tanto oggi...[K]\nÈ ora di andare a casa. ♪", spanish="Hoy me lo he pasado bomba...[K]\nPero ahora toca volver a casa. ♪"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
