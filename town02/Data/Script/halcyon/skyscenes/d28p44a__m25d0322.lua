-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P44A/m25d0322.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D28P44A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 256, 184, Direction.Down, "NPC_YONOWAARU")
  -- SetAnimation(55) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 256, 184, Direction.Up, "NPC_JUPUTORU")
  -- SetAnimation(33) [anim idle native]
  -- GAP: SetEffect 653 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Though the parting hurts...[K]\nThe rest is in your hands!", french="Ecoute-moi bien... La séparation\nest toujours douloureuse...[K] mais les larmes\ndevront attendre!", german="Auch wenn die Trennung\nschmerzt...[K] Der Rest liegt in deiner Hand!", italian="Certo, gli addii sono dolorosi...[K]\nMa ora è tutto nelle tue mani!", spanish="Separarse es duro...[K]\n¡Lo dejo todo en tus manos!"})
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
