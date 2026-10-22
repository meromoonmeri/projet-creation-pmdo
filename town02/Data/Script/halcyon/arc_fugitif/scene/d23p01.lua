--- Scene: d23p01
local d23p01 = {}
function d23p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
  SOUND:FadeOutBGM(120)
  GAME:FadeOut(true, 60)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D23P01_001"))
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d23p01
