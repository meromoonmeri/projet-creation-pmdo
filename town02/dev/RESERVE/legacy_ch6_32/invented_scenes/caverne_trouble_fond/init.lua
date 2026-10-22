--[[ Fond de la Caverne Trouble — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local caverne_trouble_fond = {}

function caverne_trouble_fond.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_caverne_trouble_fond")
  COMMON.RespawnAllies()
end

function caverne_trouble_fond.Enter(map)
  GAME:FadeIn(20)
end

function caverne_trouble_fond.Update(map, time)
end

return caverne_trouble_fond
