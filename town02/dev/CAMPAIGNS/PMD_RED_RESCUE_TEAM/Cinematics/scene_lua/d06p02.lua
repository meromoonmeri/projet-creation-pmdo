--- Scene: d06p02
local d06p02 = {}
function d06p02.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Mt Thunder', true)
  GAME:FadeOutBGM(60)
  GAME:FadeOutBGM(30)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:PlayBGM('Mt Thunder', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D06P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D06P02_002"))
  GAME:CutsceneMode(false)
end
return d06p02
