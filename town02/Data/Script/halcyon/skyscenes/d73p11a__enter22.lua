-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/enter22.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]↑\n[CN][CS:P]Sky Peak[CR] Mountain Path\n[CN]", french="[CN]↑\n[CN]Ascension du [CS:P]Pic Céleste[CR]\n[CN]", german="[CN]↑\n[CN][CS:P]Himmelsgipfel[CR]-Gebirgspfad\n[CN]", italian="[CN]↑\n[CN]Sentiero del [CS:P]Picco del Cielo[CR]\n[CN]", spanish="[CN]↑\n[CN]Sendero alpino de la [CS:P]Cumbre del Cielo[CR][CN]"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
