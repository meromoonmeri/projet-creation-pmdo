-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V17P03A/m16a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_V17P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(472, 156, 60, false) end) -- performer/caméra
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(240), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(2.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_SetWaitMode(180, 90) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_YONOWAARU) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="No winds blow...[K] The day never\ncomes...", french="Le vent ne souffle plus...[K]\nPas plus que le jour ne se lève...", german="Nun, es weht kein Wind...[K] und es\nwird nie wieder Tag...", italian="Il vento non soffia più...[K] Il\ngiorno non arriva mai...", spanish="El viento no soplaría...[K]\nEl sol jamás saldría..."})
  -- message_KeyWait
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Neither spring nor summer ever\ncomes...[K] It's a world of unrelenting darkness...", french="Le printemps et l'été cessent\nd'exister...[K] Et une ombre éternelle s'abat\nsur le monde...", german="Es wird weder Frühling noch\nSommer...[K] Es ist eine Welt von niemals\nendender Dunkelheit...", italian="La primavera e l'estate non\ngiungono mai...[K] Il mondo sprofonda\nnell'oscurità eterna...", spanish="La primavera y el verano jamás\nllegarían...[K] Sería un mundo de perpetua\noscuridad."})
  -- message_KeyWait
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It would be no exaggeration to\ncall it the complete ruin of the world.", french="On peut, sans exagération\naucune, parler de fin du monde.", german="Man könnte es ohne zu\nübertreiben als den endgültigen Untergang\nder Welt bezeichnen.", italian="Non potrei definirla in altro\nmodo se non come la completa rovina del\nmondo.", spanish="No sería exagerado decir que\nel mundo acabaría en ruinas."})
  -- message_Close
  GAME:FadeOut(false, 30)
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
end
