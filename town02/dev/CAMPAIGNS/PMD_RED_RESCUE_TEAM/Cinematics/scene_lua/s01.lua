--- Scene: s01
local s01 = {}
function s01.Cutscene()
  GAME:CutsceneMode(true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_S01_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_S01_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_S01_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_S01_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_S01_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_S01_006"))
  GAME:PlayBGM('Welcome To The World Of Pokemon', true)
  GAME:FadeOutBGM(30)
  GAME:CutsceneMode(false)
end
return s01
