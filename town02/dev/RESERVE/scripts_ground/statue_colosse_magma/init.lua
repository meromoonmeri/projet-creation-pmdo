--[[ Statue du Colosse de Magma — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch11 Groudon - antichambre
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local statue_colosse_magma = {}

function statue_colosse_magma.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_statue_colosse_magma")
  COMMON.RespawnAllies()
end

function statue_colosse_magma.Enter(map)
  GAME:FadeIn(20)
end

function statue_colosse_magma.Update(map, time)
end

return statue_colosse_magma
