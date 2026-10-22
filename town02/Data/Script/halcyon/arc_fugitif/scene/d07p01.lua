--- Scene: d07p01
local d07p01 = {}
function d07p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Chasm Cave.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D07P01_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D07P01_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D07P01_003"))
  -- GROUND:CharSetAction(ent, 2)
  SOUND:PlayBGM('Chasm Cave.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D07P01_004"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d07p01
