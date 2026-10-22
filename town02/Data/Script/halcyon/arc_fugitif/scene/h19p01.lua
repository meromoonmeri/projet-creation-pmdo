--- Scene: h19p01
local h19p01 = {}
function h19p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Friend Area Cave.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h19p01
