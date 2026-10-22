-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d21p01 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("In the Depths of the Pit (Rescue Team).ogg", true) end) -- 0x44 music_id 114 (ROM)
  SkySceneKit.say({english="Urghgh...", french="Arghgh...", german="Arghgh...", italian="Urghgh...", spanish="Urg..."})
  SkySceneKit.say({english="............ Please... Please let me go...", french="... ... ... ... S'il te plaît... S'il te plaît, laisse-moi partir...", german="............ Bitte... Bitte lass mich gehen...", italian="... ... ... ... Ti prego... Ti scongiuro, lasciami andare...", spanish="... Por favor... Por favor, déjame ir..."})
  SkySceneKit.say({english="I have to go... There's somewhere that I have to go...", french="Je dois absolument partir... Il le faut...", german="Ich muss gehen... Ich muss zu einem ganz bestimmten Ort...", italian="Devo andarmene... Devo recarmi in un posto...", spanish="Debo irme... Tengo que ir a un sitio..."})
  SkySceneKit.say({english="If...I don't hurry... M-my little sister...", french="Si... je ne me dépêche pas... ma... ma petite sur...", german="Wenn... ich mich nicht beeile... wird m-meine kleine Schwester...", italian="Se non faccio in fretta... la mia sorellina...", spanish="Si... no me doy prisa... mi hermana pequeña..."})
end
