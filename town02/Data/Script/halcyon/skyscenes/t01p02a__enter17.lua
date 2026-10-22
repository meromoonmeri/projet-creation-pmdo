-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/enter17.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Move Linking and\n[CN]Banking Services This Way →\n[CN][CS:K]Electivire[CR] Link Shop    [CS:K]Duskull[CR] Bank", french="[CN]Création de chaînes de capacités\n[CN]Services bancaires →\n[CN][CS:K]Stand Chaîne Elekable[CR]    [CS:K]Banque Skelénox[CR]", german="[CN]Zum Kombinieren von Attacken (Link)\n[CN]und für Bankgeschäfte hier entlang →\n[CN][CS:K]Elevoltek-Link[CR]    [CS:K]Zwirrlicht-Bank[CR]", italian="[CN]Combinazione Mosse e\n[CN]Servizi Bancari da questa parte →\n[CN]Combiteca [CS:K]Electivire[CR]                Banca [CS:K]Duskull[CR]", spanish="[CN]Enlace de movimientos y\n[CN]Servicios Bancarios por aquí →\n[CN][CS:K]Enlaces Electivire[CR]    [CS:K]Banco Duskull[CR]"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
