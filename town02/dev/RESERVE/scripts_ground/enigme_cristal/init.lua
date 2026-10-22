--[[ Énigme de Cristal — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch8 Diancie - salle-énigme (event optionnel)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local enigme_cristal = {}

function enigme_cristal.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_enigme_cristal")
  COMMON.RespawnAllies()
end

function enigme_cristal.Enter(map)
  GAME:FadeIn(20)
end

function enigme_cristal.Update(map, time)
end

return enigme_cristal
