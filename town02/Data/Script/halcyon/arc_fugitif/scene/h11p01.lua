--- Scene: h11p01
local h11p01 = {}
function h11p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Friend Area Swamp.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h11p01
