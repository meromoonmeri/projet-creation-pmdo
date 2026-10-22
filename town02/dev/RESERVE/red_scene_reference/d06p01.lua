--- Scene: d06p01
local d06p01 = {}
function d06p01.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Mt Thunder', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D06P01_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D06P01_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D06P01_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D06P01_004"))
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 9)
  -- GROUND:CharSetAction(ent, 2)
  GAME:PlayBGM('Mt Thunder', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D06P01_005"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d06p01
