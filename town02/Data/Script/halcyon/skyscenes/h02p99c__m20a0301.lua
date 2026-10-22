-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/m20a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetAnimation(62) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 544, 232, Direction.UpLeft, "NPC_JUPUTORU")
  -- SetAnimation(29) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60)
  GAME:WaitFrames(60)
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Hm?[K] [partner] isn't here...", french="Hmm?[K] [partner] n'est pas\nlà...", german="Hm?[K] [partner] ist nicht\nhier...", italian=" Uh?[K] [partner] non è qui...", spanish=" ¿Eh?[K] [partner] no está."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Maybe outside...?", french=" Dehors, peut-être...?", german=" Vielleicht draußen?", italian=" Sarà fuori...?", spanish=" ¿Habrá salido?"})
  -- message_Close
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-60), p.Y+(0), false, 2) end
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-56), false, 2) end
  GROUND:MoveToPosition(npc_npc_juputoru, 492, 140, false, 2)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
