-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P21A/n06a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Boulder Quarry.ogg", true) end)
  SV.SkyScenarioSide = {main=45, sub=5} -- $SCENARIO_SIDE = scn[45,5] (ROM)
  -- back_SetGround(LEVEL_D55P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 208, 424, Direction.Down, "NPC_CHAAREMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 256, 424, Direction.Left, "NPC_SAANAITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(hero, 228, 276, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_chaaremu, 204, 308, false, 2)
  GAME:WaitFrames(12)
  GROUND:MoveToPosition(npc_npc_saanaito, 252, 308, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(6)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We've come pretty far.", french="Ça fait longtemps que\nnous avançons.", german=" Wir sind schon ganz schön weit.", italian=" Abbiamo fatto parecchia strada.", spanish=" Hemos avanzado bastante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="I think it's going to get more\ndifficult from here on.", french="Et j'ai comme l'impression\nque ça va se corser.", german="Von hier an wird es wohl\nschwieriger werden.", italian="Credo che da qui in avanti\nle cose si complicheranno.", spanish="Creo que a partir de este punto\nserá más difícil."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Let's proceed with caution.", french=" Restons prudentes.", german="Lasst uns mit Bedacht\nvoranschreiten.", italian=" Dobbiamo procedere con cautela.", spanish="Será mejor que avancemos\ncon cautela."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
