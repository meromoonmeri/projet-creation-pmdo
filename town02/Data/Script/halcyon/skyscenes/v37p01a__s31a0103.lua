-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V37P01A/s31a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_V37P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(128, 92, 60, false) end) -- performer/caméra
  GAME:FadeIn(60)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker("Mr Mime", true, "mr_mime", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_BARIYAADO) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's a really tall mountain to\nthe east.", french="C'est une très haute montagne,\nà l'est.", german="So heißt ein wirklich hoher Berg\nim Osten.", italian="È una montagna altissima che\nsi trova a est di qui.", spanish="Es una montaña altísima que se\nencuentra al este."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's said that the mountain is so\ntall, it almost reaches beyond the sky.", french="On dit que cette montagne est si\nhaute qu'elle s'élève au-delà du ciel.", german="Man sagt, dieser Berg sei so\nhoch, dass er über den Himmel hinausragt.", italian="Si dice che sia talmente alta\nda superare addirittura le nuvole.", spanish="Se dice que es tan alta que\ncasi atraviesa el cielo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But it's surrounded by an\nimpassable mountain range, so the route there\nhas been lost.", french="Mais elle est entourée d'une\nchaîne de montagnes presque infranchissable,\nsi bien qu'il est très difficile de s'y rendre.", german="Aber er ist von unüberwindbaren\nGebirgszügen umringt, sodass niemand ihn\nerreichen kann.", italian="Ma è circondata da una catena\nmontuosa insormontabile, quindi il sentiero\nè inaccessibile.", spanish="Pero la rodea una cadena montañosa\ninfranqueable y se ha perdido el sendero\nde ascenso."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That's why it hasn't been fully\nexplored yet.", french="C'est pourquoi elle n'a pas\nencore été entièrement explorée.", german="Deswegen wurde er auch noch\nnicht vollständig erforscht.", italian="Ecco perché non è stata ancora\nesplorata del tutto.", spanish="Por eso hasta ahora no se ha\nconseguido explorar en su totalidad."})
  -- message_Close
  GAME:FadeOut(false, 60)
end
