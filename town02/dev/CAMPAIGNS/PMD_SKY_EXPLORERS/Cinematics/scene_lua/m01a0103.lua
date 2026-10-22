--- PMD Sky to PMDO Automatic Translation
--- Source Scene: m01a0103

local m01a0103 = {}

function m01a0103.Cutscene()
  GAME:CutsceneMode(true)

  GAME:FadeOut(false, 1)
  GAME:MoveCamera(hero.MapLoc.X, hero.MapLoc.Y, 1, true)
  GAME:PlayBGM('MUS_BEACH', true)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:CharSetAction(partner, RogueEssence.Ground.Animations.SurpriseAction())
  SOUND:PlayBattleSE('SE_NOTICE')
  GROUND:MoveToPosition(partner, 10, 15, false, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey('SCENE_M01A0103_DLG_001'))

  GAME:CutsceneMode(false)
end

return m01a0103
