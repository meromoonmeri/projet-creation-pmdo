--- Scene: h08p01
local h08p01 = {}
function h08p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Luminous Spring.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h08p01
