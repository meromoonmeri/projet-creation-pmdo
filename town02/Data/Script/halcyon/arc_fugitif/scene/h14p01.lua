--- Scene: h14p01
local h14p01 = {}
function h14p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Overgrown Wilds.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h14p01
