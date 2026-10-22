--- Scene: d08p02
local d08p02 = {}
function d08p02.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Theres Trouble', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D08P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D08P02_002"))
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D08P02_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D08P02_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D08P02_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D08P02_006"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d08p02
