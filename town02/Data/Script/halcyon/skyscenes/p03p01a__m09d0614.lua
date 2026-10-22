-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P01A/m09d0614.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(5)
  GAME:WaitFrames(10)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I see!", french="[CN]Je vois!", german="[CN]Ich verstehe!", italian="[CN]Ho capito!", spanish="[CN]¡Ya lo veo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Place the Drought Stone\n[CN]in Groudon's heart.", french="[CN]Place la Pierre-Sèche\n[CN]dans le cœur de Groudon.", german="[CN]Setze den Melioriestein\n[CN]in das Herz von Groudon.", italian="[CN]Metti la Pietra del Sole\n[CN]nel cuore di Groudon.", spanish="[CN]Coloca la Piedra Sequía\n[CN]en el corazón de Groudon."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]That lifts the fog!", french="[CN]Le brouillard se lève!", german="[CN]Das löst den Nebel auf!", italian="[CN]Così la nebbia si alzerà!", spanish="[CN]¡Eso disipará la niebla!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Very well done!\n[CN]Good job, partner!", french="[CN]Très bien joué!\n[CN]Beau travail, partenaire!", german="[CN]Sehr gut gemacht!\n[CN]Gute Arbeit, Partner!", italian="[CN]Ben fatto!\n[CN]Buon lavoro, partner!", spanish="[CN]¡Muy bien hecho!\n[CN]¡Buen trabajo, camarada!"})
  -- message_Close
  -- GAP: se_Play(5139) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOut
end
