--- Scene: d25p01
local d25p01 = {}
function d25p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
  SOUND:FadeOutBGM(120)
  GAME:FadeOut(true, 60)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D25P01_001"))
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d25p01
