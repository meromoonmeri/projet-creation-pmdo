--- Scene: a05p01
local a05p01 = {}
function a05p01.Cutscene()
  GAME:CutsceneMode(true)
  GAME:FadeOut(true, 30)
  GAME:FadeOut(true, 30)
  GAME:PlayBGM('Credits', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P01_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P01_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P01_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P01_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P01_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P01_006"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P01_007"))
  GAME:FadeOut(true, 60)
  GAME:FadeOut(true, 60)
  GAME:PlayBGM('Time Of Reunion', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P01_008"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P01_009"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P01_010"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P01_011"))
  GAME:CutsceneMode(false)
end
return a05p01
