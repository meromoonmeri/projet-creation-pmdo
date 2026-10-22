--[[ Galerie de Cristal IV — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch8 Diancie - salle interne
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local galerie_cristal_4 = {}

function galerie_cristal_4.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_galerie_cristal_4")
  COMMON.RespawnAllies()
end

function galerie_cristal_4.Enter(map)
  GAME:FadeIn(20)
end

function galerie_cristal_4.Update(map, time)
end

return galerie_cristal_4
