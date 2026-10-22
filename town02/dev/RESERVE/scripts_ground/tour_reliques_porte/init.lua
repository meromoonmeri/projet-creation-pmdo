--[[ Porte de la Tour des Reliques — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch28 Dialga - entrée Tour des Reliques
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local tour_reliques_porte = {}

function tour_reliques_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_tour_reliques_porte")
  COMMON.RespawnAllies()
end

function tour_reliques_porte.Enter(map)
  GAME:FadeIn(20)
end

function tour_reliques_porte.Update(map, time)
end

return tour_reliques_porte
