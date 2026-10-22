--[[ Centrale d'Énergie — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Regieleki (futur) / Genesect alt.
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local centrale_energie = {}

function centrale_energie.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_centrale_energie")
  COMMON.RespawnAllies()
end

function centrale_energie.Enter(map)
  GAME:FadeIn(20)
end

function centrale_energie.Update(map, time)
end

return centrale_energie
