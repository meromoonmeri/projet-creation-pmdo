--[[ Flèche des Reliques — Ruine — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch28 Dialga - variante effondrement
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local fleche_reliques_ruine = {}

function fleche_reliques_ruine.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_fleche_reliques_ruine")
  COMMON.RespawnAllies()
end

function fleche_reliques_ruine.Enter(map)
  GAME:FadeIn(20)
end

function fleche_reliques_ruine.Update(map, time)
end

return fleche_reliques_ruine
