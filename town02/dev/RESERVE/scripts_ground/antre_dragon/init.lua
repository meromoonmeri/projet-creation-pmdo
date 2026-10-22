--[[ Antre du Dragon — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Zygarde ch30 (Ciel Suspendu) / dragons
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local antre_dragon = {}

function antre_dragon.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_antre_dragon")
  COMMON.RespawnAllies()
end

function antre_dragon.Enter(map)
  GAME:FadeIn(20)
end

function antre_dragon.Update(map, time)
end

return antre_dragon
