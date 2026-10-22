-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P06A/enter04.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Please wash up before eating!\n[CN]                             -[CS:N]Chimecho[CR]", french="[CN]Prière de vous laver les mains avant\n[CN]de manger!\n[CN]                             - [CS:N]Eoko[CR]", german="[CN]Vor dem Essen bitte Hände waschen!\n[CN]                    - [CS:N]Palimpalim[CR]", italian="[CN]Lavarsi le mani prima di mangiare!\n[CN]                             - [CS:N]Chimecho[CR] -", spanish="[CN]¡Lavaos antes de comer!\n[CN]                             -[CS:N]Chimecho[CR]"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
