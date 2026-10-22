--- Framework Remake: dimensional_scream_01 (Full VFX Injection)
local dimensional_scream_01 = {}

function dimensional_scream_01.Cutscene()
  GAME:CutsceneMode(true)

  -- Début Chorégraphie Spatiale (Exemple)
  GROUND:MoveToPosition(partner, 10, 15, false, 2)
  GROUND:EntTurn(partner, Direction.Left)

  -- Début Injection VFX Extraite
  GAME:FadeOut(true, 60) -- Approximation for filters like Sepia
  GAME:PlayVFX('VFX_TIME_RIPPLE')
  SOUND:PlayBattleSE('SE_DIMENSIONAL_SCREAM')
  -- Fin Injection VFX

  -- Remplacement Narratif New Era
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_DIMENSIONAL_SCREAM_01_001"))

  GAME:CutsceneMode(false)
end

return dimensional_scream_01
