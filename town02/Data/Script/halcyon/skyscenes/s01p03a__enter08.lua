-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P03A/enter08.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]↑ Rescue Assistance\n[CN]Welcome to [CS:P]Pelipper Island[CR]!\n[CN]↓ Exit", french="[CN]↑ Informations Sauvetage\n[CN]Bienvenue sur l'[CS:P]Ile Bekipan[CR]!\n[CN]↓ Sortie", german="[CN]↑ Anmeldeschalter\n[CN]Willkommen auf der [CS:P]Pelipper-Insel[CR]!\n[CN]↓ Ausgang", italian="[CN]↑ Servizio Soccorso\n[CN]Benvenuti all'[CS:P]Isola Pelipper[CR]!\n[CN]↓ Uscita", spanish="[CN]¡Bienvenidos a la [CS:P]Isla Pelipper[CR]!\n[CN]↑ Rescate\n[CN]↓ Salir"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
