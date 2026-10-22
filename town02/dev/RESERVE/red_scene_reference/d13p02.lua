--- Scene: d13p02
local d13p02 = {}
function d13p02.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Sky Tower', true)
  GAME:FadeOutBGM(60)
  GAME:FadeOutBGM(30)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:PlayBGM('Sky Tower', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D13P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D13P02_002"))
  GAME:CutsceneMode(false)
end
return d13p02
