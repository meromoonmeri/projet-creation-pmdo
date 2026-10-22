--- Scene: d02p02
local d02p02 = {}
function d02p02.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
  SOUND:FadeOutBGM(120)
  GAME:FadeOut(true, 60)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D02P02_001"))
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d02p02
