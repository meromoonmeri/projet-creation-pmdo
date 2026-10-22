--[[ Pied du Pic Hérissé — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE entrée montagne
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local pic_herisse_pied = {}

function pic_herisse_pied.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_pic_herisse_pied")
  COMMON.RespawnAllies()
end

function pic_herisse_pied.Enter(map)
  GAME:FadeIn(20)
end

function pic_herisse_pied.Update(map, time)
end

return pic_herisse_pied
