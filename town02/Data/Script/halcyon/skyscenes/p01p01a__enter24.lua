-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/enter24.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]↑ [CS:N]Wigglytuff[CR]'s Guild\n[CN]← Treasure Town                Exploration →\n[CN]↓ Beach", french="[CN]↑ Guilde de [CS:N]Grodoudou[CR]\n[CN]← Bourg-Trésor                Exploration →\n[CN]↓ Plage", german="[CN]↑ [CS:N]Knuddeluff-Gilde[CR]\n[CN]← Schatzstadt                      Erkundung →\n[CN]↓ Strand", italian="[CN]↑ Gilda di [CS:N]Wigglytuff[CR]\n[CN]← Borgo Tesoro                 Esplorazione →\n[CN]↓ Spiaggia", spanish="[CN]↑ [CS:N]Pokégremio de Exploradores[CR]\n[CN]← Aldea Tesoro                Territorios →\n[CN]↓ Playa"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
