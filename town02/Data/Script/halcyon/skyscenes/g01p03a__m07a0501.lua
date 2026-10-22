-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m07a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 240, 216, Direction.Up, "NPC_DOGAASU")
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho! What's with them?[K]\nThey went down before they even got near the\nPerfect Apples.", french="Mouarf mouarf! C'est quoi leur\nproblème?[K] Comment on peut tomber K.O. aussi\nvite sans avoir trouvé les Pommes Parfaites?", german="Whoaho! Was ist mit denen\nlos?[K] Sie haben es nicht einmal in die Nähe\nder Perfekten Äpfel geschafft!", italian="Uooh-ho! Ma cosa succede?[K]\nVanno KO prima ancora di aver raggiunto le\nMele Perfette?", spanish="¡Jo, jo...! ¡Qué poco aguante![K]\nLes han dado para el pelo antes de poder\nacercarse a las Manzanas Perfectas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 264, 216, Direction.Up, "NPC_ZUBATTO")
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh. And they did it all\nthemselves without us helping.", french="Hin hin! Et en plus, on y est pour\nrien!", german="Hehe. Und wir mussten nicht\neinmal nachhelfen.", italian="Eh-eh. E non c'è neanche stato\nbisogno del nostro intervento.", spanish="¡Jue, jue! Y nosotros ni siquiera\nhemos tenido que hacer nada."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
