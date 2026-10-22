-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P02A/enter08.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Welcome!\n[CN][CS:N]Wigglytuff[CR]'s Guild!", french="[CN]Bienvenue!\n[CN]Voici la Guilde de [CS:N]Grodoudou[CR]!", german="[CN]Willkommen!\n[CN][CS:N]Knuddeluff-Gilde[CR]!", italian="[CN]Benvenuti!\n[CN]Gilda di [CS:N]Wigglytuff[CR]!", spanish="[CN]¡Disfrutad de vuestra estancia\n[CN]en el [CS:N]Pokégremio de Exploradores[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]No salespeople!\n[CN]No agents!\n[CN]No survey takers!", french="[CN]Démarcheurs, colporteurs et enquêteurs\n[CN]de tous poils, passez votre chemin!", german="[CN]Keine Anwälte!\n[CN]Keine Agenten!\n[CN]Keine Meinungsforscher!", italian="[CN]Vietato l'accesso a scocciatori, rappresentanti\n[CN]e venditori!", spanish="[CN]¡Vendedores no!\n[CN]¡Representantes no!\n[CN]¡Encuestadores no!"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
