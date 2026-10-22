--- Scene: a05p02
local a05p02 = {}
function a05p02.Cutscene()
  GAME:CutsceneMode(true)
  GAME:FadeIn(30)
  GAME:FadeOut(true, 120)
  GAME:FadeIn(15)
  GAME:FadeOutBGM(330)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P02_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P02_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P02_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A05P02_005"))
  GAME:CutsceneMode(false)
end
return a05p02
