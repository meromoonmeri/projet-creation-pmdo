--- Scene: h27p01
local h27p01 = {}
function h27p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Flyaway Cliffs.ogg', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return h27p01
