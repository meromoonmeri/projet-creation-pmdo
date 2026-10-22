-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P03A/s22p1106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- back_SetGround(LEVEL_V26P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Darkrai", true, "darkrai", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_DAAKURAI) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I set my sights on [CS:N]Dialga[CR]'s\n[CS:P]Temporal Tower[CR] because of its tie to time...", french="J'ai commencé par jeter mon\ndévolu sur la [CS:P]Tour du Temps[CR] de [CS:N]Dialga[CR],\ncar elle est étroitement liée au temps...", german="Deshalb habe ich ein Auge auf\nden [CS:P]Zeitturm[CR] von [CS:N]Dialga[CR] geworfen. Wegen\nseiner Bedeutung für die Zeit...", italian="Come obiettivo avevo scelto la\n[CS:P]Torre del Tempo[CR] di [CS:N]Dialga[CR] a causa\ndel suo legame con il tempo.", spanish="Primero, centré mis esfuerzos\nen la [CS:P]Torre del Tiempo[CR] de [CS:N]Dialga[CR] por su\nvínculo con el tiempo..."})
  -- message_Close
  GAME:FadeOut(false, 30)
end
