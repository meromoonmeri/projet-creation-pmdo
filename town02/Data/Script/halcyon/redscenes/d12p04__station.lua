-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d12p04 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("In the Depths of the Pit (Rescue Team).ogg", true) end) -- 0x44 music_id 114 (ROM)
  SkySceneKit.say({english="Having calmed , [hero]'s team left the dungeon...", french="Ayant réussi à calmer , l'équipe de [hero] quitta le donjon...", german="Nachdem beruhigt war, verließ das Team von [hero] den Dungeon...", italian="Dopo aver placato , la squadra di [hero] lascia il dungeon...", spanish="Una vez que calmaron a , el equipo de [hero] dejó la cueva..."})
  SkySceneKit.say({english="And returned to Pokémon Square together with 's team.", french="... et retourna sur la Place Pokémon, accompagnée de l'équipe d'.", german="Und kehrte mit s Team zum Pokémonplatz zurück.", italian="e fa ritorno in Piazza Pokémon insieme alla squadra di .", spanish="y volvió a la Plaza Pokémon junto al equipo de ."})
  SkySceneKit.say({english="Grgaaaaaah!", french="Grrraaaaaah!", german="Grgaaaaaah!", italian="Grgaaaaaah!", spanish="¡Grrrrrrrrr!"})
  SkySceneKit.say({english="Look! It's ! and too!", french="Regarde! ... et ! Ils sont là!", german="Sieh mal! Da ist ! Und da sind auch und !", italian="Guarda! È ! Ci sono pure e !", spanish="¡Mira! ¡Es ! ¡Y también y !"})
  SkySceneKit.say({english="Urrgggh!", french="Arrgggh!", german="Arrgggh!", italian="Urrgggh!", spanish="¡Urrg!"})
  SkySceneKit.say({english="Did you do it? ?", french="Et ? Vous l'avez battu?", german="Habt ihr es geschafft? Was ist mit ?", italian="Ce l'avete fatta? E ?", spanish="¿Hiciste tú esto? ¿?"})
  SkySceneKit.say({english="Are you all right?", french="Vous allez bien?", german="Seid ihr in Ordnung?", italian="Tutto a posto?", spanish="¿Estás bien?"})
  SkySceneKit.say({english="Are you OK?", french="Vous vous sentez bien?", german="Geht es euch gut?", italian="Tutto OK?", spanish="¿Te encuentras bien?"})
  SkySceneKit.say({english="Yes, fine.", french="Oui, ça va.", german="Ja, alles in Ordnung.", italian="Sì, bene.", spanish="Sí, estoy bien."})
  SkySceneKit.say({english="We will be fine. But we must get out immediately.", french="On va bien. Mais nous devons partir tout de suite.", german="Es geht mir gut. Aber wir müssen diesen Ort sofort verlassen.", italian="Non abbiamo motivo di preoccuparci. Ma dobbiamo uscire di qui al più presto.", spanish="No te preocupes por nosotros. Debemos irnos de inmediato."})
  SkySceneKit.say({english="What about ? Will it be OK?", french="Et ? Tout ira bien pour lui?", german="Was ist mit ? Wird es ihm gut gehen?", italian="E ? Che fine farà?", spanish="¿Y ? ¿Estará bien?"})
  SkySceneKit.say({english="Your concern is unneeded. It will awaken soon enough.", french="Il n'y a pas lieu de s'inquiéter. Il se réveillera bien assez tôt.", german="Eure Sorgen sind unbegründet. Es wird nur allzu bald wieder erwachen.", italian="Le tue preoccupazioni sono infondate. Si risveglierà presto.", spanish="No necesitas preocuparte. Despertará pronto."})
  SkySceneKit.say({english="It had lost control only because it was enraged from having its sleep disturbed.", french="Il a perdu le contrôle de lui-même uniquement parce que son sommeil a été perturbé.", german="Es war wütend darüber, aus seinem Schlaf gerissen zu werden, und hat die Kontrolle verloren.", italian="Era andato su tutte le furie solo perché era stato disturbato nel sonno.", spanish="Perdió el control solo por la furia que le provocó que interrumpieran su sueño."})
  SkySceneKit.say({english="It should calm down.", french="Il devrait se calmer.", german="Es sollte sich beruhigen.", italian="Ora dovrebbe calmarsi.", spanish="Debería calmarse."})
  SkySceneKit.say({english="Waah... Another quake!", french="Aaah... Une autre secousse!", german="Waah... Ein weiteres Beben!", italian="Aah... Un'altra scossa!", spanish="Aaah... ¡Otro seísmo!"})
  SkySceneKit.say({english="Out! Quickly!", french="Sortons! Vite!", german="Hinaus! Schnell!", italian="Fuori! Non c'è tempo da perdere!", spanish="¡Vamos afuera! ¡Rápido!"})
end
