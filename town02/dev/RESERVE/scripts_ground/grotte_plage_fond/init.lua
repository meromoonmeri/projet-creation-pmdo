--[[ Fond de la Grotte de la Plage — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE côte
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local grotte_plage_fond = {}

function grotte_plage_fond.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_plage_fond")
  COMMON.RespawnAllies()
end

function grotte_plage_fond.Enter(map)
  GAME:FadeIn(20)
end

function grotte_plage_fond.Update(map, time)
end



function grotte_plage_fond.Koffing_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Héhéhé ![pause=15] Mêlez-vous de ce qui vous regarde !", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function grotte_plage_fond.Zubat_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Héhé ![pause=15] Vous n'avez rien à faire par ici !", "Normal")
  GeneralFunctions.EndConversation(chara)
end
return grotte_plage_fond
