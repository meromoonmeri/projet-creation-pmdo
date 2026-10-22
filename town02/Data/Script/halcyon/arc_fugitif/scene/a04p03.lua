--- Scene: a04p03
local a04p03 = {}
function a04p03.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM("Dialga's Fight To the Finish!.ogg", true)
  -- GAME:MoveCamera(HeroX, HeroY, 1)
  SOUND:PlayBGM('Sky Tower.ogg', true)
  -- GAME:MoveCamera(HeroX, HeroY, 1)
  SOUND:PlayBGM('Sky Tower.ogg', true)
  GAME:FadeIn(16)
  GAME:FadeOut(true, 8)
  GAME:FadeIn(8)
  GAME:FadeOut(true, 8)
  GAME:FadeIn(8)
  GAME:FadeOut(true, 45)
  -- GAME:MoveCamera(HeroX, HeroY, 1)
  GAME:CutsceneMode(false)
end
return a04p03
