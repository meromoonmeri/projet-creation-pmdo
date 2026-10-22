-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P10P01A/m24a0110.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P10P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_rapurasu = SkySceneKit.spawn_npc("lapras", 168, 128, Direction.Right, "NPC_RAPURASU")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- GAP: SetEffect 646 — VFX sans émote PMDO équivalente
  GAME:FadeOut(false, 0) -- screen_FlushOut
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I met with [CS:N]Lapras[CR] and\n[CN]explained what was happening.", french="[CN]Je suis allé voir [CS:N]Lokhlass[CR]\n[CN]pour l'avertir de ce qui se passait.", german="[CN]Ich traf mich mit [CS:N]Lapras[CR] und\n[CN]erklärte ihm, was passierte.", italian="[CN]Ho incontrato [CS:N]Lapras[CR] e gli ho\n[CN]spiegato cosa stava succedendo.", spanish="[CN]Me reuní con él y\n[CN]le expliqué lo que ocurría."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]How time was stopping all over\n[CN]and how the world was in peril...", french="[CN]Que le temps s'arrêtait un peu partout\n[CN]et que le monde était en danger...", german="[CN]Wie die Zeit überall anhielt und\n[CN]dass die Welt in Gefahr war...", italian="[CN]Di come il tempo si stesse fermando\n[CN]in ogni dove e il mondo fosse in pericolo...", spanish="[CN]Cómo el tiempo se estaba deteniendo\n[CN]y el peligro que corría el mundo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I also explained how the\n[CN]Time Gears needed to be\n[CN]taken to [CS:P]Temporal Tower[CR]...", french="[CN]Je lui ai aussi raconté qu'il fallait\n[CN]emporter les Rouages du Temps\n[CN]à la [CS:P]Tour du Temps[CR]...", german="[CN]Ich erklärte ihm auch, dass\n[CN]die Zahnräder der Zeit zum\n[CN][CS:P]Zeitturm[CR] gebracht werden müssten.", italian="[CN]Gli ho anche spiegato perché era\n[CN]necessario portare gli Ingranaggi del\n[CN]Tempo alla [CS:P]Torre del Tempo[CR]...", spanish="[CN]También le expliqué que había que\n[CN]llevar los Engranajes del Tiempo\n[CN]a la [CS:P]Torre del Tiempo[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]So I asked him to reveal\n[CN]how we could get to\n[CN]the [CS:P]Hidden Land[CR].", french="[CN]Et je lui ai demandé de me révéler\n[CN]le moyen d'atteindre\n[CN]les [CS:P]Terres Illusoires[CR].", german="[CN]Deshalb bat ich ihn, mir\n[CN]zu verraten, wie man zum\n[CN][CS:P]Verborgenen Land[CR] gelangt.", italian="[CN]Quindi gli ho chiesto di rivelarmi\n[CN]la via per raggiungere la\n[CN][CS:P]Terra Nascosta[CR].", spanish="[CN]Por último, le pregunté\n[CN]cómo se podía llegar\n[CN]a la [CS:P]Tierra Oculta[CR]."})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
