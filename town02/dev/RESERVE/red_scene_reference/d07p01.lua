--- Scene: d07p01
local d07p01 = {}
function d07p01.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Great Canyon', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D07P01_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D07P01_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D07P01_003"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:PlayBGM('Great Canyon', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D07P01_004"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d07p01
