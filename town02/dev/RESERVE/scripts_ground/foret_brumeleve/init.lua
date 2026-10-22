--[[ Forêt de Brume-Levée — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve forêt
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local foret_brumeleve = {}

function foret_brumeleve.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_brumeleve")
  COMMON.RespawnAllies()
end

function foret_brumeleve.Enter(map)
  GAME:FadeIn(20)
end

function foret_brumeleve.Update(map, time)
end

return foret_brumeleve
