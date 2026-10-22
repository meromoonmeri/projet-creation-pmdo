-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground h29p01 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  GAME:WaitFrames(2) -- 0xE7
  GAME:WaitFrames(4) -- 0xE7
  GAME:WaitFrames(4) -- 0xE7
  GAME:WaitFrames(4) -- 0xE7
  GAME:WaitFrames(5) -- 0xE7
  GAME:WaitFrames(8) -- 0xE7
  GAME:WaitFrames(9) -- 0xE7
  GAME:WaitFrames(9) -- 0xE7
  GAME:WaitFrames(9) -- 0xE7
  pcall(function() SOUND:PlayBGM("Friend Area Legendary Island.ogg", true) end) -- 0x44 music_id 117 (ROM)
  pcall(function() SOUND:PlayBGM("Friend Area Legendary Island.ogg", true) end) -- 0x44 music_id 117 (ROM)
  SkySceneKit.say({english="Fire, ice, and electricity...", french="Feu, glace et électricité...", german="Feuer, Eis und Elektrizität...", italian="Fuoco, ghiaccio ed elettricità...", spanish="Fuego, hielo y electricidad..."})
  SkySceneKit.say({english="When the three powers merge as one...", french="Quand ces trois pouvoirs ne font plus qu'un...", german="Wenn die drei Kräfte miteinander verschmelzen...", italian="Quando i tre poteri si fonderanno in uno solo...", spanish="Cuando los tres poderes se fundan en uno..."})
  SkySceneKit.say({english="The guardian of the sea is said to arise.", french="... on dit que le gardien des mers se réveille.", german="Erhebt sich der Wächter des Meeres.", italian="Si dice che il custode del mare si risveglierà.", spanish="Se dice que el guardián del mar despertará."})
  SkySceneKit.say({english="Our arrival at the HLegendary Island...", french="Le fait que nous nous trouvions tous les trois sur l'HIle Légendaire...", german="Unsere Ankunft auf der HLegendären Insel...", italian="Con il nostro arrivo sull'HIsola Leggenda...", spanish="Nuestra llegada a la HIsla Legendaria..."})
  SkySceneKit.say({english="The three of us caused the sea guardian to awaken.", french="... a causé le réveil du gardien des mers.", german="Wir drei haben mit unserer Gegenwart den Wächter des Meeres geweckt.", italian="Tutti e tre insieme abbiamo risvegliato il custode del mare.", spanish="Nosotros tres provocamos que el guardián del mar despertase."})
  SkySceneKit.say({english="It is what caused whirlpools to grow into tornadoes.", french="A cause de cela, certains tourbillons se sont transformés en tornades.", german="Deswegen wachsen die Strudel zu Tornados an.", italian="Per questo i gorghi si sono trasformati in tornadi.", spanish="Eso fue lo que hizo que los remolinos se convirtieran en tornados."})
  SkySceneKit.say({english="I have here the 4Vortex Stone.", french="J'ai ici la 4Pierre Vortex.", german="Ich habe hier den 4Vortex-Stein.", italian="Ho la 4Pietra Vortex.", spanish="Aquí tengo la 4Piedra Remolino."})
  SkySceneKit.say({english="Bearing it, you will gain passage through the sea's tornadoes...", french="Si tu la portes, tu pourras traverser les tornades marines...", german="Wenn ihr ihn tragt, könnt ihr durch die Tornados des Meeres schreiten...", italian="Se la porti con te, potrai aprirti un varco attraverso i tornadi...", spanish="Si la llevas, podrás pasar a través de los tornados marinos..."})
  SkySceneKit.say({english="It will lead you to a place called the DSilver Trench.", french="Elle te mènera à un endroit appelé la DFosse d'Argent.", german="So gelangt ihr zu einem Ort namens DSilbergraben.", italian="Ti porterà in un posto chiamato DFossa Argento.", spanish="También te llevará a un lugar conocido como la DZanja Argéntea."})
  SkySceneKit.say({english="There, you will find the guardian of the sea.", french="Là, tu trouveras le gardien des mers.", german="Dort findet ihr den Wächter des Meeres.", italian="Lì troverai il custode del mare.", spanish="Allí encontrarás al guardián del mar."})
  SkySceneKit.say({english="Now go. The guardian of the sea awaits you.", french="Maintenant, va. Le gardien des mers t'attend.", german="Geht jetzt. Der Wächter des Meeres erwartet euch.", italian="Ora vai. Il custode del mare ti attende.", spanish="Ahora márchate. El guardián del mar te espera."})
  SkySceneKit.say({english="Obtained the 4Vortex Stone.", french="Vous obtenez la 4Pierre Vortex.", german="4Vortex-Stein erhalten.", italian="La 4Pietra Vortex è tua.", spanish="Has obtenido la 4Piedra Remolino."})
  SkySceneKit.say({english="And...", french="Et...", german="Und...", italian="In più...", spanish="¡Y además..."})
  SkySceneKit.say({english="Gained access to the DSilver Trench!", french="... la DFosse d'Argent est maintenant accessible!", german="Der DSilbergraben steht offen!", italian="La DFossa Argento è ora accessibile!", spanish="tienes acceso a la DZanja Argéntea!"})
end
