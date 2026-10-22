--- Scene: d12p02
local d12p02 = {}
function d12p02.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Magma Cavern', true)
  GAME:FadeOutBGM(60)
  GAME:FadeOutBGM(30)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:PlayBGM('Magma Cavern', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P02_002"))
  GAME:CutsceneMode(false)
end
return d12p02
