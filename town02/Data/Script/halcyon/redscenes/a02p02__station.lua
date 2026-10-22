-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a02p02 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("The Escape.ogg", true) end) -- 0x44 music_id 24 (ROM)
  SkySceneKit.say({english="Across fields of fire...", french="Traversant des plaines en feu...", german="Und höllisch heiße Feuerebenen...", italian="Attraverso distese infuocate...", spanish="Y atravesando campos de fuego..."})
  SkySceneKit.say({english="But throughout it all, [hero]'s team kept their heads held high.", french="Mais tout au long de ces épreuves, l'équipe de [hero] garda la tête haute.", german="Doch trotz aller Gefahren hielt sich das Team von [hero] wacker und aufrecht.", italian="La squadra di [hero] affronta ogni avversità a testa alta.", spanish="Pero, a pesar de todo, el equipo de [hero] mantuvo la cabeza alta."})
  SkySceneKit.say({english="Without a complaint, they marched on.", french="Le voyage se poursuivit sans aucune plainte, de plus en plus loin.", german="Unverzagt und tapfer marschierten sie weiter.", italian="E continua il proprio cammino senza esitazioni.", spanish="Sin pausa, sin descanso, continuaron su camino."})
  SkySceneKit.say({english="Nature's gone savage here too...", french="La nature est devenue folle, ici aussi...", german="Die Natur ist auch hier durcheinander geraten...", italian="Anche qui la natura si sta ribellando...", spanish="Esta zona también ha sido asolada por los desastres naturales..."})
  SkySceneKit.say({english="The forest fires are still burning out of control...", french="Les feux de forêt restent incontrôlables...", german="Das Feuer im Wald brennt immer noch lichterloh...", italian="Gli incendi nelle foreste sono inarrestabili...", spanish="Los fuegos aún no están controlados..."})
  SkySceneKit.say({english="The environment is out of control here too...", french="Les éléments se déchaînent, ici aussi...", german="Die Natur ist auch hier außer Kontrolle geraten...", italian="Anche qui l'ambiente si ribella...", spanish="La naturaleza también ha perdido el norte aquí..."})
  SkySceneKit.say({english="The forest fire is still raging...", french="Le feu de forêt fait encore rage...", german="Das Feuer im Wald wütet noch immer...", italian="Gli incendi nelle foreste sono incontenibili...", spanish="El fuego lo está abrasando todo..."})
end
