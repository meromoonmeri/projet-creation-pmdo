--[[ Entrée du Sanctuaire des Titans — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch7 Regigigas - entrée
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local sanctuaire_titans_entree = {}

function sanctuaire_titans_entree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_sanctuaire_titans_entree")
  COMMON.RespawnAllies()
end

function sanctuaire_titans_entree.Enter(map)
  GAME:FadeIn(20)
end

function sanctuaire_titans_entree.Update(map, time)
end

return sanctuaire_titans_entree
