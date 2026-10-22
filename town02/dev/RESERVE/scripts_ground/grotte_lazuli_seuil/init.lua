--[[ Seuil de la Grotte Lazuli — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local grotte_lazuli_seuil = {}

function grotte_lazuli_seuil.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_lazuli_seuil")
  COMMON.RespawnAllies()
end

function grotte_lazuli_seuil.Enter(map)
  GAME:FadeIn(20)
end

function grotte_lazuli_seuil.Update(map, time)
end

return grotte_lazuli_seuil
