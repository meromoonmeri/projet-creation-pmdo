--- Scene: d04p01
local d04p01 = {}
function d04p01.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Sinister Woods', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D04P01_001"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:PlayBGM('Sinister Woods', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D04P01_002"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d04p01
