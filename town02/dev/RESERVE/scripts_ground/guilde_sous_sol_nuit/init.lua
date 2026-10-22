--[[ Sous-sol de la Guilde — Nuit — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local guilde_sous_sol_nuit = {}

function guilde_sous_sol_nuit.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_guilde_sous_sol_nuit")
  COMMON.RespawnAllies()
end

function guilde_sous_sol_nuit.Enter(map)
  GAME:FadeIn(20)
end

function guilde_sous_sol_nuit.Update(map, time)
end

return guilde_sous_sol_nuit
