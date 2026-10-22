--- Scene: h01p03
local h01p03 = {}
function h01p03.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Water Cave.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h01p03
