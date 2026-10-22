--- Scene: a03p02
local a03p02 = {}
function a03p02.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Escape Through The Snow', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P02_002"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return a03p02
