--[[ Galerie de Cristal V — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch8 Diancie - salle interne 2
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local galerie_cristal_5 = {}

function galerie_cristal_5.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_galerie_cristal_5")
  COMMON.RespawnAllies()
end

function galerie_cristal_5.Enter(map)
  GAME:FadeIn(20)
end

function galerie_cristal_5.Update(map, time)
end

return galerie_cristal_5
