--- Scene: s02
local s02 = {}
function s02.Cutscene()
  GAME:CutsceneMode(true)
  -- GROUND:CharSetAction(ent, 7)
  GAME:PlayBGM('Opening Title', true)
  GAME:FadeOutBGM(30)
  GAME:PlayBGM('Title Screen', true)
  GAME:FadeIn(60)
  -- GAME:MoveCamera(HeroX, HeroY, 1)
  -- GROUND:CharSetAction(ent, 5)
  -- GROUND:CharSetAction(ent, 7)
  -- GROUND:CharSetAction(ent, 8)
  GAME:PlayBGM('Title Screen', true)
  -- GAME:MoveCamera(HeroX, HeroY, 1)
  GAME:CutsceneMode(false)
end
return s02
