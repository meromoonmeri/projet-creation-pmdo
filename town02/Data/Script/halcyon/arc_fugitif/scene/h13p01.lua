--- Scene: h13p01
local h13p01 = {}
function h13p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Friend Area Cave.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h13p01
