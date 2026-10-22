--- Scene: d14p01
local d14p01 = {}
function d14p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Growing Anxiety.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d14p01
