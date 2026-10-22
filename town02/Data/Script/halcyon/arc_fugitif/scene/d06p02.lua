--- Scene: d06p02
local d06p02 = {}
function d06p02.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Thunderstruck Pass.ogg', true)
  SOUND:FadeOutBGM(60)
  SOUND:FadeOutBGM(30)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  SOUND:PlayBGM('Thunderstruck Pass.ogg', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D06P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D06P02_002"))
  GAME:CutsceneMode(false)
end
return d06p02
