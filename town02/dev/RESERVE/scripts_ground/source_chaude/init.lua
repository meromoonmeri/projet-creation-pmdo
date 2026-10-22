--[[ Source Chaude — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE lieu de détente (post-ch10)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local source_chaude = {}

function source_chaude.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_source_chaude")
  COMMON.RespawnAllies()
end

function source_chaude.Enter(map)
  GAME:FadeIn(20)
end

function source_chaude.Update(map, time)
end

return source_chaude
