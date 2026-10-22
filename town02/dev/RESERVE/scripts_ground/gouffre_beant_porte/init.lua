--[[ Porte du Gouffre Béant — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local gouffre_beant_porte = {}

function gouffre_beant_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_gouffre_beant_porte")
  COMMON.RespawnAllies()
end

function gouffre_beant_porte.Enter(map)
  GAME:FadeIn(20)
end

function gouffre_beant_porte.Update(map, time)
end

return gouffre_beant_porte
