--- Scene: h04p01
local h04p01 = {}
function h04p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Fertile Valley.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h04p01
