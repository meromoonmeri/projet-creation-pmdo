--[[ Forêt aux Champignons — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve forêt
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local foret_champignons = {}

function foret_champignons.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_champignons")
  COMMON.RespawnAllies()
end

function foret_champignons.Enter(map)
  GAME:FadeIn(20)
end

function foret_champignons.Update(map, time)
end

return foret_champignons
