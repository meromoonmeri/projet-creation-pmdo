--[[ Rite de l'Âme — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE variante intro
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local rite_ame = {}

function rite_ame.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_rite_ame")
  COMMON.RespawnAllies()
end

function rite_ame.Enter(map)
  GAME:FadeIn(20)
end

function rite_ame.Update(map, time)
end

return rite_ame
