--- Scene: h02p02
local h02p02 = {}
function h02p02.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Water Cave.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h02p02
