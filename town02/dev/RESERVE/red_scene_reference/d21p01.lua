--- Scene: d21p01
local d21p01 = {}
function d21p01.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('In The Depths Of The Pit', true)
  GAME:FadeOutBGM(60)
  -- GROUND:CharSetAction(ent, 2)
  GAME:FadeOut(true, 5)
  GAME:FadeIn(5)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D21P01_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D21P01_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D21P01_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D21P01_004"))
  SOUND:PlayBattleSE('EVT_Roar')
  GAME:WaitFrames(20)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 19)
  -- GROUND:CharSetAction(ent, 25)
  -- GROUND:CharSetAction(ent, 33)
  -- GROUND:CharSetAction(ent, 9)
  GAME:CutsceneMode(false)
end
return d21p01
