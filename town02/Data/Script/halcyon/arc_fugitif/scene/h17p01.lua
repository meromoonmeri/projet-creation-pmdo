--- Scene: h17p01
local h17p01 = {}
function h17p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Overgrown Wilds.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h17p01
