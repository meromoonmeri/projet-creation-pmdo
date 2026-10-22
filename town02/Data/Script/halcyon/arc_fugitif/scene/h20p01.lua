--- Scene: h20p01
local h20p01 = {}
function h20p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Overgrown Wilds.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h20p01
