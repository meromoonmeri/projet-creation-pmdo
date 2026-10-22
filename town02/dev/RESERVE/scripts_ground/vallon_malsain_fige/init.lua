--[[ Bois Flétri — Figé — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch29 Yveltal - variante temps figé (écho lore Explorers)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local vallon_malsain_fige = {}

function vallon_malsain_fige.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vallon_malsain_fige")
  COMMON.RespawnAllies()
end

function vallon_malsain_fige.Enter(map)
  GAME:FadeIn(20)
end

function vallon_malsain_fige.Update(map, time)
end

return vallon_malsain_fige
