--[[ Forêt de Guérison — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Celebi ch20 (Bois d'Antan)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local foret_guerison = {}

function foret_guerison.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_guerison")
  COMMON.RespawnAllies()
end

function foret_guerison.Enter(map)
  GAME:FadeIn(20)
end

function foret_guerison.Update(map, time)
end

return foret_guerison
