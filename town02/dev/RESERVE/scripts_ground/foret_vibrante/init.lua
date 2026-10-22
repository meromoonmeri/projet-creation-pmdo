--[[ Forêt Vibrante — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve forêt
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local foret_vibrante = {}

function foret_vibrante.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_vibrante")
  COMMON.RespawnAllies()
end

function foret_vibrante.Enter(map)
  GAME:FadeIn(20)
end

function foret_vibrante.Update(map, time)
end

return foret_vibrante
