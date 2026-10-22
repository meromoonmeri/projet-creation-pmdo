--[[ Mer Sereine — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve cinématique marine
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local mer_sereine = {}

function mer_sereine.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mer_sereine")
  COMMON.RespawnAllies()
end

function mer_sereine.Enter(map)
  GAME:FadeIn(20)
end

function mer_sereine.Update(map, time)
end

return mer_sereine
