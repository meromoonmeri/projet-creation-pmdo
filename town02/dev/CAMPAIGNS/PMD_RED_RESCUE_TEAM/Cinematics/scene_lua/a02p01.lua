--- Scene: a02p01
local a02p01 = {}
function a02p01.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('The Escape', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P01_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P01_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P01_003"))
  -- GROUND:CharSetAction(ent, 2)
  -- CAMERA_PAN(256, 0),
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P01_004"))
  -- GROUND:CharSetAction(ent, 2)
  -- CAMERA_PAN(256, 1),
  GAME:CutsceneMode(false)
end
return a02p01
