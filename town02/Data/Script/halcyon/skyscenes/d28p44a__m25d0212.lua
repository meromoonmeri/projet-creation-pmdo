-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P44A/m25d0212.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D28P44A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 256, 208, Direction.Down, "NPC_YONOWAARU")
  -- SetAnimation(36) [anim idle native]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Is this really...", french=" Est-ce vraiment...", german=" Ist das wirklich...", italian=" È davvero...", spanish=" ¿Es esto...?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Is this what you really want?", french="Est-ce là vraiment ce que vous\nsouhaitez?", german="Ist das wirklich, was ihr\nwollt?", italian=" È davvero questo che volete?", spanish="¿Realmente es esto lo que\nqueréis?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If history is changed...[K]\nWe Pokémon of the future will disappear...", french="Si le cours de l'histoire est\naltéré...[K] Nous, les Pokémon du futur, serons\namenés à disparaître...", german="Wenn die Geschichte verändert\nwird,[K] dann werden wir Pokémon aus der\nZukunft verschwinden...", italian="Se la storia cambia...[K] noi\nPokémon del futuro scompariremo...", spanish="Si cambiáis la historia...[K]\nlos Pokémon del futuro desapareceremos."})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
