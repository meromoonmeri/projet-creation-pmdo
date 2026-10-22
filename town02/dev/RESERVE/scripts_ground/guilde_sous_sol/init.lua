--[[ Sous-sol de la Guilde — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE extension guilde Metano
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local guilde_sous_sol = {}

function guilde_sous_sol.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_guilde_sous_sol")
  COMMON.RespawnAllies()
end

function guilde_sous_sol.Enter(map)
  GAME:FadeIn(20)
end

function guilde_sous_sol.Update(map, time)
end

return guilde_sous_sol
