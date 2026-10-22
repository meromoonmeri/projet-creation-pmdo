--- Scene: d12p01
local d12p01 = {}
function d12p01.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Magma Cavern', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:PlayBGM('Magma Cavern', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P01_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P01_002"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:PlayBGM('Magma Cavern', true)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P01_003"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d12p01
