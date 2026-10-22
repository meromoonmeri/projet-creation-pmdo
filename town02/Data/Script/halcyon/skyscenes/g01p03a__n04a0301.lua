-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/n04a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Which outlaw I'm looking for is\nalready decided!", french="Je sais déjà quel hors-la-loi\nje recherche!", german="Nach welchem Ganoven ich\nAusschau halte, ist bereits entschieden!", italian="È già stato deciso chi sarà\nil mio ricercato!", spanish="¡Ya está decidido qué malhechor\nestoy buscando!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It's [CS:N]Haunter[CR]!", french=" C'est [CS:N]Spectrum[CR]!", german=" Und zwar [CS:N]Alpollo[CR]!", italian=" È [CS:N]Haunter[CR]!", spanish=" Es [CS:N]Haunter[CR]."})
  -- message_Close
end
