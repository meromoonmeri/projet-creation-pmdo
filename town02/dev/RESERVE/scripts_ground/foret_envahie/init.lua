--[[ Forêt Envahie — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Zarude (revanche alt.)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local foret_envahie = {}

function foret_envahie.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_envahie")
  COMMON.RespawnAllies()
end

function foret_envahie.Enter(map)
  GAME:FadeIn(20)
end

function foret_envahie.Update(map, time)
end

return foret_envahie
