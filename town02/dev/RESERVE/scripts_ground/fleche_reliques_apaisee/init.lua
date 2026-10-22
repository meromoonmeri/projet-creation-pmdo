--[[ Flèche des Reliques — Apaisée — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch28 Dialga - post-victoire
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local fleche_reliques_apaisee = {}

function fleche_reliques_apaisee.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_fleche_reliques_apaisee")
  COMMON.RespawnAllies()
end

function fleche_reliques_apaisee.Enter(map)
  GAME:FadeIn(20)
end

function fleche_reliques_apaisee.Update(map, time)
end

return fleche_reliques_apaisee
