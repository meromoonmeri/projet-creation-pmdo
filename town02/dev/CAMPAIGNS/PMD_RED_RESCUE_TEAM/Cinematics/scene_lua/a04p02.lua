--- Scene: a04p02
local a04p02 = {}
function a04p02.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Sky Tower', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A04P02_001"))
  -- GAME:MoveCamera(HeroX, HeroY, 1)
  GAME:CutsceneMode(false)
end
return a04p02
