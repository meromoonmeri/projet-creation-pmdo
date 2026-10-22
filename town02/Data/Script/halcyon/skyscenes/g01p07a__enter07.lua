-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/enter07.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]GET UP ALREADY!\n[CN]         -[CS:N]Loudred[CR]", french="[CN]ALLEZ, DEBOUT! HOP HOP HOP!\n[CN]         - [CS:N]Ramboum[CR]", german="[CN]NUN STEHT ENDLICH AUF!\n[CN]- [CS:N]Krakeelo[CR]", italian="[CN]SU! È ORA DI ALZARSI!\n[CN]               - [CS:N]Loudred[CR] -", spanish="[CN]¡DESPERTAD YA!\n[CN]         -[CS:N]Loudred[CR]"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
