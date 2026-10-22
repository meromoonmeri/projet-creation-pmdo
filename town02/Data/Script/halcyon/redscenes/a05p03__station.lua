-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a05p03 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="", french="", german="", italian="", spanish=""})
  SkySceneKit.say({english="The story of [hero] and ends here.", french="L'histoire de [hero] et se termine ici.", german="Hier endet die Geschichte von [hero] und .", italian="La storia di [hero] e termina qui.", spanish="La historia de [hero] y termina aquí."})
  SkySceneKit.say({english="But isn't done yet! There are many rescues to be done!", french="Mais pas celle de l'Equipe ! Il y a encore de nombreux sauvetages à effectuer!", german="Aber nicht für Team ! Es stehen noch so viele Rettungsaufträge aus!", italian="Ma il Team non ha finito! Ci sono ancora moltissime missioni da portare a termine!", spanish="¡Pero no es el fin del equipo ! ¡Aún hay muchas misiones que cumplir!"})
  SkySceneKit.say({english="A new adventure begins!", french="Une nouvelle aventure commence!", german="Ein neues Abenteuer beginnt!", italian="Comincia una nuova avventura!", spanish="¡Comienza una nueva aventura!"})
  SkySceneKit.say({english="The legendary Pokémon are set to make their appearance!", french="Les Pokémon légendaires peuvent désormais apparaître!", german="Die Legendären Pokémon stehen kurz davor, in Erscheinung zu treten!", italian="I Pokémon leggendari faranno la loro apparizione!", spanish="¡Los Pokémon legendarios están listos para entrar en escena!"})
  SkySceneKit.say({english="Don't go away!", french="Ce n'est pas terminé!", german="Geh nicht weg!", italian="Non andare via!", spanish="¡No te vayas!"})
  SkySceneKit.say({english="Would you like to save your adventure?", french="Voulez-vous sauvegarder votre aventure?", german="Möchtest du dein Abenteuer speichern?", italian="Vuoi salvare l'avventura?", spanish="¿Quieres guardar la partida?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="No.", french="Non", german="Nein", italian="No", spanish="No"})
  GAME:WaitFrames(1) -- 0xE7
end
