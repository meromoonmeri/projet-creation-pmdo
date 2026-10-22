-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P04P01C/m11a0706.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P04P01C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 160, 408, Direction.Up, "NPC_JUPUTORU")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(15)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_yukushii = SkySceneKit.spawn_npc("uxie", 160, 360, Direction.Down, "NPC_YUKUSHII")
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" I should have done it...", french=" J'aurais dû le faire...", german=" Ich hätte es tun sollen...", italian=" Avrei dovuto farlo...", spanish=" Tendría que haberlo hecho."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="I should have taken their\nmemories when I had the chance...", french="J'aurais dû effacer leurs\nsouvenirs quand j'en ai eu l'occasion...", german="Ich hätte ihr Gedächtnis löschen\nsollen, als ich die Chance hatte...", italian="Avrei dovuto prendermi i loro\nricordi finché ero in tempo...", spanish="Debería haberles borrado\nla memoria cuando tuve la oportunidad."})
  -- message_Close
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="I don't know exactly what you're talking\nabout...[K] But you're wrong.", french="Je ne sais pas de quoi tu parles\nau juste...[K] Mais tu as tort.", german="Ich weiß nicht genau, wovon du redest...[K]\nAber du irrst dich.", italian="Non capisco bene di cosa stai parlando...[K]\nMa ti sbagli.", spanish="No sé muy bien de qué hablas...[K]\nPero te equivocas."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="No one led me here. No one told me about\nthis place.", french="Personne ne m'a conduit jusqu'ici.\nPersonne ne m'a parlé de cet endroit.", german="Niemand hat mich hergeführt. Niemand hat\nmir von diesem Ort erzählt.", italian="Nessuno mi ha portato qui e nessuno mi ha\nraccontato di questo posto.", spanish="Nadie me ha traído aquí. Nadie me\nha hablado de este lugar."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="I've known about the presence of a\nTime Gear here...[K]for a long time.", french="Je sais que ce Rouage du Temps est ici...[K]\ndepuis bien longtemps.", german="Dass es hier ein Zahnrad der Zeit gibt,[K]\nweiß ich schon lange.", italian="Sono a conoscenza del fatto che qui si\ntrova un Ingranaggio del Tempo...[K] da molto\ntempo.", spanish="Sabía que aquí había un Engranaje del\nTiempo...[K] desde hace mucho."})
  -- message_Close
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
