--- Scene: h28p01
local h28p01 = {}
function h28p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Overgrown Wilds.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h28p01
