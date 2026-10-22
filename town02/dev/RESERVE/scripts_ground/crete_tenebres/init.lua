--[[ Crête des Ténèbres — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Darkrai ch23 (Cour du Clair de Lune)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local crete_tenebres = {}

function crete_tenebres.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_crete_tenebres")
  COMMON.RespawnAllies()
end

function crete_tenebres.Enter(map)
  GAME:FadeIn(20)
end

function crete_tenebres.Update(map, time)
end

return crete_tenebres
