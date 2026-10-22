-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/n04a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I don't have time to\ncheck the Job Bulletin Board!", french="Pas le temps de regarder le\nTableau des Missions!", german="Ich habe keine Zeit, mir das\nJob-Infobrett anzusehen!", italian="Non ho tempo per controllare\nla Bacheca delle missioni!", spanish="¡No estoy como para mirar\nel Tablón de Anuncios!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I have to hurry and get ready\nto catch [CS:N]Haunter[CR]!", french="Je dois vite me préparer pour\npartir à la recherche de [CS:N]Spectrum[CR]!", german="Ich muss mich beeilen und\nfertigwerden, um [CS:N]Alpollo[CR] zu fangen!", italian="Devo prepararmi e partire subito\nper andare a catturare [CS:N]Haunter[CR]!", spanish="¡Tengo que darme prisa y\nprepararme para capturar a [CS:N]Haunter[CR]!"})
  -- message_Close
end
