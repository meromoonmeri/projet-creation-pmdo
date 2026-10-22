-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/enter19.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]All Your Item Needs Fulfilled!\n[CN]← [CS:K]Kangaskhan[CR] Storage    [CS:K]Kecleon[CR] Market", french="[CN]← Tous les objets dont vous avez besoin!\n[CN][CS:K]Réserve Kangourex[CR]    [CS:K]Marché Kecleon[CR]", german="[CN]← Für all deine Item-Bedürfnisse!\n[CN][CS:K]Kangama-Lager[CR]    [CS:K]Kecleon-Markt[CR]", italian="[CN]← Da questa parte! Tutto per gli strumenti!\n[CN]Deposito [CS:K]Kangaskhan[CR]          [CS:K]Kecleon[CR] Market", spanish="[CN]¡Todo lo que necesitas en cuestión de objetos!\n[CN]← [CS:K]Consigna Kangaskhan[CR]   [CS:K]Bazar Kecleon[CR]"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
