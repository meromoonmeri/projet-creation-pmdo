--[[ Forêt de l'Envolée — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve forêt
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local foret_envolee = {}

function foret_envolee.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_envolee")
  COMMON.RespawnAllies()
end

function foret_envolee.Enter(map)
  GAME:FadeIn(20)
end

function foret_envolee.Update(map, time)
end

return foret_envolee
