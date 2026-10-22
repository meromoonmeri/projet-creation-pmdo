--- Scene: d21p01
local d21p01 = {}
function d21p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
  SOUND:FadeOutBGM(60)
  -- GROUND:CharSetAction(ent, 2)
  GAME:FadeOut(true, 5)
  GAME:FadeIn(5)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D21P01_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D21P01_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D21P01_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D21P01_004"))
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  GAME:WaitFrames(20)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 19)
  -- GROUND:CharSetAction(ent, 25)
  -- GROUND:CharSetAction(ent, 33)
  -- GROUND:CharSetAction(ent, 9)
  GAME:CutsceneMode(false)
end
return d21p01
