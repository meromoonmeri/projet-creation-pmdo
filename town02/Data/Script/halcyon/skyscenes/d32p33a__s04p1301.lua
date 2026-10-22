-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P33A/s04p1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(59, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  if (SkyProg.cmp(29, 64) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 64]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_D32P33A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:MoveToPosition(hero, 180, 252, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 204, 268, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 156, 268, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 180, 284, false, 2) end end
  pcall(function() SOUND:PlayBGM("Sealed Ruin.ogg", true) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  local npc_npc_rejisuchiru = SkySceneKit.spawn_npc("registeel", 184, 216, Direction.Down, "NPC_REJISUCHIRU")
  pcall(function() UI:SetSpeaker(npc_npc_rejisuchiru) end)
  SkySceneKit.say({english="IF YOU WANT TO GO ON, SHOW\nTHAT YOU HAVE THE POWER.", french="SI VOUS VOULEZ CONTINUER,\nMONTREZ QUE VOUS EN AVEZ LE POUVOIR.", german="WENN IHR WEITERGEHEN\nWOLLT, ZEIGT, DASS IHR DIE KRAFT DAZU\nHABT.", italian="SE VUOI PROSEGUIRE,\nDIMOSTRA DI AVERNE LA FORZA.", spanish="SI QUIERES CONTINUAR,\nDEMUESTRA QUE ERES CAPAZ."})
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  else
  SkyProg.set(29, 64) -- $SCENARIO_MAIN = scn[29,64] (ROM)
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
