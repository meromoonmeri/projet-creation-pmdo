-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99E/s21p0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_H01P99E) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 224, 168, Direction.UpLeft, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But when all seemed lost...[K]\nyou refused to give up.", french="Mais quand tout semblait\nperdu...[K] tu as refusé d'abandonner.", german="Aber als alles verloren\nschien...[K] Da hast du dich geweigert aufzugeben.", italian="Ma quando tutto sembrava\nperduto...[K] tu non hai voluto desistere.", spanish="Pero cuando todo parecía\nperdido...[K] tú te negaste a rendirte."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Even I had given up.", french=" Même moi, j'avais abandonné.", german="Sogar ich hatte schon\naufgegeben.", italian=" Sebbene io mi fossi arreso.", spanish="Incluso yo lo había dado todo por\nperdido."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What compelled you?", french=" Qu'est-ce qui te motive?", german=" Was hat dich angetrieben?", italian=" Cosa ti ha spinto?", spanish=" ¿Cómo lo hiciste?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="How did you manage...[K]to stay\nso strong?", french="Comment peux-tu...[K] rester\ninébranlable?", german="Wie hast du es geschafft?[K]\nWie konntest du so stark bleiben?", italian="Come hai fatto...[K] a trovare\nla forza?", spanish="¿Cómo te las arreglaste...?[K]\n¿Cómo encontraste las fuerzas?"})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
