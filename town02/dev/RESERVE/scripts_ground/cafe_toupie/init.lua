--[[ Café de la Toupie — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE annexe café Metano
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local cafe_toupie = {}

function cafe_toupie.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cafe_toupie")
  COMMON.RespawnAllies()
end

function cafe_toupie.Enter(map)
  GAME:FadeIn(20)
end

function cafe_toupie.Update(map, time)
end

return cafe_toupie
