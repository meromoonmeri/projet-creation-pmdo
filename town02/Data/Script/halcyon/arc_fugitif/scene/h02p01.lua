--- Scene: h02p01
local h02p01 = {}
function h02p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Water Cave.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h02p01
