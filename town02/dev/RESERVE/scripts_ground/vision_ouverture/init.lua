--[[ Vision d'Ouverture — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE cinématique intro alt.
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local vision_ouverture = {}

function vision_ouverture.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vision_ouverture")
  COMMON.RespawnAllies()
end

function vision_ouverture.Enter(map)
  GAME:FadeIn(20)
end

function vision_ouverture.Update(map, time)
end

return vision_ouverture
