-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V38P07A/n09a2203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_V38P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  GAME:FadeIn(30)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  -- MovePositionOffset<object OBJECT_V38P07C1_490> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P07C2_491> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P07C3_492> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P07D4_498> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(10)
  -- MovePositionOffset<object OBJECT_V38P07C4_493> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P07C5_494> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P07D1_495> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P07B1_489> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(10)
  -- MovePositionOffset<object OBJECT_V38P07D2_496> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P07D3_497> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(5)
  -- MovePositionOffset<object OBJECT_V38P07A1_488> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P07D5_499> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(10)
  -- MovePositionOffset<object OBJECT_V38P07D6_500> [prop décor NDS, géré par le rendu du ground]
  GAME:FadeOut(false, 30)
  -- camera_SetEffect(0): arrêt d'effet caméra
end
