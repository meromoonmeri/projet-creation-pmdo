-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d16p01 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("In the Depths of the Pit (Rescue Team).ogg", true) end) -- 0x44 music_id 114 (ROM)
  SkySceneKit.say({english="Gwooooooh!", french="Gwooooooh!", german="Gwooooooh!", italian="Gwooooooh!", spanish="¡Oooooooh!"})
  SkySceneKit.say({english="Urghgh... I... I lost...", french="Arghgh... Je... j'ai perdu...", german="Arghgh... Ich... Ich habe...", italian="Urghgh... Ho... ho perso...", spanish="Urg... Me has... derrotado..."})
  SkySceneKit.say({english="You... What do you wish?", french="Toi... Que souhaites-tu?", german="Du... Was willst du?", italian="... Qual è il tuo sogno?", spanish="¿Qué...? ¿Qué deseas?"})
  SkySceneKit.say({english="...Wh-what?! This is... the IClear Wing...", french="Qu... quoi??? C'est... la IPlume Diaphane...", german="...W-was?!? Das ist... Die IKlarfeder...", italian="... Cosa?! Questa è... la IPiuma Bianca...", spanish="¡¿Qué?! Pero si esto es... la IPluma Blanca..."})
  SkySceneKit.say({english="...I understand now. To meet that Pokémon...", french="... Je comprends maintenant. Tu souhaites rencontrer ce Pokémon...", german="...Jetzt begreife ich. Um dieses Pokémon zu treffen...", italian="... Ora capisco. Vuoi incontrare quel Pokémon...", spanish="Ya entiendo... Para encontrar a ese Pokémon..."})
  SkySceneKit.say({english="............ Stand aside.", french="... ... ... ... Ecarte-toi.", german="............ Tritt zurück.", italian="... ... ... ... Mantieniti a distanza.", spanish="... Apártate."})
  SkySceneKit.say({english="Entei's fiery blast made the IClear Wing flare!", french="Le souffle ardent d'Entei enflamme la IPlume Diaphane!", german="Enteis Feuersturm bringt die IKlarfeder zum Glühen!", italian="Il colpo infuocato di Entei infiamma la IPiuma Bianca!", spanish="¡La llama de Entei ha hecho que la IPluma Blanca empiece a arder!"})
  SkySceneKit.say({english="The IClear Wing... transformed into the IRed Wing!", french="La IPlume Diaphane... se transforme en IPlume Vermillon!", german="Die IKlarfeder... wird zur IRotfeder!", italian="La IPiuma Bianca... si trasforma nella IPiuma Rossa!", spanish="¡La IPluma Blanca... ha pasado ahora a ser la IPluma Roja!"})
  pcall(function() SOUND:PlayBGM("In the Depths of the Pit (Rescue Team).ogg", true) end) -- 0x44 music_id 114 (ROM)
  SkySceneKit.say({english="Take this and go west!", french="Prends ça et dirige-toi à l'ouest!", german="Nimm dies und zieh nach Westen!", italian="Prendi questo e va' verso ovest!", spanish="¡Toma esto y dirígete al oeste!"})
  SkySceneKit.say({english="There, you will find the DLightning Field.", french="Là, tu trouveras les DTerres de Foudre.", german="Dort findest du das DBlitzfeld.", italian="Lì troverai il DCampo Lampo.", spanish="Allí se encuentra el DCampo Centella."})
  SkySceneKit.say({english="You will know your path there!", french="Ta volonté s'accomplira là-bas!", german="Dort wird sich dir ein Pfad auftun.", italian="Ti verrà indicata la strada!", spanish="¡Allí sabrás qué camino debes seguir!"})
  SkySceneKit.say({english="Now go! To the DLightning Field!", french="Va, maintenant! Vers les DTerres de Foudre!", german="Geh jetzt! Geh zum DBlitzfeld!", italian="Ora vai! Al DCampo Lampo!", spanish="¡Y ahora marcha al DCampo Centella!"})
  SkySceneKit.say({english="[hero] received the IRed Wing.", french="[hero] reçoit la IPlume Vermillon.", german="[hero] erhält die IRotfeder.", italian="[hero] riceve la IPiuma Rossa.", spanish="[hero] ha recibido la IPluma Roja."})
  SkySceneKit.say({english="And...", french="Et...", german="Und...", italian="In più...", spanish="Y además..."})
  SkySceneKit.say({english="Gained access to the DLightning Field!", french="... les DTerres de Foudre sont maintenant accessibles!", german="Das DBlitzfeld steht offen!", italian="Il DCampo Lampo è ora accessibile!", spanish="¡ha ganado acceso al DCampo Centella!"})
  GAME:WaitFrames(1) -- 0xE7
  GAME:WaitFrames(1) -- 0xE7
end
