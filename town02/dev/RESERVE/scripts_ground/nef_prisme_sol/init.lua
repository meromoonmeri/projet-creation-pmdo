--[[ Nef du Prisme — Échouée — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch30 Xerneas - cinématique 2
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local nef_prisme_sol = {}

function nef_prisme_sol.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_nef_prisme_sol")
  COMMON.RespawnAllies()
end

function nef_prisme_sol.Enter(map)
  GAME:FadeIn(20)
end

function nef_prisme_sol.Update(map, time)
end

return nef_prisme_sol
