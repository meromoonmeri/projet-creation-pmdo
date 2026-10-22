--- Scene: h05p01
local h05p01 = {}
function h05p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Friend Area Forest.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h05p01
