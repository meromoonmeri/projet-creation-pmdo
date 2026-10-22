--[[ Grotte Benthique — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve marine
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local grotte_benthique = {}

function grotte_benthique.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_benthique")
  COMMON.RespawnAllies()
end

function grotte_benthique.Enter(map)
  GAME:FadeIn(20)
end

function grotte_benthique.Update(map, time)
end

return grotte_benthique
