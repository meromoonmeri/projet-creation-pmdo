--- Scene: a05p03
local a05p03 = {}
function a05p03.Cutscene()
  GAME:CutsceneMode(true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P03_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P03_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P03_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P03_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P03_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P03_006"))
  GAME:CutsceneMode(false)
end
return a05p03
