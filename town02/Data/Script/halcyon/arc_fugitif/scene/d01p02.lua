--- Scene: d01p02
local d01p02 = {}
function d01p02.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D01P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D01P02_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D01P02_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D01P02_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D01P02_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D01P02_006"))
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d01p02
