--[[ Écran Titre II — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local ecran_titre_v2 = {}

function ecran_titre_v2.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_ecran_titre_v2")
  COMMON.RespawnAllies()
end

function ecran_titre_v2.Enter(map)
  GAME:FadeIn(20)
end

function ecran_titre_v2.Update(map, time)
end

return ecran_titre_v2
