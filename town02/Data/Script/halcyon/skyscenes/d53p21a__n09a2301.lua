-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P21A/n09a2301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D53P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 256, 288, Direction.UpLeft, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 208, 288, Direction.Up, "NPC_SEREBII")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(29) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(npc_npc_serebii, Direction.Down)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_VAST_ICE_MOUNTAIN_PEAK non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GROUND:EntTurn(npc_npc_serebii, Direction.Up)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_serebii, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- GAP: se_Play(11534) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(20)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(20)
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(20)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(20)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(20)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We don't have any time.", french=" Ne perdons pas de temps.", german=" Wir haben keine Zeit.", italian=" Non c'è tempo.", spanish=" No nos queda tiempo."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We have to stop Master [CS:N]Dialga[CR],\nbefore we disappear...", french="Nous devons arrêter Maître\n[CS:N]Dialga[CR] avant de disparaître...", german="Wir müssen Meister [CS:N]Dialga[CR]\naufhalten, bevor wir verschwinden...", italian="Prima di scomparire, dobbiamo\nfermare il Maestro [CS:N]Dialga[CR]...", spanish="Tenemos que detener a\n[CS:N]Dialga[CR] antes de desaparecer..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Let's hurry.", french=" Dépêchons.", german=" Beeilen wir uns.", italian=" Sbrighiamoci.", spanish=" Démonos prisa."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
