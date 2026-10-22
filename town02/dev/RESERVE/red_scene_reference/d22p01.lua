--- Scene: d22p01
local d22p01 = {}
function d22p01.Cutscene()
  GAME:CutsceneMode(true)
  GAME:FadeOut(true, 60)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D22P01_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D22P01_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D22P01_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D22P01_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D22P01_005"))
  GAME:FadeOutBGM(90)
  -- GROUND:CharSetAction(ent, 4)
  -- GROUND:CharSetAction(ent, 22)
  GAME:CutsceneMode(false)
end
return d22p01
