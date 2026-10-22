--- Scene: d11p02
local d11p02 = {}
function d11p02.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Mt Freeze', true)
  GAME:FadeOutBGM(60)
  GAME:FadeOutBGM(30)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:PlayBGM('Mt Freeze', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P02_002"))
  GAME:CutsceneMode(false)
end
return d11p02
