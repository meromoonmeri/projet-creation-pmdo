--[[ Porche du Sanctuaire de Cristal — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch8 Diancie - entrée alt.
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local sanctuaire_cristal_porche = {}

function sanctuaire_cristal_porche.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_sanctuaire_cristal_porche")
  COMMON.RespawnAllies()
end

function sanctuaire_cristal_porche.Enter(map)
  GAME:FadeIn(20)
end

function sanctuaire_cristal_porche.Update(map, time)
end

return sanctuaire_cristal_porche
