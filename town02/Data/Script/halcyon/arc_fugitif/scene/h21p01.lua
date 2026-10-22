--- Scene: h21p01
local h21p01 = {}
function h21p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Friend Area Cave.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h21p01
