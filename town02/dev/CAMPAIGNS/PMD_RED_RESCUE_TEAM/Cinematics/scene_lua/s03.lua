--- Scene: s03
local s03 = {}
function s03.Cutscene()
  GAME:CutsceneMode(true)
  GAME:PlayBGM('Intro', true)
  GAME:FadeOut(true, 60)
  -- GAME:MoveCamera(HeroX, HeroY, 1)
  -- GROUND:CharSetAction(ent, 16)
  -- GROUND:CharSetAction(ent, 17)
  -- GROUND:CharSetAction(ent, 18)
  -- GROUND:CharSetAction(ent, 19)
  -- GROUND:CharSetAction(ent, 20)
  -- GROUND:CharSetAction(ent, 21)
  -- GROUND:CharSetAction(ent, 21)
  -- GROUND:CharSetAction(ent, 8)
  GAME:CutsceneMode(false)
end
return s03
