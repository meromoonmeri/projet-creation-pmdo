--[[ Mont de la Crevasse — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve montagne
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local mont_crevasse = {}

function mont_crevasse.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mont_crevasse")
  COMMON.RespawnAllies()
end

function mont_crevasse.Enter(map)
  GAME:FadeIn(20)
end

function mont_crevasse.Update(map, time)
end

return mont_crevasse
