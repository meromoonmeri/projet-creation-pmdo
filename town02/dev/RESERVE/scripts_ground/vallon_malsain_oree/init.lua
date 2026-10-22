--[[ Orée du Bois Flétri — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch29 Yveltal - entrée Vallon Malsain
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local vallon_malsain_oree = {}

function vallon_malsain_oree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vallon_malsain_oree")
  COMMON.RespawnAllies()
end

function vallon_malsain_oree.Enter(map)
  GAME:FadeIn(20)
end

function vallon_malsain_oree.Update(map, time)
end

return vallon_malsain_oree
