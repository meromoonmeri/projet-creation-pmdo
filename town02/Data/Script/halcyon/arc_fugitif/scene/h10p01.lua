--- Scene: h10p01
local h10p01 = {}
function h10p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Water Cave.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h10p01
