--- Scene: d24p02
local d24p02 = {}
function d24p02.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Stormy Sea', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D24P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D24P02_002"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d24p02
