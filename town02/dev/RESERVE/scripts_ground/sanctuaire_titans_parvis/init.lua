--[[ Parvis du Sanctuaire des Titans — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch7 Regigigas - ground de cinématique (complète sanctuaire_titans.rsmap)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local sanctuaire_titans_parvis = {}

function sanctuaire_titans_parvis.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_sanctuaire_titans_parvis")
  COMMON.RespawnAllies()
end

function sanctuaire_titans_parvis.Enter(map)
  GAME:FadeIn(20)
end

function sanctuaire_titans_parvis.Update(map, time)
end

return sanctuaire_titans_parvis
