-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/n01a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] It's too tough...", french=" Snif...[K] C'est trop balaise...", german="Schnief...[K]\nDas ist härter als erwartet...", italian=" Sniff...[K] È così difficile...", spanish=" Buaa...[K] Es demasiado difícil..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" That's it for today...", french=" Suffit pour aujourd'hui...", german=" Das war es wohl für heute...", italian=" Per oggi non posso fare altro...", spanish=" Ya es suficiente por hoy..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
