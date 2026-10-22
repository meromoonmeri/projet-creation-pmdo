--- Scene: s02
local s02 = {}
function s02.Cutscene()
  GAME:CutsceneMode(true)
  -- GROUND:CharSetAction(ent, 7)
  SOUND:PlayBGM('Title.ogg', true)
  SOUND:FadeOutBGM(30)
  SOUND:PlayBGM('Title.ogg', true)
  GAME:FadeIn(60)
  -- GAME:MoveCamera(HeroX, HeroY, 1)
  -- GROUND:CharSetAction(ent, 5)
  -- GROUND:CharSetAction(ent, 7)
  -- GROUND:CharSetAction(ent, 8)
  SOUND:PlayBGM('Title.ogg', true)
  -- GAME:MoveCamera(HeroX, HeroY, 1)
  GAME:CutsceneMode(false)
end
return s02
