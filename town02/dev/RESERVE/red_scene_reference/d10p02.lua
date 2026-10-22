--- Scene: d10p02
local d10p02 = {}
function d10p02.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Frosty Forest', true)
  GAME:FadeOutBGM(60)
  GAME:FadeOutBGM(30)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:PlayBGM('Frosty Forest', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P02_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P02_003"))
  GAME:PlayBGM('Frosty Forest', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P02_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P02_005"))
  GAME:CutsceneMode(false)
end
return d10p02
