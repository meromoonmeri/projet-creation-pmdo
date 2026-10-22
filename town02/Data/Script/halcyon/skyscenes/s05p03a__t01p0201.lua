-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S05P03A/t01p0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- switch(ProcessSpecial(23, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S05P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[30] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[30]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(4) [neutre/état moteur]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- GAP: BGM BGM_POKEMON_EXPLORATION_TEAM_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GROUND:MoveToPosition(hero, 168, 524, false, 2)
  GROUND:MoveToPosition(partner, 144, 508, false, 2)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  GROUND:MoveToPosition(hero, 168, 196, false, 2)
  GAME:WaitFrames(2)
  GROUND:MoveToPosition(partner, 144, 196, false, 2)
  GROUND:MoveToPosition(partner, 120, 156, false, 2)
  GROUND:MoveToPosition(hero, 156, 188, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 156, 172, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 128, 156, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 5)
  GAME:FadeIn(5)
  GAME:WaitFrames(90)
  GAME:FadeOut(false, 5)
  -- back_SetGround(LEVEL_S05P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[30] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[30]
  -- supervision_Acting(4) [neutre/état moteur]
  -- @label_3 [étiquette de flux ExplorerScript]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(156, 164, 1, false) end) -- SetPositionMark performer/caméra
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(5)
  GAME:WaitFrames(20)
  -- GAP: SetEffect 652 — VFX sans émote PMDO équivalente
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(45)
  GAME:FadeOut(true, 60) -- screen_WhiteOutAll
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(5)
  GAME:FadeOut(false, 0)
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  GAME:FadeIn(5)
  GAME:WaitFrames(95)
  GAME:FadeOut(false, 5)
  else
  -- supervision_Acting(3) [neutre/état moteur]
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- supervision_Acting(3) [neutre/état moteur]
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
