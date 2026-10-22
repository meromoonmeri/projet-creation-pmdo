--[[ Cime du Pic Hérissé — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE arène mini-boss
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local pic_herisse_cime = {}

function pic_herisse_cime.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_pic_herisse_cime")
  COMMON.RespawnAllies()
end

function pic_herisse_cime.Enter(map)
  GAME:FadeIn(20)
end

function pic_herisse_cime.Update(map, time)
end

return pic_herisse_cime
