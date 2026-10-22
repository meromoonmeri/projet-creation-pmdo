--[[ Forêt Secrète — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Marshadow ch26 (Creux des Ombres)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local foret_secrete = {}

function foret_secrete.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_secrete")
  COMMON.RespawnAllies()
end

function foret_secrete.Enter(map)
  GAME:FadeIn(20)
end

function foret_secrete.Update(map, time)
end

return foret_secrete
