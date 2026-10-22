--[[ Étang Carapace — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local etang_carapace = {}

function etang_carapace.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_etang_carapace")
  COMMON.RespawnAllies()
end

function etang_carapace.Enter(map)
  GAME:FadeIn(20)
end

function etang_carapace.Update(map, time)
end

return etang_carapace
